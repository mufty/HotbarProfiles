local AceGUI = LibStub("AceGUI-3.0")

HBP_MAX_ACTION_BUTTONS = 120
HBP_EMPTY_ICON_TEXTURE_ID = 134400
HBP_RANDOM_MOUNT_SPELL_IDHBP_RANDOM_MOUNT_SPELL_ID = 150544

HotbarProfiles = LibStub("AceAddon-3.0"):NewAddon("HotbarProfiles", "AceConsole-3.0")

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