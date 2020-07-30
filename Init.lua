local _, core =...
local versionStringFromToc = GetAddOnMetadata("WereWolf", "Version")
local versionString = "0.0.1"

local LDBIcon = LibStub("LibDBIcon-1.0")
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")

local isDevVersion = false
local intendedWoWProject = WOW_PROJECT_MAINLINE

local CreateFrame, UnitFullName, UnitName, UnitClass = CreateFrame, UnitFullName, UnitName, UnitClass;

WereWolf = {}
WerewolfDB = WerewolfDB or {};
WereWolf.frames = {}
WereWolf.L = {}
WereWolf.normalWidth = 1.25
WereWolf.halfWidth = WereWolf.normalWidth / 2
WereWolf.doubleWidth = WereWolf.normalWidth * 2
WereWolf.me = {}
WereWolf.InvitedPlayers = {}
WereWolf.players = {}
WereWolf.currentStep = "";
WereWolf.MIN_PLAYER_COUNT = 8

WereWolf.isDevVersion = isDevVersion

core.commands = {
	["minimap"] = function()
		WereWolf.ToggleMinimap();
	end,
	["help"] = function()
		WereWolf.PrintHelp();
	end,
	["show"] = function(...)
		WereWolf.OpenOptions(tostringall(...));
	end,
};


WereWolf.versionString = versionStringFromToc
WereWolf.printPrefix = "|cff0000ffWereWolf:|r "

local tooltip_update_frame = CreateFrame("FRAME");

local Broker_WereWolf;
Broker_WereWolf = LDB:NewDataObject("WereWolf", {
  type = "launcher",
  text = "WereWolf",
  icon = "Interface\\Icons\\Ability_mount_blackdirewolf",
  OnClick = function(self, button)
    if button == 'LeftButton' then
        WereWolf.OpenOptions();
    elseif(button == 'MiddleButton') then
		WereWolf.ToggleMinimap();
    end
    WereWolf.tooltip_draw()
  end,
  OnEnter = function(self)
    local elapsed = 0;
    local delay = 1;
    tooltip_update_frame:SetScript("OnUpdate", function(self, elap)
      elapsed = elapsed + elap;
      if(elapsed > delay) then
        elapsed = 0;
        WereWolf.tooltip_draw();
      end
    end);
    GameTooltip:SetOwner(self, "ANCHOR_NONE");
    GameTooltip:SetPoint(WereWolf.getAnchors(self))
    WereWolf.tooltip_draw();
  end,
  OnLeave = function(self)
    tooltip_update_frame:SetScript("OnUpdate", nil);
    GameTooltip:Hide();
  end
});

WereWolf.prettyPrint = function(msg)
	if(#msg > 0) then
		print(WereWolf.printPrefix .. msg)
	end
end

function WereWolf.IsCorrectVersion()
    return isDevVersion or intendedWoWProject == WOW_PROJECT_ID
end

function WereWolf.printDebug(msg)
	if(isDevVersion) then
		print(msg)
	end
end

local function HandleSlashCommands(str)
	if (#str == 0) then 
		WereWolf.PrintHelp()
	else
		local args = {};
		for _,arg in pairs({string.split(' ', str)}) do
			if(#arg > 0)then
				table.insert(args, arg)
			end
		end

		local path = core.commands; -- required for updating found table.
		for id, arg in ipairs(args) do
			if (#arg > 0) then -- if string length is greater than 0.
				arg = arg:lower();			
				if (path[arg]) then
					if (type(path[arg]) == "function") then				
						-- all remaining args passed to our function!
						path[arg](select(id + 1, unpack(args))); 
						return;					
					elseif (type(path[arg]) == "table") then				
						path = path[arg]; -- another sub-table found!
					end
				else
					-- does not exist!
					WereWolf.PrintHelp();
					return;
				end
			end
		end
	end
end

function core:init(event, name)
	if(name ~= "WereWolf") then
		return
	end

	WereWolf.me = {
		id = UnitGUID("player"),
		Name = UnitFullName("player"),
		Class = select(2, UnitClass("player")),
		Role = nil,
		hasVoted = false,
		isAlive = true,
		isLover = false,
		voteNb = 0
	}

	if isDevVersion then
		WereWolf.MIN_PLAYER_COUNT = 20
		table.insert(WereWolf.players, WereWolf.me)
		local knownClass = { }
		knownClass[1] = "SHAMAN"
		knownClass[2] = "HUNTER"
		knownClass[3] = "ROGUE"
		knownClass[4] = "PRIEST"
		knownClass[5] = "PALADIN"
		knownClass[6] = "WARRIOR"
		knownClass[7] = "WARLOCK"
		knownClass[8] = "MONK"
		knownClass[9] = "DEATHKNIGHT"
		knownClass[10] = "MAGE"
		knownClass[11] = "DRUID"
		knownClass[12] = "DEMONHUNTER"
		
		for i=1,9 do
			local classIndex = math.random(#knownClass)
			local dummy = {
				id = "Dummy-"..i,
				Name = "Dummy "..i,
				Class = knownClass[classIndex],
				Role = nil,
				hasVoted = false,
				isAlive = true,
				isLover = false
			}
			table.insert(WereWolf.players, dummy)
		end
	end
	db = WerewolfDB;	
	db.minimap = db.minimap or { hide = false };
	LDBIcon:Register("WereWolf", Broker_WereWolf, db.minimap);

	SLASH_WEREWOLF1 = "/werewolf";
	SLASH_WEREWOLF2 = "/ww";
	SlashCmdList.WEREWOLF = HandleSlashCommands;

	WereWolf.prettyPrint(" version "..versionString.." loaded")
end

local eventFrame = CreateFrame("Frame");
eventFrame:RegisterEvent("ADDON_LOADED");
eventFrame:SetScript("OnEvent", core.init);