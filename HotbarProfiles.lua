local AceGUI = LibStub("AceGUI-3.0")

--[[local frame = AceGUI:Create("Frame")
frame:SetTitle("Mike debug frame")
frame:SetStatusText("Debug ready")

local function log(msg)
    local desc = AceGUI:Create("Label")
    desc:SetText(msg)
    desc:SetFullWidth(true)
    frame:AddChild(desc)
end--]]

HotbarProfiles = LibStub("AceAddon-3.0"):NewAddon("HotbarProfiles", "AceConsole-3.0")

local function log(msg)
    HotbarProfiles:Print(msg)
end

log("HotbarProfiles use /hbp to enable the addon")

local hpLDB = LibStub("LibDataBroker-1.1"):NewDataObject("HotbarProfiles", {
    type = "data source",
    text = "HotbarProfiles",
    icon = "Interface\\Icons\\INV_Chest_Cloth_17",
    OnClick = function() print("HotbarProfiles addon by Mike") end,
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
        },
    })
    icon:Register("HotbarProfiles", hpLDB, self.db.profile.minimap)
    self:RegisterChatCommand("hbp", "HotbarProfilesControll")
    log("Calling addon init done")
end

function HotbarProfiles:HotbarProfilesControll()
    log("Calling addon /hbp callback")
    self.db.profile.minimap.hide = not self.db.profile.minimap.hide
    if self.db.profile.minimap.hide then
        icon:Hide("HotbarProfiles")
    else
        icon:Show("HotbarProfiles")
    end

    log("Calling addon /hbp callback done")
end