--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local _G = _G
local format, gsub, sub = string.format, string.gsub, string.sub
local CreateFrame = CreateFrame
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS
local NUM_STANCE_SLOTS = NUM_STANCE_SLOTS
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS
local IsUsableAction = IsUsableAction
local IsActionInRange = IsActionInRange
local ActionHasRange = ActionHasRange
local HasAction = HasAction
local BlizzardFrames = {
	MainMenuBar, MainMenuBarArtFrame, OverrideActionBar,
	PossessBarFrame, PetActionBarFrame, IconIntroTracker,
	ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight,
	TalentMicroButtonAlert, CollectionsMicroButtonAlert, EJMicroButtonAlert
}

local FlyoutButtons = 0

local DisableBlizzard = function()
	SetCVar( 'alwaysShowActionBars', 1 )

	for _, Frame in pairs( BlizzardFrames ) do
		Frame:UnregisterAllEvents()
		Frame.ignoreFramePositionManager = true
		Frame:SetParent( S['HiddenFrame'] )
	end

	for index = 1, 6 do
		local Button = _G['OverrideActionBarButton' .. index]
		Button:UnregisterAllEvents()
		Button:SetAttribute( 'statehidden', true )
		Button:SetAttribute( 'showgrid', 1 )
	end

	hooksecurefunc( 'TalentFrame_LoadUI', function()
		PlayerTalentFrame:UnregisterEvent( 'ACTIVE_TALENT_GROUP_CHANGED' )
	end )

	hooksecurefunc( 'ActionButton_OnEvent', function( self, event )
		if( event == 'PLAYER_ENTERING_WORLD' ) then
			self:UnregisterEvent( 'ACTIONBAR_SHOWGRID' )
			self:UnregisterEvent( 'ACTIONBAR_HIDEGRID' )
			self:UnregisterEvent( 'PLAYER_ENTERING_WORLD' )
		end
	end )

	MainMenuBar.slideOut.IsPlaying = function()
		return true
	end
end

local ShowGrid = function()
	for index = 1, NUM_ACTIONBAR_BUTTONS do
		local Button

		Button = _G[format( 'ActionButton%d', index )]
		Button:SetAttribute( 'showgrid', 1 )
		Button:SetAttribute( 'statehidden', true )
		Button:Show()

		ActionButton_ShowGrid( Button )

		Button = _G[format( 'MultiBarRightButton%d', index )]
		Button:SetAttribute( 'showgrid', 1 )
		Button:SetAttribute( 'statehidden', true )
		Button:Show()

		ActionButton_ShowGrid( Button )

		Button = _G[format( 'MultiBarBottomRightButton%d', index )]
		Button:SetAttribute( 'showgrid', 1 )
		Button:SetAttribute( 'statehidden', true )
		Button:Show()

		ActionButton_ShowGrid( Button )

		Button = _G[format( 'MultiBarLeftButton%d', index )]
		Button:SetAttribute( 'showgrid', 1 )
		Button:SetAttribute( 'statehidden', true )
		Button:Show()

		ActionButton_ShowGrid( Button )

		Button = _G[format( 'MultiBarBottomLeftButton%d', index )]
		Button:SetAttribute( 'showgrid', 1 )
		Button:SetAttribute( 'statehidden', true )
		Button:Show()

		ActionButton_ShowGrid( Button )
	end
end

local UpdateHotKeys = function( self, actionButtonType )
	local HotKey = _G[self:GetName() .. 'HotKey']
	local Text = HotKey:GetText()
	local Indicator = _G['RANGE_INDICATOR']

	if( not Text ) then
		return
	end

	Text = gsub( Text, '(s%-)', 'S' )
	Text = gsub( Text, '(a%-)', 'A' )
	Text = gsub( Text, '(c%-)', 'C' )
	Text = gsub( Text, '(Mouse Button )', 'M' )
	Text = gsub( Text, KEY_MOUSEWHEELDOWN , 'MDn' )
	Text = gsub( Text, KEY_MOUSEWHEELUP , 'MUp' )
	Text = gsub( Text, KEY_BUTTON3, 'M3' )
	Text = gsub( Text, KEY_BUTTON4, 'M4' )
	Text = gsub( Text, KEY_BUTTON5, 'M5' )
	Text = gsub( Text, KEY_NUMPAD0, 'N0' )
	Text = gsub( Text, KEY_NUMPAD1, 'N1' )
	Text = gsub( Text, KEY_NUMPAD2, 'N2' )
	Text = gsub( Text, KEY_NUMPAD3, 'N3' )
	Text = gsub( Text, KEY_NUMPAD4, 'N4' )
	Text = gsub( Text, KEY_NUMPAD5, 'N5' )
	Text = gsub( Text, KEY_NUMPAD6, 'N6' )
	Text = gsub( Text, KEY_NUMPAD7, 'N7' )
	Text = gsub( Text, KEY_NUMPAD8, 'N8' )
	Text = gsub( Text, KEY_NUMPAD9, 'N9' )
	Text = gsub( Text, KEY_NUMPADDECIMAL, 'Nu.' )
	Text = gsub( Text, KEY_NUMPADDIVIDE, 'Nu/' )
	Text = gsub( Text, KEY_NUMPADMINUS, 'Nu-' )
	Text = gsub( Text, KEY_NUMPADMULTIPLY, 'Nu*' )
	Text = gsub( Text, KEY_NUMPADPLUS, 'Nu+' )
	Text = gsub( Text, KEY_NUMLOCK, 'NuL' )
	Text = gsub( Text, KEY_PAGEUP, 'PU' )
	Text = gsub( Text, KEY_PAGEDOWN, 'PD' )
	Text = gsub( Text, KEY_SPACE, 'SpB' )
	Text = gsub( Text, KEY_INSERT, 'Ins' )
	Text = gsub( Text, KEY_HOME, 'Hm' )
	Text = gsub( Text, KEY_DELETE, 'Del' )
	Text = gsub( Text, KEY_INSERT_MAC, 'Hlp' )

	if( HotKey:GetText() == Indicator ) then
		HotKey:SetText( '' )
	else
		HotKey:SetText( Text )
	end
end

local RangeUpdate = function( self )
	local Icon = self.icon
	local NormalTexture = self.NormalTexture
	local ID = self.action

	if( not ID ) then
		return
	end

	local IsUsable, NotEnoughMana = IsUsableAction( ID )
	local HasRange = ActionHasRange( ID )
	local InRange = IsActionInRange( ID )

	if( IsUsable ) then
		if( HasRange and InRange == false ) then
			Icon:SetVertexColor( 0.8, 0.1, 0.1 )
			NormalTexture:SetVertexColor( 0.8, 0.1, 0.1 )
		else
			Icon:SetVertexColor( 1.0, 1.0, 1.0 )
			NormalTexture:SetVertexColor( 1.0, 1.0, 1.0 )
		end
	elseif( NotEnoughMana ) then
		Icon:SetVertexColor( 0.1, 0.3, 1.0 )
		NormalTexture:SetVertexColor( 0.1, 0.3, 1.0 )
	else
		Icon:SetVertexColor( 0.3, 0.3, 0.3 )
		NormalTexture:SetVertexColor( 0.3, 0.3, 0.3 )
	end
end

local RangeOnUpdate = function( self, elapsed )
	if( not self.rangeTimer ) then
		return
	end

	if( self.rangeTimer == TOOLTIP_UPDATE_TIME ) then
		RangeUpdate( self )
	end
end

local SkinButtons = function( self )
	local Name = self:GetName()
	local Action = self['action']
	local Button = self
	local Icon = _G[Name .. 'Icon']
	local Count = _G[Name .. 'Count']
	local Flash = _G[Name .. 'Flash']
	local HotKey = _G[Name .. 'HotKey']
	local Border = _G[Name .. 'Border']
	local ButtonName = _G[Name .. 'Name']
	local NormalTexture = _G[Name .. 'NormalTexture']
	local FloatingBackground = _G[Name .. 'FloatingBG']

	Flash:SetTexture( '' )
	Button:SetNormalTexture( '' )

	Count:ClearAllPoints()
	Count:Point( 'BOTTOMRIGHT', 0, 2 )
	Count:SetFont( M['Fonts']['Normal'], 10, 'OUTLINE' )
	Count:SetShadowOffset( 0, 0 )

	HotKey:ClearAllPoints()
	HotKey:Point( 'TOPRIGHT', 0, -2 )

	UpdateHotKeys( self )

	if( Border and Button['IsSkinned'] ) then
		Border:SetTexture( '' )

		if( Border:IsShown() and sCoreCDB['ActionBars']['ActionBars_EquipBorder'] ) then
			Button:SetBackdropBorderColor( 0.08, 0.70, 0 )
		else
			Button:SetBackdropBorderColor( M['Colors']['General']['Border']['r'], M['Colors']['General']['Border']['g'], M['Colors']['General']['Border']['b'], M['Colors']['General']['Border']['a'] )
		end
	end

	if( ButtonName and NormalTexture and sCoreCDB['ActionBars']['ActionBars_ShowMacroText'] ) then
		local String = GetActionText( Action )

		if( String ) then
			local Text

			if( string.byte( String, 1 ) > 223 ) then
				Text = string.sub( String, 1, 9 )
			else
				Text = string.sub( String, 1, 4 )
			end

			ButtonName:SetText( Text )
			ButtonName:SetShadowOffset( 0, 0 )
		end
	end

	if( Button['IsSkinned'] ) then
		return
	end

	if( ButtonName ) then
		if( sCoreCDB['ActionBars']['ActionBars_ShowMacroText'] ) then
			ButtonName:ClearAllPoints()
			ButtonName:Point( 'BOTTOM', 1, 1 )
			ButtonName:SetFont( M['Fonts']['Normal'], 10, 'OUTLINE' )
			ButtonName:SetShadowOffset( 0, 0 )
		else
			ButtonName:SetText( '' )
			ButtonName:Kill()
		end
	end

	if( FloatingBackground ) then
		FloatingBackground:Kill()
	end

	if( sCoreCDB['ActionBars']['ActionBars_ShowHotKeyText'] ) then
		HotKey:SetFont( M['Fonts']['Normal'], 10, 'OUTLINE' )
		HotKey:SetShadowOffset( 0, 0 )
		HotKey['ClearAllPoints'] = S['Dummy']
		HotKey['SetPoint'] = S['Dummy']
	else
		HotKey:SetText( '' )
		HotKey:Kill()
	end

	if( Name:match( 'Extra' ) ) then
		Button['Pushed'] = true
	end

	Button:ApplyStyle( nil, nil, true )
	Button:UnregisterEvent( 'ACTIONBAR_SHOWGRID' )
	Button:UnregisterEvent( 'ACTIONBAR_HIDEGRID' )

	if( sCoreCDB['ActionBars']['ActionBars_InvertedTextures'] ) then
		if( Button['Gradient'] ) then
			return
		end

		local Gradient = CreateFrame( 'Frame', nil, Button )
		Gradient:Point( 'CENTER', Button, 'CENTER', 0, 0 )
		Gradient:SetAllPoints()
		Gradient:SetFrameStrata( Button:GetFrameStrata() )
		Gradient:SetFrameLevel( Button:GetFrameLevel() + 2 )

		Gradient['Texture'] = Gradient:CreateTexture( nil, 'OVERLAY' )
		Gradient['Texture']:SetTexture( M['Textures']['Inverted'] )
		Gradient['Texture']:SetInside( Gradient )
		Gradient['Texture']:SetAlpha( 0.9 )

		Button['Gradient'] = Gradient
	end

	if( sCoreCDB['ActionBars']['ActionBars_GlossTextures'] ) then
		if( Button['Gloss'] ) then
			return
		end

		local Glossy = CreateFrame( 'Frame', nil, Button )
		Glossy:Point( 'CENTER', Button, 'CENTER', 0, 0 )
		Glossy:SetAllPoints()
		Glossy:SetFrameStrata( Button:GetFrameStrata() )
		Glossy:SetFrameLevel( Button:GetFrameLevel() + 2 )

		Glossy['Texture'] = Glossy:CreateTexture( nil, 'OVERLAY' )
		Glossy['Texture']:SetTexture( M['Textures']['Gloss'] )
		Glossy['Texture']:SetInside( Glossy )
		Glossy['Texture']:SetAlpha( 0.4 )

		Button['Gloss'] = Glossy
	end

	Icon:SetTexCoord( unpack( S['TextureCoords'] ) )
	Icon:SetInside()
	Icon:SetDrawLayer( 'BACKGROUND', 7 )

	if( NormalTexture ) then
		NormalTexture:ClearAllPoints()
		NormalTexture:Point( 'TOPLEFT' )
		NormalTexture:Point( 'BOTTOMRIGHT' )

		if( Button:GetChecked() ) then
			ActionButton_UpdateState( Button )
		end
	end

	Button:ApplySkin( 'Action' )

	Button['IsSkinned'] = true
end

local SkinPetAndShiftButton = function( Normal, Button, Icon, Name, Pet )
	if( Button['IsSkinned'] ) then
		return
	end

	local PetBar_ButtonSize = sCoreCDB['ActionBars']['ActionBars_PetBar_ButtonSize']
	local HotKey = _G[Button:GetName() .. 'HotKey']
	local Flash = _G[Name .. 'Flash']

	Button:Size( PetBar_ButtonSize, PetBar_ButtonSize )
	Button:ApplyStyle( nil, nil, true )

	if( sCoreCDB['ActionBars']['ActionBars_ShowHotKeyText'] ) then
		HotKey:ClearAllPoints()
		HotKey:Point( 'TOPRIGHT', 0, -2 )
		HotKey:SetFont( M['Fonts']['Normal'], 10, 'OUTLINE' )
		HotKey:SetShadowOffset( 0, 0 )
	else
		HotKey:SetText( '' )
		HotKey:Kill()
	end

	Icon:SetTexCoord( unpack( S['TextureCoords'] ) )
	Icon:SetInside()
	Icon:SetDrawLayer( 'BACKGROUND', 7 )

	if( Pet ) then
		if( PetBar_ButtonSize < 30 ) then
			local AutoCast = _G[Name .. 'AutoCastable']
			AutoCast:SetAlpha( 0 )
		end

		local Shine = _G[Name .. 'Shine']
		Shine:Size( PetBar_ButtonSize )
		Shine:ClearAllPoints()
		Shine:Point( 'CENTER', Button, 'CENTER', 0, 0 )

		UpdateHotKeys( Button )
	end

	Button:SetNormalTexture( '' )
	Button.SetNormalTexture = S['Dummy']

	Flash:SetTexture( '' )

	if( Normal ) then
		Normal:ClearAllPoints()
		Normal:Point( 'TOPLEFT' )
		Normal:Point( 'BOTTOMRIGHT' )
	end

	Button:ApplySkin( 'Action' )
	Button['IsSkinned'] = true
end

local SkinPetButtons = function()
	for index = 1, NUM_PET_ACTION_SLOTS do
		local Name = 'PetActionButton' .. index
		local Button  = _G[Name]
		local Icon  = _G[Name .. 'Icon']
		local Normal  = _G[Name .. 'NormalTexture2']

		SkinPetAndShiftButton( Normal, Button, Icon, Name, true )
	end
end

local SkinStanceButtons = function()
	for index = 1, NUM_STANCE_SLOTS do
		local Name = 'StanceButton' .. index
		local Button  = _G[Name]
		local Icon  = _G[Name .. 'Icon']
		local Normal  = _G[Name .. 'NormalTexture']

		SkinPetAndShiftButton( Normal, Button, Icon, Name, false )
	end
end

local SkinFlyoutButtons = function()
	for index = 1, FlyoutButtons do
		local Button = _G['SpellFlyoutButton' .. index]

		if( Button and not Button['IsSkinned'] ) then
			SkinButtons( Button )

			if( Button:GetChecked() ) then
				Button:SetChecked( nil )
			end

			Button['IsSkinned'] = true
		end
	end
end

local StyleFlyout = function( self )
	if( not self.FlyoutArrow ) then
		return
	end

	local SpellFlyoutHorizontalBackground = SpellFlyoutHorizontalBackground
	local SpellFlyoutVerticalBackground = SpellFlyoutVerticalBackground
	local SpellFlyoutBackgroundEnd = SpellFlyoutBackgroundEnd

	if( self.FlyoutBorder ) then
		self.FlyoutBorder:SetAlpha( 0 )
		self.FlyoutBorderShadow:SetAlpha( 0 )
	end

	SpellFlyoutHorizontalBackground:SetAlpha( 0 )
	SpellFlyoutVerticalBackground:SetAlpha( 0 )
	SpellFlyoutBackgroundEnd:SetAlpha( 0 )

	for index = 1, GetNumFlyouts() do
		local ID = GetFlyoutID( index )
		local _, _, NumSlots, IsKnown = GetFlyoutInfo( ID )

		if( IsKnown ) then
			FlyoutButtons = NumSlots

			break
		end
	end

	SkinFlyoutButtons()
end

local UpdatePetBar = function( ... )
	local ButtonName, PetActionButton, PetActionIcon, PetActionBackdrop, PetAutoCastableTexture, PetAutoCastShine, HotKey
	local Name, SubText, Texture, IsToken, IsActive, AutoCastAllowed, AutoCastEnabled

	for index = 1, NUM_PET_ACTION_SLOTS, 1 do
		ButtonName = 'PetActionButton' .. index
		PetActionButton = _G[ButtonName]
		PetActionIcon = _G[ButtonName .. 'Icon']
		PetActionBackdrop = PetActionButton.Backdrop
		PetAutoCastableTexture = _G[ButtonName .. 'AutoCastable']
		PetAutoCastShine = _G[ButtonName .. 'Shine']
		HotKey = _G[ButtonName .. 'HotKey']
		Name, SubText, Texture, IsToken, IsActive, AutoCastAllowed, AutoCastEnabled = GetPetActionInfo( index )

		if( not IsToken ) then
			PetActionIcon:SetTexture( Texture )
			PetActionButton.tooltipName = Name
		else
			PetActionIcon:SetTexture( _G[Texture] )
			PetActionButton.tooltipName = _G[Name]
		end

		PetActionButton.IsToken = IsToken
		PetActionButton.tooltipSubtext = SubText

		if( IsActive ) then
			PetActionButton:SetChecked( true )

			if( PetActionBackdrop ) then
				PetActionBackdrop:SetBackdropBorderColor( M['Colors']['oUF']['class'][A.MyClass][1], M['Colors']['oUF']['class'][A.MyClass][2], M['Colors']['oUF']['class'][A.MyClass][3] )
			end

			if( IsPetAttackAction( index ) ) then
				PetActionButton_StartFlash( PetActionButton )
			end
		else
			PetActionButton:SetChecked( false )

			if( PetActionBackdrop ) then
				PetActionBackdrop:SetBackdropBorderColor( M['Colors']['General']['Border']['r'], M['Colors']['General']['Border']['g'], M['Colors']['General']['Border']['b'], M['Colors']['General']['Border']['a'] )
			end

			if( IsPetAttackAction( index ) ) then
				PetActionButton_StopFlash( PetActionButton )
			end
		end

		if( AutoCastAllowed ) then
			PetAutoCastableTexture:Show()
		else
			PetAutoCastableTexture:Hide()
		end

		if( AutoCastEnabled ) then
			AutoCastShine_AutoCastStart( PetAutoCastShine )
		else
			AutoCastShine_AutoCastStop( PetAutoCastShine )
		end

		if( Texture ) then
			if( GetPetActionSlotUsable( index ) ) then
				SetDesaturation( PetActionIcon, nil )
			else
				SetDesaturation( PetActionIcon, 1 )
			end

			PetActionIcon:Show()
		else
			PetActionIcon:Hide()
		end

		if( not PetHasActionBar() and Texture and Name ~= 'PET_ACTION_FOLLOW' ) then
			PetActionButton_StopFlash( PetActionButton )
			SetDesaturation( PetActionIcon, 1 )
			PetActionButton:SetChecked( false )
		end

		if( sCoreCDB['ActionBars']['ActionBars_ShowHotKeyText'] ) then
			HotKey:ClearAllPoints()
			HotKey:Point( 'TOPRIGHT', 0, -2 )
			HotKey:SetFont( M['Fonts']['Normal'], 10, 'OUTLINE' )
			HotKey:SetShadowOffset( 0, 0 )
			HotKey['ClearAllPoints'] = S['Dummy']
			HotKey['SetPoint'] = S['Dummy']
		else
			HotKey:SetText( '' )
			HotKey:Kill()
		end
	end
end

local UpdateStanceBar = function( ... )
	if( InCombatLockdown() ) then
		return
	end

	local NumShapeshiftForms = GetNumShapeshiftForms()
	local Texture, Name, IsActive, IsCastable, Button, Icon, Cooldown, Start, Duration, Enable
	local STANCEBUTTON_SIZE = sCoreCDB['ActionBars']['ActionBars_StanceBar_ButtonSize']
	local STANCEBUTTON_SPACING = sCoreCDB['ActionBars']['ActionBars_StanceBar_ButtonSpacing']

	if( NumShapeshiftForms == 0 ) then
		StanceBar:SetAlpha( 0 )
	else
		StanceBar:SetAlpha( 1 )
		StanceBar:SetSize( ( STANCEBUTTON_SIZE * NumShapeshiftForms) + ( STANCEBUTTON_SPACING * ( NumShapeshiftForms + 1 ) ), STANCEBUTTON_SIZE + ( STANCEBUTTON_SPACING * 2 ) )

		for index = 1, NUM_STANCE_SLOTS do
			local ButtonName = 'StanceButton' .. index

			Button = _G[ButtonName]
			Icon = _G[ButtonName .. 'Icon']

			if( index <= NumShapeshiftForms ) then
				Texture, Name, IsActive, IsCastable = GetShapeshiftFormInfo( index )

				if( not Icon ) then
					return
				end

				Icon:SetTexture( Texture )
				Cooldown = _G[ButtonName .. 'Cooldown']

				if( Texture ) then
					Cooldown:SetAlpha( 1 )
				else
					Cooldown:SetAlpha( 0 )
				end

				Start, Duration, Enable = GetShapeshiftFormCooldown( index )
				CooldownFrame_Set( Cooldown, Start, Duration, Enable )

				if( IsActive ) then
					StanceBarFrame.lastSelected = Button:GetID()
					Button:SetChecked( true )

					if( Button['Backdrop'] ) then
						Button['Backdrop']:SetBackdropBorderColor( M['Colors']['oUF']['class'][A.MyClass][1], M['Colors']['oUF']['class'][A.MyClass][2], M['Colors']['oUF']['class'][A.MyClass][3] )
					end
				else
					Button:SetChecked( false )

					if( Button['Backdrop'] ) then
						Button['Backdrop']:SetBackdropBorderColor( M['Colors']['General']['Border']['r'], M['Colors']['General']['Border']['g'], M['Colors']['General']['Border']['b'], M['Colors']['General']['Border']['a'] )
					end
				end

				if( IsCastable ) then
					Icon:SetVertexColor( 1.0, 1.0, 1.0 )
				else
					Icon:SetVertexColor( 0.4, 0.4, 0.4 )
				end
			end
		end
	end
end

local AddHooks = function()
	hooksecurefunc( 'ActionButton_Update', SkinButtons )
	hooksecurefunc( 'ActionButton_UpdateFlyout', StyleFlyout )
	hooksecurefunc( 'SpellButton_OnClick', StyleFlyout )
	hooksecurefunc( 'ActionButton_OnUpdate', RangeOnUpdate )
	hooksecurefunc( 'ActionButton_Update', RangeUpdate )
	hooksecurefunc( 'ActionButton_UpdateUsable', RangeUpdate )
	hooksecurefunc( 'ActionButton_UpdateHotkeys', UpdateHotKeys )
	hooksecurefunc( 'PetActionButton_SetHotkeys', UpdateHotKeys )
end

local CreateBar1 = function()
	local MAINBUTTON_SIZE = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSize']
	local MAINCEBUTTON_SPACING = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSpacing']

	local Bar1 = ActionBar1
	local Druid, Rogue = '', ''

	if( sCoreCDB['ActionBars']['ActionBars_SwitchBarOnStance'] ) then
		Rogue = '[bonusbar:1] 7;'
		Druid = '[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;'
	end

	Bar1.Page = {
		['DRUID'] = Druid,
		['ROGUE'] = Rogue,
		['DEFAULT'] = '[vehicleui:12] 12; [possessbar] 12; [overridebar] 14; [shapeshift] 13; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;',
	}

	local UpdateBar1 = function()
		local Button
		for index = 1, NUM_ACTIONBAR_BUTTONS do
			Button = _G['ActionButton' .. index]
			Bar1:SetFrameRef( 'ActionButton' .. index, Button )
		end

		Bar1:Execute( [[
			Button = table.new()
			for index = 1, 12 do
				table.insert( Button, self:GetFrameRef( 'ActionButton' .. index ) )
			end
		]] )

		Bar1:SetAttribute( '_onstate-page', [[
			if( HasTempShapeshiftActionBar() ) then
				newstate = GetTempShapeshiftBarIndex() or newstate
			end

			for index, Button in ipairs( Button ) do
				Button:SetAttribute( 'actionpage', tonumber( newstate ) )
			end
		]] )

		RegisterStateDriver( Bar1, 'page', Bar1:GetBar() )
	end

	function Bar1:GetBar()
		local Condition = Bar1.Page['DEFAULT']
		local Class = S['MyClass']
		local Page = Bar1.Page[Class]

		if( Page ) then
			Condition = Condition .. ' ' .. Page
		end

		Condition = Condition .. ' [form] 1; 1'

		return Condition
	end

	UpdateBar1()

	Bar1:RegisterEvent( 'PLAYER_ENTERING_WORLD' )
	Bar1:RegisterEvent( 'KNOWN_CURRENCY_TYPES_UPDATE' )
	Bar1:RegisterEvent( 'CURRENCY_DISPLAY_UPDATE' )
	Bar1:RegisterEvent( 'BAG_UPDATE' )
	Bar1:SetScript( 'OnEvent', function( self, event, unit, ... )
		local Button, PreviousButton

		if( event == 'ACTIVE_TALENT_GROUP_CHANGED' ) then
			UpdateBar1()
		elseif( event == 'PLAYER_ENTERING_WORLD' ) then
			for index = 1, NUM_ACTIONBAR_BUTTONS do
				Button = _G['ActionButton' .. index]
				PreviousButton = _G['ActionButton' .. index - 1]

				Button:Size( MAINBUTTON_SIZE, MAINBUTTON_SIZE )
				Button:ClearAllPoints()
				Button:SetParent( self )

				if( index == 1 ) then
					Button:Point( 'BOTTOMLEFT', Bar1, 'BOTTOMLEFT', MAINCEBUTTON_SPACING, MAINCEBUTTON_SPACING )
				else
					Button:Point( 'LEFT', PreviousButton, 'RIGHT', MAINCEBUTTON_SPACING, 0 )
				end
			end
		else
			MainMenuBar_OnEvent( self, event, ... )
		end
	end )
end

local CreateBar2 = function()
	local MAINBUTTON_SIZE = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSize']
	local MAINCEBUTTON_SPACING = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSpacing']

	local Bar2 = ActionBar2
	local Button, PreviousButton

	MultiBarBottomLeft:SetParent( ActionBar2 )

	for index = 1, NUM_ACTIONBAR_BUTTONS do
		Button = _G['MultiBarBottomLeftButton' .. index]
		PreviousButton = _G['MultiBarBottomLeftButton' .. index - 1]

		Button:Size( MAINBUTTON_SIZE, MAINBUTTON_SIZE )
		Button:ClearAllPoints()
		Button:SetFrameStrata( 'BACKGROUND' )
		Button:SetFrameLevel( 15 )

		if( index == 1 ) then
			Button:Point( 'BOTTOMLEFT', Bar2, 'BOTTOMLEFT', MAINCEBUTTON_SPACING, MAINCEBUTTON_SPACING )
		else
			Button:Point( 'LEFT', PreviousButton, 'RIGHT', MAINCEBUTTON_SPACING, 0 )
		end
	end

	_G['MultiBarBottomLeftButton6']:SetParent( S['HiddenFrame'] )
	_G['MultiBarBottomLeftButton7']:SetParent( S['HiddenFrame'] )
	_G['MultiBarBottomLeftButton8']:SetParent( S['HiddenFrame'] )
	_G['MultiBarBottomLeftButton9']:SetParent( S['HiddenFrame'] )
	_G['MultiBarBottomLeftButton10']:SetParent( S['HiddenFrame'] )
	_G['MultiBarBottomLeftButton11']:SetParent( S['HiddenFrame'] )
	_G['MultiBarBottomLeftButton12']:SetParent( S['HiddenFrame'] )
end

local CreateBar3 = function()

end

local CreateBar4 = function()
	local BUTTON_SIZE = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSize']
	local BUTTON_SPACING = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSpacing']
	local ENABLE_VERTICALRIGHTBARS = sCoreCDB['ActionBars']['ActionBars_VerticalRightBars']

	local Bar4 = ActionBar4
	local Button, PreviousButton

	MultiBarBottomRight:SetParent( Bar4 )

	for index = 1, NUM_ACTIONBAR_BUTTONS do
		Button = _G['MultiBarBottomRightButton' .. index]
		PreviousButton = _G['MultiBarBottomRightButton' .. index - 1]

		Button:Size( BUTTON_SIZE, BUTTON_SIZE )
		Button:ClearAllPoints()
		Button:SetFrameStrata( 'BACKGROUND' )
		Button:SetFrameLevel( 15 )
		if( ENABLE_VERTICALRIGHTBARS ) then
			Button:SetAttribute( 'flyoutDirection', 'LEFT' )
		else
			Button:SetAttribute( 'flyoutDirection', 'UP' )
		end

		if( index == 1 ) then
			if( ENABLE_VERTICALRIGHTBARS ) then
				Button:Point( 'TOPRIGHT', _G['MultiBarRightButton1'], 'TOPLEFT', -BUTTON_SPACING, 0 )
			else
				Button:Point( 'BOTTOMLEFT', _G['MultiBarRightButton1'], 'TOPLEFT', 0, BUTTON_SPACING )
			end
		else
			if( ENABLE_VERTICALRIGHTBARS ) then
				Button:Point( 'TOP', PreviousButton, 'BOTTOM', 0, -BUTTON_SPACING )
			else
				Button:Point( 'LEFT', PreviousButton, 'RIGHT', BUTTON_SPACING, 0 )
			end
		end
	end
end

local CreateBar5 = function()

end

local CreateSplitBars = function()
	local BUTTON_SIZE = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSize']
	local BUTTON_SPACING = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSpacing']
	local ENABLE_SPLITBARS = sCoreCDB['ActionBars']['ActionBars_SplitBars']
	local ENABLE_VERTICALRIGHTBARS = sCoreCDB['ActionBars']['ActionBars_VerticalRightBars']

	local Button

	for index = 1, NUM_ACTIONBAR_BUTTONS do
		Button = _G['MultiBarLeftButton' .. index]

		Button:Size( BUTTON_SIZE, BUTTON_SIZE )
		Button:ClearAllPoints()
		Button:SetFrameStrata( 'BACKGROUND' )
		Button:SetFrameLevel( 15 )

		if( ENABLE_SPLITBARS ) then
			Button:SetAttribute( 'flyoutDirection', 'UP' )
		else
			Button:Size( BUTTON_SIZE, BUTTON_SIZE )
			if( ENABLE_VERTICALRIGHTBARS ) then
				Button:SetAttribute( 'flyoutDirection', 'LEFT' )
			else
				Button:SetAttribute( 'flyoutDirection', 'UP' )
			end
		end
	end
end

local CreateRightBar = function()
	local BUTTON_SIZE = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSize']
	local BUTTON_SPACING = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSpacing']
	local ENABLE_VERTICALRIGHTBARS = sCoreCDB['ActionBars']['ActionBars_VerticalRightBars']

	local Bar = RightActionBar
	local Button, PreviousButton

	MultiBarRight:SetParent( Bar )

	for index = 1, NUM_ACTIONBAR_BUTTONS do
		Button = _G['MultiBarRightButton' .. index]
		PreviousButton = _G['MultiBarRightButton' .. index - 1]

		Button:Size( BUTTON_SIZE, BUTTON_SIZE )
		Button:ClearAllPoints()
		Button:SetFrameStrata( 'BACKGROUND' )
		Button:SetFrameLevel( 15 )

		if( ENABLE_VERTICALRIGHTBARS ) then
			Button:SetAttribute( 'flyoutDirection', 'LEFT' )
		else
			Button:SetAttribute( 'flyoutDirection', 'UP' )
		end

		if( index == 1 ) then
			if( ENABLE_VERTICALRIGHTBARS ) then
				Button:Point( 'TOPRIGHT', Bar, -5, -5 )
			else
				Button:Point( 'BOTTOMLEFT', Bar, 5, 5 )
			end
		else
			if( ENABLE_VERTICALRIGHTBARS ) then
				Button:Point( 'TOP', PreviousButton, 'BOTTOM', 0, -BUTTON_SPACING )
			else
				Button:Point( 'LEFT', PreviousButton, 'RIGHT', BUTTON_SPACING, 0 )
			end
		end
	end
end

local CreateStanceBar = function()
	local STANCEBUTTON_SIZE = sCoreCDB['ActionBars']['ActionBars_StanceBar_ButtonSize']
	local STANCEBUTTON_SPACING = sCoreCDB['ActionBars']['ActionBars_StanceBar_ButtonSpacing']

	local Button, PreviousButton

	StanceBarFrame.ignoreFramePositionManager = true
	--StanceBarFrame:StripTextures()
	StanceBarFrame:SetParent( StanceBar )
	StanceBarFrame:ClearAllPoints()
	StanceBarFrame:SetPoint( 'TOPLEFT', StanceBar, 'TOPLEFT', 0, 0 )
	StanceBarFrame:EnableMouse( false )

	for index = 1, NUM_STANCE_SLOTS do
		Button = _G['StanceButton' .. index]
		Button:Show()

		if( index ~= 1 ) then
			PreviousButton = _G['StanceButton' .. index - 1]

			Button:ClearAllPoints()
			Button:Point( 'LEFT', PreviousButton, 'RIGHT', STANCEBUTTON_SPACING, 0 )
		else
			Button:ClearAllPoints()
			Button:Point( 'BOTTOMLEFT', StanceBar, 'BOTTOMLEFT', STANCEBUTTON_SPACING, STANCEBUTTON_SPACING )
		end
	end

	RegisterStateDriver( StanceBar, 'visibility', '[vehicleui][petbattle] hide; show' )

	StanceBar:RegisterEvent( 'PLAYER_ENTERING_WORLD' )
	StanceBar:RegisterEvent( 'UPDATE_SHAPESHIFT_FORMS' )
	StanceBar:RegisterEvent( 'UPDATE_SHAPESHIFT_USABLE' )
	StanceBar:RegisterEvent( 'UPDATE_SHAPESHIFT_COOLDOWN' )
	StanceBar:RegisterEvent( 'UPDATE_SHAPESHIFT_FORM' )
	StanceBar:RegisterEvent( 'ACTIONBAR_PAGE_CHANGED' )
	StanceBar:RegisterEvent( 'PLAYER_TALENT_UPDATE' )
	StanceBar:RegisterEvent( 'SPELLS_CHANGED' )
	StanceBar:SetScript( 'OnEvent', function( self, event, ... )
		if( event == 'UPDATE_SHAPESHIFT_FORMS' ) then

		elseif( event == 'PLAYER_ENTERING_WORLD' ) then
			UpdateStanceBar( self )
			SkinStanceButtons()
		else
			UpdateStanceBar( self )
		end
	end )

	RegisterStateDriver( StanceBar, 'visibility', '[vehicleui][petbattle][overridebar] hide; show' )
end

local CreatePetBar = function()
	local ENABLE_VERTICALRIGHTBARS = sCoreCDB['ActionBars']['ActionBars_VerticalRightBars']
	local PETBUTTON_SIZE = sCoreCDB['ActionBars']['ActionBars_PetBar_ButtonSize']
	local PETBUTTON_SPACING = sCoreCDB['ActionBars']['ActionBars_PetBar_ButtonSpacing']

	local PetActionBarFrame = PetActionBarFrame
	local PetActionBar_UpdateCooldowns = PetActionBar_UpdateCooldowns
	local Button, PreviousButton

	PetActionBarFrame:UnregisterEvent( 'PET_BAR_SHOWGRID' )
	PetActionBarFrame:UnregisterEvent( 'PET_BAR_HIDEGRID' )
	PetActionBarFrame.showgrid = 1

	for index = 1, NUM_PET_ACTION_SLOTS do
		Button = _G['PetActionButton' .. index]
		PreviousButton = _G['PetActionButton' .. ( index - 1 )]

		Button:ClearAllPoints()
		Button:SetParent( PetActionBar )
		Button:Size( PETBUTTON_SIZE, PETBUTTON_SIZE )
		Button:Show()

		if( index == 1 ) then
			Button:Point( 'TOPLEFT', 5, -5 )
		else
			if( ENABLE_VERTICALRIGHTBARS ) then
				Button:Point( 'TOP', PreviousButton, 'BOTTOM', 0, -PETBUTTON_SPACING )
			else
				Button:Point( 'LEFT', PreviousButton, 'RIGHT', PETBUTTON_SPACING, 0 )
			end
		end

		PetActionBar:SetAttribute( 'addchild', Button )
	end

	hooksecurefunc( 'PetActionBar_Update', UpdatePetBar )

	SkinPetButtons()

	RegisterStateDriver( PetActionBar, 'visibility', '[pet,nopetbattle,novehicleui,nooverridebar,nobonusbar:5] show; hide' )

	PetActionBar:RegisterEvent( 'PLAYER_CONTROL_LOST' )
	PetActionBar:RegisterEvent( 'PLAYER_CONTROL_GAINED' )
	PetActionBar:RegisterEvent( 'PLAYER_FARSIGHT_FOCUS_CHANGED' )
	PetActionBar:RegisterEvent( 'PET_BAR_UPDATE' )
	PetActionBar:RegisterEvent( 'PET_BAR_UPDATE_USABLE' )
	PetActionBar:RegisterEvent( 'PET_BAR_UPDATE_COOLDOWN' )
	PetActionBar:RegisterEvent( 'PET_BAR_HIDE' )
	PetActionBar:RegisterEvent( 'UNIT_PET' )
	PetActionBar:RegisterEvent( 'UNIT_FLAGS' )
	PetActionBar:RegisterEvent( 'UNIT_AURA' )
	PetActionBar:SetScript( 'OnEvent', function( self, event, arg1 )
		if( event == 'PET_BAR_UPDATE' )
			or ( event == 'UNIT_PET' and arg1 == 'player' )
			or ( event == 'PLAYER_CONTROL_LOST' )
			or ( event == 'PLAYER_CONTROL_GAINED' )
			or ( event == 'PLAYER_FARSIGHT_FOCUS_CHANGED' )
			or ( event == 'UNIT_FLAGS' )
			or ( arg1 == 'pet' and ( event == 'UNIT_AURA' ) ) then
				UpdatePetBar()
		elseif( event == 'PET_BAR_UPDATE_COOLDOWN' ) then
			PetActionBar_UpdateCooldowns()
		else
			SkinPetButtons()
		end
	end )
end

local BuildMainBars = function()
	local ENABLE_SPLITBARS = sCoreCDB['ActionBars']['ActionBars_SplitBars']

	local Button
	local ActionBar1 = ActionBar1
	local ActionBar2 = ActionBar2
	local ActionBar3 = ActionBar3
	local SplitBarLeft = ActionBarSplitBarLeft
	local SplitBarRight = ActionBarSplitBarRight
	local ActionBar1LeftLine1 = ActionBar1LeftLine1
	local ActionBar1RightLine1 = ActionBar1RightLine1
	local MultiBarLeft = MultiBarLeft

	RegisterStateDriver( ActionBar2, 'visibility', '[vehicleui][petbattle][overridebar] hide; show' )
	ActionBar2:Show()

	if( ENABLE_SPLITBARS ) then
		MultiBarLeft:ClearAllPoints()
		MultiBarLeft:SetParent( SplitBarLeft )

		for index = 7, 12 do
			Button = _G['MultiBarLeftButton' .. index]
			Button:SetAlpha( 1 )
			Button:SetScale( 1 )
		end

		ActionBar1LeftLine1:ClearAllPoints()
		ActionBar1LeftLine1:Point( 'RIGHT', SplitBarLeft, 'LEFT', 0, -16 )

		ActionBar1RightLine1:ClearAllPoints()
		ActionBar1RightLine1:Point( 'LEFT', SplitBarRight, 'RIGHT', 0, -16 )
	else
		MultiBarLeft:ClearAllPoints()
		MultiBarLeft:SetParent( ActionBar3 )

		ActionBar1LeftLine1:ClearAllPoints()
		ActionBar1LeftLine1:Point( 'RIGHT', ActionBar1, 'LEFT', 0, 0 )

		ActionBar1RightLine1:ClearAllPoints()
		ActionBar1RightLine1:Point( 'LEFT', ActionBar1, 'RIGHT', 0, 0 )
	end
end

local BuildRightBars = function()
	local BUTTON_SIZE = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSize']
	local BUTTON_SPACING = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSpacing']
	local NUM_RIGHTBARS = sCoreCDB['ActionBars']['ActionBars_NumRightBars']
	local ENABLE_SPLITBARS = sCoreCDB['ActionBars']['ActionBars_SplitBars']
	local ENABLE_VERTICALRIGHTBARS = sCoreCDB['ActionBars']['ActionBars_VerticalRightBars']

	local Button, PreviousButton

	local ActionBar3 = ActionBar3
	local ActionBar4 = ActionBar4
	local RightActionBar = RightActionBar
	local PetActionBar = PetActionBar
	local MultiBarLeft = MultiBarLeft
	local GridBackground = GridBackground

	if( NUM_RIGHTBARS >= 1 ) then
		PetActionBar:ClearAllPoints()

		if( ENABLE_VERTICALRIGHTBARS ) then
			if( not sCoreCDB['ChatFrames']['ChatFrames_Backgrounds'] ) then
				PetActionBar:Point( 'RIGHT', RightActionBar, 'LEFT', -3, 0 )
			else
				PetActionBar:Point( 'BOTTOMRIGHT', RightActionBar, 'BOTTOMLEFT', -3, 0 )
			end
		else
			PetActionBar:Point( 'BOTTOMRIGHT', RightActionBar, 'TOPRIGHT', 0, 6 )
		end
	else
		PetActionBar:ClearAllPoints()

		if( ENABLE_VERTICALRIGHTBARS ) then
			PetActionBar:Point( 'BOTTOMRIGHT', GridBackground, 'TOPRIGHT', 0, 6 )
		else
			PetActionBar:Point( 'RIGHT', UIParent, 'RIGHT', -8, 0 )
		end
	end

	if( NUM_RIGHTBARS == 1 ) then
		RegisterStateDriver( RightActionBar, 'visibility', '[vehicleui][petbattle][overridebar] hide; show' )
		UnregisterStateDriver( ActionBar4, 'visibility' )
		RightActionBar:Show()
		ActionBar4:Hide()

		if( ENABLE_VERTICALRIGHTBARS ) then
			RightActionBar:Width( ( BUTTON_SIZE + BUTTON_SPACING * 2 ) + 2 )
			RightActionBar:Height( ( BUTTON_SIZE * 12 + BUTTON_SPACING * ( 12 + 1 ) ) + 2 )
		else
			RightActionBar:Height( ( BUTTON_SIZE + BUTTON_SPACING * 2 ) + 2 )
		end

		if( ENABLE_SPLITBARS ~= true and ActionBar3:IsShown() ) then
			MultiBarLeft:ClearAllPoints()
			MultiBarLeft:SetParent( ActionBar3 )
			UnregisterStateDriver( ActionBar3, 'visibility' )
			ActionBar3:Hide()
		end
	elseif( NUM_RIGHTBARS == 2 ) then
		RegisterStateDriver( RightActionBar, 'visibility', '[vehicleui][petbattle][overridebar] hide; show' )
		RegisterStateDriver( ActionBar4, 'visibility', '[vehicleui][petbattle][overridebar] hide; show' )
		RightActionBar:Show()
		ActionBar4:Show()

		if( ENABLE_VERTICALRIGHTBARS ) then
			RightActionBar:Width( ( BUTTON_SIZE * 2 + BUTTON_SPACING * 3 ) + 2 )
			RightActionBar:Height( ( BUTTON_SIZE * 12 + BUTTON_SPACING * ( 12 + 1 ) ) + 2 )
		else
			RightActionBar:Height( ( BUTTON_SIZE * 2 + BUTTON_SPACING * 3 ) + 2 )
		end

		if( ENABLE_SPLITBARS ~= true and ActionBar3:IsShown() ) then
			MultiBarLeft:ClearAllPoints()
			MultiBarLeft:SetParent( ActionBar3 )
			UnregisterStateDriver( ActionBar3, 'visibility' )
			ActionBar3:Hide()
		end
	elseif( NUM_RIGHTBARS == 3 ) then
		RegisterStateDriver( RightActionBar, 'visibility', '[vehicleui][petbattle][overridebar] hide; show' )
		RegisterStateDriver( ActionBar4, 'visibility', '[vehicleui][petbattle][overridebar] hide; show' )
		RightActionBar:Show()
		ActionBar4:Show()

		if( ENABLE_VERTICALRIGHTBARS ) then
			RightActionBar:Width( ( BUTTON_SIZE * 3 + BUTTON_SPACING * 4 ) + 2 )
			RightActionBar:Height( ( BUTTON_SIZE * 12 + BUTTON_SPACING * ( 12 + 1 ) ) + 2 )
		else
			RightActionBar:Height( ( BUTTON_SIZE * 3 + BUTTON_SPACING * 4 ) + 2 )
		end

		if( not ENABLE_SPLITBARS ) then
			MultiBarLeft:ClearAllPoints()
			MultiBarLeft:SetParent( ActionBar3 )
			RegisterStateDriver( ActionBar3, 'visibility', '[vehicleui][petbattle][overridebar] hide; show' )
			ActionBar3:Show()

			for index = 1, 12 do
				Button = _G['MultiBarLeftButton' .. index]
				PreviousButton = _G['MultiBarLeftButton' .. index - 1]

				Button:Size( BUTTON_SIZE, BUTTON_SIZE )
				Button:ClearAllPoints()

				if( index == 1 ) then
					Button:Point( 'TOPLEFT', RightActionBar, 5, -5 )
				else
					if( not ENABLE_SPLITBARS and ENABLE_VERTICALRIGHTBARS == true ) then
						Button:Point( 'TOP', PreviousButton, 'BOTTOM', 0, -BUTTON_SPACING )
					else
						Button:Point( 'LEFT', PreviousButton, 'RIGHT', BUTTON_SPACING, 0 )
					end
				end
			end
		end
	elseif( NUM_RIGHTBARS == 0 ) then
		UnregisterStateDriver( RightActionBar, 'visibility' )
		UnregisterStateDriver( ActionBar4, 'visibility' )
		RightActionBar:Hide()
		ActionBar4:Hide()

		if( not ENABLE_SPLITBARS ) then
			MultiBarLeft:ClearAllPoints()
			MultiBarLeft:SetParent( ActionBar3 )
			UnregisterStateDriver( ActionBar3, 'visibility' )
			ActionBar3:Hide()
		end
	end
end

local BuildSplitBars = function()
	local BUTTON_SIZE = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSize']
	local BUTTON_SPACING = sCoreCDB['ActionBars']['ActionBars_MainBar_ButtonSpacing']
	local NUM_RIGHTBARS = sCoreCDB['ActionBars']['ActionBars_NumRightBars']
	local ENABLE_SPLITBARS = sCoreCDB['ActionBars']['ActionBars_SplitBars']
	local ENABLE_VERTICALRIGHTBARS = sCoreCDB['ActionBars']['ActionBars_VerticalRightBars']

	local Button, PreviousButton

	local ActionBar3 = ActionBar3
	local SplitBarLeft = ActionBarSplitBarLeft
	local SplitBarRight = ActionBarSplitBarRight
	local RightActionBar = RightActionBar
	local MultiBarLeft = MultiBarLeft

	if( ENABLE_SPLITBARS ) then
		MultiBarLeft:ClearAllPoints()
		MultiBarLeft:SetParent( SplitBarLeft )

		for index = 1, 12 do
			Button = _G['MultiBarLeftButton' .. index]
			PreviousButton = _G['MultiBarLeftButton' .. index - 1]

			Button:ClearAllPoints()
			if( index == 1 ) then
				Button:Point( 'BOTTOMLEFT', SplitBarLeft, 5, 5 )
			else
				if( index == 4 ) then
					Button:Point( 'BOTTOMLEFT', SplitBarRight, 5, 5 )
				elseif( index == 7 ) then
					Button:Point( 'BOTTOMLEFT', _G['MultiBarLeftButton1'], 'TOPLEFT', 0, BUTTON_SPACING )
				elseif( index == 10 ) then
					Button:Point( 'BOTTOMLEFT', _G['MultiBarLeftButton4'], 'TOPLEFT', 0, BUTTON_SPACING )
				else
					Button:Point( 'LEFT', PreviousButton, 'RIGHT', BUTTON_SPACING, 0 )
				end
			end
		end

		if( NUM_RIGHTBARS == 3 ) then
			RegisterStateDriver( RightActionBar, 'visibility', '[vehicleui][petbattle][overridebar] hide; show' )
			RightActionBar:Show()

			if( ENABLE_VERTICALRIGHTBARS ) then
				RightActionBar:Width( ( BUTTON_SIZE * 2 + BUTTON_SPACING * 3 ) + 2 )
			else
				RightActionBar:Height( ( BUTTON_SIZE * 2 + BUTTON_SPACING * 3 ) + 2 )
			end
		end

		for index = 7, 12 do
			Button = _G['MultiBarLeftButton' .. index]
			Button:SetAlpha( 1 )
			Button:SetScale( 1 )
		end

		RegisterStateDriver( SplitBarLeft, 'visibility', '[vehicleui][petbattle][overridebar] hide; show' )
		RegisterStateDriver( SplitBarRight, 'visibility', '[vehicleui][petbattle][overridebar] hide; show' )

		SplitBarLeft:Show()
		SplitBarRight:Show()
	elseif( not ENABLE_SPLITBARS ) then
		MultiBarLeft:ClearAllPoints()
		MultiBarLeft:SetParent( ActionBar3 )

		for index = 1, 12 do
			Button = _G['MultiBarLeftButton' .. index]
			PreviousButton = _G['MultiBarLeftButton' .. index - 1]

			Button:ClearAllPoints()
			if( index == 1 ) then
				Button:Point( 'TOPLEFT', RightActionBar, 5, -5 )
			else
				Button:Point( 'LEFT', PreviousButton, 'RIGHT', BUTTON_SPACING, 0 )
			end
		end

		BuildRightBars()

		for index = 7, 12 do
			Button = _G['MultiBarLeftButton' .. index]
			Button:SetAlpha( 1 )
			Button:SetScale( 1 )
		end

		UnregisterStateDriver( SplitBarLeft, 'visibility' )
		UnregisterStateDriver( SplitBarRight, 'visibility' )

		SplitBarLeft:Hide()
		SplitBarRight:Hide()
	end
end

S['ActionBars_Init'] = function()
	DisableBlizzard()

	CreateBar1()
	CreateBar2()
	CreateBar3()
	CreateBar4()
	CreateBar5()
	CreateSplitBars()
	CreateRightBar()
	CreateStanceBar()
	CreatePetBar()
	--CreateExtraBar()
	--CreateVehicleButton()

	BuildMainBars()
	BuildRightBars()
	BuildSplitBars()

	ShowGrid()

	AddHooks()
end
