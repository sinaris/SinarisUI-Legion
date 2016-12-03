--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

if( S['Locale'] ~= 'enUS' ) then
	return
end

L["ChatFrames"] = {}
L["ChatFrames"] = {
	["INSTANCE_CHAT"] = "I",
	["INSTANCE_CHAT_LEADER"] = "IL",
	["BN_WHISPER_GET"] = "From",
	["GUILD_GET"] = "G",
	["OFFICER_GET"] = "O",
	["PARTY_GET"] = "P",
	["PARTY_GUIDE_GET"] = "P",
	["PARTY_LEADER_GET"] = "P",
	["RAID_GET"] = "R",
	["RAID_LEADER_GET"] = "R",
	["RAID_WARNING_GET"] = "W",
	["WHISPER_GET"] = "From",
	["FLAG_AFK"] = "|cffff0000[AFK]|r ",
	["FLAG_DND"] = "|cffe7e716[DND]|r ",
	["FLAG_GM"] = "[GM]",
	["ERR_FRIEND_ONLINE_SS"] = "is now |cff298F00online|r",
	["ERR_FRIEND_OFFLINE_S"] = "is now |cffff0000offline|r",

	["Channel_Defense"] = "LocalDefense",
	["Channel_Recrutment"] = "GuildRecruitment",
	["Channel_LFG"] = "LookingForGroup",
}

L['MovingFrames'] = {}
L['MovingFrames'] = {
	['Healer'] = '|cff76EE00Healer|r',
	['DPS'] = '|cffE066FFDps/Tank|r',
	['FrameMover'] = 'Frame Mover',
	['CurrentMode'] = 'Current Mode: ',
	['CurrentFrame'] = 'Current Frame: ',
	['Point1'] = 'Point1',
	['Point2'] = 'Point2',
	['AnchorFrame'] = 'Anchor Frame',
	['XOffSet'] = 'X',
	['YOffSet'] = 'Y',
	['ResetFrame'] = 'Reset this frame to default position.',
	['ResetAllFrames'] = 'Reset all frames',
	['EnteringCombat'] = 'Entered combat, lock all frames.',
	['LockAllFrames'] = 'Lock all frames',
	['UnlockAllFrames'] = 'Unlock all frames',
}
