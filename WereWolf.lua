if not WereWolf.IsCorrectVersion() then return end

-- Lua APIs
local tinsert, tremove, wipe = table.insert, table.remove, wipe
local fmt, tostring = string.format, tostring
local pairs, type, unpack = pairs, type, unpack
local loadstring, error = loadstring, error

-- WoW APIs
local InCombatLockdown = InCombatLockdown
local GetScreenWidth, GetScreenHeight, GetBuildInfo, GetLocale, GetTime, CreateFrame, IsAddOnLoaded, LoadAddOn
  = GetScreenWidth, GetScreenHeight, GetBuildInfo, GetLocale, GetTime, CreateFrame, IsAddOnLoaded, LoadAddOn
local UnitClass, GetFontString = UnitClass, GetFontString
local GetNumGuildMembers, GetGuildRosterInfo = GetNumGuildMembers, GetGuildRosterInfo

local LDBIcon = LibStub("LibDBIcon-1.0")
local AceGUI = LibStub("AceGUI-3.0")
local AceTimer = LibStub("AceTimer-3.0")

local ADDON_NAME = "WereWolf"
local WereWolf = WereWolf
local L = WereWolf.L
local Comm = WereWolf.Comm
local versionString = WereWolf.versionString
local prettyPrint = WereWolf.prettyPrint

local defaultWidth = 830
local defaultHeight = 665
local minWidth = 750
local minHeight = 240

local MainFrame;
WereWolf.MainFrame = MainFrame
local players = WereWolf.players



function WereWolf.PrintHelp()
    print(" ")
    print(L["Usage:"])
    print("|cff0000ff/ww help|r - "..L["Show this message"])
    print("|cff0000ff/ww minimap|r - "..L["Toggle the minimap icon"])
    print("|cff0000ff/ww show|r - "..L["Toggle the config frame"])    
    print(" ")
end

function WereWolf.ToggleMinimap()
    WerewolfDB.minimap.hide = not WerewolfDB.minimap.hide
    if WerewolfDB.minimap.hide then
      LDBIcon:Hide("WereWolf");
      prettyPrint(L["Use /wa minimap to show the minimap icon again"])
    else
      LDBIcon:Show("WereWolf");
    end
  end

function WereWolf.OpenOptions(msg)
    if  WereWolf.LoadOptions(msg) then
        WereWolf.ShowOptions(msg);
    end
end

local function AddGroupDescription(container, header, description, imagePath)
    
    local group = AceGUI:Create("InlineGroup")
    group:SetTitle(header)
    group:SetFullWidth(true)

    local peon = AceGUI:Create("Label")
    peon:SetImage(imagePath)
    peon:SetImageSize(32,32)
    peon:SetText(description)
    peon:SetFont(GameFontHighlightSmall:GetFont(), 10)
    peon:SetFullWidth(true)

    group:AddChild(peon)
    container:AddChild(group)
    
    local space = AceGUI:Create("Label")
    space:SetText("") -- just space label
    space:SetFullWidth(true)
    container:AddChild(space)

end

-- function that draws the widgets for the first tab
local function DrawGroup1(container)
    local scrollcontainer = AceGUI:Create("SimpleGroup") 
    scrollcontainer:SetFullWidth(true)
    scrollcontainer:SetFullHeight(true) 
    scrollcontainer:SetLayout("Fill")
    container:AddChild(scrollcontainer)

    local scroll = AceGUI:Create("ScrollFrame")
    scroll:SetLayout("Flow")
    scrollcontainer:AddChild(scroll)


    local descH = AceGUI:Create("Heading")
    descH:SetText(L["GameGoalHeader"])
    descH:SetFullWidth(true)
    scroll:AddChild(descH)
    local desc = AceGUI:Create("Label")
    desc:SetText(L["GameDescription"])
    desc:SetFullWidth(true)
    scroll:AddChild(desc)
    

    local charH = AceGUI:Create("Heading")
    charH:SetText(L["GameCharacter"])
    charH:SetFullWidth(true)
    scroll:AddChild(charH)

    AddGroupDescription(scroll, L["Peon"], L["GameCharPeon"], "Interface\\Icons\\Ability_racial_avatar")
    AddGroupDescription(scroll, L["Werewolf"], L["GameCharWereWolf"], "Interface\\Icons\\Ability_mount_blackdirewolf")
    
    local specialCharH = AceGUI:Create("Heading")
    specialCharH:SetText(L["SpecialGameCharacter"])
    specialCharH:SetFullWidth(true)
    scroll:AddChild(specialCharH)
    
    AddGroupDescription(scroll, L["Hunter"], L["GameCharHunter"], "Interface\\Icons\\Ability_hunter_zenarchery")
    AddGroupDescription(scroll, L["Cathy"], L["GameCharCathy"], "Interface\\Icons\\Ability_seal")
    AddGroupDescription(scroll, L["Witch"], L["GameCharWitch"], "Interface\\Icons\\Inv_alchemy_enchantedvial")
    AddGroupDescription(scroll, L["Captain"], L["GameCharCaptain"], "Interface\\Icons\\Ability_warrior_defensivestance")
    AddGroupDescription(scroll, L["Cupid"], L["GameCharCupid"], "Interface\\Icons\\Inv_misc_gem_sapphire_01")
    AddGroupDescription(scroll, L["Rogue"], L["GameCharRogue"], "Interface\\Icons\\Ability_stealth")
    AddGroupDescription(scroll, L["Seer"], L["GameCharSeer"], "Interface\\Icons\\Ability_townwatch")
    AddGroupDescription(scroll, L["Lover"], L["GameCharLover"], "Interface\\Icons\\Inv_valentinesboxofchocolates02")

end
  
-- function that draws the widgets for the second tab
local function DrawGroup2(container)
    local scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
    scrollcontainer:SetFullWidth(false)
    scrollcontainer:SetWidth(300)
    scrollcontainer:SetFullHeight(true) -- probably?
    scrollcontainer:SetLayout("Fill")

    local scroll = AceGUI:Create("ScrollFrame")
    scroll:SetLayout("List")
    scrollcontainer:AddChild(scroll)

    WereWolf.InviteList(scroll)
    container:AddChild(scrollcontainer)

    local gameMasterOption = AceGUI:Create("InlineGroup")
    gameMasterOption:SetText(L["GMOptions"])
    local GMcheckBox = AceGUI:Create("CheckBox")
    local PlayGMcheckBox = AceGUI:Create("CheckBox")
    GMcheckBox:SetType("radio")
    GMcheckBox:SetValue(true)
    GMcheckBox:SetCallback("OnValueChanged", function(checked) 
                                                if checked then 
                                                    PlayGMcheckBox:SetValue(false) 
                                                end 
                                            end)
    GMcheckBox:SetLabel(L["AddonGameMaster"])
    PlayGMcheckBox:SetType("radio")
    PlayGMcheckBox:SetValue(false)
    PlayGMcheckBox:SetCallback("OnValueChanged", function(checked) 
                                                if checked then 
                                                    GMcheckBox:SetValue(false) 
                                                end 
                                            end)
    PlayGMcheckBox:SetLabel(L["PlayGameMaster"])

    gameMasterOption:AddChild(GMcheckBox)
    gameMasterOption:AddChild(PlayGMcheckBox)

    container:AddChild(gameMasterOption)

    local startBtn = AceGUI:Create("Button")
    startBtn:SetText(L["Start"])
    startBtn:SetCallback("OnClick", function() 
        MainFrame:Hide()

        if PlayGMcheckBox:GetValue() == true then
            WereWolf.StartAsGameMaster()
        else
		    table.insert(WereWolf.players, WereWolf.me)
            WereWolf.StartAsPlayer()
        end

    end)
    
    container:AddChild(startBtn)

end


  -- Callback function for OnGroupSelected
local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == "tab1" then
        DrawGroup1(container)
    elseif group == "tab2" then
        DrawGroup2(container)
    end
end


function WereWolf.CreateMainFrame()
    -------- Mostly Copied from AceGUIContainer-Frame--------
    MainFrame =  AceGUI:Create("Frame")
    MainFrame:SetTitle("WereWolf " .. WereWolf.versionString)
    MainFrame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    -- Fill Layout - the TabGroup widget will fill the whole frame
    MainFrame:SetLayout("Fill")
    
    local tab =  AceGUI:Create("TabGroup")
    tab:SetLayout("Flow")
    -- Setup which tabs to show
    tab:SetTabs({{text=L["Game Rules"], value="tab1"}, {text=L["Game Setup"], value="tab2"}})
    -- Register callback
    tab:SetCallback("OnGroupSelected", SelectGroup)
    -- Set initial Tab (this will fire the OnGroupSelected callback)
    tab:SelectTab("tab1")

    -- add to the frame container
    MainFrame:AddChild(tab)
end


function WereWolf.tooltip_draw()
	local tooltip = GameTooltip;
	tooltip:ClearLines();
	tooltip:AddDoubleLine("WereWolf", versionString);
	
	tooltip:AddLine(" ");
	tooltip:AddLine(L["|cffeda55fLeft-Click|r to toggle showing the main window."], 0.2, 1, 0.2);
	tooltip:AddLine(L["|cffeda55fMiddle-Click|r to toggle the minimap icon on or off."], 0.2, 1, 0.2);
	tooltip:Show();
end

function WereWolf.getAnchors(frame)
	local x, y = frame:GetCenter()
	if not x or not y then return "CENTER" end
	local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
	local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
	return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
end

local queueshowooc;

function WereWolf.LoadOptions(msg)
    if(MainFrame and MainFrame:IsVisible()) then
        WereWolf.HideOptions();
        return false;
    elseif InCombatLockdown() then
        -- inform the user and queue ooc
        prettyPrint(L["Options will finish loading after combat ends."])
        queueshowooc = msg or "";
        WereWolf.frames["Addon Handler"]:RegisterEvent("PLAYER_REGEN_ENABLED")
        return false;
    end
    return true
end


local frame = CreateFrame("FRAME", "WereWolfMainFrame", UIParent);
WereWolf.frames["WereWolf Main Frame"] = frame;
frame:SetAllPoints(UIParent);
local loadedFrame = CreateFrame("FRAME");
WereWolf.frames["Addon Handler"] = loadedFrame;
loadedFrame:RegisterEvent("LOADING_SCREEN_ENABLED");
loadedFrame:RegisterEvent("LOADING_SCREEN_DISABLED");
loadedFrame:SetScript("OnEvent", function(self, event, addon)
    if(event == "LOADING_SCREEN_ENABLED") then
        in_loading_screen = true;
    elseif(event == "LOADING_SCREEN_DISABLED") then
        in_loading_screen = false;
    else
        local callback
        if(event == "PLAYER_REGEN_ENABLED") then
            callback = function()
              if (queueshowooc) then
                WereWolf.OpenOptions(queueshowooc)
                queueshowooc = nil
                WereWolf.frames["Addon Handler"]:UnregisterEvent("PLAYER_REGEN_ENABLED")
              end
            end
        end
        callback()
    end
end);

function WereWolf.ShowOptions(msg)
    local isOpen = WereWolf.IsOptionsOpen();
    -- WereWolf.Pause();
  
    if not(isOpen) then
        WereWolf.CreateMainFrame();
        MainFrame:Show();
    end
end
  
function WereWolf.HideOptions()
    if(MainFrame) then
        MainFrame:Hide()
    end
end
  
function WereWolf.IsOptionsOpen()
    if(MainFrame and MainFrame:IsVisible()) then
        return true;
    else
        return false;
    end
end
  

function WereWolf.IsShown()
    if(WereWolf.IsOptionsOpen()) then
        return MainFrame:IsShown()
    elseif WereWolf.IsOptionsOpen() then
        return GameFrame:IsShown()
    end
end