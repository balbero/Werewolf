if not WereWolf.IsCorrectVersion() then return end

-- other Libs
local AceGUI = LibStub("AceGUI-3.0")
local AceTimer = LibStub("AceTimer-3.0")

local WereWolf = WereWolf
local L = WereWolf.L
local Comm = WereWolf.Comm

local layouts = {}
-- AceTimer:ScheduleTimer("TimerFeedback", 5)
-- TimerFeedback -> callback function

local RogueFrame;

function WereWolf.IsRogueOpen()
    if(RogueFrame and RogueFrame:IsVisible()) then
        return true;
    else
        return false;
    end
end

function WereWolf.DisplayRogueInterface()
    local isOpen = WereWolf.IsRogueOpen();
  
    if not(isOpen) then
        WereWolf.CreateGogueFrame();
        RogueFrame:Show();
    end
end

function WereWolf.CreateGogueFrame()
    RogueFrame = AceGUI:Create("SimpleGroup") 
    RogueFrame:SetLayout("Fill")
    RogueFrame.frame:SetToplevel(true)
    
    RogueFrame.label = AceGUI:Create("Label")
    RogueFrame:SetText(L["Choose Wisely"])
    RogueFrame:SetFont(GameFontHighlightSmall:GetFont(), 10)
    RogueFrame:SetFullWidth(true)

    RogueFrame:AddChild(RogueFrame.label)
    local col = 0;
    local selectedRole = WereWolf.GetAvailabelRoleForRogue()
    for _, value in pairs(selectedRole) do
        local zone = AceGUI:Create("PlayerZone")

        zone:SetColor(1, 1, 1)
        zone:SetImage(134400)
        zone:SetCallback("OnClick", 
        function() 
            WereWolf.DisplayPortraitOnRogueFrame(zone, value) 
        end)

        zone:SetPoint("TOPLEFT", RogueFrame.frame, "TOPLEFT", 120*col, -30)
        RogueFrame:AddChild(zone)

        table.insert(layouts, zone)
        col = col + 1
    end
    RogueFrame:SetWidth(260)
    RogueFrame:SetHeight(180)
end

function WereWolf.DisplayPortraitOnRogueFrame(zone, role) 

    RogueFrame:SetText(L["You choose : "]..role.Name)
    for _, value in pairs(layouts) do
        value:SetDisabled(true)
    end

    zone:SetImage(role.Icon)

    WereWolf.SetSpecificRoleToPlayer(WereWolf.me, role)

    AceTimer:ScheduleTimer("WereWolf.SwitchNext", 5)
end

function WereWolf.SwitchNext()
    for key,value in pairs(players) do
        Comm:SendCommand(value.Name, "next_step")
    end    
end
