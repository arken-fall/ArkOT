# Raids

The engine is complete and runs: `announce`, `singlespawn`, `areaspawn` and `script` events,
loaded at `GAME_STATE_INIT` and checked on a scheduler (`src/raids.cpp`). It reloads with
`/reload raids`. What is missing is content — there is not one real raid for this map.

`example_raids.toml.disabled` is upstream demo content, kept as a format reference and
deliberately not loaded. It shipped three repeating raids whose spawn coordinates are
`[800,800,7]`, `[1000,1000,7]` and a radius around `[900,900,7]`. The Canary map's real
coordinates are around 32000, so nothing ever spawned — but the `announce` events fired on
schedule and broadcast to every player online, every two to four hours, promising an invasion
that never came. It was doing exactly that in production until it was disabled.

Only files ending `.toml` are loaded, so the `.disabled` suffix is what keeps it off.

## Writing a real one

A raid needs a name, an interval and margin in minutes, and an event list. Announcements are
free; the spawns need coordinates that exist on this map. Read them off the map editor at the
invasion site, then:

    [[thais_orc_raid.events]]
    type = "areaspawn"
    delay = 65000
    from = [32900, 31950, 7]
    to   = [32930, 31980, 7]

Pick the sites first — which cities get raided, by what, and how often — because everything
else is transcription.
