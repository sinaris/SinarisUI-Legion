--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local _G = _G
local gsub, match = string.gsub, string.match
local floor = math.floor
local CreateFrame = CreateFrame

local CurrentFrame = 'NONE'
local FRAME_POINTS = { 'CENTER', 'LEFT', 'RIGHT', 'TOP', 'BOTTOM', 'TOPLEFT', 'TOPRIGHT', 'BOTTOMLEFT', 'BOTTOMRIGHT' }
local role, selected

local PlaceCurrentFrame = function()
	local Frame = _G[CurrentFrame]
	local Points = sCoreCDB['FramePoints'][CurrentFrame][role]

	Frame:ClearAllPoints()
	Frame:Point( Points['a1'], _G[Points.parent], Points['a2'], Points['x'], Points['y'] )

	if( match( CurrentFrame, 'Raid' ) ) then
		Frame['DragFrame']:ClearAllPoints()
		if( match( Points['parent'], 'Raid' ) ) then
			Frame['DragFrame']:Point( Points['a1'], Points['parent']['DragFrame'], Points['a2'], Points['x'], Points['y'] )
		else
			Frame['DragFrame']:Point( Points['a1'], Frame, Points['a1'] )
		end
	end
end

local Reskinbox = function( Box, Name, Value, Anchor, X, Y )
	Box:Point( 'LEFT', Anchor, 'RIGHT', X, Y )

	Box['name'] = S['Construct_FontString']( Box, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'LEFT' )
	Box['name']:Point( 'BOTTOMLEFT', Box, 'TOPLEFT', 5, 8 )
	Box['name']:SetText( Name )

	Box:ApplySkin( 'Edit' )

	Box:SetFont( M['Fonts']['Normal'], 12, 'OUTLINE' )
	Box:SetAutoFocus( false )
	Box:SetTextInsets( 3, 0, 0, 0 )

	Box:SetScript( 'OnShow', function( self )
		if( CurrentFrame ~= 'NONE' ) then
			self:SetText( sCoreCDB['FramePoints'][CurrentFrame][role][Value] )
		else
			self:SetText( '' )
		end
	end )

	Box:SetScript( 'OnEscapePressed', function( self )
		if( CurrentFrame ~= 'NONE' ) then
			self:SetText( sCoreCDB['FramePoints'][CurrentFrame][role][Value] )
		else
			self:SetText( '' )
		end

		self:ClearFocus()
	end )

	Box:SetScript( 'OnEnterPressed', function( self )
		if( CurrentFrame ~= 'NONE' ) then
			sCoreCDB['FramePoints'][CurrentFrame][role][Value] = self:GetText()
			PlaceCurrentFrame()
		else
			self:SetText( '' )
		end

		self:ClearFocus()
	end )
end

local SpecMover = CreateFrame( 'Frame', 'MovingHandlerSpecMover', UIParent )
SpecMover:Point( 'CENTER', UIParent, 'CENTER', 0, -300 )
SpecMover:Size( 540, 140 )
SpecMover:SetFrameStrata( 'HIGH' )
SpecMover:SetFrameLevel( 30 )
SpecMover:ApplyBackdrop( true, true )
SpecMover:Hide()

SpecMover:RegisterForDrag( 'LeftButton' )
SpecMover:SetScript( 'OnDragStart', function( self )
	self:StartMoving()
end )
SpecMover:SetScript( 'OnDragStop', function( self )
	self:StopMovingOrSizing()
end )
SpecMover:SetClampedToScreen( true )
SpecMover:SetMovable( true )
SpecMover:EnableMouse( true )

SpecMover['title'] = S['Construct_FontString']( SpecMover, 'OVERLAY', M['Fonts']['Normal'], 16, 'OUTLINE', 'CENTER' )
SpecMover['title']:Point( 'TOP', SpecMover, 'TOP', 0, -2 )
SpecMover['title']:SetText( L['MovingFrames']['FrameMover'] )

SpecMover['curmode'] = S['Construct_FontString']( SpecMover, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'LEFT' )
SpecMover['curmode']:Point( 'TOPLEFT', SpecMover, 'TOPLEFT', 10, -15 )

SpecMover['curframe'] = S['Construct_FontString']( SpecMover, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'LEFT' )
SpecMover['curframe']:Point( 'TOPLEFT', SpecMover, 'TOPLEFT', 10, -30 )

SpecMover['align'] = CreateFrame( 'Frame', 'MovingHandlerSpecMoverGridFrame', SpecMover )
SpecMover['align']:SetAllPoints( UIParent )
SpecMover['align']:SetFrameStrata( 'MEDIUM' )
SpecMover['align']:SetFrameLevel( 30 )

local Width = S['ScreenWidth'] / 80
local h = floor( S['ScreenHeight'] / Width )
local w = floor( S['ScreenWidth'] / Width )

for index = 0, h do
	SpecMover['align']['vertical' .. index] = SpecMover['align']:CreateTexture( nil, 'BACKGROUND' )
	SpecMover['align']['vertical' .. index]:SetColorTexture( 0.3, 0, 0, 0.7 )
	SpecMover['align']['vertical' .. index]:Point( 'TOPLEFT', UIParent, 'TOPLEFT', 0, -Width * index + 1 )
	SpecMover['align']['vertical' .. index]:Point( 'BOTTOMRIGHT', UIParent, 'TOPRIGHT', 0, -Width * index - 1 )
end

for index = 0, w do
	SpecMover['align']['horizontal' .. index] = SpecMover['align']:CreateTexture( nil, 'BACKGROUND' )
	SpecMover['align']['horizontal' .. index]:SetColorTexture( 0.3, 0, 0, 0.7 )
	SpecMover['align']['horizontal' .. index]:Point( 'TOPLEFT', UIParent, 'TOPLEFT', Width * index - 1, 0 )
	SpecMover['align']['horizontal' .. index]:Point( 'BOTTOMRIGHT', UIParent, 'BOTTOMLEFT', Width * index + 1, 0 )
end

local Point1dropDown = CreateFrame( 'Frame', 'SpecMoverPoint1DropDown', SpecMover, 'UIDropDownMenuTemplate' )
Point1dropDown:Point( 'TOPLEFT', SpecMover, 'TOPLEFT', 0, -70 )
--Point1dropDown:ApplySkin( 'Drop' )

Point1dropDown['name'] = S['Construct_FontString']( Point1dropDown, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'LEFT' )
Point1dropDown['name']:Point( 'BOTTOMLEFT', Point1dropDown, 'TOPLEFT', 15, 5 )
Point1dropDown['name']:SetText( L['MovingFrames']['Point1'] )

UIDropDownMenu_SetWidth( Point1dropDown, 100 )
UIDropDownMenu_SetText( Point1dropDown, '' )

UIDropDownMenu_Initialize( Point1dropDown, function( self, level, menuList )
	local info = UIDropDownMenu_CreateInfo()
	for index =  1, #FRAME_POINTS do
		info['text'] = FRAME_POINTS[index]
		info['checked'] = function()
			if( CurrentFrame ~= 'NONE' ) then
				return ( sCoreCDB['FramePoints'][CurrentFrame][role]['a1'] == info['text'] )
			end
		end

		info['func'] = function( self )
			sCoreCDB['FramePoints'][CurrentFrame][role]['a1'] = FRAME_POINTS[index]
			PlaceCurrentFrame()
			UIDropDownMenu_SetSelectedName( Point1dropDown, FRAME_POINTS[index], true )
			UIDropDownMenu_SetText( Point1dropDown, FRAME_POINTS[index] )
			CloseDropDownMenus()
		end

		UIDropDownMenu_AddButton( info )
	end
end )

local ParentBox = CreateFrame( 'EditBox', 'SpecMoverParentBox', SpecMover )
ParentBox:Size( 120, 20 )
Reskinbox( ParentBox, L['MovingFrames']['AnchorFrame'], 'parent', Point1dropDown, -2, 2 )

local Point2dropDown = CreateFrame( 'Frame', 'SpecMoverPoint2dropDown', SpecMover, 'UIDropDownMenuTemplate' )
Point2dropDown:Point( 'LEFT', ParentBox, 'RIGHT', -4, -2 )
--Point2dropDown:ApplySkin( 'Drop' )

Point2dropDown['name'] = S['Construct_FontString']( Point1dropDown, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'LEFT' )
Point2dropDown['name']:Point( 'BOTTOMLEFT', Point2dropDown, 'TOPLEFT', 15, 5 )
Point2dropDown['name']:SetText( L['MovingFrames']['Point2'] )

UIDropDownMenu_SetWidth( Point2dropDown, 100 )
UIDropDownMenu_SetText( Point2dropDown, '' )

UIDropDownMenu_Initialize( Point2dropDown, function( self, level, menuList )
	local info = UIDropDownMenu_CreateInfo()
	for index =  1, #FRAME_POINTS do
		info['text'] = FRAME_POINTS[index]
		info['checked'] = function()
			if( CurrentFrame ~= 'NONE' ) then
				return ( sCoreCDB['FramePoints'][CurrentFrame][role]['a2'] == info['text'] )
			end
		end

		info['func'] = function( self )
			sCoreCDB['FramePoints'][CurrentFrame][role]['a2'] = FRAME_POINTS[index]
			PlaceCurrentFrame()
			UIDropDownMenu_SetSelectedName( Point2dropDown, FRAME_POINTS[index], true )
			UIDropDownMenu_SetText( Point2dropDown, FRAME_POINTS[index] )
			CloseDropDownMenus()
		end

		UIDropDownMenu_AddButton( info )
	end
end )

local XBox = CreateFrame( 'EditBox', 'SpecMoverXBox', SpecMover )
XBox:Size( 50, 20 )
Reskinbox( XBox, L['MovingFrames']['XOffSet'], 'x', Point2dropDown, -2, 2 )

local YBox = CreateFrame( 'EditBox', 'SpecMoverYBox', SpecMover )
YBox:Size( 50, 20 )
Reskinbox( YBox, L['MovingFrames']['YOffSet'], 'y', XBox, 10, 0 )

local DisplayCurrentFramePoint = function()
	local points = sCoreCDB['FramePoints'][CurrentFrame][role]
	UIDropDownMenu_SetText( Point1dropDown, points.a1 )
	ParentBox:SetText( points.parent )
	UIDropDownMenu_SetText( Point2dropDown, points.a2 )
	XBox:SetText( points.x )
	YBox:SetText( points.y )
end

local SpecMoverResetButton = CreateFrame( 'Button', 'SpecMoverResetButton', SpecMover )
SpecMoverResetButton:Point( 'BOTTOMLEFT', SpecMover, 'BOTTOMLEFT', 20, 10 )
SpecMoverResetButton:Size( 250, 25 )
--SpecMoverResetButton:ApplySkin( 'Button' )

SpecMoverResetButton['Title'] = S['Construct_FontString']( SpecMoverResetButton, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'CENTER' )
SpecMoverResetButton['Title']:Point( 'CENTER', SpecMoverResetButton, 'CENTER', 0, 0 )
SpecMoverResetButton['Title']:SetText( L['MovingFrames']['ResetFrame'] )

SpecMoverResetButton:SetScript( 'OnClick', function()
	if( CurrentFrame ~= 'NONE' ) then
		local frame = _G[CurrentFrame]

		sCoreCDB['FramePoints'][CurrentFrame][role]['a1'] = frame['point'][role]['a1']
		sCoreCDB['FramePoints'][CurrentFrame][role]['parent'] = frame['point'][role]['parent']
		sCoreCDB['FramePoints'][CurrentFrame][role]['a2'] = frame['point'][role]['a2']
		sCoreCDB['FramePoints'][CurrentFrame][role]['x'] = frame['point'][role]['x']
		sCoreCDB['FramePoints'][CurrentFrame][role]['y'] = frame['point'][role]['y']

		PlaceCurrentFrame()
		DisplayCurrentFramePoint()
	end
end )

S['CreateDragFrame'] = function( Frame )
	local FrameName = Frame:GetName()

	if( not sCoreCDB['FramePoints'][FrameName] ) then
		sCoreCDB['FramePoints'][FrameName] = Frame['point']
	end
	table.insert( S['DragFrameList'], Frame )

	Frame:SetMovable( true )
	Frame:SetClampedToScreen( true )

	Frame['DragFrame'] = CreateFrame( 'Frame', FrameName .. 'DragFrame', UIParent )
	Frame['DragFrame']:SetAllPoints( Frame )
	Frame['DragFrame']:SetFrameStrata( 'HIGH' )
	Frame['DragFrame']:EnableMouse( true )
	Frame['DragFrame']:RegisterForDrag( 'LeftButton' )
	Frame['DragFrame']:SetClampedToScreen( true )
	Frame['DragFrame']:SetScript( 'OnDragStart', function( self )
		Frame:StartMoving()
		self.x, self.y = Frame:GetCenter()

		if( match( FrameName, 'Raid' ) and match( sCoreCDB['FramePoints'][FrameName][role].parent, 'Raid' ) ) then
			local dfx, dfy = self:GetCenter()
			self:ClearAllPoints()
			self:Point( 'CENTER', Frame, 'CENTER', dfx - self.x, dfy - self.y )
		end
	end )

	Frame.DragFrame:SetScript( 'OnDragStop', function( self )
		Frame:StopMovingOrSizing()

		local x, y = Frame:GetCenter()
		local x1, y1 = ( '%d' ):format( x - self.x ), ( '%d' ):format( y -self.y )

		sCoreCDB['FramePoints'][FrameName][role].x = sCoreCDB['FramePoints'][FrameName][role]['x'] + x1
		sCoreCDB['FramePoints'][FrameName][role].y = sCoreCDB['FramePoints'][FrameName][role]['y'] + y1

		PlaceCurrentFrame()
		DisplayCurrentFramePoint()
	end )

	Frame['DragFrame']:ApplyStyle( true, true )
	Frame['DragFrame']:Hide()

	Frame['DragFrame']['text'] = S['Construct_FontString']( Frame['DragFrame'], 'OVERLAY', M['Fonts']['Normal'], 13, 'OUTLINE', 'CENTER' )
	Frame['DragFrame']['text']:Point( 'CENTER', Frame['DragFrame'], 'CENTER', 0, 0 )
	Frame['DragFrame']['text']:SetText( Frame['movingname'] )

	Frame['DragFrame']:SetScript( 'OnMouseDown', function()
		CurrentFrame = FrameName
		SpecMover['curframe']:SetText( L['MovingFrames']['CurrentFrame'] .. gsub( Frame['movingname'], '\n', '' ) )
		DisplayCurrentFramePoint()

		if( not selected ) then
			UIDropDownMenu_EnableDropDown( Point1dropDown )
			UIDropDownMenu_EnableDropDown( Point2dropDown ) 
			ParentBox:Enable()
			XBox:Enable()
			YBox:Enable()
			selected = true
		end

		for index = 1, #S['DragFrameList'] do
			if( S['DragFrameList'][index]:GetName() == FrameName ) then
				S['DragFrameList'][index]['DragFrame']:SetBackdropBorderColor( 0, 1, 1, 1 )
			else
				S['DragFrameList'][index]['DragFrame']:SetBackdropBorderColor( 1, 0, 0, 1 )
			end
		end
	end )
end

local UnlockAll = function()
	if( not InCombatLockdown() ) then
		if( CurrentFrame ~= 'NONE' ) then
			SpecMover['curframe']:SetText( L['MovingFrames']['CurrentFrame'] .. gsub( _G[CurrentFrame]['movingname'], '\n', '' ) )
		else
			SpecMover['curframe']:SetText( L['MovingFrames']['CurrentFrame'] .. CurrentFrame )
		end

		for index = 1, #S['DragFrameList'] do
			S['DragFrameList'][index]['DragFrame']:Show()
			S['DragFrameList'][index]['DragFrame']:SetBackdropBorderColor( 1, 0, 0, 1 )
		end

		SpecMover:Show()
	else
		SpecMover:RegisterEvent( 'PLAYER_REGEN_ENABLED' )

		S['Print']( 'Red', L['MovingFrames']['EnteringCombat'] )
	end
end

local LockAll = function()
	CurrentFrame = 'NONE'
	UIDropDownMenu_SetText( Point1dropDown, '' )
	UIDropDownMenu_SetText( Point2dropDown, '' )
	UIDropDownMenu_DisableDropDown( Point1dropDown )
	UIDropDownMenu_DisableDropDown( Point2dropDown )
	ParentBox:Disable()
	XBox:Disable()
	YBox:Disable()
	selected = false

	for index = 1, #S['DragFrameList'] do
		S['DragFrameList'][index]['DragFrame']:Hide()
		S['DragFrameList'][index]['DragFrame']:SetBackdropBorderColor( 0, 1, 1, 1 )
	end

	SpecMover:Hide()
end

local OnSpecChanged = function()
	role = S['CheckRole']()
	SpecMover['curmode']:SetText( L['MovingFrames']['CurrentMode'] .. L['MovingFrames'][role] )

	for index = 1, #S['DragFrameList'] do
		local Name = S['DragFrameList'][index]:GetName()
		local Points = sCoreCDB['FramePoints'][Name][role]

		S['DragFrameList'][index]:ClearAllPoints()
		S['DragFrameList'][index]:Point( Points['a1'], _G[Points.parent], Points['a2'], Points['x'], Points['y'] )

		if( match( Name, 'Raid' ) ) then
			S['DragFrameList'][index]['DragFrame']:ClearAllPoints()

			if( match( Points['parent'], 'Raid' ) ) then
				S['DragFrameList'][index]['DragFrame']:Point( Points['a1'], Points['parent']['DragFrame'], Points['a2'], Points['x'], Points['y'] )
			else
				S['DragFrameList'][index]['DragFrame']:Point( Points['a1'], S['DragFrameList'][index], Points['a1'] )
			end
		end
	end
end

SpecMover:SetScript( 'OnEvent', function( self, event, arg1 )
	if( InCombatLockdown() ) then
		return
	end

	if( event == 'PLAYER_SPECIALIZATION_CHANGED' and arg1 == 'player' ) then
		OnSpecChanged()
	elseif( event == 'PLAYER_REGEN_DISABLED' ) then
		if( SpecMover:IsShown() ) then
			LockAll()

			S['Print']( 'Red', L['MovingFrames']['EnteringCombat'] )
		end
	elseif( event == 'PLAYER_REGEN_ENABLED' ) then
		UnlockAll()
		self:UnregisterEvent( 'PLAYER_REGEN_ENABLED' )
	elseif( event == 'PLAYER_LOGIN' ) then
		OnSpecChanged()
		self:RegisterEvent( 'PLAYER_SPECIALIZATION_CHANGED' )
		self:RegisterEvent( 'PLAYER_REGEN_DISABLED' )
	end
end )

SpecMover:RegisterEvent( 'PLAYER_LOGIN' )

local SpecMoverLockButton = CreateFrame( 'Button', 'SpecMoverLockButton', SpecMover )
SpecMoverLockButton:Point( 'LEFT', SpecMoverResetButton, 'RIGHT', 10, 0 )
SpecMoverLockButton:Size( 250, 25 )
--SpecMoverLockButton:ApplySkin( 'Button' )

SpecMoverLockButton['Title'] = S['Construct_FontString']( SpecMoverLockButton, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'CENTER' )
SpecMoverLockButton['Title']:Point( 'CENTER', SpecMoverLockButton, 'CENTER', 0, 0 )
SpecMoverLockButton['Title']:SetText( L['MovingFrames']['LockAllFrames'] )

SpecMoverLockButton:SetScript( 'OnClick', function()
	LockAll()
end )

local IntroOptions = ConfigUIIntroFrame

local ResetPositionsButtonn = CreateFrame( 'Button', 'ResetPositionsButtonn', IntroOptions )
ResetPositionsButtonn:Point( 'BOTTOMLEFT', IntroOptions, 'BOTTOMLEFT', 40, 60 )
ResetPositionsButtonn:Size( 190, 25 )
--ResetPositionsButtonn:ApplySkin( 'Button' )

ResetPositionsButtonn['Title'] = S['Construct_FontString']( ResetPositionsButtonn, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'CENTER' )
ResetPositionsButtonn['Title']:Point( 'CENTER', ResetPositionsButtonn, 'CENTER', 0, 0 )
ResetPositionsButtonn['Title']:SetText( L['MovingFrames']['ResetAllFrames'] )

ResetPositionsButtonn:SetScript( 'OnClick', function()
	for index = 1, #S['DragFrameList'] do
		local f = S['DragFrameList'][index]
		sCoreCDB['FramePoints'][f:GetName()] = {}

		for role, points in pairs( f['point'] ) do
			sCoreCDB['FramePoints'][f:GetName()][role] = {}

			for k, v in pairs( points ) do
				sCoreCDB['FramePoints'][f:GetName()][role][k] = v
			end
		end

		CurrentFrame = f:GetName()
		PlaceCurrentFrame()
	end

	CurrentFrame = 'NONE'
end )

local UnlockFramesButton = CreateFrame( 'Button', 'UnlockFramesButton', IntroOptions )
UnlockFramesButton:Point( 'LEFT', ResetPositionsButtonn, 'RIGHT', 20, 0 )
UnlockFramesButton:Size( 190, 25 )
--UnlockFramesButton:ApplySkin( 'Button' )

UnlockFramesButton['Title'] = S['Construct_FontString']( UnlockFramesButton, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'CENTER' )
UnlockFramesButton['Title']:Point( 'CENTER', UnlockFramesButton, 'CENTER', 0, 0 )
UnlockFramesButton['Title']:SetText( L['MovingFrames']['UnlockAllFrames'] )

UnlockFramesButton:SetScript( 'OnClick', function()
	UnlockAll()

	if( ConfigUI:IsShown() ) then
		ConfigUI:Hide()
	end
	
end )
