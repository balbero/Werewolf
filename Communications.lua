if not WereWolf.IsCorrectVersion() then
    return
end

local UnitIsUnit, UnitFullName, UnitName = UnitIsUnit, UnitFullName, UnitName;

local LibAceSerializer = LibStub:GetLibrary("AceSerializer-3.0")
WereWolf.Comm = LibStub("AceAddon-3.0"):NewAddon("WereWolf", "AceEvent-3.0", "AceComm-3.0")

local L = WereWolf.L

function WereWolf.Comm:OnDisable()
	self:UnregisterAllEvents()
	self:UnregisterAllComm()
end

function WereWolf.Comm:OnEnable()
	self.realmName = select(2, UnitFullName("player"))
	self.playerName = UnitName("player")

	self:RegisterComm("WereWolf", "OnCommReceived")
	self:RegisterEvent("CHAT_MSG_WHISPER",	"OnEvent")
end

function WereWolf.Comm:OnCommReceived(prefix, message, distribution, sender)
    if prefix == "WereWolf" then
        local test, command, data = LibAceSerializer:Deserialize(message);
		if test then
			WereWolf.printDebug(command)
			if command == "add_player" then
				local val = unpack(data);
				if data.id ~= WereWolf.me.id then
					WereWolf.AddPlayer(data.Name)
				end
			elseif command == "player_role" then
				local val = unpack(data);
				WereWolf.printDebug("role recieved : \n Name : "..val.Name.."\n Class : "..val.Class.."\n Icon : "..val.Icon.."\n Hint : "..val.Tips.."\n Goal : "..val.Goal)
				WereWolf.SetSpecificRoleToPlayer(WereWolf.me, val)
				WereWolf.DiscoverPlayerRole(WereWolf.me)
				WereWolf.ShowTimerFrame(L["Game starting"], 5)	
			elseif command == "set_night" then
				WereWolf.ShowTimerFrame(L["The night fall on the village and everyone fells asleep"], 10)							
			elseif command == "set_day" then
				WereWolf.ShowTimerFrame(L["The day rises again with its shinny sun and its grim discovery..."], 10)
			elseif command == "set_seer" then
				if WereWolf.me.Role.Name == "Seer" then
					-- authorize me to click twice on char portrait
					WereWolf.EnableAndAuthorizeClick(1)
				end
				WereWolf.ShowTimerFrame(L["Seer, wake up and claim the real nature of one of your fellow!"], 60)
			elseif command == "set_rogue" then
				if WereWolf.me.Role.Name == "Rogue" then
					WereWolf.DisplayRogueInterface()
				end
				WereWolf.ShowTimerFrame(L["Rogue, wake up and do your sneaky thing!"], 60)
			elseif command == "set_cupid" then
				if WereWolf.me.Role.Name == "Cupid" then
					-- authorize me to click twice on char portrait
					WereWolf.EnableAndAuthorizeClick(2)
				end
				WereWolf.ShowTimerFrame(L["Cupid, wake up and throw your arrows!"], 60)
			elseif command == "set_lover" then
				WereWolf.ShowTimerFrame(L["Lovers, wake up and face your beloved!"], 20)
			elseif command == "set_werwolves" then
				WereWolf.ShowTimerFrame(L["Werewolves, wake up and eat, eat till your hunger are filled!"], 120)
			elseif command == "set_witch" then
				WereWolf.ShowTimerFrame(L["Witch, wake up and decides with your potions!"], 60)
			elseif command == "set_vote" then
				WereWolf.ShowTimerFrame(L["Villagers vote! Point the one who killed!"], 120)
			elseif command == "next_step" then
				WereWolf.NextStep()
			elseif command == "game_ends" then
				local val = unpack(data);
				WereWolf.ShowTimerFrame(val, 10)
			elseif command == "ww_player_designated" then
				if WereWolf.currentStep == "Cupid" then
					WereWolf.me.isLover = true
				elseif WereWolf.currentStep == "Seer" then
					local player = unpack(data);
					WereWolf.DiscoverPlayerRole(player);
				elseif WereWolf.currentStep == "Vote" then
					local designatedPlayer, votedPlayer = unpack(data);
					WereWolf.ManageVote(designatedPlayer, votedPlayer)
				end
			elseif command == "werewolf_invite" then
				WereWolf.ShowInvitePopup(sender)
			elseif 	command == "ww_accept_invite" or 
					command == "ww_refuse_invite" then
				WereWolf.ManageInvite(sender, command)
			end
        end
    end
end

function WereWolf.Comm:SendCommand(target, command, ...)
	-- send all data as a table, and let receiver unpack it

	if string.find(target, "Dummy") == nil then
		
		local toSend = LibAceSerializer:Serialize(command, {...})
		if target == "group" then
			if IsInRaid() then -- Raid
				WereWolf.Comm:SendCommMessage("WereWolf", toSend, self.Utils:IsInNonInstance() and "INSTANCE_CHAT" or "RAID")
			elseif IsInGroup() then -- Party
				WereWolf.Comm:SendCommMessage("WereWolf", toSend, self.Utils:IsInNonInstance() and "INSTANCE_CHAT" or "PARTY")
			else--if self.testMode then -- Alone (testing)
				WereWolf.Comm:SendCommMessage("WereWolf", toSend, "WHISPER", self.playerName)
			end

		elseif target == "guild" then
			WereWolf.Comm:SendCommMessage("WereWolf", toSend, "GUILD")

		else
			if UnitIsUnit(target,"player") then -- If target == "player"
				WereWolf.Comm:SendCommMessage("WereWolf", toSend, "WHISPER", self.playerName)
			else
				-- We cannot send "WHISPER" to a crossrealm player
				if target:find("-") then
					if target:find(self.realmName) then -- Our own realm, just send it
						WereWolf.Comm:SendCommMessage("WereWolf", toSend, "WHISPER", target)
					else -- Get creative
						-- Remake command to be "xrealm" and put target and command in the table
						-- See "RCLootCouncil:HandleXRealmComms()" for more info
						toSend = LibAceSerializer:Serialize("xrealm", {target, command, ...})
						if GetNumGroupMembers() > 0 then -- We're in a group
							WereWolf.Comm:SendCommMessage("WereWolf", toSend, self.Utils:IsInNonInstance() and "INSTANCE_CHAT" or "RAID")
						else -- We're not, probably a guild verTest
							WereWolf.Comm:SendCommMessage("WereWolf", toSend, "GUILD")
						end
					end

				else -- Should also be our own realm
					self:SendCommMessage("WereWolf", toSend, "WHISPER", target)
				end
			end
		end
	end
end

function WereWolf.Comm:OnEvent(event, ...)

end