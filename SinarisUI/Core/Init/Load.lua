--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local EventFrame = CreateFrame( 'Frame' )
EventFrame:RegisterEvent( 'PLAYER_LOGIN' )
EventFrame:SetScript( 'OnEvent', function( self, event, ... )
	self[event]( self, ... )
end )

function EventFrame:PLAYER_LOGIN()
	S['Templates_Fonts']()

	S['Layout_Init']()
	S['Auras_Init']()
	S['Minimap_Init']()

	--S['Plugin_GameMenu_Init']()
end
