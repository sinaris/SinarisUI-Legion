--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

--[[
local format = string.format

local EventFrame = CreateFrame( 'Frame' )
EventFrame:RegisterEvent( 'PLAYER_ENTERING_WORLD' )
EventFrame:SetScript( 'OnEvent', function( self, event )
	if( event == 'DISPLAY_SIZE_CHANGED' ) then

	else
		local UseUIScale = GetCVar( 'useUiScale' )
		if( UseUIScale ~= '1' ) then
			SetCVar( 'useUiScale', 1 )
		end

		if( format( '%.2f', GetCVar( 'uiScale' ) ) ~= format( '%.2f', 0.64 ) ) then
			SetCVar( 'uiScale', 0.64 )
		end

		UIParent:SetScale( 0.64 )

		self:UnregisterEvent( 'PLAYER_ENTERING_WORLD' )
		self:RegisterEvent( 'DISPLAY_SIZE_CHANGED' )
	end
end )
]]--

local max, min, floor = math.max, math.min, math.floor
local match = string.match

S['PixelPerfect'] = function()
	S['UIScale'] = min( 2, max( 0.64, 768 / match( S['ScreenResolution'], "%d+x(%d+)" ) ) )
end

S['PixelPerfect']()

S['Mult'] = 768 / match( S['ScreenResolution'], "%d+x(%d+)" ) / S['UIScale']
S['Scale'] = function( x )
	return S['Mult'] * floor( x / S['Mult'] + .5 )
end
S['NoScaleMult'] = S['Mult'] * S['UIScale']
