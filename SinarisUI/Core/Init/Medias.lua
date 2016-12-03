--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

M['Colors'] = {
	['General'] = {
		['Backdrop'] = { r = 0, g = 0, b = 0, a = 1 },
		['Border'] = { r = 0.125, g = 0.125, b = 0.125, a = 1 },
		['Value'] = { r = 0.4, g = 0.4, b = 0.5, a = 1 },
		['PrimaryDataText'] = { r = 1, g = 1, b = 1, a = 1 },
		['SecondaryDataText'] = { r = 0.4, g = 0.4, b = 0.5, a = 1 },
		['Alpha'] = 0.7,
	},

	['oUF'] = {
		['disconnected'] = { 0.84, 0.75, 0.65 },
		['power'] = {
			['MANA'] = { 0.31, 0.45, 0.63 },
			['INSANITY'] = { 0.40, 0, 0.80 },
			['MAELSTROM'] = { 0, 0.50, 1 },
			['LUNAR_POWER'] = { 0.93, 0.51, 0.93 },
			['RAGE'] = { 0.69, 0.31, 0.31 },
			['FOCUS'] = { 0.71, 0.43, 0.27 },
			['ENERGY'] = { 0.65, 0.63, 0.35 },
			['RUNES'] = { 0.55, 0.57, 0.61 },
			['FURY'] = { 0.78, 0.26, 0.99 },
			['RUNIC_POWER'] = { 0, 0.82, 1 },
			['AMMOSLOT'] = { 0.80, 0.60, 0 },
			['FUEL'] = { 0, 0.55, 0.50 },
			['POWER_TYPE_STEAM'] = { 0.55, 0.57, 0.61 },
			['POWER_TYPE_PYRITE'] = { 0.60, 0.09, 0.17 },
			['ALTPOWER'] = { 0, 1, 1 },
		},
		['runes'] = {
			[1] = { 0.69, 0.31, 0.31 },
			[2] = { 0.33, 0.59, 0.33 },
			[3] = { 0.31, 0.45, 0.63 },
			[4] = { 0.84, 0.75, 0.65 },
		},
		['totems'] = {
			[1] = { 0.58, 0.23, 0.10 },
			[2] = { 0.23, 0.45, 0.13 },
			[3] = { 0.19, 0.48, 0.60 },
			[4] = { 0.42, 0.18, 0.74 },
		},
		['reaction'] = {
			[1] = { 0.8, 0.3, 0.22 },
			[2] = { 0.8, 0.3, 0.22 },
			[3] = { 0.75, 0.27, 0 },
			-- [4] = { 0.9, 0.7, 0 },
			[4] = { 0.85, 0.77, 0.36 },
			[5] = { 0, 0.6, 0.1 },
			[6] = { 0, 0.6, 0.1 },
			[7] = { 0, 0.6, 0.1 },
			[8] = { 0, 0.6, 0.1 },
		},
		['class'] = {
			['DEMONHUNTER'] = { 0.64, 0.19, 0.79 },
			['DEATHKNIGHT'] = { 0.77, 0.12, 0.23 },
			['DRUID'] = { 1, 0.49, 0.04 },
			['HUNTER'] = { 0.67, 0.83, 0.45 },
			['MAGE'] = { 0.41, 0.80, 0.94  },
			['MONK'] = { 0.33, 0.54, 0.52 },
			['PALADIN'] = { 0.96, 0.55, 0.73 },
			['PRIEST'] = { 1, 1, 1 },
			['ROGUE'] = { 1, 0.96, 0.41  },
			['SHAMAN'] = { 0.0, 0.44, 0.87 },
			['WARLOCK'] = { 0.58, 0.51, 0.79 },
			['WARRIOR'] = { 0.78, 0.61, 0.43  },
		},
	},
}

M['Fonts'] = {
	['Normal'] = [=[Interface\AddOns\SinarisUI\Medias\Fonts\Normal.ttf]=],
	['Pixel'] = [=[Interface\AddOns\SinarisUI\Medias\Fonts\Pixel.ttf]=],
}

M['Textures'] = {
	['Blank'] = [[Interface\AddOns\SinarisUI\Medias\Textures\Blank]],
	['CombatSwords'] = [[Interface\AddOns\SinarisUI\Medias\Textures\CombatSwords]],
	['Copy'] = [[Interface\AddOns\SinarisUI\Medias\Textures\Copy]],
	['Glamour'] = [[Interface\AddOns\SinarisUI\Medias\Textures\Glamour3]],
	['Gloss'] = [[Interface\AddOns\SinarisUI\Medias\Textures\Gloss]],
	['Glow'] = [[Interface\AddOns\SinarisUI\Medias\Textures\Glow]],
	['Inverted'] = [[Interface\AddOns\SinarisUI\Medias\Textures\Inverted]],
	['Mail'] = [[Interface\AddOns\SinarisUI\Medias\Textures\Mail]],
	['MasterLooter'] = [[Interface\AddOns\SinarisUI\Medias\Textures\MasterLooter]],
	['Resting'] = [[Interface\AddOns\SinarisUI\Medias\Textures\Resting]],
	['SoundLow'] = [[Interface\AddOns\SinarisUI\Medias\Textures\SoundLow]],
	['SoundMax'] = [[Interface\AddOns\SinarisUI\Medias\Textures\SoundMax]],
	['SoundMedium'] = [[Interface\AddOns\SinarisUI\Medias\Textures\SoundMedium]],
	['SoundMute'] = [[Interface\AddOns\SinarisUI\Medias\Textures\SoundMute]],
	['StatusBar'] = [[Interface\AddOns\SinarisUI\Medias\Textures\StatusBar]],
}

M['Smilies'] = {
	['Angry'] = [[Interface\AddOns\SinarisUI\Medias\Smilies\Angry]],
	['Grin'] = [[Interface\AddOns\SinarisUI\Medias\Smilies\Grin]],
	['Hmm'] = [[Interface\AddOns\SinarisUI\Medias\Smilies\Hmm]],
	['MiddleFinger'] = [[Interface\AddOns\SinarisUI\Medias\Smilies\MiddleFinger]],
	['Sad'] = [[Interface\AddOns\SinarisUI\Medias\Smilies\Sad]],
	['Surprise'] = [[Interface\AddOns\SinarisUI\Medias\Smilies\Surprise]],
	['Tongue'] = [[Interface\AddOns\SinarisUI\Medias\Smilies\Tongue]],
	['Cry'] = [[Interface\AddOns\SinarisUI\Medias\Smilies\Weepy]],
	['Wink'] = [[Interface\AddOns\SinarisUI\Medias\Smilies\Winky]],
	['Happy'] = [[Interface\AddOns\SinarisUI\Medias\Smilies\Happy]],
	['Heart'] = [[Interface\AddOns\SinarisUI\Medias\Smilies\Heart]],
	['BrokenHeart'] = [[Interface\AddOns\SinarisUI\Medias\Smilies\BrokenHeart]],
}

M['Icons'] = {
	['Exit'] = [[Interface\AddOns\SinarisUI\Medias\Icons\Exit]],
}
