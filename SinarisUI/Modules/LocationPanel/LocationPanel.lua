--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local floor = math.floor
local CreateFrame = CreateFrame
local GetMinimapZoneText = GetMinimapZoneText
local GetZonePVPInfo = GetZonePVPInfo
local GetPlayerMapPosition = GetPlayerMapPosition

local ZoneColors = {
	['friendly'] = { 0.1, 1.0, 0.1 },
	['sanctuary'] = { 0.41, 0.8, 0.94 },
	['arena'] = { 1.0, 0.1, 0.1 },
	['hostile'] = { 1.0, 0.1, 0.1 },
	['contested'] = { 1.0, 0.7, 0 },
	['combat'] = { 1.0, 0.1, 0.1 },
}

local OnEvent = function( self )
	local MinimapZoneText = GetMinimapZoneText()
	local ZonePVPInfo = GetZonePVPInfo()

	self['Text']:SetText( MinimapZoneText )
	self:Width( self['Text']:GetStringWidth() + 40 )

	if( ZoneColors[ZonePVPInfo] ) then
		self['Text']:SetTextColor( ZoneColors[ZonePVPInfo][1], ZoneColors[ZonePVPInfo][2], ZoneColors[ZonePVPInfo][3] )
	else
		self['Text']:SetTextColor( 1.0, 1.0, 1.0 )
	end
end

local OnXUpdate = function( self )
	local PosX, PosY = GetPlayerMapPosition( 'player' )

	if( not PosX ) then
		PosX = 0
	end

	PosX = floor( 100 * PosX )

	self['Text']:SetText( PosX )
end

local OnYUpdate = function( self )
	local PosX, PosY = GetPlayerMapPosition( 'player' )

	if( not PosY ) then
		PosY = 0
	end

	PosY = floor( 100 * PosY )

	self['Text']:SetText( PosY )
end

local CreatePanels = function()
	local ZoneText = CreateFrame( 'Frame', 'ZoneText', S['PetUIFrame'] )
	ZoneText:Point( 'TOP', UIParent, 'TOP', 0, -3 )
	ZoneText:Size( 70, 28 )
	ZoneText:SetFrameStrata( 'BACKGROUND' )
	ZoneText:SetFrameLevel( 3 )
	ZoneText:ApplyStyle( nil, true, true )
	ZoneText:EnableMouse( true )

	local XCoords = CreateFrame( 'Frame', 'XCoords', S['PetUIFrame'] )
	XCoords:Point( 'RIGHT', ZoneText, 'LEFT', 1, 0 )
	XCoords:Size( 35, 24 )
	XCoords:SetFrameStrata( 'BACKGROUND' )
	XCoords:SetFrameLevel( 2 )
	XCoords:ApplyStyle( nil, true, true )

	local YCoords = CreateFrame( 'Frame', 'YCoords', S['PetUIFrame'] )
	YCoords:Point( 'LEFT', ZoneText, 'RIGHT', -1, 0 )
	YCoords:Size( 35, 24 )
	YCoords:SetFrameStrata( 'BACKGROUND' )
	YCoords:SetFrameLevel( 2 )
	YCoords:ApplyStyle( nil, true, true )

	ZoneText['Text'] = S['Construct_FontString']( ZoneText, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'CENTER', true )
	ZoneText['Text']:Point( 'CENTER', ZoneText, 'CENTER', 0, -1 )
	ZoneText['Text']:SetText( 'Zone' )

	XCoords['Text'] = S['Construct_FontString']( XCoords, 'OVERLAY', M['Fonts']['Normal'], 10, 'OUTLINE', 'CENTER', true )
	XCoords['Text']:Point( 'CENTER', XCoords, 'CENTER', 0, -1 )
	XCoords['Text']:SetText( 'X' )

	YCoords['Text'] = S['Construct_FontString']( YCoords, 'OVERLAY', M['Fonts']['Normal'], 10, 'OUTLINE', 'CENTER', true )
	YCoords['Text']:Point( 'CENTER', YCoords, 'CENTER', 0, -1 )
	YCoords['Text']:SetText( 'Y' )
end

S['LocationPanel_Init'] = function()
	if( not sCoreCDB['LocationPanel']['LocationPanel_Enable'] ) then
		return
	end

	CreatePanels()

	ZoneText:RegisterEvent( 'ZONE_CHANGED' )
	ZoneText:RegisterEvent( 'PLAYER_ENTERING_WORLD' )
	ZoneText:RegisterEvent( 'ZONE_CHANGED_INDOORS' )
	ZoneText:RegisterEvent( 'ZONE_CHANGED_NEW_AREA' )

	ZoneText:SetScript( 'OnEvent', OnEvent )
	XCoords:SetScript( 'OnUpdate', OnXUpdate )
	YCoords:SetScript( 'OnUpdate', OnYUpdate )
end
