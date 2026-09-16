// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_ACCOUNT_H
#define FS_ACCOUNT_H

#include "enums.h"
#include "world.h"

// One character offered to the client, tagged with the world it lives on.
// A character belongs to one world forever, so the tag is set once, where the
// row is read, and never recomputed. Plain aggregate: no invariant of its own.
struct CharacterEntry
{
	std::string			name;
	BlackTek::World::Id	world = 0;
};

using CharacterList = std::vector<CharacterEntry>;

struct Account {
	CharacterList characters;
	std::string name;
	std::string key;
	uint32_t id = 0;
	time_t premiumEndsAt = 0;
	AccountType_t accountType = ACCOUNT_TYPE_NORMAL;

	Account() = default;
};

#endif
