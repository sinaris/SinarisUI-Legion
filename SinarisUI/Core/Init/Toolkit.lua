--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local _G = _G
local select, unpack = select, unpack
local type = type
local twipe, tinsert, tremove = table.wipe, tinsert, tremove
local format, gsub, match, reverse = string.format, string.gsub, string.match, string.reverse
local ceil, floor, modf = math.ceil, math.floor, math.modf
local CreateFrame = CreateFrame

S['Print'] = function( Color, Value )
	local MessageColor

	if( Color == 'Red' ) then
		MessageColor = '|cffad2424'
	elseif( Color == 'Lila' ) then
		MessageColor = '|cff817fc9'
	elseif( Color == 'Yellow' ) then
		MessageColor = '|cffd38d01'
	elseif( Color == 'Pink' ) then
		MessageColor = '|cffff63d3'
	elseif( Color == 'Green' ) then
		MessageColor = '|cff1daa1d'
	elseif( Color == 'Grey' ) then
		MessageColor = '|cffcccccc'
	elseif( Color == 'Gold' ) then
		MessageColor = '|cffc5b358'
	elseif( Color == 'Blue' ) then
		MessageColor = '|cff049ffe'
	else
		MessageColor = '|cffffffff'
	end

	print( format( '%s' .. S['UIName'] .. '|r: ' .. Value, MessageColor ) )
end

S['Round'] = function( Number, idp )
	if( idp and idp > 0 ) then
		local Mult = 10 ^ idp

		return floor( Number * Mult + 0.5 ) / Mult
	end

	return floor( Number + 0.5 )
end

S['ColorGradient'] = function( a, b, ... )
	local Percent

	if( b == 0 ) then
		Percent = 0
	else
		Percent = a / b
	end

	if( Percent >= 1 ) then
		local R, G, B = select( select( '#', ... ) - 2, ... )

		return R, G, B
	elseif( Percent <= 0 ) then
		local R, G, B = ...

		return R, G, B
	end

	local Num = ( select( '#', ... ) / 3 )
	local Segment, RelPercent = modf( Percent * ( Num - 1 ) )
	local R1, G1, B1, R2, G2, B2 = select( ( Segment * 3 ) + 1, ... )

	return R1 + ( R2 - R1 ) * RelPercent, G1 + ( G2 - G1 ) * RelPercent, B1 + ( B2 - B1 ) * RelPercent
end

S['FormatTime'] = function( s )
	local Day, Hour, Minute = 86400, 3600, 60

	if( s >= Day ) then
		return format( '%dd', ceil( s / Day ) )
	elseif( s >= Hour ) then
		return format( '%dh', ceil( s / Hour ) )
	elseif( s >= Minute ) then
		return format( '%dm', ceil( s / Minute ) )
	elseif( s >= Minute / 12 ) then
		return floor( s )
	end

	return format( '%.1f', s )
end

----------------------------------------
-- Player's Role check
----------------------------------------
S['CheckRole'] = function()
	local Role
	local Specialization = GetSpecialization()
	local Class = S['MyClass']

	if( ( Class == 'MONK' and Specialization == 2 ) or ( Class == 'PRIEST' and ( Specialization == 1 or Specialization == 2 ) ) or ( Class == 'PALADIN' and Specialization == 1 ) or ( Class == 'DRUID' and Specialization == 4 ) or ( Class == 'SHAMAN' and Specialization == 3 ) ) then
		Role = 'Healer'
	else
		Role = 'DPS'
	end

	return Role
end

















----------------------------------------
-- GUI Functions
----------------------------------------
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
			Tab:SetBackdropBorderColor( M['Colors']['oUF']['class'][MyClass][1], M['Colors']['oUF']['class'][MyClass][2], M['Colors']['oUF']['class'][MyClass][3] )
		end

		Tab:HookScript( 'OnMouseDown', function( self )
			Frame:Show()
			self:Point( 'TOPLEFT', Parent, 'TOPRIGHT', 8, -28 * Tab['Number'] )
			Tab:SetBackdropBorderColor( M['Colors']['oUF']['class'][MyClass][1], M['Colors']['oUF']['class'][MyClass][2], M['Colors']['oUF']['class'][MyClass][3] )
		end )

		if( Tab['Number'] == 1 ) then
			Tab:Point( 'TOPLEFT', Parent, 'TOPRIGHT', 8, -28 )
		else
			Tab:Point( 'TOPLEFT', Parent, 'TOPRIGHT', 3, -28 * Tab['Number'] )
		end

		for index = 1, Parent['TabNumbers'] do
			if( index ~= Tab['Number'] ) then
				Parent['Tab' .. index]:HookScript( 'OnMouseDown', function( self )
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
			Tab:SetBackdropBorderColor( M['Colors']['oUF']['class'][MyClass][1], M['Colors']['oUF']['class'][MyClass][2], M['Colors']['oUF']['class'][MyClass][3] )
		end

		Tab:HookScript( 'OnMouseDown', function( self )
			Frame:Show()
			Tab:SetBackdropBorderColor( M['Colors']['oUF']['class'][MyClass][1], M['Colors']['oUF']['class'][MyClass][2], M['Colors']['oUF']['class'][MyClass][3] )
		end )

		for index = 1, Parent['TabNumbers'] do
			if( index == 1 ) then
				Parent['Tab' .. index]:Point( 'BOTTOMLEFT', Parent, 'TOPLEFT', 15, 2 )
			else
				Parent['Tab' .. index]:Point( 'LEFT', Parent['Tab' .. index - 1], 'RIGHT', 4, 0 )
			end

			if( index ~= Tab['Number'] ) then
				Parent['Tab' .. index]:HookScript( 'OnMouseDown', function( self )
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
	Options['Line']:SetColorTexture( 0.125, 0.125, 0.125, 1 )

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
	CheckButton:ApplySkin( 'Check' )

	_G[CheckButton:GetName() .. 'Text']:SetText( Name )

	CheckButton:SetScript( 'OnShow', function( self )
		self:SetChecked( aCoreCDB[Table][Value] )
	end )

	CheckButton:SetScript( 'OnClick', function( self )
		PlaySound( self:GetChecked() and 'igMainMenuOptionCheckBoxOn' or 'igMainMenuOptionCheckBoxOff' )

		if( self:GetChecked() ) then
			aCoreCDB[Table][Value] = true
		else
			aCoreCDB[Table][Value] = false
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
		self:SetValue( ( aCoreCDB[Table][Value] ) * Divisor )
		_G[Slider:GetName() .. 'Text']:SetFormattedText( '%s |cff00ffff%s|r', Name, aCoreCDB[Table][Value] )
	end )

	Slider:SetScript( 'OnValueChanged', function( self, getvalue )
		aCoreCDB[Table][Value] = getvalue / Divisor
		S['GUIOptionsSlider_OnValueChanged']( self, getvalue )
		_G[Slider:GetName() .. 'Text']:SetFormattedText( '%s |cff00ffff%s|r', Name, aCoreCDB[Table][Value] )
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
		self:SetText( aCoreCDB[Table][Value] )
	end )

	EditBox:SetScript( 'OnEscapePressed', function( self )
		self:SetText( aCoreCDB[Table][Value] )
		self:ClearFocus()
	end )

	EditBox:SetScript( 'OnEnterPressed', function( self )
		self:ClearFocus()
		aCoreCDB[Table][Value] = self:GetText()
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
			self:SetChecked( aCoreCDB[Table][Value] == k )
		end )

		RadioButton[k]:SetScript( 'OnClick', function( self )
			if( self:GetChecked() ) then
				aCoreCDB[Table][Value] = k
			else
				self:SetChecked( true )
			end
		end )
	end

	for k, v in pairs( Group ) do
		RadioButton[k]:HookScript( 'OnClick', function( self )
			if( aCoreCDB[Table][Value] == k ) then
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
	for index = 1, #RadioButtons do
		if( index == 1 ) then
			RadioButtons[index]:Point( 'LEFT', 5, -10 )
		else
			RadioButtons[index]:Point( 'LEFT', _G[RadioButtons[index - 1]:GetName() .. 'Text'], 'RIGHT', 5, 0 )
		end

		if( index == #RadioButtons ) then
			RadioButton['Name']:Point( 'LEFT', _G[RadioButtons[index]:GetName() .. 'Text'], 'RIGHT', 10, 1 )
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
	ColorPickerButton:StripTextures()
	ColorPickerButton:ApplyStyle()

	ColorPickerButton['Texture'] = ColorPickerButton:CreateTexture( nil, 'OVERLAY' )
	ColorPickerButton['Texture']:SetTexture( M['Textures']['Blank'] )
	ColorPickerButton['Texture']:SetPoint( 'CENTER' )
	ColorPickerButton['Texture']:SetInside()

	if( ColorPickerButton['SetHighlightTexture'] and not ColorPickerButton['hover'] ) then
		local Hover = ColorPickerButton:CreateTexture( 'Frame', nil, ColorPickerButton )
		Hover:SetColorTexture( 1.0, 1.0, 1.0, 0.3 )
		Hover:SetInside()
		ColorPickerButton['hover'] = Hover
		ColorPickerButton:SetHighlightTexture( Hover )
	end

	ColorPickerButton['Name'] = S['Construct_FontString']( ColorPickerButton, 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'LEFT', false )
	ColorPickerButton['Name']:Point( 'LEFT', ColorPickerButton, 'RIGHT', 10, 1 )
	ColorPickerButton['Name']:SetText( Name )

	ColorPickerButton:SetScript( 'OnShow', function( self )
		self['Texture']:SetVertexColor( aCoreCDB[Table][Value]['r'], aCoreCDB[Table][Value]['g'], aCoreCDB[Table][Value]['b'] )
	end )

	ColorPickerButton:SetScript( 'OnClick', function( self )
		local r, g, b, a = aCoreCDB[Table][Value]['r'], aCoreCDB[Table][Value]['g'], aCoreCDB[Table][Value]['b'], aCoreCDB[Table][Value]['a']

		ColorPickerFrame:ClearAllPoints()
		ColorPickerFrame:Point( 'TOPLEFT', self, 'TOPRIGHT', 20, 0 )
		ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = 1, a

		ColorPickerFrame.func = function()
			aCoreCDB[Table][Value]['r'], aCoreCDB[Table][Value]['g'], aCoreCDB[Table][Value]['b'] = ColorPickerFrame:GetColorRGB()

			self['Texture']:SetVertexColor( ColorPickerFrame:GetColorRGB() )
		end

		ColorPickerFrame.opacityFunc = function()
			aCoreCDB[Table][Value]['a'] = OpacitySliderFrame:GetValue()
		end

		ColorPickerFrame.previousValues = { r = r, g = g, b = b, opacity = a }

		ColorPickerFrame.cancelFunc = function()
			aCoreCDB[Table][Value]['r'], aCoreCDB[Table][Value]['g'], aCoreCDB[Table][Value]['b'], aCoreCDB[Table][Value]['a'] = r, g, b, a

			self['Texture']:SetVertexColor( aCoreCDB[Table][Value]['r'], aCoreCDB[Table][Value]['g'], aCoreCDB[Table][Value]['b'] )
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
			GameTooltip()
		end )
	end

	Parent[Value] = ColorPickerButton
end
