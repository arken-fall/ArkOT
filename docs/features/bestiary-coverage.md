# Bestiary coverage

Companion list to `featureslist.md`. Generated from `data/scripts/monsters/**/*.lua` at commit
da50459. Every figure is a count of the checkout, not an estimate. **Counts are of distinct
monster names**, not files — 15 names are declared by more than one file, and a name counts as
covered if any of its files declares a bestiary block.

|~~~~~~~~~~~~~~~~~~~~~~~~~               | 62%

**676 of 1097 eligible monsters carry a bestiary entry. 421 do not.**

## Why this is not "741 of 1,712"

The README's 43% divides 741 entries by every monster file in the tree. That denominator counts
a great deal that was never supposed to have a bestiary entry:

| Excluded from the denominator | Names | Why |
| --- | ---: | --- |
| Bosstiary-marked monsters | 139 | They belong to the **Bosstiary**, a separate system with no implementation here. None carries a bestiary entry, which is correct. |
| `canary/quests/` | 377 | Quest-only spawns; Tibia does not list most of these. |
| `canary/event_creatures/` | 26 | Seasonal and event spawns. |
| `canary/raids/` | 16 | Raid spawns. |
| `canary/bosses/` | 13 | Boss folder, pre-dating the bosstiary marker. |
| `canary/nostalgia/` | 8 | Nostalgia-server variants. |
| `canary/familiars/` | 5 | Summoned familiars, not huntable. |
| `canary/dawnport/` | 3 | Tutorial island spawns. |
| `canary/trainers/` | 1 | Training dummies. |

That leaves **1097** monsters that genuinely should appear in the bestiary, of which
**676** do — **62%**, not 43%. The work remaining is 421 entries, not 971.

**One caveat, stated rather than hidden:** the missing column still contains old-world bosses —
Abyssador, Annihilon, Apocalypse, Arachir The Ancient One among them — that pre-date the
`monster.bosstiary` marker this count relies on. They arguably belong to the Bosstiary as well,
which would push the real figure above 62%. Sorting them needs a judgement per monster, so
they are left in and flagged here rather than quietly dropped to flatter the number.

Each missing entry is a `monster.bestiary = { race, class, toKill, firstUnlock, secondUnlock,
charmPoints, stars, occurrence, locations }` block added to that monster's Lua file. Pure
datapack work, no engine change, and it reloads without a restart.

**Rewards unlocked by finishing this:** bestiary progress and unlock tiers, charm points and the
charms they buy, and prey list eligibility — prey draws its nine candidates from bestiary
creatures, so every missing entry is also a monster that can never appear as prey.

---

## Missing a bestiary entry (421)

| | | |
| --- | --- | --- |
| Abyssador | Golgordan | Robby the Reckless |
| Abyssal Calamary | Gorgo | Rocko |
| Achad | Grand Mother Foulscale | Rocky |
| Agressive Chicken | Grandfather Tridian | Rogue Naga |
| Amarie | Gravelord Oshuran | Ron the Ripper |
| Angry Adventurer | Greater Death Minion | Rottie The Rotworm |
| Annihilon | Greed | Rotworm Queen |
| Apocalypse | Grimeleech | Rukor Zad |
| Apprentice Sheng | Grimgor Guteater | Running Elite Orc Guard |
| Arachir The Ancient One | Groam | Rupture |
| Armenius | Grodrik | Sacred Snake |
| Ashmunrah | Grorlam | Salamander Trainer |
| Avalanche | Guilt | Scar Tribe Shaman |
| Axeitus Headbanger | Hacker | Scorn of the Emperor |
| Azerus | Hairman The Huge | Seacrest Serpent |
| Bad Dream | Hardened Usurper Archer | Shard Of Corruption |
| Barbaria | Hardened Usurper Knight | Shardhead |
| Baron Brute | Hardened Usurper Warlock | Sharptooth |
| Battlemaster Zunzu | Haunter | Shiversleep |
| Bazir | Hazardous Phantom | Shredderthrower |
| Beast Hulking Prehemoth | Hell Hole | Shulgrax |
| Bibby Bloodbath | Hellflayer | Sir Valorcrest |
| Big Boss Trolliver | Hellgorak | Slick Water Elemental |
| Black Knight | Hemming | Slim |
| Blazing Fire Elemental | Heoni | Slippery Northern Pike |
| Blistering Fire Elemental | Hide | Sloth Wraith |
| Bloodpaw | High Templar Cobrass | Smuggler Baron Silvertoe |
| Bones | Hive Pore | Snake God Essence |
| Boogey | Horadron | Snake Thing |
| Bovinus | Horestis | Spark of Destruction |
| Breach Brood | Humorless Fungus | Spectral Scum |
| Bretzecutioner | Ice Overlord | Spider Queen |
| Brittle Skeleton | Incineron | Spirit of Earth |
| Bruise Payne | Incredibly Old Witch | Spirit of Fire |
| Brutus Bloodbeard | Infernatil | Spirit of Water |
| Bullwark | Inky | Spite of the Emperor |
| Burrowing Beetle | Instable Breach Brood | Splasher |
| Captain Jones | Instable Sparkion | Stonecracker |
| Carnisylvan Sapling | Jagged Earth Elemental | Strange Slime |
| Charged Energy Elemental | Jaul | Sulphur Scuttler |
| Charger | Jesse the Wicked | Superior Death Minion |
| Cheese Thief | Juvenile Cyclops | Svoren the Mad |
| Chikhaton | Kerberos | Swarmer Hatchling |
| Chizzoron The Distorter | Kitty | Tame Terror Bird |
| Christmas Goblin | Koshei The Deathless | Tanjis |
| Clomp | Kraknaknork | Tarbaz |
| Clubarc The Plunderer | Kraknaknork's Demon | Teleskor |
| Cockroach | Kreebosh the Exile | Terofar |
| Coldheart | Lady Bug | Thalas |
| Colerian the Barbarian | Latrivan | The Abomination |
| Corrupt Naga | Lavahole | The Axeorcist |
| Countess Sorrow | Lesser Death Minion | The Big Bad One |
| Crazed Dwarf | Lesser Fire Devil | The Blightfather |
| Cursed Gladiator | Lesser Swarmer | The Bloodtusk |
| Darakan the Executioner | Lethal Lissy | The Bloodweb |
| Dawn Scorpion | Leviathan | The Collector |
| Dawnfly | Lion Archer | The Count |
| Deadeye Devious | Lion Knight | The Dark Dancer |
| Death Dragon | Lion Warlock | The Dreadorian |
| Death Priest Shargon | Lisa | The Evil Eye |
| Deathbine | Lizard Abomination | The Fettered Shatterer |
| Deathbringer | Lord of the Elements | The Frog Prince |
| Deathslicer | Mad Sheep | The Hag |
| Deathspawn | Mad Technomancer | The Hairy One |
| Deathstrike | Madareth | The Halloween Hare |
| Deaththrower | Magic Pillar | The Handmaiden |
| Demodras | Magicthrower | The Horned Fox |
| Demon (Goblin) | Mahrdis | The Hunger |
| Demon Summoner | Man in the Cave | The Imperor |
| Depowered Minotaur | Massacre | The Many |
| Despair | Mawhawk | The Masked Marauder |
| Desperate White Deer | Mazoran | The Noxious Spawn |
| Devourer | Meadow Strider | The Obliverator |
| Dharalion | Mechanical Fighter | The Old Whopper |
| Diblis The Fair | Menace | The Old Widow |
| Dipthrah | Mephiles | The Pale Count |
| Dirtbeard | Merikh the Slaughterer | The Pit Lord |
| Diseased Bill | Mimic | The Plasmother |
| Diseased Dan | Minion Of Gaz'haragoth | The Rage |
| Diseased Fred | Minion Of Versperoth | The Ravager |
| Disgusting Ooze | Minishabaal | The Ruthless Herald |
| Doctor Perhaps | Minotaur Bruiser | The Shatterer |
| Donkey | Minotaur Invader | The Snapper |
| Doomhowl | Minotaur Occultist | The Weakened Count |
| Doomsday Cultist | Minotaur Poacher | Thief |
| Dracola | Minotaur Totem | Thieving Squirrel |
| Drasilla | Minotaur Wallbreaker | Thul |
| Dread Intruder | Monk of the Order | Tibia Bug |
| Dreadbeast | Monstor | Tiquandas Revenge |
| Dreadwing | Mooh'Tah Master | Tirecz |
| Dwarf Dispenser | Morgaroth | Tormented Ghost |
| Dwarf Miner | Morguthis | Tormentor |
| Earth Overlord | Morik The Gladiator | Training Monk |
| Elder Forest Fury | Mornenion | Travelling Merchant |
| Elite Pirat | Mountain Troll | Tremorak |
| Elvira Hammerthrust | Mr. Punish | Troll Marauder |
| Energized Raging Mage | Muddy Earth Elemental | Troll-Trained Salamander |
| Energy Overlord | Muglex Clan Assassin | Tromphonyte |
| Enpa Yolo | Muglex Clan Footman | Undead Jester |
| Enraged Squirrel | Muglex Clan Scavenger | Undead Minion |
| Enraged White Deer | Munster | Ungreez |
| Eradicator | Mutated Zalamon | Ushuriel |
| Eradicatorr | Necromancer Servant | Vashresamun |
| Esmeralda | Necropharus | Verminor |
| Essence of Darkness | Nightmare Of Gaz'haragoth | Versperoth |
| Ethershreck | Norgle Glacierbeard | Vexclaw |
| Evil Mastermind | Obujos | Warlord Ruzad |
| Eye of the Seven | Omnivora | Weakened Demon |
| Fahim the Wise | Omruc | Webster |
| Fallen Mooh'tah Master Ghar | Orcus the Cruel | Werebadger |
| Fatality | Orshabaal | Werebear |
| Fazzrah | Outburst | Wereboar |
| Fernfang | Overcharged Energy Element | Wild Dog |
| Ferumbras | Paiz The Pauperizer | Wild Fire Magic |
| Ferumbras Mortal Shell | Parasite | Wild Fury Magic |
| Fire Horse | Party Skeleton | Wild Nature Magic |
| Fire Overlord | Phantasm Summon | Wild Water Magic |
| Flame Of Omrafir | Pillar | Woodling |
| Flamethrower | Pirat Artillerist | World Bug |
| Fleshslicer | Plagirath | World Devourer |
| Floor Blob | Plaguethrower | Wounded Cave Draptor |
| Fluffy | Poodle | Wrath of the Emperor |
| Football | Primitive | Xenia |
| Foreman Kneebiter | Prince Drazzak | Yaga The Crone |
| Freegoiz | Professor Maxxen | Yakchal |
| Frenzy | Pythius The Rotten | Yalahari |
| Frostfur | Quara Trainer | Young Troll |
| Fungosaurus | Rage Of Mazoran | Zamulosh |
| Furious Orc Berserker | Ragiaz | Zanakeph |
| Fury of the Emperor | Raging Mage | Zarabustor |
| Gaz'haragoth | Rahemos | Zavarash |
| General Murius | Razzagorn | Zevelon Duskbringer |
| Ghazbaran | Reality Reaver | Zomba |
| Giant Beaver | Renegade Orc | Zoralurk |
| Glitterscale | Ribstride | Zugurosh |
| Glooth Fairy | Rift Brood | Zulazza the Corruptor |
| Glooth Powered Minotaur | Rift Lord | Zushuka |
| Glooth Slasher | Rift Phantom | a carved stone tile |
| Glooth Trasher | Rift Scythe | mad mage |
| Gnomevil | Rift Worm |  |
| Gnorre Chyllson | Roaring Water Elemental |  |

---

## Has a bestiary entry (676)

| | | |
| --- | --- | --- |
| Acid Blob | Floating Savant | Panda |
| Acolyte of Darkness | Flying Book | Parder |
| Acolyte of the Cult | Foam Stalker | Parrot |
| Adept of the Cult | Forest Fury | Penguin |
| Adult Goanna | Fox | Phantasm |
| Adventurer | Frazzlemaw | Pig |
| Afflicted Strider | Freakish Lost Soul | Pigeon |
| Agrestic Chicken | Frost Dragon | Pirat Bombardier |
| Amazon | Frost Dragon Hatchling | Pirat Cutthroat |
| Ancient Scarab | Frost Flower Asura | Pirat Mate |
| Angry Sugar Fairy | Frost Giant | Pirat Scoundrel |
| Animated Feather | Frost Giantess | Pirate Buccaneer |
| Animated Snowman | Frost Troll | Pirate Corsair |
| Arachnophobica | Fruit Drop | Pirate Cutthroat |
| Arctic Faun | Furious Troll | Pirate Ghost |
| Armadile | Fury | Pirate Marauder |
| Askarak Demon | Gang Member | Pirate Skeleton |
| Askarak Lord | Gargoyle | Pixie |
| Askarak Prince | Gazer | Plaguesmith |
| Assassin | Gazer Spectre | Poacher |
| Azure Frog | Ghastly Dragon | Poison Spider |
| Badger | Ghost | Poisonous Carnisylvan |
| Bandit | Ghost Wolf | Polar Bear |
| Bane Bringer | Ghoul | Pooka |
| Bane of Light | Ghoulish Hyaena | Priestess |
| Banshee | Giant Spider | Priestess of the Wild Sun |
| Barbarian Bloodwalker | Gingerbread Man | Putrid Mummy |
| Barbarian Brutetamer | Girtablilu Warrior | Quara Constrictor |
| Barbarian Headsplitter | Gladiator | Quara Constrictor Scout |
| Barbarian Skullhunter | Gloom Wolf | Quara Hydromancer |
| Bashmu | Glooth Anemone | Quara Hydromancer Scout |
| Bat | Glooth Bandit | Quara Looter |
| Bear | Glooth Blob | Quara Mantassin |
| Behemoth | Glooth Brigand | Quara Mantassin Scout |
| Berserker Chicken | Glooth Golem | Quara Pincher |
| Betrayed Wraith | Gnarlhound | Quara Pincher Scout |
| Biting Book | Goblin | Quara Plunderer |
| Black Sheep | Goblin Assassin | Quara Predator |
| Black Sphinx Acolyte | Goblin Leader | Quara Predator Scout |
| Blemished Spawn | Goblin Scavenger | Quara Raider |
| Blightwalker | Goggle Cake | Rabbit |
| Blood Beast | Golden Servant | Rage Squid |
| Blood Crab | Golden Servant Replica | Raging Fire |
| Blood Hand | Gore Horn | Rat |
| Blood Priest | Gorerilla | Ravenous Lava Lurker |
| Blue Butterfly | Gorger Inferniarch | Red Butterfly |
| Blue Djinn | Gozzler | Renegade Knight |
| Boar | Grave Guard | Renegade Quara Constrictor |
| Boar Man | Grave Robber | Renegade Quara Hydromancer |
| Bog Frog | Gravedigger | Renegade Quara Mantassin |
| Bog Raider | Green Djinn | Renegade Quara Pincher |
| Bonebeast | Green Frog | Renegade Quara Predator |
| Bonelord | Grey Horse | Retching Horror |
| Boogy | Grim Reaper | Rhindeer |
| Brain Squid | Grynch Clan Goblin | Ripper Spectre |
| Braindeath | Gryphon | Roaring Lion |
| Brimstone Bug | Guardian of Tales | Rootthing Amber Shaper |
| Brinebrute Inferniarch | Guzzlemaw | Rootthing Bug Tracker |
| Broken Shaper | Hand Of Cursed Fate | Rootthing Nutshell |
| Broodrider Inferniarch | Harpy | Rorc |
| Brown Horse | Haunted Treeling | Rot Elemental |
| Bug | Headpecker | Rotworm |
| Bulltaur Alchemist | Hellfire Fighter | Rustheap Golem |
| Bulltaur Brute | Hellhound | Sabretooth |
| Bulltaur Forgepriest | Hellhunter Inferniarch | Sacred Spider |
| Burning Book | Hellspawn | Salamander |
| Burning Gladiator | Herald of Gloom | Sandcrawler |
| Burster Spectre | Hero | Sandstone Scorpion |
| Butterfly | Hibernal Moth | Scarab |
| Calamary | Hideous Fungus | Scorpion |
| Candy Floss Elemental | High Voltage Elemental | Sea Serpent |
| Candy Horror | Hive Overseer | Seagull |
| Carniphila | Honey Elemental | Serpent Spawn |
| Carnivostrich | Honour Guard | Shaburak Demon |
| Carrion Worm | Horse | Shaburak Lord |
| Cat | Hot Dog | Shaburak Prince |
| Cave Chimera | Hulking Carnisylvan | Shadow Hound |
| Cave Devourer | Hulking Prehemoth | Shadow Pupil |
| Cave Parrot | Humongous Fungus | Shaper Matriarch |
| Cave Rat | Hunter | Shark |
| Centipede | Husky | Sheep |
| Chakoya Toolshaper | Hyaena | Shock Head |
| Chakoya Tribewarden | Hydra | Shrieking Cry-Stal |
| Chakoya Windcaller | Ice Golem | Sibang |
| Chasm Spawn | Ice Witch | Sight Of Surrender |
| Chicken | Icecold Book | Silencer |
| Chocolate Blob | Iks Ahpututu | Silver Rabbit |
| Choking Fear | Iks Aucar | Sineater Inferniarch |
| Clay Guardian | Iks Chuka | Skeleton |
| Cliff Strider | Iks Churrascan | Skeleton Elite Warrior |
| Cobra | Iks Pututu | Skeleton Warrior |
| Cobra Assassin | Iks Yapunac | Skunk |
| Cobra Scout | Infected Weeper | Slime |
| Cobra Vizier | Infernal Frog | Slug |
| Coral Frog | Infernalist | Smuggler |
| Corym Charlatan | Ink Blob | Snake |
| Corym Skirmisher | Insane Siren | Son of Verminor |
| Corym Vanguard | Insect Swarm | Soul-Broken Harbinger |
| Crab | Insectoid Scout | Souleater |
| Crape Man | Insectoid Worker | Sparkion |
| Crawler | Iron Servant | Spectre |
| Crazed Beggar | Iron Servant Replica | Spellreaper Inferniarch |
| Crazed Summer Rearguard | Ironblight | Sphinx |
| Crazed Summer Vanguard | Island Troll | Spider |
| Crazed Winter Rearguard | Jellyfish | Spidris |
| Crazed Winter Vanguard | Juggernaut | Spidris Elite |
| Cream Blob | Jungle Moa | Spiky Carnivor |
| Crimson Frog | Juvenile Bashmu | Spit Nettle |
| Crocodile | Killer Caiman | Spitter |
| Crustacea Gigantica | Killer Rabbit | Squid Warden |
| Crypt Defiler | Knowledge Elemental | Squidgy Slime |
| Crypt Shambler | Kollos | Squirrel |
| Crypt Warden | Kongra | Stabilizing Dread Intruder |
| Crypt Warrior | Lacewing Moth | Stabilizing Reality Reaver |
| Crystal Spider | Ladybug | Stalker |
| Crystal Wolf | Lamassu | Stalking Stalk |
| Crystalcrusher | Lancer Beetle | Stampor |
| Cunning Werepanther | Larva | Starving Wolf |
| Cursed Ape | Lava Golem | Stone Devourer |
| Cursed Book | Lava Lurker | Stone Golem |
| Cursed Prospector | Lavafungus | Stone Rhino |
| Cyclops | Lavaworm | Stonerefiner |
| Cyclops Drone | Leaf Golem | Streaked Devourer |
| Cyclops Smith | Lich | Sugar Cube |
| Damaged Crystal Golem | Liodile | Sugar Cube Worker |
| Damaged Worker Golem | Lion | Sulphider |
| Dark Apprentice | Little Corym Charlatan | Sulphur Spouter |
| Dark Carnisylvan | Lizard Chosen | Swamp Troll |
| Dark Faun | Lizard Dragon Priest | Swampling |
| Dark Magician | Lizard High Guard | Swan Maiden |
| Dark Monk | Lizard Legionnaire | Swarmer |
| Dark Torturer | Lizard Magistratus | Tainted Soul |
| Dawnfire Asura | Lizard Noble | Tarantula |
| Death Blob | Lizard Sentinel | Tarnished Spirit |
| Death Priest | Lizard Snakecharmer | Terramite |
| Deathling Scout | Lizard Templar | Terrified Elephant |
| Deathling Spellsinger | Lizard Zaogun | Terror Bird |
| Deepling Brawler | Lost Basher | Terrorsleep |
| Deepling Elite | Lost Berserker | Thanatursus |
| Deepling Guard | Lost Exile | Thornback Tortoise |
| Deepling Master Librarian | Lost Husher | Thornfire Wolf |
| Deepling Scout | Lost Soul | Tiger |
| Deepling Spellsinger | Lost Thrower | Toad |
| Deepling Tyrant | Lumbering Carnivor | Tomb Servant |
| Deepling Warrior | Mad Scientist | Tortoise |
| Deepling Worker | Magma Crawler | Tremendous Tyrant |
| Deepsea Blood Crab | Makara | Troll |
| Deepworm | Mammoth | Troll Champion |
| Deer | Manta Ray | Troll Guard |
| Defiler | Manticore | Troll Legionnaire |
| Demon | Mantosaurus | True Dawnfire Asura |
| Demon Outcast | Marid | True Frost Flower Asura |
| Demon Parrot | Marsh Stalker | True Midnight Asura |
| Demon Skeleton | Massive Earth Elemental | Truffle |
| Destroyer | Massive Energy Elemental | Truffle Cook |
| Diabolic Imp | Massive Fire Elemental | Tunnel Tyrant |
| Diamond Servant | Massive Water Elemental | Twisted Pooka |
| Diamond Servant Replica | Mean Lost Soul | Twisted Shaper |
| Dire Penguin | Medusa | Two-Headed Turtle |
| Diremaw | Mega Dragon | Undead Cavebear |
| Dog | Menacing Carnivor | Undead Dragon |
| Doom Deer | Mercurial Menace | Undead Elite Gladiator |
| Dragolisk | Mercury Blob | Undead Gladiator |
| Dragon | Merlkin | Undead Mine Worker |
| Dragon Hatchling | Metal Gargoyle | Undead Prospector |
| Dragon Lord | Midnight Asura | Undertaker |
| Dragon Lord Hatchling | Midnight Panther | Usurper Archer |
| Dragonling | Midnight Spawn | Usurper Knight |
| Draken Abomination | Minotaur | Usurper Warlock |
| Draken Elite | Minotaur Amazon | Valkyrie |
| Draken Spellweaver | Minotaur Archer | Vampire |
| Draken Warmaster | Minotaur Cult Follower | Vampire Bride |
| Draptor | Minotaur Cult Prophet | Vampire Pig |
| Drillworm | Minotaur Cult Zealot | Vampire Viscount |
| Dromedary | Minotaur Guard | Varnished Diremaw |
| Dryad | Minotaur Hunter | Venerable Girtablilu |
| Duskbringer | Minotaur Mage | Vicious Manbat |
| Dwarf | Mitmah Scout | Vicious Squire |
| Dwarf Geomancer | Mitmah Seer | Vile Grandmaster |
| Dwarf Guard | Modified Gnarlhound | Vulcongra |
| Dwarf Henchman | Mole | Wailing Widow |
| Dwarf Soldier | Monk | Walker |
| Dworc Fleshhunter | Mooh'Tah Warrior | War Golem |
| Dworc Venomsniper | Moohtant | War Wolf |
| Dworc Voodoomaster | Mummy | Wardragon |
| Earth Elemental | Mushroom Sniffer | Warlock |
| Efreet | Mutated Bat | Wasp |
| Elder Bonelord | Mutated Human | Waspoid |
| Elder Mummy | Mutated Rat | Water Buffalo |
| Elder Wyrm | Mutated Tiger | Water Elemental |
| Elephant | Naga Archer | Weakened Frazzlemaw |
| Elf | Naga Warrior | Weeper |
| Elf Arcanist | Necromancer | Werecrocodile |
| Elf Overseer | Nibblemaw | Werefox |
| Elf Scout | Nightfiend | Werehyaena |
| Emerald Damselfly | Nighthunter | Werehyaena Shaman |
| Emerald Tortoise | Nightmare | Werelion |
| Energetic Book | Nightmare Scion | Werelioness |
| Energuardian of Tales | Nightstalker | Werepanther |
| Energy Elemental | Noble Lion | Weretiger |
| Enfeebled Silencer | Nomad | Werewolf |
| Enlightened of the Cult | Nomad Blue | White Deer |
| Enraged Crystal Golem | Nomad Female | White Lion |
| Enslaved Dwarf | Northern Pike | White Shade |
| Eternal Guardian | Novice of the Cult | White Tiger |
| Evil Prospector | Noxious Ripptor | White Weretiger |
| Evil Sheep | Nymph | Wiggler |
| Evil Sheep Lord | Ogre Brute | Wild Horse |
| Execowtioner | Ogre Rowdy | Wild Warrior |
| Exotic Bat | Ogre Ruffian | Wilting Leaf Golem |
| Exotic Cave Spider | Ogre Sage | Winter Wolf |
| Eyeless Devourer | Ogre Savage | Wisp |
| Falcon Knight | Ogre Shaman | Witch |
| Falcon Paladin | Orc | Wolf |
| Faun | Orc Berserker | Worker Golem |
| Feral Sphinx | Orc Leader | Worm Priestess |
| Feral Werecrocodile | Orc Marauder | Wyrm |
| Feverish Citizen | Orc Rider | Wyvern |
| Feversleep | Orc Shaman | Yellow Butterfly |
| Filth Toad | Orc Spearman | Yeti |
| Fire Devil | Orc Warlord | Yielothax |
| Fire Elemental | Orc Warrior | Young Goanna |
| Firestarter | Orchid Frog | Young Sea Serpent |
| Fish | Orclops Doomhauler | Zombie |
| Flamingo | Orclops Ravager |  |
| Flimsy Lost Soul | Orewalker |  |
