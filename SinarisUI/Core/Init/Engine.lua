--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local UIName, UIEngine = ...

UIEngine[1] = {}
UIEngine[2] = {}
UIEngine[3] = {}

function UIEngine:Unpack()
	return self[1], self[2], self[3]
end

_G.Sinaris = UIEngine
