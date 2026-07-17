// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.
// Modern transport behavior referenced from opentibiabr/canary (GPL-2.0), transport_codec.cpp / protocol.cpp.

#include "otpch.h"

#include "protocol.h"
#include "outputmessage.h"
#include "rsa.h"
#include "xtea.h"

extern RSA g_RSA;

namespace {

using namespace BlackTek::Network;

// Sequence numbers wrap below the high bit; the high bit is the outbound
// compression flag, so it can never be allowed to mean "very large sequence".
constexpr uint32_t SEQUENCE_LIMIT = 0x7FFFFFFF;
constexpr uint32_t COMPRESSION_FLAG = 1U << 31;

// Modern clients only benefit from deflate on bigger payloads; below this the
// zlib overhead wins. Same threshold canary uses.
constexpr size_t COMPRESSION_MIN_SIZE = 128;

void XTEA_encrypt(OutputMessage& msg, const xtea::round_keys& key)
{
	// The message must be a multiple of 8
	size_t paddingBytes = msg.getLength() % 8u;
	if (paddingBytes != 0) {
		msg.addPaddingBytes(8 - paddingBytes);
	}

	uint8_t* buffer = msg.getOutputBuffer();
	xtea::encrypt(buffer, msg.getLength(), key);
}

bool XTEA_decrypt(NetworkMessage& msg, const xtea::round_keys& key, TransportGeneration generation)
{
	if (((msg.getLength() - 6) & 7) != 0) {
		return false;
	}

	uint8_t* buffer = msg.getBuffer() + msg.getBufferPosition();
	xtea::decrypt(buffer, msg.getLength() - 6, key);

	if (generation == TransportGeneration::Modern)
	{
		// Modern payload leads with how many padding bytes trail the packets,
		// instead of the legacy inner length up front.
		uint16_t decryptedLength = msg.getLength() - 6;
		uint8_t paddingSize = msg.getByte();
		if (paddingSize >= decryptedLength)
		{
			return false;
		}

		msg.setLength(decryptedLength - paddingSize);
		return true;
	}

	uint16_t innerLength = msg.get<uint16_t>();
	if (innerLength + 8 > msg.getLength()) {
		return false;
	}

	msg.setLength(innerLength);
	return true;
}

}

void Protocol::onSendMessage(const OutputMessage_ptr& msg) const
{
	if (rawMessages) {
		return;
	}

	if (not usesModernFraming())
	{
		msg->writeMessageLength();

		if (encryptionEnabled) {
			XTEA_encrypt(*msg, key);
			msg->addCryptoHeader(checksumEnabled);
		}
		return;
	}

	if (not encryptionEnabled)
	{
		// Pre-login frames (challenge, early disconnect messages) still ride
		// the modern framing: adler32 checksum, body padded to whole XTEA
		// blocks so the block-count length header stays exact. Trailing zero
		// bytes are dead air the client never reads past its packet.
		while (msg->getLength() % 8 != 0)
		{
			msg->addByte(0);
		}
		msg->writeChecksumHeader(adlerChecksum(msg->getOutputBuffer(), msg->getLength()));
		msg->writeBlockCountLength();
		return;
	}

	uint32_t sequence = ++serverSequence;
	if (serverSequence >= SEQUENCE_LIMIT)
	{
		serverSequence = 0;
	}

	if (checksumMode == BlackTek::Network::ChecksumMode::Sequence
		and msg->getLength() >= COMPRESSION_MIN_SIZE
		and compress(*msg))
	{
		sequence |= COMPRESSION_FLAG;
	}

	msg->writePaddingAmount();
	XTEA_encrypt(*msg, key);
	msg->writeChecksumHeader(sequence);
	msg->writeBlockCountLength();
}

void Protocol::onRecvMessage(NetworkMessage& msg)
{
	if (usesModernFraming())
	{
		// Connection leaves modern frames untouched; the four bytes under
		// the cursor are the client's sequence number.
		uint32_t sequence = msg.get<uint32_t>();
		if (checksumMode == BlackTek::Network::ChecksumMode::Sequence)
		{
			uint32_t expected = ++clientSequence;
			if (clientSequence >= SEQUENCE_LIMIT)
			{
				clientSequence = 0;
			}

			if (sequence == 0 or sequence != expected)
			{
				disconnect();
				return;
			}
		}
	}

	if (encryptionEnabled and not XTEA_decrypt(msg, key, transportGeneration)) {
		return;
	}

	parsePacket(msg);
}

OutputMessage_ptr Protocol::getOutputBuffer(int32_t size)
{
	//dispatcher thread
	if (!outputBuffer) {
		outputBuffer = OutputMessagePool::getOutputMessage();
	} else if ((outputBuffer->getLength() + size) > NetworkMessage::MAX_PROTOCOL_BODY_LENGTH) {
		send(std::move(outputBuffer));
		outputBuffer = OutputMessagePool::getOutputMessage();
	}
	return outputBuffer;
}

bool Protocol::RSA_decrypt(NetworkMessage& msg)
{
	if ((msg.getLength() - msg.getBufferPosition()) < 128) {
		return false;
	}

	g_RSA.decrypt(reinterpret_cast<char*>(msg.getBuffer()) + msg.getBufferPosition()); //does not break strict aliasing
	return msg.getByte() == 0;
}

bool Protocol::compress(OutputMessage& msg)
{
	// One deflate stream per network thread; deflateReset between messages
	// keeps the dictionary from leaking across sessions.
	struct Deflater
	{
		z_stream stream {};
		std::array<uint8_t, NETWORKMESSAGE_MAXSIZE> buffer {};
		bool usable = false;

		Deflater()
		{
			// Raw deflate (negative window bits): modern clients expect no
			// zlib header on the wire.
			usable = deflateInit2(&stream, 6, Z_DEFLATED, -15, 9, Z_DEFAULT_STRATEGY) == Z_OK;
		}

		~Deflater()
		{
			if (usable)
			{
				deflateEnd(&stream);
			}
		}
	};

	static thread_local Deflater deflater;
	if (not deflater.usable)
	{
		return false;
	}

	deflater.stream.next_in = msg.getOutputBuffer();
	deflater.stream.avail_in = msg.getLength();
	deflater.stream.next_out = deflater.buffer.data();
	deflater.stream.avail_out = deflater.buffer.size();

	const int result = deflate(&deflater.stream, Z_FINISH);
	const auto compressedSize = deflater.stream.total_out;
	deflateReset(&deflater.stream);

	if ((result != Z_OK and result != Z_STREAM_END) or compressedSize == 0 or compressedSize >= msg.getLength())
	{
		return false;
	}

	msg.rewriteWith(deflater.buffer.data(), compressedSize);
	return true;
}

uint32_t Protocol::getIP() const
{
	if (auto connection = getConnection()) {
		return connection->getIP();
	}

	return 0;
}
