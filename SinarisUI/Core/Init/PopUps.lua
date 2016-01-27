--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

S['PopUps_Create'] = {}

local Frame = {}
local Total = 4

local Hide = function( self )
	PlaySound( 'igMainMenuClose' )

	local PopUp = self:GetParent()
	PopUp:Hide()
end