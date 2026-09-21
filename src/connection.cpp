// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "configmanager.h"
#include "connection.h"
#include "console.h"
#include "outputmessage.h"
#include "protocol.h"
#include "scheduler.h"
#include "server.h"

extern ConfigManager g_config;

Connection_ptr ConnectionManager::createConnection(boost::asio::io_context& io_context, ConstServicePort_ptr servicePort)
{
	auto connection = std::make_shared<Connection>(io_context, servicePort);
	connections.insert(connection);
	return connection;
}

void ConnectionManager::releaseConnection(const Connection_ptr& connection)
{
	connections.erase(connection);
}

void ConnectionManager::closeAll()
{
	connections.for_each([](const Connection_ptr& connection)
	{
		try
		{
			boost::system::error_code error;
			connection->socket.shutdown(boost::asio::ip::tcp::socket::shutdown_both, error);
			connection->socket.close(error);
		}
		catch (boost::system::system_error&) {}
	});
	connections.clear();
}

// Connection

void Connection::close(bool force)
{
	// dispatch() executes inline when already on-strand, otherwise posts.
	// This eliminates recursive locking while remaining safe from any thread.
	boost::asio::dispatch(strand, [this, self = shared_from_this(), force]()
	{
		if (closed)
		{
			return;
		}
		closed = true;

		ConnectionManager::getInstance().releaseConnection(self);

		if (protocol)
		{
			g_dispatcher.addTask(createTask([protocol = protocol]() { protocol->release(); }));
		}

		if (messageQueue.empty() or force)
		{
			closeSocket();
		}
		// else closeSocket() called from onWriteOperation once queue drains
	});
}

void Connection::closeSocket()
{
	if (socket.is_open())
	{
		try
		{
			readTimer.cancel();
			writeTimer.cancel();
			boost::system::error_code error;
			socket.shutdown(boost::asio::ip::tcp::socket::shutdown_both, error);
			socket.close(error);
		}
		catch (boost::system::system_error& e)
		{
			std::cout << "[Network error - Connection::closeSocket] " << e.what() << std::endl;
		}
	}
}

Connection::~Connection()
{
	closeSocket();
}

// Arming again over a live wait cancels the pending one; handleTimeout discards
// that as operation_aborted, so a chain may re-arm freely at its own boundaries.
void Connection::ArmReadDeadline()
{
	readTimer.expires_after(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
	readTimer.async_wait(
		boost::asio::bind_executor(strand,
			[thisPtr = std::weak_ptr<Connection>(shared_from_this())](const boost::system::error_code& error)
			{
				Connection::handleTimeout(thisPtr, error);
			}));
}

void Connection::accept(Protocol_ptr protocol)
{
	this->protocol = protocol;
	g_dispatcher.addTask(createTask([=]() { protocol->onConnect(); }));

	// A login-protocol client opens with a world-name line whose first byte is
	// usually the terminator itself, so there is nothing to sniff. Read the line
	// up front, one byte at a time, and let readWorldLineByte start the header
	// read once the line ends. parseHeader's sniff is deliberately left alone for
	// game connections: there the line is optional in practice, and that is the
	// framing path validated against a real client.
	if (this->protocol->requiresWorldLine())
	{
		modern_world_name_consumed = true;
		// One deadline for the entire line, armed before the per-byte loop starts.
		ArmReadDeadline();
		readWorldLineByte();
		return;
	}

	accept();
}

void Connection::accept()
{
	try
	{
		msg = NetworkMessagePool::getNetworkMessage();

		readTimer.expires_after(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait(
			boost::asio::bind_executor(strand,
				[thisPtr = std::weak_ptr<Connection>(shared_from_this())](const boost::system::error_code& error)
				{
					Connection::handleTimeout(thisPtr, error);
				}));

		boost::asio::async_read(socket,
			boost::asio::buffer(msg->getBuffer(), NetworkMessage::HEADER_LENGTH),
			boost::asio::bind_executor(strand,
				[thisPtr = shared_from_this()](const boost::system::error_code& error, auto /*bytes_transferred*/)
				{
					thisPtr->parseHeader(error);
				}));
	}
	catch (boost::system::system_error& e)
	{
		std::cout << "[Network error - Connection::accept] " << e.what() << std::endl;
		close(FORCE_CLOSE);
	}
}

void Connection::parseHeader(const boost::system::error_code& error)
{
	readTimer.cancel();

	if (error)
	{
		close(FORCE_CLOSE);
		return;
	}
	else if (closed)
	{
		return;
	}

	uint32_t timePassed = std::max<uint32_t>(1, (time(nullptr) - timeConnected) + 1);

	if ((++packetsSent / timePassed) > static_cast<uint32_t>(g_config.GetNumber(ConfigManager::MAX_PACKETS_PER_SECOND)))
	{
		std::cout << convertIPToString(getIP()) << " disconnected for exceeding packet per second limit." << std::endl;
		close();
		return;
	}

	if (timePassed > 2)
	{
		timeConnected = time(nullptr);
		packetsSent = 0;
	}

	if (protocol and protocol->usesModernFraming() and !modern_world_name_consumed)
	{
		modern_world_name_consumed = true;
		const uint8_t b0 = msg->getBuffer()[0];
		const uint8_t b1 = msg->getBuffer()[1];
		const bool printable0 = b0 >= 0x20 and b0 < 0x7F;
		if (printable0 and (b1 == '\n' or (b1 >= 0x20 and b1 < 0x7F)))
		{
			modern_world_line.assign(1, static_cast<char>(b0));
			if (b1 == '\n')
			{
				accept();
				return;
			}
			modern_world_line.push_back(static_cast<char>(b1));
			modern_line_skipped = 2;
			// parseHeader cancelled the read timer at its head, so the rest of the
			// line has no deadline until this arms one.
			ArmReadDeadline();
			readWorldLineByte();
			return;
		}
		// no world-name line (e.g. harness clients) - fall through to framing
	}

	uint32_t size = msg->getLengthHeader();
	if (protocol and protocol->usesModernFraming())
	{
		// Modern clients send the outer length as a count of 8-byte XTEA
		// blocks; the 4 sequence/checksum bytes ride on top of that. Widened
		// to 32 bits so a hostile block count can't wrap the bounds check.
		size = size * 8 + NetworkMessage::CHECKSUM_LENGTH;
	}

	if (size == 0 or size >= NETWORKMESSAGE_MAXSIZE - 16)
	{
		close(FORCE_CLOSE);
		return;
	}

	try
	{
		readTimer.expires_after(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait(
			boost::asio::bind_executor(strand,
				[thisPtr = std::weak_ptr<Connection>(shared_from_this())](const boost::system::error_code& error)
				{
					Connection::handleTimeout(thisPtr, error);
				}));

		// The frame starts at buffer offset 0, so the whole frame - outer length
		// header included - is what is readable until a decrypt narrows it.
		msg->SetReadableRange(0, static_cast<NetworkMessage::MsgSize_t>(size + NetworkMessage::HEADER_LENGTH));
		boost::asio::async_read(socket,
			boost::asio::buffer(msg->getBodyBuffer(), size),
			boost::asio::bind_executor(strand,
				[thisPtr = shared_from_this()](const boost::system::error_code& error, auto /*bytes_transferred*/)
				{
					thisPtr->parsePacket(error);
				}));
	}
	catch (boost::system::system_error& e)
	{
		std::cout << "[Network error - Connection::parseHeader] " << e.what() << std::endl;
		close(FORCE_CLOSE);
	}
}

void Connection::readWorldLineByte()
{
	if (++modern_line_skipped > 32)
	{
		close(FORCE_CLOSE);
		return;
	}

	try
	{
		// No arm and no cancel per byte: the deadline the caller armed covers the
		// whole line, and every way out of this loop cancels it already. '\n' goes
		// to accept(), whose own expires_after replaces the wait; error, closed and
		// the 32-byte cap go to close(FORCE_CLOSE) -> closeSocket(), which cancels
		// it. handleTimeout drops the resulting operation_aborted either way.
		boost::asio::async_read(socket,
			boost::asio::buffer(&modern_line_byte, 1),
			boost::asio::bind_executor(strand,
				[thisPtr = shared_from_this()](const boost::system::error_code& error, auto /*bytes_transferred*/)
				{
					if (error or thisPtr->closed)
					{
						thisPtr->close(FORCE_CLOSE);
						return;
					}

					if (thisPtr->modern_line_byte == '\n')
					{
						BlackTek::Console::Net::Trace("Connection::readWorldLineByte: world-name preamble '{:s}'", thisPtr->modern_world_line);
						thisPtr->accept();
					}
					else
					{
						thisPtr->modern_world_line.push_back(static_cast<char>(thisPtr->modern_line_byte));
						thisPtr->readWorldLineByte();
					}
				}));
	}
	catch (boost::system::system_error& e)
	{
		BlackTek::Console::Net::Error("Connection::readWorldLineByte: {:s}", e.what());
		close(FORCE_CLOSE);
	}
}

void Connection::parsePacket(const boost::system::error_code& error)
{
	readTimer.cancel();

	if (error)
	{
		close(FORCE_CLOSE);
		return;
	}
	else if (closed)
	{
		return;
	}

	if (protocol and protocol->usesModernFraming())
	{
		// Modern frames carry a sequence number where legacy carries adler32;
		// Protocol::onRecvMessage verifies it. Nothing to pre-check here.
		if (not receivedFirst)
		{
			receivedFirst = true;

			// First frame layout: sequence u32, padding count u8, then the
			// 0x0A ClientPendingGame byte that legacy also skips. This is the one
			// modern frame nothing trims - onRecvMessage only trims what it
			// decrypts, and the first frame is plaintext - so trim it here.
			// Without this, anything locating a field from the END of the message
			// reads into the client's trailing padding.
			constexpr uint16_t firstFrameOverhead = NetworkMessage::HEADER_LENGTH + NetworkMessage::CHECKSUM_LENGTH + 2;

			// parseHeader accepts a blockCount of 0, which leaves the padding-count
			// and opcode bytes unread from the socket and indeterminate in buffer.
			if (msg->getLength() < firstFrameOverhead)
			{
				close(FORCE_CLOSE);
				return;
			}

			msg->skipBytes(NetworkMessage::CHECKSUM_LENGTH);

			const uint8_t paddingAmount = msg->getByte();
			const uint16_t framedLength = msg->getLength();

			// The readable length is a uint16_t; an unguarded subtraction would
			// wrap and hand canRead a bound far past the payload.
			if (framedLength < firstFrameOverhead + paddingAmount)
			{
				close(FORCE_CLOSE);
				return;
			}

			// Still counted from buffer offset 0 - the first frame is plaintext,
			// so nothing moved it - but trimmed of the client's trailing padding.
			msg->SetReadableRange(0, static_cast<NetworkMessage::MsgSize_t>(framedLength - paddingAmount));
			msg->skipBytes(1); // protocol identifier / first opcode
			protocol->onRecvFirstMessage(*msg);
		}
		else
		{
			protocol->onRecvMessage(*msg);
		}
	}
	else
	{
		uint32_t checksum;
		int32_t len = msg->getLength() - msg->getBufferPosition() - NetworkMessage::CHECKSUM_LENGTH;

		if (len > 0)
		{
			checksum = adlerChecksum(msg->getBuffer() + msg->getBufferPosition() + NetworkMessage::CHECKSUM_LENGTH, len);
		}
		else
		{
			checksum = 0;
		}

		uint32_t recvChecksum = msg->get<uint32_t>();
		if (recvChecksum != checksum)
		{
			msg->skipBytes(-NetworkMessage::CHECKSUM_LENGTH);
		}

		if (not receivedFirst)
		{
			receivedFirst = true;

			if (not protocol)
			{
				protocol = service_port->make_protocol(recvChecksum == checksum, *msg, shared_from_this());
				if (not protocol)
				{
					close(FORCE_CLOSE);
					return;
				}
			}
			else
			{
				msg->skipBytes(1); // Skip protocol ID
			}

			protocol->onRecvFirstMessage(*msg);
		}
		else
		{
			protocol->onRecvMessage(*msg); // Send the packet to the current protocol
		}
	}

	try
	{
		readTimer.expires_after(std::chrono::seconds(CONNECTION_READ_TIMEOUT));
		readTimer.async_wait(
			boost::asio::bind_executor(strand,
				[thisPtr = std::weak_ptr<Connection>(shared_from_this())](const boost::system::error_code& error)
				{
					Connection::handleTimeout(thisPtr, error);
				}));

		// Release the consumed buffer and acquire a fresh one for the next packet
		msg = NetworkMessagePool::getNetworkMessage();

		// Wait for the next packet
		boost::asio::async_read(socket,
			boost::asio::buffer(msg->getBuffer(), NetworkMessage::HEADER_LENGTH),
			boost::asio::bind_executor(strand,
				[thisPtr = shared_from_this()](const boost::system::error_code& error, auto /*bytes_transferred*/)
				{
					thisPtr->parseHeader(error);
				}));
	}
	catch (boost::system::system_error& e)
	{
		std::cout << "[Network error - Connection::parsePacket] " << e.what() << std::endl;
		close(FORCE_CLOSE);
	}
}

void Connection::send(const OutputMessage_ptr& msg)
{
	boost::asio::dispatch(strand, [this, self = shared_from_this(), msg]()
	{
		if (closed)
		{
			return;
		}

		bool noPendingWrite = messageQueue.empty();
		messageQueue.emplace_back(msg);
		if (noPendingWrite)
		{
			internalSend(msg);
		}
	});
}

void Connection::internalSend(const OutputMessage_ptr& msg)
{
	protocol->onSendMessage(msg);
	try
	{
		writeTimer.expires_after(std::chrono::seconds(CONNECTION_WRITE_TIMEOUT));
		writeTimer.async_wait(
			boost::asio::bind_executor(strand,
				[thisPtr = std::weak_ptr<Connection>(shared_from_this())](const boost::system::error_code& error)
				{
					Connection::handleTimeout(thisPtr, error);
				}));

		boost::asio::async_write(socket,
			boost::asio::buffer(msg->getOutputBuffer(), msg->getLength()),
			boost::asio::bind_executor(strand,
				[thisPtr = shared_from_this()](const boost::system::error_code& error, auto /*bytes_transferred*/)
				{
					thisPtr->onWriteOperation(error);
				}));
	}
	catch (boost::system::system_error& e)
	{
		std::cout << "[Network error - Connection::internalSend] " << e.what() << std::endl;
		close(FORCE_CLOSE);
	}
}

uint32_t Connection::getIP()
{
	uint32_t cached = cachedIP.load(std::memory_order_relaxed);
	if (cached != 0)
	{
		return cached;
	}

	boost::system::error_code error;
	const boost::asio::ip::tcp::endpoint endpoint = socket.remote_endpoint(error);
	if (error)
	{
		return 0;
	}

	const uint32_t ip = htonl(endpoint.address().to_v4().to_uint());
	cachedIP.store(ip, std::memory_order_relaxed);
	return ip;
}

void Connection::onWriteOperation(const boost::system::error_code& error)
{
	writeTimer.cancel();
	OutputMessage_ptr msg = messageQueue.front();
	messageQueue.pop_front();

	msg->reset();

	if (error)
	{
		messageQueue.clear();
		close(FORCE_CLOSE);
		return;
	}

	if (not messageQueue.empty())
	{
		internalSend(messageQueue.front());
	}
	else if (closed)
	{
		closeSocket();
	}
}

void Connection::handleTimeout(ConnectionWeak_ptr connectionWeak, const boost::system::error_code& error)
{
	if (error == boost::asio::error::operation_aborted)
	{
		return;
	}

	if (auto connection = connectionWeak.lock())
	{
		connection->close(FORCE_CLOSE);
	}
}
