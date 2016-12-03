--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local pairs, type = pairs, type

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
		['ActionBars_Locked'] = true,
		['ActionBars_ShowMacroText'] = true,
		['ActionBars_ShowHotKeyText'] = true,
		['ActionBars_InvertedTextures'] = false,
		['ActionBars_GlossTextures'] = false,
		['ActionBars_EquipBorder'] = true,

		['ActionBars_SwitchBarOnStance'] = true,
		['ActionBars_MainBar_ButtonSize'] = 27,
		['ActionBars_MainBar_ButtonSpacing'] = 4,
		['ActionBars_PetBar_ButtonSize'] = 27,
		['ActionBars_PetBar_ButtonSpacing'] = 4,
		['ActionBars_StanceBar_ButtonSize'] = 27,
		['ActionBars_StanceBar_ButtonSpacing'] = 4,

		['ActionBars_SplitBars'] = true,

		['ActionBars_NumRightBars'] = 2,
	},

	['Auras'] = {
		['Auras_Enable'] = true,
		['Auras_Consolidate'] = false,
		['Auras_Flash'] = true,
		['Auras_FlashTimer'] = 30,
		['Auras_ClassicTimer'] = false,
		['Auras_WrapAfter'] = 15,
		['Auras_Size'] = 30,
		['Auras_WarapAfter'] = 14,
		['Auras_ColSpacing'] = 5,
		['Auras_RowSpacing'] = 73,
	},

	['ChatFrames'] = {
		['ChatFrames_Enable'] = true,
		['ChatFrames_Height'] = 198,
		['ChatFrames_Width'] = 384,
		['ChatFrames_LinesToScroll'] = 3,
		['ChatFrames_WhisperSound'] = true,
		['ChatFrames_JustifyRight'] = true,
		['ChatFrames_UseLinkColor'] = true,
		['ChatFrames_LinkBrackets'] = true,
		['ChatFrames_LinkColor'] = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 },
		['ChatFrames_Smilies'] = true,
	},

	['LocationPanel'] = {
		['LocationPanel_Enable'] = true,
	},

	['Minimap'] = {
		['Minimap_Enable'] = true,
		['Minimap_Size'] = 144,
		['Minimap_ColorBorder'] = true,
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

S['DataBase_LoadDefaults'] = function( Type )
	if( not Type ) then
		return
	end

	if( Type and Type ~= '' ) then
		sCoreCDB[Type] = nil
		sCoreCDB[Type] = {}
	end
end
