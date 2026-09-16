# Running N worlds

How to deploy this server as more than one world: what each world gets its own copy of, what every
world must share byte for byte, which disagreements the server refuses to boot on, and what the
shared MySQL instance has to look like.

One process serves exactly one world. N worlds means N processes.

---

## Status: none of this has been run

**Nothing described here has been compiled, started or tested.** The multi-world code is written
and committed; it has never served a player. The in-binary login path in particular has never been
exercised by a real client, because until `login_port` was turned on it could not be.

Three things are unverified, and nothing below should be trusted until they are:

| Unverified | Why it matters | How to settle it |
| --- | --- | --- |
| Whether the per-world views are insertable and updatable | `INSERT INTO accounts`, `UPDATE accounts`, `INSERT INTO store_history` all go through a view. A `TEMPTABLE` view is read-only. | The probe statements under **O1** in the header of `auth_schema.sql` — run them against the provisioning rig. |
| Whether InnoDB accepts the cross-schema foreign keys | Without them, deleting an account no longer cascades at the database level and an orphaned `players` row stops being impossible. | Section 4 of `auth_schema.sql`, which ships commented out. Attempt each statement, keep what works. |
| What a real 15.25 client actually puts on the wire for a login packet | No capture of a login packet exists. The field layout `ProtocolLogin::onRecvFirstMessage` skips is inferred from the *game* packet. If it is wrong, every login fails with "Invalid authentication token." | `harness/capture_proxy.py` between a real client and port 7171, decoded with `harness/packet_diff.py --decode`. |

There is also no scripted login-protocol client yet: `harness/` has `modern_client.py` for the game
port and nothing for 7171.

Treat this document as the design made concrete, not as a procedure anyone has followed.

---

## One directory per world

Every world runs from its own working directory, because the process reads almost everything by
relative path:

| Read | Path | Source |
| --- | --- | --- |
| Configuration | `config/*.toml` | literal relative paths in `src/configmanager.cpp` |
| World list | `config/worlds.toml` | `src/world.cpp:21` |
| RSA key | `key.pem` | `src/otserv.cpp:540` |
| Map | `data/world/<map_name>.otbm` | `src/game.cpp:248` |
| Assets | `data/items/assets.dat`, `data/items/appearances.dat` | `[world]` keys in `config/server.toml` |

So a world is a directory containing the binary, `config/`, `data/` and `key.pem`, and it is started
from inside that directory. Two worlds sharing one directory would share one `config/server.toml`
and therefore be the same world.

What differs between those directories is small:

| File | Per world | Notes |
| --- | --- | --- |
| `config/worlds.toml` | **byte-identical everywhere** | see below |
| `config/server.toml` | `[world].id`, `[network].game_port_modern`, `[network].login_port`, and `[network].ip` where hosts differ | everything else can be identical |
| `config/database.toml` | `[mysql].database` differs; `[mysql].auth_database` identical | |
| `key.pem` | its own copy | the content may be the same file copied N times |
| `data/` | identical | the map and datapack are the same world content unless you intend otherwise |

---

## `config/worlds.toml` — the same bytes on every world

`config/worlds.toml` is the world list. Deploy the **same file** to every world directory.

That is what makes the world list identical from every world, and it is why any world can serve the
list: `ProtocolLogin::getCharacterList` writes one entry per registry row, in registry order, taking
each world's advertised `address` and `port` from that world's own row rather than from the serving
process's configuration (`src/protocollogin.cpp`). A world can only advertise another world
correctly if it was handed the same list.

A row is:

| Field | Meaning | Validation |
| --- | --- | --- |
| `id` | the world-id byte on the wire | 0–255, unique across the file |
| `name` | exactly what the client is told the world is called, and what it echoes back on the game connection | non-empty, unique across the file (whitespace-trimmed) |
| `address` | what the client dials for that world's game server | non-empty; must equal that world's `[network].ip` |
| `port` | what the client dials | 1–65535; must equal that world's `[network].game_port_modern` |
| `schema` | that world's MySQL database | non-empty; must equal that world's `[mysql].database` |

`name` is **not** `[identity].name` from `config/server.toml`. `[identity].name` ships as
`"Black Tek"` while the shipped world row is `"BlackTek"`; nothing cross-checks them, and only the
`worlds.toml` name reaches the client.

Deleting `config/worlds.toml` is supported and means single-world: the process synthesises one row
from its own configuration (`[identity].name`, `[network].ip`, `[network].game_port_modern`,
`[mysql].database`) and boots as it did before the file existed. That is the fallback, not the
multi-world path.

---

## `config/server.toml` — what each world changes

```toml
[world]
id = 0                      # this process's row in config/worlds.toml

[network]
ip               = "127.0.0.1"   # must equal this world's worlds.toml address
game_port_modern = 7183          # must equal this world's worlds.toml port
login_port       = 7171          # exactly one world in the deployment; 0 on the rest
status_port      = 7184          # must not be 7171
```

### The refusals

At boot the registry finds this process's row by `[world].id` and cross-checks it against the rest
of this process's configuration. Any disagreement stops the boot — it never degrades into a
running server that advertises the wrong address. Read from `src/world.cpp` and `src/otserv.cpp`:

| Condition | What the refusal means |
| --- | --- |
| `[world].id` is outside 0–255 | The id is a single wire byte. Nothing else was checked yet. |
| `config/worlds.toml` could not be parsed | TOML syntax error; the parser's own description is logged first. |
| The file declares no `[[world]]` entries | An empty or missing `[[world]]` array. Delete the file entirely if you want single-world. |
| A `[[world]]` entry is missing a required field | One of `id`, `name`, `address`, `port`, `schema` is absent, empty after trimming, or out of range (`id` 0–255, `port` 1–65535). |
| Two `[[world]]` entries share the same id | Two worlds would claim the same wire byte, so characters could not be attributed. |
| Two `[[world]]` entries share the same name | The wrong-world check matches by name, so two worlds with one name cannot be told apart. Names compare case-insensitively after trimming. |
| No `[[world]]` entry matches this process's `[world].id` | This process cannot prove which world it is. Usually a copied `server.toml` whose `[world].id` was never changed, or a `worlds.toml` that was never updated for the new world. |
| This world's declared address does not match `[network].ip` | The registry would tell clients to dial an address this process does not bind. Compared exactly after trimming — `localhost` and `127.0.0.1` are a mismatch. |
| This world's declared port does not match `[network].game_port_modern` | Same, for the port. Note it is `game_port_modern` that is checked, not `game_port`. |
| This world's declared schema does not match `[mysql].database` | This process would serve characters out of a database the list attributes to some other world. |

Two more refusals come from the listener wiring rather than the registry:

| Condition | What the refusal means |
| --- | --- |
| `game_port` and `game_port_modern` are both non-zero | Two protocol generations at once is not supported; set `game_port = 0`. |
| `login_port` is non-zero and equals `status_port`, `game_port` or `game_port_modern` | A port collision. `ServiceManager::add` would otherwise only print and silently disable one of the two listeners, and which one depends on registration order. |

`status_port == game_port_modern` is **not** checked. That collision still silently disables a
listener.

---

## `config/database.toml`

```toml
[mysql]
host          = "127.0.0.1"
port          = 3307
user          = "forgottenserver"
pass          = "..."
database      = "blacktek_world_0"   # differs per world
auth_database = "arkot_auth"         # identical on every world
```

`[mysql].database` is this world's schema and must equal its `worlds.toml` `schema`.

`[mysql].auth_database` is the shared auth schema and must be the same string on every world. It
ships **empty**, which means single world: no auth schema, no views, no boot probe, no database
change at all. Setting it (to something other than `database`) is what turns on the shared-account
behaviour and the boot probes described below. A multi-world deployment must set it.

---

## `key.pem`

Loaded as the literal relative path `key.pem` from the working directory, before the database
connection is opened. Each world directory needs its own copy of the file. The *content* may be the
same key on every world — nothing ties a key to a world — but a directory without the file refuses
to boot with the loader's own error.

---

## Ports

| Port | Listener | Key |
| --- | --- | --- |
| 7171 | in-binary login | `[network].login_port` |
| this world's game port | modern game (13.40+) | `[network].game_port_modern` |
| this world's status port | status / server info | `[network].status_port` |

Defaults matter here, because a key omitted from `server.toml` is not a disabled listener:

| Key | Default when the key is absent |
| --- | --- |
| `login_port` | 7171 |
| `game_port` | 7172 |
| `game_port_modern` | 7173 |
| `status_port` | **7171** |

So a `server.toml` with no `status_port` collides with the login port and the boot is refused. The
shipped file sets `status_port = 7184`.

### 7171 is a client-side constant

A 15.25 client only speaks to an in-binary login server on port **7171**. On any other port it
sends the login to HTTP login instead. The port cannot be moved, renegotiated or advertised
elsewhere, so **anything colliding with 7171 has to be the thing that moves.** That is why the boot
refuses on a collision rather than logging it: the fixable side is always the other listener.

### One login listener for the whole deployment

Because 7171 cannot vary, N worlds on one host cannot each run a login listener — they would all try
to bind the same port on the same address.

The recommended arrangement is **one login listener for the entire deployment**:

- exactly one world sets `login_port = 7171`,
- every other world sets `login_port = 0`.

This is safe because the world list is identical everywhere by construction: `config/worlds.toml`
is deployed byte-identical, so the list the login-serving world hands the client is the same list
any other world would have handed it. The login-serving world is not special in any other way — it
holds no extra state, and the character list it builds is read live from every world's schema on the
shared MySQL instance, not from its own process.

**Failover is flipping that one key.** Set `login_port = 0` on the world that has it, set
`login_port = 7171` on another, restart both. Nothing else changes, and no world list has to be
edited.

The alternative, if you want a login listener per world, is to give each world its own address:
set `bind_only_global_address = true` and a distinct `[network].ip` per world. With that flag every
listener binds `[network].ip` instead of `0.0.0.0`, so two worlds on separate addresses can each
hold 7171. Note that `[network].ip` is also what the registry checks against the world's
`worlds.toml` `address`, so the row has to name the same address — which it should anyway.

---

## MySQL

**Every world's schema must live on one MySQL instance.** This is not a preference. The
cross-world character list is a single connection that schema-qualifies each world's `players`
table — one `COUNT(*)` plus one `SELECT name` per world, per login — and the shared auth schema is
reached through per-world views on that same connection. Split the worlds across instances and the
design stops working.

### Grants

The MySQL user must hold `SELECT` on **every** world's schema, not just its own:

```sql
GRANT SELECT ON `blacktek_world_0`.* TO '<user>'@'%';
GRANT SELECT ON `blacktek_world_1`.* TO '<user>'@'%';   -- ... and so on
```

and, because the views are created `SQL SECURITY INVOKER`, on the auth schema in its own right:

```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON `arkot_auth`.* TO '<user>'@'%';
```

A world that lacks the `SELECT` on some other world's schema still boots and still serves its own
players. It **warns per world that fails**, at boot and again at each login, and that world's
characters are simply missing from the list:

```
cannot read `blacktek_world_1`.`players` for world 'BlackTek-Hardcore' (id 1);
that world's characters will be missing from the character list.
Grant this MySQL user SELECT on that schema.
```

One unreachable world never stops another world from serving. That is deliberate — the queries are
issued one per world rather than as a single `UNION`, so a failure costs one world's characters
instead of the whole list.

### `auth_schema.sql`

Run it **once for the auth schema and once per world for that world's views**. Both happen in the
same invocation: sections 1 and 3 are idempotent, and section 1 is a no-op after the first world.

```bash
sed -e 's/__AUTH_SCHEMA__/arkot_auth/g' \
    -e 's/__WORLD_SCHEMA__/blacktek_world_0/g' \
    auth_schema.sql | mysql -h 127.0.0.1 -P 3307 -u root -p
```

`__AUTH_SCHEMA__` must equal `[mysql].auth_database`; `__WORLD_SCHEMA__` must equal that world's
`[mysql].database`.

Section 2 — the one-time hoist of an existing world's rows, and the `DROP TABLE`s it needs — ships
commented out and destroys data. Read its notes before uncommenting anything, and take a
`mysqldump` first. A fresh schema imported from `schema.sql` still owns real `accounts`,
`account_sessions` and `store_history` tables, and a view cannot take a name a base table holds, so
2b and 2c are needed even for a brand-new world.

Section 4 — the cross-schema foreign keys — also ships commented out, and is one of the three
unverified items at the top of this document.

### What the boot probes do

With `auth_database` set and different from `database`:

| Probe | On failure |
| --- | --- |
| `accounts` is readable from this world's schema | **Refuses to boot** |
| `accounts`, `account_sessions` and `store_history` are all **views** in this world's schema | **Refuses to boot** — this world was never provisioned against the auth schema, and would otherwise quietly authenticate against its own stale account table |
| All three exist as **base tables** in the auth schema | **Refuses to boot** — run section 1 |
| Each view's stored definition names the auth schema | Warns only; the definition text is also empty without `SHOW VIEW` |
| Each registry world's `<schema>.players` is readable | Warns per world, as above |

The per-world `players` probe only runs when the shared auth schema is configured. With
`auth_database` empty there is no probe at all — but the cross-world character list still queries
every registry world at login time, so a missing grant shows up as a per-login warning instead of a
boot warning.

### What stays per-world

`account_storage`, `account_bans`, `account_ban_history` and `account_viplist` are **not** hoisted.
Consequences, stated because players will notice them: account storage is per-world, a ban on one
world does not bar another, and a VIP list is per-world.

### The migration rule

**A world process must never `ALTER` a hoisted table.** In a world schema `accounts`,
`account_sessions` and `store_history` are views, so an `ALTER` from a world process hits the view,
not the table. The auth schema is provisioned out of band, by `auth_schema.sql` alone — `schema.sql`
is deliberately not modified and there is no `data/migrations/` entry for it.

After any change to an auth base table, re-run section 3 for **every** world: a `SELECT *` view
freezes its column list at creation time and would otherwise keep serving the old columns.

---

## If you also deploy the login webservice

The in-binary login listener on 7171 and an `opentibiabr/login-server` instance can both be live.
They are different transports on different ports and the client's configured port picks one: 7171
means in-binary, anything else means HTTP login. Nothing in the server chooses.

**If the webservice is deployed, its `SERVER_NAME`, `SERVER_IP` and `SERVER_PORT` must equal that
world's `worlds.toml` row — `name`, `address` and `port`.**

A client that logs in over HTTP takes its world name from what the webservice told it and sends that
name as the plaintext preamble on the game connection. The game protocol refuses any client
announcing a world that is not this one:

```
This is <world>. Please pick that world in your client's world list.
```

If `SERVER_NAME` and the registry `name` disagree, **every** HTTP-login player is refused. That is a
total outage for the HTTP path, not a degradation, and players logging in through 7171 are
unaffected — which makes it easy to miss. Only case and surrounding whitespace are tolerated in that
comparison.

**Nothing in the server can verify this.** The registry proves that a world's row agrees with its
own process; it has no knowledge of the webservice's environment at all. The check is yours to make
and to keep making.

A `SERVER_IP`/`SERVER_PORT` mismatch is less dramatic: HTTP players dial whatever the webservice
says, in-binary players dial the registry row, and they end up on different servers or on nothing.

---

## Worked example: two worlds on one host

`config/worlds.toml`, identical in both directories:

```toml
[[world]]
id      = 0
name    = "BlackTek"
address = "127.0.0.1"
port    = 7183
schema  = "blacktek_world_0"

[[world]]
id      = 1
name    = "BlackTek-Hardcore"
address = "127.0.0.1"
port    = 7283
schema  = "blacktek_world_1"
```

| | `/srv/world0` | `/srv/world1` |
| --- | --- | --- |
| `[world].id` | `0` | `1` |
| `[network].ip` | `127.0.0.1` | `127.0.0.1` |
| `[network].game_port_modern` | `7183` | `7283` |
| `[network].status_port` | `7184` | `7284` |
| `[network].login_port` | `7171` | `0` |
| `[mysql].database` | `blacktek_world_0` | `blacktek_world_1` |
| `[mysql].auth_database` | `arkot_auth` | `arkot_auth` |
| `key.pem` | its own copy | its own copy |

Provisioning, once:

```bash
sed -e 's/__AUTH_SCHEMA__/arkot_auth/g' -e 's/__WORLD_SCHEMA__/blacktek_world_0/g' \
    auth_schema.sql | mysql -h 127.0.0.1 -P 3307 -u root -p
sed -e 's/__AUTH_SCHEMA__/arkot_auth/g' -e 's/__WORLD_SCHEMA__/blacktek_world_1/g' \
    auth_schema.sql | mysql -h 127.0.0.1 -P 3307 -u root -p
```

Then start each world from its own directory. World 0 holds the only login listener; a client
pointed at `127.0.0.1:7171` sees both worlds and, under each, only that world's characters.

---

## Limits and costs

| | |
| --- | --- |
| Worlds on the wire | 255. The registry allows 256 ids; the 256th is clamped off the list with a warning. |
| Characters in the list | 255, across all worlds combined, clamped with a warning. |
| Queries per login | Two per world — one `COUNT(*)`, one `SELECT name` — on the one connection. This number has never been measured under load. |
| Account Manager | With `[account_manager].enabled = true`, an "Account Manager" entry is offered once **per world**, so N worlds means N entries in the list. |

---

## Known stale elsewhere

`Dockerfile`, `docker-compose.yaml` and the port line in `README.md` predate this work and are not
updated by it — the compose file still maps 7171/7172/7173 and cannot serve a world, which
`README.md` already records. Do not read ports out of them.
