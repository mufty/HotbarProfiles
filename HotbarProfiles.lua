local AceGUI = LibStub("AceGUI-3.0")

ABP_MAX_ACTION_BUTTONS = 120

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

function HotbarProfiles:saveBars(name)
    log(name)

    local list = self.db.profile.list
    local profile = { name = name, default = false }

    list[name] = profile

    HotbarPopup:updateProfileList()

    HotbarPopup:SetStatusText("Profile '" .. name .. "' saved");
end

function HotbarProfiles:deleteProfile(profile)
    log(profile.name)

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