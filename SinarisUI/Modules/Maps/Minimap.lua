--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local _G = _G
local floor = math.floor
local CreateFrame = CreateFrame

local Map = _G['Minimap']
local Mail = _G['MiniMapMailFrame']
local MailBorder = _G['MiniMapMailBorder']
local MailIcon = _G['MiniMapMailIcon']
local ZoomIn = _G['MinimapZoomIn']
local ZoomOut = _G['MinimapZoomOut']

local Elapsed = 0

local ZoneColors = {
	['friendly'] = { 0.1, 1.0, 0.1 },
	['sanctuary'] = { 0.41, 0.8, 0.94 },
	['arena'] = { 1.0, 0.1, 0.1 },
	['hostile'] = { 1.0, 0.1, 0.1 },
	['contested'] = { 1.0, 0.7, 0 },
	['combat'] = { 1.0, 0.1, 0.1 },
}

local DisableBlizzard = function()
	local NorthTag = _G['MinimapNorthTag']
	NorthTag:SetTexture( nil )

	local HiddenFrames = {
		MinimapCluster,
		MinimapBorder,
		MinimapBorderTop,
		MinimapZoomIn,
		MinimapZoomOut,
		MiniMapVoiceChatFrame,
		MinimapNorthTag,
		MinimapZoneTextButton,
		MiniMapTracking,
		GameTimeFrame,
		MiniMapWorldMapButton,
		MiniMapMailBorder,
		TimeManagerClockButton,
	}

	for i = 1, #HiddenFrames do
		local Frame = HiddenFrames[i]

		Frame:Kill()

		if( Frame.UnregisterAllEvents ) then
			Frame:UnregisterAllEvents()
		end
	end
end

local CreateMover = function()
	local Mover_Minimap = CreateFrame( 'Frame', 'Mover_Minimap', UIParent )
	Mover_Minimap['movingname'] = 'Mover: Minimap'
	Mover_Minimap['point'] = {
		Healer = { a1 = 'TOPLEFT', parent = 'UIParent', a2 = 'TOPLEFT', x = 23, y = -42 },
		DPS = { a1 = 'TOPLEFT', parent = 'UIParent', a2 = 'TOPLEFT', x = 23, y = -42 },
	}
	Mover_Minimap:Size( sCoreCDB['Minimap']['Minimap_Size'], sCoreCDB['Minimap']['Minimap_Size'] )
	S['CreateDragFrame']( Mover_Minimap )
end

local ApplySkin = function()
	Map:ApplyBackdrop( nil, true )
	Map:SetMaskTexture( M['Textures']['Blank'] )
	Map:SetParent( S['PetUIFrame'] )
	Map:SetInside( Mover_Minimap )
	Map:Size( sCoreCDB['Minimap']['Minimap_Size'], sCoreCDB['Minimap']['Minimap_Size'] )
	Map:SetFrameStrata( 'BACKGROUND' )
	Map:SetFrameLevel( 2 )

	Mail:ClearAllPoints()
	Mail:Point( 'TOPRIGHT', 3, 3 )
	Mail:SetFrameLevel( Map:GetFrameLevel() + 2 )

	MailBorder:Hide()

	MailIcon:SetTexture( M['Textures']['Mail'] )

	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:Point( 'TOPLEFT', Map, 'TOPLEFT', 0, 8 )
	MiniMapInstanceDifficulty:SetParent( Map )

	GarrisonLandingPageMinimapButton:ClearAllPoints()
	GarrisonLandingPageMinimapButton:Point( 'TOPLEFT', Map, 0, -4 )

	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:Point( 'TOPLEFT', Map, 'TOPLEFT', 0, 8 )
	MiniMapInstanceDifficulty:SetParent( Map )

	GuildInstanceDifficulty:ClearAllPoints()
	GuildInstanceDifficulty:Point( 'TOPLEFT', Map, 'TOPLEFT', 0, 8 )
	GuildInstanceDifficulty:SetParent( Map )

	QueueStatusMinimapButton:SetParent( Map )
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:Point( 'BOTTOMRIGHT', 0, 0 )
	QueueStatusMinimapButtonBorder:Kill()
end

local UpdateLFGTooltip = function()
	QueueStatusFrame:StripTextures()
	QueueStatusFrame:Point( 'TOPRIGHT', Map, 'BOTTOMRIGHT', 2, -5 )
	QueueStatusFrame:ApplyStyle( nil, true )
end

local ApplyColorBorder = function()
	local R, G, B, A = M['Colors']['General']['Border']['r'], M['Colors']['General']['Border']['g'], M['Colors']['General']['Border']['b'], M['Colors']['General']['Border']['a']
	local CalendarGetNumPendingInvites = CalendarGetNumPendingInvites()
	local HasNewMail = HasNewMail()

	if( CalendarGetNumPendingInvites > 0 and HasNewMail ) then
		Map['Backdrop']:SetBackdropBorderColor( 1, 0.5, 0 )
	elseif( CalendarGetNumPendingInvites > 0 and not HasNewMail ) then
		Map['Backdrop']:SetBackdropBorderColor( 1, 0.08, 0.24 )
	elseif( CalendarGetNumPendingInvites == 0 and HasNewMail ) then
		Map['Backdrop']:SetBackdropBorderColor( 0, 1, 0 )
	else
		Map['Backdrop']:SetBackdropBorderColor( R, G, B, A )
	end
end

local OnEvent = function( self, event, addon )
	if( event == 'CALENDAR_UPDATE_PENDING_INVITES' or event == 'UPDATE_PENDING_MAIL' ) then
		ApplyColorBorder()
	end
end

local AddHooks = function()
	QueueStatusFrame:HookScript( 'OnShow', UpdateLFGTooltip )
end

function GetMinimapShape()
	return 'SQUARE'
end

S['Minimap_Init'] = function()
	if( not sCoreCDB['Minimap']['Minimap_Enable'] ) then
		return
	end

	DisableBlizzard()
	CreateMover()
	ApplySkin()
	AddHooks()

	Map:SetScript( 'OnMouseWheel', function( self, Direction )
		if( Direction > 0 ) then
			ZoomIn:Click()
		elseif( Direction < 0 ) then
			ZoomOut:Click()
		end
	end )

	Map:SetScript( 'OnMouseUp', function( self, Button )
		if( Button == 'MiddleButton' or ( Button  == 'RightButton' and IsShiftKeyDown() ) ) then
			EasyMenu( S['MicroMenu'], MicroButtonsDropDown, Map, 0,  S['Scale']( -2 ), 'MENU', 2 )
		elseif( Button == 'RightButton' ) then
			ToggleDropDownMenu( nil, nil, MiniMapTrackingDropDown, Map, 0, S['Scale']( -2 ) )
		else
			Minimap_OnClick( self )
		end
	end )

	if( sCoreCDB['Minimap']['Minimap_ColorBorder'] ) then
		local EventFrame = CreateFrame( 'Frame' )
		EventFrame:RegisterEvent( 'CALENDAR_UPDATE_PENDING_INVITES' )
		EventFrame:RegisterEvent( 'UPDATE_PENDING_MAIL' )
		EventFrame:SetScript( 'OnEvent', OnEvent )
	end
end
