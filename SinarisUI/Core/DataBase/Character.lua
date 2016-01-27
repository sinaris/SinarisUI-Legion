--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local CharacterDataBase = {}
CharacterDataBase = {
	['Texts'] = {},
	['FramePoints'] = {},

	['General'] = {
		['IsInstalled'] = false,
		['WelcomeMessage'] = true,
	},

	['ActionBars'] = {
		['ActionBars_Enable'] = true,
	},

	['ChatFrames'] = {
		['ChatFrames_Enable'] = true,
	},

	['Minimap'] = {
		['Minimap_Enable'] = true,
		['Minimap_ColorBorder'] = true,
		['Minimap_ColorNewMail'] = { ['r'] = 0, ['g'] = 1.0, ['b'] = 0, ['a'] = 1 },
		['Minimap_ColorNewInvite'] = { ['r'] = 1.0, ['g'] = 0.08, ['b'] = 0.24, ['a'] = 1 },
		['Minimap_ColorNewMailAndInvite'] = { ['r'] = 1.0, ['g'] = 0.5, ['b'] = 0, ['a'] = 1 },
		['Minimap_ZoneText'] = true,
		['Minimap_ColorZoneText'] = true,
		['Minimap_PlayerCoords'] = true,
		['Minimap_Size'] = 165,
	},

	['Plugins'] = {
		['Plugins_AFKScreen_Enable'] = true,
		['Plugins_GameMenu_Enable'] = true,
	},
}

S['DataBase_SetupCharacter'] = function()
	for a, b in pairs( CharacterDataBase ) do
		if( type( b ) ~= 'table' ) then
			if( sCoreCDB[a] == nil ) then
				sCoreCDB[a] = b
			end
		else
			if( sCoreCDB[a] == nil ) then
				sCoreCDB[a] = {}
			end

			for k, v in pairs( b ) do
				if( sCoreCDB[a][k] == nil ) then
					sCoreCDB[a][k] = v
				end
			end
		end
	end
end
