// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "configmanager.h"
#include "databasetasks.h"
#include "game.h"
#include "monsters.h"
#include "rsa.h"
#include "scheduler.h"

#include "testregistry.h"

#include <fmt/color.h>

// The server binary defines these globals in otserv.cpp. The test binary
// links every other translation unit, so it has to provide the same set.
DatabaseTasks g_databaseTasks;
Dispatcher g_dispatcher;
Dispatcher g_utility_boss;
Scheduler g_scheduler;
Game g_game;
ConfigManager g_config;
Monsters g_monsters;
Vocations g_vocations;
RSA g_RSA;
std::mutex g_loaderLock;
std::condition_variable g_loaderSignal;

namespace BlackTek::Tests
{
	std::vector<TestCase>& registry()
	{
		static std::vector<TestCase> cases;
		return cases;
	}

	Registrar::Registrar(std::string_view name, std::function<void()> body)
	{
		registry().push_back({ std::string(name), std::move(body) });
	}

	void expectBytes(const uint8_t* actual, size_t actualLength, std::string_view expectedHex, std::string_view what)
	{
		std::vector<uint8_t> expected;
		uint8_t pending = 0;
		bool haveNibble = false;
		for (char symbol : expectedHex)
		{
			int nibble;
			if (symbol >= '0' and symbol <= '9')
			{
				nibble = symbol - '0';
			}
			else if (symbol >= 'a' and symbol <= 'f')
			{
				nibble = symbol - 'a' + 10;
			}
			else if (symbol >= 'A' and symbol <= 'F')
			{
				nibble = symbol - 'A' + 10;
			}
			else
			{
				continue;
			}

			if (haveNibble)
			{
				expected.push_back(static_cast<uint8_t>((pending << 4) | nibble));
				haveNibble = false;
			}
			else
			{
				pending = static_cast<uint8_t>(nibble);
				haveNibble = true;
			}
		}

		auto render = [](const uint8_t* data, size_t length)
		{
			std::string out;
			for (size_t i = 0; i < length; ++i)
			{
				out += fmt::format("{:02X} ", data[i]);
			}
			return out;
		};

		if (actualLength != expected.size() or not std::equal(expected.begin(), expected.end(), actual))
		{
			throw TestFailure{ fmt::format(
				"{}: byte mismatch\n  expected ({} bytes): {}\n  actual   ({} bytes): {}",
				what, expected.size(), render(expected.data(), expected.size()), actualLength, render(actual, actualLength)) };
		}
	}
}

int main(int argc, char* argv[])
{
	using namespace BlackTek::Tests;

	std::string_view filter = argc > 1 ? argv[1] : "";
	int passed = 0;
	int failed = 0;

	for (const auto& test : registry())
	{
		if (not filter.empty() and test.name.find(filter) == std::string::npos)
		{
			continue;
		}

		try
		{
			test.body();
			fmt::print(fmt::fg(fmt::color::green), "[PASS] ");
			fmt::print("{}\n", test.name);
			++passed;
		}
		catch (const TestFailure& failure)
		{
			fmt::print(fmt::fg(fmt::color::red), "[FAIL] ");
			fmt::print("{}\n       {}\n", test.name, failure.message);
			++failed;
		}
		catch (const std::exception& exception)
		{
			fmt::print(fmt::fg(fmt::color::red), "[FAIL] ");
			fmt::print("{}\n       unexpected exception: {}\n", test.name, exception.what());
			++failed;
		}
	}

	fmt::print("\n{} passed, {} failed\n", passed, failed);
	return failed == 0 ? 0 : 1;
}
