--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local CreateFrame = CreateFrame

local EventFrame = CreateFrame( 'Frame' )
EventFrame:RegisterEvent( 'PLAYER_LOGIN' )
EventFrame:SetScript( 'OnEvent', function( self, event, ... )
	self[event]( self, ... )
end )

function EventFrame:PLAYER_LOGIN()
	S['Layout_Init']()
	S['ActionBars_Init']()
	S['Auras_Init']()
	S['LocationPanel_Init']()
	S['Minimap_Init']()
end
