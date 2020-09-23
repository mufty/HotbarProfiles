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

function HotbarPopup:createHotbarPopup()
    self:SetTitle("HotbarProfiles")

    self:SetCallback("OnClose", function(widget)
        HotbarProfiles.db.profile.drop.hide = true
        self:Hide()
    end)

    local saveActionBars = AceGUI:Create("Label")
    saveActionBars:SetText("Enter name to save the current action bars")
    self:AddChild(saveActionBars)

    local saveABName = AceGUI:Create("EditBox")
    saveABName:SetLabel("Name:")
    saveABName:SetCallback("OnEnterPressed", function(widget, event, text)
        log(text)
    end)
    self:AddChild(saveABName)

    local loadButton = AceGUI:Create("Button")
    loadButton:SetText("Load")
    loadButton:SetCallback("OnClick", function()
        local slot
        for slot = 1, ABP_MAX_ACTION_BUTTONS do
            local type, id, sub = GetActionInfo(slot)
            log(type)
            log(id)
            log(sub)
        end
    end)
    self:AddChild(loadButton)
end

HotbarPopup:createHotbarPopup()

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

HotbarPopup:Hide()

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
        },
    })
    icon:Register("HotbarProfiles", hpLDB, self.db.profile.minimap)
    self:RegisterChatCommand("hbp", "HotbarProfilesControll")
    log("Calling addon init done")
end

icon:Show("HotbarProfiles")

function HotbarProfiles:HotbarProfilesControll()
    log("Calling addon /hbp callback")
    toggleHBP()
end