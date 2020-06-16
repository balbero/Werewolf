local Type, Version = "TimerZone", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent


local timeLeft = 0;
local timerTimeOut = 0;

local function Frame_UpdateTimer(frame)
	local elapsed = GetTime() - timeLeft
	local self = frame.obj
    if elapsed < timerTimeOut then --Timeout!
        self.timeoutBar.text:SetText("Time Left: "..ceil(timerTimeOut - elapsed)) 
        self.timeoutBar:SetValue(timerTimeOut - elapsed)
    else
		self.timeoutBar:SetValue(0)
		
        self:Fire("TimerEnds")
    end
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetWidth(400)
		self:SetHeight(50)
		self:SetLabel("")
		self.isVisible = false
		timeLeft = GetTime()
	end,

	["ResetTimer"] = function(self)
		timeLeft = GetTime()
	end, 

	-- ["OnRelease"] = nil,

	["SetLabel"] = function(self,msg)
		self.label:SetText(msg)
	end,

	["SetTimeOut"] = function(self,timeOut)
		timerTimeOut = timeOut
		self.timeoutBar:SetMinMaxValues(0, timeOut)
	end,

	["IsTimerVisible"] = function(self)
		return self.isVisible
	end,

	["OnWidthSet"] = function(self, width)
		local content = self.timeoutBar
		local contentwidth = width - 100
		if contentwidth < 0 then
			contentwidth = 0
		end
		content:SetWidth(contentwidth)
		content.width = contentwidth
	end,

	["LayoutFinished"] = function(self, width, height)
		if self.noAutoHeight then return end
		self:SetHeight((height or 0) + 40)
	end,

	["HideTimer"] = function(self)
		self.isVisible = false
		self.timeoutBar:Hide()
	end,

	["ShowTimer"] = function(self)
		self.isVisible = true
		self.timeoutBar:Show()
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local PaneBackdrop  = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 3, right = 3, top = 5, bottom = 3 }
}

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")
    frame:SetScript("OnUpdate", Frame_UpdateTimer);


	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetFont(GameFontNormal:GetFont(), 18)
    label:SetJustifyH("CENTER")
    label:SetJustifyV("TOP")
    label:SetPoint("CENTER",frame, "CENTER", 0, 10)
    label:SetHeight(25)
    
	local timeoutBar = CreateFrame("StatusBar", nil, frame, "TextStatusBar")
	timeoutBar:ClearAllPoints()
    timeoutBar:SetSize(300, 20)
    timeoutBar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 50, 2)
    timeoutBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    timeoutBar:SetStatusBarColor(0.1, 0, 0.6, 0.8) -- grey
    timeoutBar:SetMinMaxValues(0, timerTimeOut)

    timeoutBar.text = timeoutBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    timeoutBar.text:SetPoint("CENTER", timeoutBar)
    timeoutBar.text:SetTextColor(1,1,1)
    timeoutBar.text:SetText("")	

	local widget = {
		frame     = frame,
		label 	  = label,
		timeoutBar = timeoutBar,
		type      = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
