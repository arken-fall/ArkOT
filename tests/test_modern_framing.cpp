// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "outputmessage.h"
#include "protocol.h"

#include "testregistry.h"

#include <functional>
#include <span>
#include <vector>
#include <zlib.h>

using namespace BlackTek::Tests;
using namespace BlackTek::Network;

namespace
{
	// Bare protocol with the knobs exposed, so the framing added by
	// onSendMessage / consumed by onRecvMessage can be tested without a
	// socket or a player behind it.
	class WireProbe final : public Protocol
	{
		public:
			WireProbe(TransportGeneration generation, bool encrypted) : Protocol(nullptr)
			{
				setTransportGeneration(generation);
				if (encrypted)
				{
					setChecksumMode(ChecksumMode::Sequence);
					enableXTEAEncryption();
					setXTEAKey({ 0x11111111, 0x22222222, 0x33333333, 0x44444444 });
				}
			}

			void onRecvFirstMessage(NetworkMessage&) override {}

			void parsePacket(NetworkMessage& msg) override
			{
				received.assign(msg.getBuffer() + msg.getBufferPosition(), msg.getBuffer() + msg.getBufferPosition() + remainingLength(msg));
			}

			std::vector<uint8_t> received;

		private:
			static size_t remainingLength(NetworkMessage& msg)
			{
				// Whatever the framing did, the readable end is the one place
				// that knows where this message's payload actually stops.
				return msg.GetReadableEnd() - msg.getBufferPosition();
			}
	};

	// Same wiring as WireProbe, but it hands the decrypted message to the test
	// instead of copying it out, so assertions can run at the exact point a
	// real parser reads from: cursor on the first payload byte.
	class InspectProbe final : public Protocol
	{
		public:
			using Inspector = std::function<void(NetworkMessage&)>;

			InspectProbe(TransportGeneration generation, Inspector inspector) : Protocol(nullptr), inspect(std::move(inspector))
			{
				setTransportGeneration(generation);
				setChecksumMode(ChecksumMode::Sequence);
				enableXTEAEncryption();
				setXTEAKey({ 0x11111111, 0x22222222, 0x33333333, 0x44444444 });
			}

			void onRecvFirstMessage(NetworkMessage&) override {}

			void parsePacket(NetworkMessage& msg) override
			{
				parsed = true;
				inspect(msg);
			}

			// Guards against a vacuous pass: a rejected frame returns from
			// onRecvMessage without ever reaching parsePacket.
			bool parsed = false;

		private:
			Inspector inspect;
	};

	std::pair<const uint8_t*, size_t> wireBytes(const OutputMessage_ptr& msg)
	{
		// After onSendMessage all headers sit directly in front of the body;
		// getOutputBuffer() points at the first header byte.
		return { msg->getOutputBuffer(), msg->getLength() };
	}

	// Frames payload with a fresh sender, then feeds it back in exactly as
	// Connection does: whole frame at buffer offset 0, readable range set by
	// parseHeader, cursor just past the outer length header. Legacy frames also
	// have their adler32 header consumed here, because Connection::parsePacket
	// consumes it before the protocol ever sees the message.
	void ReplayThroughWire(TransportGeneration generation, std::span<const uint8_t> payload, Protocol& receiver)
	{
		WireProbe sender(generation, true);

		auto msg = OutputMessagePool::getOutputMessage();
		for (uint8_t value : payload)
		{
			msg->addByte(value);
		}

		sender.onSendMessage(msg);

		auto [data, length] = wireBytes(msg);
		NetworkMessage inbound;
		memcpy(inbound.getBuffer(), data, length);
		inbound.SetReadableRange(0, static_cast<NetworkMessage::MsgSize_t>(length));
		inbound.getBodyBuffer(); // sets the cursor to position 2

		if (generation == TransportGeneration::Legacy)
		{
			[[maybe_unused]] const uint32_t checksum = inbound.get<uint32_t>();
		}

		receiver.onRecvMessage(inbound);
	}
}

BT_TEST(modernChallengeFrameMatchesCanaryLayout)
{
	WireProbe probe(TransportGeneration::Modern, false);

	auto msg = OutputMessagePool::getOutputMessage();
	msg->addByte(0x01);
	msg->add(ServerCode::Challenge);
	msg->add<uint32_t>(0x11223344);
	msg->addByte(0x55);
	msg->addByte(0x71);

	probe.onSendMessage(msg);

	auto [data, length] = wireBytes(msg);
	// [u16 block count][u32 adler32][01 1F ts rand 71]
	expectBytes(data, length, "01 00 91 01 56 05 01 1F 44 33 22 11 55 71", "modern challenge frame");
}

BT_TEST(modernEncryptedFrameGolden)
{
	WireProbe probe(TransportGeneration::Modern, true);

	auto msg = OutputMessagePool::getOutputMessage();
	msg->addByte(0xA0);
	msg->add<uint16_t>(150);
	msg->add<uint16_t>(150);
	msg->add<uint16_t>(100);

	probe.onSendMessage(msg);

	auto [data, length] = wireBytes(msg);
	// 7-byte body -> padding count 0, one XTEA block, sequence 1.
	// Cipher bytes generated independently in Python (harness/packet_diff.py).
	expectBytes(data, length, "01 00 01 00 00 00 F6 2D 31 A1 E6 43 5B D9", "modern encrypted frame");
}

BT_TEST(modernFrameRoundtripsThroughOnRecvMessage)
{
	WireProbe sender(TransportGeneration::Modern, true);
	WireProbe receiver(TransportGeneration::Modern, true);

	auto msg = OutputMessagePool::getOutputMessage();
	msg->addByte(0xB4);
	msg->addByte(0x14);
	msg->addString("hello");

	const std::vector<uint8_t> payload(
		msg->getBuffer() + NetworkMessage::INITIAL_BUFFER_POSITION,
		msg->getBuffer() + NetworkMessage::INITIAL_BUFFER_POSITION + msg->getLength());

	sender.onSendMessage(msg);

	// Re-run the frame through the inbound path exactly as Connection would:
	// whole frame at the start of the buffer, cursor just past the outer
	// length header.
	auto [data, length] = wireBytes(msg);
	NetworkMessage inbound;
	memcpy(inbound.getBuffer(), data, length);
	inbound.SetReadableRange(0, static_cast<NetworkMessage::MsgSize_t>(length));
	inbound.getBodyBuffer(); // sets the cursor to position 2

	receiver.onRecvMessage(inbound);

	BT_CHECK(receiver.received.size() == payload.size());
	BT_CHECK(std::equal(payload.begin(), payload.end(), receiver.received.begin()));
}

BT_TEST(modernLargeFrameCompressesAndFlagsSequence)
{
	WireProbe probe(TransportGeneration::Modern, true);

	auto msg = OutputMessagePool::getOutputMessage();
	msg->addByte(0x64);
	for (int i = 0; i < 400; ++i)
	{
		msg->addByte(static_cast<uint8_t>(i % 7));
	}

	probe.onSendMessage(msg);

	auto [data, length] = wireBytes(msg);
	uint32_t sequence;
	memcpy(&sequence, data + 2, sizeof(sequence));
	BT_CHECK((sequence & 0x80000000) != 0);
	BT_CHECK((sequence & 0x7FFFFFFF) == 1);
	// 401 raw bytes of a 7-symbol cycle must deflate well below one third
	BT_CHECK(length < 200);
}

BT_TEST(modernFrameReadableEndStopsAtPayload)
{
	// 3 payload bytes means 4 trailing padding bytes, so anything read past the
	// payload lands in padding that is still inside the frame - a deterministic
	// 0x33, never the caller's data.
	const std::vector<uint8_t> payload{ 0xB4, 0x14, 0x2A };

	InspectProbe receiver(TransportGeneration::Modern,
		[&payload](NetworkMessage& msg)
		{
			for (uint8_t expected : payload)
			{
				BT_CHECK(msg.getByte() == expected);
			}

			BT_CHECK(not msg.isOverrun());
			// One byte past the payload must be refused, not served out of the
			// client's padding.
			BT_CHECK(msg.getByte() == 0 and msg.isOverrun());
		});

	ReplayThroughWire(TransportGeneration::Modern, payload, receiver);
	BT_CHECK(receiver.parsed);
}

BT_TEST(modernAutoWalkPacketEndsAtLastDirection)
{
	constexpr uint8_t numdirs = 4;

	std::vector<uint8_t> payload{ 0x64, numdirs };
	for (uint8_t step = 0; step < numdirs; ++step)
	{
		payload.push_back(static_cast<uint8_t>(1 + step));
	}

	InspectProbe receiver(TransportGeneration::Modern,
		[payloadSize = static_cast<NetworkMessage::MsgSize_t>(payload.size())](NetworkMessage& msg)
		{
			// Where the payload ends according to the bytes this test wrote,
			// measured from the cursor the framing handed the parser.
			const auto payloadEnd = static_cast<NetworkMessage::MsgSize_t>(msg.getBufferPosition() + payloadSize);

			BT_CHECK(msg.getByte() == 0x64);
			const uint8_t dirs = msg.getByte();
			BT_CHECK(dirs == numdirs);

			// The predicate ProtocolGame::parseAutoWalk evaluates: the last
			// direction byte has to land exactly on the end of the payload.
			BT_CHECK(static_cast<NetworkMessage::MsgSize_t>(msg.getBufferPosition() + dirs) == payloadEnd);
			BT_CHECK(msg.GetReadableEnd() == payloadEnd);
			BT_CHECK(not msg.isOverrun());
		});

	ReplayThroughWire(TransportGeneration::Modern, payload, receiver);
	BT_CHECK(receiver.parsed);
}

BT_TEST(legacyFrameReadableEndStopsAtPayload)
{
	const std::vector<uint8_t> payload{ 0xB4, 0x14, 0x2A };

	InspectProbe receiver(TransportGeneration::Legacy,
		[&payload](NetworkMessage& msg)
		{
			BT_CHECK(msg.getLength() == static_cast<NetworkMessage::MsgSize_t>(payload.size()));

			for (uint8_t expected : payload)
			{
				BT_CHECK(msg.getByte() == expected);
			}

			BT_CHECK(not msg.isOverrun());
			BT_CHECK(msg.getByte() == 0 and msg.isOverrun());
		});

	ReplayThroughWire(TransportGeneration::Legacy, payload, receiver);
	BT_CHECK(receiver.parsed);
}
