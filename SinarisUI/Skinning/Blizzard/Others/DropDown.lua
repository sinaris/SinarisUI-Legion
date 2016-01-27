--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local _G = _G
local tinsert = tinsert
local hooksecurefunc = hooksecurefunc

local ChatMenus = {
	'ChatMenu',
	'EmoteMenu',
	'LanguageMenu',
	'VoiceMacroMenu',
}

local function Skinning_ApplySkin()
	for i = 1, UIDROPDOWNMENU_MAXLEVELS do
		local Backdrop = _G['DropDownList' .. i .. 'MenuBackdrop']
		if( Backdrop and not Backdrop['IsSkinned'] ) then
			Backdrop:ApplyStyle( false, true )

			Backdrop['IsSkinned'] = true
		end

		local Backdrop = _G['DropDownList' .. i .. 'Backdrop']
		if( Backdrop and not Backdrop['IsSkinned'] ) then
			Backdrop:ApplyStyle( false, true )

			Backdrop['IsSkinned'] = true
		end
	end
end

local function Others_DropDowns()
	for i = 1, getn( ChatMenus ) do
		local Menu = _G[ChatMenus[i]]
		Menu:ApplyStyle( false, true )
		Menu.SetBackdropColor = S['Dummy']
		Menu.SetBackdropBorderColor = S['Dummy']
	end

	hooksecurefunc( 'UIDropDownMenu_CreateFrames', Skinning_ApplySkin )
end

tinsert( S['SkinningFunctions']['SinarisUI'], Others_DropDowns )
