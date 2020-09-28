StorageModule = HotbarProfiles:NewModule("StorageModule");

function StorageModule:saveActions(profile)
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
                            icon, ParsingModule:encodeLink(body), name
                    )
                else
                    actions[slot] = string.format(
                            "|cffff0000|Habp:macro:%s:%s:1|h[%s]|h|r",
                            icon, ParsingModule:encodeLink(body), name
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
                    icon, ParsingModule:encodeLink(body), name
            ))
        end
    end

    for index = MAX_ACCOUNT_MACROS + 1, MAX_ACCOUNT_MACROS + charMacros do
        local name, icon, body = GetMacroInfo(index)

        icon = icon or HBP_EMPTY_ICON_TEXTURE_ID

        if body and not savedMacros[index] then
            table.insert(macros, string.format(
                    "|cffff0000|Habp:macro:%s:%s|h[%s]|h|r",
                    icon, ParsingModule:encodeLink(body), name
            ))
        end
    end

    profile.macros = macros
end

function StorageModule:makeCache()
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

    self:preloadTalents(cache.talents, cache.allTalents)
    self:preloadSpecialSpells(cache.spells)
    self:preloadSpellbook(cache.spells, cache.flyouts)
    self:preloadMountjournal(cache.spells)
    self:preloadCombatAllySpells(cache.spells)
    self:preloadEquip(cache.equip)
    self:preloadBags(cache.bags)
    self:preloadPetJournal(cache.pets)
    self:preloadMacros(cache.macros)
    self:preloadPetSpells(cache.petSpells)
    return cache
end

function StorageModule:preloadPetSpells(spells)
    if HasPetSpells() then
        local index
        for index = 1, HasPetSpells() do
            local id = select(2, GetSpellBookItemInfo(index, BOOKTYPE_PET))
            local name = GetSpellBookItemName(index, BOOKTYPE_PET)
            local token = bit.band(id, 0x80000000) == 0 and bit.rshift(id, 24) ~= 1

            id = bit.band(id, 0xFFFFFF)

            if token then
                self:updateCache(spells, index, -1, name)
            else
                self:updateCache(spells, index, id, name)
            end
        end
    end
end

function StorageModule:preloadMacros(macros)
    local all, char = GetNumMacros()

    local index
    for index = 1, all do
        local name, _, body = GetMacroInfo(index)
        if body then
            self:updateCache(macros, index, self:packMacro(body), name)
        end
    end

    for index = MAX_ACCOUNT_MACROS + 1, MAX_ACCOUNT_MACROS + char do
        local name, _, body = GetMacroInfo(index)
        if body then
            self:updateCache(macros, index, self:packMacro(body), name)
        end
    end
end

function StorageModule:packMacro(macro)
    return macro:gsub("^%s+", ""):gsub("%s+\n", "\n"):gsub("\n%s+", "\n"):gsub("%s+$", ""):sub(1)
end

function StorageModule:restorePetJournalFilters(saved)
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

function StorageModule:savePetJournalFilters()
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

function StorageModule:preloadPetJournal(pets)
    local saved = self:savePetJournalFilters()

    C_PetJournal.ClearSearchFilter()

    C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED, true)
    C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED, false)

    C_PetJournal.SetAllPetSourcesChecked(true)
    C_PetJournal.SetAllPetTypesChecked(true)

    local index
    for index = 1, C_PetJournal:GetNumPets() do
        local id, species = C_PetJournal.GetPetInfoByIndex(index)
        self:updateCache(pets, id, id, species)
    end

    self:restorePetJournalFilters(saved)
end

function StorageModule:preloadBags(bags)
    local bag
    for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        local index
        for index = 1, GetContainerNumSlots(bag) do
            local id = GetContainerItemID(bag, index)
            if id then
                self:updateCache(bags, { bag, index }, id, GetItemInfo(id))
            end
        end
    end
end

function StorageModule:preloadEquip(equip)
    local slot
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local id = GetInventoryItemID("player", slot)
        if id then
            self:updateCache(equip, slot, id, GetItemInfo(id))
        end
    end
end

function StorageModule:preloadCombatAllySpells(spells)
    local idx, follower
    for idx, follower in pairs(C_Garrison.GetFollowers() or {}) do
        if follower.garrFollowerID then
            local idx, id
            for idx, id in pairs({ C_Garrison.GetFollowerZoneSupportAbilities(follower.garrFollowerID) }) do
                local name = GetSpellInfo(id)
                self:updateCache(spells, 211390, id, name)
            end
        end
    end
end

function StorageModule:preloadMountjournal(mounts)
    local all = C_MountJournal.GetMountIDs()
    local faction = (UnitFactionGroup("player") == "Alliance" and 1) or 0

    local idx, mount
    for idx, mount in pairs(all) do
        local name, id, required, collected = table.s2k_select({ C_MountJournal.GetMountInfoByID(mount) }, 1, 2, 9, 11)

        if collected and (not required or required == faction) then
            self:updateCache(mounts, id, id, name)
        end
    end
end

function StorageModule:preloadSpellbook(spells, flyouts)
    local tabs = {}
    local book
    for book = 1, GetNumSpellTabs() do
        local offset, count, _, spec = select(3, GetSpellTabInfo(book))

        if spec == 0 then
            table.insert(tabs, { type = BOOKTYPE_SPELL, offset = offset, count = count })
        end
    end

    local prof
    for prof in table.s2k_values({ GetProfessions() }) do
        if prof then
            local count, offset = select(5, GetProfessionInfo(prof))

            table.insert(tabs, { type = BOOKTYPE_PROFESSION, offset = offset, count = count })
        end
    end
    local tab
    for tab in table.s2k_values(tabs) do
        local index
        for index = tab.offset + 1, tab.offset + tab.count do
            local type, id = GetSpellBookItemInfo(index, tab.type)
            local name = GetSpellBookItemName(index, tab.type)

            if type == "FLYOUT" then
                self:updateCache(flyouts, index, id, name)

            elseif type == "SPELL" then
                self:updateCache(spells, id, id, name)
            end
        end
    end
end

function StorageModule:preloadTalents(talents, all)
    local tier
    for tier = 1, MAX_TALENT_TIERS do
        all[tier] = all[tier] or { id = {}, name = {} }

        if GetTalentTierInfo(tier, 1) then
            local column
            for column = 1, NUM_TALENT_COLUMNS do
                local id, name, _, selected = GetTalentInfo(tier, column, 1)

                if selected then
                    self:updateCache(talents, id, id, name)
                end

                self:updateCache(all[tier], id, id, name)
            end
        end
    end
end

function StorageModule:preloadSpecialSpells(spells)
    local level = UnitLevel("player")
    local class = select(2, UnitClass("player"))
    local faction = UnitFactionGroup("player")
    local spec = GetSpecializationInfo(GetSpecialization())

    local id, info
    for id, info in pairs(HBP_SPECIAL_SPELLS) do
        if (not info.level or level >= info.level) and
                (not info.class or class == info.class) and
                (not info.faction or faction == info.faction) and
                (not info.spec or spec == info.spec)
        then
            self:updateCache(spells, id, id)
            if info.altSpellIds then
                local idx, alt
                for idx, alt in pairs(info.altSpellIds) do
                    self:updateCache(spells, id, alt)
                end
            end
        end
    end
end

function StorageModule:updateCache(cache, value, id, name)
    cache.id[id] = value

    if cache.name and name then
        cache.name[name] = value
    end
end