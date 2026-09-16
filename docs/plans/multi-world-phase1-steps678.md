I have everything I need. Here is the plan.

---

# Phase 1, Steps 6–8 — In-binary `ProtocolLogin` world list, framing, version gate, deployment

---

## 1. Current state

### 1.1 What is already in the tree (steps 1–5, 9)

- `BlackTek::World::Registry` exists and is complete: `/home/josh/Documents/BlackTek-Server/src/world.h:32-87`, implementation `/home/josh/Documents/BlackTek-Server/src/world.cpp:45-237`. `Load` validates and refuses (`src/world.cpp:116-170`), `All()` returns `std::span<const Entry>` (`src/world.h:74`), `Find`/`IsSelf` compare case-insensitively after trimming (`src/world.cpp:26-42, 200-209`), free functions `IsLocalWorld`/`Local` at `src/world.cpp:229-237`.
- Boot loads it on the dispatcher before any listener opens: `src/otserv.cpp:555-586`, with `WORLD_ID` from `config/server.toml` (`src/configmanager.cpp:135`, `config/server.toml:15`). `config/worlds.toml` ships with world 0 named `"BlackTek"`, address `127.0.0.1`, port `7183`, schema `blacktek` (`config/worlds.toml:31-36`).
- The registry's self-check binds `address == [network].ip`, `port == [network].game_port_modern`, `schema == [mysql].database` (`src/otserv.cpp:574-579`, `src/world.cpp:154-170`).
- `Connection` already keeps the world line and exposes it: `GetWorldLine()` at `src/connection.h:81`, member `modern_world_line` at `src/connection.h:122`, sniffed at `src/connection.cpp:162-182`, accumulated byte-at-a-time in `skipWorldNameByte` at `src/connection.cpp:225-272`. Both `std::cout` calls are gone (`src/connection.cpp:257, 269`).
- The wrong-world rejection is live in `ProtocolGame::onRecvFirstMessage` at `src/protocolgame.cpp:536-551`, after `enableXTEAEncryption()` (`:528`) and `setChecksumMode(Sequence)` (`:531-534`).
- `CharacterEntry` / `CharacterList` exist (`src/account.h:13-19`), and `IOLoginData::loginserverAuthentication` assembles the world-tagged list with one `COUNT(*)` plus one `SELECT name` per registry entry, schema-qualified, warning per unreadable world (`src/iologindata.cpp:107-147`). The account-manager entry is emitted per world (`src/iologindata.cpp:118-121`).
- The auth-schema probe and the per-world `players` readability probe are in `mainLoader` (`src/otserv.cpp:377-400, 588-609`); `auth_schema.sql` and `config/database.toml:18`'s `auth_database` exist.
- `src/protocollogin.cpp:91-96` already carries the >255-character clamp and warning against the new `CharacterList`.

### 1.2 What is still the old code

- `src/protocollogin.cpp:98-126` still emits the pre-multi-world list: the `ONLINE_OFFLINE_CHARLIST` two-fake-world branch (`:98-107`), the single-world branch using `SERVER_NAME` / `IP` / `GAME_PORT` (`:108-115`), and the per-character world byte used as an online flag (`:120-124`). `GAME_PORT` is `0` in this fork (`config/server.toml:40`), so the advertised port would be 0.
- `ONLINE_OFFLINE_CHARLIST` lives at `src/configmanager.h:49`, `src/configmanager.cpp:176`, `src/luascript.cpp:2223`, `config/server.toml:58`. A whole-repo grep finds no other reader — no Lua datapack file references it.
- The version gate at `src/protocollogin.cpp:183-186` refuses anything outside `CLIENT_VERSION_MIN/MAX` = 1097..1098 (`src/definitions.h:16-17`); there is a second, earlier gate at `src/protocollogin.cpp:165-168` for `version <= 760`.
- `ProtocolLogin::server_sends_first = false` (`src/protocollogin.h:16`), `protocol_identifier = 0x01` (`:17`), shared with `ProtocolOld` (`src/protocolold.h:15-17`), disambiguated by checksum state in `ServicePort::make_protocol` (`src/server.cpp:122-135`).
- `login_port = 0` (`config/server.toml:39`), so `services->add<ProtocolLogin>` (`src/otserv.cpp:789-792`) and `services->add<ProtocolOld>` (`src/otserv.cpp:815-818`) never run.

### 1.3 How the transport actually frames modern traffic — established by in-repo capture

`harness/captures/mehah1525_login_client.hex` is a real 15.25 mehah session, client→server. This is decisive evidence, not inference:

- Line 2 is `426c61636b54656b0a` = `"BlackTek\n"` — the preamble, raw, unframed.
- Line 3 is the first framed packet: `1b00` `00000000` `05` `0a` `0a00` `f505` … `0000000000`. That decodes as blockCount `0x001b` = 27 → `27*8+4 = 220` body bytes, a 4-byte header of `00000000`, a padding-count byte `05`, then the payload starting `0a` (ClientPendingGame), OS `0a00`, version `f505` = 1525 — and five trailing `00` padding bytes.

Three facts follow, and they are what steps 6–7 rest on:

1. **The client writes `[u16 blockCount][u32 header][u8 paddingCount][payload][padding]` even when the frame is not XTEA-encrypted.** The `"1525"` string and the 64-char asset hash are readable ASCII in that capture, so that frame is plaintext, and it still carries a block-count length and a padding-count byte. This matches `src/connection.cpp:184-191` (`size = size * 8 + CHECKSUM_LENGTH`) and `src/connection.cpp:297` (`skipBytes(CHECKSUM_LENGTH + 2)`).
2. **The 4-byte header is a sequence, starting at 0, and the client does not validate the server's copy of it.** `harness/captures/mehah1525_login_server.hex:2` is the server challenge: `0100` `4703c30c` `01` `1f` `bea15d6a` `8f` `71` — blockCount 1, an *adler32* in the header (written by `src/protocol.cpp:101`), padding count `01`, opcode `0x1F`, timestamp, random, one pad byte `0x71`. The client accepted it while sequenced packets were on. Line 3 of the same file is the server's first encrypted frame with header `01000080` = sequence 1 with the compression high bit (`src/protocol.cpp:106-122`), also accepted.
3. **`0x71` in `ProtocolGame::onConnect` (`src/protocolgame.cpp:742`) is the padding byte**, and the hand-written `0x01` at `:738` is the padding count. The framer's unencrypted-modern branch (`src/protocol.cpp:91-104`) pads with zeros and writes adler + block count but writes *no* padding-count byte — the challenge writer supplies its own.

### 1.4 The three concrete defects that block a 15.25 client on a login port

1. **The preamble is never consumed.** `src/connection.cpp:162` is guarded by `protocol and protocol->usesModernFraming()`; on a `server_sends_first = false` port `protocol` is null at the first header read (`src/server.cpp:103-107` only pre-builds the protocol for single-socket ports), so the branch is skipped and the preamble bytes become a length header at `src/connection.cpp:184`.
2. **Even with a protocol in hand, the sniff cannot represent an empty world line.** `src/connection.cpp:167` requires `b0` to be printable ASCII; the login connection's preamble is a bare `"\n"` (0x0A) because the client's `m_worldName` is empty until `Game::loginWorld` runs. `0x0A` is also a perfectly ordinary low byte of a block-count length header (10 blocks), so no two-byte sniff can disambiguate it.
3. **The modern first frame's padding is never trimmed, and `ProtocolLogin` locates its token block from the end of the message.** `src/connection.cpp:209` sets `length = size + HEADER_LENGTH`, which includes the client's trailing padding; `Protocol::onRecvMessage`'s trim (`src/protocol.cpp:52-60`) only runs for frames it decrypts, and the first frame bypasses `onRecvMessage` entirely (`src/connection.cpp:298` calls `onRecvFirstMessage` directly). `src/protocollogin.cpp:210` does `msg.skipBytes((msg.getLength() - 128) - msg.getBufferPosition())` to find the trailing RSA authenticator block — under modern framing that lands `paddingCount` bytes late and `RSA_decrypt` fails, producing "Invalid authentication token." on every login.

### 1.5 Port 7171 in this tree

- `src/configmanager.cpp:156` defaults `status_port` to `7171`; `config/server.toml:45` overrides it to `7184`.
- `src/configmanager.cpp:145` defaults `login_port` to `7171`; `config/server.toml:39` sets it to `0`.
- `docker-compose.yaml:66-68` maps host `7171/7172/7173`; `README.md:76` already records the compose file as stale and unable to serve a world.
- If two services land on one port, `ServiceManager::add` (`src/server.h:131-136`) prints to `std::cout` and returns `false` — the server keeps booting with one of the two services silently dead, and *which* one dies depends on registration order (`src/otserv.cpp:789, 812, 815`).
- `ProtocolStatus` is `server_sends_first = false`, identifier `0xFF` (`src/protocolstatus.h:14-16`), so it can legally share a port with the *legacy* `ProtocolLogin` but not with any single-socket protocol (`src/server.cpp:234-236`).

---

## 2. Constraints and invariants

**Must keep working:**

- The validated 15.25 game path. `ProtocolGameModern` (`src/protocolgame.h:560-573`), `ProtocolGame::shared_modern_layout` (`src/protocolgame.h:551-553`), and the dual-listener refusal (`src/otserv.cpp:802-806`) are untouched or moved verbatim. The challenge bytes at `src/protocolgame.cpp:738-742` are **not** changed: `0x71` is the pad by strong inference, not by proof, and it is the first thing a client parses.
- The external `opentibiabr/login-server` path (`README.md:189-190`, `docker-compose.yaml:38-59`, `src/iologindata.cpp:152-177`) stays a live, unmodified fallback.
- `src/definitions.h:16-18` is not touched. It still feeds `src/protocolstatus.cpp:98, 209`, `src/protocolold.cpp:37, 58`, `src/luascript.cpp:5837-5839`, `src/protocolgame.h:529`, `src/otserv.cpp:126`.
- The legacy login pair (`ProtocolLogin` + `ProtocolOld` sharing a port via `src/server.cpp:122-135`) must remain constructible for a legacy `game_port` deployment.
- 15.25-only: no `game_port` revival, no second game-protocol generation.
- No new `virtual`. New per-protocol transport knowledge follows the existing non-virtual pattern: a protected setter plus a public `[[nodiscard]]` getter on `Protocol`, exactly like `setTransportGeneration` / `usesModernFraming` (`src/protocol.h:45-47, 81-83`).
- New work nests under `BlackTek::` (`CONTRIBUTING.md:38-46`); `xtea` and the other accepted top-level namespaces are not renamed.

**Client-side constants this repository cannot change (established evidence, from the brief):**

- A 15.25 client reaches in-binary `ProtocolLogin` **only on port 7171**; any other port at protocol ≥ 1281 goes to HTTP login.
- The client sends `"<worldName>\n"` on **every** connection at version ≥ 1200, login included, and that name is empty at startup.
- The 0x64 charlist layout for `> 1010` is: `worldsCount u8`, then per world `{ id u8, name String, ip String, port u16, previewState u8 }`, then `charactersCount u8`, then per character `{ worldId u8, name String }` — exactly what `src/protocollogin.cpp:101-125` already writes, modulo the fake worlds.

**Invariants this design relies on and states:**

1. The registry is written once in `mainLoader` (`src/otserv.cpp:581`) and read afterwards only from the dispatcher and the connection strand; no accept handler can run before `mainLoader` returns (`src/otserv.cpp:432-439`). No synchronisation is added anywhere in steps 6–8.
2. A modern connection's first frame is the only modern frame whose length is never trimmed of padding. Fixing that is a transport-layer invariant, not a login-protocol workaround: **by the time a protocol sees a message, `getLength()` is the end of the real payload.**
3. On a login connection the world line is *mandatory but meaningless*. It is consumed and logged, never used to accept or reject.

---

## 3. Proposed design

### 3.1 `ProtocolLoginModern` — the port fixes the generation, exactly as it does for the game

New class in `src/protocollogin.h`, mirroring `ProtocolGameModern` (`src/protocolgame.h:560-573`):

```cpp
// Same login protocol, listening on the port a 15.25 client hardcodes. The
// client opens with a plaintext world-name line and then frames everything the
// modern way, so the generation is fixed by the port rather than sniffed - and
// the port is server_sends_first so Connection is holding the right protocol
// before the first byte arrives, which is what makes consuming that line
// possible at all.
class ProtocolLoginModern final : public ProtocolLogin
{
	public:
		// static protocol information
		enum {server_sends_first = true};
		enum {protocol_identifier = 0}; // the port decides; make_protocol never runs
		enum {use_checksum = true};
		static const char* protocol_name() {
			return "modern login protocol";
		}

		explicit ProtocolLoginModern(Connection_ptr connection) : ProtocolLogin(std::move(connection)) {
			setTransportGeneration(BlackTek::Network::TransportGeneration::Modern);
			setWorldLineRequired(true);
		}
};
```

Mechanisms, not taste:

- `server_sends_first = true` is what makes `ServicePort::onAccept` take the `connection->accept(service->make_protocol(connection))` branch (`src/server.cpp:103-104`), so `Connection::protocol` is non-null before the first read. Nothing is actually sent first: `ProtocolLogin` does not override `Protocol::onConnect` (`src/protocol.h:30`), so the posted `onConnect()` (`src/connection.cpp:99`) is a no-op. The flag here means "the protocol is known from the port", which is precisely how `ProtocolGameModern` already uses it.
- `protocol_identifier = 0` because `ServicePort::make_protocol` (`src/server.cpp:122-135`) never runs for a single-socket port. The client's `0x01` opcode byte is consumed by the framing layer instead (`src/connection.cpp:297`), landing the cursor exactly on the OS `u16` that `ProtocolLogin::onRecvFirstMessage` reads first (`src/protocollogin.cpp:150`).
- `ProtocolLogin` is deliberately **not** made `final` — it already is not — and gains no members. All the login logic stays in one place; the subclass is a two-line transport tag.
- `setChecksumMode` is **not** called. Leaving it at the `Adler32` default (`src/protocol.h:113`) keeps `src/protocol.cpp:112-117` from ever deflating a login response. The client's compression behaviour on a login connection has no capture behind it, and the charlist is small; the sequence header is still written unconditionally by `src/protocol.cpp:121`, which is what the client reads. cpp-coder must not add a `setChecksumMode` call here.

### 3.2 Mandatory world-line consumption, in `Connection`, without touching the game path

`src/protocol.h` gains one flag beside the existing transport knobs, named to sit with `usesModernFraming()` rather than in namespace-scope `PascalCase` (`CONTRIBUTING.md:337` governs namespace scope; this is a member on a class whose entire surface is camelCase, and consistency inside the type wins):

```cpp
		// The login protocol's client opens with a plaintext world-name line that
		// is normally EMPTY, so its first byte is the '\n' itself - which no
		// two-byte sniff can tell from a length header's low byte. Connection is
		// told to consume a line instead of guessing at one.
		[[nodiscard]] bool requiresWorldLine() const noexcept {
			return world_line_required;
		}
```

protected, beside `setTransportGeneration` (`src/protocol.h:81-83`):

```cpp
		void setWorldLineRequired(bool value) noexcept {
			world_line_required = value;
		}
```

private: `bool world_line_required = false;` (snake_case per `CONTRIBUTING.md:334`, matching `protocol_profile` / `client_version` at `src/protocolgame.h:539, 549`).

`Connection::accept(Protocol_ptr)` (`src/connection.cpp:96-102`) branches once:

```cpp
void Connection::accept(Protocol_ptr protocol)
{
	this->protocol = protocol;
	g_dispatcher.addTask(createTask([=]() { protocol->onConnect(); }));

	// A login-protocol client opens with a world-name line whose first byte is
	// usually the terminator itself, so there is nothing to sniff. Read the line
	// up front, one byte at a time, and let accept() start the header read once
	// it ends. parseHeader's sniff is left alone for game connections, where the
	// line is optional in practice and the framing path is the validated one.
	if (this->protocol->requiresWorldLine())
	{
		modern_world_name_consumed = true;
		readWorldLineByte();
		return;
	}

	accept();
}
```

`Connection::skipWorldNameByte` is renamed `readWorldLineByte` (`src/connection.h:86`, `src/connection.cpp:225`, call site `src/connection.cpp:178`) — the name has been stale since it started keeping the bytes at `src/connection.cpp:262`, and all three sites are inside the functions this step edits, so it is opportunistic migration in the sense of `CONTRIBUTING.md:233`. Its body is unchanged: the 32-byte cap (`src/connection.cpp:227`), the per-byte read timer, the `'\n'` terminator calling `accept()` (`src/connection.cpp:255-259`). Entering it from `accept(Protocol_ptr)` with `modern_line_skipped == 0` gives a 32-byte cap on the whole line; entering it from the sniff still starts at 2 (`src/connection.cpp:177`).

Why the empty-line case falls out for free: the very first byte read is `'\n'`, `modern_world_line` stays empty, `accept()` runs, and `Connection::GetWorldLine()` returns `""` — which `ProtocolGame`'s check already treats as "announced nothing" (`src/protocolgame.cpp:545`). No special case anywhere.

Why the game path is not switched to `requiresWorldLine`: `harness/modern_client.py:121` sends a preamble, and a real client ≥ 1200 does too, but a client that sends none would hang until `CONNECTION_READ_TIMEOUT` (`src/connection.h:15`) instead of falling through to framing at `src/connection.cpp:181`. Changing the one validated path in the repository to fix the unvalidated one is the wrong trade. The asymmetry is deliberate and commented.

Residual, stated: a legacy client dialling the modern login port now gets closed by the 32-byte cap or the 30-second read timeout instead of a "wrong protocol" message. It could not have played on a `game_port_modern`-only server anyway (`resolveProfile` rejects 1097 against `Modern`, `src/protocolprofile.h:245-255`).

### 3.3 Trim the modern first frame's padding, in the transport layer

`src/connection.cpp:288-304`, modern branch, `not receivedFirst` case, replacing the single `skipBytes(CHECKSUM_LENGTH + 2)` at `:297`:

```cpp
		if (not receivedFirst)
		{
			receivedFirst = true;

			// First frame layout: sequence u32, padding count u8, then the
			// protocol/opcode byte legacy also skips. This is the one modern
			// frame nothing trims - onRecvMessage only trims what it decrypts,
			// and the first frame is plaintext - so trim it here. Without this,
			// anything locating a field from the END of the message (the login
			// protocol's trailing RSA authenticator block) reads into padding.
			constexpr uint16_t firstFrameOverhead = NetworkMessage::HEADER_LENGTH + NetworkMessage::CHECKSUM_LENGTH + 2;

			if (msg->getLength() < firstFrameOverhead)
			{
				close(FORCE_CLOSE);
				return;
			}

			msg->skipBytes(NetworkMessage::CHECKSUM_LENGTH);

			const uint8_t paddingAmount = msg->getByte();
			const uint16_t framedLength = msg->getLength();

			if (framedLength < firstFrameOverhead + paddingAmount)
			{
				close(FORCE_CLOSE);
				return;
			}

			msg->setLength(static_cast<NetworkMessage::MsgSize_t>(framedLength - paddingAmount));
			msg->skipBytes(1); // protocol identifier / first opcode
			protocol->onRecvFirstMessage(*msg);
		}
```

- The first guard exists because `msg->getByte()` at position 6 would otherwise read an indeterminate byte of `NetworkMessage::buffer` (`src/networkmessage.h:153`, default-constructed, not zeroed) when the client declares `blockCount == 0`; `Connection::parseHeader`'s bounds check (`src/connection.cpp:193`) permits `size == 4`.
- The second guard exists because `setLength` takes `MsgSize_t` (`uint16_t`, `src/networkmessage.h:19, 108`) and an unguarded subtraction would wrap, after which `canRead`'s `info.length + 8` test (`src/networkmessage.h:161`) permits reads far past the payload. This is a hardening requirement introduced *by* the trim, not optional.
- Behaviour on the game path is unchanged: `ProtocolGame::onRecvFirstMessage` reads every field forward from the cursor and only consults the tail via the OTCv8 probe (`src/protocolgame.cpp:640-647`), where today the probe reads zero padding bytes as `probeLength == 0` and after the trim `canRead` fails and `get<uint16_t>()` returns 0 — the same `!= 5` outcome. Verified against both `harness/modern_client.py:159-161` (padding zeros) and `harness/captures/mehah1525_login_client.hex:3` (padCount 5, five trailing `00`).

### 3.4 Version gate: `resolveProfile`, and `definitions.h` stays put

**Confirmed against the current tree: this is still the right call.** `BlackTek::Network::resolveProfile` (`src/protocolprofile.h:245-255`) is generation-aware, and the `Legacy1098` band is exactly `1097..1098` (`src/protocolprofile.h:196-197`) — byte-identical to `CLIENT_VERSION_MIN/MAX` (`src/definitions.h:16-17`). So a legacy login listener accepts exactly the same set it accepts today, while the modern one accepts `1520..1525` via `Modern1525` (`src/protocolprofile.h:224-238`). `allowedProtocolVersions()` (`src/protocolprofile.h:259-271`) builds the refusal text from the registry so it cannot drift. `src/definitions.h` keeps feeding `src/protocolstatus.cpp:98, 209` and `src/protocolold.cpp:37, 58`, so its own comment (`src/definitions.h:13-15`) stays substantially true.

Replacing `src/protocollogin.cpp:183-186`, keeping the position (after `enableXTEAEncryption()` at `:180`, so the refusal is framed and encrypted the way the client expects):

```cpp
	// The port the client walked in through fixes the framing generation; the
	// version it just claimed has to land in a profile of that same generation
	// or there is nothing to talk about. Same registry, same rule and same
	// message as the game path (protocolgame.cpp:467-473).
	const auto generation = usesModernFraming()
		? BlackTek::Network::TransportGeneration::Modern
		: BlackTek::Network::TransportGeneration::Legacy;

	if (not BlackTek::Network::resolveProfile(version, generation))
	{
		disconnectClient(fmt::format("Only clients with protocol {:s} allowed!", BlackTek::Network::allowedProtocolVersions()), version);
		return;
	}
```

The earlier `version <= 760` gate (`src/protocollogin.cpp:165-168`) fires *before* XTEA is up, where no readable modern refusal exists — the modern framer writes no padding-count byte for an unencrypted frame (`src/protocol.cpp:91-104`; the challenge hand-writes its own at `src/protocolgame.cpp:738`). So:

```cpp
	// A pre-XTEA refusal has to be framed the way the client reads it, and the
	// modern framer writes no padding-count byte for an unencrypted frame - so
	// on a modern connection this case just closes. Every version a real client
	// can claim is refused readably by the profile gate below, after XTEA is up.
	if (version <= 760)
	{
		if (usesModernFraming())
			disconnect();

		else
			disconnectClient(fmt::format("Only clients with protocol {:s} allowed!", CLIENT_VERSION_STR), version);

		return;
	}
```

Legacy behaviour is preserved exactly; the modern branch is unreachable for any coherent client.

### 3.5 The world list and charlist wire (step 6)

`src/protocollogin.cpp:98-126` is replaced. `src/protocollogin.cpp:88-96` (the `0x64` byte, the `size` clamp and its warning) stays as it is.

```cpp
	const auto worlds = BlackTek::World::Registry::GetInstance().All();

	// the wire carries both counts in one byte each
	const uint8_t worldCount = std::min<size_t>(std::numeric_limits<uint8_t>::max(), worlds.size());

	if (worlds.size() > worldCount) {
		BlackTek::Console::Net::Warn("ProtocolLogin::getCharacterList: the registry declares {:d} worlds, but the world list carries at most {:d}; the remainder is not shown.", worlds.size(), worldCount);
	}

	output->addByte(worldCount);

	for (const auto& world : worlds | std::views::take(worldCount))
	{
		output->addByte(world.id);
		output->addString(world.name);
		output->addString(world.address);
		output->add<uint16_t>(world.port);
		output->addByte(0); // preview state
	}

	output->addByte(size);

	for (const auto& character : account.characters | std::views::take(size))
	{
		output->addByte(character.world);
		output->addString(character.name);
	}
```

- `std::views::take` rather than an index loop with a `continue`, per `CONTRIBUTING.md:12-34`. Requires `<ranges>` in the angle-bracket include block and `"world.h"` in the quoted block (`CONTRIBUTING.md:437-449`); `src/account.h:8` already pulls `world.h` transitively, but the direct dependency is spelled.
- The advertised address and port come from the registry `Entry` (`src/world.h:20-27`), never `ConfigManager::GAME_PORT` — and the registry has already proved at boot that its own row equals `[network].ip` and `[network].game_port_modern` (`src/world.cpp:154-164`).
- The world count clamp mirrors the character clamp. The registry permits up to 256 distinct ids (`src/world.cpp:116, 124-128`), and an unclamped `static_cast<uint8_t>(256)` would write `0` and silently produce an empty world list.
- `ONLINE_OFFLINE_CHARLIST` is **deleted**, not bypassed: `src/configmanager.h:49`, `src/configmanager.cpp:176`, `src/luascript.cpp:2223`, `config/server.toml:58`, and both branches. The world-id byte reverts to meaning a world id. Nothing else reads it, in C++ or in `data/`.
- `g_game.getPlayerByName` disappears from this file; `game.h` stays included for `getGameState()` (`:36, 41, 145`) and `getMotdNum()` (`:81`).

### 3.6 Listener wiring and the port-7171 collision

**The server must refuse to boot on a login-port collision.** Mechanism, not preference: `ServiceManager::add`'s existing failure is a `std::cout` line plus `return false` (`src/server.h:131-136`), which leaves the process running with either the status listener or the login listener silently dead, and *which one* depends on the order of `src/otserv.cpp:789, 812, 815`. That is the worst available outcome — a server that looks healthy while players cannot log in or monitoring lies. The precedent is the dual-listener refusal at `src/otserv.cpp:802-806`.

`src/otserv.cpp:784-818` is restructured. The existing refusal text and `ProtocolGame::setSharedModernLayout(true)` move verbatim; nothing is weakened.

```cpp
	const auto gamePort = g_config.GetNumber(ConfigManager::GAME_PORT);
	const auto modernPort = g_config.GetNumber(ConfigManager::GAME_PORT_MODERN);
	const auto loginPort = g_config.GetNumber(ConfigManager::LOGIN_PORT);
	const auto statusPort = g_config.GetNumber(ConfigManager::STATUS_PORT);

	// shared spectator payloads are built once for every client, so they can
	// only follow one generation; serving both ports at once is not supported
	// since the legacy listener was retired
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
		services->add<ProtocolGame>(static_cast<uint16_t>(gamePort));

		if (loginPort != 0)
		{
			services->add<ProtocolLogin>(static_cast<uint16_t>(loginPort));
			services->add<ProtocolOld>(static_cast<uint16_t>(loginPort));
		}
	}

	// Modern (13.40+) clients handshake on a separate port; see ProtocolGameModern
	if (modernPort != 0)
	{
		services->add<ProtocolGameModern>(static_cast<uint16_t>(modernPort));
		ProtocolGame::setSharedModernLayout(true);

		if (loginPort != 0)
		{
			services->add<ProtocolLoginModern>(static_cast<uint16_t>(loginPort));
		}
	}

	// OT protocols
	services->add<ProtocolStatus>(static_cast<uint16_t>(statusPort));
```

- The legacy `ProtocolLogin` + `ProtocolOld` pair keeps its shared port and its `make_protocol` checksum disambiguation (`src/server.cpp:122-135`) on a legacy `game_port` deployment. It cannot coexist with `ProtocolLoginModern`, because `ServicePort::add_service` refuses any service beside a single-socket one (`src/server.cpp:234-236`) — which is correct: a 15.25-only server has no legacy clients to redirect.
- `status_port` vs `game_port_modern` is a pre-existing collision class this change does not address; out of scope, noted.

`config/server.toml:39` changes from `login_port = 0` to `login_port = 7171` with a comment stating that 7171 is a client-side constant (any other port at protocol ≥ 1281 sends the client to HTTP login instead) and that `status_port` must therefore stay off 7171. `status_port` is already `7184` (`config/server.toml:45`), so the shipped config has no collision.

**Deployment consequence, stated up front rather than discovered:** 7171 is not configurable client-side, so N worlds on one host cannot each run a login listener unless each binds its own address (`bind_only_global_address = true` plus distinct `[network].ip`, honoured at `src/server.cpp:161-171`). The recommended arrangement instead is **one login listener for the deployment**: the world list is identical from every world by construction (the registry is the same file everywhere, `config/worlds.toml:1`), so one world sets `login_port = 7171` and every other world sets `login_port = 0`. Failover is flipping the key on another world. This is also why plan alternative D (a dedicated login process) stays rejected — no new process, no new single point of failure beyond the one port.

### 3.7 Coexistence with the external webservice, and what G2 becomes

**Both can be live at once, and they cannot be confused.** They are different transports on different ports: HTTP on the webservice's own port (`docker-compose.yaml:42`) versus TCP 7171 in-binary. The *client's configured port* selects the path — 7171 means in-binary, anything else means HTTP login. Nothing in the server chooses.

They also cannot corrupt each other, because they converge through different, already-distinguished credentials:

- The in-binary path hands the client the legacy four-field bundle `"account\npassword\ntoken\nticks"` (`src/protocollogin.cpp:85-86`), which `ProtocolGame::onRecvFirstMessage` classifies as *not* an opaque session key (`src/protocolgame.cpp:574-580`) and routes to `IOLoginData::gameworldAuthentication` (`src/protocolgame.cpp:696-698`). It never touches `account_sessions`.
- The webservice path hands over an opaque key with no `'\n'`, routed to `IOLoginData::sessionKeyAuthentication` (`src/iologindata.cpp:152-177`).

**What happens if they disagree**, precisely:

1. **Different world *names*.** The webservice's `SERVER_NAME` (`docker-compose.yaml:51`) becomes the client's `m_worldName` and therefore the preamble on the game connection. If it differs from that world's `worlds.toml` `name`, every HTTP-login player is refused by the live check at `src/protocolgame.cpp:545-550`. In-binary players are unaffected. This is a total outage for the HTTP path and the single most important deployment rule in step 8.
2. **Different address/port.** HTTP players dial whatever `SERVER_IP`/`SERVER_PORT` says; in-binary players dial the registry's row. The registry self-check (`src/world.cpp:154-164`) proves the registry agrees with the *process*, not with the webservice — nothing in-process can verify the webservice, and the design does not pretend otherwise.
3. **Different world *sets*.** The two menus differ. No breakage; both lists resolve against the same schemas.

**G2 is now resolved for the in-binary path, and only for it.** Because the client sets `m_worldName` from the charlist the login server returned, once this server's own `ProtocolLogin` serves the list, the name echoed on the game connection *is* this server's `worlds.toml` `name` — so the step-3 check at `src/protocolgame.cpp:545` compares a string this server issued against itself and cannot false-reject. G2 survives only as a webservice-deployment question: `SERVER_NAME` must equal the world's registry `name`, with only case and surrounding whitespace tolerated (`src/world.cpp:26-42`). Today they already agree — `config/worlds.toml:33` is `"BlackTek"` and `docker-compose.yaml:51` is `SERVER_NAME=BlackTek`, matching `harness/modern_client.py:121`.

### 3.8 Error strategy, concurrency, and what is explicitly *not* added

- **Transport layer (`Connection`)**: no exceptions beyond the existing `boost::system::system_error` catches; every malformed-frame path is `close(FORCE_CLOSE)`. The two new guards in 3.3 follow that.
- **Login protocol**: no exceptions; every failure is a framed `disconnectClient` plus, where it is the server's fault, a `BlackTek::Console::Net` line (`CONTRIBUTING.md:201-234`). Per-world charlist failure already degrades to "that world has no characters" (`src/iologindata.cpp:130-133`).
- **Boot**: `startupErrorMessage` refusals, matching `src/otserv.cpp:802-806` and `src/otserv.cpp:581-585`.
- **Threading**: unchanged. `getCharacterList` runs on the dispatcher (posted at `src/protocollogin.cpp:218-221`), the registry is immutable by then, and `All()` returns a span over a `std::vector` that is never mutated after `mainLoader`. No atomics, no mutex, no `jthread`, no new threads.
- **Not added**: no `LoginPacketLayout` struct mirroring `GameLoginLayout`. One version band speaks this protocol and one field offset is in question (3.6 of section 6); a data-driven layout table for a single row is speculative generality. No `setChecksumMode` on the login protocol. No world check on the login connection's world line.

---

## 4. Alternatives considered

**A. Keep `server_sends_first = false` and sniff the preamble before `make_protocol`.** Rejected on a mechanism: `Connection::parsePacket` only reaches `make_protocol` after a *successful header parse and body read* (`src/connection.cpp:331`), and the preamble corrupts that header. To sniff first you would have to buffer bytes with no protocol to tell you which framing to expect — and on a port that at that moment could be legacy or modern, the ambiguity is unresolvable (a `'\n'` is a legal length low byte). `server_sends_first` moves the answer to configuration, which is exactly how `ProtocolGameModern` already solved the identical problem (`src/protocolprofile.h:18-22`).

**B. Widen the existing two-byte sniff to accept a leading `'\n'`.** Rejected: on the *game* port `0x0A` is a legitimate block-count low byte (10 blocks = an 84-byte frame), so the widened sniff would misread real game frames as empty preambles. And on the login port the sniff would have already consumed the first byte of the real length header, requiring a second read-continuation state to splice it back. The byte-at-a-time entry in 3.2 is strictly simpler and confines the change to connections that opt in.

**C. Make `requiresWorldLine()` true for `ProtocolGameModern` too, and delete the sniff.** Rejected on blast radius: it would make a missing preamble a 30-second hang on the one protocol path in this repository that is verified end-to-end against a real client (`STATUS.md:217-238`). The sniff's fall-through at `src/connection.cpp:181` is load-bearing for anything that does not announce a world.

**D. Fix the padding trim inside `ProtocolLogin` instead of `Connection`.** Rejected: the padding count is a framing field (`src/protocol.cpp:52-60` already trims it for every other modern frame), and leaving the first frame untrimmed keeps a latent trap for every future reader that measures from the end of a message. Fixing it once in the transport layer makes "`getLength()` is the payload end" an invariant instead of a per-protocol obligation.

**E. Unify the padding-count byte into `Protocol::onSendMessage`'s unencrypted-modern branch and drop the hand-written `0x01`/`0x71` from the challenge.** Tempting — it would also fix `ProtocolGame`'s pre-XTEA refusal (`src/protocolgame.cpp:471` currently sends a mis-framed message to a modern client) — and rejected for now: it changes one discarded byte of the *first* frame a real client parses (`0x71` → `0x00`, `harness/captures/mehah1525_login_server.hex:2`). The evidence that `0x71` is pure padding is an inference from the 8-byte body and the `01` padding count, not a proof, and the cost of being wrong is that no client can log in at all. Recorded as a separate, independently testable follow-up with its own capture, not smuggled into this work.

**F. Replace the version gate with a widened `CLIENT_VERSION_MIN/MAX` in `src/definitions.h`.** Rejected by constraint and by mechanism: the brief forbids it, and `src/definitions.h:13-15` already declares those constants are not the authority on who may connect. `resolveProfile` additionally enforces generation/port agreement, which a pair of integers cannot.

**G. Drop `ProtocolOld` entirely now that the login port is single-socket.** Rejected as out-of-scope scope creep: it still serves a legacy `game_port` deployment through the checksum disambiguation at `src/server.cpp:122-135`, and the branch in 3.6 keeps it reachable there at zero cost.

**H. Let `ServiceManager::add` report the 7171 collision as it does today.** Rejected: its failure mode is a `std::cout` and a disabled service (`src/server.h:132-134`), order-dependent between `src/otserv.cpp:789/812/815`, on a port the client cannot be pointed away from. A boot refusal converts a silent production outage into a startup message naming both keys.

**I. Run one login listener per world on distinct ports.** Impossible, not merely undesirable: port 7171 is hardcoded client-side. Hence the one-listener-per-deployment or one-IP-per-world guidance in 3.6.

---

## 5. Migration plan

Each step is one `cpp-coder` dispatch. Steps 6 and 7A are independent of each other; 7B depends on 7A; 7C depends on 7B.

---

**Step 6 — In-binary world list and charlist wire.**
*Scope:* `src/protocollogin.cpp:98-126` rewritten per 3.5, plus `<ranges>` and `"world.h"` includes. `ONLINE_OFFLINE_CHARLIST` deleted from `src/configmanager.h:49`, `src/configmanager.cpp:176`, `src/luascript.cpp:2223`, `config/server.toml:58`.
*Blast radius:* the login protocol's response payload, plus one Lua-visible config enumerator. No framing, no listener, no SQL. `login_port` is still `0`, so this is observably inert until step 7C.
*Done when:* the charlist writer emits `worldCount`, then one `{ id, name, address, port, 0 }` tuple per registry entry in registry order, then the character count, then one `{ worldId, name }` pair per character; `grep -r ONLINE_OFFLINE_CHARLIST src/ config/ data/` returns nothing; `src/protocollogin.cpp` no longer references `ConfigManager::GAME_PORT` or `g_game.getPlayerByName`.
*Deliberate behavioural change:* `online_offline_charlist` is removed, along with the `configKeys` enumerator Lua could read. Settled by the brief.

---

**Step 7A — Transport prerequisites: world-line mode and first-frame padding trim.**
*Scope:* `src/protocol.h` — `requiresWorldLine()` getter, `setWorldLineRequired()` protected setter, `bool world_line_required = false;` member. `src/connection.h` — rename `skipWorldNameByte` → `readWorldLineByte` (`:86`). `src/connection.cpp` — the `accept(Protocol_ptr)` branch (`:96-102`), the rename at the definition (`:225`) and the call site (`:178`), and the modern first-frame trim plus its two guards (`:288-304`).
*Blast radius:* **every modern game connection.** This is the highest-risk step of the three; the trim and the guards run on the validated path. The `accept` branch is dead until 7B, since nothing sets the flag yet.
*Done when:* `harness/modern_client.py` still logs in and walks against `game_port_modern` unchanged; a real 15.25 client still enters the world; a frame declaring `blockCount == 0`, and a frame whose declared padding exceeds its payload, both close the connection instead of reading past the payload; no `std::cout` is introduced.
*Behavioural change:* none intended on the game path. If the harness or the real client regresses here, stop — do not proceed to 7B.

---

**Step 7B — `ProtocolLoginModern` and the version gate.**
*Scope:* `src/protocollogin.h` — the new `ProtocolLoginModern` class per 3.1, plus the `#include "protocolprofile.h"` it needs (or via `protocol.h:12`). `src/protocollogin.cpp` — the `version <= 760` branch (`:165-168`) and the `resolveProfile` gate replacing `:183-186`, both per 3.4. `src/protocollogin.cpp:23` unchanged.
*Blast radius:* the login protocol only. The legacy `ProtocolLogin` listener's accepted version set is unchanged (`Legacy1098` band equals `CLIENT_VERSION_MIN/MAX`). `src/definitions.h` untouched.
*Done when:* a legacy `ProtocolLogin` connection still refuses anything outside 1097..1098 with the same text shape; a `ProtocolLoginModern` connection accepts 1520..1525 and refuses others with `allowedProtocolVersions()`; `ProtocolLoginModern` sets `Modern` generation and the world-line flag in its constructor and adds no other member.
*Behavioural change:* the refusal message on the login port now lists every declared profile rather than `"10.98"`. Intentional, matching `src/protocolgame.cpp:471`.

---

**Step 7C — Listener wiring, collision refusal, and turning the port on.**
*Scope:* `src/otserv.cpp:784-818` restructured per 3.6 (the existing dual-listener refusal text and `setSharedModernLayout(true)` move verbatim), `#include "protocollogin.h"` already present. `config/server.toml:37-39` — `login_port = 7171` plus the comment explaining 7171 is a client-side constant.
*Blast radius:* boot and listener set. The server now opens a TCP listener it did not open before.
*Done when:* a boot with `login_port == status_port` refuses with a message naming both keys and both values, and does not start; a boot with the shipped config opens `7171` (login), `7183` (modern game) and `7184` (status) and prints all three at `src/otserv.cpp:666-668`; a legacy config (`game_port != 0`, `game_port_modern = 0`, `login_port != 0`) still registers `ProtocolLogin` and `ProtocolOld` on the same port with no `ServiceManager::add` error line.
*Deliberate behavioural change:* `login_port` ships enabled. Every deployment gains a listener on 7171 and must not have anything else there. Owner-visible; call it out in the commit message.

---

**Step 7D — `harness/login_client.py`, the scripted login-protocol client.**
*Scope:* one new Python file in `harness/`, modelled on `harness/modern_client.py` and reusing `xtea_apply` from `harness/packet_diff.py` (`harness/modern_client.py:30-31`) and `read_modern_frame`/`decrypt_modern` (`:48-67`). It connects to 7171, sends `b"\n"`, builds the login packet per `src/protocollogin.cpp:150-216` (OS `u16`, version `u16`, 17 pre-RSA bytes, a 128-byte RSA block holding `0x00`, the four XTEA words, account and password strings, and a second 128-byte RSA block for the token), frames it as `[u16 blocks][u32 0][u8 padCount][0x01][payload][pad]`, then reads one modern frame, XTEA-decrypts it, and asserts the response: optional `0x14` MOTD, `0x28` session key, `0x64` charlist with `worldCount`, per-world tuples, `charCount`, per-character `{worldId, name}`.
*Blast radius:* tooling only, no C++.
*Done when:* run against a server with a two-world `config/worlds.toml`, it prints both worlds with their registry name/address/port and every character with its own world byte, and exits 0; run with a wrong password it reports the `0x0B` refusal.

---

**Step 8 — Deployment documentation for N worlds.**
*Scope:* one new document, `docs/deployment/multi-world.md`. No code. `Dockerfile`, `docker-compose.yaml` and `README.md` port lines are explicitly **not** touched (`README.md:76` already records them as stale).
Contents, all of it already determined by the code cited above:
- One working directory per world, because configuration is loaded by relative path (`README.md:184-185`) and the map/assets are read relative to it.
- `config/worlds.toml` deployed **byte-identical** to every world (`config/worlds.toml:1`), with the field reference already in that file's header (`:15-25`).
- Per-world `config/server.toml`: distinct `[world].id`, `[network].game_port_modern`, and `[network].ip` where hosts differ; the registry refuses a boot on any disagreement (`src/world.cpp:154-170`).
- Per-world `config/database.toml`: distinct `[mysql].database`; identical `[mysql].auth_database` (`config/database.toml:9-18`).
- Per-world `key.pem` — loaded from the working directory (`src/otserv.cpp:540`). Worlds may share the same key file content; each directory needs a copy.
- Ports: 7171 login (**client-side constant**), the world's `game_port_modern`, `status_port`. The one-login-listener-per-deployment recommendation and the per-IP alternative from 3.6, including the `bind_only_global_address` requirement (`src/server.cpp:161-171`).
- MySQL: one instance for every world schema (the cross-world charlist is one connection, `src/iologindata.cpp:107-112`); `SELECT` granted to the login-serving user on every world's schema, which the boot probe warns about per world (`src/otserv.cpp:393-399`); `auth_schema.sql` run once for the auth schema and once per world for its views, which the boot probe refuses on (`src/otserv.cpp:345-353`).
- The webservice rule from 3.7: if an `opentibiabr/login-server` instance is also deployed, its `SERVER_NAME`/`SERVER_IP`/`SERVER_PORT` must equal that world's `worlds.toml` row, or every HTTP-login player is refused by `src/protocolgame.cpp:545-550`.
- The migration rule already recorded in plan §3.2: never `ALTER` a hoisted table from a world process.
*Done when:* two worlds boot side by side on one host from the document alone, each refuses the other's world name, and a client on 7171 sees both worlds and the right characters under each.

---

## 6. Risks and open questions

**Q1 — Does the 15.25 client's *login* packet use the same 17 pre-RSA bytes that `src/protocollogin.cpp:153-157` skips?**
The layout being skipped is `clientVersion u32` + three 4-byte signature/revision fields + `previewState u8` = 17, which matches the modern *game* packet's shape as captured (`harness/captures/mehah1525_login_client.hex:3`). But the login protocol is a different client module and its field set at 1525 is not in this repository. If it is wrong, `Protocol::RSA_decrypt` (`src/protocollogin.cpp:170`) fails and the client gets a silent close.
*Resolve by:* running `harness/capture_proxy.py` between a real client and the login port after step 7C, then `harness/packet_diff.py --decode` on the client-side file; count the bytes between the version `u16` and the `00` byte that opens the RSA block. *Fallback if it differs:* one constant in one place. This does **not** justify a `LoginPacketLayout` table for a single version band.

**Q2 — Does the client expect the login connection's frames to be framed exactly like the game connection's?**
Everything points to yes, and the chain is capture-backed: the client writes `[blockCount][4-byte header][padCount][payload][pad]` even for an unencrypted frame (`harness/captures/mehah1525_login_client.hex:3`); sequence takes precedence over checksum in its writer (that frame's header is `00000000`, not an adler, while `GameProtocolChecksum` was on); and it accepts a server frame whose 4-byte header is an adler while sequenced (`harness/captures/mehah1525_login_server.hex:2`), so it does not validate the value. `Protocol::onConnect` enables sequenced packets on the login connection too. The residual is that `protocollogin.lua`'s `enableChecksum()` / delayed `enabledSequencedPackets()` dance might change the *shape* rather than just the value.
*Resolve by:* the same capture as Q1 — the first two bytes of the client's login frame are either a block count (small, e.g. `0x0023`) or a byte count (~`0x0116`), which settles it instantly. *Fallback if it is a byte count:* `ProtocolLoginModern` sets `Legacy` generation and `setWorldLineRequired(true)` only, and `Connection`'s legacy branch handles it — the world-line work in 3.2 is generation-independent and stands either way.

**Q3 — Is the premium tail at `src/protocollogin.cpp:128-136` right for 15.25?**
The brief confirmed the world/character section of the 0x64 layout, not the bytes after it. Unchanged by this plan (behaviour preserved), but unverified.
*Resolve by:* the same capture; a wrong tail shows up as the client reporting trailing unread bytes, or as a missing/garbled premium indicator in the character list.

**Q4 — `m_worldName` on a login connection after a logout.**
The brief establishes it is empty at startup and set in `Game::loginWorld`. It does not establish that it is cleared on logout, so a player returning to the character list may send a *stale non-empty* world name on the login connection. The design already handles both (`readWorldLineByte` consumes any line up to 32 bytes; the login connection never checks it). Recorded so nobody later "improves" the login path by rejecting on that line — it would break exactly the returning player.

**Q5 — `0x71` in the challenge.** Section 1.3 concludes it is the padding byte. The design deliberately does not act on that conclusion (alternative E). *Resolve by:* a dedicated experiment — change it to `0x00` on a scratch build and confirm a real client still logs in — before anyone unifies the padding-count byte into the framer.

**Q6 — How many worlds?** The world count now rides an unmeasured number. The wire caps at 255 worlds and 255 characters (`src/protocollogin.cpp:91`, 3.5), both clamped with warnings. `IOLoginData::loginserverAuthentication` issues two queries per world per login (`src/iologindata.cpp:128, 139`). *Resolve by:* asking the owner for the intended world count before anyone optimises that path. No optimisation is proposed on an unmeasured path.

**Q7 — Nothing verifies the webservice against the registry.** 3.7 case 1 is a total outage for HTTP-login players and is caught only by a capture or by a failed login. The server cannot check it — it has no knowledge of the webservice's environment. It is a step-8 documentation rule plus the validation item below.

---

## 7. Validation

No performance claim is made anywhere in this plan, so nothing here asks for a benchmark.

1. **Regression gate on the validated path, after step 7A and again after 7C** — the full pass `README.md:194-197` prescribes: `./blacktek_tests`, `harness/modern_client.py --webservice ...`, and a headless real-client run under `harness/capture_proxy.py`. Step 7A touches the transport every modern game connection uses; if this does not pass, nothing downstream is trustworthy.
2. **The login-port capture, before anyone trusts the login path** — `harness/capture_proxy.py` between a real 15.25 client and port 7171, decoded with `harness/packet_diff.py --decode`. This single capture settles Q1, Q2 and Q3 at once, and the two capture files belong in `harness/captures/` beside `mehah1525_login_client.hex` / `mehah1525_login_server.hex` as the permanent record.
3. **Scripted login parity** — `harness/login_client.py` (step 7D) against a two-world registry with both schemas populated: both worlds appear with their registry name, address and port, in registry order; every character carries its own world byte; the account-manager entry appears once per world (`src/iologindata.cpp:118-121`).
4. **Charlist truthfulness under partial failure** — stop world B's *process* and confirm its characters still list (nothing is process-cached); then revoke `SELECT` on world B's schema and confirm world A's characters still list with the warning from `src/iologindata.cpp:132` naming world B.
5. **Framing hardening** — drive `harness/login_client.py` with a frame declaring `blockCount == 0`, and with a padding count exceeding the payload, against `game_port_modern` and `7171`. Both must close the connection with no read past the payload. Run the server under ASan/UBSan for this one; it is the only part of steps 6–8 that changes a bounds calculation.
6. **Boot refusals** — `login_port == status_port`, `login_port == game_port_modern`, and `game_port != 0` together with `game_port_modern != 0` each print a distinct message and stop. The last one must be byte-identical to today's (`src/otserv.cpp:804`).
7. **Legacy path unchanged** — a config with `game_port != 0`, `game_port_modern = 0`, `login_port != 0` boots, registers `ProtocolLogin` and `ProtocolOld` on one port with no `ServiceManager::add` error, and refuses a 1525 client with the `allowedProtocolVersions()` text while accepting 1097/1098.
8. **Both login sources live at once** — with the webservice running and `login_port = 7171`, log in once through each and confirm both reach the world: the in-binary route through `gameworldAuthentication` and the HTTP route through `sessionKeyAuthentication`. Then deliberately set the webservice's `SERVER_NAME` to something the registry does not declare and confirm the HTTP route is refused by `src/protocolgame.cpp:548`'s message while the in-binary route is unaffected — that is the proof that G2 is closed for the in-binary path and open only for the webservice.

---

### Files this work touches

- `/home/josh/Documents/BlackTek-Server/src/protocollogin.h`, `/home/josh/Documents/BlackTek-Server/src/protocollogin.cpp`
- `/home/josh/Documents/BlackTek-Server/src/protocol.h`
- `/home/josh/Documents/BlackTek-Server/src/connection.h`, `/home/josh/Documents/BlackTek-Server/src/connection.cpp`
- `/home/josh/Documents/BlackTek-Server/src/otserv.cpp`
- `/home/josh/Documents/BlackTek-Server/src/configmanager.h`, `/home/josh/Documents/BlackTek-Server/src/configmanager.cpp`, `/home/josh/Documents/BlackTek-Server/src/luascript.cpp`
- `/home/josh/Documents/BlackTek-Server/config/server.toml`
- New: `/home/josh/Documents/BlackTek-Server/harness/login_client.py`, `/home/josh/Documents/BlackTek-Server/docs/deployment/multi-world.md`

### Files read as evidence but not modified

- `/home/josh/Documents/BlackTek-Server/src/world.h`, `/home/josh/Documents/BlackTek-Server/src/world.cpp`, `/home/josh/Documents/BlackTek-Server/src/account.h`, `/home/josh/Documents/BlackTek-Server/src/iologindata.cpp`
- `/home/josh/Documents/BlackTek-Server/src/protocolgame.h`, `/home/josh/Documents/BlackTek-Server/src/protocolgame.cpp`, `/home/josh/Documents/BlackTek-Server/src/protocolprofile.h`, `/home/josh/Documents/BlackTek-Server/src/protocol.cpp`, `/home/josh/Documents/BlackTek-Server/src/outputmessage.h`, `/home/josh/Documents/BlackTek-Server/src/networkmessage.h`
- `/home/josh/Documents/BlackTek-Server/src/server.h`, `/home/josh/Documents/BlackTek-Server/src/server.cpp`, `/home/josh/Documents/BlackTek-Server/src/protocolold.h`, `/home/josh/Documents/BlackTek-Server/src/protocolold.cpp`, `/home/josh/Documents/BlackTek-Server/src/protocolstatus.h`, `/home/josh/Documents/BlackTek-Server/src/definitions.h`
- `/home/josh/Documents/BlackTek-Server/harness/captures/mehah1525_login_client.hex`, `/home/josh/Documents/BlackTek-Server/harness/captures/mehah1525_login_server.hex`, `/home/josh/Documents/BlackTek-Server/harness/modern_client.py`, `/home/josh/Documents/BlackTek-Server/harness/README.md`
- `/home/josh/Documents/BlackTek-Server/config/worlds.toml`, `/home/josh/Documents/BlackTek-Server/config/database.toml`, `/home/josh/Documents/BlackTek-Server/docker-compose.yaml`, `/home/josh/Documents/BlackTek-Server/README.md`, `/home/josh/Documents/BlackTek-Server/STATUS.md`, `/home/josh/Documents/BlackTek-Server/arktext.md`agentId: a1e9f3c52e3dd578a (use SendMessage with to: 'a1e9f3c52e3dd578a', summary: '<5-10 word recap>' to continue this agent)
<usage>subagent_tokens: 217417
tool_uses: 50
duration_ms: 965094</usage>