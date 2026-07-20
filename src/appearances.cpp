// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.
// Loader shape referenced from opentibiabr/canary (GPL-2.0), items.cpp loadFromProtobuf.

#include "otpch.h"

#include "appearances.h"
#include "console.h"

#include <appearances.pb.h>

#include <fstream>

namespace BlackTek::Assets
{
	bool Appearances::load(const std::string& path)
	{
		std::ifstream fileStream(path, std::ios::in | std::ios::binary);
		if (not fileStream.is_open())
		{
			Console::Warn("Appearances file not found at {}; modern id validation disabled", path);
			return false;
		}

		Canary::protobuf::appearances::Appearances parsed;
		if (not parsed.ParseFromIstream(&fileStream))
		{
			Console::Error("Failed to parse protobuf appearances from {}", path);
			return false;
		}

		objects.clear();
		objects.reserve(parsed.object_size());

		for (int index = 0; index < parsed.object_size(); ++index)
		{
			const auto& object = parsed.object(index);
			if (not object.has_id() or not object.has_flags())
			{
				continue;
			}

			const auto& flags = object.flags();
			AppearanceInfo info;
			info.name = object.name();
			info.container = flags.container();
			info.stackable = flags.cumulative();
			info.liquidContainer = flags.liquidcontainer();
			info.liquidPool = flags.liquidpool();
			info.ground = flags.has_bank();
			info.podium = flags.show_off_socket();
			info.wrappable = flags.wrap();
			info.unwrappable = flags.unwrap();
			info.pickupable = flags.take();
			info.marketable = flags.has_market();
			if (flags.has_upgradeclassification())
			{
				info.classification = flags.upgradeclassification().upgrade_classification();
			}
			info.wearOut = flags.wearout();
			info.clockExpire = flags.clockexpire();
			info.expire = flags.expire();
			info.expireStop = flags.expirestop();
			info.wrapKit = flags.wrapkit();
			objects.emplace(object.id(), std::move(info));
		}

		loaded = true;
		return true;
	}
}
