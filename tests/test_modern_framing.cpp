// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "outputmessage.h"
#include "protocol.h"

#include "testregistry.h"

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
				// length counts payload past INITIAL_BUFFER_POSITION; the modern
				// decrypt leaves the cursor one byte earlier (see protocol.cpp)
				return msg.getLength() + NetworkMessage::INITIAL_BUFFER_POSITION - msg.getBufferPosition();
			}
	};

	std::pair<const uint8_t*, size_t> wireBytes(const OutputMessage_ptr& msg)
	{
		// After onSendMessage all headers sit directly in front of the body;
		// getOutputBuffer() points at the first header byte.
		return { msg->getOutputBuffer(), msg->getLength() };
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
	inbound.setLength(static_cast<NetworkMessage::MsgSize_t>(length));
	inbound.getBodyBuffer(); // sets the cursor to position 2

	receiver.onRecvMessage(inbound);

	BT_CHECK(receiver.received.size() >= payload.size());
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
