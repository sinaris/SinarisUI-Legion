--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local select, tonumber = select, tonumber
local match = string.match
local floor = math.floor

local GetCVar = GetCVar

local Resolution = GetCurrentResolution() > 0 and select( GetCurrentResolution(), GetScreenResolutions() ) or nil
local Windowed = Display_DisplayModeDropDown:windowedmode()
local Fullscreen = Display_DisplayModeDropDown:fullscreenmode()

----------------------------------------
-- Game
----------------------------------------
S['Locale'] = GetLocale()
if( S['Locale'] == 'enGB' ) then
	S['Locale'] = 'enUS'
end

--S['UIScale'] = 0.64
S['WindowedMode'] = Windowed
S['FullscreenMode'] = Fullscreen
S['ScreenResolution'] = Resolution or ( Windowed and GetCVar( 'gxWindowedResolution' ) ) or GetCVar( 'gxFullscreenResolution' )
S['ScreenHeight'] = tonumber( match( S['ScreenResolution'], '%d+x(%d+)' ) )
S['ScreenWidth'] = tonumber( match( S['ScreenResolution'], '(%d+)x+%d' ) )

--S['Mult'] = 768 / match( S['ScreenResolution'], "%d+x(%d+)" ) / S['UIScale']
--S['Scale'] = function( x )
--	return S['Mult'] * floor( x / S['Mult'] + .5 )
--end

S['MyName'] = UnitName( 'player' )
S['MyLevel'] = UnitLevel( 'player' )
S['MyClass'] = select( 2, UnitClass( 'player' ) )
S['MyRace'] = select( 2, UnitRace( 'player' ) )
S['MyFaction'] = UnitFactionGroup( 'player' )
S['MyRealm'] = GetRealmName()
S['MySpec'] = GetSpecialization()

S['DragFrameList'] = {}

S['Dummy'] = function()
	return
end

S['TextureCoords'] = { 0.08, 0.92, 0.08, 0.92 }

S['HiddenFrame'] = CreateFrame( 'Frame', 'HiddenFrame', UIParent )
S['HiddenFrame']:Hide()

S['PetUIFrame'] = CreateFrame( 'Frame', 'PetUIFrame', UIParent, 'SecureHandlerStateTemplate' )
S['PetUIFrame']:SetAllPoints()
RegisterStateDriver( S['PetUIFrame'], 'visibility', '[petbattle] hide;show' )

S['UIName'] = 'SinarisUI'
S['UIVersion'] = GetAddOnMetadata( 'SinarisUI', 'Version' )
S['UIVersionNumber'] = tonumber( S['UIVersion'] )
S['WoWPatch'], S['WoWBuild'], S['WoWPatchReleaseDate'], S['TocVersion'] = GetBuildInfo()
S['WoWBuild'] = tonumber( S['WoWBuild'] )
