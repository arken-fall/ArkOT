// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef BT_TESTS_TESTREGISTRY_H
#define BT_TESTS_TESTREGISTRY_H

#include <cstdint>
#include <functional>
#include <string>
#include <string_view>
#include <vector>

namespace BlackTek::Tests
{
	struct TestCase
	{
		std::string name;
		std::function<void()> body;
	};

	struct TestFailure
	{
		std::string message;
	};

	[[nodiscard]] std::vector<TestCase>& registry();

	struct Registrar
	{
		Registrar(std::string_view name, std::function<void()> body);
	};

	// Compares against an even-length hex string like "A0 96 00" (spaces optional).
	// Throws TestFailure with a byte-level report on mismatch.
	void expectBytes(const uint8_t* actual, size_t actualLength, std::string_view expectedHex, std::string_view what);
}

#define BT_TEST(testName) \
	static void testName(); \
	static const BlackTek::Tests::Registrar testName##_registrar(#testName, &testName); \
	static void testName()

#define BT_CHECK(condition) \
	do \
	{ \
		if (not (condition)) \
		{ \
			throw BlackTek::Tests::TestFailure{ std::string("check failed: ") + #condition }; \
		} \
	} while (false)

#endif
