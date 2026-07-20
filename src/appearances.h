// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.
// Loader shape referenced from opentibiabr/canary (GPL-2.0), items.cpp loadFromProtobuf.

#ifndef FS_APPEARANCES_H
#define FS_APPEARANCES_H

#include <cstdint>
#include <string>

#include <gtl/phmap.hpp>

namespace BlackTek {
	namespace Assets
	{
		// The subset of appearance flags the protocol layer cares about: the
		// wire format of an item depends on what the CLIENT believes about the
		// appearance id we send (stackable -> count byte, fluid -> subtype
		// byte, container -> slots, podium -> extra block). If these disagree
		// with the server's ItemType for the mapped id, the stream desyncs -
		// so they exist here to be checked against, not to drive gameplay.
		struct AppearanceInfo
		{
			std::string name;
			bool container = false;
			bool stackable = false;
			bool liquidContainer = false;
			bool liquidPool = false;
			bool ground = false;
			bool podium = false;
			bool wrappable = false;
			bool unwrappable = false;
			bool pickupable = false;
			bool marketable = false;
			// 12.6+ wire-format extras: each one makes the client read more
			// bytes after the item id (tier, duration, charges, kit id)
			uint32_t classification = 0;
			bool wearOut = false;
			bool clockExpire = false;
			bool expire = false;
			bool expireStop = false;
			bool wrapKit = false;
		};

		// Parsed view of a modern client's protobuf appearances.dat. Loading
		// is optional: without the file the server still runs, the modern id
		// mapping just goes unvalidated (and Phase C parity checks are off).
		class Appearances
		{
			public:
				// non-copyable
				Appearances(const Appearances&) = delete;
				Appearances& operator=(const Appearances&) = delete;

				static Appearances& getInstance() {
					static Appearances instance;
					return instance;
				}

				bool load(const std::string& path);

				[[nodiscard]] bool isLoaded() const {
					return loaded;
				}

				[[nodiscard]] const AppearanceInfo* getObject(uint32_t appearanceId) const {
					auto it = objects.find(appearanceId);
					return it != objects.end() ? &it->second : nullptr;
				}

				[[nodiscard]] size_t objectCount() const {
					return objects.size();
				}

			private:
				Appearances() = default;

				gtl::flat_hash_map<uint32_t, AppearanceInfo> objects;
				bool loaded = false;
		};
	}
}

#endif
