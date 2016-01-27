--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

S['CheckRole'] = function()
	local Role
	local Tree = GetSpecialization()
	local Class = S['MyClass']

	if( ( Class == 'MONK' and Tree == 2 ) or ( Class == 'PRIEST' and ( Tree == 1 or Tree == 2 ) ) or ( Class == 'PALADIN' and Tree == 1 ) or ( Class == 'DRUID' and Tree == 4 ) or ( Class == 'SHAMAN' and Tree == 3 ) ) then
		Role = 'Healer'
	else
		Role = 'DPS'
	end

	return Role
end












S['GUIFunction_CreateResetButton'] = function( Parent, Name, Function )
	if( not Parent or not Name ) then
		return
	end

	local GUI = ConfigUI

	local Button = CreateFrame( 'Button', Name .. 'ResetButton', Parent )
	Button:Point( 'BOTTOM', GUI['ReloadUIButton'], 'TOP', 0, 10 )
	Button:Size( 100, 25 )
	Button:ApplySkin( 'Button' )

	Button['Text'] = S['Construct_FontString']( Button, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'CENTER', false )
	Button['Text']:Point( 'CENTER', Button, 'CENTER', 0, 0 )
	Button['Text']:SetText( RESET )

	return Button
end

S['GUIFunction_CreateTab'] = function( Text, Frame, Parent, Orientation )
	local MyClass = S['MyClass']

	local Tab = Parent['Tab' .. Parent.TabIndex]
	Tab:SetFrameLevel( Parent:GetFrameLevel() + 2 )
	Tab:ApplyStyle( nil, true )

	Tab['Number'] = Parent['TabIndex']
	Tab['FrameName'] = Frame:GetName()

	Tab['Name'] = S['Construct_FontString']( Tab, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'LEFT', false )
	Tab['Name']:SetText( Text )

	if( Orientation == 'VERTICAL' ) then
		Tab['Name']:Point( 'LEFT', Tab, 'LEFT', 10, 0 )
		Tab:Size( 130, 25 )
		Tab:ApplyOverlay()

		if( Tab['Number'] == 1 ) then
			Tab:SetBackdropBorderColor( M['Colors']['oUF']['Class'][MyClass][1], M['Colors']['oUF']['Class'][MyClass][2], M['Colors']['oUF']['Class'][MyClass][3] )
		end

		Tab:HookScript( 'OnMouseDown', function( self )
			Frame:Show()
			self:Point( 'TOPLEFT', Parent, 'TOPRIGHT', 8, -28 * Tab['Number'] )
			Tab:SetBackdropBorderColor( M['Colors']['oUF']['Class'][MyClass][1], M['Colors']['oUF']['Class'][MyClass][2], M['Colors']['oUF']['Class'][MyClass][3] )
		end )

		if( Tab['Number'] == 1 ) then
			Tab:Point( 'TOPLEFT', Parent, 'TOPRIGHT', 8, -28 )
		else
			Tab:Point( 'TOPLEFT', Parent, 'TOPRIGHT', 3, -28 * Tab['Number'] )
		end

		for i = 1, Parent['TabNumbers'] do
			if( i ~= Tab['Number'] ) then
				Parent['Tab' .. i]:HookScript( 'OnMouseDown', function( self )
					Frame:Hide()
					Tab:Point( 'TOPLEFT', Parent, 'TOPRIGHT', 3, -28 * Tab['Number'] )
					Tab:ApplyStyle( nil, true )
				end )
			end
		end
	else
		Tab['Name']:SetJustifyH( 'CENTER' )
		Tab['Name']:Point( 'CENTER', Tab, 'CENTER', 0, 0 )
		Tab:Size( Tab['Name']:GetWidth() + 10, 25 )
		Tab:ApplyOverlay()

		if( Tab['Number'] == 1 ) then
			Tab:SetBackdropBorderColor( M['Colors']['oUF']['Class'][MyClass][1], M['Colors']['oUF']['Class'][MyClass][2], M['Colors']['oUF']['Class'][MyClass][3] )
		end

		Tab:HookScript( 'OnMouseDown', function( self )
			Frame:Show()
			Tab:SetBackdropBorderColor( M['Colors']['oUF']['Class'][MyClass][1], M['Colors']['oUF']['Class'][MyClass][2], M['Colors']['oUF']['Class'][MyClass][3] )
		end )

		for i = 1, Parent['TabNumbers'] do
			if( i == 1 ) then
				Parent['Tab' .. i]:Point( 'BOTTOMLEFT', Parent, 'TOPLEFT', 15, 2 )
			else
				Parent['Tab' .. i]:Point( 'LEFT', Parent['Tab' .. i - 1], 'RIGHT', 4, 0 )
			end

			if( i ~= Tab['Number'] ) then
				Parent['Tab' .. i]:HookScript( 'OnMouseDown', function( self )
					Frame:Hide()
					Tab:ApplyStyle( nil, true )
				end )
			end
		end
	end

	Parent['TabIndex'] = Parent['TabIndex'] + 1
end

S['GUIFunction_CreateOptionPage'] = function( Name, Title, Parent, Orientation, Scroll, Sub )
	local Options = CreateFrame( 'Frame', 'ConfigUIMainFrame' .. Name, Parent )

	S['GUIFunction_CreateTab']( Title, Options, Parent, Orientation )

	Options:SetAllPoints( Parent )
	Options:Hide()

	Options:SetScript( 'OnShow', function( self )
		PlaySound( 'igCharacterInfoTab' )
	end )

	Options['Title'] = S['Construct_FontString']( Options, 'OVERLAY', M['Fonts']['Normal'], 16, 'OUTLINE', 'LEFT', false )
	Options['Title']:Point( 'TOPLEFT', Options, 'TOPLEFT', 35, ( Sub and -23 or -73 ) )
	Options['Title']:SetText( Title )

	Options['Line'] = Options:CreateTexture( nil, 'ARTWORK' )
	Options['Line']:Point( 'TOP', Options, 'TOP', 0, ( Sub and -50 or -100 ) )
	Options['Line']:Size( Parent:GetWidth() - 50, 1 )
	Options['Line']:SetTexture( 0.125, 0.125, 0.125, 1 )

	if( Scroll ) then
		Options['SF'] = CreateFrame( 'ScrollFrame', Name .. ' ScrollFrame', Options, 'UIPanelScrollFrameTemplate' )
		Options['SF']:Point( 'TOPLEFT', Options, 'TOPLEFT', 10, -130 )
		Options['SF']:Point( 'BOTTOMRIGHT', Options, 'BOTTOMRIGHT', -45, 35 )
		Options['SF']:SetFrameLevel( Options:GetFrameLevel() + 1 )

		Options['SFAnchor'] = CreateFrame( 'Frame', Name .. ' ScrollAnchor', Options['SF'] )
		Options['SFAnchor']:Point( 'TOPLEFT', Options['SF'], 'TOPLEFT', 0, -3 )
		Options['SFAnchor']:Width( Options['SF']:GetWidth() - 30 )
		Options['SFAnchor']:Height( Options['SF']:GetHeight() + 200 )
		Options['SFAnchor']:SetFrameLevel( Options['SF']:GetFrameLevel() + 1 )

		Options['SF']:SetScrollChild( Options['SFAnchor'] )

		_G[Name .. 'ScrollFrameScrollBar']:ApplySkin( 'Scroll' )
	end

	return Options
end

S['GUIFunction_CreateOptionCheckButton'] = function( Parent, X, Y, Name, Table, Value, Tooltip, Function )
	local CheckButton = CreateFrame( 'CheckButton', Value .. 'Button', Parent, 'InterfaceOptionsCheckButtonTemplate' )
	CheckButton:Point( 'TOPLEFT', Parent, 'TOPLEFT', X, -Y )
	CheckButton:ApplySkin( 'CheckBox' )

	_G[CheckButton:GetName() .. 'Text']:SetText( Name )

	CheckButton:SetScript( 'OnShow', function( self )
		self:SetChecked( sCoreCDB[Table][Value] )
	end )

	CheckButton:SetScript( 'OnClick', function( self )
		PlaySound( self:GetChecked() and 'igMainMenuOptionCheckBoxOn' or 'igMainMenuOptionCheckBoxOff' )

		if( self:GetChecked() ) then
			sCoreCDB[Table][Value] = true
		else
			sCoreCDB[Table][Value] = false
		end

		if( Function ) then
			S[Function]()
		end
	end )

	if( Tooltip ) then
		CheckButton:SetScript( 'OnEnter', function( self )
			GameTooltip:SetOwner( self, 'ANCHOR_RIGHT', -20, 10 )
			GameTooltip:AddLine( Tooltip )
			GameTooltip:Show()
		end)

		CheckButton:SetScript( 'OnLeave', function( self )
			GameTooltip:Hide()
		end )
	end

	Parent[Value] = CheckButton
end

S['GUIOptionsSlider_OnValueChanged'] = function( self, value )
	if( not self._onsetting ) then
		self._onsetting = true
		self:SetValue( self:GetValue() )
		value = self:GetValue()

		self._onsetting = false
	else
		return
	end
end

S['GUIFunction_CreateOptionSlider'] = function( Parent, X, Y, Name, Table, Value, Divisor, Min, Max, Step, Tooltip, Function )
	local Slider = CreateFrame( 'Slider', Value .. 'Slider', Parent, 'OptionsSliderTemplate' )
	Slider:Point( 'TOPLEFT', Parent, 'TOPLEFT', X, -Y )
	Slider:Width( 220 )
	Slider:ApplySkin( 'Slider' )

	BlizzardOptionsPanel_Slider_Enable( Slider )

	Slider:SetMinMaxValues( Min, Max )

	_G[Slider:GetName() .. 'Low']:SetText( Min / Divisor )
	_G[Slider:GetName() .. 'High']:SetText( Max / Divisor )

	Slider:SetValueStep( Step )

	Slider:SetScript( 'OnShow', function( self )
		self:SetValue( ( sCoreCDB[Table][Value] ) * Divisor )
		_G[Slider:GetName() .. 'Text']:SetFormattedText( '%s |cff00ffff%s|r', Name, sCoreCDB[Table][Value] )
	end )

	Slider:SetScript( 'OnValueChanged', function( self, getvalue )
		sCoreCDB[Table][Value] = getvalue / Divisor
		S['GUIOptionsSlider_OnValueChanged']( self, getvalue )
		_G[Slider:GetName() .. 'Text']:SetFormattedText( '%s |cff00ffff%s|r', Name, sCoreCDB[Table][Value] )
	end )

	if( Tooltip ) then
		Slider.tooltipText = Tooltip
	end

	if( Function ) then
		S[Function]()
	end

	Parent[Value] = Slider
end

S['GUIFunction_CreateEditBox'] = function( Parent, X, Y, Name, Table, Value, Tooltip )
	local EditBox = CreateFrame( 'EditBox', Value .. 'EditBox', Parent )
	EditBox:Point( 'TOPLEFT', X, -Y )
	EditBox:Size( 180, 20 )
	EditBox:ApplySkin( 'Edit' )

	EditBox['Title'] = S['Construct_FontString']( EditBox, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'LEFT', false )
	EditBox['Title']:Point( 'LEFT', EditBox, 'RIGHT', 10, 1 )
	EditBox['Title']:SetText( Name )

	EditBox:SetFont( M['Fonts']['Normal'], 12, 'OUTLINE' )
	EditBox:SetAutoFocus( false )
	EditBox:SetTextInsets( 3, 0, 0, 0 )

	EditBox:SetScript( 'OnShow', function( self )
		self:SetText( sCoreCDB[Table][Value] )
	end )

	EditBox:SetScript( 'OnEscapePressed', function( self )
		self:SetText( sCoreCDB[Table][Value] )
		self:ClearFocus()
	end )

	EditBox:SetScript( 'OnEnterPressed', function( self )
		self:ClearFocus()
		sCoreCDB[Table][Value] = self:GetText()
	end )

	if( Tooltip ) then
		EditBox:SetScript( 'OnEnter', function( self )
			GameTooltip:SetOwner( self, 'ANCHOR_RIGHT', -20, 10 )
			GameTooltip:AddLine( Tooltip )
			GameTooltip:Show()
		end )

		EditBox:SetScript( 'OnLeave', function( self )
			GameTooltip:Hide()
		end )
	end

	Parent[Value] = EditBox
end

S['GUIFunction_CreateRadioButtonGroup'] = function( Parent, X, Y, Name, Table, Value, Group, Tooltip )
	local RadioButton = CreateFrame( 'Frame', Value .. 'RadioButtonGroup', Parent )
	RadioButton:Point( 'TOPLEFT', Parent, 'TOPLEFT', X, -Y )
	RadioButton:Size( 150, 30 )

	for k, v in pairs( Group ) do
		RadioButton[k] = CreateFrame( 'CheckButton', Value .. k .. 'RadioButtonGroup', RadioButton, 'UIRadioButtonTemplate' )

		_G[RadioButton[k]:GetName() .. 'Text']:SetText( v )

		RadioButton[k]:SetScript( 'OnShow', function( self )
			self:SetChecked( sCoreCDB[Table][Value] == k )
		end )

		RadioButton[k]:SetScript( 'OnClick', function( self )
			if( self:GetChecked() ) then
				sCoreCDB[Table][Value] = k
			else
				self:SetChecked( true )
			end
		end )
	end

	for k, v in pairs( Group ) do
		RadioButton[k]:HookScript( 'OnClick', function( self )
			if( sCoreCDB[Table][Value] == k ) then
				for key, value in pairs( Group ) do
					if( key ~= k ) then
						RadioButton[key]:SetChecked( false )
					end
				end
			end
		end )
	end

	RadioButton['Name'] = S['Construct_FontString']( RadioButton, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'LEFT', false )
	RadioButton['Name']:SetText( Name )

	local RadioButtons = { RadioButton:GetChildren() }
	for i = 1, #RadioButtons do
		if( i == 1 ) then
			RadioButtons[i]:Point( 'LEFT', 5, -10 )
		else
			RadioButtons[i]:Point( 'LEFT', _G[RadioButtons[i - 1]:GetName() .. 'Text'], 'RIGHT', 5, 0 )
		end

		if( i == #RadioButtons ) then
			RadioButton['Name']:Point( 'LEFT', _G[RadioButtons[i]:GetName() .. 'Text'], 'RIGHT', 10, 1 )
		else
			RadioButton['Name']:Point( 'TOPLEFT', Parent, 'TOPLEFT', X, -Y )
		end
	end

	Parent[Value] = RadioButton
end

S['GUIFunction_CreateColorPickerButton'] = function( Parent, X, Y, Name, Table, Value, Tooltip )
	local ColorPickerButton = CreateFrame( 'Button', Value .. 'ColorPickerButton', Parent, 'UIPanelButtonTemplate' )
	ColorPickerButton:Point( 'TOPLEFT', Parent, 'TOPLEFT', X, -Y )
	ColorPickerButton:Size( 20, 20 )
	ColorPickerButton:ApplyStyle()

	ColorPickerButton['Texture'] = ColorPickerButton:CreateTexture( nil, 'OVERLAY' )
	ColorPickerButton['Texture']:SetTexture( M['Textures']['StatusBar'] )
	ColorPickerButton['Texture']:SetPoint( 'CENTER' )
	ColorPickerButton['Texture']:SetInside()

	ColorPickerButton['Name'] = S['Construct_FontString']( ColorPickerButton, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'LEFT', false )
	ColorPickerButton['Name']:Point( 'LEFT', ColorPickerButton, 'RIGHT', 10, 1 )
	ColorPickerButton['Name']:SetText( Name )

	ColorPickerButton:SetScript( 'OnShow', function( self )
		self['Texture']:SetVertexColor( sCoreCDB[Table][Value].r, sCoreCDB[Table][Value].g, sCoreCDB[Table][Value].b )
	end )

	ColorPickerButton:SetScript( 'OnClick', function( self )
		local r, g, b, a = sCoreCDB[Table][Value]['r'], sCoreCDB[Table][Value]['g'], sCoreCDB[Table][Value]['b'], sCoreCDB[Table][Value]['a']

		ColorPickerFrame:ClearAllPoints()
		ColorPickerFrame:Point( 'TOPLEFT', self, 'TOPRIGHT', 20, 0 )
		ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = 1, a

		ColorPickerFrame.func = function()
			sCoreCDB[Table][Value]['r'], sCoreCDB[Table][Value]['g'], sCoreCDB[Table][Value]['b'] = ColorPickerFrame:GetColorRGB()

			self['Texture']:SetVertexColor( ColorPickerFrame:GetColorRGB() )
		end

		ColorPickerFrame.opacityFunc = function()
			sCoreCDB[Table][Value].a = OpacitySliderFrame:GetValue()
		end

		ColorPickerFrame.previousValues = { r = r, g = g, b = b, opacity = a }

		ColorPickerFrame.cancelFunc = function()
			sCoreCDB[Table][Value]['r'], sCoreCDB[Table][Value]['g'], sCoreCDB[Table][Value]['b'], sCoreCDB[Table][Value]['a'] = r, g, b, a

			self['Texture']:SetVertexColor( sCoreCDB[Table][Value]['r'], sCoreCDB[Table][Value]['g'], sCoreCDB[Table][Value]['b'] )
		end

		ColorPickerFrame:SetColorRGB( r, g, b )
		ColorPickerFrame:Hide()
		ColorPickerFrame:Show()
	end )

	if( Tooltip ) then
		ColorPickerButton:SetScript( 'OnEnter', function( self )
			GameTooltip:SetOwner( self, 'ANCHOR_RIGHT', 10, 10 )
			GameTooltip:AddLine( Tooltip )
			GameTooltip:Show()
		end )

		ColorPickerButton:SetScript( 'OnLeave', function( self )
			S['HideGameTooltip']()
		end )
	end

	Parent[Value] = ColorPickerButton
end