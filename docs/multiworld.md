# Multi-world: how it works

One account, several worlds, one login. This document explains the whole mechanism — what a world
is, how a player reaches one, what is shared between them and what is not, and what each piece
refuses to do when something is wrong.

For the operator runbook — provisioning a new world, the SQL, the upgrade path, every boot refusal
with its remedy — see [`deployment/multi-world.md`](deployment/multi-world.md). This file is the
explanation; that one is the procedure.

---

## The rules this is built to serve

These are product decisions, settled first, and everything below follows from them:

- **A character belongs to one world for life.** There is no transfer.
- **Store coins are account-wide.** Buy on one world, spend on another.
- **What a purchase unlocks stays with the character.**
- **A ban bars the account everywhere**, not just where it was issued.
- **One player online per account across the whole deployment** — with two deliberate exemptions.
- **A player holds characters on as many worlds as they like**, and sees them all after one login.

---

## The shape

**One process serves exactly one world.** Three worlds means three processes. They are ordinary
copies of the same binary, each with its own working directory, its own `config/`, and its own
database schema, all on one MySQL instance.

```
                        ┌───────────────────────────────┐
   client ── HTTPS ────►│ website  (answers the login)  │
                        └───────────────┬───────────────┘
                                        │  reads the same worlds.toml
                                        │  writes the session row
                    ┌───────────────────┼───────────────────┐
                    ▼                   ▼                   ▼
             ┌────────────┐      ┌────────────┐      ┌────────────┐
             │  world 0   │      │  world 1   │      │  world 2   │
             │  :7172     │      │  :7173     │      │  :7174     │
             └─────┬──────┘      └─────┬──────┘      └─────┬──────┘
                   │  its own schema   │                   │
                   └───────────────────┼───────────────────┘
                                       ▼
                        ┌──────────────────────────────┐
                        │  shared auth schema          │
                        │  accounts, sessions, bans,   │
                        │  coins history, presence,    │
                        │  roles                       │
                        └──────────────────────────────┘
```

Every world reaches the shared tables through **views of the same name** in its own schema, so every
unqualified query in the engine and the datapack keeps working untouched. The tables that are new to
multi-world — presence and roles — have no view; the code names the auth schema directly.

### What is shared and what is per-world

| Shared across every world | Per world |
| --- | --- |
| Accounts, passwords, account type | Characters and everything on them |
| Login sessions | Character storage (quest progress) |
| Store coins and purchase history | Houses, guilds, market, deaths |
| Account bans and ban history | Towns, spawns, the map itself |
| Login presence (who is online where) | Account *storage* — deliberately, it is per-character state |
| Account roles (tester and friends) | |

---

## The world list

`config/worlds.toml` is the list, and **the same file is deployed to every world, byte for byte**.

```toml
[[world]]
id             = 0
name           = "Avarion"
address        = "127.0.0.1"
public_address = "avarionot.example"   # website-only
port           = 7172
schema         = "blacktek"
```

| Field | Meaning |
| --- | --- |
| `id` | the world byte on the wire, 0-255 |
| `name` | **exactly** what the client is told, and what it echoes back on connecting |
| `address` | must equal this process's `[network].ip` |
| `port` | must equal this process's `[network].game_port_modern` |
| `schema` | must equal this process's `[mysql].database` |
| `public_address` | what a client should dial when `address` is a bind address. Website-only |
| `listed` | website-only: hide a world from public pages without hiding it from players who have one |
| `access` | the role an account must hold to enter. Absent means public |

**The boot cross-check is the point.** Each process finds its own row by `[world].id` and refuses to
start if that row disagrees with its own configuration — so a world can never advertise another
world's address, port or database. Duplicate ids, duplicate names, a missing field and an id no row
declares are all boot refusals with their own message.

Unknown keys are ignored, which is how `public_address` and `listed` can be website-only: the server
reads the five keys it names and never sees the rest.

**The list is read once, at boot.** Changing it means restarting every world.

---

## How a player reaches a world

1. **The client asks the login service.** The 15.25 client speaks HTTP login unless the port is
   exactly 7171, which is a client-side constant — it cannot be moved. In this deployment a small
   proxy publishes 7171 and hands the request to the website.
2. **The website authenticates the account** against the shared `accounts` table, checks the ban
   table, and mints a session key: a random 64-character value handed to the client, stored as its
   **lowercase hex SHA-256** in `account_sessions` with a NULL character name.
3. **It answers with the world list and every character**, each tagged with the world it lives on —
   read from each world's schema in turn. Worlds the account may not enter are not offered.
4. **The client dials that world's game port directly** and opens with the world's name as a
   plaintext line. If it does not match, the server refuses:
   *"This is Avarion. Please pick that world in your client's world list."*
5. **The world authenticates the session key** by the same SHA-256, finds the character on its own
   schema, and then runs its gates in order:
   - **IP ban**, then **account ban** — account-wide, so a ban issued anywhere bars everywhere.
   - **Private-world access** — if the world's row names a role.
   - **One session per account** — the deployment-wide claim.
   - **The waiting list**, if the world is full.
6. **The player is placed in the world**, and the claim is released after their character is saved
   on logout — in that order, so no other world can load a stale character.

The server also has its own in-binary login listener, which serves the same world list on 7171. The
deployment does not use it — the website answers that port — but it exists, and the world list it
would serve comes from the same registry.

---

## One session per account

The rule is deployment-wide: an account may be online on one world at a time.

**How it is enforced.** Two tables in the auth schema, neither of them viewed:

- `world_presence` — one heartbeat row per running world, written every **10 seconds**.
- `account_presence` — one row per claimed account, holding the world, the character and a random
  claim token.

A login inserts its claim. The primary key means exactly one world can win; the loser is told where
the account already is: *"Your account is already online on Avarion as …"*

**A crashed world must not lock its players out forever.** A claim whose world has not beaten for
**45 seconds** is stale, and another world may take it over. The takeover re-checks staleness at the
moment it writes, so a world that recovered in between keeps its claim.

**A world that was frozen and comes back must not keep players it no longer owns.** On recovery it
compares the database's clock — never its own — and if it stalled past the lease it re-reads its
claims and kicks anyone whose claim was taken from it. That read uses a constant marker row, so a
failed query is distinguishable from an empty one and kicks nobody.

**Exempt:** accounts of type Gamemaster and above, and any world running with `allow_clones`.

---

## Account-wide bans

The ban tables live in the auth schema, so a ban written on one world is seen by all of them.

The issuer is stored as a **frozen name** rather than a character id, because a character id means
different people on different worlds — the same number is a different character in another schema.
The name is written at ban time and never re-resolved.

An expired ban is **retired once, however many worlds notice it**: the delete is guarded so the world
that actually removes the row is the one that writes the history entry. This is why nothing else
should delete an expired ban — doing so wins that race and the history is never written.

---

## Store coins

Coins are account-wide, so two worlds can change the same balance. Every change is a **guarded
delta** — `coins = coins + n` with a condition that refuses to go below zero — never a write of an
absolute value, which would let one world overwrite another's spending.

On MySQL 8.0 unsigned arithmetic below zero raises an error rather than wrapping, so the guard casts
to signed and the refusal is a normal, quiet "you cannot afford this".

---

## Private worlds

A world row may name a role:

```toml
access = "tester"
```

- **Absent means public.** A public world runs **no query** for this — the check returns before it
  touches the database.
- **Roles are rows** in `account_roles` in the auth schema: one row per account per role, with the
  granting character's name frozen in beside it. Granted and revoked from the website.
- **Staff pass regardless** — account type Gamemaster (4) and above, the same comparison the
  one-session exemption uses, shared so the two can never drift apart.
- **Everything fails closed.** A world naming a role refuses to boot unless it can read the role
  table; a role that cannot be read refuses the login; an `access` value that is not a valid role
  name refuses the boot rather than quietly reading as public.
- **The website hiding a world is not a gate.** Anyone who knows the port can dial it, which is why
  the refusal lives in the server. The site hides it as well, so players are not shown a door they
  cannot open.

Revoking takes effect at the next login: a tester already in the world stays until they log out.

---

## Ports

| Port | What |
| --- | --- |
| 7171 | login — **fixed by the client**, nothing else may use it |
| 7172, 7173, 7174 … | one game port per world, contiguous |
| 7181, 7182, 7183 … | one status port per world, in their own block |

Game ports run in a block from the login port so that a router forwarding a *range* covers every
world the deployment will ever have. Status ports are kept in a separate block so a new world extends
the game range without ever colliding with a status listener.

The client dials whatever the world list told it, so a world's port is free to be whatever the list
and its own configuration agree on — with one exception: 7171 belongs to login and a collision with
it is a boot refusal, because the fixable side is always the other listener.

---

## What needs a restart

| Change | Cost |
| --- | --- |
| `config/worlds.toml` — any change at all | restart **every** world; the list is read once at boot |
| A world's ports or schema | restart that world |
| Granting or revoking a role | nothing — read at each login |
| Banning an account | nothing — read at each login |
| The website's copy of the world list | restart the website container; it reads the file at start |
| Datapack and quest content | `/reload`, no restart |

---

## Failure modes, and what the player sees

| Situation | What happens |
| --- | --- |
| Client dials the wrong world for the name it announces | *"This is <world>. Please pick that world in your client's world list."* A client holding an old list after a rename sees this until it restarts. |
| Account already online elsewhere | Refused, naming the world and character. |
| The account's claim could not be read | Refused. It fails closed. |
| Account holds no role for a private world | *"<world> is not open to your account."* |
| The role table cannot be read | Refused, not admitted. |
| A world's game port is not reachable | The client says "connection refused" and names no cause — check the firewall and the router before the server. |
| A world's views of the shared tables are missing or stale | That world **refuses to boot** and names the remedy. It never runs half-connected to the shared schema. |

---

## What has not been proven

- **Behaviour under real player load.** The heartbeat and lease were exercised deliberately —
  including a killed world, a frozen one, and a takeover — but not measured with a full world online.
- **Worlds on separate hosts.** Everything judges time on the database's clock rather than a process
  clock, which is what should make this work, but it has not been tried.
- **A real client on the in-binary login port.** Production answers login from the website, so that
  path is built and unused.
