if not WereWolf.IsCorrectVersion() then
    return
end

-- blizz API
local CreateFrame, UIParent = CreateFrame, UIParent


local WereWolf = WereWolf
local L = WereWolf.L
local Comm = WereWolf.Comm

local timerFrame = nil;
local timeLeft = 0;
local timerTimeOut = 0;

function WereWolf.ShowTimerFrame(msg, timeOut)
    WereWolf.printDebug(msg.." "..timeOut.."s")
    timeLeft = GetTime()
    if timerFrame == nil then
        timerTimeOut = timeOut
        WereWolf.CreateTimerFrame(msg, timeOut)
        WereWolf.printDebug(timerFrame)
    else
        if not(timerFrame:IsVisible()) then
            timerFrame.label:SetText(msg)
            timerFrame.timeoutBar:SetMinMaxValues(0, timeOut)
        end
    end
    timerFrame:Show()
    WereWolf.printDebug(timerFrame:IsVisible())
end

local FrameBackdrop = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 3, right = 3, top = 5, bottom = 3 }
}

function WereWolf.CreateTimerFrame(msg, timeOut)
	timerFrame = CreateFrame("Frame", nil, UIParent)
    timerFrame:ClearAllPoints()
	timerFrame:Hide()

	timerFrame:EnableMouse(true)
	timerFrame:SetMovable(true)
	timerFrame:SetFrameStrata("FULLSCREEN_DIALOG")
	timerFrame:SetBackdrop(FrameBackdrop)
	timerFrame:SetBackdropColor(0, 0, 0, 1)
	timerFrame:SetWidth(400)
	timerFrame:SetHeight(100)
    timerFrame:SetToplevel(true)
    timerFrame:SetPoint("CENTER")


    local label = timerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    label:SetText(msg)
    label:SetJustifyH("LEFT")
    label:SetJustifyV("TOP")
    label:SetAllPoints()
    label:SetPoint("CENTER",timerFrame, "CENTER", 0, 10)
    label:SetHeight(18)
    
    local timeoutBar = CreateFrame("StatusBar", nil, timerFrame, "TextStatusBar")
    timeoutBar:SetSize(300, 20)
    timeoutBar:SetPoint("BOTTOMLEFT", 50, 20)
    timeoutBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    timeoutBar:SetStatusBarColor(0.1, 0, 0.6, 0.8) -- grey
    timeoutBar:SetMinMaxValues(0, timeOut)

    timeoutBar.text = timeoutBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    timeoutBar.text:SetPoint("CENTER", timeoutBar)
    timeoutBar.text:SetTextColor(1,1,1)
    timeoutBar.text:SetText("")

    timerFrame:SetScript("OnUpdate", WereWolf.UpdateTimer);
    timerFrame.timeoutBar = timeoutBar
    timerFrame.label = label

end

function WereWolf.TimerEnds()
    timerFrame:Hide()
    Comm:SendCommand(WereWolf.me.Name, "next_step")
end

function WereWolf.UpdateTimer()
    local elapsed = GetTime() - timeLeft
    if elapsed < timerTimeOut then --Timeout!
        timerFrame.timeoutBar.text:SetText(L["Time Left"]..": "..ceil(timerTimeOut - elapsed)) -- _G.CLOSES_IN == "Time Left" for English
        timerFrame.timeoutBar:SetValue(timerTimeOut - elapsed)
    else
        timerFrame.timeoutBar:SetValue(0)
        return WereWolf.TimerEnds()
    end
end