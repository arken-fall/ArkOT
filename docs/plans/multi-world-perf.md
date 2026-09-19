# Multi-world performance plan

Five findings from the `/cpp-perf-review` of the multi-world change set (HEAD `3fc0542`), each
verified against the checkout before it was planned. This document is the implementation plan for
them: what changes, in what order, what may land alone, and what must be true before the next step
starts.

The feature is **live in production with two worlds**, so every behavioural change below is called
out where it appears, not summarised at the end.

| # | Finding | Tier | Verdict |
| --- | --- | --- | --- |
| F1 | Character list costs two round trips per world, on the game thread | High | Plan, step 1 |
| F5 | Shutdown deletes each claim, then deletes them all again | Opportunistic | Plan, steps 2-3 |
| F4 | World-name preamble re-arms its timer once per byte | Opportunistic | Plan, step 4 |
| F2a | Heartbeat blocks the game thread twice every 10 s | Medium | Plan, step 5 |
| F2b | The heartbeat's write, too | Medium | Conditional, step 6 |
| F3 | Login's blocking query chain, claim included | Medium | **Not implemented as stated** |

Landing order: **F1 → F5 → F4 → F2a → (F2b) →** F3 rejected.

F1 is isolated and touches no threading. F5 introduces the retirement lifecycle that F2b's ordering
work reuses, and reduces shutdown's database traffic before shutdown ordering is perturbed. F4 is
independent of the database seam and sits here so the seam changes stay reviewable alone.

---

## The seam these changes share

- `Dispatcher` is a single thread (`src/tasks.cpp:21-47`) and it is the game loop. Scheduler timers
  do not run work; they post it to the dispatcher (`src/scheduler.cpp:32`).
- `Database` is one shared MySQL handle under a `std::recursive_mutex` (`src/database.h:129-130`).
  Both query paths hold that lock across the whole round trip, and on a connection-level error they
  retry forever with a 1 s sleep **while still holding it** (`src/database.cpp:93-101`, `:117-125`),
  against a 30 s timeout (`src/database.cpp:35-37`).
- `g_databaseTasks` owns a second, independent connection (`src/databasetasks.h:36`) and a FIFO
  deque drained by its own thread; results return as a dispatcher task (`src/databasetasks.cpp:65`).

Three properties of that queue are load-bearing below:

1. **Affected rows never cross it.** `mysql_affected_rows` reads the connection handle
   (`src/database.h:100-102`), which has moved on by callback time, and a `store` task hard-codes
   success (`src/databasetasks.cpp:56-58`). `src/ban.cpp:76-80` already documents this and keeps a
   guarded DELETE synchronous for exactly that reason.
2. **`addTask` silently drops** anything queued when the thread is not running
   (`src/databasetasks.cpp:41-44`).
3. **`flush()` drains on the calling thread** (`src/databasetasks.cpp:69-79`) while `threadMain` may
   be draining concurrently, so queue order does **not** imply execution order.

Two more invariants constrain everything here:

- `storeQuery` returns `nullptr` for both "no rows" and "failed" (`src/database.cpp:146-151`), and a
  result starts positioned on row 1 with `next()` advancing (`src/database.cpp:189`, `:219`). The
  marker-row idiom at `src/presence.cpp:392-406` is this project's established answer.
- `Classify`'s own-world `Abandoned` rule is justified **solely** by the local one-session check
  having run in the same uninterrupted dispatcher task (`src/presence.cpp:319-322`), and that
  precedence is pinned by tests (`tests/test_presence.cpp:72-76`, `:97-102`).

---

## F1 — one marker-row query per world

`IOLoginData::loginserverAuthentication`, `src/iologindata.cpp:115-147`. Today every login runs
`1 + 2W` blocking round trips (`W` = registry worlds). The `COUNT(*)` carries nothing the names query
does not; it exists only to tell "no characters" from "query failed", and to size a `reserve` that is
exact-fit and therefore reallocates on the very next world's account-manager `push_back`.

```cpp
	// One growth for the account-manager entries; the character rows then grow
	// geometrically. An exact-size reserve per world forced a reallocation on the
	// very next world's account-manager push_back.
	if (offerAccountManager)
		account.characters.reserve(worlds.size());

	for (const auto& world : worlds)
	{
		if (offerAccountManager)
		{
			account.characters.push_back(CharacterEntry{ .name = AccountManager::NAME, .world = world.id });
		}

		// storeQuery reports "no rows" and "the query failed" alike (database.cpp:146-151),
		// so a constant marker row that always comes back makes nullptr mean failure only.
		// Same technique as World::Presence::Reconcile (presence.cpp:392-406). The explicit
		// marker column and ORDER BY marker keep that row first under any collation, and the
		// result is positioned on it on entry (database.cpp:189, 219), so the loop below
		// yields exactly the real rows.
		const auto names = db.storeQuery(fmt::format(
			"SELECT 0 AS `marker`, NULL AS `name` UNION ALL SELECT 1, `name` FROM `{:s}`.`players` WHERE `account_id` = {:d} AND `deletion` = 0 ORDER BY `marker` ASC, `name` ASC",
			world.schema, account.id));

		if (not names)
		{
			BlackTek::Console::Database::Warn("IOLoginData::loginserverAuthentication: could not read schema '{:s}' of world '{:s}' (id {:d}); it contributes no characters to account {:d}'s list.", world.schema, world.name, world.id, account.id);
			continue;
		}

		while (names->next())
		{
			account.characters.push_back(CharacterEntry{ .name = std::string{ names->getString("name") }, .world = world.id });
		}
	}
```

`NULL AS name` rather than `''`: the marker's name is never read, and a NULL literal raises no
collation-aggregation question at all.

**A single cross-world `UNION` is not planned.** The comment at `src/iologindata.cpp:107-111` is
right that one unreadable schema nulls the whole result, and `storeQuery` surfaces no per-branch
error.

**Behavioural change (log only):** a names query that fails now warns, where the
COUNT-succeeded-names-failed case was previously silent. Strictly better.

## F5 — retirement state on `Presence`

Shutdown issues one blocking DELETE per online player (`src/player.cpp:2068`), then `Retire()`
removes the same rows with one world-scoped statement (`src/presence.cpp:197`).

`Presence` gains `BeginRetire()` / `IsRetiring()` and a `retiring` flag beside `retired`, with
`Retire()` setting `retiring` on every path so a `Retire()` without a prior `BeginRetire()` behaves
exactly as today. `PresenceClaim` gains a private `Discard()` that gives up the claim with no
statement, and `Release()` gains, right after its `IsHeld()` guard:

```cpp
		// Shutdown deletes every claim of this world with one statement
		// (Presence::Retire), so the per-player DELETE here is pure cost. Discard
		// rather than return: a claim left held would be queued by ~PresenceClaim
		// (presence.cpp:114-121) and run by the flush at game.cpp:245, which is the
		// same round trip on a different thread.
		if (Presence::GetInstance().IsRetiring())
		{
			Discard();
			return;
		}
```

`Game::setGameState(GAME_STATE_SHUTDOWN)` calls `BeginRetire()` immediately before its kick loop
(`src/game.cpp:182`).

Two things must **not** change:

- `~PresenceClaim` and `QueueRelease` stay as they are. The destructor can run at static destruction,
  where `Presence`'s function-local static (`src/presence.h:99-103`) is already gone — it must not
  consult the flag. `Release()` is dispatcher-only and may.
- `GAME_STATE_CLOSED`'s kick loop (`src/game.cpp:206-221`) must not call `BeginRetire()`: that world
  keeps running and its claims must be released individually.

**Behavioural change (flag to the owner):** if `Retire()`'s bulk DELETE fails, claims linger until
the 45 s lease instead of having been removed one by one — the mode `src/presence.cpp:198` already
documents and accepts. Player-visible: an account cannot log into another world for up to 45 s after
a shutdown whose DELETE failed.

**Explicitly not planned:** making ordinary logout releases asynchronous. A logout on one world
followed at once by a login on another would reach `Presence::Claim` before the queued DELETE ran and
be refused as `Live` (`src/presence.cpp:324-327`) — a visible regression for one round trip.

## F4 — one deadline for the whole preamble

`readWorldLineByte` (`src/connection.cpp:238-285`) arms a timer, reads one byte, cancels the timer,
and recurses — so each byte also gets a **fresh 30 s deadline**, letting a client trickling 32 bytes
hold the socket far longer than one timeout.

Introduce `ArmReadDeadline()` (the `expires_after` + `async_wait` + `bind_executor` block) and arm
once at each preamble entry point — `Connection::accept(Protocol_ptr)` (`src/connection.cpp:107-112`)
and `parseHeader`'s preamble branch (`:190-192`, which needs it because `parseHeader` cancelled the
timer at `:148`). `readWorldLineByte` then loses its `expires_after`/`async_wait` and its handler
loses `readTimer.cancel()`.

Termination needs no explicit cancel, and the comment should say so, so nobody "fixes" it later:

- `'\n'` → `accept()`, whose own `expires_after` (`src/connection.cpp:123`) cancels the preamble
  deadline; `handleTimeout` ignores the resulting `operation_aborted` (`:515-518`).
- error, closed, or over the 32-byte cap → `close(FORCE_CLOSE)` → `closeSocket()` cancels (`:78`).

**Not planned:** `async_read_until`. It buffers past the newline, and those bytes belong to the
framed stream `parseHeader` reads straight from the socket (`src/connection.cpp:197`, `:223-229`).

**Behavioural change (flag):** the preamble as a whole now gets one `CONNECTION_READ_TIMEOUT`
instead of one per byte. This tightens a slowloris window.

## F2a — the heartbeat's age read leaves the game thread

`Beat()` (`src/presence.cpp:330-386`) runs two blocking statements on the dispatcher every 10 s
(three on the stall path). Steady state is cheap; the tail is the point — the lock-held retry loop
above means a database hiccup freezes the simulation for tens of seconds on a fixed cadence,
whatever the player count.

`Beat` splits into `Beat` (re-arm, enqueue the age read) and `FinishBeat` (everything from the
missing-age warning onward), with a `beat_in_flight` flag:

```cpp
		// One chain at a time. A tick that finds the previous beat's age read still
		// queued is not a beat at all: it plans nothing, lands nothing and carries
		// nothing, so the pinned state machine never sees it.
		if (beat_in_flight)
			return;
```

`readAt` is taken at enqueue, so the span also covers queue wait. That only **widens** it, which
makes `IsStall` more conservative, never less — the bound argued at `src/presence.h:127-151` still
holds, and that comment must be updated to say so.

**The upsert stays synchronous in this step, deliberately.** It is the only presence write that races
`Retire()`'s DELETE. Keeping it on the main connection, on the dispatcher, keeps `Retire()` strictly
ordered after it with no new machinery. The age read is a pure SELECT whose loss is already modelled
as a stall.

**Behavioural change (flag):** under a database outage the game no longer freezes on the age read,
so the simulation keeps running while peers may be declaring this world expired; when the chain
completes, `Reconcile` kicks the accounts that were taken over. Previously the dispatcher was frozen
and nobody could act at all.

## F2b — the upsert too (conditional)

Only worth doing if F2a's measurement says the remaining synchronous write matters. It needs a new
primitive, because queue FIFO does not order execution (property 3 above).

`DatabaseTasks` gains `WaitForQueued()`: `DatabaseTask` carries an optional
`std::shared_ptr<std::promise<void>>` barrier, `runTask` fulfils it and returns before touching `db`,
so both `threadMain` and a concurrent `flush()` settle barriers and neither can hang a waiter.
`WaitForQueued` checks state and pushes under `taskLock` — the same lock `shutdown()` takes — so the
state cannot flip between the check and the push.

`Beat` then becomes a three-hop chain, and `Retire()` gains, after the flags are set and before its
DELETEs:

```cpp
		// Every heartbeat write is queued on that one connection, so draining the
		// queue is what orders the DELETE below after them. Without this a beat
		// upsert landing after the DELETE re-creates this world's heartbeat row,
		// and any claim Retire failed to remove then looks Live to other worlds for
		// a full lease instead of being taken over at once.
		g_databaseTasks.WaitForQueued();
```

`Reconcile()` stays synchronous: it is the rare post-stall path and it kicks players, which must
happen on the dispatcher.

**Rejected alternative:** making the beat a bare `UPDATE` so a late beat cannot resurrect a deleted
row. It loses the self-healing property that a missing `world_presence` row is re-created by the next
beat, and detecting "updated nothing" needs affected rows, which the queue cannot return. The failure
mode is a world beating forever into a row that does not exist, judged expired by every peer, with
its own players kicked by `Reconcile`.

**Not safe to land piecemeal:** the barrier must land in the same change as `Retire()`'s use of it.

## F3 — not implemented as stated

Rebuilding login as a continuation chain is rejected for now, on three grounds from the checkout:

1. **Mechanically blocked.** The claim decides everything from `getAffectedRows()`
   (`src/presence.cpp:250`, `:299`), which cannot cross the queue's callback. The same limit already
   forced `src/ban.cpp:81-97` to stay synchronous. Async claiming is not a refactor of `Presence`; it
   is a change to a shared primitive also used by Lua, the market and bans.
2. **It is the wrong few percent.** The common-case claim is *one* `INSERT IGNORE`. The same login
   task already blocks on `preloadPlayer`, two ban checks, and `loadPlayerById` → `loadPlayer`, which
   issues more than twenty further reads (`src/iologindata.cpp:766` … `:1159`).
3. **It dismantles a live invariant to buy that fraction.** Yielding invalidates the same-task
   guarantee behind `Classify`'s `Abandoned` rule, and also `getPlayerByGUID`, `getPlayerByAccount`,
   the game-state gates and waiting-list admission — leaving a constructed-but-unplaced `Player`
   alive across suspension points. The in-flight account-id set restores one of those guarantees, not
   the rest.

**What would change the verdict:** a measurement showing login-path dispatcher occupancy actually
hurts. If it does, the target is `loadPlayer`'s twenty-odd reads, not the claim, and the
prerequisites are (i) `DatabaseTasks` carrying affected rows, (ii) a dispatcher-owned in-flight
account-id set, (iii) an explicit login state machine owning the half-built `Player` across
suspensions. That is its own plan.

---

## Steps

Each step is one `cpp-coder` dispatch.

**Step 1 (F1) — marker-row character list.**
Scope: `src/iologindata.cpp:115-147` only. Blast radius: one function, one caller
(`src/protocollogin.cpp:60`); no threading, no shutdown, no presence.
Done: exactly one `storeQuery` per registry world; `nullptr` is the only warning trigger; wire order
unchanged (account manager first per world, then names ascending); no `reserve` inside the loop.

**Step 2 (F5) — retiring state, single bulk claim delete.**
Scope: `src/presence.h`, `src/presence.cpp`, one call at `src/game.cpp:182`. Blast radius: the
shutdown path and `Player::onRemoveCreature`.
Done: no per-player DELETE once `BeginRetire()` has run; no claim survives the kick loop still held,
so `~PresenceClaim` queues nothing; `IsEnabled()` unchanged; `GAME_STATE_CLOSED` untouched;
`Retire()` without `BeginRetire()` behaves as before.

**Step 3 (F5 tests) — pin the retiring gate.**
Scope: new cases in the existing `tests/test_presence.cpp` (no new file, so no premake regeneration —
`premake5.lua:201` globs `tests/**.cpp`), plus a `BlackTek::Tests::PresenceAccess` friend mirroring
the existing `PresenceClaimAccess`.
Done: a held claim released while retiring ends up not held and never reaches `Database`, the same
property the existing test at `tests/test_presence.cpp:460-466` asserts; the flag is cleared at the
end so no test ordering dependency is created. Lands with or immediately after step 2.

**Step 4 (F4) — one deadline per preamble.**
Scope: `src/connection.h`, `src/connection.cpp:107-112`, `:190-192`, `:238-285`.
Done: exactly one `expires_after` per preamble; no `cancel()` in the per-byte handler; the 32-byte cap
and the trace log preserved; `parseHeader`'s two-byte entry arms before entering.

**Step 5 (F2a) — age read on `g_databaseTasks`.**
Scope: `src/presence.h`, `src/presence.cpp:330-386`. `Retire()` and `Start()` unchanged.
Done: at most one blocking statement per beat on the dispatcher (the upsert), plus `Reconcile`'s read
on the stall path; a tick that finds `beat_in_flight` re-arms and returns without calling
`PlanReconcile`; `readAt` taken at enqueue; `FinishBeat` returns early and clears `beat_in_flight`
when `retired`.

**Step 6 (F2b, conditional on step 5's measurement) — `WaitForQueued` + async upsert.**
Scope: `src/databasetasks.h`/`.cpp`, then `src/presence.cpp`. Blast radius: every user of
`g_databaseTasks` shares the modified `DatabaseTask`/`runTask` — Lua, market, bans, claim releases.
The new field is additive and inert for them, but the review must say so.
Done: zero blocking presence statements on a healthy beat; `WaitForQueued()` returns immediately when
the thread is not running; a barrier queued before a concurrent `flush()` is still fulfilled;
`Retire()`'s DELETE is provably after every queued beat write; shutdown completes with no hang
against a reachable database.

## Independence and gating

- **F1** — lands alone; nothing depends on it, it depends on nothing.
- **F5** — lands alone. Must be in, and exercised through at least one real shutdown, before F2a
  starts: two uncharacterised shutdown changes should not be in flight together.
- **F4** — lands alone, in either direction. Can be parallelised with steps 1-3.
- **F2a** — after F5 is in and shutdown exercised. Must run in production long enough to answer
  whether the remaining synchronous upsert is worth a new shared primitive.
- **F2b** — never alone: needs F2a's chain, F5's lifecycle, and its barrier landing together with
  `Retire()`'s use of it.
- **F3** — not implemented; nothing gates on it.

## Risks and open questions

1. **The marker-row query against the live schema (F1).** The shape is the one already in production
   at `src/presence.cpp:397-399`, but that one has no `ORDER BY` and no NULL literal. Run the exact
   generated query by hand against a production schema with characters, one without, and a
   deliberately non-existent schema, and confirm three outcomes: marker only, marker + rows in name
   order, and error → `nullptr`.
2. **`W` — settled.** The owner intends **up to 15 worlds for now** (2026-09-18); production runs two
   today. That makes F1 worth landing on its own merits rather than on principle: at `W = 15` a
   character list is 31 blocking round trips on the game thread, and this step takes it to 16.
   `docs/plans/multi-world-phase1-steps678.md:501` recorded the count as unknown; this answers it.
3. **A wedged beat chain (F2a).** If `g_databaseTasks` is not running, `addTask` drops the task, the
   callback never runs, and `beat_in_flight` stays true — silently stopping the heartbeat. Today that
   can only happen after `g_databaseTasks.stop()` during shutdown, where it is harmless. Confirm in
   review that no other path stops it on a live server; if one is added, `Beat` needs a watchdog.
4. **`flush()` racing `threadMain` is pre-existing** (`src/databasetasks.cpp:69-79` vs `:17-35`,
   invoked at `src/game.cpp:245`). This plan does not fix it, and F2b's barrier is designed to be
   correct in its presence. Whether `flush()` should refuse to run while the thread is alive is a
   separate question.
5. **`Reconcile` stays synchronous** on the stall path. Accepted deliberately.
6. **F4's tightened deadline against real clients.** 30 s for a whole preamble is far beyond any
   legitimate client, but this is production: confirm with a real modern client on both listeners,
   plus one deliberate slow-trickle test.
7. **Shutdown with a failed bulk DELETE (F5) — accepted.** The owner accepted the up-to-45 s
   lease-out for affected accounts (2026-09-18). F5 is cleared to proceed on that basis.

## Validation

No numbers are asserted here; these are the exercises that confirm the claims.

- **F1** — count statements for one character-list request: `1 + W` reads, not `1 + 2W`. The client's
  character list is identical before and after for an account with characters on both worlds, on one,
  and on none; an intentionally unreadable schema still warns and still yields the other world's
  characters.
- **F5** — with N players online, shutdown issues one world-scoped DELETE, not N + 1, and
  `account_presence` is empty for this world afterwards. A normal logout still issues its individual
  guarded DELETE, and logout-here/login-there immediately after still succeeds.
- **F4** — timer arm/cancel pairs drop to one for the whole line. Real-client login works on the
  modern listener, and a client sending no world line still reaches framing through `parseHeader`'s
  fall-through (`src/connection.cpp:194`).
- **F2a** — measure time spent inside `Beat`/`FinishBeat` on the dispatcher, before and after. Then
  stop MySQL: the game loop keeps ticking where it previously stalled; restart it and confirm the
  beat resumes, the stall is carried to the next landed beat, and `Reconcile` runs exactly once plus
  its follow-up (the sequences pinned at `tests/test_presence.cpp:307-390`).
- **F2b** — repeat that exercise for zero dispatcher stall on a healthy beat. Then the ordering
  proof: shut down with a beat write in flight against an artificially slowed database and confirm
  `world_presence` has no row for this world afterwards; repeat with the `account_presence` DELETE
  forced to fail and confirm the heartbeat row is still gone, so peers take the claims over at once.
- **Every step** — `blacktek_tests` passes, with `PlanReconcile` / `FollowUpAfter` / `IsStall` /
  `Classify` unmodified by any step in this plan.
