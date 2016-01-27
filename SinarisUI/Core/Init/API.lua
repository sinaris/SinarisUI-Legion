--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

-- Cache global variables
-- Lua functions
local _G = _G
local getmetatable, select, type, unpack = getmetatable, select, type, unpack

-- WoW API / Variables
local CreateFrame = CreateFrame
local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut

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

local StripTextures = function( self, Kill )
	for i = 1, self:GetNumRegions() do
		local Region = select( i, self:GetRegions() )

		if( Region:GetObjectType() == 'Texture' ) then
			if( Kill ) then
				Region:Kill()
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

	for i = 1, #Points do
		if( type( Points[i] ) == 'number' ) then
			Points[i] = S['Scale']( Points[i] )
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

	local Shadow = CreateFrame( 'Frame', nil, self )
	Shadow:SetFrameLevel( 1 )
	Shadow:SetFrameStrata( self:GetFrameStrata() )
	Shadow:Point( 'TOPLEFT', -3, 3 )
	Shadow:Point( 'BOTTOMLEFT', -3, -3 )
	Shadow:Point( 'TOPRIGHT', 3, 3 )
	Shadow:Point( 'BOTTOMRIGHT', 3, -3 )
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

	local Overlay = self:CreateTexture( self:GetName() and self:GetName() .. 'Overlay' or nil, 'BORDER', self )
	Overlay:ClearAllPoints()
	Overlay:SetInside()
	Overlay:SetTexture( M['Textures']['StatusBar'] )
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

	local Backdrop = CreateFrame( 'Frame', nil, self )
	Backdrop:ApplyStyle( Transparent, Shadow, Overlay )
	Backdrop:SetOutside()

	if( self:GetFrameLevel() - 1 >= 0 ) then
		Backdrop:SetFrameLevel( self:GetFrameLevel() - 1 )
	else
		Backdrop:SetFrameLevel( 0 )
	end

	self['Backdrop'] = Backdrop
end

local ApplySkin = function( self, Theme, arg1, arg2, arg3 )
	if( Theme == 'Action' ) then

	elseif( Theme == 'Bag' ) then

	elseif( Theme == 'Button' ) then
		if( self:GetName() ) then
			local Left = _G[self:GetName() .. 'Left']
			local Middle = _G[self:GetName() .. 'Middle']
			local Right = _G[self:GetName() .. 'Right']

			if( Left ) then
				Left:SetAlpha( 0 )
			end

			if( Middle ) then
				Middle:SetAlpha( 0 )
			end

			if( Right ) then
				Right:SetAlpha( 0 )
			end
		end

		if( self['Left'] ) then
			self['Left']:SetAlpha( 0 )
		end

		if( self['Right'] ) then
			self['Right']:SetAlpha( 0 )
		end

		if( self['Middle'] ) then
			self['Middle']:SetAlpha( 0 )
		end

		if( self['SetNormalTexture'] ) then
			self:SetNormalTexture( '' )
		end

		if( self['SetHighlightTexture'] ) then
			self:SetHighlightTexture( '' )
		end

		if( self['SetPushedTexture'] ) then
			self:SetPushedTexture( '' )
		end

		if( self['SetDisabledTexture'] ) then
			self:SetDisabledTexture( '' )
		end

		self:ApplyStyle( nil, nil, true )

		self:SetScript( 'OnEnter', function()
			self:SetBackdropColor( M['Colors']['General']['Backdrop']['r'], M['Colors']['General']['Backdrop']['g'], M['Colors']['General']['Backdrop']['b'], M['Colors']['General']['Backdrop']['a'] )
			self:SetBackdropBorderColor( M['Colors']['oUF']['Class'][S.MyClass][1], M['Colors']['oUF']['Class'][S.MyClass][2], M['Colors']['oUF']['Class'][S.MyClass][3], 1 )
		end )

		self:SetScript( 'OnLeave', function()
			self:SetBackdropColor( M['Colors']['General']['Backdrop']['r'], M['Colors']['General']['Backdrop']['g'], M['Colors']['General']['Backdrop']['b'], M['Colors']['General']['Backdrop']['a'] )
			self:SetBackdropBorderColor( M['Colors']['General']['Border']['r'], M['Colors']['General']['Border']['g'], M['Colors']['General']['Border']['b'], M['Colors']['General']['Border']['a'] )
		end )
	elseif( Theme == 'CheckBox' ) then
		self:StripTextures()

		self['Display'] = CreateFrame( 'Frame', nil, self )
		self['Display']:Size( 16, 16 )
		self['Display']:ApplyStyle()
		self['Display']:Point( 'CENTER' )

		self:SetFrameLevel( self:GetFrameLevel() + 1 )
		self['Display']:SetFrameLevel( self:GetFrameLevel() - 1 )

		local Checked = self['Display']:CreateTexture( nil, 'OVERLAY' )
		Checked:SetTexture( M['Textures']['StatusBar'] )
		Checked:SetVertexColor( 0, 0.6, 1.0 )
		Checked:SetInside( self['Display'] )
		self:SetCheckedTexture( Checked )

		local Disabled = self['Display']:CreateTexture( nil, 'OVERLAY' )
		Disabled:SetTexture( M['Textures']['StatusBar'] )
		Disabled:SetVertexColor( 0.77, 0.12, 0.23 )
		Disabled:SetInside( self['Display'] )
		self:SetDisabledTexture( Disabled )

		local Hover = self['Display']:CreateTexture(nil, 'OVERLAY')
		Hover:SetTexture( M['Textures']['StatusBar'] )
		Hover:SetVertexColor( 1.0, 1.0, 1.0, 0.3 )
		Hover:SetInside( self['Display'] )
		self:SetHighlightTexture( Hover )

		self['SetNormalTexture'] = S['Dummy']
		self['SetPushedTexture'] = S['Dummy']
		self['SetHighlightTexture'] = S['Dummy']

		local Name = self:GetName()
		local Text = self['Text'] or Name and _G[Name .. 'Text']

		if( Text ) then
			Text:ClearAllPoints()
			Text:SetFont( M['Fonts']['Normal'], 12, '' )
			Text:Point( 'LEFT', self, 'RIGHT', 0, -1 )
		end
	elseif( Theme == 'Close' ) then

	elseif( Theme == 'Edit' ) then

	elseif( Theme == 'Slider' ) then
		local Orientation = self:GetOrientation()
		local LowText = _G[self:GetName() .. 'Low']
		local HighText = _G[self:GetName() .. 'High']
		local Text = _G[self:GetName() .. 'Text']

		self:StripTextures()
		self:ApplyBackdrop()
		self['Backdrop']:SetAllPoints()

		hooksecurefunc( self, 'SetBackdrop', function( self, backdrop )
			if( backdrop ~= nil ) then
				self:SetBackdrop( nil )
			end
		end )

		self:SetThumbTexture( M['Textures']['Blank'] )
		self:GetThumbTexture():SetVertexColor( 0.3, 0.3, 0.3 )
		self:GetThumbTexture():Size( 10, 10 )

		if( Orientation == 'VERTICAL' ) then
			self:Width( 12 )
		else
			self:Height( 12 )

			for i = 1, self:GetNumRegions() do
				local Region = select( i, self:GetRegions() )
				if( Region and Region:GetObjectType() == 'FontString' ) then
					local Point, Anchor, AnchorPoint, X, Y = Region:GetPoint()

					if( AnchorPoint:find( 'BOTTOM' ) ) then
						Region:Point( Point, Anchor, AnchorPoint, X, Y - 4 )
					end
				end
			end
		end

		if( LowText ) then
			LowText:ClearAllPoints()
			LowText:Point( 'BOTTOMLEFT', 0, -18 )
			LowText:SetFont( M['Fonts']['Normal'], 12, '' )
		end

		if( HighText ) then
			HighText:ClearAllPoints()
			HighText:Point( 'BOTTOMRIGHT', 0, -18 )
			HighText:SetFont( M['Fonts']['Normal'], 12, '' )
		end

		if( Text ) then
			Text:ClearAllPoints()
			Text:Point( 'TOP', 0, 19 )
			Text:SetFont( M['Fonts']['Normal'], 12, '' )
		end
	elseif( Theme == 'Toggle' ) then
		self:StripTextures()

		self['Display'] = CreateFrame( 'Frame', nil, self )
		self['Display']:Size( 16, 16 )
		self['Display']:ApplyStyle()
		self['Display']:Point( 'CENTER' )

		self:SetFrameLevel( self:GetFrameLevel() + 1 )
		self['Display']:SetFrameLevel( self:GetFrameLevel() - 1 )

		local Normal = self['Display']:CreateTexture( nil, 'OVERLAY' )
		Normal:SetTexture( M['Textures']['StatusBar'] )
		Normal:SetVertexColor( 0.33, 0.54, 0.52, 0.5 )
		Normal:SetInside( self['Display'] )
		self:SetNormalTexture( Normal )

		local Hover = self['Display']:CreateTexture( nil, 'OVERLAY' )
		Hover:SetTexture( M['Textures']['StatusBar'] )
		Hover:SetVertexColor( 0.33, 0.54, 0.52, 1 )
		Hover:SetInside( self['Display'] )
		self:SetHighlightTexture( Hover )

		local Pushed = self['Display']:CreateTexture( nil, 'OVERLAY' )
		Pushed:SetTexture( M['Textures']['StatusBar'] )
		Pushed:SetVertexColor( 1, 1, 1, 0.3 )
		Pushed:SetInside( self['Display'] )
		self:SetPushedTexture( Pushed )

		self['SetNormalTexture'] = S['Dummy']
		self['SetPushedTexture'] = S['Dummy']
		self['SetHighlightTexture'] = S['Dummy']
	end
end

local FadeIn = function( self )
	UIFrameFadeIn( self, 0.4, self:GetAlpha(), 1 )
end

local FadeOut = function( self )
	UIFrameFadeOut( self, 0.8, self:GetAlpha(), 0 )
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

	if( not object['ApplySkin'] ) then
		Meta['ApplySkin'] = ApplySkin
	end

	if( not object['FadeIn'] ) then
		Meta['FadeIn'] = FadeIn
	end

	if( not object['FadeOut'] ) then
		Meta['FadeOut'] = FadeOut
	end
end

local Handled = { ['Frame'] = true }

local Object = CreateFrame( 'Frame' )
AddAPI( Object )
AddAPI( Object:CreateTexture() )
AddAPI( Object:CreateFontString() )

Object = EnumerateFrames()

while Object do
	if( not Handled[Object:GetObjectType()] ) then
		AddAPI( Object )

		Handled[Object:GetObjectType()] = true
	end

	Object = EnumerateFrames( Object )
end
