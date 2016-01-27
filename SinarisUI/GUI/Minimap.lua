--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local _G = _G

local CreateFrame = CreateFrame

local GUI = ConfigUI

local MinimapOptions = S['GUIFunction_CreateOptionPage']( 'MinimapOptions', 'Minimap', GUI, 'VERTICAL' )
local ResetButton = S['GUIFunction_CreateResetButton']( MinimapOptions, 'Minimap' )

local MinimapOptionsInnerframe = CreateFrame( 'Frame', 'MinimapOptionsInnerframe', MinimapOptions )
MinimapOptionsInnerframe:Point( 'TOPLEFT', 40, -110 )
MinimapOptionsInnerframe:Point( 'BOTTOMLEFT', -20, 20 )
MinimapOptionsInnerframe:Width( MinimapOptions:GetWidth() - 200 )
MinimapOptionsInnerframe:ApplyStyle()

MinimapOptionsInnerframe['TabIndex'] = 1
MinimapOptionsInnerframe['TabNumbers'] = 20
for i = 1, 20 do
	MinimapOptionsInnerframe['Tab' .. i] = CreateFrame( 'Frame', 'MinimapOptionsInnerframeTab' .. i, MinimapOptionsInnerframe )
	MinimapOptionsInnerframe['Tab' .. i]:SetScript( 'OnMouseDown', function() end )
end

MinimapOptionsInnerframe['General'] = S['GUIFunction_CreateOptionPage']( 'MinimapOptions', 'General', MinimapOptionsInnerframe, 'VERTICAL', nil, true )
MinimapOptionsInnerframe['General']:Show()

S['GUIFunction_CreateOptionCheckButton']( MinimapOptionsInnerframe['General'], 30, 60, 'Enable', 'Minimap', 'Minimap_Enable', nil )
S['GUIFunction_CreateOptionSlider']( MinimapOptionsInnerframe['General'], 30, 120, 'Size', 'Minimap', 'Minimap_Size', 1, 100, 250, 1, nil )

S['GUIFunction_CreateOptionCheckButton']( MinimapOptionsInnerframe['General'], 30, 200, 'Colored Border', 'Minimap', 'Minimap_ColorBorder', nil )
S['GUIFunction_CreateColorPickerButton']( MinimapOptionsInnerframe['General'], 35, 240, 'New Mail', 'Minimap', 'Minimap_ColorNewMail', nil )
S['GUIFunction_CreateColorPickerButton']( MinimapOptionsInnerframe['General'], 185, 240, 'New Invite', 'Minimap', 'Minimap_ColorNewInvite', nil )
S['GUIFunction_CreateColorPickerButton']( MinimapOptionsInnerframe['General'], 325, 240, 'New Mail and Invite', 'Minimap', 'Minimap_ColorNewMailAndInvite', nil )

S['GUIFunction_CreateOptionCheckButton']( MinimapOptionsInnerframe['General'], 30, 380, 'Zone Text', 'Minimap', 'Minimap_ZoneText', nil )
S['GUIFunction_CreateOptionCheckButton']( MinimapOptionsInnerframe['General'], 30, 420, 'Colored Zone Text', 'Minimap', 'Minimap_ColorZoneText', nil )
S['GUIFunction_CreateOptionCheckButton']( MinimapOptionsInnerframe['General'], 30, 460, 'Player Coords', 'Minimap', 'Minimap_PlayerCoords', nil )

MinimapOptionsInnerframe['General']['Minimap_Enable']:HookScript( 'OnShow', function( self )
	if( sCoreCDB['Minimap']['Minimap_Enable'] ) then
		--Minimap_ColorBorderButton:Enable()
		BlizzardOptionsPanel_Slider_Enable( MinimapOptionsInnerframe['General']['Minimap_Size'] )
		Minimap_ColorBorderButton:Enable()
		Minimap_ColorNewMailColorPickerButton:Enable()
		Minimap_ColorNewInviteColorPickerButton:Enable()
		Minimap_ColorNewMailAndInviteColorPickerButton:Enable()
		Minimap_ZoneTextButton:Enable()
		Minimap_ColorZoneTextButton:Enable()
		Minimap_PlayerCoordsButton:Enable()
	else
		--Minimap_ColorBorderButton:Disable()
		BlizzardOptionsPanel_Slider_Disable( MinimapOptionsInnerframe['General']['Minimap_Size'] )
		Minimap_ColorBorderButton:Disable()
		Minimap_ColorNewMailColorPickerButton:Disable()
		Minimap_ColorNewInviteColorPickerButton:Disable()
		Minimap_ColorNewMailAndInviteColorPickerButton:Disable()
		Minimap_ZoneTextButton:Disable()
		Minimap_ColorZoneTextButton:Disable()
		Minimap_PlayerCoordsButton:Disable()
	end
end )

MinimapOptionsInnerframe['General']['Minimap_Enable']:HookScript( 'OnClick', function( self )
	if( sCoreCDB['Minimap']['Minimap_Enable'] ) then
		BlizzardOptionsPanel_Slider_Enable( MinimapOptionsInnerframe['General']['Minimap_Size'] )
		Minimap_ColorBorderButton:Enable()
		Minimap_ColorNewMailColorPickerButton:Enable()
		Minimap_ColorNewInviteColorPickerButton:Enable()
		Minimap_ColorNewMailAndInviteColorPickerButton:Enable()
		Minimap_ZoneTextButton:Enable()
		Minimap_ColorZoneTextButton:Enable()
		Minimap_PlayerCoordsButton:Enable()
	else
		BlizzardOptionsPanel_Slider_Disable( MinimapOptionsInnerframe['General']['Minimap_Size'] )
		Minimap_ColorBorderButton:Disable()
		Minimap_ColorNewMailColorPickerButton:Disable()
		Minimap_ColorNewInviteColorPickerButton:Disable()
		Minimap_ColorNewMailAndInviteColorPickerButton:Disable()
		Minimap_ZoneTextButton:Disable()
		Minimap_ColorZoneTextButton:Disable()
		Minimap_PlayerCoordsButton:Disable()
	end
end )

MinimapOptionsInnerframe['General']['Minimap_ColorBorder']:HookScript( 'OnShow', function( self )
	if( sCoreCDB['Minimap']['Minimap_ColorBorder'] ) then
		Minimap_ColorNewMailColorPickerButton:Enable()
		Minimap_ColorNewInviteColorPickerButton:Enable()
		Minimap_ColorNewMailAndInviteColorPickerButton:Enable()
	else
		Minimap_ColorNewMailColorPickerButton:Disable()
		Minimap_ColorNewInviteColorPickerButton:Disable()
		Minimap_ColorNewMailAndInviteColorPickerButton:Disable()
	end
end )

MinimapOptionsInnerframe['General']['Minimap_ColorBorder']:HookScript( 'OnClick', function( self )
	if( sCoreCDB['Minimap']['Minimap_ColorBorder'] ) then
		Minimap_ColorNewMailColorPickerButton:Enable()
		Minimap_ColorNewInviteColorPickerButton:Enable()
		Minimap_ColorNewMailAndInviteColorPickerButton:Enable()
	else
		Minimap_ColorNewMailColorPickerButton:Disable()
		Minimap_ColorNewInviteColorPickerButton:Disable()
		Minimap_ColorNewMailAndInviteColorPickerButton:Disable()
	end
end )

--Minimap_SizeSlider:SetScript( 'OnMouseUp', function( self )
--	S['Minimap_UpdateSize']()
--end )

Minimap_SizeSlider:HookScript( "OnValueChanged", function( self, value )
	S['Minimap_UpdateSize']()
end)
