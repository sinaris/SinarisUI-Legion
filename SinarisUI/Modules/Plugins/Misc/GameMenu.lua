--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local unpack = unpack
local random = random
local date = date

local CreateFrame = CreateFrame
local PlaySound = PlaySound
local UIFrameFadeIn = UIFrameFadeIn

local UpdateElapsed = 0

local NPCTable = {
	86470, -- Pepe
	16445, -- Terky
	15552, -- Doctor Weavil
	32398, -- King Ping
	82464, -- Elekk Plushie
	72113, -- Carpe Diem
	71163, -- Unborn Val'kir
	91226, -- Graves
	54128, -- Creepy Crate
	28883, -- Frosty
	61324, -- Baby Ape
	23754, -- Murloc Costume
	34694, -- Gurgli
	54438, -- Murkablo
	85009, -- Murkidan
	68267 -- Cinder Kitten
}

local TEXTURE_STATUSBAR = M['Textures']['StatusBar']
local TEXTURE_FACTIONLOGO = 'Interface\\AddOns\\SinarisUI\\Medias\\ClassIcons\\CLASS-' .. S['MyClass']
local COLORS_CLASS = { S['Colors']['r'], S['Colors']['g'], S['Colors']['b'] }
local UI_SCREENWIDTH, UI_SCREENHEIGHT = S['ScreenWidth'], S['ScreenHeight']
local UI_NAME, UI_VERSION = S['Name'], S['Version']

local CreateTopPanel = function()
	if( not GameMenuFrame_TopPanel ) then
		local TopPanel = CreateFrame( 'Frame', '$parent_TopPanel', GameMenuFrame )
		TopPanel:Point( 'TOP', UIParent, 'TOP', 0, 0 )
		TopPanel:Width( UI_SCREENWIDTH + 6 )
		TopPanel:SetFrameLevel( 0 )
		TopPanel:ApplyStyle( true, true )

		TopPanel['Style'] = CreateFrame( 'Frame', '$parent_TopPanelStyle', GameMenuFrame )
		TopPanel['Style']:SetInside()
		TopPanel['Style']:SetFrameStrata( 'BACKGROUND' )
		TopPanel['Style']:ApplyStyle( true, true )
		TopPanel['Style']:Point( 'TOPLEFT', TopPanel, 'BOTTOMLEFT', 0, 1 )
		TopPanel['Style']:Point( 'BOTTOMRIGHT', TopPanel, 'BOTTOMRIGHT', 0, -5 )

		TopPanel['Style']['Color'] = TopPanel['Style']:CreateTexture( nil, 'ARTWORK' )
		TopPanel['Style']['Color']:SetVertexColor( unpack( COLORS_CLASS ) )
		TopPanel['Style']['Color']:SetInside()
		TopPanel['Style']['Color']:SetTexture( TEXTURE_STATUSBAR )

		TopPanel['anim'] = CreateAnimationGroup( TopPanel )
		TopPanel['anim']['height'] = TopPanel['anim']:CreateAnimation( 'Height' )
		TopPanel['anim']['height']:SetChange( UI_SCREENHEIGHT * ( 1 / 4 ) )
		TopPanel['anim']['height']:SetDuration( 1.4 )
		TopPanel['anim']['height']:SetSmoothing( 'Bounce' )

		TopPanel:SetScript( 'OnShow', function( self )
			self:SetHeight( 0 )
			self['anim']['height']:Play()
		end )

		TopPanel['FactionLogo'] = TopPanel:CreateTexture( nil, 'ARTWORK' )
		TopPanel['FactionLogo']:Point( 'CENTER', TopPanel, 'CENTER', 0, 0 )
		TopPanel['FactionLogo']:Size( 250, 250 )
		TopPanel['FactionLogo']:SetTexture( TEXTURE_FACTIONLOGO )

		TopPanel['Date'] = S['Construct_FontString']( TopPanel, 'OVERLAY', M['Fonts']['Normal'], 20, 'OUTLINE', 'LEFT', false )
		TopPanel['Date']:Point( 'RIGHT', TopPanel, 'RIGHT', -60, 0 )

		TopPanel['Time'] = S['Construct_FontString']( TopPanel, 'OVERLAY', M['Fonts']['Normal'], 26, 'OUTLINE', 'LEFT', false )
		TopPanel['Time']:Point( 'TOP', TopPanel['Date'], 'BOTTOM', 0, -2 )

		TopPanel:SetScript( 'OnUpdate', function( self, elapsed )
			UpdateElapsed = UpdateElapsed + elapsed

			if( UpdateElapsed > 0.5 ) then
				self['Date']:SetFormattedText( '%s', date( '|cff00aaff%A|r %B %d' ) )
				self['Time']:SetFormattedText( '%s', date( '%I|cff00aaff:|r%M|cff00aaff:|r%S %p' ) )

				UpdateElapsed = 0
			end
		end )
	end
end

local CreateBottomPanel = function()
	if( not GameMenuFrame_BottomPanel ) then
		local BottomPanel = CreateFrame( 'Frame', '$parent_BottomPanel', GameMenuFrame )
		BottomPanel:Point( 'BOTTOM', UIParent, 'BOTTOM', 0, 0 )
		BottomPanel:Width( UI_SCREENWIDTH + 6 )
		BottomPanel:SetFrameLevel( 0 )
		BottomPanel:ApplyStyle( true, true )

		BottomPanel['Style'] = CreateFrame( 'Frame', '$parent_BottomPanelStyle', GameMenuFrame )
		BottomPanel['Style']:SetInside()
		BottomPanel['Style']:SetFrameStrata( 'BACKGROUND' )
		BottomPanel['Style']:ApplyStyle( true, true )
		BottomPanel['Style']:Point( 'BOTTOMRIGHT', BottomPanel, 'TOPRIGHT', 0, -1 )
		BottomPanel['Style']:Point( 'TOPLEFT', BottomPanel, 'TOPLEFT', 0, 5 )

		BottomPanel['Style']['Color'] = BottomPanel['Style']:CreateTexture( nil, 'ARTWORK' )
		BottomPanel['Style']['Color']:SetVertexColor( unpack( COLORS_CLASS ) )
		BottomPanel['Style']['Color']:SetInside()
		BottomPanel['Style']['Color']:SetTexture( TEXTURE_STATUSBAR )

		BottomPanel['anim'] = CreateAnimationGroup( BottomPanel )
		BottomPanel['anim']['height'] = BottomPanel['anim']:CreateAnimation( 'Height' )
		BottomPanel['anim']['height']:SetChange( UI_SCREENHEIGHT * ( 1 / 4 ) )
		BottomPanel['anim']['height']:SetDuration( 1.4 )
		BottomPanel['anim']['height']:SetSmoothing( 'Bounce' )

		BottomPanel:SetScript( 'OnShow', function( self )
			self:SetHeight( 0 )
			self['anim']['height']:Play()
		end )

		BottomPanel['Text'] = S['Construct_FontString']( BottomPanel, 'OVERLAY', M['Fonts']['Normal'], 40, 'OUTLINE', 'CENTER', true )
		BottomPanel['Text']:Point( 'CENTER', BottomPanel, 'CENTER', 0, 0 )
		BottomPanel['Text']:SetText( '|cff00aaff' .. UI_NAME .. '|r ' .. UI_VERSION )
	end
end

local CreateModelHolder = function()
	if( not GameMenuFrame_ModelHolder ) then
		local ModelHolder = CreateFrame( 'Frame', '$parent_ModelHolder', GameMenuFrame )
		ModelHolder:Point( 'LEFT', UIParent, 'LEFT', 400, -10 )
		ModelHolder:Size( 150, 150 )

		PlayerModel = CreateFrame( 'PlayerModel', '$parent_PlayerModel', ModelHolder )
		PlayerModel:Point( 'CENTER', ModelHolder, 'CENTER', 0, 0 )
		PlayerModel:ClearModel()
		PlayerModel:SetUnit( 'player' )
		PlayerModel:SetScript( 'OnShow', function( self )
			self:SetAlpha( 0.5 )
			UIFrameFadeIn( self, 1, self:GetAlpha(), 1 )
		end )

		PlayerModel.isIdle = nil
		PlayerModel:Size( UI_SCREENWIDTH * 2, UI_SCREENHEIGHT * 2 )
		PlayerModel:SetCamDistanceScale( 5 )
		PlayerModel:SetFacing( 6.5 )
		PlayerModel:Show()
	end
end

local CreateNPCHolder = function()
	if( not GameMenuFrame_NPCHolder ) then
		local NPCHolder = CreateFrame( 'Frame', '$parent_NPCHolder', GameMenuFrame )
		NPCHolder:Point( 'RIGHT', UIParent, 'RIGHT', -400, -10 )
		NPCHolder:Size( 150, 150 )

		NPCModel = CreateFrame( 'PlayerModel', '$parent_NPCModel', NPCHolder )
		NPCModel:Point( 'CENTER', NPCHolder, 'CENTER', 0, 0 )
		NPCModel:ClearModel()
		NPCModel:SetScript( 'OnShow', function( self )
			local ID = NPCTable[random( #NPCTable )]
			self:SetCreature( ID )
			self:SetAlpha( 0.5 )
			UIFrameFadeIn( self, 1, self:GetAlpha(), 1 )
		end )

		NPCModel.isIdle = nil
		NPCModel:Size( 256, 256 )
		NPCModel:SetCamDistanceScale( 1 )
		NPCModel:SetFacing( 6 )
		NPCModel:Show()
	end
end

S['Plugin_GameMenu_Init'] = function()
	if( sCoreCDB['Plugins']['Plugins_GameMenu_Enable'] ) then
		CreateTopPanel()
		CreateBottomPanel()
		CreateModelHolder()
		CreateNPCHolder()
	end
end
