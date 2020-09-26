local AceGUI = LibStub("AceGUI-3.0")

local PET_JOURNAL_FLAGS = { LE_PET_JOURNAL_FILTER_COLLECTED, LE_PET_JOURNAL_FILTER_NOT_COLLECTED }

HBP_MAX_ACTION_BUTTONS = 120
HBP_EMPTY_ICON_TEXTURE_ID = 134400
HBP_RANDOM_MOUNT_SPELL_ID = 150544
HBP_PICKUP_RETRY_COUNT = 5
HBP_PICKUP_RETRY_INTERVAL = 0.1
HBP_SIMILAR_ITEMS = {
    [6948]   = { 64488 },           -- Hearthstone
    [64488]  = { 6948 },            -- The Innkeeper's Daughter
    [118922] = { 86569, 75525 },    -- Oralius' Whispering Crystal
    [86569]  = { 118922, 75525 },   -- Crystal of Insanity
    [75525]  = { 118922, 86569 },   -- Alchemist's Flask
}
HBP_SIMILAR_SPELLS = {
    -- mage portals
    [10059]  = { 11417 },   -- Portal: Stormwind
    [11416]  = { 11418 },   -- Portal: Ironforge
    [11419]  = { 11420 },   -- Portal: Darnassus
    [32266]  = { 32267 },   -- Portal: Exodar
    [49360]  = { 49361 },   -- Portal: Theramore
    [33691]  = { 35717 },   -- Portal: Shattrath
    [88345]  = { 88346 },   -- Portal: Tol Barad
    [132620] = { 132626 },  -- Portal: Vale of Eternal Blossoms
    [176246] = { 176244 },  -- Portal: Stormshield
    [11417]  = { 10059 },   -- Portal: Orgrimmar
    [11418]  = { 11416 },   -- Portal: Undercity
    [11420]  = { 11419 },   -- Portal: Thunder Bluff
    [32267]  = { 32266 },   -- Portal: Silvermoon
    [49361]  = { 49360 },   -- Portal: Stonard
    [35717]  = { 33691 },   -- Portal: Shattrath
    [88346]  = { 88345 },   -- Portal: Tol Barad
    [132626] = { 132620 },  -- Portal: Vale of Eternal Blossoms
    [176244] = { 176246 },  -- Portal: Warspear

    -- mage teleports
    [3561]   = { 3567 },    -- Teleport: Stormwind
    [3562]   = { 3563 },    -- Teleport: Ironforge
    [3565]   = { 3566 },    -- Teleport: Darnassus
    [32271]  = { 32272 },   -- Teleport: Exodar
    [49359]  = { 49358 },   -- Teleport: Theramore
    [33690]  = { 35715 },   -- Teleport: Shattrath
    [88342]  = { 88344 },   -- Teleport: Tol Barad
    [132621] = { 132627 },  -- Teleport: Vale of Eternal Blossoms
    [176248] = { 176242 },  -- Teleport: Stormshield
    [3567]   = { 3561 },    -- Teleport: Orgrimmar
    [3563]   = { 3562 },    -- Teleport: Undercity
    [3566]   = { 3565 },    -- Teleport: Thunder Bluff
    [32272]  = { 32271 },   -- Teleport: Silvermoon
    [49358]  = { 49359 },   -- Teleport: Stonard
    [35715]  = { 33690 },   -- Teleport: Shattrath
    [88344]  = { 88342 },   -- Teleport: Tol Barad
    [132627] = { 132621 },  -- Teleport: Vale of Eternal Blossoms
    [176242] = { 176248 },  -- Teleport: Warspear

    -- primary racial trait
    [68992]  = { 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Darkflight
    [20589]  = { 68992, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Escape Artist
    [20594]  = { 68992, 20589, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Stoneform
    [28880]  = { 68992, 20589, 20594, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Gift of the Naaru
    [59542]  = { 68992, 20589, 20594, 28880, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Gift of the Naaru
    [59543]  = { 68992, 20589, 20594, 28880, 59542, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Gift of the Naaru
    [59544]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Gift of the Naaru
    [59545]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Gift of the Naaru
    [59547]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Gift of the Naaru
    [59548]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Gift of the Naaru
    [121093] = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },   -- Gift of the Naaru
    [58984]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Shadowmeld
    [59752]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Every Man for Himself
    [69041]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Rocket Barrage
    [7744]   = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 }, -- Will of the Forsaken
    [20572]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Blood Fury
    [33697]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Blood Fury
    [33702]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Blood Fury
    [20549]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- War Stomp
    [26297]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 25046, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Berserking
    [25046]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 28730, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Arcane Torrent
    [28730]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 50613, 69179, 80483, 129597, 155145, 202719 },  -- Arcane Torrent
    [50613]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 69179, 80483, 129597, 155145, 202719 },  -- Arcane Torrent
    [69179]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 80483, 129597, 155145, 202719 },  -- Arcane Torrent
    [80483]  = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 129597, 155145, 202719 },  -- Arcane Torrent
    [129597] = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 155145, 202719 },   -- Arcane Torrent
    [155145] = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 202719 },   -- Arcane Torrent
    [202719] = { 68992, 20589, 20594, 28880, 59542, 59543, 59544, 59545, 59547, 59548, 121093, 58984, 59752, 69041, 7744, 20572, 33697, 33702, 20549, 26297, 25046, 28730, 50613, 69179, 80483, 129597, 155145 },   -- Arcane Torrent

    -- secondary racial trait
    [87840]  = { 69070, 20577 },    -- Running Wild
    [69070]  = { 87840, 20577 },    -- Rocket Jump
    [20577]  = { 87840, 69070 },    -- Cannibalize
}

HBP_SPECIAL_SPELLS = {
    -- draenor zone ability
    [161691] = {
        level = 90,
        altSpellIds = { 161676, 161332, 162075, 161767, 170097, 170108, 168487, 168499, 164012, 164050, 165803, 164222, 160240, 160241 },
    },
    -- broken isles combat ally ability
    [211390] = {
        level = 100,
    },

    -- hunter pets
    [883]    = { class = "HUNTER" },                    -- Call Pet 1
    [83242]  = { class = "HUNTER", level = 10 },        -- Call Pet 2
    [83243]  = { class = "HUNTER", level = 34 },        -- Call Pet 3
    [83244]  = { class = "HUNTER", level = 62 },        -- Call Pet 4
    [83245]  = { class = "HUNTER", level = 82 },        -- Call Pet 5
    [1462]   = { class = "HUNTER", level = 12 },        -- Beast Lore
    [2641]   = { class = "HUNTER", level = 10 },        -- Dismiss Pet
    [6991]   = { class = "HUNTER", level = 11 },        -- Feed Pet
    [136]    = { class = "HUNTER" },                    -- Mend Pet
    [982]    = { class = "HUNTER" },                    -- Revive Pet
    [1515]   = { class = "HUNTER", level = 10 },        -- Tame Beast

    -- hunter traps
    [187650] = { class = "HUNTER", spec = 255, level = 16 },        -- Freezing Trap
    [187698] = { class = "HUNTER", spec = 255, level = 36 },        -- Tar Trap
    [191433] = { class = "HUNTER", spec = 255, level = 50 },        -- Explosive Trap

    -- warlock daemons
    [688]    = { class = "WARLOCK" },                   -- Summon Imp
    [697]    = { class = "WARLOCK", level = 8 },        -- Summon Voidwalker
    [712]    = { class = "WARLOCK", level = 28 },       -- Summon Succubus
    [691]    = { class = "WARLOCK", level = 35 },       -- Summon Felhunter
    [30146]  = { class = "WARLOCK", level = 40 },       -- Summon Felguard

    -- mage portals
    [53142]  = { class = "MAGE", level = 74 },                          -- Portal: Dalaran - Northrend
    [224871] = { class = "MAGE", level = 74 },                          -- Portal: Dalaran - Broken Isles
    [120146] = { class = "MAGE", level = 74 },                          -- Ancient Portal: Dalaran
    [10059]  = { class = "MAGE", level = 42, faction = "Alliance" },    -- Portal: Stormwind
    [11416]  = { class = "MAGE", level = 42, faction = "Alliance" },    -- Portal: Ironforge
    [11419]  = { class = "MAGE", level = 42, faction = "Alliance" },    -- Portal: Darnassus
    [32266]  = { class = "MAGE", level = 42, faction = "Alliance" },    -- Portal: Exodar
    [49360]  = { class = "MAGE", level = 42, faction = "Alliance" },    -- Portal: Theramore
    [33691]  = { class = "MAGE", level = 66, faction = "Alliance" },    -- Portal: Shattrath
    [88345]  = { class = "MAGE", level = 85, faction = "Alliance" },    -- Portal: Tol Barad
    [132620] = { class = "MAGE", level = 90, faction = "Alliance" },    -- Portal: Vale of Eternal Blossoms
    [176246] = { class = "MAGE", level = 92, faction = "Alliance" },    -- Portal: Stormshield
    [11417]  = { class = "MAGE", level = 42, faction = "Horde" },       -- Portal: Orgrimmar
    [11418]  = { class = "MAGE", level = 42, faction = "Horde" },       -- Portal: Undercity
    [11420]  = { class = "MAGE", level = 42, faction = "Horde" },       -- Portal: Thunder Bluff
    [32267]  = { class = "MAGE", level = 42, faction = "Horde" },       -- Portal: Silvermoon
    [49361]  = { class = "MAGE", level = 52, faction = "Horde" },       -- Portal: Stonard
    [35717]  = { class = "MAGE", level = 66, faction = "Horde" },       -- Portal: Shattrath
    [88346]  = { class = "MAGE", level = 85, faction = "Horde" },       -- Portal: Tol Barad
    [132626] = { class = "MAGE", level = 90, faction = "Horde" },       -- Portal: Vale of Eternal Blossoms
    [176244] = { class = "MAGE", level = 92, faction = "Horde" },       -- Portal: Warspear

    -- mage teleports
    [193759] = { class = "MAGE", level = 14 },                          -- Teleport: Hall of the Guardian
    [53140]  = { class = "MAGE", level = 71 },                          -- Teleport: Dalaran - Northrend
    [224869] = { class = "MAGE", level = 71 },                          -- Teleport: Dalaran - Broken Isles
    [120145] = { class = "MAGE", level = 71 },                          -- Ancient Teleport: Dalaran
    [3561]   = { class = "MAGE", level = 17, faction = "Alliance" },    -- Teleport: Stormwind
    [3562]   = { class = "MAGE", level = 17, faction = "Alliance" },    -- Teleport: Ironforge
    [3565]   = { class = "MAGE", level = 17, faction = "Alliance" },    -- Teleport: Darnassus
    [32271]  = { class = "MAGE", level = 17, faction = "Alliance" },    -- Teleport: Exodar
    [49359]  = { class = "MAGE", level = 17, faction = "Alliance" },    -- Teleport: Theramore
    [33690]  = { class = "MAGE", level = 62, faction = "Alliance" },    -- Teleport: Shattrath
    [88342]  = { class = "MAGE", level = 85, faction = "Alliance" },    -- Teleport: Tol Barad
    [132621] = { class = "MAGE", level = 90, faction = "Alliance" },    -- Teleport: Vale of Eternal Blossoms
    [176248] = { class = "MAGE", level = 92, faction = "Alliance" },    -- Teleport: Stormshield
    [3567]   = { class = "MAGE", level = 17, faction = "Horde" },       -- Teleport: Orgrimmar
    [3563]   = { class = "MAGE", level = 17, faction = "Horde" },       -- Teleport: Undercity
    [3566]   = { class = "MAGE", level = 17, faction = "Horde" },       -- Teleport: Thunder Bluff
    [32272]  = { class = "MAGE", level = 17, faction = "Horde" },       -- Teleport: Silvermoon
    [49358]  = { class = "MAGE", level = 52, faction = "Horde" },       -- Teleport: Stonard
    [35715]  = { class = "MAGE", level = 62, faction = "Horde" },       -- Teleport: Shattrath
    [88344]  = { class = "MAGE", level = 85, faction = "Horde" },       -- Teleport: Tol Barad
    [132627] = { class = "MAGE", level = 90, faction = "Horde" },       -- Teleport: Vale of Eternal Blossoms
    [176242] = { class = "MAGE", level = 92, faction = "Horde" },       -- Teleport: Warspear

    -- rogue poisons
    [2823]   = { class = "ROGUE", spec = 259, level = 2 },              -- Deadly Poison
    [3408]   = { class = "ROGUE", spec = 259, level = 19 },             -- Crippling Poison
    [8679]   = { class = "ROGUE", spec = 259, level = 25 },             -- Wound Poison
    [108211] = { class = "ROGUE", spec = 259, level = 60 },             -- Leeching Poison
    [200802] = { class = "ROGUE", spec = 259, level = 90 },             -- Agonizing Poison

    -- paladin blessings
    [203528] = { class = "PALADIN", spec = 70, level = 42 },            -- Greater Blessing of Might
    [203538] = { class = "PALADIN", spec = 70, level = 44 },            -- Greater Blessing of Kings
    [203539] = { class = "PALADIN", spec = 70, level = 46 },            -- Greater Blessing of Wisdom
}

local DEBUG = "|cffff0000Debug:|r "

local S2KFI = LibStub("LibS2kFactionalItems-1.0")

HotbarProfiles = LibStub("AceAddon-3.0"):NewAddon("HotbarProfiles", "AceConsole-3.0")
local HotbarProfiles = HotbarProfiles

local function log(msg)
    HotbarProfiles:Print(msg)
end

HotbarPopup = AceGUI:Create("Frame")

local function toggleHBP()
    HotbarProfiles.db.profile.drop.hide = not HotbarProfiles.db.profile.drop.hide
    log(HotbarProfiles.db.profile.drop.hide)
    if HotbarProfiles.db.profile.drop.hide then
        HotbarPopup:Hide()
    else
        HotbarPopup:Show()
    end
end

function HotbarProfiles:encodeLink(data)
    return data:gsub(".", function(x)
        return ((x:byte() < 32 or x:byte() == 127 or x == "|" or x == ":" or x == "[" or x == "]" or x == "~") and string.format("~%02x", x:byte())) or x
    end)
end

function HotbarProfiles:saveActions(profile)
    local flyouts, tsNames, tsIds = {}, {}, {}

    local book
    for book = 1, GetNumSpellTabs() do
        local offset, count, _, spec = select(3, GetSpellTabInfo(book))

        if spec == 0 then
            local index
            for index = offset + 1, offset + count do
                local type, id = GetSpellBookItemInfo(index, BOOKTYPE_SPELL)
                local name = GetSpellBookItemName(index, BOOKTYPE_SPELL)

                if type == "FLYOUT" then
                    flyouts[id] = name

                elseif type == "SPELL" and IsTalentSpell(index, BOOKTYPE_SPELL) then
                    tsNames[name] = id
                end
            end
        end
    end

    local talents = {}

    local tier
    for tier = 1, MAX_TALENT_TIERS do
        local column = select(2, GetTalentTierInfo(tier, 1))
        if column and column > 0 then
            local id, name = GetTalentInfo(tier, column, 1)

            if tsNames[name] then
                tsIds[tsNames[name]] = id
            end

            talents[tier] = GetTalentLink(id)
        end
    end

    profile.talents = talents

    local actions = {}
    local savedMacros = {}

    local slot
    for slot = 1, HBP_MAX_ACTION_BUTTONS do
        local type, id, sub = GetActionInfo(slot)
        if type == "spell" then
            if tsIds[id] then
                actions[slot] = GetTalentLink(tsIds[id])
            else
                actions[slot] = GetSpellLink(id)
            end
        elseif type == "flyout" then
            if flyouts[id] then
                actions[slot] = string.format(
                        "|cffff0000|Habp:flyout:%d|h[%s]|h|r",
                        id, flyouts[id]
                )
            end

        elseif type == "item" then
            actions[slot] = select(2, GetItemInfo(id))

        elseif type == "companion" then
            if sub == "MOUNT" then
                actions[slot] = GetSpellLink(id)
            end

        elseif type == "summonpet" then
            actions[slot] = C_PetJournal.GetBattlePetLink(id)

        elseif type == "summonmount" then
            if id == 0xFFFFFFF then
                actions[slot] = GetSpellLink(HBP_RANDOM_MOUNT_SPELL_ID)
            else
                actions[slot] = GetSpellLink(({ C_MountJournal.GetMountInfoByID(id) })[2])
            end

        elseif type == "macro" then
            if id > 0 then
                local name, icon, body = GetMacroInfo(id)

                icon = icon or HBP_EMPTY_ICON_TEXTURE_ID

                if id > MAX_ACCOUNT_MACROS then
                    actions[slot] = string.format(
                            "|cffff0000|Habp:macro:%s:%s|h[%s]|h|r",
                            icon, self:encodeLink(body), name
                    )
                else
                    actions[slot] = string.format(
                            "|cffff0000|Habp:macro:%s:%s:1|h[%s]|h|r",
                            icon, self:encodeLink(body), name
                    )
                end

                savedMacros[id] = true
            end

        elseif type == "equipmentset" then
            actions[slot] = string.format(
                    "|cffff0000|Habp:equip|h[%s]|h|r",
                    id
            )
        end
    end

    profile.actions = actions

    local macros = {}
    local allMacros, charMacros = GetNumMacros()

    local index
    for index = 1, allMacros do
        local name, icon, body = GetMacroInfo(index)

        icon = icon or HBP_EMPTY_ICON_TEXTURE_ID

        if body and not savedMacros[index] then
            table.insert(macros, string.format(
                    "|cffff0000|Habp:macro:%s:%s:1|h[%s]|h|r",
                    icon, self:encodeLink(body), name
            ))
        end
    end

    for index = MAX_ACCOUNT_MACROS + 1, MAX_ACCOUNT_MACROS + charMacros do
        local name, icon, body = GetMacroInfo(index)

        icon = icon or HBP_EMPTY_ICON_TEXTURE_ID

        if body and not savedMacros[index] then
            table.insert(macros, string.format(
                    "|cffff0000|Habp:macro:%s:%s|h[%s]|h|r",
                    icon, self:encodeLink(body), name
            ))
        end
    end

    profile.macros = macros
end

function HotbarProfiles:saveBars(name)
    local list = self.db.profile.list
    local profile = { name = name, default = false }

    self:saveActions(profile)

    list[name] = profile

    HotbarPopup:updateProfileList()

    HotbarPopup:SetStatusText("Profile '" .. name .. "' saved");
end

function HotbarProfiles:deleteProfile(profile)
    local list = self.db.profile.list

    list[profile.name] = nil

    HotbarPopup:SetStatusText("Profile '" .. profile.name .. "' deleted");
end

function HotbarProfiles:cPrintf(cond, ...)
    if cond then self:Printf(...) end
end

function HotbarPopup:getDropDownProfileList(list)
    local name, profile

    local optimizedList = {}

    for name, profile in pairs(list) do
        optimizedList[name] = name
    end

    return optimizedList
end

function HotbarPopup:selectDefaultProfile()
    local defaultProfile = nil
    local name, profile
    for name, profile in pairs(HotbarProfiles.db.profile.list) do
        if profile.default then
            defaultProfile = name
        end
    end

    self.profilesDropdown:SetValue(defaultProfile)
end

function HotbarPopup:updateProfileList()
    local list = self:getDropDownProfileList(HotbarProfiles.db.profile.list)
    self.profilesDropdown:SetList(list)

    self:selectDefaultProfile()
end

function HotbarPopup:deleteProfile()
    HotbarProfiles:deleteProfile(self.selectedProfile)

    self:updateProfileList()
end

function HotbarPopup:useProfile()
    if not self.selectedProfile then
        return
    end

    HotbarProfiles:UseProfile(self.selectedProfile)


    HotbarPopup:SetStatusText("Profile '" .. self.selectedProfile.name .. "' set");
end

function HotbarPopup:updateSavedContainer()
    --self.savedProfilesContainer:Release()

    self.profilesDropdown = AceGUI:Create("Dropdown")
    local list = self:getDropDownProfileList(HotbarProfiles.db.profile.list)
    self.profilesDropdown:SetList(list)
    self.profilesDropdown:SetCallback("OnValueChanged", function(this, event, key)
        self.selectedProfile = HotbarProfiles.db.profile.list[key]
    end)
    self.savedProfilesContainer:AddChild(self.profilesDropdown)

    local profileDeleteBtn = AceGUI:Create("Button")
    profileDeleteBtn:SetText("Delete profile")
    profileDeleteBtn:SetCallback("OnClick", function ()
        HotbarPopup:deleteProfile()
    end)
    self.savedProfilesContainer:AddChild(profileDeleteBtn)

    local profileUseBtn = AceGUI:Create("Button")
    profileUseBtn:SetText("Use profile")
    --profileUseBtn:SetDisabled(true) -- temporary to not click it :)
    profileUseBtn:SetCallback("OnClick", function ()
        HotbarPopup:useProfile()
    end)
    self.savedProfilesContainer:AddChild(profileUseBtn)

    local name, profile
    for name, profile in pairs(HotbarProfiles.db.profile.list) do
        if profile.default then
            self.profilesDropdown:SetValue(name)
        end
    end
end

function HotbarPopup:drawHotbarPopup()
    self.selectedProfile = nil
    local scrollContainer = AceGUI:Create("SimpleGroup")
    scrollContainer:SetFullWidth(true)
    scrollContainer:SetLayout("List") -- important!
    self:AddChild(scrollContainer)

    --top section frame

    local mainFrame = AceGUI:Create("InlineGroup")
    mainFrame:SetLayout("Flow")

    local saveActionBars = AceGUI:Create("Label")
    saveActionBars:SetText("Enter name to save your current setup")
    mainFrame:AddChild(saveActionBars)

    local saveABName = AceGUI:Create("EditBox")
    saveABName:SetLabel("Name:")
    saveABName:SetCallback("OnEnterPressed", function (widget, event, text)
        HotbarProfiles:saveBars(text)
    end)
    mainFrame:AddChild(saveABName)

    -- bottom part

    self.savedProfilesContainer = AceGUI:Create("InlineGroup")
    self.savedProfilesContainer:SetLayout("Flow")

    self:updateSavedContainer()

    scrollContainer:AddChild(mainFrame)
    scrollContainer:AddChild(self.savedProfilesContainer)
end

function HotbarPopup:createHotbarPopup()
    self:SetTitle("HotbarProfiles")

    self:SetCallback("OnClose", function(widget)
        HotbarProfiles.db.profile.drop.hide = true
        self:Hide()
    end)

    self:SetLayout("Fill")

    self:drawHotbarPopup()
end

function HotbarProfiles:RestorePetJournalFilters(saved)
    C_PetJournal.SetSearchFilter(saved.text)

    local i
    for i in table.s2k_values(PET_JOURNAL_FLAGS) do
        C_PetJournal.SetFilterChecked(i, saved.flag[i])
    end

    for i = 1, C_PetJournal.GetNumPetSources() do
        C_PetJournal.SetPetSourceChecked(i, saved.source[i])
    end

    for i = 1, C_PetJournal.GetNumPetTypes() do
        C_PetJournal.SetPetTypeFilter(i, saved.type[i])
    end
end

function HotbarProfiles:SavePetJournalFilters()
    local saved = { flag = {}, source = {}, type = {} }

    saved.text = C_PetJournal.GetSearchFilter()

    local i
    for i in table.s2k_values(PET_JOURNAL_FLAGS) do
        saved.flag[i] = C_PetJournal.IsFilterChecked(i)
    end

    for i = 1, C_PetJournal.GetNumPetSources() do
        saved.source[i] = C_PetJournal.IsPetSourceChecked(i)
    end

    for i = 1, C_PetJournal.GetNumPetTypes() do
        saved.type[i] = C_PetJournal.IsPetTypeChecked(i)
    end

    return saved
end

log("HotbarProfiles use /hbp to enable the addon")

local hpLDB = LibStub("LibDataBroker-1.1"):NewDataObject("HotbarProfiles", {
    type = "data source",
    text = "HotbarProfiles",
    icon = "Interface\\Icons\\INV_Chest_Cloth_17",
    OnClick = function()
        log("HotbarProfiles addon by Mike")
        toggleHBP()
    end,
})

log("Created data object")

local icon = LibStub("LibDBIcon-1.0")

log("Created data icon")

function HotbarProfiles:OnInitialize()
    log("Calling addon init")
    -- Obviously you'll need a ## SavedVariables: HotbarProfilesDB line in your TOC, duh!
    self.db = LibStub("AceDB-3.0"):New("HotbarProfilesDB", {
        profile = {
            minimap = {
                hide = false,
            },
            drop = {
                hide = true,
            },
            list = {},
        },
    })
    icon:Register("HotbarProfiles", hpLDB, self.db.profile.minimap)
    self:RegisterChatCommand("hbp", "HotbarProfilesControll")
    log("Calling addon init done")

    HotbarPopup:createHotbarPopup()

    HotbarPopup:Hide()
end

icon:Show("HotbarProfiles")

function HotbarProfiles:HotbarProfilesControll()
    log("Calling addon /hbp callback")
    toggleHBP()
end

--[[

Copy from ActionBarProfiles

https://github.com/Silencer2K/wow-action-bar-profiles/

--]]

function HotbarProfiles:GetProfiles(filter, case)
    local list = self.db.profile.list
    local sorted = {}

    local name, profile

    for name, profile in pairs(list) do
        if not filter or name == filter or (case and name:lower() == filter:lower()) then
            profile.name = name
            table.insert(sorted, profile)
        end
    end

    if #sorted > 1 then
        local class = select(2, UnitClass("player"))

        table.sort(sorted, function(a, b)
            if a.class == b.class then
                return a.name < b.name
            else
                return a.class == class
            end
        end)
    end

    return unpack(sorted)
end

function HotbarProfiles:UseProfile(profile, check, cache)
    log("1")
    if type(profile) ~= "table" then
        local list = self.db.profile.list
        profile = list[profile]

        if not profile then
            return 0, 0
        end
    end

    log("2")

    cache = cache or self:MakeCache()

    local macros = cache.macros
    local talents = cache.talents

    local res = { fail = 0, total = 0 }

    log("3")

    if not profile.skipMacros then
        self:RestoreMacros(profile, check, cache, res)
    end

    log("4")

    --if not profile.skipTalents then
        --self:RestoreTalents(profile, check, cache, res)
    --end

    log("5")

    if not profile.skipActions then
        self:RestoreActions(profile, check, cache, res)
    end

    log("6")

    if not profile.skipPetActions then
        self:RestorePetActions(profile, check, cache, res)
    end

    log("7")

    --if not profile.skipBindings then
        --self:RestoreBindings(profile, check, cache, res)
    --end

    log("8")

    cache.macros = macros
    cache.talents = talents

    return res.fail, res.total
end

function HotbarProfiles:DecodeLink(data)
    return data:gsub("~[0-9A-Fa-f][0-9A-Fa-f]", function(x)
        return string.char(tonumber(x:sub(2), 16))
    end)
end

function HotbarProfiles:RestoreMacros(profile, check, cache, res)
    local fail, total = 0, 0

    local all, char = GetNumMacros()
    local macros

    if self.db.profile.replace_macros then
        macros = { id = {}, name = {} }

        if not check then
            local index
            for index = 1, all do
                DeleteMacro(1)
            end

            for index = 1, char do
                DeleteMacro(MAX_ACCOUNT_MACROS + 1)
            end
        end

        all, char = 0, 0
    else
        macros = table.s2k_copy(cache.macros)
    end

    local slot
    for slot = 1, HBP_MAX_ACTION_BUTTONS do
        local link = profile.actions[slot]
        if link then
            -- has action
            local data, name = link:match("^|c.-|H(.-)|h%[(.-)%]|h|r$")
            link = link:gsub("|Habp:.+|h(%[.+%])|h", "%1")

            if data then
                local type, sub, icon, body, global = strsplit(":", data)

                if type == "abp" and sub == "macro" then
                    local ok
                    total = total + 1

                    body = self:DecodeLink(body)

                    if self:GetFromCache(macros, self:PackMacro(body)) then
                        ok = true

                    elseif (global and all < MAX_ACCOUNT_MACROS) or (not global and char < MAX_CHARACTER_MACROS) then
                        if check or CreateMacro(name, icon, body, not global) then
                            ok = true
                            self:UpdateCache(macros, -1, self:PackMacro(body), name)
                        end

                        if ok then
                            all = all + ((global and 1) or 0)
                            char = char + ((global and 0) or 1)
                        end
                    end

                    if not ok then
                        fail = fail + 1
                        self:cPrintf(not check, "L.msg_cant_create_macro", link)
                    end
                end
            else
                self:cPrintf(profile.skipActions and not check, "L.msg_bad_link", link)
            end
        end
    end

    if self.db.profile.replace_macros and profile.macros then
        for slot = 1, #profile.macros do
            local link = profile.macros[slot]

            local data, name = link:match("^|c.-|H(.-)|h%[(.-)%]|h|r$")
            link = link:gsub("|Habp:.+|h(%[.+%])|h", "%1")

            if data then
                local type, sub, icon, body, global = strsplit(":", data)

                if type == "abp" and sub == "macro" then
                    local ok
                    total = total + 1

                    body = self:DecodeLink(body)

                    if self:GetFromCache(macros, self:PackMacro(body)) then
                        ok = true

                    elseif (global and all < MAX_ACCOUNT_MACROS) or (not global and char < MAX_CHARACTER_MACROS) then
                        if check or CreateMacro(name, icon, body, not global) then
                            ok = true
                            self:UpdateCache(macros, -1, self:PackMacro(body), name)
                        end

                        if ok then
                            all = all + ((global and 1) or 0)
                            char = char + ((global and 0) or 1)
                        end
                    end

                    if not ok then
                        fail = fail + 1
                        self:cPrintf(not check, "L.msg_cant_create_macro", link)
                    end
                else
                    self:cPrintf(not check, "L.msg_bad_link", link)
                end
            else
                self:cPrintf(not check, "L.msg_bad_link", link)
            end
        end
    end

    if not check then
        -- correct macro ids
        self:PreloadMacros(macros)
    end

    cache.macros = macros

    if res then
        res.fail = res.fail + fail
        res.total = res.total + total
    end

    return fail, total
end

function HotbarProfiles:RestoreTalents(profile, check, cache, res)
    local fail, total = 0, 0

    -- hack: update cache
    local talents = { id = {}, name = {} }
    local rest = self.auraState or IsResting()

    local tier
    for tier = 1, MAX_TALENT_TIERS do
        local link = profile.talents[tier]
        if link then
            -- has action
            local ok
            total = total + 1

            local data, name = link:match("^|c.-|H(.-)|h%[(.-)%]|h|r$")
            link = link:gsub("|Habp:.+|h(%[.+%])|h", "%1")

            if data then
                local type, sub = strsplit(":", data)
                local id = tonumber(sub)

                if type == "talent" then
                    local found = self:GetFromCache(cache.allTalents[tier], id, name, not check and link)
                    if found then
                        if self:GetFromCache(cache.talents, id) or rest or select(2, GetTalentTierInfo(tier, 1)) == 0 then
                            ok = true

                            -- hack: update cache
                            self:UpdateCache(talents, found, id, select(2, GetTalentInfoByID(id)))

                            if not check then
                                LearnTalent(found)
                            end
                        else
                            self:cPrintf(not check, "L.msg_cant_learn_talent", link)
                        end
                    else
                        self:cPrintf(not check, "L.msg_talent_not_exists", link)
                    end
                else
                    self:cPrintf(not check, "L.msg_bad_link", link)
                end
            else
                self:cPrintf(not check, "L.msg_bad_link", link)
            end

            if not ok then
                fail = fail + 1
            end
        end
    end

    -- hack: update cache
    cache.talents = talents

    if res then
        res.fail = res.fail + fail
        res.total = res.total + total
    end

    return fail, total
end

function HotbarProfiles:RestoreActions(profile, check, cache, res)
    local fail, total = 0, 0

    local slot
    for slot = 1, HBP_MAX_ACTION_BUTTONS do
        local link = profile.actions[slot]
        if link then
            -- has action
            local ok
            total = total + 1

            local data, name = link:match("^|c.-|H(.-)|h%[(.-)%]|h|r$")
            link = link:gsub("|Habp:.+|h(%[.+%])|h", "%1")

            if data then
                local type, sub, p1, p2, _, _, _, p6 = strsplit(":", data)
                local id = tonumber(sub)

                if type == "spell" then
                    if id == HBP_RANDOM_MOUNT_SPELL_ID then
                        ok = true

                        if not check then
                            self:PlaceMount(slot, 0, link)
                        end
                    else
                        local found = self:FindSpellInCache(cache.spells, id, name, not check and link)
                        if found then
                            ok = true

                            if not check then
                                self:PlaceSpell(slot, found, link)
                            end
                        end
                    end

                    self:cPrintf(not ok and not check, "L.msg_spell_not_exists", link)

                elseif type == "talent" then
                    local found = self:GetFromCache(cache.talents, id, name, not check and link)
                    if found then
                        ok = true

                        if not check then
                            self:PlaceTalent(slot, found, link)
                        end
                    end

                    self:cPrintf(not ok and not check, "L.msg_spell_not_exists", link)

                elseif type == "item" then
                    if PlayerHasToy(id) then
                        ok = true

                        if not check then
                            self:PlaceItem(slot, id, link)
                        end
                    else
                        local found = self:FindItemInCache(cache.equip, id, name, not check and link)
                        if found then
                            ok = true

                            if not check then
                                self:PlaceInventoryItem(slot, found, link)
                            end
                        else
                            found = self:FindItemInCache(cache.bags, id, name, not check and link)
                            if found then
                                ok = true

                                if not check then
                                    self:PlaceContainerItem(slot, found[1], found[2], link)
                                end
                            end
                        end
                    end

                    if not ok and not check then
                        self:PlaceItem(slot, S2KFI:GetConvertedItemId(id) or id, link)
                    end

                    ok = true   -- sic!

                elseif type == "battlepet" then
                    local found = self:GetFromCache(cache.pets, p6, id, not check and link)
                    if found then
                        ok = true

                        if not check then
                            self:PlacePet(slot, found, link)
                        end
                    end

                    self:cPrintf(not ok and not check, "L.msg_pet_not_exists", link)

                elseif type == "abp" then
                    id = tonumber(p1)

                    if sub == "flyout" then
                        local found = self:FindFlyoutInCache(cache.flyouts, id, name, not check and link)
                        if found then
                            ok = true

                            if not check then
                                self:PlaceFlyout(slot, found, BOOKTYPE_SPELL, link)
                            end
                        end

                        self:cPrintf(not ok and not check, "L.msg_spell_not_exists", link)

                    elseif sub == "macro" then
                        local found = self:GetFromCache(cache.macros, self:PackMacro(self:DecodeLink(p2)), name, not check and link)
                        if found then
                            ok = true

                            if not check then
                                self:PlaceMacro(slot, found, link)
                            end
                        end

                        if profile.skipMacros then
                            self:cPrintf(not ok and not check, "L.msg_macro_not_exists", link)
                        else
                            total = total - 1
                            if not ok then
                                fail = fail - 1
                            end
                        end

                    elseif sub == "equip" then
                        if GetEquipmentSetInfoByName(name) then
                            ok = true

                            if not check then
                                self:PlaceEquipment(slot, name, link)
                            end
                        end

                        self:cPrintf(not ok and not check, "L.msg_equip_not_exists", link)
                    else
                        self:cPrintf(not check, "L.msg_bad_link", link)
                    end
                else
                    self:cPrintf(not check, "L.msg_bad_link", link)
                end
            else
                self:cPrintf(not check, "L.msg_bad_link", link)
            end

            if not ok then
                fail = fail + 1

                if not profile.skipEmptySlots and not check then
                    self:ClearSlot(slot)
                end
            end
        else
            if not profile.skipEmptySlots and not check then
                self:ClearSlot(slot)
            end
        end
    end

    if res then
        res.fail = res.fail + fail
        res.total = res.total + total
    end

    return fail, total
end

function HotbarProfiles:RestorePetActions(profile, check, cache, res)
    if not HasPetSpells() or not profile.petActions then
        return 0, 0
    end

    local fail, total = 0, 0

    local slot
    for slot = 1, NUM_PET_ACTION_SLOTS do
        local link = profile.petActions[slot]
        if link then
            -- has action
            local ok
            total = total + 1

            local data, name = link:match("^|c.-|H(.-)|h%[(.-)%]|h|r$")
            link = link:gsub("|Habp:.+|h(%[.+%])|h", "%1")

            if data then
                local type, sub, p1 = strsplit(":", data)
                local id = tonumber(sub)

                if type == "spell" or (type == "abp" and sub == "pet") then
                    if type == "spell" then
                        name = GetSpellInfo(id) or name
                    else
                        id = -2
                        name = _G[name] or name
                    end

                    local found = self:GetFromCache(cache.petSpells, id, name, type == "spell" and link)
                    if found then
                        ok = true

                        if not check then
                            self:PlacePetSpell(slot, found, link)
                        end
                    end
                else
                    self:cPrintf(not check, "L.msg_bad_link", link)
                end
            else
                self:cPrintf(not check, "L.msg_bad_link", link)
            end

            if not ok then
                fail = fail + 1

                if not check then
                    self:ClearPetSlot(slot)
                end
            end
        else
            -- empty slot
            if not check then
                self:ClearPetSlot(slot)
            end
        end
    end

    if res then
        res.fail = res.fail + fail
        res.total = res.total + total
    end

    return fail, total
end

function HotbarProfiles:RestoreBindings(profile, check, cache, res)
    if check then
        return 0, 0
    end

    -- clear
    local index
    for index = 1, GetNumBindings() do
        local bind = { GetBinding(index) }
        if bind[3] then
            local idx, key
            for idx, key in pairs({ select(3, unpack(bind)) }) do
                SetBinding(key)
            end
        end
    end

    -- restore
    local cmd, keys
    for cmd, keys in pairs(profile.bindings) do
        local idx, key
        for idx, key in pairs(keys) do
            SetBinding(key, cmd)
        end
    end

    if LibStub("AceAddon-3.0"):GetAddon("Dominos", true) and profile.bindingsDominos then
        for index = 13, 60 do
            local idx, key

            -- clear
            for idx, key in pairs({ GetBindingKey(string.format("CLICK DominosActionButton%d:LeftButton", index)) }) do
                SetBinding(key)
            end

            -- restore
            if profile.bindingsDominos[index] then
                for idx, key in pairs(profile.bindingsDominos[index]) do
                    SetBindingClick(key, string.format("DominosActionButton%d", index), "LeftButton")
                end
            end
        end
    end

    SaveBindings(GetCurrentBindingSet())

    return 0, 0
end

function HotbarProfiles:UpdateCache(cache, value, id, name)
    cache.id[id] = value

    if cache.name and name then
        cache.name[name] = value
    end
end

function HotbarProfiles:GetFromCache(cache, id, name, link)
    if cache.id[id] then
        return cache.id[id]
    end

    if cache.name and name and cache.name[name] then
        self:cPrintf(link, DEBUG .. "L.msg_found_by_name", link)
        return cache.name[name]
    end
end

function HotbarProfiles:FindSpellInCache(cache, id, name, link)
    name = GetSpellInfo(id) or name

    local found = self:GetFromCache(cache, id, name, link)
    if found then
        return found
    end

    local similar = HBP_SIMILAR_SPELLS[id]
    if similar then
        local idx, alt
        for idx, alt in pairs(similar) do
            local found = self:GetFromCache(cache, alt)
            if found then
                return found
            end
        end
    end
end

function HotbarProfiles:FindFlyoutInCache(cache, id, name, link)
    local ok, info_name = pcall(GetFlyoutInfo, id)
    if ok then
        name = info_name
    end

    local found = self:GetFromCache(cache, id, name, link)
    if found then
        return found
    end
end

function HotbarProfiles:FindItemInCache(cache, id, name, link)
    local found = self:GetFromCache(cache, id, name, link)
    if found then
        return found
    end

    local alt = S2KFI:GetConvertedItemId(id)
    if alt then
        found = self:GetFromCache(cache, alt)
        if found then
            return found
        end
    end

    local similar = HBP_SIMILAR_ITEMS[id]
    if similar then
        local idx
        for idx, alt in pairs(similar) do
            found = self:GetFromCache(cache, alt)
            if found then
                return found
            end
        end
    end
end

function HotbarProfiles:MakeCache()
    local cache = {
        talents = { id = {}, name = {} },
        allTalents = {},

        spells = { id = {}, name = {} },
        flyouts = { id = {}, name = {} },

        equip = { id = {}, name = {} },
        bags = { id = {}, name = {} },

        pets = { id = {}, name = {} },

        macros = { id = {}, name = {} },

        petSpells = { id = {}, name = {} },
    }

    log("a1")
    self:PreloadTalents(cache.talents, cache.allTalents)
    log("a2")
    self:PreloadSpecialSpells(cache.spells)
    log("a3")
    self:PreloadSpellbook(cache.spells, cache.flyouts)
    log("a4")
    self:PreloadMountjournal(cache.spells)
    log("a5")
    self:PreloadCombatAllySpells(cache.spells)
    log("a6")
    self:PreloadEquip(cache.equip)
    log("a7")
    self:PreloadBags(cache.bags)
    log("a8")
    self:PreloadPetJournal(cache.pets)
    log("a9")
    self:PreloadMacros(cache.macros)
    log("a10")
    self:PreloadPetSpells(cache.petSpells)
    log("a11")
    return cache
end

function HotbarProfiles:PreloadSpecialSpells(spells)
    log("b1")
    local level = UnitLevel("player")
    local class = select(2, UnitClass("player"))
    local faction = UnitFactionGroup("player")
    local spec = GetSpecializationInfo(GetSpecialization())

    log("b2")
    local id, info
    for id, info in pairs(HBP_SPECIAL_SPELLS) do
        if (not info.level or level >= info.level) and
                (not info.class or class == info.class) and
                (not info.faction or faction == info.faction) and
                (not info.spec or spec == info.spec)
        then
            log("b4")
            self:UpdateCache(spells, id, id)
            log("b5")
            if info.altSpellIds then
                log("b6")
                local idx, alt
                for idx, alt in pairs(info.altSpellIds) do
                    log("b61")
                    self:UpdateCache(spells, id, alt)
                    log("b62")
                end
                log("b7")
            end
        end
    end
end

function HotbarProfiles:PreloadSpellbook(spells, flyouts)
    local tabs = {}

    local book
    for book = 1, GetNumSpellTabs() do
        local offset, count, _, spec = select(3, GetSpellTabInfo(book))

        if spec == 0 then
            table.insert(tabs, { type = BOOKTYPE_SPELL, offset = offset, count = count })
        end
    end

    local idx, prof
    for prof in pairs({ GetProfessions() }) do
        if prof then
            local count, offset = select(5, GetProfessionInfo(prof))

            table.insert(tabs, { type = BOOKTYPE_PROFESSION, offset = offset, count = count })
        end
    end

    local tab
    for idx, tab in pairs(tabs) do
        local index
        for index = tab.offset + 1, tab.offset + tab.count do
            local type, id = GetSpellBookItemInfo(index, tab.type)
            local name = GetSpellBookItemName(index, tab.type)

            if type == "FLYOUT" then
                self:UpdateCache(flyouts, index, id, name)

            elseif type == "SPELL" then
                self:UpdateCache(spells, id, id, name)
            end
        end
    end
end

function HotbarProfiles:PreloadMountjournal(mounts)
    local all = C_MountJournal.GetMountIDs()
    local faction = (UnitFactionGroup("player") == "Alliance" and 1) or 0

    local idx, mount
    for idx, mount in pairs(all) do
        local name, id, required, collected = table.s2k_select({ C_MountJournal.GetMountInfoByID(mount) }, 1, 2, 9, 11)

        if collected and (not required or required == faction) then
            self:UpdateCache(mounts, id, id, name)
        end
    end
end

function HotbarProfiles:PreloadCombatAllySpells(spells)
    local idx, follower
    for idx, follower in pairs(C_Garrison.GetFollowers() or {}) do
        if follower.garrFollowerID then
            local idx, id
            for idx, id in pairs({ C_Garrison.GetFollowerZoneSupportAbilities(follower.garrFollowerID) }) do
                local name = GetSpellInfo(id)
                self:UpdateCache(spells, 211390, id, name)
            end
        end
    end
end

function HotbarProfiles:PreloadTalents(talents, all)
    local tier
    for tier = 1, MAX_TALENT_TIERS do
        all[tier] = all[tier] or { id = {}, name = {} }

        if GetTalentTierInfo(tier, 1) then
            local column
            for column = 1, NUM_TALENT_COLUMNS do
                local id, name, _, selected = GetTalentInfo(tier, column, 1)

                if selected then
                    self:UpdateCache(talents, id, id, name)
                end

                self:UpdateCache(all[tier], id, id, name)
            end
        end
    end
end

function HotbarProfiles:PreloadEquip(equip)
    local slot
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local id = GetInventoryItemID("player", slot)
        if id then
            self:UpdateCache(equip, slot, id, GetItemInfo(id))
        end
    end
end

function HotbarProfiles:PreloadBags(bags)
    local bag
    for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        local index
        for index = 1, GetContainerNumSlots(bag) do
            local id = GetContainerItemID(bag, index)
            if id then
                self:UpdateCache(bags, { bag, index }, id, GetItemInfo(id))
            end
        end
    end
end

function HotbarProfiles:PreloadPetJournal(pets)
    log("c1")
    local saved = self:SavePetJournalFilters()
    log("c2")

    C_PetJournal.ClearSearchFilter()

    C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED, true)
    C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED, false)

    C_PetJournal.SetAllPetSourcesChecked(true)
    C_PetJournal.SetAllPetTypesChecked(true)

    log("c3")
    local index
    for index = 1, C_PetJournal:GetNumPets() do
        log("c4")
        local id, species = C_PetJournal.GetPetInfoByIndex(index)
        self:UpdateCache(pets, id, id, species)
    end

    log("c5")
    self:RestorePetJournalFilters(saved)
    log("c6")
end

function HotbarProfiles:PackMacro(macro)
    return macro:gsub("^%s+", ""):gsub("%s+\n", "\n"):gsub("\n%s+", "\n"):gsub("%s+$", ""):sub(1)
end

function HotbarProfiles:PreloadMacros(macros)
    local all, char = GetNumMacros()

    local index
    for index = 1, all do
        local name, _, body = GetMacroInfo(index)
        if body then
            self:UpdateCache(macros, index, HotbarProfiles:PackMacro(body), name)
        end
    end

    for index = MAX_ACCOUNT_MACROS + 1, MAX_ACCOUNT_MACROS + char do
        local name, _, body = GetMacroInfo(index)
        if body then
            self:UpdateCache(macros, index, HotbarProfiles:PackMacro(body), name)
        end
    end
end

function HotbarProfiles:PreloadPetSpells(spells)
    if HasPetSpells() then
        local index
        for index = 1, HasPetSpells() do
            local id = select(2, GetSpellBookItemInfo(index, BOOKTYPE_PET))
            local name = GetSpellBookItemName(index, BOOKTYPE_PET)
            local token = bit.band(id, 0x80000000) == 0 and bit.rshift(id, 24) ~= 1

            id = bit.band(id, 0xFFFFFF)

            if token then
                self:UpdateCache(spells, index, -1, name)
            else
                self:UpdateCache(spells, index, id, name)
            end
        end
    end
end

function HotbarProfiles:ClearSlot(slot)
    ClearCursor()
    PickupAction(slot)
    ClearCursor()
end

function HotbarProfiles:PlaceToSlot(slot)
    PlaceAction(slot)
    ClearCursor()
end

function HotbarProfiles:ClearPetSlot(slot)
    ClearCursor()
    PickupPetAction(slot)
    ClearCursor()
end

function HotbarProfiles:PlaceToPetSlot(slot)
    PickupPetAction(slot)
    ClearCursor()
end

function HotbarProfiles:PlaceSpell(slot, id, link, count)
    count = count or HBP_PICKUP_RETRY_COUNT

    ClearCursor()
    PickupSpell(id)

    if not CursorHasSpell() then
        if count > 0 then
            self:ScheduleTimer(function()
                self:PlaceSpell(slot, id, link, count - 1)
            end, HBP_PICKUP_RETRY_INTERVAL)
        else
            self:cPrintf(link, DEBUG .. "L.msg_cant_place_spell", link)
        end
    else
        self:PlaceToSlot(slot)
    end
end

function HotbarProfiles:PlaceSpellBookItem(slot, id, tab, link, count)
    count = count or HBP_PICKUP_RETRY_COUNT

    ClearCursor()
    PickupSpellBookItem(id, tab)

    if not CursorHasSpell() then
        if count > 0 then
            self:ScheduleTimer(function()
                self:PlaceSpellBookItem(slot, id, tab, link, count - 1)
            end, HBP_PICKUP_RETRY_INTERVAL)
        else
            self:cPrintf(link, DEBUG .. "L.msg_cant_place_spell", link)
        end
    else
        self:PlaceToSlot(slot)
    end
end

function HotbarProfiles:PlaceFlyout(slot, id, tab, link, count)
    ClearCursor()
    PickupSpellBookItem(id, tab)

    self:PlaceToSlot(slot)
end

function HotbarProfiles:PlaceTalent(slot, id, link, count)
    count = count or HBP_PICKUP_RETRY_COUNT

    ClearCursor()
    PickupTalent(id)

    if not CursorHasSpell() then
        if count > 0 then
            self:ScheduleTimer(function()
                self:PlaceTalent(slot, id, link, count - 1)
            end, HBP_PICKUP_RETRY_INTERVAL)
        else
            self:cPrintf(link, DEBUG .. "L.msg_cant_place_spell", link)
        end
    else
        self:PlaceToSlot(slot)
    end
end

function HotbarProfiles:PlaceMount(slot, id, link, count)
    ClearCursor()
    C_MountJournal.Pickup(id)

    self:PlaceToSlot(slot)
end

function HotbarProfiles:PlaceItem(slot, id, link, count)
    ClearCursor()
    PickupItem(id)

    self:PlaceToSlot(slot)
end

function HotbarProfiles:PlaceInventoryItem(slot, id, link, count)
    count = count or HBP_PICKUP_RETRY_COUNT

    ClearCursor()
    PickupInventoryItem(id)

    if not CursorHasItem() then
        if count > 0 then
            self:ScheduleTimer(function()
                self:PlaceInventoryItem(slot, id, link, count - 1)
            end, HBP_PICKUP_RETRY_INTERVAL)
        else
            self:cPrintf(link, DEBUG .. "L.msg_cant_place_item", link)
        end
    else
        self:PlaceToSlot(slot)
    end
end

function HotbarProfiles:PlaceContainerItem(slot, bag, id, link, count)
    count = count or HBP_PICKUP_RETRY_COUNT

    ClearCursor()
    PickupContainerItem(bag, id)

    if not CursorHasItem() then
        if count > 0 then
            self:ScheduleTimer(function()
                self:PlaceContainerItem(slot, id, link, count - 1)
            end, HBP_PICKUP_RETRY_INTERVAL)
        else
            self:cPrintf(link, DEBUG .. "L.msg_cant_place_item", link)
        end
    else
        self:PlaceToSlot(slot)
    end
end

function HotbarProfiles:PlacePet(slot, id, link, count)
    ClearCursor()
    C_PetJournal.PickupPet(id)

    self:PlaceToSlot(slot)
end

function HotbarProfiles:PlaceMacro(slot, id, link, count)
    count = count or HBP_PICKUP_RETRY_COUNT

    ClearCursor()
    PickupMacro(id)

    if not CursorHasMacro() then
        if count > 0 then
            self:ScheduleTimer(function()
                self:PlaceMacro(slot, id, link, count - 1)
            end, HBP_PICKUP_RETRY_INTERVAL)
        else
            self:cPrintf(link, DEBUG .. "L.msg_cant_place_macro", link)
        end
    else
        self:PlaceToSlot(slot)
    end
end

function HotbarProfiles:PlaceEquipment(slot, id, link, count)
    ClearCursor()
    PickupEquipmentSetByName(id)

    self:PlaceToSlot(slot)
end

function HotbarProfiles:PlacePetSpell(slot, id, link, count)
    ClearCursor()
    PickupSpellBookItem(id, BOOKTYPE_PET)

    self:PlaceToPetSlot(slot)
end

function HotbarProfiles:IsDefault(profile, key)
    if type(profile) ~= "table" then
        local list = self.db.profile.list
        profile = list[profile]

        if not profile then return end
    end

    return profile.fav and profile.fav[key] and true or nil
end