--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local EventFrame = CreateFrame( 'Frame' )
EventFrame:RegisterEvent( 'ADDON_LOADED' )
EventFrame:SetScript( 'OnEvent', function( self, event, ... )
	self[event]( self, ... )
end )

function EventFrame:ADDON_LOADED( arg1 )
	if( arg1 ~= 'SinarisUI' ) then
		return
	end

	if( sCoreDB == nil ) then
		sCoreDB = {}
	end

	if( sCoreCDB == nil ) then
		sCoreCDB = {}
	end

	S['DataBase_SetupAccount']()
	S['DataBase_SetupCharacter']()
end
