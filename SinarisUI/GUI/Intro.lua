--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local date, format, split, lower = date, string.format, string.split, string.lower
local random = math.random

local UnitLevel, IsInGuild, GetGuildInfo, UnitPVPName, UnitIsAFK = UnitLevel, IsInGuild, GetGuildInfo, UnitPVPName, UnitIsAFK
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight

local CreateFrame = CreateFrame
local Name, Level, GuildName
local Class, ClassToken = UnitClass( 'player' )
local Race, RaceToken = UnitRace( 'player' )
local FactionToken, Faction = UnitFactionGroup( 'player' )
local Color = RAID_CLASS_COLORS[ClassToken]
local AddOnVersion = '|cff00aaff' .. S['Version'] .. '|r'
local AddOnTitle = '|cffff6347' .. S['Name'] .. '|r'
local Font = M['Fonts']['Normal']
local FontFlag = 'OUTLINE'
local UpdateElapsed = 0

local GUI = ConfigUI

--local EmoteTable = {
--	0, 1, 3, 4, 5, 8, 9, 10, 11, 12, 13, 14, 26, 43, 55, 56, 57, 58, 
--	60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 
--	80,81,82,83,84,87,89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 
--	100, 101, 103, 104, 105, 107, 109, 110, 113, 114, 115, 116, 117, 118, 119, 
--	120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 
--}

-- http://us.battle.net/wow/en/forum/topic/8569600188
-- local c, f = CharacterModelFrame f = AmT or CreateFrame( "EditBox","AmT",c,"InputBoxTemplate" )
-- f:SetSize(64,32)
-- f:SetPoint("BOTTOMLEFT",7,-5)
-- f:SetScript("OnEnterPressed",function(s) c:SetAnimation(s:GetText()) end)
-- f:SetAutoFocus(nil)

local IntroOptions = CreateFrame( "Frame", "ConfigUIIntroFrame", GUI )
IntroOptions:SetAllPoints( GUI )
S['GUIFunction_CreateTab']( "Intro", IntroOptions, GUI, "VERTICAL" )

IntroOptions:SetScript( "OnShow", function()
	GUI['ReloadUIButton']:Hide()
end )

IntroOptions:SetScript( "OnHide", function()
	GUI['ReloadUIButton']:Show()
end )

local function PlayerModelUpdate()
	PlayerModel:SetUnit( 'player' )
	PlayerModel:SetCamera( 0 )
end

local PlayerModel = CreateFrame( 'PlayerModel', 'PlayerModel', IntroOptions )
PlayerModel:Point( 'TOPLEFT', IntroOptions, 'TOPLEFT', 40, -110 )
PlayerModel:Size( 400, 450 )
PlayerModel:SetScript( 'OnEvent', PlayerModelUpdate )
PlayerModel:RegisterEvent( 'UNIT_PORTRAIT_UPDATE' )
PlayerModel:ApplyStyle()

PlayerModel['Title'] = S['Construct_FontString']( PlayerModel, 'OVERLAY', M['Fonts']['Normal'], 40, 'OUTLINE', 'LEFT', false )
PlayerModel['Title']:Point( 'TOPLEFT', PlayerModel, 'TOPRIGHT', 90, 0 )
PlayerModel['Title']:SetText( AddOnTitle )

PlayerModel['Version'] = S['Construct_FontString']( PlayerModel, 'OVERLAY', M['Fonts']['Normal'], 20, 'OUTLINE', 'LEFT', false )
PlayerModel['Version']:Point( 'TOP', PlayerModel['Title'], 'BOTTOM', 0, -2 )
PlayerModel['Version']:SetFormattedText( '%s %s', GAME_VERSION_LABEL, AddOnVersion )

PlayerModel['Date'] = S['Construct_FontString']( PlayerModel, 'OVERLAY', M['Fonts']['Normal'], 15, 'OUTLINE', 'LEFT', false )
PlayerModel['Date']:Point( 'TOP', PlayerModel['Version'], 'BOTTOM', 0, -50 )

PlayerModel['Time'] = S['Construct_FontString']( PlayerModel, 'OVERLAY', M['Fonts']['Normal'], 20, 'OUTLINE', 'LEFT', false )
PlayerModel['Time']:Point( 'TOP', PlayerModel['Date'], 'BOTTOM', 0, -2 )

PlayerModel['PlayerName'] = S['Construct_FontString']( PlayerModel, 'OVERLAY', M['Fonts']['Normal'], 20, 'OUTLINE', 'LEFT', false )
PlayerModel['PlayerName']:Point( 'TOP', PlayerModel['Time'], 'BOTTOM', 0, -50 )

PlayerModel['Guild'] = S['Construct_FontString']( PlayerModel, 'OVERLAY', M['Fonts']['Normal'], 15, 'OUTLINE', 'LEFT', false )
PlayerModel['Guild']:Point( 'TOP', PlayerModel['PlayerName'], 'BOTTOM', 0, -2 )

PlayerModel['PlayerInfo'] = S['Construct_FontString']( PlayerModel, 'OVERLAY', M['Fonts']['Normal'], 15, 'OUTLINE', 'LEFT', false )
PlayerModel['PlayerInfo']:Point( 'TOP', PlayerModel['Guild'], 'BOTTOM', 0, -2 )

PlayerModel:SetScript( 'OnShow', function( self )
	Level, Name, GuildName = UnitLevel( 'player' ), UnitPVPName( 'player' ), IsInGuild() and GetGuildInfo( 'player' ) or ERR_GUILDEMBLEM_NOGUILD
	self['PlayerName']:SetFormattedText( '|c%s%s|r', Color.colorStr, Name )
	self['Guild']:SetFormattedText( '|cff00aaff%s|r', GuildName )
	self['PlayerInfo']:SetFormattedText( '%s %s %s %s', LEVEL, Level, Faction, Class )
end )

PlayerModel:SetScript( 'OnUpdate', function( self, elapsed )
	UpdateElapsed = UpdateElapsed + elapsed

	if( UpdateElapsed > 0.5 ) then
		self['Time']:SetFormattedText( '%s', date( '%I|cff00aaff:|r%M|cff00AAFF:|r%S %p' ) )
		self['Date']:SetFormattedText( '%s', date( '|cff00aaff%A|r %B %d' ) )
		UpdateElapsed = 0
	end
end )
