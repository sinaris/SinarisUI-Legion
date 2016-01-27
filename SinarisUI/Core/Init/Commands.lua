--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

SLASH_RELOADUI1 = '/rl'
SlashCmdList.RELOADUI = ReloadUI

----------------------------------------
-- SlashHandler
----------------------------------------
local SplitCommand = function( cmd )
	if( cmd:find( '%s' ) ) then
		return strsplit( ' ', strlower( cmd ) )
	else
		return cmd
	end
end

S['SlashHandler'] = function( arg )
	if( InCombatLockdown() ) then
		return
	end

	local Value
	local arg1, arg2 = SplitCommand( arg )

	if( arg1 == '' or arg1 == nil ) then
		if( ConfigUI:IsShown() ) then
			PlaySound( 'AchievementMenuOpen' )
			ConfigUI:Hide()
		else
			PlaySound( 'AchievementMenuClose' )
			ConfigUI:Show()
		end
	elseif( arg1 == 'tut' or arg1 == 'tutorial' ) then
		S['Installation_Instructions']()
	elseif( arg1 == 'rs' or arg1 == 'reset' ) then
		if( arg2 ) then
			if( arg2 == 'all' ) then
				Value = 'All'

				sCoreDB = nil
				sCoreCDB = nil
				S['Print']( 'Red', 'Reset Account and Character DataBase\nPlease reload the UI' )
				ReloadUI()
			elseif( arg2 == 'character' ) then
				Value = 'Character'

				sCoreCDB = nil
				S['Print']( 'Red', 'Reset Character DataBase\nPlease reload the UI' )
				ReloadUI()
			end
			S['Installation_Reset']( Value )

			S['Print']( 'Blue', 'Please reload ui to apply settings' )
		end
	elseif( arg1 == 'dt' or arg1 == 'datatext' ) then
		if( arg2 ) then
			if( arg2 == 'reset' ) then
				S['DataTexts']:Reset()
			elseif( arg2 == 'resetgold' ) then
				S['DataTexts']:ResetGold()
			end
		else
			S['DataTexts']:ToggleDataPositions()
		end
	end
end

SLASH_ACPSLASHHANDLER1 = '/acp'
SLASH_ACPSLASHHANDLER2 = '/gui'
SlashCmdList['ACPSLASHHANDLER'] = S['SlashHandler']
