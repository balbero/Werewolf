if not WereWolf.IsCorrectVersion() then return end

-- other Libs
local AceGUI = LibStub("AceGUI-3.0")

local WereWolf = WereWolf
local L = WereWolf.L
local players = WereWolf.players
local GameFrame;
local Comm = WereWolf.Comm

local layouts = {}
local nbClickAuth = 0;

function WereWolf.IsGameOpen()
    if(GameFrame and GameFrame:IsVisible()) then
        return true;
    else
        return false;
    end
end

function WereWolf.DisplayGameFrame()
    local isOpen = WereWolf.IsGameOpen();
  
    if not(isOpen) then
        WereWolf.CreateGameFrame();
        GameFrame:Show();
    end
end

function WereWolf.ShowTimerFrame(msg, timeOut)
    WereWolf.printDebug(msg.." "..timeOut.."s")
    GameFrame.announcement:ResetTimer()
    GameFrame.announcement:SetLabel(msg)
    GameFrame.announcement:SetTimeOut(timeOut)
    GameFrame.announcement:ShowTimer()
end

function WereWolf.CreatePlayerFrame(content, player, col, line)

    local playerGroup = AceGUI:Create("SimpleGroup") 
        
    local playerZone = AceGUI:Create("PlayerZone")        
    local color = RAID_CLASS_COLORS[player.Class]
    playerZone:SetColor(color.r, color.g, color.b)
    playerZone:SetDisabled(true)
    playerZone:SetLabel(player.Name)
    playerZone:SetCallback("OnClick", 
        function() 
            WereWolf.SaveClickedPortrait(player) 
        end)

    local playerVoteButton = AceGUI:Create("Button")
    playerVoteButton:SetWidth(115)
    playerVoteButton:SetDisabled(true)
    playerVoteButton:SetText(L["Kill"])
    
    player.RoleZone = playerZone
    player.VoteBtn = playerVoteButton

    playerGroup:AddChild(playerZone)
    playerGroup:AddChild(playerVoteButton)

    playerGroup:SetWidth(115)
    playerGroup:SetHeight(160)
    
    playerGroup:SetPoint("TOPLEFT", content.frame, "TOPLEFT", 120*col, -130*line)
    table.insert(layouts, playerGroup)
    content:AddChild(playerGroup)

end

function WereWolf.TimerEnds()
    if GameFrame.announcement:IsTimerVisible() then
        GameFrame.announcement:HideTimer()
        Comm:SendCommand(WereWolf.me.Name, "next_step")
    end
end

-- function that draws the game frame
function WereWolf.CreateGameFrame()

    GameFrame = AceGUI:Create("GameFrame")
    GameFrame:SetTitle(L["GamePanel"])
    GameFrame:SetLayout("Flow")
    
    
    GameFrame.announcement = AceGUI:Create("TimerZone")
    GameFrame.announcement:SetFullWidth(true)
    GameFrame.announcement:SetCallback("TimerEnds", WereWolf.TimerEnds)

    GameFrame:AddChild(GameFrame.announcement)

    local frameGroup = AceGUI:Create("SimpleGroup")
    frameGroup:SetLayout("Fill")

    local col = 0;
    local line = 0;
    for key,value in pairs(players) do
        -- Creer un Widget avec frame + btn
        -- arranger l'orientation en grille
        -- ajoute l'emplacement de l'icone
        WereWolf.CreatePlayerFrame(frameGroup, value, col, line)
        -- 4*5
        if line == 3 then
            line = 0
            col = col + 1
        else
            line = line + 1
        end
    end


    GameFrame:AddChild(frameGroup)

    GameFrame:SetWidth(700)
    GameFrame:SetHeight(675)
    return GameFrame
end
    
function WereWolf.DiscoverPlayerRole(player)
    WereWolf.DisplayGameFrame()
    
    player.RoleZone:SetImage(player.Role.Icon)
end

local clickedPlayers = { };
function WereWolf.SaveClickedPortrait(player)
    if(nbClickAuth > 0) then
        local found = false
        for key, value in pairs(clickedPlayers) do
            if(value.id == player.id) then
                    found = true
                break
            end
        end
        if found then
            WereWolf.prettyPrint(L["You can not choose him twice"])
        else
            nbClickAuth = nbClickAuth - 1
            table.insert(clickedPlayers, player)
        end
    end

    if(nbClickAuth == 0) then
        for key, value in pairs(layouts) do
            value.playerZone:SetDisabled(true)
        end
        for key, value in pairs(clickedPlayers) do
            -- send message
            if(WereWolf.currentStep == "Cupid") then
                Comm:SendCommand(value.Name, "ww_player_designated")
            elseif (WereWolf.currentStep == "Seer") then
                Comm:SendCommand(WereWolf.me.Name, "ww_player_designated", value)
            end
        end
        
        for key,value in pairs(players) do
            Comm:SendCommand(value.Name, "next_step")
        end
    end
end



function WereWolf.EnableAndAuthorizeClick(nbClickAuthorized)
    clickedPlayers = { };
    nbClickAuth = nbClickAuthorized
    for key, value in pairs(layouts) do
        value.playerZone:SetDisabled(false)
    end
end