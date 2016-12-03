--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local _G = _G
local CreateFrame = CreateFrame
local ACCEPT, CANCEL = ACCEPT, CANCEL
local STATICPOPUP_TEXTURE_ALERT, STATICPOPUP_TEXTURE_ALERTGEAR = STATICPOPUP_TEXTURE_ALERT, STATICPOPUP_TEXTURE_ALERTGEAR

S['CreatePopUp'] = {}

local Frame = {}
local Total = 4

local Hide = function( self )
	PlaySound( 'igMainMenuClose' )

	local PopUp = self:GetParent()
	PopUp:Hide()
end

for index = 1, Total do
	Frame[index] = CreateFrame( 'Frame', 'PopUpDialog' .. index, UIParent )
	Frame[index]:Size( 400, 60 )
	Frame[index]:SetFrameLevel( 3 )
	Frame[index]:ApplyStyle( nil, true )
	Frame[index]:Hide()

	Frame[index]['Text'] = CreateFrame( 'MessageFrame', nil, Frame[index] )
	Frame[index]['Text']:Point( 'CENTER', Frame[index], 'CENTER', 0, 0 )
	Frame[index]['Text']:Size( 380, 40 )
	Frame[index]['Text']:SetFont( M['Fonts']['Normal'], 12 )
	Frame[index]['Text']:SetInsertMode( 'TOP' )
	Frame[index]['Text']:SetFading( false )
	--Frame[index]['Text']:SetAlpha( 1 )
	Frame[index]['Text']:AddMessage( '' )

	Frame[index]['Button1'] = CreateFrame( 'Button', 'PopUpDialogButtonAccept' .. index, Frame[index] )
	Frame[index]['Button1']:Point( 'TOPLEFT', Frame[index], 'BOTTOMLEFT', 0, -3 )
	Frame[index]['Button1']:Size( 198, 23 )
	--Frame[index]['Button1']:ApplySkin( 'Button' )
	--Frame[index]['Button1']:ApplyShadow()
	Frame[index]['Button1']:SetScript( 'OnClick', Hide )
	Frame[index]['Button1']:HookScript( 'OnClick', Hide )

	Frame[index]['Button1']['Text'] = S['Construct_FontString']( Frame[index]['Button1'], 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'CENTER' )
	Frame[index]['Button1']['Text']:Point( 'CENTER', Frame[index]['Button1'], 'CENTER', 0, 1 )
	Frame[index]['Button1']['Text']:SetText( ACCEPT )

	Frame[index]['Button2'] = CreateFrame( 'Button', 'PopUpDialogButtonCancel' .. index, Frame[index] )
	Frame[index]['Button2']:Point( 'TOPRIGHT', Frame[index], 'BOTTOMRIGHT', 0, -3 )
	Frame[index]['Button2']:Size( 198, 23 )
	--Frame[index]['Button2']:ApplySkin( 'Button' )
	--Frame[index]['Button2']:ApplyShadow()
	Frame[index]['Button2']:SetScript( 'OnClick', Hide )
	Frame[index]['Button2']:HookScript( 'OnClick', Hide )

	Frame[index]['Button2']['Text'] = S['Construct_FontString']( Frame[index]['Button2'], 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'CENTER' )
	Frame[index]['Button2']['Text']:Point( 'CENTER', Frame[index]['Button2'], 'CENTER', 0, 1 )
	Frame[index]['Button2']['Text']:SetText( CANCEL )

	Frame[index]['AlertIcon'] = Frame[index]:CreateTexture( nil, 'OVERLAY' )
	Frame[index]['AlertIcon']:Point( 'LEFT', Frame[index], 'LEFT', 24, 0 )
	Frame[index]['AlertIcon']:Size( 36, 36 )

	Frame[index]['EditBox'] = CreateFrame( 'EditBox', 'PopUpDialogEditBox' .. index, Frame[index] )
	Frame[index]['EditBox']:Point( 'BOTTOM', Frame[index], 0, 12 )
	Frame[index]['EditBox']:Size( 380, 16 )
	Frame[index]['EditBox']:SetMultiLine( false )
	Frame[index]['EditBox']:EnableMouse( true )
	Frame[index]['EditBox']:SetAutoFocus( true )
	Frame[index]['EditBox']:SetFontObject( ChatFontNormal )
	Frame[index]['EditBox']:SetScript( 'OnEscapePressed', function()
		Frame[index]:Hide()
	end )
	Frame[index]['EditBox']:ApplyBackdrop()
	Frame[index]['EditBox']['Backdrop']:Point( 'TOPLEFT', -4, 4 )
	Frame[index]['EditBox']['Backdrop']:Point( 'BOTTOMRIGHT', 4, -4 )
	Frame[index]['EditBox']:Hide()

	if( index == 1 ) then
		Frame[index]['Anchor'] = CreateFrame( 'Frame', nil, Frame[index] )
		Frame[index]['Anchor']:Point( 'BOTTOM', Frame[index], 'TOP', 0, -2 )
		Frame[index]['Anchor']:Size( 360, 30 )
		Frame[index]['Anchor']:SetFrameLevel( Frame[index]:GetFrameLevel() - 2 )
		Frame[index]['Anchor']:ApplyStyle( true, nil, nil )

		Frame[index]:Point( 'TOP', UIParent, 'TOP', 0, -10 )
	else
		local Previous = Frame[index - 1]
		Frame[index]:Point( 'TOP', Previous, 'BOTTOM', 0, -Frame[index]['Button1']:GetHeight() - 6 )
	end
end

S['ShowPopUp'] = function( self )
	local Info = S['CreatePopUp'][self]

	if( not Info ) then
		return
	end

	PlaySound( 'igMainMenuOpen' )

	local Selection = _G['PopUpDialog1']
	for index = 1, Total - 1 do
		if( Frame[index]:IsShown() ) then
			Selection = _G['PopUpDialog' .. index + 1]
		end
	end

	local PopUp = Selection
	local Question = PopUp['Text']
	local Button1 = PopUp['Button1']
	local Button2 = PopUp['Button2']
	local EditBox = PopUp['EditBox']
	local AlertIcon = PopUp['AlertIcon']

	Question:Clear()
	EditBox:SetText( '' )

	if( Info['Question'] ) then
		Question:AddMessage( Info['Question'] )
	end

	if( Info['Answer1'] ) then
		Button1['Text']:SetText( Info['Answer1'] )
	else
		Button1['Text']:SetText( ACCEPT )
	end

	if( Info['Answer2'] ) then
		Button2['Text']:SetText( Info['Answer2'] )
	else
		Button2['Text']:SetText( CANCEL )
	end

	if( Info['Function1'] ) then
		Button1:SetScript( 'OnClick', Info['Function1'] )
	else
		Button1:SetScript( 'OnClick', Hide )
	end

	if( Info['Function2'] ) then
		Button2:SetScript( 'OnClick', Info['Function2'] )
	else
		Button2:SetScript( 'OnClick', Hide )
	end

	if( Info['EditBox'] ) then
		EditBox:Show()
	else
		EditBox:Hide()
	end

	if( Info['ShowAlert'] ) then
		AlertIcon:SetTexture( STATICPOPUP_TEXTURE_ALERT )
	elseif( Info['ShowAlertGear'] ) then
		AlertIcon:SetTexture( STATICPOPUP_TEXTURE_ALERTGEAR )
	else
		AlertIcon:SetTexture()
		AlertIcon:Hide()
	end

	if ( Info['Sound'] ) then
		PlaySound( Info['Sound'] )
	end

	Button1:HookScript( 'OnClick', Hide )
	Button2:HookScript( 'OnClick', Hide )

	PopUp:Show()
end
