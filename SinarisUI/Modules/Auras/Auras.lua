--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local CreateFrames = function()
	local AurasLineV = CreateFrame( 'Frame', 'AurasLineV', UIParent )
	AurasLineV:Point( 'TOPRIGHT', UIParent, 'TOPRIGHT', -12, -31 )
	AurasLineV:Size( 2, 230 )
	AurasLineV:SetFrameStrata( 'BACKGROUND' )
	AurasLineV:SetFrameLevel( 1 )
	AurasLineV:ApplyStyle()

	local AurasLineH = CreateFrame( 'Frame', 'AurasLineH', UIParent )
	AurasLineH:Point( 'TOPRIGHT', AurasLineV, 'TOPRIGHT', 0, 0 )
	AurasLineH:Size( 230, 2 )
	AurasLineH:SetFrameStrata( 'BACKGROUND' )
	AurasLineH:SetFrameLevel( 1 )
	AurasLineH:ApplyStyle()

	local AurasCubeV = CreateFrame( 'Frame', 'AurasCubeV', UIParent )
	AurasCubeV:Point( 'TOP', MinimaAurasLineV, 'BOTTOM', 0, 0 )
	AurasCubeV:Size( 10, 10 )
	AurasCubeV:SetFrameStrata( 'BACKGROUND' )
	AurasCubeV:SetFrameLevel( 1 )
	AurasCubeV:ApplyStyle()

	local AurasCubeH = CreateFrame( 'Frame', 'AurasCubeH', UIParent )
	AurasCubeH:Point( 'RIGHT', AurasLineH, 'LEFT', 0, 0 )
	AurasCubeH:Size( 10, 10 )
	AurasCubeH:SetFrameStrata( 'BACKGROUND' )
	AurasCubeH:SetFrameLevel( 1 )
	AurasCubeH:ApplyStyle()
end

S['Auras_Init'] = function()
	if( not sCoreCDB['Auras']['Auras_Enable'] ) then
		return
	end

	CreateFrames()
end
