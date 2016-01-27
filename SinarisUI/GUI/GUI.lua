--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local GUI = CreateFrame( 'Frame', 'ConfigUI', UIParent )
GUI:Point( 'CENTER', UIParent, 'CENTER', 0, 0 )
GUI:Size( 750, 700 )
GUI:SetFrameStrata( 'HIGH' )
GUI:SetFrameLevel( 4 )
GUI:ApplyStyle( true, true )
GUI:Hide()

tinsert( UISpecialFrames, 'ConfigUI' ) 

GUI['Title'] = CreateFrame( 'Frame', nil, GUI )
GUI['Title']:Point( 'TOP', GUI, 'TOP', 0, -3 )
GUI['Title']:Size( GUI:GetWidth( ) - 6, 34 )
GUI['Title']:ApplyStyle()

GUI['Title']['Text'] = S['Construct_FontString']( GUI['Title'], 'OVERLAY', M['Fonts']['Normal'], 16, 'OUTLINE', 'CENTER', true )
GUI['Title']['Text']:Point( 'CENTER', GUI['Title'], 'CENTER', 0, 0 )
GUI['Title']['Text']:SetText( '|cff00aaff' .. S['Name'] .. '|r ' .. S['Version'] .. ' - |cffFF6347ConfigUI|r' )

GUI['Subtitle'] = CreateFrame( 'Frame', nil, GUI )
GUI['Subtitle']:Point( 'TOP', GUI['Title'], 'BOTTOM', 0, -3 )
GUI['Subtitle']:Size( GUI:GetWidth( ) - 6, 21 )
GUI['Subtitle']:ApplyStyle()

GUI['Subtitle']['Text'] = S['Construct_FontString']( GUI['Subtitle'], 'OVERLAY', M['Fonts']['Normal'], 13, 'OUTLINE', 'CENTER', true )
GUI['Subtitle']['Text']:Point( 'CENTER', GUI['Subtitle'], 'CENTER', 0, 0 )
GUI['Subtitle']['Text']:SetText( 'Original author: |cff00aaffSinaris|r' )

GUI['CloseButton'] = CreateFrame( 'Button', 'ConfigUICloseButton', GUI )
GUI['CloseButton']:Point( 'BOTTOMRIGHT', GUI, 'BOTTOMRIGHT', -10, 10 )
GUI['CloseButton']:Size( 20, 20 )
GUI['CloseButton']:ApplySkin( 'Button' )
GUI['CloseButton']:SetScript( 'OnClick', function()
	PlaySound( 'AchievementMenuOpen' )

	GUI:Hide()
end )

GUI['ReloadUIButton'] = CreateFrame( 'Button', 'ConfigUIReloadUIButton', GUI )
GUI['ReloadUIButton']:Point( 'RIGHT', GUI['CloseButton'], 'LEFT', -15, 0 )
GUI['ReloadUIButton']:Size( 100, 25 )
GUI['ReloadUIButton']:ApplySkin( 'Button' )
GUI['ReloadUIButton']:SetScript( 'OnClick', ReloadUI )

GUI['ReloadUIButton']['Text'] = S['Construct_FontString']( GUI['ReloadUIButton'], 'OVERLAY', M['Fonts']['Normal'], 12, 'OUTLINE', 'CENTER', false )
GUI['ReloadUIButton']['Text']:Point( 'CENTER', GUI['ReloadUIButton'], 'CENTER', 0, 0 )
GUI['ReloadUIButton']['Text']:SetText( APPLY )

GUI['TabIndex'] = 1
GUI['TabNumbers'] = 20
for i = 1, 20 do
	GUI['Tab' .. i] = CreateFrame( 'Frame', 'ConfigUITab' .. i, GUI )
	GUI['Tab' .. i]:SetScript( 'OnMouseDown', function() end )
end
