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
local CalendarGetNumPendingInvites, HasNewMail = CalendarGetNumPendingInvites, HasNewMail

local GetMinimapZoneText, GetZonePVPInfo, GetPlayerMapPosition = GetMinimapZoneText, GetZonePVPInfo, GetPlayerMapPosition

local Map = _G['Minimap']
local Mail = _G['MiniMapMailFrame']
local MailBorder = _G['MiniMapMailBorder']
local MailIcon = _G['MiniMapMailIcon']
local ZoomIn = _G['MinimapZoomIn']
local ZoomOut = _G['MinimapZoomOut']

local ZoneColors = {
	['friendly'] = { 0.1, 1.0, 0.1 },
	['sanctuary'] = { 0.41, 0.8, 0.94 },
	['arena'] = { 1.0, 0.1, 0.1 },
	['hostile'] = { 1.0, 0.1, 0.1 },
	['contested'] = { 1.0, 0.7, 0 },
	['combat'] = { 1.0, 0.1, 0.1 },
}

local Elapsed = 0

local UpdateZone = function( self )
	local PVPInfo = GetZonePVPInfo()

	if( sCoreCDB['Minimap']['Minimap_ColorZoneText'] ) then
		if( ZoneColors[PVPInfo] ) then
			MinimapZone['Text']:SetTextColor( ZoneColors[PVPInfo][1], ZoneColors[PVPInfo][2], ZoneColors[PVPInfo][3] )
		else
			MinimapZone['Text']:SetTextColor( 1.0, 1.0, 1.0 )
		end
	else
		MinimapZone['Text']:SetTextColor( 1.0, 1.0, 1.0 )
	end

	MinimapZone['Text']:SetText( GetMinimapZoneText() )
end

local UpdateCoords = function( self, t )
	Elapsed = Elapsed - t

	if( Elapsed > 0 ) then
		return
	end

	local X, Y = GetPlayerMapPosition( 'player' )
	local XText, YText

	X = floor( 100 * X )
	Y = floor( 100 * Y )

	if( X == 0 and Y == 0 ) then
		MinimapCoords['Text']:SetText( 'X _ X' )
	else
		if( X < 10 ) then
			XText = '0' .. X
		else
			XText = X
		end

		if( Y < 10 ) then
			YText = '0' .. Y
		else
			YText = Y
		end

		MinimapCoords['Text']:SetText( XText .. ', ' .. YText )
	end

	Elapsed = 0.5
end

local DisableBlizzard = function()
	local NorthTag = _G['MinimapNorthTag']
	NorthTag:SetTexture( nil )

	local Frames = {
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

	for i = 1, #Frames do
		local Frame = Frames[i]
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
		['Healer'] = { a1 = 'TOPLEFT', parent = 'UIParent', a2 = 'TOPLEFT', x = 25, y = -44 },
		['DPS'] = { a1 = 'TOPLEFT', parent = 'UIParent', a2 = 'TOPLEFT', x = 25, y = -44 },
	}
	Mover_Minimap:Size( sCoreCDB['Minimap']['Minimap_Size'], sCoreCDB['Minimap']['Minimap_Size'] )
	S['CreateDragFrame']( Mover_Minimap )
end

local CreateFrames = function()
	local MinimapLineV = CreateFrame( 'Frame', 'MinimapLineV', UIParent )
	MinimapLineV:Point( 'TOPLEFT', UIParent, 'TOPLEFT', 12, -31 )
	MinimapLineV:Size( 2, 230 )
	MinimapLineV:SetFrameStrata( 'BACKGROUND' )
	MinimapLineV:SetFrameLevel( 1 )
	MinimapLineV:ApplyStyle()

	local MinimapLineH = CreateFrame( 'Frame', 'MinimapLineH', UIParent )
	MinimapLineH:Point( 'TOPLEFT', MinimapLineV, 'TOPLEFT', 0, 0 )
	MinimapLineH:Size( 230, 2 )
	MinimapLineH:SetFrameStrata( 'BACKGROUND' )
	MinimapLineH:SetFrameLevel( 1 )
	MinimapLineH:ApplyStyle()

	local MinimapCubeV = CreateFrame( 'Frame', 'MinimapCubeV', UIParent )
	MinimapCubeV:Point( 'TOP', MinimapLineV, 'BOTTOM', 0, 0 )
	MinimapCubeV:Size( 10, 10 )
	MinimapCubeV:SetFrameStrata( 'BACKGROUND' )
	MinimapCubeV:SetFrameLevel( 1 )
	MinimapCubeV:ApplyStyle()

	local MinimapCubeH = CreateFrame( 'Frame', 'MinimapCubeH', UIParent )
	MinimapCubeH:Point( 'LEFT', MinimapLineH, 'RIGHT', 0, 0 )
	MinimapCubeH:Size( 10, 10 )
	MinimapCubeH:SetFrameStrata( 'BACKGROUND' )
	MinimapCubeH:SetFrameLevel( 1 )
	MinimapCubeH:ApplyStyle()

	local MinimapSmallLineLeft = CreateFrame( 'Frame', 'MinimapSmallLineLeft', UIParent )
	MinimapSmallLineLeft:Point( 'RIGHT', Map, 'LEFT', 0, 0 )
	MinimapSmallLineLeft:Size( 13, 2 )
	MinimapSmallLineLeft:SetFrameStrata( 'BACKGROUND' )
	MinimapSmallLineLeft:SetFrameLevel( 1 )
	MinimapSmallLineLeft:ApplyStyle()

	local MinimapSmallLineTop = CreateFrame( 'Frame', 'MinimapSmallLineTop', UIParent )
	MinimapSmallLineTop:Point( 'BOTTOM', Map, 'TOP', 0, 0 )
	MinimapSmallLineTop:Size( 2, 13 )
	MinimapSmallLineTop:SetFrameStrata( 'BACKGROUND' )
	MinimapSmallLineTop:SetFrameLevel( 1 )
	MinimapSmallLineTop:ApplyStyle()
end

local CreateZoneCoords = function()
	if( sCoreCDB['Minimap']['Minimap_ZoneText'] ) then
		local MinimapZone = CreateFrame( 'Frame', 'MinimapZone', Map )
		MinimapZone:Point( 'TOP', Map, 'TOP', 0, -2 )
		MinimapZone:Size( Map:GetWidth() - 8, 22 )
		MinimapZone:SetFrameStrata( Map:GetFrameStrata() )
		MinimapZone:ApplyStyle( false, true )
		MinimapZone:SetAlpha( 0 )

		MinimapZone['Text'] = S['Construct_FontString']( MinimapZone, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'CENTER', true )
		MinimapZone['Text']:Point( 'CENTER', MinimapZone, 'CENTER', 0, 0 )
		MinimapZone['Text']:SetText( '' )

		MinimapZone:RegisterEvent( 'PLAYER_ENTERING_WORLD' )
		MinimapZone:RegisterEvent( 'ZONE_CHANGED_NEW_AREA' )
		MinimapZone:RegisterEvent( 'ZONE_CHANGED' )
		MinimapZone:RegisterEvent( 'ZONE_CHANGED_INDOORS' )
		MinimapZone:SetScript( 'OnEvent', UpdateZone )
	end

	if( sCoreCDB['Minimap']['Minimap_PlayerCoords'] ) then
		local MinimapCoords = CreateFrame( 'Frame', 'MinimapCoords', Map )
		MinimapCoords:Point( 'BOTTOMLEFT', Map, 'BOTTOMLEFT', 2, 2 )
		MinimapCoords:Size( 48, 22 )
		MinimapCoords:SetFrameStrata( Map:GetFrameStrata() )
		MinimapCoords:ApplyStyle( false, true )
		MinimapCoords:SetAlpha( 0 )

		MinimapCoords['Text'] = S['Construct_FontString']( MinimapCoords, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'CENTER', true )
		MinimapCoords['Text']:Point( 'CENTER', MinimapCoords, 'CENTER', 0, 0 )
		MinimapCoords['Text']:SetText( '' )

		MinimapCoords:SetScript( 'OnUpdate', UpdateCoords )
	end
end

local UpdateLFGTooltip = function()
	QueueStatusFrame:StripTextures()
	QueueStatusFrame:ClearAllPoints()
	QueueStatusFrame:Point( 'TOPLEFT', Map, 'BOTTOMLEFT', -2, -6 )
	QueueStatusFrame:ApplyStyle( nil, true )
end

local ApplySkin = function()
	Map:ApplyBackdrop( nil, true )
	Map['Backdrop']:SetFrameStrata( 'BACKGROUND' )
	Map['Backdrop']:SetFrameLevel( 1 )
	Map:SetMaskTexture( M['Textures']['Blank'] )
	Map:SetParent( S['PetUIFrame'] )
	Map:SetInside( Mover_Minimap )
	Map:Size( sCoreCDB['Minimap']['Minimap_Size'], sCoreCDB['Minimap']['Minimap_Size'] )

	Mail:ClearAllPoints()
	Mail:Point( 'TOPRIGHT', Map, 'TOPRIGHT', 3, 3 )
	Mail:SetFrameLevel( Map:GetFrameLevel() + 2 )

	MailBorder:Hide()

	--MailIcon:SetTexture( M['Textures']['Mail'] )

	MiniMapInstanceDifficulty:SetParent( Map )
	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:Point( 'TOPLEFT', Map, 'TOPLEFT', 0, 8 )

	GarrisonLandingPageMinimapButton:SetParent( Map )
	GarrisonLandingPageMinimapButton:ClearAllPoints()
	GarrisonLandingPageMinimapButton:Point( 'TOPLEFT', Map, 'TOPLEFT', 0, -4 )

	MiniMapInstanceDifficulty:SetParent( Map )
	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:Point( 'TOPLEFT', Map, 'TOPLEFT', 0, 8 )

	GuildInstanceDifficulty:SetParent( Map )
	GuildInstanceDifficulty:ClearAllPoints()
	GuildInstanceDifficulty:Point( 'TOPLEFT', Map, 'TOPLEFT', 0, 8 )

	QueueStatusMinimapButton:SetParent( Map )
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:Point( 'BOTTOMRIGHT', Map, 'BOTTOMRIGHT', 0, 0 )
	QueueStatusMinimapButtonBorder:Kill()
end

local ApplyColorBorder = function()
	local CalendarGetNumPendingInvites = CalendarGetNumPendingInvites()
	local HasNewMail = HasNewMail()

	if( CalendarGetNumPendingInvites > 0 and HasNewMail ) then
		Map['Backdrop']:SetBackdropBorderColor( sCoreCDB['Minimap']['Minimap_ColorNewMailAndInvite']['r'], sCoreCDB['Minimap']['Minimap_ColorNewMailAndInvite']['g'], sCoreCDB['Minimap']['Minimap_ColorNewMailAndInvite']['b'], sCoreCDB['Minimap']['Minimap_ColorNewMailAndInvite']['a'] )
	elseif( CalendarGetNumPendingInvites > 0 and not HasNewMail ) then
		Map['Backdrop']:SetBackdropBorderColor( sCoreCDB['Minimap']['Minimap_ColorNewInvite']['r'], sCoreCDB['Minimap']['Minimap_ColorNewInvite']['g'], sCoreCDB['Minimap']['Minimap_ColorNewInvite']['b'], sCoreCDB['Minimap']['Minimap_ColorNewInvite']['a'] )
	elseif( CalendarGetNumPendingInvites == 0 and HasNewMail ) then
		Map['Backdrop']:SetBackdropBorderColor( sCoreCDB['Minimap']['Minimap_ColorNewMail']['r'], sCoreCDB['Minimap']['Minimap_ColorNewMail']['g'], sCoreCDB['Minimap']['Minimap_ColorNewMail']['b'], sCoreCDB['Minimap']['Minimap_ColorNewMail']['a'] )
	else
		Map['Backdrop']:SetBackdropBorderColor( M['Colors']['General']['Border']['r'], M['Colors']['General']['Border']['g'], M['Colors']['General']['Border']['b'], M['Colors']['General']['Border']['a'] )
	end
end

local OnMouseOver = function()
	Map:SetScript( 'OnEnter', function()
		if( sCoreCDB['Minimap']['Minimap_ZoneText'] ) then
			MinimapZone:FadeIn()
		end

		if( sCoreCDB['Minimap']['Minimap_PlayerCoords'] ) then
			MinimapCoords:FadeIn()
		end
	end )

	Map:SetScript( 'OnLeave', function()
		if( sCoreCDB['Minimap']['Minimap_ZoneText'] ) then
			MinimapZone:FadeOut()
		end

		if( sCoreCDB['Minimap']['Minimap_PlayerCoords'] ) then
			MinimapCoords:FadeOut()
		end
	end )
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
	CreateFrames()
	ApplySkin()
	CreateZoneCoords()
	OnMouseOver()
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
			EasyMenu( S['MicroMenu'], MicroButtonsDropDown, Map, S['Scale']( -2 ), S['Scale']( -6 ), 'MENU', 2 )
		elseif( Button == 'RightButton' ) then
			ToggleDropDownMenu( nil, nil, MiniMapTrackingDropDown, Map, S['Scale']( -2 ), S['Scale']( -6 ) )
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

S['Minimap_UpdateSize'] = function()
	Mover_Minimap:Size( sCoreCDB['Minimap']['Minimap_Size'], sCoreCDB['Minimap']['Minimap_Size'] )
	Map:SetInside( Mover_Minimap )
	Map:Size( sCoreCDB['Minimap']['Minimap_Size'], sCoreCDB['Minimap']['Minimap_Size'] )

	Minimap_ZoomIn()
	Minimap_ZoomOut()
end
