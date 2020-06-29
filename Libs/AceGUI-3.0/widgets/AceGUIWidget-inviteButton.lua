--[[-----------------------------------------------------------------------------
Button Widget
Graphical Button.
-------------------------------------------------------------------------------]]
local Type, Version = "InviteButton", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local _G = _G
local PlaySound, CreateFrame, UIParent = PlaySound, CreateFrame, UIParent

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Button_OnClick(frame, ...)
	AceGUI:ClearFocus()
	PlaySound(852) -- SOUNDKIT.IG_MAINMENU_OPTION
	
	frame.obj:Fire("OnClick", ...)
end

local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- restore default values
		self:SetHeight(24)
		self:SetWidth(300)
		self:SetDisabled(false)
		self:SetAutoWidth(false)
		self:SetText()
		self:SetLabel()
		self:SetFontObject()
	end,

	-- ["OnRelease"] = nil,
	["SetLabel"] = function(self, text)
		self.label:SetText(text)
	end,
	["GetLabel"] = function(self)
		return self.label:GetText()
	end,
	
	["SetFont"] = function(self, font, height, flags)
		self.label:SetFont(font, height, flags)
	end,

	["SetFontObject"] = function(self, font)
		self:SetFont((font or GameFontHighlightSmall):GetFont())
	end,
	
	["SetJustifyH"] = function(self, justifyH)
		self.label:SetJustifyH(justifyH)
	end,

	["SetJustifyV"] = function(self, justifyV)
		self.label:SetJustifyV(justifyV)
	end,

	["SetLabelColor"] = function(self, r, g, b)
		if not (r and g and b) then
			r, g, b = 1, 1, 1
		end
		self.label:SetVertexColor(r, g, b)
	end,

	["SetText"] = function(self, text)
		self.text:SetText(text)
		if self.autoWidth then
			self:SetWidth(self.text:GetStringWidth() + 30)
		end
	end,

	["SetAutoWidth"] = function(self, autoWidth)
		self.autoWidth = autoWidth
		if self.autoWidth then
			self:SetWidth(self.text:GetStringWidth() + 30)
		end
	end,

	["HideButton"] = function(self)
		self.frameBtn:Hide()
	end,
	
	["ShowButton"] = function(self)
		self.frameBtn:Show()
		self.frameBtn:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -5, -1)
		self.frameBtn:SetWidth(100)
		self.frameBtn:SetHeight(24)
		self.button:SetHeight(20)
		self.button:SetWidth(90)
		self.button:SetPoint("TOPRIGHT", self.frameBtn, "TOPRIGHT", -5, -2)
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.label:SetVertexColor(0, 1, 0)
			self.button:Disable()
		else
			self.button:Enable()
		end
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local label = frame:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall")
	label:SetPoint("BOTTOMLEFT")
	label:SetPoint("BOTTOMRIGHT")
	label:SetJustifyH("LEFT")
	label:SetJustifyV("TOP")
	label:SetHeight(18)

	local frameBtn = CreateFrame("Frame", nil, frame)
	frameBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -1)
	frameBtn:SetWidth(100)
	frameBtn:SetHeight(24)

	local name = "AceGUI30Button" .. AceGUI:GetNextWidgetNum(Type)
	local button = CreateFrame("Button", name, frameBtn, "UIPanelButtonTemplate")
	button:SetHeight(20)
	button:SetWidth(90)
	button:SetPoint("TOPRIGHT", frameBtn, "TOPRIGHT", -5, -2)

	button:EnableMouse(true)
	button:SetScript("OnClick", Button_OnClick)
	button:SetScript("OnEnter", Control_OnEnter)
	button:SetScript("OnLeave", Control_OnLeave)

	local text = button:GetFontString()
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 15, -1)
	text:SetPoint("BOTTOMRIGHT", -15, 1)
	text:SetJustifyV("MIDDLE")


	local widget = {
		frame = frame,
		label = label,
		frameBtn = frameBtn,
		button = button,
		text  = text,
		type  = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	button.obj = widget

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
