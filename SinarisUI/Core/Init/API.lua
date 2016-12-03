--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local _G = _G
local unpack, type, select, getmetatable, assert = unpack, type, select, getmetatable, assert

local Kill = function( self )
	if( self.IsProtected ) then
		if( self:IsProtected() ) then
			error( 'Attempted to kill a protected object: <' .. self:GetName() .. '>' )
		end
	end

	if( self.UnregisterAllEvents ) then
		self:UnregisterAllEvents()
	end

	if( self.GetScript and self:GetScript( 'OnUpdate' ) ) then
		self:SetScript( 'OnUpdate', nil )
	end

	self.Show = S['Dummy']
	self:Hide()
end

local StripTextures = function( Object, Kill )
	for index = 1, Object:GetNumRegions() do
		local Region = select( index, Object:GetRegions() )

		if( Region and region:GetObjectType() == 'Texture' ) then
			if( Kill and type( Kill ) == 'boolean' ) then
				Region:Kill()
			elseif( Region:GetDrawLayer() == Kill ) then
				Region:SetTexture( nil )
			elseif( Kill and type( Kill ) == 'string' and Region:GetTexture() ~= Kill ) then
				Region:SetTexture( nil )
			else
				Region:SetTexture( nil )
			end
		end
	end
end

local Size = function( self, Width, Height )
	self:SetSize( S['Scale']( Width ), S['Scale']( Height or Width ) )
end

local Width = function( self, Width )
	self:SetWidth( S['Scale']( Width ) )
end

local Height = function( self, Height )
	self:SetHeight( S['Scale']( Height ) )
end

local Point = function( ... )
	local Object, Arg1, Arg2, Arg3, Arg4, Arg5 = select( 1, ... )

	if( not Object ) then
		return
	end

	local Points = { Arg1, Arg2, Arg3, Arg4, Arg5 }

	for index = 1, #Points do
		if( type( Points[index] ) == 'number' ) then
			Points[index] = S['Scale']( Points[index] )
		end
	end

	Object:SetPoint( unpack( Points ) )
end

local SetInside = function( self, Anchor, xOffset, yOffset )
	if( self:GetPoint() ) then
		self:ClearAllPoints()
	end

	self:Point( 'TOPLEFT', Anchor or self:GetParent(), 'TOPLEFT', ( xOffset or 2 ), -( yOffset or 2 ) )
	self:Point( 'BOTTOMRIGHT', Anchor or self:GetParent(), 'BOTTOMRIGHT', -( xOffset or 2 ), ( yOffset or 2 ) )
end

local SetOutside = function( self, Anchor, xOffset, yOffset )
	if( self:GetPoint() ) then
		self:ClearAllPoints()
	end

	self:Point( 'TOPLEFT', Anchor or self:GetParent(), 'TOPLEFT', -( xOffset or 2 ), ( yOffset or 2 ) )
	self:Point( 'BOTTOMRIGHT', Anchor or self:GetParent(), 'BOTTOMRIGHT', ( xOffset or 2 ), -( yOffset or 2 ) )
end

local ApplyShadow = function( self )
	if( self['Shadow'] ) then
		return
	end

	local Shadow = CreateFrame( 'Frame', '$parent_Shadow', self )
	Shadow:SetFrameLevel( 1 )
	--Shadow:SetFrameStrata( self:GetFrameStrata() )
	Shadow:SetFrameStrata( 'BACKGROUND' )
	Shadow:SetOutside( self, 3, 3 )
	--Shadow:Point( 'TOPLEFT', -3, 3 )
	--Shadow:Point( 'BOTTOMLEFT', -3, -3 )
	--Shadow:Point( 'TOPRIGHT', 3, 3 )
	--Shadow:Point( 'BOTTOMRIGHT', 3, -3 )
	Shadow:SetBackdrop( {
		['edgeFile'] = M['Textures']['Glow'],
		['edgeSize'] = S['Scale']( 3 ),
		['insets'] = {
			['left'] = S['Scale']( 5 ),
			['right'] = S['Scale']( 5 ),
			['top'] = S['Scale']( 5 ),
			['bottom'] = S['Scale']( 5 )
		},
	} )
	Shadow:SetBackdropColor( 0, 0, 0, 0 )
	Shadow:SetBackdropBorderColor( 0, 0, 0, 0.8 )

	self['Shadow'] = Shadow
end

local ApplyOverlay = function( self )
	if( self['Overlay'] ) then
		return
	end

	local Overlay = self:CreateTexture( '$parent_Overlay', 'BORDER', self )
	Overlay:ClearAllPoints()
	Overlay:SetInside()
	Overlay:SetTexture( M['Textures']['Glamour'] )
	Overlay:SetVertexColor( 0.05, 0.05, 0.05, 1.0 )
	Overlay:SetDrawLayer( 'BACKGROUND', 1 )

	self['Overlay'] = Overlay
end

local ApplyStyle = function( self, Transparent, Shadow, Overlay )
	local BackdropColor = { M['Colors']['General']['Backdrop']['r'], M['Colors']['General']['Backdrop']['g'], M['Colors']['General']['Backdrop']['b'], Transparent and M['Colors']['General']['Alpha'] or 1 }
	local BorderColor = { M['Colors']['General']['Border']['r'], M['Colors']['General']['Border']['g'], M['Colors']['General']['Border']['b'], Transparent and M['Colors']['General']['Border']['a'] or 1 }
	local Backdrop = {
		['bgFile'] = M['Textures']['Blank'],
		['edgeFile'] = M['Textures']['Blank'],
		['tile'] = false,
		['tileSize'] = 0,
		['edgeSize'] = S['Mult'],
		['insets'] = {
			['left'] = -S['Mult'],
			['right'] = -S['Mult'],
			['top'] = -S['Mult'],
			['bottom'] = -S['Mult']
		},
	}

	self:SetBackdrop( Backdrop )
	self:SetBackdropColor( unpack( BackdropColor ) )
	self:SetBackdropBorderColor( unpack( BorderColor ) )

	if( Shadow ) then
		self:ApplyShadow()
	end

	if( Overlay ) then
		self:ApplyOverlay()
	end
end

local ApplyBackdrop = function( self, Transparent, Shadow, Overlay )
	if( self['Backdrop'] ) then
		return
	end

	local Backdrop = CreateFrame( 'Frame', '$parent_Backdrop' or nil, self )
	Backdrop:ApplyStyle( Transparent, Shadow, Overlay )
	Backdrop:SetOutside()

	if( self:GetFrameLevel() - 1 >= 0 ) then
		Backdrop:SetFrameLevel( self:GetFrameLevel() - 1 )
	else
		Backdrop:SetFrameLevel( 0 )
	end

	self['Backdrop'] = Backdrop
end

local FadeIn = function( self )
	UIFrameFadeIn( self, 0.4, self:GetAlpha(), 1 )
end

local FadeOut = function( self )
	UIFrameFadeOut( self, 0.8, self:GetAlpha(), 0 )
end

local ApplySkin = function( self, Theme, arg1, arg2, arg3 )
	if( Theme == 'Action' ) then
		if( self['SetHighlightTexture'] and not self['hover'] ) then
			local Hover = self:CreateTexture( 'Frame', nil, self )
			Hover:SetColorTexture( 1.0, 1.0, 1.0, 0.3 )
			Hover:SetInside()
			self['hover'] = Hover
			self:SetHighlightTexture( Hover )
		end

		if( self['SetPushedTexture'] and not self['pushed'] ) then
			local Pushed = self:CreateTexture( 'Frame', nil, self )
			Pushed:SetColorTexture( 0.9, 0.8, 0.1, 0.3 )
			Pushed:SetInside()
			self['pushed'] = Pushed
			self:SetPushedTexture( Pushed )
		end

		if( self['SetCheckedTexture'] and not self['checked'] ) then
			local Checked = self:CreateTexture( 'Frame', nil, self )
			Checked:SetColorTexture( 0, 1.0, 0, 0.3 )
			Checked:SetInside()
			self['checked'] = Checked
			self:SetCheckedTexture( Checked )
		end

		local Cooldown = self:GetName() and _G[self:GetName() .. 'Cooldown']
		if( Cooldown ) then
			Cooldown:ClearAllPoints()
			Cooldown:SetInside()
		end
	end
end

local AddAPI = function( object )
	local Meta = getmetatable( object ).__index

	if( not object['Kill'] ) then
		Meta['Kill'] = Kill
	end

	if( not object['StripTextures'] ) then
		Meta['StripTextures'] = StripTextures
	end

	if( not object['Size'] ) then
		Meta['Size'] = Size
	end

	if( not object['Width'] ) then
		Meta['Width'] = Width
	end

	if( not object['Height'] ) then
		Meta['Height'] = Height
	end

	if( not object['Point'] ) then
		Meta['Point'] = Point
	end

	if( not object['SetInside'] ) then
		Meta['SetInside'] = SetInside
	end

	if( not object['SetOutside'] ) then
		Meta['SetOutside'] = SetOutside
	end

	if( not object['ApplyShadow'] ) then
		Meta['ApplyShadow'] = ApplyShadow
	end

	if( not object['ApplyOverlay'] ) then
		Meta['ApplyOverlay'] = ApplyOverlay
	end

	if( not object['ApplyStyle'] ) then
		Meta['ApplyStyle'] = ApplyStyle
	end

	if( not object['ApplyBackdrop'] ) then
		Meta['ApplyBackdrop'] = ApplyBackdrop
	end

	if( not object['FadeIn'] ) then
		Meta['FadeIn'] = FadeIn
	end

	if( not object['FadeOut'] ) then
		Meta['FadeOut'] = FadeOut
	end

	if( not object['ApplySkin'] ) then
		Meta['ApplySkin'] = ApplySkin
	end
end

local Handled = { ['Frame'] = true }

local Object = CreateFrame( 'Frame' )
AddAPI( Object )
AddAPI( Object:CreateTexture() )
AddAPI( Object:CreateFontString() )

Object = EnumerateFrames()

while Object do
	if( not Object:IsForbidden() and not Handled[Object:GetObjectType()] ) then
		AddAPI( Object )

		Handled[Object:GetObjectType()] = true
	end

	Object = EnumerateFrames( Object )
end
