if not WereWolf.IsCorrectVersion() then return end


local AceGUI = LibStub("AceGUI-3.0")
local AceTimer = LibStub("AceTimer-3.0")

local GetNumGuildMembers, GetGuildRosterInfo = GetNumGuildMembers, GetGuildRosterInfo

local WereWolf = WereWolf
local L = WereWolf.L
local Comm = WereWolf.Comm
local invitedPlayers = WereWolf.InvitedPlayers;
local whoInvited = "";

StaticPopupDialogs["WEREWOLF_INVITE_POPUP"] = {
    text = L["%s invited you tu play Werewolf.  Are you ok?"],
    button1 = L["Play it"],
    button2 = L["Hell No"],
    OnAccept = function()
        WereWolf.SendAcceptInvite()
    end,
    OnCancel = function (_,reason)
        if reason == "timeout" or reason == "clicked" then
            WereWolf.SendRefuseInvite()
        else
            -- "override" ...?
        end;
    end,
    sound = "levelup2",
    timeout = 120,
    whileDead = true,
    hideOnEscape = true,
}

function WereWolf.ShowInvitePopup(sender)
    if whoInvited == "" then
        whoInvited = sender
        StaticPopup_Show("WEREWOLF_INVITE_POPUP", sender)
    end
end

function WereWolf.InviteList(container)
     
    local guildMembersNb = GetNumGuildMembers()
    for i=1,guildMembersNb do
        local name, _, _, _, _, _, _, _, isOnline, _, class, _, _, _, _, _, GUID = GetGuildRosterInfo(i)

        if isOnline and GUID ~= WereWolf.me.id then
            
            local playerInvite = AceGUI:Create("InviteButton")
            playerInvite:SetLabel(name)
            playerInvite:SetText(L["Invite"])    
            local color = RAID_CLASS_COLORS[class]
            playerInvite:SetLabelColor(color.r, color.g, color.b)
            playerInvite:SetCallback("OnClick", function() 
                WereWolf.StoreInvitedPeople(playerInvite, name, class, GUID) 
            end)
            playerInvite:SetPoint("TOPLEFT", container.frame, "TOPLEFT", 0, 24*i - 2 )
            playerInvite:SetWidth(250)
            container:AddChild(playerInvite)
        end
    end
end

function WereWolf.StoreInvitedPeople(playerInvite, name, class, GUID)
    playerInvite:HideButton()
    local timer = 120
    if WereWolf.isDevVersion then
        timer = 5
    end
    local timerId = AceTimer:ScheduleTimer(WereWolf.WaitAnswer, timer)
    local invitedPlayer = { Name = name,
                            Guid = GUID, 
                            HadAccepted = false,
                            inviteUI = playerInvite,
                            inviteTimer = timerId}
    table.insert(invitedPlayers, invitedPlayer)

    Comm:SendCommand(name, "werewolf_invite")
end

function WereWolf.WaitAnswer()
    local foundPlayer = nil
    local pos = 0;
    for key,value in ipairs(invitedPlayers) do
        pos = key;
        if(AceTimer:TimeLeft(value.inviteTimer) <= 0) then
            foundPlayer = value
            break
        end
    end
    
    if foundPlayer ~= nil then
        foundPlayer.inviteUI:ShowButton()
        table.remove(invitedPlayers, pos)
    end
end

function WereWolf.ManageInvites(player, response)
    local foundPlayer = nil
    local pos = 0;
    for key,value in ipairs(invitedPlayers) do
        pos = key;
        if(value.Name == player) then
            foundPlayer = value
            break
        end
    end

    if foundPlayer ~= nil then
        AceTimer:CancelTimer(foundPlayer.inviteTimer)

        if response == "ww_accept_invite" then
            foundPlayer.inviteUI:SetDisabled()
            WereWolf.AddPlayer(foundPlayer.Name)
        else
            foundPlayer.inviteUI:ShowButton()
            table.remove(invitedPlayers, pos)
        end
    end

end

function WereWolf.SendAcceptInvite()
    Comm:SendCommand(whoInvited, "ww_accept_invite")
end

function WereWolf.SendRefuseInvite()
    whoInvited = ""
    Comm:SendCommand(whoInvited, "ww_refuse_invite")
end