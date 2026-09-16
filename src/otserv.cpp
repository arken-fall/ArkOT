// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "bestiary.h"
#include "prey.h"
#include "forge.h"
#include "wheel.h"
#include "store.h"

#include "server.h"

#include "game.h"

#include "iomarket.h"

#include "configmanager.h"
#include "scriptmanager.h"
#include "rsa.h"
#include "protocolold.h"
#include "protocollogin.h"
#include "protocolstatus.h"
#include "databasemanager.h"
#include "scheduler.h"
#include "databasetasks.h"
#include "script.h"
#include <fstream>
#include <fmt/color.h>
#include "appearances.h"
#include "augments.h"
#include "zones.h"
#include "console.h"
#include "metrics.h"
#include "world.h"
#include "simd_dispatch.h"
#include <array>
#include <memory>
#include <optional>
#include <ranges>
#include <string_view>

#if __has_include("gitmetadata.h")
	#include "gitmetadata.h"
#endif

DatabaseTasks g_databaseTasks;
Dispatcher g_dispatcher;
Dispatcher g_utility_boss;
Scheduler g_scheduler;

Game g_game;
ConfigManager g_config;
Monsters g_monsters;
Vocations g_vocations;
extern Scripts* g_scripts;
RSA g_RSA;

std::mutex g_loaderLock;
std::condition_variable g_loaderSignal;
std::unique_lock<std::mutex> g_loaderUniqueLock(g_loaderLock);

// ============================================================================
// BLACKTEK HOLOGRAPHIC CONSOLE - Color Definitions
// ============================================================================

namespace Console {
	// Primary colors for the holographic theme
	const auto cyan = fmt::color::cyan;
	const auto magenta = fmt::color::magenta;
	const auto white = fmt::color::white;
	const auto gray = fmt::color::gray;
	const auto dark_gray = fmt::color::dim_gray;
	const auto green = fmt::color::lime_green;
	const auto red = fmt::color::red;
	const auto yellow = fmt::color::yellow;
	const auto purple = fmt::color::purple;
	const auto dark_purple = fmt::color::dark_violet;

	// Box drawing characters
	constexpr const char* BOX_TL = "╔";
	constexpr const char* BOX_TR = "╗";
	constexpr const char* BOX_BL = "╚";
	constexpr const char* BOX_BR = "╝";
	constexpr const char* BOX_H = "═";
	constexpr const char* BOX_V = "║";
	constexpr const char* BOX_LT = "╠";
	constexpr const char* BOX_RT = "╣";

	// Status symbols
	constexpr const char* CHECK = "✓";
	constexpr const char* CROSS = "✗";
	constexpr const char* DIAMOND = "◆";
	constexpr const char* ARROW = "▸";
	constexpr const char* DOT = "●";
	constexpr const char* PROGRESS_FULL = "█";
	constexpr const char* PROGRESS_EMPTY = "░";

	// Print the large BLACKTEK ASCII banner with gradient effect
	void printBanner()
	{
		BlackTek::Console::Print("\n");
		BlackTek::Console::StyledPrint(true, fg(dark_purple) | fmt::emphasis::bold,
			"    ██████╗ ██╗      █████╗  ██████╗██╗  ██╗████████╗███████╗██╗  ██╗");
		BlackTek::Console::StyledPrint(true, fg(dark_purple),
			"    ██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝╚══██╔══╝██╔════╝██║ ██╔╝");
		BlackTek::Console::StyledPrint(true, fg(dark_purple),
			"    ██████╔╝██║     ███████║██║     █████╔╝    ██║   █████╗  █████╔╝ ");
		BlackTek::Console::StyledPrint(true, fg(dark_purple),
			"    ██╔══██╗██║     ██╔══██║██║     ██╔═██╗    ██║   ██╔══╝  ██╔═██╗ ");
		BlackTek::Console::StyledPrint(true, fg(dark_purple),
			"    ██████╔╝███████╗██║  ██║╚██████╗██║  ██╗   ██║   ███████╗██║  ██╗");
		BlackTek::Console::StyledPrint(true, fg(dark_purple) | fmt::emphasis::bold,
			"    ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝");
		BlackTek::Console::Print("\n");
	}

	// Print version info bar
	void printVersionBar()
	{
		BlackTek::Console::StyledPrint(false, fg(dark_gray), "    ─────────────────────────────────────────────────────────────────\n");
		BlackTek::Console::StyledPrint(false, fg(gray),      "    VERSION ");
		BlackTek::Console::StyledPrint(false, fg(white) | fmt::emphasis::bold, "{} ", STATUS_SERVER_VERSION);
		BlackTek::Console::StyledPrint(false, fg(dark_gray), " · ");
		BlackTek::Console::StyledPrint(false, fg(gray),      " CLIENT ");
		BlackTek::Console::StyledPrint(false, fg(white) | fmt::emphasis::bold, "{} ", CLIENT_VERSION_STR);
		BlackTek::Console::StyledPrint(false, fg(dark_gray), " · ");
		BlackTek::Console::StyledPrint(false, fg(gray),      " BUILD ");
		#if defined(GIT_RETRIEVED_STATE) && GIT_RETRIEVED_STATE
			#if GIT_IS_DIRTY
				BlackTek::Console::StyledPrint(false, fg(yellow) | fmt::emphasis::bold, "DIRTY\n");
			#else
				BlackTek::Console::StyledPrint(false, fg(green)  | fmt::emphasis::bold, "CLEAN\n");
			#endif
		#else
				BlackTek::Console::StyledPrint(false, fg(green)  | fmt::emphasis::bold, "OFFICIAL\n");
		#endif
		BlackTek::Console::StyledPrint(false, fg(dark_gray), "    ─────────────────────────────────────────────────────────────────\n\n");
	}

	// Print a section header
	void printSection(const std::string& name)
	{
		std::string out;
		out += fmt::format(fg(cyan) | fmt::emphasis::bold, "\n    {} {}\n", DIAMOND, name);
		out += fmt::format(fg(dark_gray), "    ────────────────────────────────────────");
		BlackTek::Console::LogAndPrint(std::move(out));
	}

	void printProgress(const std::string& name, bool success = true, const std::string& detail = "")
	{
		std::string out;
		out += fmt::format(fg(gray),  "    ");
		out += fmt::format(fg(white), "{:<24}", name);

		if (success)
			out += fmt::format(fg(green) | fmt::emphasis::bold, "{}", CHECK);
		else
			out += fmt::format(fg(red)   | fmt::emphasis::bold, "{}", CROSS);

		if (not detail.empty())
			out += fmt::format(fg(dark_gray), "  {:>12}", detail);

		BlackTek::Console::LogAndPrint(std::move(out));
	}

	// Print a simple status line
	void printStatus(const std::string& message, bool success = true)
	{
		std::string out;
		out += fmt::format(fg(gray),  "    {} ", ARROW);
		out += fmt::format(fg(white), "{}", message);
		if (success)
			out += fmt::format(fg(green) | fmt::emphasis::bold, " {}", CHECK);
		else
			out += fmt::format(fg(red)   | fmt::emphasis::bold, " {}", CROSS);
		BlackTek::Console::LogAndPrint(std::move(out));
	}

	// Print info line
	void printInfo(const std::string& label, const std::string& value)
	{
		std::string out;
		out += fmt::format(fg(dark_gray), ":    {:<16}", label);
		out += fmt::format(fg(white),     "{}", value);
		BlackTek::Console::LogAndPrint(std::move(out));
	}

	// Print the final online status box
	void printOnline(const std::string& serverName)
	{
		std::string onlineText = "◆ " + serverName + " SERVER ONLINE ◆";
		int totalWidth = 68;
		auto textLen = static_cast<int>(onlineText.length());
		int padding = (totalWidth - textLen) / 2;

		std::string out;
		out += "\n";
		out += fmt::format(fg(dark_gray), "    ╔══════════════════════════════════════════════════════════════════╗\n");
		out += fmt::format(fg(dark_gray), "    ║");
		out += fmt::format(fg(cyan),                              "{:>{}}", "", padding);
		out += fmt::format(fg(cyan)  | fmt::emphasis::bold,       "{}", DIAMOND);
		out += fmt::format(fg(white) | fmt::emphasis::bold,       " {} ", serverName);
		out += fmt::format(fg(green) | fmt::emphasis::bold,       "| ONLINE | ");
		out += fmt::format(fg(cyan)  | fmt::emphasis::bold,       "{}", DIAMOND);
		out += fmt::format(fg(cyan),                              "{:<{}}", "", padding - 2);
		out += fmt::format(fg(dark_gray), "       ║\n");
		out += fmt::format(fg(dark_gray), "    ╚══════════════════════════════════════════════════════════════════╝\n\n");
		BlackTek::Console::LogAndPrint(std::move(out));
	}

	// Print error message
	void printError(const std::string& message)
	{
		std::string out = fmt::format(fg(red) | fmt::emphasis::bold, "\n    {} ERROR: {}\n\n", CROSS, message);
		BlackTek::Console::LogAndPrint(std::move(out));
	}

	// Print warning message
	void printWarning(const std::string& message)
	{
		std::string out = fmt::format(fg(yellow) | fmt::emphasis::bold, "    ⚠ WARNING: {}\n", message);
		BlackTek::Console::LogAndPrint(std::move(out));
	}
}

// ============================================================================
// Server Functions
// ============================================================================

void startupErrorMessage(const std::string& errorStr)
{
	Console::printError(errorStr);

	if (auto logPath = BlackTek::Console::GetChannelLogPath(BlackTek::Console::ChannelType::System))
	{
		Console::printWarning("Full details logged to " + *logPath);
	}

	g_loaderSignal.notify_all();
}

namespace
{
	// The three tables auth_schema.sql hoists into the shared auth schema. Every
	// world schema carries a VIEW of the same name over each of them, which is the
	// whole reason no account query in this server - or in the unmodifiable
	// third-party login-server - had to be schema-qualified.
	constexpr std::array<std::string_view, 3> AuthSharedTables{ "accounts", "account_sessions", "store_history" };

	// Establishes that this world's schema really was provisioned against the
	// configured auth schema. Returns the reason it was not, or nullopt when the
	// shared auth schema is usable. Boot must refuse on a reason: a world whose
	// views were never created would quietly authenticate against its own stale
	// account table, which is a broken login rather than a degraded one.
	[[nodiscard]] std::optional<std::string> ProbeSharedAuthSchema(const std::string& authSchema, const std::string& worldSchema)
	{
		Database& db = Database::getInstance();

		// The unqualified name every existing account query uses must resolve to
		// something this connection can read. EXISTS() always yields exactly one
		// row, so a freshly provisioned (and therefore empty) account table is not
		// mistaken for a failure - storeQuery returns nullptr for an empty result
		// set just as it does for a failed query.
		if (not db.storeQuery("SELECT EXISTS(SELECT 1 FROM `accounts` LIMIT 1) AS `readable`"))
		{
			return fmt::format("Shared auth schema: `accounts` cannot be read from schema '{:s}'. Run auth_schema.sql for this world, or clear [mysql].auth_database in config/database.toml.", worldSchema);
		}

		// Reading is not enough; it has to be reading the SHARED rows. So `accounts`
		// must be a view in this world's schema, and the base table behind it must
		// live in the auth schema. information_schema answers both on this same
		// connection, exactly as DatabaseManager already reaches it
		// (src/databasemanager.cpp:18, 41, 47).
		std::array<bool, AuthSharedTables.size()> isView{};
		std::array<bool, AuthSharedTables.size()> hasBaseTable{};
		std::array<bool, AuthSharedTables.size()> viewNamesAuthSchema{};

		constexpr std::string_view sharedTableList = "('accounts', 'account_sessions', 'store_history')";

		const auto indexOf = [](std::string_view tableName) -> std::optional<size_t>
		{
			const auto match = std::ranges::find_if(AuthSharedTables, [tableName](std::string_view candidate)
			{
				return caseInsensitiveEqual(tableName, candidate);
			});

			if (match == AuthSharedTables.end())
				return std::nullopt;

			return static_cast<size_t>(std::ranges::distance(AuthSharedTables.begin(), match));
		};

		if (const auto views = db.storeQuery(fmt::format("SELECT `TABLE_NAME`, `VIEW_DEFINITION` FROM `information_schema`.`VIEWS` WHERE `TABLE_SCHEMA` = {:s} AND `TABLE_NAME` IN {:s}", db.escapeString(worldSchema), sharedTableList)))
		{
			const std::string authReference = asLowerCaseString(fmt::format("`{:s}`.", authSchema));

			do
			{
				if (const auto index = indexOf(views->getString("TABLE_NAME")))
				{
					isView[*index] = true;
					viewNamesAuthSchema[*index] = asLowerCaseString(std::string{ views->getString("VIEW_DEFINITION") }).find(authReference) != std::string::npos;
				}
			} while (views->next());
		}

		if (const auto tables = db.storeQuery(fmt::format("SELECT `TABLE_NAME` FROM `information_schema`.`TABLES` WHERE `TABLE_SCHEMA` = {:s} AND `TABLE_TYPE` = 'BASE TABLE' AND `TABLE_NAME` IN {:s}", db.escapeString(authSchema), sharedTableList)))
		{
			do
			{
				if (const auto index = indexOf(tables->getString("TABLE_NAME")))
				{
					hasBaseTable[*index] = true;
				}
			} while (tables->next());
		}

		std::string missingViews;
		std::string missingTables;

		const auto listName = [](std::string& list, std::string_view tableName)
		{
			if (not list.empty())
			{
				list += ", ";
			}

			list += tableName;
		};

		for (size_t index = 0; index < AuthSharedTables.size(); ++index)
		{
			if (not isView[index])
			{
				listName(missingViews, AuthSharedTables[index]);
			}

			if (not hasBaseTable[index])
			{
				listName(missingTables, AuthSharedTables[index]);
			}
		}

		if (not missingViews.empty())
		{
			return fmt::format("Shared auth schema: schema '{:s}' has no view for {:s}. This world was never provisioned against auth schema '{:s}' - run auth_schema.sql for it, or clear [mysql].auth_database in config/database.toml.", worldSchema, missingViews, authSchema);
		}

		if (not missingTables.empty())
		{
			return fmt::format("Shared auth schema: auth schema '{:s}' has no base table for {:s}. Run section 1 of auth_schema.sql, or clear [mysql].auth_database in config/database.toml.", authSchema, missingTables);
		}

		// Whether a stored view definition still spells out the auth schema is a
		// question about the server's own text formatting - and about whether this
		// user holds SHOW VIEW, without which VIEW_DEFINITION comes back empty -
		// not about structure, so it only warns. The structural checks above are
		// what boot refuses on; refusing here too would trade a real outage for a
		// cosmetic mismatch.
		auto unconfirmed = std::views::iota(size_t{ 0 }, AuthSharedTables.size())
			| std::views::filter([&viewNamesAuthSchema](size_t index) { return not viewNamesAuthSchema[index]; });

		for (const auto index : unconfirmed)
		{
			BlackTek::Console::Database::Warn("mainLoader: view `{:s}`.`{:s}` does not name auth schema '{:s}' in its definition; confirm it points where you think it does.", worldSchema, AuthSharedTables[index], authSchema);
		}

		return std::nullopt;
	}

	// O3: the cross-world character list reads `<other world>`.`players` on this
	// same connection, so the login-serving MySQL user needs SELECT on every world
	// schema, not just its own. A world that cannot be read costs only that world's
	// characters in the list, so this warns per world instead of refusing - one
	// unreachable world must never stop this world from serving.
	void ProbeWorldSchemas()
	{
		Database& db = Database::getInstance();

		const auto quotable = [](const BlackTek::World::Entry& entry) noexcept
		{
			return entry.schema.find('`') == std::string::npos;
		};

		const auto worlds = BlackTek::World::Registry::GetInstance().All();

		for (const auto& entry : worlds | std::views::filter(std::not_fn(quotable)))
		{
			BlackTek::Console::Database::Warn("mainLoader: world '{:s}' (id {:d}) declares an unusable schema name '{:s}'; its characters cannot be listed.", entry.name, entry.id, entry.schema);
		}

		for (const auto& entry : worlds | std::views::filter(quotable))
		{
			if (not db.storeQuery(fmt::format("SELECT EXISTS(SELECT 1 FROM `{:s}`.`players` LIMIT 1) AS `readable`", entry.schema)))
			{
				BlackTek::Console::Database::Warn("mainLoader: cannot read `{:s}`.`players` for world '{:s}' (id {:d}); that world's characters will be missing from the character list. Grant this MySQL user SELECT on that schema.", entry.schema, entry.name, entry.id);
			}
		}
	}
}

void mainLoader(int argc, char* argv[], ServiceManager* services);
bool argumentsHandler(const StringVector& args);

[[noreturn]] 
void badAllocationHandler()
{
	// Use functions that only use stack allocation
	puts("Allocation failed, server out of memory.\nDecrease the size of your map or compile in 64 bits mode.\n");
	getchar();
	exit(-1);
}

int main(int argc, char* argv[])
{
	StringVector args = StringVector(argv, argv + argc);
	if(argc > 1 && !argumentsHandler(args))
	{
		return 0;
	}

	// Setup bad allocation handler
	std::set_new_handler(badAllocationHandler);
	BlackTek::Console::Initialize();
	ServiceManager serviceManager;

	g_dispatcher.start();
	g_scheduler.start();
	g_utility_boss.start();

	g_dispatcher.addTask(createTask([=, services = &serviceManager]() { mainLoader(argc, argv, services); }));

	g_loaderSignal.wait(g_loaderUniqueLock);

	if (serviceManager.is_running())
	{
		Console::printOnline(g_config.GetString(ConfigManager::SERVER_NAME));
		serviceManager.run();
	}
	else
	{
		Console::printError("No services running. The server is NOT online.");

		g_scheduler.shutdown();
		g_databaseTasks.shutdown();
		g_dispatcher.shutdown();
		g_utility_boss.shutdown();

		BlackTek::Console::Shutdown();

		// A console window opened by double-clicking the exe closes the instant main()
		// returns, so any errors printed before this would otherwise vanish before being read.
		// todo: Implement a more sophisticated way of handling this, considering users who might
		// be piping the output through CI/CL or using local scripts
		puts("Press Enter to exit...");
		getchar();
	}

	g_scheduler.join();
	g_databaseTasks.join();
	g_dispatcher.join();
	g_utility_boss.join();

	return 0;
}

#include "accountmanager.h"

void printServerVersion()
{
	Console::printBanner();
	Console::printVersionBar();
	
	#if defined(GIT_RETRIEVED_STATE) && GIT_RETRIEVED_STATE
		Console::printInfo("Git SHA1", std::string(GIT_SHORT_SHA1) + " (" + GIT_COMMIT_DATE_ISO8601 + ")");
	#endif

	Console::printInfo("Developed By", STATUS_SERVER_DEVELOPERS);
	Console::printInfo("Maintainer", STATUS_SERVER_MAINTAINER);
	Console::printInfo("Community", STATUS_SERVER_COMMUNITY_LINK);
	Console::printInfo("Website", "black-tek.github.io/blacktek/welcome/");
}

namespace
{
	// Registers one listener and refuses the boot if it is not accepting when we
	// are done. ServicePort::open does not retry a bind that failed at startup,
	// so such a listener stays dead for the entire run - and the config-level
	// collision checks below cannot see a port held by a process outside this
	// server, which is exactly how an occupied login port used to produce an
	// ONLINE banner nobody could log into.
	//
	// Every configured listener is treated as required. A game or login port
	// that will not bind means no one can play; a status port that will not bind
	// is most often a second copy of this same server already running, and two
	// instances sharing one world's database is a worse outcome than refusing to
	// start. Port 0 is the documented "listener disabled" setting, and is the one
	// way add() can fail that the operator asked for, so it does not refuse.
	template <typename ProtocolType>
	[[nodiscard]] bool AddListener(ServiceManager& services, uint16_t port)
	{
		auto listening = services.add<ProtocolType>(port);
		if (listening.has_value() or port == 0)
			return true;

		// Ports bound before this one would still make is_running() true, and
		// main() announces ONLINE on that alone, so the refusal has to take the
		// whole set of listeners down with it.
		services.AbandonListeners();

		startupErrorMessage(fmt::format("{:s} could not listen on port {:d}: {:s}. Free that port or change it in config/server.toml, then start the server again.", ProtocolType::protocol_name(), port, listening.error()));
		return false;
	}
}

void mainLoader(int, char*[], ServiceManager* services)
{
	// dispatcher thread
	g_game.setGameState(GAME_STATE_STARTUP);

	BlackTek::SIMD::detect();

	srand(static_cast<unsigned int>(OTSYS_TIME()));

	#ifdef _WIN32
		SetConsoleTitle(STATUS_SERVER_NAME);

		// Enable ANSI/VT100 escape code processing
		HANDLE hOut = GetStdHandle(STD_OUTPUT_HANDLE);
		DWORD dwMode = 0;
		GetConsoleMode(hOut, &dwMode);
		dwMode |= ENABLE_VIRTUAL_TERMINAL_PROCESSING;
		SetConsoleMode(hOut, dwMode);

		// We disable quick edit mode because it causes the server to freeze whenever a user clicks the console window
		HANDLE hIn = GetStdHandle(STD_INPUT_HANDLE);
		DWORD dwInMode = 0;
		GetConsoleMode(hIn, &dwInMode);
		dwInMode &= ~ENABLE_QUICK_EDIT_MODE;
		SetConsoleMode(hIn, dwInMode);
	#endif

	// banner and version info
	printServerVersion();
	BlackTek::Console::Print("\n");
	BlackTek::Console::LogAndPrint(fmt::format(fg(Console::dark_gray), "    ────────────────────────────────────────"));

	// Load configuration from config/ directory (TOML files)
	if (not g_config.Load())
	{
		startupErrorMessage("Unable to load configuration files from the config/ directory!");
		return;
	}

	if constexpr (BlackTek::Metrics::ENABLED) BlackTek::Metrics::Initialize();

	#ifdef _WIN32
		const std::string& defaultPriority = g_config.GetString(ConfigManager::DEFAULT_PRIORITY);
		if (caseInsensitiveEqual(defaultPriority, "high"))
		{
			SetPriorityClass(GetCurrentProcess(), HIGH_PRIORITY_CLASS);
		}
		else if (caseInsensitiveEqual(defaultPriority, "above-normal"))
		{
			SetPriorityClass(GetCurrentProcess(), ABOVE_NORMAL_PRIORITY_CLASS);
		}
	#endif

	try
	{
		g_RSA.loadPEM("key.pem");
	}
	catch(const std::exception& e)
	{
		startupErrorMessage(e.what());
		return;
	}

	// Connect to database
	if (not Database::getInstance().connect())
	{
		startupErrorMessage("Failed to connect to database.");
		return;
	}

	// World identity. Loaded once here, on the dispatcher, before any listener can
	// accept; every later reader runs after mainLoader returns, so the registry
	// needs no synchronisation. A world that cannot prove which world it is - or
	// that disagrees with config/worlds.toml about its own address, port or
	// schema - refuses to boot rather than misrouting players at login.
	{
		using WorldRegistry = BlackTek::World::Registry;

		const int32_t configuredWorldId = g_config.GetNumber(ConfigManager::WORLD_ID);
		if (configuredWorldId < 0 or configuredWorldId > 255)
		{
			startupErrorMessage(fmt::format("World registry: [world].id must be between 0 and 255, got {:d}.", configuredWorldId));
			return;
		}

		// The wire name is the login source's world name; [identity].name is only a
		// stand-in for the single world synthesised when no worlds.toml is deployed.
		const std::string& serverName = g_config.GetString(ConfigManager::SERVER_NAME);

		const WorldRegistry::Identity identity{
			.name    = serverName.empty() ? std::string{STATUS_SERVER_NAME} : serverName,
			.address = g_config.GetString(ConfigManager::IP),
			.schema  = g_config.GetString(ConfigManager::MYSQL_DB),
			.port    = static_cast<uint16_t>(g_config.GetNumber(ConfigManager::GAME_PORT_MODERN)),
			.id      = static_cast<BlackTek::World::Id>(configuredWorldId) };

		if (const auto loaded = WorldRegistry::GetInstance().Load(identity); not loaded)
		{
			startupErrorMessage(fmt::format("World registry: {:s}", WorldRegistry::Describe(loaded.error())));
			return;
		}
	}

	// Shared auth schema. An empty [mysql].auth_database - or one equal to
	// [mysql].database - is a single-world install: no auth schema, no views,
	// nothing to probe, so this whole block is skipped. When it is set, every
	// unqualified `accounts` / `account_sessions` / `store_history` query in this
	// process is expected to resolve through a per-world view into that schema
	// (auth_schema.sql), so a world whose views were never created must stop here
	// rather than serve logins against its own stale account table.
	{
		const std::string& authSchema = g_config.GetString(ConfigManager::MYSQL_AUTH_DB);
		const std::string& worldSchema = g_config.GetString(ConfigManager::MYSQL_DB);

		if (not authSchema.empty() and not caseInsensitiveEqual(authSchema, worldSchema))
		{
			if (const auto failure = ProbeSharedAuthSchema(authSchema, worldSchema))
			{
				startupErrorMessage(*failure);
				return;
			}

			ProbeWorldSchemas();
		}
	}

	Console::printInfo("Compiler", BOOST_COMPILER);
	Console::printInfo("Compiled", std::string(__DATE__) + " " + __TIME__);
	Console::printInfo("Lua Version", LUA_VERSION);
	Console::printInfo("Database", std::string("MariaDB ") + Database::getClientVersion());

	// Run database manager
	if (not DatabaseManager::isDatabaseSetup())
	{
		startupErrorMessage("The database you have specified in config.lua is empty, please import the schema.sql to your database.");
		return;
	}
	g_databaseTasks.start();
	DatabaseManager::updateDatabase();

	if (g_config.GetBoolean(ConfigManager::OPTIMIZE_DATABASE) and not DatabaseManager::optimizeTables())
	{
		Console::printWarning("No tables were optimized.");
	}

	// ========================================================================
	// SERVER CONFIGURATION
	// ========================================================================
	Console::printSection("SERVER CONFIG");

	// Check world type
	std::string worldType = asLowerCaseString(g_config.GetString(ConfigManager::WORLD_TYPE));
	if (worldType == "pvp")
	{
		g_game.setWorldType(WORLD_TYPE_PVP);
	}
	else if (worldType == "no-pvp")
	{
		g_game.setWorldType(WORLD_TYPE_NO_PVP);
	}
	else if (worldType == "pvp-enforced")
	{
		g_game.setWorldType(WORLD_TYPE_PVP_ENFORCED);
	}
	else
	{
		startupErrorMessage(fmt::format("Unknown world type: {:s}, valid world types are: pvp, no-pvp and pvp-enforced.", g_config.GetString(ConfigManager::WORLD_TYPE)));
		return;
	}

	Console::printProgress("World", true, fmt::format("{:s} (id {:d})", BlackTek::World::Local().name, BlackTek::World::Local().id));
	Console::printProgress("World Type", true, asUpperCaseString(worldType));
	Console::printProgress("World Map",  true, g_config.GetString(ConfigManager::MAP_NAME));

	// Account Manager
	if (g_config.GetBoolean(ConfigManager::ENABLE_ACCOUNT_MANAGER))
	{
		AccountManager::initialize();
		Console::printProgress("Account Manager", true, "enabled");
	}

	Console::printProgress("Game Port",   true, std::to_string(g_config.GetNumber(ConfigManager::GAME_PORT)));
	Console::printProgress("Modern Game Port", true, std::to_string(g_config.GetNumber(ConfigManager::GAME_PORT_MODERN)));
	Console::printProgress("Login Port",  true, std::to_string(g_config.GetNumber(ConfigManager::LOGIN_PORT)));
	Console::printProgress("Status Port", true, std::to_string(g_config.GetNumber(ConfigManager::STATUS_PORT)));

	// ========================================================================
	// GAME DATA
	// ========================================================================
	Console::printSection("GAME DATA");

	// Load vocations
	if (not g_vocations.loadFromToml())
	{
		startupErrorMessage("Unable to load vocations!");
		return;
	}
	Console::printProgress("Vocations", true, std::to_string(g_vocations.getVocations().size()));

	// Load items
	if (not Item::items.loadFromDat(g_config.GetString(ConfigManager::ASSETS_DAT_PATH)))
	{
		startupErrorMessage("Unable to load items (DAT)!");
		return;
	}
	if (not Item::items.loadFromToml())
	{
		startupErrorMessage("Unable to load items (TOML)!");
		return;
	}
	Console::printProgress("Items", true, std::to_string(Item::items.size()));

	// Modern (13.40+) client support data. Both are optional: without them
	// legacy clients are unaffected and modern clients simply can't be
	// served item content yet. Appearances load first so the id mapper can
	// prune rows whose appearance no longer exists.
	if (BlackTek::Assets::Appearances::getInstance().load(g_config.GetString(ConfigManager::APPEARANCES_DAT_PATH)))
	{
		Console::printProgress("Appearances", true, std::to_string(BlackTek::Assets::Appearances::getInstance().objectCount()));
	}

	if (Item::items.loadModernClientIds("data/items/modern_client_ids.tsv"))
	{
		Console::printProgress("Modern client ids", true, std::to_string(Item::items.modernClientIdCount()));
	}

	// Load script systems
	if (not ScriptingManager::getInstance().loadScriptSystems())
	{
		startupErrorMessage("Failed to load script systems");
		return;
	}

	// Load lua scripts
	if (not g_scripts->loadScripts("scripts", false, false))
	{
		startupErrorMessage("Failed to load lua scripts");
		return;
	}

	// Load outfits
	if (not Outfits::getInstance().load())
	{
		startupErrorMessage("Unable to load outfits!");
		return;
	}

	// todo: split this to show both counts individually
	Console::printProgress("Outfits", true, std::to_string(Outfits::getInstance().getOutfits(PLAYERSEX_FEMALE).size() + Outfits::getInstance().getOutfits(PLAYERSEX_MALE).size()));

	// Load guilds
	IOGuild::loadGuilds();
	Console::printProgress("Guilds", true, std::to_string(g_game.getGuilds().size()));

	// Load lua monsters (folder is optional)
	g_scripts->loadScripts("monster", false, false);
	Console::printProgress("Monsters", true, std::to_string(g_monsters.count()));

	// Load zones
	Zones::ZoneManager::LoadZones();
	Console::printProgress("Zones", true, std::to_string(Zones::ZoneManager::Count()));
	Console::printProgress("Spawns", true, std::to_string(Zones::ZoneManager::SpawnCount()));

	// Load augments
	BlackTek::Augments::loadAll();
	BlackTek::Bestiary::Registry::getInstance().loadCharms();
	BlackTek::Prey::System::getInstance().loadConfig();
	BlackTek::Forge::System::getInstance().loadConfig();
	BlackTek::Wheel::System::getInstance().loadConfig();
	BlackTek::Store::System::getInstance().loadConfig();
	Console::printProgress("Augments", true, std::to_string(BlackTek::Augments::count()));


	// Load map
	if (not g_game.loadMainMap(g_config.GetString(ConfigManager::MAP_NAME)))
	{
		startupErrorMessage("Failed to load map");
		return;
	}

	Console::printProgress("Map Tiles", true, std::to_string(g_game.map.lastLoadTileCount));
	Console::printProgress("Map Items", true, std::to_string(g_game.map.lastLoadItemCount));
	Console::printProgress("Map Load Time", true, std::to_string(g_game.map.lastLoadTimeSeconds) + "s");

	Zones::ZoneManager::StampWorldZoneFlags();

	if (g_config.GetBoolean(ConfigManager::SMART_CONVERT_LEGACY_ZONES))
		Zones::ZoneManager::SmartConvertLegacyZoneFlags(g_game.map);

	if (g_config.GetBoolean(ConfigManager::SMART_CONVERT_LEGACY_SPAWNS))
		Zones::ZoneManager::ConvertLegacySpawns(g_game.map.spawnfile, g_game.map.otbmFilePath);

	g_game.initializeSpawnPool();

	// Initialize game state
	g_game.setGameState(GAME_STATE_INIT);

	// Game client protocols; 0 disables a listener, matching game_port_modern.
	// Legacy (pre-13.40) clients use game_port/login_port; a modern-only server
	// runs with both set to 0 and serves game_port_modern alone.
	const auto gamePort = g_config.GetNumber(ConfigManager::GAME_PORT);
	const auto modernPort = g_config.GetNumber(ConfigManager::GAME_PORT_MODERN);
	const auto loginPort = g_config.GetNumber(ConfigManager::LOGIN_PORT);
	const auto statusPort = g_config.GetNumber(ConfigManager::STATUS_PORT);

	// shared spectator payloads are built once for every client, so they
	// can only follow one generation; serving both ports at once is not
	// supported since the legacy listener was retired
	if (gamePort != 0 and modernPort != 0)
	{
		startupErrorMessage("game_port and game_port_modern can not both be enabled; set game_port = 0 for a 13.40+ server.");
		return;
	}

	// A 15.25 client only speaks to an in-binary login server on port 7171 -
	// that is a client-side constant - so login_port cannot be moved out of a
	// collision. ServiceManager::add would only print and disable one of the
	// two listeners, leaving a server that looks healthy and cannot be logged
	// into, so this refuses instead.
	if (loginPort != 0 and (loginPort == statusPort or loginPort == gamePort or loginPort == modernPort))
	{
		startupErrorMessage(fmt::format("login_port {:d} collides with another listener in config/server.toml (status_port {:d}, game_port {:d}, game_port_modern {:d}). A 15.25 client only reaches an in-binary login server on 7171, so move the other listener.", loginPort, statusPort, gamePort, modernPort));
		return;
	}

	if (gamePort != 0)
	{
		if (not AddListener<ProtocolGame>(*services, static_cast<uint16_t>(gamePort)))
			return;

		// the legacy pair shares one port; make_protocol tells them apart by
		// checksum state, which only works while neither is single-socket
		if (loginPort != 0)
		{
			if (not AddListener<ProtocolLogin>(*services, static_cast<uint16_t>(loginPort)))
				return;

			if (not AddListener<ProtocolOld>(*services, static_cast<uint16_t>(loginPort)))
				return;
		}
	}

	// Modern (13.40+) clients handshake on a separate port; see ProtocolGameModern
	if (modernPort != 0)
	{
		if (not AddListener<ProtocolGameModern>(*services, static_cast<uint16_t>(modernPort)))
			return;

		ProtocolGame::setSharedModernLayout(true);

		// ProtocolLoginModern is server_sends_first, so it takes the login port
		// alone - ServicePort::add_service refuses any service beside a
		// single-socket one. A 15.25-only server has no legacy client to
		// redirect, so there is nothing for ProtocolOld to answer here.
		if (loginPort != 0)
		{
			if (not AddListener<ProtocolLoginModern>(*services, static_cast<uint16_t>(loginPort)))
				return;
		}
	}

	// OT protocols
	if (not AddListener<ProtocolStatus>(*services, static_cast<uint16_t>(statusPort)))
		return;

	// House rent
	RentPeriod_t rentPeriod;
	std::string strRentPeriod = asLowerCaseString(g_config.GetString(ConfigManager::HOUSE_RENT_PERIOD));


	// TODO: I want to add the load times for things, and we are still not displaying the old information about the map size
	// the method was changed to std::expected and given error codes for handling each type of failure for loading
	// this needs to be repeated for other loader methods, having them return statistical data we might want to show 
	// on the console, and probably have a dedicated section for this purpose, or, at the very least, alter the entries
	// which already show the "counts" of things loaded, to display "loaded x in x.xx seconds". 



	if (strRentPeriod == "yearly")
	{
		rentPeriod = RENTPERIOD_YEARLY;
	}
	else if (strRentPeriod == "weekly")
	{
		rentPeriod = RENTPERIOD_WEEKLY;
	}
	else if (strRentPeriod == "monthly")
	{
		rentPeriod = RENTPERIOD_MONTHLY;
	}
	else if (strRentPeriod == "daily")
	{
		rentPeriod = RENTPERIOD_DAILY;
	}
	else
	{
		rentPeriod = RENTPERIOD_NEVER;
	}

	g_game.map.houses.payHouses(rentPeriod);

	IOMarket::checkExpiredOffers();
	IOMarket::getInstance().updateStatistics();

#ifndef _WIN32
	if (getuid() == 0 || geteuid() == 0) {
		Console::printWarning(std::string(STATUS_SERVER_NAME) + " has been executed as root user, please consider running it as a normal user.");
	}
#endif

	g_game.start(services);
	g_game.setGameState(GAME_STATE_NORMAL);
	g_loaderSignal.notify_all();
}

bool argumentsHandler(const StringVector& args)
{
	for (const auto& arg : args) {
		if (arg == "--help") {
			std::clog << "Usage:\n"
			"\n"
			"\t--ip=$1\t\t\tIP address of the server.\n"
			"\t\t\t\tShould be equal to the global IP.\n"
			"\t--login-port=$1\tPort for login server to listen on.\n"
			"\t--game-port=$1\tPort for game server to listen on.\n";
			return false;
		} else if (arg == "--version") {
			printServerVersion();
			return false;
		}

		auto tmp = explodeString(arg, "=");

		if (tmp[0] == "--ip")
			g_config.SetString(ConfigManager::IP, tmp[1]);
		else if (tmp[0] == "--login-port")
			g_config.SetNumber(ConfigManager::LOGIN_PORT, std::stoi(tmp[1].data()));
		else if (tmp[0] == "--game-port")
			g_config.SetNumber(ConfigManager::GAME_PORT, std::stoi(tmp[1].data()));
	}

	return true;
}
