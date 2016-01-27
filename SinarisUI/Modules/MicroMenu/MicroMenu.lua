--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local gsub = string.gsub
local upper = string.upper

local CalendarString = gsub( SLASH_CALENDAR1, '/', '' )
CalendarString = gsub( CalendarString, '^%l', upper )

local MicroButtonsDropDown = CreateFrame( 'Frame', 'MicroButtonsDropDown', UIParent, 'UIDropDownMenuTemplate' )
S['MicroMenu'] = {
	{ text = CHARACTER_BUTTON, notCheckable = true, func = function()
		ToggleCharacter( 'PaperDollFrame' )
	end },

	{ text = SPELLBOOK_ABILITIES_BUTTON, notCheckable = true, func = function()
		if( InCombatLockdown() ) then
			S['Print']( 'Red', ERR_NOT_IN_COMBAT )

			return
		end

		if( not SpellBookFrame:IsShown() ) then
			ShowUIPanel( SpellBookFrame )
		else
			HideUIPanel( SpellBookFrame )
		end
	end },

	{ text = LOOKING_FOR_RAID, notCheckable = true, func = function()
		ToggleFrame( RaidBrowserFrame )
	end },

	{ text = MOUNTS, notCheckable = true, func = function()
		ToggleCollectionsJournal( 1 )
	end },

	{ text = PETS, notCheckable = true, func = function()
		ToggleCollectionsJournal( 2 )
	end },

	{ text = TOY_BOX, notCheckable = true, func = function()
		ToggleCollectionsJournal( 3 )
	end },

	{ text = HEIRLOOMS, notCheckable = true, func = function()
		ToggleCollectionsJournal( 4 )
	end },

	{ text = TALENTS_BUTTON, notCheckable = true, func = function()
		if( not PlayerTalentFrame ) then
			TalentFrame_LoadUI()
		end

		if( not GlyphFrame ) then
			GlyphFrame_LoadUI()
		end

		if( S['MyLevel'] >= SHOW_TALENT_LEVEL ) then
			if( not PlayerTalentFrame:IsShown() ) then
				ShowUIPanel( PlayerTalentFrame )
			else
				HideUIPanel( PlayerTalentFrame )
			end
		else
			S['Print']( 'Yellow', format( FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_TALENT_LEVEL ) )
		end
	end },

	{ text = TIMEMANAGER_TITLE, notCheckable = true, func = function()
		ToggleFrame( TimeManagerFrame )
	end },

	{ text = ACHIEVEMENT_BUTTON, notCheckable = true, func = function()
		ToggleAchievementFrame()
	end },

	{ text = WORLD_MAP .. " / " .. QUESTLOG_BUTTON, notCheckable = true, func = function()
		ShowUIPanel( WorldMapFrame )
	end },

	{ text = SOCIAL_BUTTON, notCheckable = true, func = function()
		ToggleFriendsFrame()
	end },

	{ text = CalendarString, notCheckable = true, func = function()
		GameTimeFrame:Click()
	end },

	{ text = PLAYER_V_PLAYER, notCheckable = true, func = function()
		if( S['MyLevel'] >= SHOW_PVP_LEVEL ) then
			TogglePVPUI()
		else
			S['Print']( 'Yellow', format( FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_PVP_LEVEL ) )
		end
	end },

	{ text = IsInGuild() and ACHIEVEMENTS_GUILD_TAB or LOOKINGFORGUILD, notCheckable = true, func = function()
		if( IsTrialAccount() ) then
			S['Print']( 'Yellow', ERR_RESTRICTED_ACCOUNT )

			return
		end

		if( IsInGuild() ) then
			if( not GuildFrame ) then
				LoadAddOn( 'Blizzard_GuildUI' )
			end

			ToggleGuildFrame()
			GuildFrame_TabClicked( GuildFrameTab2 )
		else
			if( not LookingForGuildFrame ) then
				LoadAddOn( 'Blizzard_LookingForGuildUI' )
			end

			if( not LookingForGuildFrame ) then
				return
			end

			LookingForGuildFrame_Toggle()
		end
	end },

	{ text = LFG_TITLE, notCheckable = true, func = function()
		if( S['MyLevel'] >= SHOW_LFD_LEVEL ) then
			PVEFrame_ToggleFrame()
		else
			S['Print']( 'Yellow', format( FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_LFD_LEVEL ) )
		end
	end },

	{ text = ENCOUNTER_JOURNAL, notCheckable = true, func = function()
		if( not IsAddOnLoaded( 'Blizzard_EncounterJournal' ) ) then
			EncounterJournal_LoadUI()
		end
		ToggleFrame( EncounterJournal )
	end },

	{ text = BATTLEFIELD_MINIMAP, notCheckable = true, func = function()
		ToggleBattlefieldMinimap()
	end },

	{ text = LOOT_ROLLS, notCheckable = true, func = function()
		ToggleFrame( LootHistoryFrame )
	end },

	{ text = HELP_BUTTON, notCheckable = true, func = function()
		ToggleHelpFrame()
	end },

	{ text = SOCIAL_TWITTER_COMPOSE_NEW_TWEET, notCheckable = true, func = function()
		if( not SocialPostFrame ) then
			LoadAddOn( "Blizzard_SocialUI" )
		end

		local IsTwitterEnabled = C_Social.IsSocialEnabled()
		if( IsTwitterEnabled ) then
			Social_SetShown( true )
		else
			S['Print']( 'Yellow', SOCIAL_TWITTER_TWEET_NOT_LINKED )
		end
	end },
}

if( S['MyLevel'] > 89 ) then
	tinsert( S['MicroMenu'], { text = GARRISON_LANDING_PAGE_TITLE, notCheckable = true, func = function()
		GarrisonLandingPage_Toggle()
	end } )
end

if( not IsTrialAccount() and not C_StorePublic.IsDisabledByParentalControls() ) then
	tinsert( S['MicroMenu'], { text = BLIZZARD_STORE, notCheckable = true, func = function()
		StoreMicroButton:Click()
	end } )
end
