--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local max, min = math.max, math.min
local match = string.match

local OnLogon = CreateFrame("Frame")
OnLogon:RegisterEvent("PLAYER_LOGIN")
OnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_LOGIN")

	if S['ScreenWidth'] < 1024 and GetCVar("gxMonitor") == "0" then
		SetCVar("useuiscale", 0)
		print( 'POPUP_DISABLE_UI' )
	else
		SetCVar("useuiscale", 1)

		if S['UIScale'] > 1.28 then S['UIScale'] = 1.28 end
		if S['UIScale'] < 0.64 then S['UIScale'] = 0.64 end

		-- Set our uiscale
		SetCVar("uiscale", S['UIScale'])

		-- Hack for 4K and WQHD Resolution
		local customScale = min( 2, max( 0.64, 768 / match( S['ScreenResolution'], "%d+x(%d+)" ) ) )
		if customScale < 0.64 then
			UIParent:SetScale(customScale)
		elseif customScale < 0.64 then
			UIParent:SetScale(S['UIScale'])
		end
	end
end )
