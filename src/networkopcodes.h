// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#pragma once
#include <cstdint>

namespace BlackTek {
    namespace Network
    {
        // For clarity, the client codes are codes which come
        // from the client, not the ones sent to it
        enum class ClientCode : uint8_t
        {
            CounterOffer = 0x01,
            Exit = 0x0F,
            Logout = 0x14,
            PingBack = 0x1D,
            Ping = 0x1E,
            ExtendedOpcode = 0x32,

            // Movement
            AutoWalk = 0x64,
            MoveNorth = 0x65,
            MoveEast = 0x66,
            MoveSouth = 0x67,
            MoveWest = 0x68,
            StopAutoWalk = 0x69,
            MoveNorthEast = 0x6A,
            MoveSouthEast = 0x6B,
            MoveSouthWest = 0x6C,
            MoveNorthWest = 0x6D,

            // Turning
            TurnNorth = 0x6F,
            TurnEast = 0x70,
            TurnSouth = 0x71,
            TurnWest = 0x72,

            // Item & UI Interactions
            EquipObject = 0x77,
            Throw = 0x78,
            LookInShop = 0x79,
            Purchase = 0x7A,
            Sale = 0x7B,
            CloseShop = 0x7C,
            RequestTrade = 0x7D,
            LookInTrade = 0x7E,
            AcceptTrade = 0x7F,
            CloseTrade = 0x80,
            UseItem = 0x82,
            UseItemEx = 0x83,
            UseWithCreature = 0x84,
            RotateItem = 0x85,
            // missing = 0x86,
            CloseContainer = 0x87,
            UpArrowContainer = 0x88,
            TextWindow = 0x89,
            HouseWindow = 0x8A,
            WrapItem = 0x8B,
            LookAt = 0x8C,
            LookInBattleList = 0x8D,
            JoinAggression = 0x8E, // unhandled

            // General Chat / Communication
            Say = 0x96,
            RequestChannels = 0x97,
            OpenChannel = 0x98,
            CloseChannel = 0x99,
            OpenPrivateChannel = 0x9A,
            CloseNpcChannel = 0x9E,

            // Combat & Party Stuff
            FightMode = 0xA0,
            Attack = 0xA1,
            Follow = 0xA2,
            InviteToParty = 0xA3,
            JoinParty = 0xA4,
            RevokePartyInvite = 0xA5,
            PassPartyLeadership = 0xA6,
            LeaveParty = 0xA7,
            EnableSharedPartyExperience = 0xA8,
            CreatePrivateChannel = 0xAA,
            ChannelInvite = 0xAB,
            ChannelExclude = 0xAC,
            CancelAttackAndFollow = 0xBE,

            // Tile / Container Operations
            UpdateTile = 0xC9, // unhandled
            UpdateContainer = 0xCA,
            BrowseField = 0xCB,
            SeekInContainer = 0xCC,

            // Player Customization
            RequestOutfit = 0xD2,
            SetOutfit = 0xD3,
            ToggleMount = 0xD4,

            // Vip Management
            AddVip = 0xDC,
            RemoveVip = 0xDD,
            EditVip = 0xDE,

            // Reports & Debug
            BugReport = 0xE6,
            ThankYou = 0xE7, // unhandled
            DebugAssert = 0xE8,
            // missing = 0xEE,

            // Quests
            ShowQuestLog = 0xF0,
            QuestLine = 0xF1,
            RuleViolationReport = 0xF2,
            GetObjectInfo = 0xF3, // unhandled

            // Market
            MarketLeave = 0xF4,
            MarketBrowse = 0xF5,
            MarketCreateOffer = 0xF6,
            MarketCancelOffer = 0xF7,
            MarketAcceptOffer = 0xF8,

            // Modal Window
            ModalWindowAnswer = 0xF9,

            // Game Store
            GameStoreRequest    = 0xFA,
            StoreSelectCategory = 0xFB,
            StoreBuyOffer       = 0xFC,
            StoreOpenHistory    = 0xFD,
            StoreRequestHistory = 0xFE,

            // --- Modern clients (13.40+) below this line ---
            // Verified against opentibiabr/canary's dispatch switch. Handlers
            // arrive with their systems; the names land first so nothing in
            // the codebase ever has to say "case 0x28:".
            // Three legacy bytes are reused by modern clients with different
            // payloads and stay under their legacy names above until the
            // feature-gated handlers land: 0xC9 (UpdateTile -> transaction
            // details), 0xE7 (ThankYou -> wheel gem action), 0xE8
            // (DebugAssert -> store offer description), 0xCA
            // (UpdateContainer -> exiva restrictions).

            // Stash & depot search
            StashWithdraw = 0x28,
            RetrieveDepotSearch = 0x29,
            OpenDepotSearch = 0x92,
            CloseDepotSearch = 0x93,
            DepotSearchItemRequest = 0x94,

            // Cyclopedia & analytics
            CyclopediaMonsterTracker = 0x2A,
            PartyAnalyzerAction = 0x2B,
            LeaderFinderWindow = 0x2C,
            MemberFinderWindow = 0x2D,
            CyclopediaHouseAuction = 0xAD,
            RequestHighscores = 0xB1,
            CyclopediaMapAction = 0xDB,
            CyclopediaCharacterInfo = 0xE5,

            // Client state & misc
            SetClientOptions = 0x2E,
            PlayerTyping = 0x38,
            ClientCheck = 0x63,
            Teleport = 0x73,
            StartOfflineTraining = 0x74,
            ContainerAction = 0x75,
            CharacterTradeConfiguration = 0x76,
            FriendSystemAction = 0x81,
            ClientDetails = 0xC1,
            AimAtTarget = 0xC8,
            GetTextForReport = 0x9D,
            Greet = 0xEE,

            // Imbuements
            InventoryImbuements = 0x60,
            ImbuementDurations = 0xB2,
            ApplyImbuement = 0xD5,
            ClearImbuement = 0xD6,
            CloseImbuementWindow = 0xD7,

            // Wheel of Destiny
            OpenWheel = 0x61,
            SaveWheel = 0x62,

            // Quickloot
            QuickLoot = 0x8F,
            LootContainer = 0x90,
            QuickLootBlackWhitelist = 0x91,
            OpenParentContainer = 0x95,

            // Guild & VIP extensions
            EditGuildMessage = 0x9C,
            VipGroupActions = 0xDF,

            // Podium
            SetMonsterPodium = 0x9F,
            ConfigureShowOffSocket = 0x86,

            // Bosstiary & bestiary
            RequestBosstiary = 0xAE,
            RequestBosstiarySlots = 0xAF,
            BosstiarySlot = 0xB0,
            BossDifficultySelection = 0xC2,
            BestiaryRaces = 0xE1,
            BestiaryCreatures = 0xE2,
            BestiaryMonsterData = 0xE3,
            BuyCharmRune = 0xE4,

            // Weapon proficiency (14.x+)
            WeaponProficiency = 0xB3,

            // Hunting tasks & prey
            TaskHuntingAction = 0xBA,
            PreyAction = 0xEB,

            // Forge
            ForgeEnter = 0xBF,
            ForgeBrowseHistory = 0xC0,

            // Inspection
            InspectionObject = 0xCD,
            InspectPlayer = 0xCE,

            // Misc systems
            RequestBlessingsDialog = 0xCF,
            SetHirelingName = 0xEC,
            RequestResourceBalance = 0xED,
            RewardChestCollect = 0xFF
        };

        // Again, for clarity, the server codes are the
        // ones sent by the server, not recieved by it.
        enum class ServerCode : uint8_t
        {
            // Connection & Session
            PendingStateEntered = 0x0A,
            EnterWorld = 0x0F,
            LoginOrPendingState = 0x14,
            FyiBox = 0x15,
            LoginQueue = 0x16,
            Challenge = 0x1F,
            Death = 0x28,
            Ping = 0x1D,
            PingBack = 0x1E,
            ExtendedOpcode = 0x32,

            // Map & Tiles
            MapDescription = 0x64,
            MoveNorth = 0x65,
            MoveEast = 0x66,
            MoveSouth = 0x67,
            MoveWest = 0x68,
            UpdateTile = 0x69,
            AddTileThing = 0x6A,
            UpdateTileThing = 0x6B,
            RemoveTileThing = 0x6C,
            MoveCreature = 0x6D,

            // Container Management
            Container = 0x6E,
            CloseContainer = 0x6F,
            AddContainerItem = 0x70,
            UpdateContainerItem = 0x71,
            RemoveContainerItem = 0x72,

            // Inventory
            InventoryItem = 0x78,
            EmptyInventory = 0x79,

            // Shop
            NpcShop = 0x7A,
            SaleItemList = 0x7B,
            CloseNpcShop = 0x7C,
            TradeItemRequest = 0x7D,
            TradeAcknowledged = 0x7E,
            CloseTrade = 0x7F,

            // Animations & Text
            WorldLight = 0x82,
            MagicEffect = 0x83,
            DistanceShoot = 0x85,
            CreatureHealth = 0x8C,
            CreatureLight = 0x8D,
            CreatureOutfit = 0x8E,
            CreatureSpeed = 0x8F,
            CreatureSkull = 0x90,
            CreatureShield = 0x91,
            CreatureWalkthrough = 0x92,
            CreatureSquare = 0x93,
            CreatureHelpers = 0x94,
            CreatureType = 0x95,

            // Windows
            TextWindow = 0x96,
            HouseWindow = 0x97,

            // Stats
            BasicData = 0x9F,
            PlayerStats = 0xA0,
            PlayerSkills = 0xA1,

            // Visual Display / Icon Stuff
            Icons = 0xA2,
            CancelTarget = 0xA3,
            SpellCooldown = 0xA4,
            SpellGroupCooldown = 0xA5,
            FightMode = 0xA7,

            // Chat / Communication
            CreatureSay = 0xAA,
            ChannelsDialog = 0xAB,
            SendChannel = 0xAC,
            OpenPrivateChannel = 0xAD,
            CreatePrivateChannel = 0xB2,
            ClosePrivateChannel = 0xB3,
            TextMessage = 0xB4,
            CancelWalk = 0xB5,

            // WalkWait = 0xB6, // Not implemented
            UnjustifiedStats = 0xB7,  // Unjustified kill statistics
            PvpSituations = 0xB8,     // Open PvP situations count

            // Floor Changes
            FloorChangeUp = 0xBE,
            FloorChangeDown = 0xBF,

            // Player Customization
            OutfitWindow = 0xC8,

            // Vip
            VipEntry = 0xD2,
            VipStatus = 0xD3,

            // Tutorial & Map Marker
            Tutorial = 0xDC,
            MapMarker = 0xDD,

            // Quests
            QuestLog = 0xF0,
            QuestLine = 0xF1,


            ChannelEvent = 0xF3,
            SendItems = 0xF5,

            // Market
            MarketEnter = 0xF6,
            MarketLeave = 0xF7,
            MarketDetail = 0xF8,
            MarketAction = 0xF9,

            // Modal Window
            ModalWindow = 0xFA,

            // Game Store
            StoreCategories     = 0xFB,
            StoreOffers         = 0xFC,
            StoreHistory        = 0xFD,
            StorePurchaseResult = 0xFE,

            // Special Messages
            LoginSuccess = 0x17,
            ReLoginWindow = 0x28,
        };

        enum class SpecialCode : uint16_t 
        {
            False = 0x00,
            True = 0x01,
            AddCreature = 0x61,
            AddKnownCreature = 0x62,
            CreatureTurn = 0x63,
            End = 0xFFFF,

            Zero = False
        };

        enum class CommonCode : uint8_t
        {
            False = 0x00,
            True = 0x01,
            Final = 0xFE,
            End = 0xFF,

            Zero = False
        };

    }
}