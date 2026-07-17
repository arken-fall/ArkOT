// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.
// Wire layouts referenced from opentibiabr/canary (GPL-2.0), protocol_profile.hpp / protocolgame.cpp.

#pragma once
#include <array>
#include <cstdint>
#include <string>
#include <string_view>

namespace BlackTek {
	namespace Network
	{
		// Which framing generation a connection speaks. Legacy is the classic
		// adler32 + inner-length wire format every 7.x-11.x client uses. Modern
		// (13.40+) switched to sequence numbers, a padding-byte payload layout,
		// a block-count outer length and optional deflate compression.
		//
		// The server sends the login challenge BEFORE the client says anything,
		// and the two generations need differently framed challenges - so the
		// generation is decided by which game port the client connected to, not
		// by sniffing bytes. resolveProfile() then has to agree with the port.
		enum class TransportGeneration : uint8_t
		{
			Legacy,
			Modern,
		};

		enum class ChecksumMode : uint8_t
		{
			Adler32,
			Sequence,
		};

		enum class ProtocolProfileId : uint8_t
		{
			Legacy1098,
			Modern1340,
			Modern1412,
			Modern1525,
		};

		// One bit per capability the packet layer can branch on. Packet code
		// tests features, never raw version numbers - the only place a version
		// number is allowed to appear is the registry at the bottom of this
		// file. Add a bit here when a ported system needs a new branch.
		enum class ProtocolFeature : uint64_t
		{
			None                  = 0,

			// transport & login
			SessionKeyLogin       = 1ULL << 0,  // single session-key string instead of acc/pass fields
			SequenceChecksum      = 1ULL << 1,  // u32 sequence replaces adler32 after the first packet
			CompressedFrames      = 1ULL << 2,  // outbound deflate when body >= 128 bytes, high bit of sequence flags it

			// asset / id pipeline
			ProtobufAppearances   = 1ULL << 3,  // client ids and flags come from appearances.dat protobuf
			ItemsOverU16Capacity  = 1ULL << 4,  // client item id space needs guarding above u16 writers

			// payload layout deltas
			ExtendedMagicEffects  = 1ULL << 5,  // 0x83 carries u16 effect ids and a loop terminator
			PlayerLevelPercentU16 = 1ULL << 6,  // 0xA0 level percent is a centesimal u16, not u8

			// modern side systems (each one is a stub until its phase lands)
			ResourceBalance       = 1ULL << 7,
			PreySystem            = 1ULL << 8,
			Bestiary              = 1ULL << 9,
			Bosstiary             = 1ULL << 10,
			WheelOfDestiny        = 1ULL << 11,
			Forge                 = 1ULL << 12,
			StoreButtons          = 1ULL << 13,
			BlessingsDialog       = 1ULL << 14,
			ClientCheck           = 1ULL << 15,
			TypingIndicator       = 1ULL << 16,
			WeaponProficiency     = 1ULL << 17, // 14.x+ only
			QuickLootAndStash     = 1ULL << 18,
			DepotSearch           = 1ULL << 19,
			Cyclopedia            = 1ULL << 20,
			Imbuements            = 1ULL << 21,
			Analyzers             = 1ULL << 22,
			Podiums               = 1ULL << 23,
			ObjectInspection      = 1ULL << 24,
		};

		[[nodiscard]] constexpr ProtocolFeature operator|(ProtocolFeature left, ProtocolFeature right)
		{
			return static_cast<ProtocolFeature>(static_cast<uint64_t>(left) | static_cast<uint64_t>(right));
		}

		// The first game packet's field order differs per generation, and getting
		// it wrong shows up downstream as a bogus "RSA decrypt failed" - so the
		// order lives here as data instead of inline reads scattered with ifs.
		//
		// Field order when the flag is set (fields listed in read order):
		//   0x0A byte (consumed by Connection), OS u16, protocol version u16,
		//   [clientVersionU32] [clientVersionString] [assetHashString]
		//   [clientTypeU8] [contentRevisionU16] [previewStateU8]
		//   RSA block: zero u8, XTEA key u32 x4, gamemaster u8,
		//   [sessionKeyLogin ? session-key string : acc/pass/token bundle string]
		//   character name string, challenge timestamp u32, challenge random u8,
		//   [otcV8Probe]
		struct GameLoginLayout
		{
			bool clientVersionU32 = false;
			bool clientVersionString = false;
			bool assetHashString = false;
			bool contentRevisionU16 = false;
			bool clientTypeU8 = false;
			bool previewStateU8 = false;
			bool sessionKeyLogin = false;
			bool otcV8Probe = false;
		};

		struct ProtocolProfile
		{
			ProtocolProfileId id = ProtocolProfileId::Legacy1098;
			TransportGeneration generation = TransportGeneration::Legacy;
			uint16_t versionMin = 0;
			uint16_t versionMax = 0;
			GameLoginLayout loginLayout {};
			uint64_t features = 0;
			std::string_view name;

			[[nodiscard]] constexpr bool hasFeature(ProtocolFeature feature) const
			{
				return (features & static_cast<uint64_t>(feature)) != 0;
			}
		};

		namespace Detail
		{
			// 10.98 sends its version block before the RSA chunk exactly like it
			// always did: u32 client version, u8 client type, u16 dat revision.
			inline constexpr GameLoginLayout legacy1098Layout {
				.clientVersionU32 = true,
				.contentRevisionU16 = true,
				.clientTypeU8 = true,
			};

			// Verified against canary's current parser for 15.25. The 13.40 and
			// 14.12 rows reuse it - canary only keeps the current layout around,
			// so treat those two as ASSUMED until a mehah capture confirms them.
			inline constexpr GameLoginLayout modernLayout {
				.clientVersionU32 = true,
				.clientVersionString = true,
				.assetHashString = true,
				.previewStateU8 = true,
				.sessionKeyLogin = true,
				.otcV8Probe = true,
			};

			inline constexpr uint64_t modernCommonFeatures = static_cast<uint64_t>(
				ProtocolFeature::SessionKeyLogin
				| ProtocolFeature::SequenceChecksum
				| ProtocolFeature::CompressedFrames
				| ProtocolFeature::ProtobufAppearances
				| ProtocolFeature::ItemsOverU16Capacity
				| ProtocolFeature::ExtendedMagicEffects
				| ProtocolFeature::PlayerLevelPercentU16
				| ProtocolFeature::ResourceBalance
				| ProtocolFeature::PreySystem
				| ProtocolFeature::Bestiary
				| ProtocolFeature::Bosstiary
				| ProtocolFeature::WheelOfDestiny
				| ProtocolFeature::Forge
				| ProtocolFeature::StoreButtons
				| ProtocolFeature::BlessingsDialog
				| ProtocolFeature::ClientCheck
				| ProtocolFeature::TypingIndicator
				| ProtocolFeature::QuickLootAndStash
				| ProtocolFeature::DepotSearch
				| ProtocolFeature::Cyclopedia
				| ProtocolFeature::Imbuements
				| ProtocolFeature::Analyzers
				| ProtocolFeature::Podiums
				| ProtocolFeature::ObjectInspection);
		}

		// Version bands are protocol versions as the client reports them in the
		// login packet (1340 = 13.40). The modern bands are deliberately narrow;
		// widen them only after testing an actual client from that band.
		inline constexpr std::array<ProtocolProfile, 4> profileRegistry { {
			{
				.id = ProtocolProfileId::Legacy1098,
				.generation = TransportGeneration::Legacy,
				.versionMin = 1097,
				.versionMax = 1098,
				.loginLayout = Detail::legacy1098Layout,
				.features = static_cast<uint64_t>(ProtocolFeature::None),
				.name = "10.98",
			},
			{
				.id = ProtocolProfileId::Modern1340,
				.generation = TransportGeneration::Modern,
				.versionMin = 1332,
				.versionMax = 1340,
				.loginLayout = Detail::modernLayout,
				.features = Detail::modernCommonFeatures,
				.name = "13.40",
			},
			{
				.id = ProtocolProfileId::Modern1412,
				.generation = TransportGeneration::Modern,
				.versionMin = 1405,
				.versionMax = 1412,
				.loginLayout = Detail::modernLayout,
				.features = Detail::modernCommonFeatures | static_cast<uint64_t>(ProtocolFeature::WeaponProficiency),
				.name = "14.12",
			},
			{
				.id = ProtocolProfileId::Modern1525,
				.generation = TransportGeneration::Modern,
				.versionMin = 1520,
				.versionMax = 1525,
				.loginLayout = Detail::modernLayout,
				.features = Detail::modernCommonFeatures | static_cast<uint64_t>(ProtocolFeature::WeaponProficiency),
				.name = "15.25",
			},
		} };

		// The one place a raw version number is allowed to meet the code. The
		// generation must match the port the client walked in through; a modern
		// version on the legacy port (or the reverse) resolves to nothing and
		// the caller disconnects.
		[[nodiscard]] constexpr const ProtocolProfile* resolveProfile(uint16_t version, TransportGeneration generation)
		{
			for (const auto& profile : profileRegistry)
			{
				if (profile.generation == generation and version >= profile.versionMin and version <= profile.versionMax)
				{
					return &profile;
				}
			}
			return nullptr;
		}

		// "10.98, 13.40, 14.12 and 15.25" for disconnect messages, built from
		// the registry so it can never drift out of sync with it.
		[[nodiscard]] inline std::string allowedProtocolVersions()
		{
			std::string result;
			for (size_t i = 0; i < profileRegistry.size(); ++i)
			{
				if (i > 0)
				{
					result += (i + 1 == profileRegistry.size()) ? " and " : ", ";
				}
				result += profileRegistry[i].name;
			}
			return result;
		}
	}
}
