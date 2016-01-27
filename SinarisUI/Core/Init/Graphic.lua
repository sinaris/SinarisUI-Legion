--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local min, max = math.min, math.max
local GetCVar = GetCVar

local UIScale

S['PixelPerfect'] = function()
	UIScale = min( 2, max( 0.64, 768 / string.match( GetCVar( 'gxResolution' ), '%d+x(%d+)' ) ) )

	S['UIScale'] = UIScale
end
S['PixelPerfect']()

local Mult = 768 / string.match( GetCVar( 'gxResolution' ), '%d+x(%d+)' ) / S['UIScale']

local function Scale( x )
	return Mult * math.floor( x / Mult + 0.5 )
end

S['Scale'] = function( x )
	return Scale( x )
end

S['Mult'] = Mult
