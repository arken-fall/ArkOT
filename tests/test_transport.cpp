// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "networkmessage.h"
#include "tools.h"
#include "xtea.h"

#include "testregistry.h"

using namespace BlackTek::Tests;

// Golden vectors below were generated independently in Python (harness/) so a
// bug in the C++ implementation can't silently bless itself.

BT_TEST(adlerChecksumMatchesReference)
{
	const uint8_t sample[] = { 'B', 'l', 'a', 'c', 'k', 'T', 'e', 'k' };
	BT_CHECK(adlerChecksum(sample, sizeof(sample)) == 0x0D1E0302);

	const uint8_t zeros[8] = {};
	BT_CHECK(adlerChecksum(zeros, sizeof(zeros)) == 0x00080001);
}

BT_TEST(xteaEncryptMatchesReference)
{
	const xtea::key key = { 0x11111111, 0x22222222, 0x33333333, 0x44444444 };
	const auto roundKeys = xtea::expand_key(key);

	uint8_t data[16];
	for (size_t i = 0; i < sizeof(data); ++i)
	{
		data[i] = static_cast<uint8_t>(i);
	}

	xtea::encrypt(data, sizeof(data), roundKeys);
	expectBytes(data, sizeof(data), "AB 3C 6B B6 98 82 E5 5D BB 48 82 97 0A 6E 7B 66", "xtea ciphertext");

	xtea::decrypt(data, sizeof(data), roundKeys);
	expectBytes(data, sizeof(data), "00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F", "xtea roundtrip");
}

BT_TEST(networkMessagePrimitivesLayout)
{
	NetworkMessage msg;
	msg.addByte(0xA0);
	msg.add<uint16_t>(150);
	msg.add<uint32_t>(0xDEADBEEF);
	msg.addString("hi");

	expectBytes(msg.getBuffer() + NetworkMessage::INITIAL_BUFFER_POSITION, msg.getLength(),
		"A0 96 00 EF BE AD DE 02 00 68 69", "wire primitives");
}
