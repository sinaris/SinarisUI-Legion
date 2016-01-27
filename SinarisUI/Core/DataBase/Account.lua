--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local AccountDataBase = {}
AccountDataBase = {
	['General'] = {
		['UIScale'] = 0.71,
		['AutoUIScale'] = true,
		['IsGuided'] = false,
	},

	['Gold'] = {},
}

S['DataBase_SetupAccount'] = function()
	for a, b in pairs( AccountDataBase ) do
		if( type( b ) ~= 'table' ) then
			if( sCoreDB[a] == nil ) then
				sCoreDB[a] = b
			end
		else
			if( sCoreDB[a] == nil ) then
				sCoreDB[a] = {}
			end

			for k, v in pairs( b ) do
				if( sCoreDB[a][k] == nil ) then
					sCoreDB[a][k] = v
				end
			end
		end
	end
end
