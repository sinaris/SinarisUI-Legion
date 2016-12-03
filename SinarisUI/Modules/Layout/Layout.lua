--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

-- Cache global variables
-- Lua functions
local pairs = pairs

-- WoW API / Variables
local CreateFrame = CreateFrame
local UnitAffectingCombat = UnitAffectingCombat
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS

----------------------------------------
-- Top Panel
----------------------------------------
local CreateTopPanel = function()
	local TopPanel = CreateFrame( 'Frame', 'TopPanel', UIParent )
	TopPanel:Point( 'TOP', UIParent, 'TOP', 0, 5 )
	TopPanel:Size( S['ScreenWidth'] + 10, 23 )
	TopPanel:SetFrameStrata( 'BACKGROUND' )
	TopPanel:SetFrameLevel( 1 )
	TopPanel:ApplyStyle( false, true )
end

----------------------------------------
-- Minimap
----------------------------------------
local CreateMinimapPanels = function()
	local MinimapLineLeft = CreateFrame( 'Frame', 'MinimapLineLeft', UIParent )
	MinimapLineLeft:Point( 'TOPLEFT', UIParent, 'TOPLEFT', 12, -30 )
	MinimapLineLeft:Size( 2, 201 )
	MinimapLineLeft:SetFrameStrata( 'BACKGROUND' )
	MinimapLineLeft:SetFrameLevel( 1 )
	MinimapLineLeft:ApplyStyle()

	local MinimapLineTop = CreateFrame( 'Frame', 'MinimapLineTop', UIParent )
	MinimapLineTop:Point( 'TOPLEFT', MinimapLineLeft, 'TOPLEFT', 0, 0 )
	MinimapLineTop:Size( 182, 2 )
	MinimapLineTop:SetFrameStrata( 'BACKGROUND' )
	MinimapLineTop:SetFrameLevel( 1 )
	MinimapLineTop:ApplyStyle()

	local MinimapCubeTop = CreateFrame( 'Frame', 'MinimapCubeTop', UIParent )
	MinimapCubeTop:Point( 'LEFT', MinimapLineTop, 'RIGHT', 0, 0 )
	MinimapCubeTop:Size( 10, 10 )
	MinimapCubeTop:SetFrameStrata( 'BACKGROUND' )
	MinimapCubeTop:SetFrameLevel( 1 )
	MinimapCubeTop:ApplyStyle()

	local MinimapCubeLeft = CreateFrame( 'Frame', 'MinimapCubeLeft', UIParent )
	MinimapCubeLeft:Point( 'TOP', MinimapLineLeft, 'BOTTOM', 0, 0 )
	MinimapCubeLeft:Size( 10, 10 )
	MinimapCubeLeft:SetFrameStrata( 'BACKGROUND' )
	MinimapCubeLeft:SetFrameLevel( 1 )
	MinimapCubeLeft:ApplyStyle()

	local MinimapTopLineH = CreateFrame( 'Frame', 'MinimapTopLineH', UIParent )
	MinimapTopLineH:Point( 'BOTTOM', Minimap, 'TOP', 0, 0 )
	MinimapTopLineH:Size( 2, 12 )
	MinimapTopLineH:SetFrameStrata( 'BACKGROUND' )
	MinimapTopLineH:SetFrameLevel( 1 )
	MinimapTopLineH:ApplyStyle()

	local MinimapTopLineV = CreateFrame( 'Frame', 'MinimapTopLineV', UIParent )
	MinimapTopLineV:Point( 'RIGHT', Minimap, 'LEFT', 0, 0 )
	MinimapTopLineV:Size( 12, 2 )
	MinimapTopLineV:SetFrameStrata( 'BACKGROUND' )
	MinimapTopLineV:SetFrameLevel( 1 )
	MinimapTopLineV:ApplyStyle()
end

----------------------------------------
-- Auras
----------------------------------------
local CreateAurasPanels = function()
	sCoreCDB['Auras']['Auras_Size'] = 30

	local AurasLineLeft = CreateFrame( 'Frame', 'AurasLineLeft', UIParent )
	AurasLineLeft:Point( 'TOPRIGHT', UIParent, 'TOPRIGHT', -12, -30 )
	AurasLineLeft:Size( 2, 201 )
	AurasLineLeft:SetFrameStrata( 'BACKGROUND' )
	AurasLineLeft:SetFrameLevel( 1 )
	AurasLineLeft:ApplyStyle()

	local AurasLineTop = CreateFrame( 'Frame', 'AurasLineTop', UIParent )
	AurasLineTop:Point( 'TOPRIGHT', AurasLineLeft, 'TOPRIGHT', 0, 0 )
	AurasLineTop:Size( 182, 2 )
	AurasLineTop:SetFrameStrata( 'BACKGROUND' )
	AurasLineTop:SetFrameLevel( 1 )
	AurasLineTop:ApplyStyle()

	local AurasCubeTop = CreateFrame( 'Frame', 'AurasCubeTop', UIParent )
	AurasCubeTop:Point( 'RIGHT', AurasLineTop, 'LEFT', 0, 0 )
	AurasCubeTop:Size( 10, 10 )
	AurasCubeTop:SetFrameStrata( 'BACKGROUND' )
	AurasCubeTop:SetFrameLevel( 1 )
	AurasCubeTop:ApplyStyle()

	local AurasCubeLeft = CreateFrame( 'Frame', 'AurasCubeLeft', UIParent )
	AurasCubeLeft:Point( 'TOP', AurasLineLeft, 'BOTTOM', 0, 0 )
	AurasCubeLeft:Size( 10, 10 )
	AurasCubeLeft:SetFrameStrata( 'BACKGROUND' )
	AurasCubeLeft:SetFrameLevel( 1 )
	AurasCubeLeft:ApplyStyle()
end

----------------------------------------
-- ActionBars
----------------------------------------
local CreateActionBars = function()
	local BUTTON_SIZE = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSize']
	local BUTTON_SPACING = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSpacing']
	local PETBUTTON_SIZE = sCoreCDB['ActionBars']['ActionBars_PetBar_ButtonSize']
	local PETBUTTON_SPACING = sCoreCDB['ActionBars']['ActionBars_PetBar_ButtonSpacing']
	local STANCEBUTTON_SIZE = sCoreCDB['ActionBars']['ActionBars_StanceBar_ButtonSize']
	local STANCEBUTTON_SPACING = sCoreCDB['ActionBars']['ActionBars_StanceBar_ButtonSpacing']

	local ActionBar1 = CreateFrame( 'Frame', 'ActionBar1', UIParent, 'SecureHandlerStateTemplate' )
	ActionBar1:Point( 'BOTTOM', UIParent, 'BOTTOM', 0, 33 )
	ActionBar1:Size( ( BUTTON_SIZE * 12 ) + ( BUTTON_SPACING * 13 ), BUTTON_SIZE + ( BUTTON_SPACING * 2 ) )
	ActionBar1:SetFrameStrata( 'BACKGROUND' )
	ActionBar1:SetFrameLevel( 1 )
	ActionBar1:ApplyStyle( false, true )

	local ActionBar2 = CreateFrame( 'Frame', 'ActionBar2', UIParent, 'SecureHandlerStateTemplate' )
	ActionBar2:Point( 'BOTTOMLEFT', ActionBar1, 'TOPLEFT', 0, 6 )
	ActionBar2:Size( ( BUTTON_SIZE * 5 ) + ( BUTTON_SPACING * 6 ), BUTTON_SIZE + ( BUTTON_SPACING * 2 ) )
	ActionBar2:SetFrameStrata( 'BACKGROUND' )
	ActionBar2:SetFrameLevel( 1 )
	ActionBar2:ApplyStyle( false, true )

	local ActionBar3 = CreateFrame( 'Frame', 'ActionBar3', S['PetUIFrame'], 'SecureHandlerStateTemplate' )
	ActionBar3:SetAllPoints( ActionBar1 )

	local ActionBar4 = CreateFrame( 'Frame', 'ActionBar4', S['PetUIFrame'], 'SecureHandlerStateTemplate' )
	ActionBar4:SetAllPoints( ActionBar1 )

	local RightActionBar = CreateFrame( 'Frame', 'RightActionBar', S['PetUIFrame'], 'SecureHandlerStateTemplate' )
	RightActionBar:Point( 'BOTTOMRIGHT', GridBackground, 'TOPRIGHT', 0, 6 )
	RightActionBar:Size( ( BUTTON_SIZE * 12 ) + ( BUTTON_SPACING * ( 13 ) ) + 2, ( BUTTON_SIZE * 2 ) + ( BUTTON_SPACING * 3 ) + 2 )
	RightActionBar:SetFrameStrata( 'BACKGROUND' )
	RightActionBar:SetFrameLevel( 1 )
	RightActionBar:ApplyStyle( false, true )

	local ActionBarSplitBarLeft = CreateFrame( 'Frame', 'ActionBarSplitBarLeft', S['PetUIFrame'], 'SecureHandlerStateTemplate' )
	ActionBarSplitBarLeft:Point( 'BOTTOMRIGHT', ActionBar1, 'BOTTOMLEFT', -6, 0 )
	ActionBarSplitBarLeft:Size( ( BUTTON_SIZE * 3 ) + ( BUTTON_SPACING * 4 ) + 2, ( BUTTON_SIZE * 2 ) + ( BUTTON_SPACING * ( 2 + 1 ) ) + 2 )
	ActionBarSplitBarLeft:SetFrameStrata( 'BACKGROUND' )
	ActionBarSplitBarLeft:SetFrameLevel( 1 )
	ActionBarSplitBarLeft:ApplyStyle( false, true )

	local ActionBarSplitBarRight = CreateFrame( 'Frame', 'ActionBarSplitBarRight', S['PetUIFrame'], 'SecureHandlerStateTemplate' )
	ActionBarSplitBarRight:Point( 'BOTTOMLEFT', ActionBar1, 'BOTTOMRIGHT', 6, 0 )
	ActionBarSplitBarRight:Size( ( BUTTON_SIZE * 3 ) + ( BUTTON_SPACING * 4 ) + 2, ( BUTTON_SIZE * 2 ) + ( BUTTON_SPACING * ( 2 + 1 ) ) + 2 )
	ActionBarSplitBarRight:SetFrameStrata( 'BACKGROUND' )
	ActionBarSplitBarRight:SetFrameLevel( 1 )
	ActionBarSplitBarRight:ApplyStyle( false, true )

	local Mover_StanceBars = CreateFrame( 'Frame', 'Mover_StanceBars', UIParent )
	Mover_StanceBars['movingname'] = 'Mover: StanceBars'
	Mover_StanceBars['point'] = {
		Healer = { a1 = 'TOPLEFT', parent = 'ChatBackground', a2 = 'TOPRIGHT', x = 6, y = 0 },
		DPS = { a1 = 'TOPLEFT', parent = 'ChatBackground', a2 = 'TOPRIGHT', x = 6, y = 0 },
	}
	Mover_StanceBars:Size( 250, 20 )
	S['CreateDragFrame']( Mover_StanceBars )

	local StanceBar = CreateFrame( 'Frame', 'StanceBar', S['PetUIFrame'], 'SecureHandlerStateTemplate' )
	StanceBar:Point( 'TOPLEFT', Mover_StanceBars, 'TOPLEFT', 0, 0 )
	StanceBar:Size( ( STANCEBUTTON_SIZE * 10 ) + ( STANCEBUTTON_SPACING * 11 ), ( STANCEBUTTON_SIZE + STANCEBUTTON_SPACING * 2 ) + 2 )
	StanceBar:SetFrameStrata( 'BACKGROUND' )
	StanceBar:SetFrameLevel( 1 )
	StanceBar:ApplyStyle( false, true )

	local PetActionBar = CreateFrame( 'Frame', 'PetActionBar', S['PetUIFrame'], 'SecureHandlerStateTemplate' )
	PetActionBar:Point( 'RIGHT', UIParent, 'RIGHT', 0, 0 )
	if( sCoreCDB['ActionBars']['ActionBars_VerticalRightBars'] ) then
		PetActionBar:Size( ( PETBUTTON_SIZE + PETBUTTON_SPACING * 2 ) + 2, ( PETBUTTON_SIZE * NUM_PET_ACTION_SLOTS + PETBUTTON_SPACING * 11 ) + 2 )
	else
		PetActionBar:Size( ( PETBUTTON_SIZE * NUM_PET_ACTION_SLOTS + PETBUTTON_SPACING * 11 ) + 2, ( PETBUTTON_SIZE + PETBUTTON_SPACING * 2 ) + 2 )
	end
	PetActionBar:SetFrameStrata( 'BACKGROUND' )
	PetActionBar:SetFrameLevel( 1 )
	PetActionBar:ApplyStyle( false, true )

	local ActionBar1LeftLine1 = CreateFrame( 'Frame', 'ActionBar1LeftLine1', UIParent )
	ActionBar1LeftLine1:Point( 'RIGHT', ActionBar1, 'LEFT', 0, 0 )
	ActionBar1LeftLine1:Size( 26, 2 )
	ActionBar1LeftLine1:SetFrameStrata( 'BACKGROUND' )
	ActionBar1LeftLine1:SetFrameLevel( 1 )
	ActionBar1LeftLine1:ApplyStyle()

	local ActionBar1LeftLine2 = CreateFrame( 'Frame', 'ActionBar1LeftLine2', UIParent )
	ActionBar1LeftLine2:Point( 'TOPLEFT', ActionBar1LeftLine1, 'TOPLEFT', 0, 0 )
	ActionBar1LeftLine2:Size( 2, 41 )
	ActionBar1LeftLine2:SetFrameStrata( 'BACKGROUND' )
	ActionBar1LeftLine2:SetFrameLevel( 1 )
	ActionBar1LeftLine2:ApplyStyle()

	local ActionBar1LeftLine3 = CreateFrame( 'Frame', 'ActionBar1LeftLine3', UIParent )
	ActionBar1LeftLine3:Point( 'BOTTOMRIGHT', ActionBar1LeftLine2, 'BOTTOMRIGHT', 0, 0 )
	ActionBar1LeftLine3:Size( 26, 2 )
	ActionBar1LeftLine3:SetFrameStrata( 'BACKGROUND' )
	ActionBar1LeftLine3:SetFrameLevel( 1 )
	ActionBar1LeftLine3:ApplyStyle()

	local ActionBar1LeftCube = CreateFrame( 'Frame', 'ActionBar1LeftCube', UIParent )
	ActionBar1LeftCube:Point( 'RIGHT', ActionBar1LeftLine3, 'LEFT', 0, 0 )
	ActionBar1LeftCube:Size( 10, 10 )
	ActionBar1LeftCube:SetFrameStrata( 'BACKGROUND' )
	ActionBar1LeftCube:SetFrameLevel( 1 )
	ActionBar1LeftCube:ApplyStyle()

	local ActionBar1RightLine1 = CreateFrame( 'Frame', 'ActionBar1RightLine1', UIParent )
	ActionBar1RightLine1:Point( 'LEFT', ActionBar1, 'RIGHT', 0, 0 )
	ActionBar1RightLine1:Size( 26, 2 )
	ActionBar1RightLine1:SetFrameStrata( 'BACKGROUND' )
	ActionBar1RightLine1:SetFrameLevel( 1 )
	ActionBar1RightLine1:ApplyStyle()

	local ActionBar1RightLine2 = CreateFrame( 'Frame', 'ActionBar1RightLine2', UIParent )
	ActionBar1RightLine2:Point( 'TOPRIGHT', ActionBar1RightLine1, 'TOPRIGHT', 0, 0 )
	ActionBar1RightLine2:Size( 2, 41 )
	ActionBar1RightLine2:SetFrameStrata( 'BACKGROUND' )
	ActionBar1RightLine2:SetFrameLevel( 1 )
	ActionBar1RightLine2:ApplyStyle()

	local ActionBar1RightLine3 = CreateFrame( 'Frame', 'ActionBar1RightLine3', UIParent )
	ActionBar1RightLine3:Point( 'BOTTOMLEFT', ActionBar1RightLine2, 'BOTTOMLEFT', 0, 0 )
	ActionBar1RightLine3:Size( 26, 2 )
	ActionBar1RightLine3:SetFrameStrata( 'BACKGROUND' )
	ActionBar1RightLine3:SetFrameLevel( 1 )
	ActionBar1RightLine3:ApplyStyle()

	local ActionBar1RightCube = CreateFrame( 'Frame', 'ActionBar1RightCube', UIParent )
	ActionBar1RightCube:Point( 'LEFT', ActionBar1RightLine3, 'RIGHT', 0, 0 )
	ActionBar1RightCube:Size( 10, 10 )
	ActionBar1RightCube:SetFrameStrata( 'BACKGROUND' )
	ActionBar1RightCube:SetFrameLevel( 1 )
	ActionBar1RightCube:ApplyStyle()
end

----------------------------------------
-- Chat
----------------------------------------
local CreateChatFrames = function()
	local ChatBackground = CreateFrame( 'Frame', 'ChatBackground', UIParent )
	ChatBackground:Point( 'BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 25, 25 )
	ChatBackground:Size( sCoreCDB['ChatFrames']['ChatFrames_Width'], sCoreCDB['ChatFrames']['ChatFrames_Height'] )
	ChatBackground:SetFrameStrata( 'BACKGROUND' )
	ChatBackground:SetFrameLevel( 1 )
	ChatBackground:ApplyStyle( false, true )

	local ChatLineV = CreateFrame( 'Frame', 'ChatLineV', UIParent )
	ChatLineV:Point( 'BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 12, 12 )
	ChatLineV:Size( 2, 260 )
	ChatLineV:SetFrameStrata( 'BACKGROUND' )
	ChatLineV:SetFrameLevel( 1 )
	ChatLineV:ApplyStyle()

	local ChatLineH = CreateFrame( 'Frame', 'ChatLineH', UIParent )
	ChatLineH:Point( 'BOTTOMLEFT', ChatLineV, 'BOTTOMLEFT', 0, 0 )
	ChatLineH:Size( 425, 2 )
	ChatLineH:SetFrameStrata( 'BACKGROUND' )
	ChatLineH:SetFrameLevel( 1 )
	ChatLineH:ApplyStyle()

	local ChatLineVSmall = CreateFrame( 'Frame', 'ChatLineVSmall', UIParent )
	ChatLineVSmall:Point( 'TOP', ChatBackground, 'BOTTOM', 0, 0 )
	ChatLineVSmall:Size( 2, 12 )
	ChatLineVSmall:SetFrameStrata( 'BACKGROUND' )
	ChatLineVSmall:SetFrameLevel( 1 )
	ChatLineVSmall:ApplyStyle()

	local ChatLineHSmall = CreateFrame( 'Frame', 'ChatLineHSmall', UIParent )
	ChatLineHSmall:Point( 'RIGHT', ChatBackground, 'LEFT', 0, 0 )
	ChatLineHSmall:Size( 12, 2 )
	ChatLineHSmall:SetFrameStrata( 'BACKGROUND' )
	ChatLineHSmall:SetFrameLevel( 1 )
	ChatLineHSmall:ApplyStyle()

	local ChatCubeV = CreateFrame( 'Frame', 'ChatCubeV', UIParent )
	ChatCubeV:Point( 'BOTTOM', ChatLineV, 'TOP', 0, 0 )
	ChatCubeV:Size( 10, 10 )
	ChatCubeV:SetFrameStrata( 'BACKGROUND' )
	ChatCubeV:SetFrameLevel( 1 )
	ChatCubeV:ApplyStyle()

	local ChatCubeH = CreateFrame( 'Frame', 'ChatCubeH', UIParent )
	ChatCubeH:Point( 'LEFT', ChatLineH, 'RIGHT', 0, 0 )
	ChatCubeH:Size( 10, 10 )
	ChatCubeH:SetFrameStrata( 'BACKGROUND' )
	ChatCubeH:SetFrameLevel( 1 )
	ChatCubeH:ApplyStyle()
end

----------------------------------------
-- Grid
----------------------------------------
local CreateGridFrames = function()
	local GridBackground = CreateFrame( 'Frame', 'GridBackground', UIParent )
	GridBackground:Point( 'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -25, 25 )
	GridBackground:Size( 305, 198 )
	GridBackground:SetFrameStrata( 'BACKGROUND' )
	GridBackground:SetFrameLevel( 1 )
	GridBackground:ApplyStyle( false, true )

	local GridLineV = CreateFrame( 'Frame', 'GridLineV', UIParent )
	GridLineV:Point( 'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -12, 12 )
	GridLineV:Size( 2, 260 )
	GridLineV:SetFrameStrata( 'BACKGROUND' )
	GridLineV:SetFrameLevel( 1 )
	GridLineV:ApplyStyle()

	local GridLineH = CreateFrame( 'Frame', 'GridLineH', UIParent )
	GridLineH:Point( 'BOTTOMRIGHT', GridLineV, 'BOTTOMRIGHT', 0, 0 )
	GridLineH:Size( 425, 2 )
	GridLineH:SetFrameStrata( 'BACKGROUND' )
	GridLineH:SetFrameLevel( 1 )
	GridLineH:ApplyStyle()

	local GridLineVSmall = CreateFrame( 'Frame', 'GridLineVSmall', UIParent )
	GridLineVSmall:Point( 'TOP', GridBackground, 'BOTTOM', 0, 0 )
	GridLineVSmall:Size( 2, 12 )
	GridLineVSmall:SetFrameStrata( 'BACKGROUND' )
	GridLineVSmall:SetFrameLevel( 1 )
	GridLineVSmall:ApplyStyle()

	local GridLineHSmall = CreateFrame( 'Frame', 'GridLineHSmall', UIParent )
	GridLineHSmall:Point( 'LEFT', GridBackground, 'RIGHT', 0, 0 )
	GridLineHSmall:Size( 12, 2 )
	GridLineHSmall:SetFrameStrata( 'BACKGROUND' )
	GridLineHSmall:SetFrameLevel( 1 )
	GridLineHSmall:ApplyStyle()

	local GridCubeV = CreateFrame( 'Frame', 'GridCubeV', UIParent )
	GridCubeV:Point( 'BOTTOM', GridLineV, 'TOP', 0, 0 )
	GridCubeV:Size( 10, 10 )
	GridCubeV:SetFrameStrata( 'BACKGROUND' )
	GridCubeV:SetFrameLevel( 1 )
	GridCubeV:ApplyStyle()

	local GridCubeH = CreateFrame( 'Frame', 'GridCubeH', UIParent )
	GridCubeH:Point( 'RIGHT', GridLineH, 'LEFT', 0, 0 )
	GridCubeH:Size( 10, 10 )
	GridCubeH:SetFrameStrata( 'BACKGROUND' )
	GridCubeH:SetFrameLevel( 1 )
	GridCubeH:ApplyStyle()
end

----------------------------------------
-- DataBlocks
----------------------------------------
local CreateDataBlockFrames = function()
	local StatsBlockBottom = CreateFrame( 'Frame', 'StatsBlockBottom', UIParent )
	StatsBlockBottom:Point( 'BOTTOMRIGHT', GridBackground, 'BOTTOMLEFT', -7, 0 )
	StatsBlockBottom:Size( 67, 38 )
	StatsBlockBottom:SetFrameStrata( 'BACKGROUND' )
	StatsBlockBottom:SetFrameLevel( 1 )
	StatsBlockBottom:ApplyStyle( false, true )

	local StatsBlockMiddle = CreateFrame( 'Frame', 'StatsBlockMiddle', UIParent )
	StatsBlockMiddle:Point( 'BOTTOM', StatsBlockBottom, 'TOP', 0, 12 )
	StatsBlockMiddle:Size( 67, 78 )
	StatsBlockMiddle:SetFrameStrata( 'BACKGROUND' )
	StatsBlockMiddle:SetFrameLevel( 1 )
	StatsBlockMiddle:ApplyStyle( false, true )

	local StatsBlockTop = CreateFrame( 'Frame', 'StatsBlockTop', UIParent )
	StatsBlockTop:Point( 'BOTTOM', StatsBlockMiddle, 'TOP', 0, 12 )
	StatsBlockTop:Size( 67, 58 )
	StatsBlockTop:SetFrameStrata( 'BACKGROUND' )
	StatsBlockTop:SetFrameLevel( 1 )
	StatsBlockTop:ApplyStyle( false, true )

	local StatsBlockBottomLine = CreateFrame( 'Frame', 'StatsBlockBottomLine', UIParent )
	StatsBlockBottomLine:Point( 'TOP', StatsBlockBottom, 'BOTTOM', 0, 0 )
	StatsBlockBottomLine:Size( 2, 12 )
	StatsBlockBottomLine:SetFrameStrata( 'BACKGROUND' )
	StatsBlockBottomLine:SetFrameLevel( 1 )
	StatsBlockBottomLine:ApplyStyle()

	local StatsBlockMiddleLine = CreateFrame( 'Frame', 'StatsBlockMiddleLine', UIParent )
	StatsBlockMiddleLine:Point( 'TOP', StatsBlockMiddle, 'BOTTOM', 0, 0 )
	StatsBlockMiddleLine:Size( 2, 12 )
	StatsBlockMiddleLine:SetFrameStrata( 'BACKGROUND' )
	StatsBlockMiddleLine:SetFrameLevel( 1 )
	StatsBlockMiddleLine:ApplyStyle()

	local StatsBlockTopLine = CreateFrame( 'Frame', 'StatsBlockTopLine', UIParent )
	StatsBlockTopLine:Point( 'TOP', StatsBlockTop, 'BOTTOM', 0, 0 )
	StatsBlockTopLine:Size( 2, 12 )
	StatsBlockTopLine:SetFrameStrata( 'BACKGROUND' )
	StatsBlockTopLine:SetFrameLevel( 1 )
	StatsBlockTopLine:ApplyStyle()
end

----------------------------------------
-- Left DataText / ThreatBar
----------------------------------------
local CreateInfoLeft = function()
	local InfoLeft = CreateFrame( 'Frame', 'InfoLeft', UIParent )
	InfoLeft:Point( 'TOPLEFT', ActionBar1, 'BOTTOMLEFT', 0, -6 )
	InfoLeft:Size( ( sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSize'] * 6 ) + ( sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSpacing'] * 6 ) - 1, 23 )
	InfoLeft:SetFrameStrata( 'BACKGROUND' )
	InfoLeft:SetFrameLevel( 2 )
	InfoLeft:ApplyStyle( false, true )
end

----------------------------------------
-- Right DataText / AltPowerBar
----------------------------------------
local CreateInfoRight = function()
	local InfoRight = CreateFrame( 'Frame', 'InfoRight', UIParent )
	InfoRight:Point( 'TOPRIGHT', ActionBar1, 'BOTTOMRIGHT', 0, -6 )
	InfoRight:Size( ( sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSize'] * 6 ) + ( sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSpacing'] * 6 ) - 1, 23 )
	InfoRight:SetFrameStrata( 'BACKGROUND' )
	InfoRight:SetFrameLevel( 2 )
	InfoRight:ApplyStyle( false, true )
end

----------------------------------------
-- For later DMG / HEALING METERS
----------------------------------------
local CombatFading = function()
	--local ActionBar1BottomLineSmall = CreateFrame( 'Frame', 'ActionBar1BottomLineSmall', UIParent )
	--ActionBar1BottomLineSmall:Point( 'TOP', ActionBar1, 'BOTTOM', 0, 0 )
	--ActionBar1BottomLineSmall:Size( 2, 21 )
	--ActionBar1BottomLineSmall:SetFrameStrata( 'BACKGROUND' )
	--ActionBar1BottomLineSmall:SetFrameLevel( 1 )
	--ActionBar1BottomLineSmall:ApplyStyle()

	local ActionBar1BottomLine = CreateFrame( 'Frame', 'ActionBar1BottomLine', UIParent )
	ActionBar1BottomLine:Point( 'LEFT', ChatLineH, 'RIGHT', 0, 0 )
	ActionBar1BottomLine:Point( 'RIGHT', GridLineH, 'LEFT', 0, 0 )
	ActionBar1BottomLine:Height( 2 )
	ActionBar1BottomLine:SetFrameStrata( 'BACKGROUND' )
	ActionBar1BottomLine:SetFrameLevel( 1 )
	ActionBar1BottomLine:ApplyStyle()

	local CombatHider = CreateFrame('Frame')
	CombatHider:RegisterEvent( 'PLAYER_ENTERING_WORLD' )
	CombatHider:RegisterEvent( 'PLAYER_REGEN_ENABLED' )
	CombatHider:RegisterEvent( 'PLAYER_REGEN_DISABLED' )

	local OnEvent = function( self )
		if( UnitAffectingCombat( 'player' ) ) then
			--ActionBar1BottomLineSmall:Show()
			ActionBar1BottomLine:Show()

			ActionBar1LeftLine1:Hide()
			ActionBar1LeftLine2:Hide()
			ActionBar1LeftLine3:Hide()
			ActionBar1LeftCube:Hide()
			ActionBar1RightLine1:Hide()
			ActionBar1RightLine2:Hide()
			ActionBar1RightLine3:Hide()
			ActionBar1RightCube:Hide()

			ChatCubeH:Hide()
			GridCubeH:Hide()
		else
			--ActionBar1BottomLineSmall:Hide()
			ActionBar1BottomLine:Hide()

			ActionBar1LeftLine1:Show()
			ActionBar1LeftLine2:Show()
			ActionBar1LeftLine3:Show()
			ActionBar1LeftCube:Show()
			ActionBar1RightLine1:Show()
			ActionBar1RightLine2:Show()
			ActionBar1RightLine3:Show()
			ActionBar1RightCube:Show()

			ChatCubeH:Show()
			GridCubeH:Show()
		end
	end

	CombatHider:SetScript( 'OnEvent', OnEvent )
end

----------------------------------------
-- Textures
----------------------------------------
local CreateTextures = function()
	for _, TextureFrames in pairs( {
		TopPanel,
		ActionBar1,
		ActionBar2,
		RightActionBar,
		ActionBarSplitBarLeft,
		ActionBarSplitBarRight,
		StanceBar,
		PetActionBar,
		ChatBackground,
		GridBackground,
		StatsBlockBottom,
		StatsBlockMiddle,
		StatsBlockTop,
		InfoLeft,
		InfoRight
	} ) do
		TextureFrames['Texture'] = TextureFrames:CreateTexture( nil, 'OVERLAY' )
		TextureFrames['Texture']:SetInside()
		TextureFrames['Texture']:SetTexture( M['Textures']['Glamour'] )
		TextureFrames['Texture']:SetAlpha( 0.08 )
	end
end

----------------------------------------
-- INIT
----------------------------------------
S['Layout_Init'] = function()
	CreateTopPanel()
	CreateMinimapPanels()
	CreateAurasPanels()
	CreateGridFrames()
	CreateActionBars()
	CreateChatFrames()
	CreateDataBlockFrames()
	CreateInfoLeft()
	CreateInfoRight()
	CombatFading()
	CreateTextures()
end
