--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local select = select
local format = string.format

local GetAddOnMetadata, GetLocale, GetRealmName, GetCVar, GetBuildInfo = GetAddOnMetadata, GetLocale, GetRealmName, GetCVar, GetBuildInfo
local UnitName, UnitLevel, UnitClass, UnitRace, UnitFactionGroup = UnitName, UnitLevel, UnitClass, UnitRace, UnitFactionGroup

----------------------------------------
-- AddOn Informations
----------------------------------------
S['Name'] = 'SinarisUI'
S['UIName'] = S['Name'] .. '_'
S['Version'] = GetAddOnMetadata( ..., 'Version' )
S['Author'] = GetAddOnMetadata( ..., 'Author' )
S['Website'] = GetAddOnMetadata( ..., 'Website' )
S['ClientLocale'] = GetLocale()
S['Print'] = function( Color, Value )
	local MessageColor

	if( Color == 'Red' ) then
		MessageColor = '|cffad2424'
	elseif( Color == 'Lila' ) then
		MessageColor = '|cff817fc9'
	elseif( Color == 'Yellow' ) then
		MessageColor = '|cffd38d01'
	elseif( Color == 'Pink' ) then
		MessageColor = '|cffff63d3'
	elseif( Color == 'Green' ) then
		MessageColor = '|cff1daa1d'
	elseif( Color == 'Grey' ) then
		MessageColor = '|cffcccccc'
	elseif( Color == 'Gold' ) then
		MessageColor = '|cffc5b358'
	elseif( Color == 'Blue' ) then
		MessageColor = '|cff049ffe'
	else
		MessageColor = '|cffffffff'
	end

	print( format( '%s' .. S['Name'] .. '|r: ' .. Value, MessageColor ) )
end

----------------------------------------
-- Player Informations
----------------------------------------
S['MyName'] = UnitName( 'player' )
S['MyLevel'] = UnitLevel( 'player' )
S['MyClass'] = select( 2, UnitClass( 'player' ) )
S['MyRace'] = select( 2, UnitRace( 'player' ) )
S['MyFaction'] = UnitFactionGroup( 'player' )
S['MyRealm'] = GetRealmName()

----------------------------------------
-- Game
----------------------------------------
S['ScreenResolution'] = GetCVar( 'gxResolution' )
S['ScreenHeight'] = tonumber( string.match( S['ScreenResolution'], '%d+x(%d+)' ) )
S['ScreenWidth'] = tonumber( string.match( S['ScreenResolution'], '(%d+)x+%d' ) )
S['GamePatch'], S['GameBuild'], S['GameDate'], S['GameToc'] = GetBuildInfo()

----------------------------------------
-- Generel Used
----------------------------------------
--S['UIScale'] = min( 2, max( 0.64, 768 / string.match( GetCVar( 'gxResolution' ), '%d+x(%d+)' ) ) )

S['DragFrameList'] = {}

S['Dummy'] = function()
	return
end

S['TextureCoords'] = { 0.08, 0.92, 0.08, 0.92 }

S['Colors'] = ( CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS )[S.MyClass]
S['ClassColors'] = ( '|cff%02x%02x%02x' ):format( S['Colors']['r'] * 255, S['Colors']['g'] * 255, S['Colors']['b'] * 255 )

S['HiddenFrame'] = CreateFrame( 'Frame', 'HiddenFrame', UIParent )
S['HiddenFrame']:Hide()

S['PetUIFrame'] = CreateFrame( 'Frame', 'PetUIHolderFrame', UIParent, 'SecureHandlerStateTemplate' )
S['PetUIFrame']:SetAllPoints()
RegisterStateDriver( S['PetUIFrame'], 'visibility', '[petbattle] hide;show' )

----------------------------------------
-- Skinning
----------------------------------------
S['SkinningFunctions'] = {}
S['SkinningFunctions']['SinarisUI'] = {}

local EventFrame = CreateFrame( 'Frame' )
EventFrame:RegisterEvent( 'ADDON_LOADED' )
EventFrame:SetScript( 'OnEvent', function( self, event, addon )
	if( IsAddOnLoaded( 'Skinner' ) or IsAddOnLoaded( 'Aurora' ) ) then
		self:UnregisterEvent( 'ADDON_LOADED' )

		return
	end

	for _AddOn, Function in pairs( S['SkinningFunctions'] ) do
		if( type( Function ) == 'function' ) then
			if( _AddOn == addon ) then
				if( Function ) then
					Function()
				end
			end
		elseif( type( Function ) == 'table' ) then
			if( _AddOn == addon ) then
				for _, Function in pairs( S['SkinningFunctions'][_AddOn] ) do
					if( Function ) then
						Function()
					end
				end
			end
		end
	end
end )
