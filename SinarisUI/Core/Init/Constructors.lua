--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local unpack = unpack
local CreateFrame = CreateFrame

S['Construct_FontString'] = function( Parent, Layer, Type, Size, Style, JustifyH, Shadow )
	local FontString = Parent:CreateFontString( nil, Layer or 'OVERLAY' )
	FontString:SetFont( Type, Size, Style )
	FontString:SetJustifyH( JustifyH or 'CENTER' )

	if( Shadow ) then
		FontString:SetShadowColor( 0, 0, 0 )
		FontString:SetShadowOffset( S['Mult'], -S['Mult'] )
	end

	return FontString
end

S['Construct_StatusBar'] = function( Name, Parent, Texture, Color )
	local StatusBar = CreateFrame( 'StatusBar', Name or nil, Parent or UIParent )
	StatusBar:SetStatusBarTexture( Texture or M['Textures']['StatusBar'] )

	if( Color ) then
		StatusBar:SetStatusBarColor( unpack( Color ) )
	end

	return StatusBar
end

S['Construct_Texture'] = function( Parent, Name, Layer, Texture )
	if( not Parent ) then
		return
	end

	local Texture = Parent:CreateTexture( Name or nil, Layer or 'OVERLAY' )
	Texture:SetTexture( Texture or M['Textures']['StatusBar'] )

	return Texture
end
