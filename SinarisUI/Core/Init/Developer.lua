--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local format, gsub, random, lower, upper, tonumber = string.format, gsub, random, string.lower, string.upper, tonumber

local CreateFrame = CreateFrame
local GetGameTime = GetGameTime
local CalendarGetDate = CalendarGetDate
local GetAchievementInfo = GetAchievementInfo
local GetStatistic = GetStatistic
local GetCursorPosition = GetCursorPosition

local TEXTURE_FACTIONLOGO = 'Interface\\AddOns\\SinarisUI\\Medias\\ClassIcons\\CLASS-' .. S['MyClass']
local UI_SCREENHEIGHT, UI_SCREENWIDTH = S['ScreenHeight'], S['ScreenWidth']

local IsAFK









-- Source wowhead.com
local stats = {
	60,		-- Total deaths
	97,		-- Daily quests completed
	98,		-- Quests completed
	107,	-- Creatures killed
	112,	-- Deaths from drowning
	114,	-- Deaths from falling
	319,	-- Duels won
	320,	-- Duels lost
	321,	-- Total raid and dungeon deaths
	326,	-- Gold from quest rewards
	328,	-- Total gold acquired
	333,	-- Gold looted
	334,	-- Most gold ever owned
	338,	-- Vanity pets owned
	339,	-- Mounts owned
	342,	-- Epic items acquired
	349,	-- Flight paths taken
	377,	-- Most factions at Exalted
	588,	-- Total Honorable Kills
	837,	-- Arenas won
	838,	-- Arenas played
	839,	-- Battlegrounds played
	840,	-- Battlegrounds won
	919,	-- Gold earned from auctions
	931,	-- Total factions encountered
	932,	-- Total 5-player dungeons entered
	933,	-- Total 10-player raids entered
	934,	-- Total 25-player raids entered
	1042,	-- Number of hugs
	1045,	-- Total cheers
	1047,	-- Total facepalms
	1065,	-- Total waves
	1066,	-- Total times LOL'd
	1088,	-- Kael'thas Sunstrider kills (Tempest Keep)
	1149,	-- Talent tree respecs
	1197,	-- Total kills
	1098,	-- Onyxia kills (Onyxia's Lair)
	1198,	-- Total kills that grant experience or honor
	1339,	-- Mage portal taken most
	1487,	-- Killing Blows
	1491,	-- Battleground Killing Blows
	1518,	-- Fish caught
	1716,	-- Battleground with the most Killing Blows
	4687,	-- Victories over the Lich King (Icecrown 25 player)
	5692,	-- Rated battlegrounds played
	5694,	-- Rated battlegrounds won
	6167,	-- Deathwing kills (Dragon Soul)
	7399,	-- Challenge mode dungeons completed
	8278,	-- Pet Battles won at max level
	8632,	-- Garrosh Hellscream (LFR Siege of Orgrimmar)
	
	-- Draenor Raiding stats. Thanks Flodropp for the effort :)
	--[[
	9297,	-- Brackenspore kills (Normal Highmaul)
	9298,	-- Brackenspore kills (Heroic Highmaul)
	9283,	-- Kargath Bladefist defeats (Normal Highmaul)
	9284,	-- Kargath Bladefist defeats (Heroic Highmaul)
	9287,	-- The Butcher kills (Normal Highmaul)
	9288,	-- The Butcher kills (Heroic Highmaul)
	9292,	-- Tectus kills (Normal Highmaul)
	9293,	-- Tectus kills (Heroic Highmaul)
	9302,	-- Twin Ogron kills (Normal Highmaul)
	9303,	-- Twin Ogron kills (Heroic Highmaul)
	9309,	-- Ko'ragh kills (Normal Highmaul)
	9310,	-- Ko'ragh kills (Heroic Highmaul)
	9313,	-- Imperator Mar'gok kills (Normal Highmaul)
	9314,	-- Imperator Mar'gok kills (Heroic Highmaul)
	9317,	-- Gruul kills (Normal Blackrock Foundry)
	9318,	-- Gruul kills (Heroic Blackrock Foundry)
	9321,	-- Oregorger kills (Normal Blackrock Foundry)
	9322,	-- Oregorger kills (Heroic Blackrock Foundry)
	9327,	-- Hans'gar and Franzok kills (Normal Blackrock Foundry)
	9328,	-- Hans'gar and Franzok kills (Heroic Blackrock Foundry)
	9331,	-- Flamebender Ka'graz kills (Normal Blackrock Foundry)
	9332,	-- Flamebender Ka'graz kills (Heroic Blackrock Foundry)
	9336,	-- Beastlord Darmac kills (Normal Blackrock Foundry)
	9337,	-- Beastlord Darmac kills (Heroic Blackrock Foundry)
	9340,	-- Operator Thogar kills (Normal Blackrock Foundry)
	9341,	-- Operator Thogar kills (Heroic Blackrock Foundry)
	9350,	-- Blast Furnace destructions (Normal Blackrock Foundry)
	9351,	-- Blast Furnace destructions (Heroic Blackrock Foundry)
	9355,	-- Kromog kills (Normal Blackrock Foundry)
	9356,	-- Kromog kills (Heroic Blackrock Foundry)
	9359,	-- Iron Maidens kills (Normal Blackrock Foundry)
	9360,	-- Iron Maidens kills (Heroic Blackrock Foundry)
	9363,	-- Warlord Blackhand kills (Normal Blackrock Foundry)
	9364,	-- Warlord Blackhand kills (Heroic Blackrock Foundry)
	]]
	9430,	-- Draenor dungeons completed (final boss defeated)
	9561,	-- Draenor raid boss defeated the most
	9558,	-- Draenor raids completed (final boss defeated)
	10060,	-- Garrison Followers recruited
	10181,	-- Garrision Missions completed
	10184,	-- Garrision Rare Missions completed
}

-- Remove capitals from class except first letter
local function handleClass()
	local lowclass = S.MyClass:lower()
    local firstclass = lowclass:gsub("^%l", string.upper)
	return firstclass
end

-- Create Time
local function createTime()
	local hour, hour24, minute, ampm = tonumber(date("%I")), tonumber(date("%H")), tonumber(date("%M")), date("%p"):lower()
	local sHour, sMinute = GetGameTime()
	
	local localTime = format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_LOCALTIME, hour, minute, ampm)
	local localTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_LOCALTIME, hour24, minute)
	local realmTime = format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute, ampm)
	local realmTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute)
	
	--if E.db.datatexts.localtime then
	--	if E.db.datatexts.time24 then
	--		return localTime24
	--	else
	--		return localTime
	--	end
	--else
	--	if E.db.datatexts.time24 then
	--		return realmTime24
	--	else
			return realmTime
	--	end
	--end
end

local monthAbr = {
	[1] = "Jan",
	[2] = "Feb",
	[3] = "Mar",
	[4] = "Apr",
	[5] = "May",
	[6] = "Jun",
	[7] = "Jul",
	[8] = "Aug",
	[9] = "Sep",
	[10] = "Oct",
	[11] = "Nov",
	[12] = "Dec",
}

local daysAbr = {
	[1] = "Sun",
	[2] = "Mon",
	[3] = "Tue",
	[4] = "Wed",
	[5] = "Thu",
	[6] = "Fri",
	[7] = "Sat",
}

-- Create Date
local function createDate()
	local curDayName, curMonth, curDay, curYear = CalendarGetDate()
	AFKMode.top.date:SetFormattedText("%s, %s %d, %d", daysAbr[curDayName], monthAbr[curMonth], curDay, curYear)
end

-- Create random stats
local function createStats()
	local id = stats[random( #stats )]
	local _, name = GetAchievementInfo(id)
	local result = GetStatistic(id)
	if result == "--" then result = NONE end
	return format("%s: |cfff0ff00%s|r", name, result)
end




local function GetMousePosition()
	x, y = GetCursorPosition();
end
--[[
local function UpdateTimer(self,elapsed)
	local createdTime = createTime()
	local minutes = floor(timer/60)
	local neg_seconds = -timer % 60

	-- Accurate AFK Timer by catching mouse movements. Credit: Nikita S. Doroshenko,
	-- http://www.wowinterface.com/forums/showthread.php?t=52742
	local nx, ny = GetCursorPosition();
	if x ~= nx and y ~= ny then
		x, y = GetCursorPosition();
		if timer > 0 then
			AFKMode.countd.text:SetFormattedText("|cffff8000%s|r", "Cursor moved. Timer reset.")
			timer = 0
		end
	else
		timer = timer + 1
		if timer > 1 then
			AFKMode.countd.text:SetFormattedText("%s: |cfff0ff00%02d:%02d|r", "Logout Timer", minutes -29, neg_seconds)
		end
	end
	GetMousePosition()


	total = total + 1
	if total >= showTime then
		local createdStat = createStats()
		AFKMode.statMsg.info:AddMessage(createdStat)
		UIFrameFadeIn(AFKMode.statMsg.info, 1, 0, 1)

		total = 0
	end
end
]]--

local x, y
local timer = 0
local showTime = 5
local total = 0

local UpdateTimer = function()
	print'HELLO'
end







--	local UpdateElapsed = 0
--	AFKMode:SetScript( 'OnUpdate', function( self, elapsed )
--		UpdateElapsed = UpdateElapsed + elapsed
	
--		if( UpdateElapsed > 0.5 ) then

--			UpdateElapsed = UpdateElapsed + 1

			-- Set time
--			AFKMode.top.time:SetFormattedText(createdTime)

			-- Set Date
--			createDate()
			--AFKMode.top.date:SetFormattedText( '%s', date( '|cff00aaff%A|r %B %d' ) )

			--AFKMode.top.Status:SetValue(floor(timer))

			-- Set the value on log off statusbar
--			AFKMode.top.Status:SetValue(floor(timer))
--			print(UpdateElapsed)
--		end
--	end )
























local SetStatus = function( status )
	if( InCombatLockdown() ) then
		return
	end

	if( status ) then
		AFKMode:Show()
		--CloseAllBags()

		--Minimap:Hide()
		--UIFrameFadeIn( UIParent, 0.5, 1, 0 )

		--SpinStart()

		AFKMode.top:SetHeight(0)
		AFKMode.top.anim.height:Play()

		AFKMode.bottom:SetHeight(0)
		AFKMode.bottom.anim.height:Play()

		--AFKMode:ScheduleRepeatingTimer('Dongle', UpdateTimer, 1)
		Dongle.ScheduleRepeatingTimer()
		--UpdateTimer()

		IsAFK = true
	elseif( IsAFK ) then
		AFKMode:Hide()

		--Minimap:Show()
		--UIFrameFadeIn( UIParent, 0.5, 0, 1 )

		--SpinStop()

		--if( PVEFrame:IsShown() ) then
		--	PVEFrame_ToggleFrame()
		--	PVEFrame_ToggleFrame()
		--end

		total = 0
		timer = 0
		AFKMode.countd.text:SetFormattedText("%s: |cfff0ff00-30:00|r", "Logout Timer")
		AFKMode.statMsg.info:AddMessage(string.format("|cffb3b3b3%s|r", "Random Stats"))

		IsAFK = false
	end

end

local OnEvent = function( self, event, ... )
	if( event == 'PLAYER_REGEN_DISABLED' or event == 'LFG_PROPOSAL_SHOW' or event == 'UPDATE_BATTLEFIELD_STATUS' ) then
		if( event == 'UPDATE_BATTLEFIELD_STATUS' ) then
			local status = GetBattlefieldStatus( ... )
			if( status == 'confirm' ) then
				SetStatus( false )
			end
		else
			SetStatus( false )
		end

		if( event == 'PLAYER_REGEN_DISABLED' ) then
			self:RegisterEvent( 'PLAYER_REGEN_ENABLED' )
			self:SetScript( 'OnEvent', OnEvent )
		end
		return
	end

	if( event == 'PLAYER_REGEN_ENABLED' ) then
		self:UnregisterEvent( 'PLAYER_REGEN_ENABLED' )
	end

	if( UnitIsAFK( 'player' ) ) then
		SetStatus( true )
	else
		SetStatus( false )
	end
end

local CreateFrame = function()
	local nonCapClass = handleClass()

	local AFKMode = CreateFrame( 'Frame', 'AFKMode', UIParent )
	AFKMode:SetFrameStrata( 'FULLSCREEN' )
	AFKMode:SetFrameLevel(1)
	AFKMode:SetScale(UIParent:GetScale())
	AFKMode:SetAllPoints(UIParent)
	AFKMode:Hide()

	AFKMode:RegisterEvent( 'PLAYER_FLAGS_CHANGED' )
	AFKMode:RegisterEvent( 'PLAYER_REGEN_DISABLED' )
	AFKMode:RegisterEvent( 'LFG_PROPOSAL_SHOW' )
	AFKMode:RegisterEvent( 'UPDATE_BATTLEFIELD_STATUS' )
	AFKMode:SetScript( 'OnEvent', OnEvent )

	SetCVar( 'autoClearAFK', '1' )

	-- Create Top frame
	AFKMode.top = CreateFrame('Frame', nil, AFKMode)
	AFKMode.top:SetFrameLevel(0)
	AFKMode.top:ApplyStyle(true, true)
	AFKMode.top:ClearAllPoints()
	AFKMode.top:SetPoint("TOP", AFKMode, "TOP", 0, 0)
	AFKMode.top:SetWidth( UI_SCREENWIDTH + 6 )

	-- Top Animation
	AFKMode.top.anim = CreateAnimationGroup( AFKMode.top )
	AFKMode.top.anim.height = AFKMode.top.anim:CreateAnimation( "Height" )
	AFKMode.top.anim.height:SetChange( UI_SCREENHEIGHT * ( 1 / 7 ) )
	AFKMode.top.anim.height:SetDuration( 1 )
	AFKMode.top.anim.height:SetSmoothing( "Bounce" )

	-- WoW logo
	AFKMode.top.wowlogo = CreateFrame('Frame', nil, AFKMode) -- need this to upper the logo layer
	AFKMode.top.wowlogo:Point("CENTER", AFKMode.top, "CENTER", 0, 0)
	AFKMode.top.wowlogo:SetFrameStrata( 'FULLSCREEN' )
	AFKMode.top.wowlogo:Size(300, 150)

	AFKMode.top.wowlogo.tex = AFKMode.top.wowlogo:CreateTexture(nil, 'OVERLAY')
	AFKMode.top.wowlogo.tex:SetTexture("Interface\\Glues\\Common\\GLUES-WOW-WODLOGO")
	AFKMode.top.wowlogo.tex:SetInside()

	-- Server/Local Time text
	AFKMode.top.time = AFKMode.top:CreateFontString(nil, 'OVERLAY')
	AFKMode.top.time:SetFont(M.Fonts.Normal, 20)
	AFKMode.top.time:SetText("")
	AFKMode.top.time:SetPoint("RIGHT", AFKMode.top, "RIGHT", -20, 0)
	AFKMode.top.time:SetJustifyH("LEFT")
	AFKMode.top.time:SetTextColor(S['Colors'].r, S['Colors'].g, S['Colors'].b)

	-- Date text
	AFKMode.top.date = AFKMode.top:CreateFontString(nil, 'OVERLAY')
	AFKMode.top.date:SetFont(M.Fonts.Normal, 20)
	AFKMode.top.date:SetText("")
	AFKMode.top.date:SetPoint("LEFT", AFKMode.top, "LEFT", 20, 0)
	AFKMode.top.date:SetJustifyH("RIGHT")
	AFKMode.top.date:SetTextColor(S['Colors'].r, S['Colors'].g, S['Colors'].b)

	-- Statusbar on Top frame decor showing time to log off (30mins)
	AFKMode.top.Status = CreateFrame('StatusBar', nil, AFKMode.top)
	AFKMode.top.Status:SetStatusBarTexture((M.Textures.StatusBar))
	AFKMode.top.Status:SetMinMaxValues(0, 1800)
	AFKMode.top.Status:SetStatusBarColor(S['Colors'].r, S['Colors'].g, S['Colors'].b, 1)
	AFKMode.top.Status:Point('TOPRIGHT', AFKMode.top, 'BOTTOMRIGHT', 0, 7)
	AFKMode.top.Status:Point('BOTTOMLEFT', AFKMode.top, 'BOTTOMLEFT', 0, 2)
	AFKMode.top.Status:SetValue(0)

	-- Create Bottom frame
	AFKMode.bottom = CreateFrame('Frame', nil, AFKMode)
	AFKMode.bottom:SetFrameLevel(0)
	AFKMode.bottom:ApplyStyle(true, true)
	AFKMode.bottom:ClearAllPoints()
	AFKMode.bottom:SetPoint("BOTTOM", AFKMode, "BOTTOM", 0, 0)
	AFKMode.bottom:SetWidth( UI_SCREENWIDTH + 6 )

	-- Bottom Frame Animation
	AFKMode.bottom.anim = CreateAnimationGroup(AFKMode.bottom)
	AFKMode.bottom.anim.height = AFKMode.bottom.anim:CreateAnimation("Height")
	AFKMode.bottom.anim.height:SetChange(UI_SCREENHEIGHT * (1 / 7))
	AFKMode.bottom.anim.height:SetDuration(1)
	AFKMode.bottom.anim.height:SetSmoothing("Bounce")

	-- Move the factiongroup sign to the center
	AFKMode.bottom.factionb = CreateFrame('Frame', nil, AFKMode) -- need this to upper the faction logo layer
	AFKMode.bottom.factionb:SetPoint("BOTTOM", AFKMode.bottom, "TOP", 0, -40)
	AFKMode.bottom.factionb:SetFrameStrata("FULLSCREEN")
	AFKMode.bottom.factionb:SetSize(220, 220)

	AFKMode.bottom.faction = AFKMode.bottom:CreateTexture(nil, 'OVERLAY')
	AFKMode.bottom.faction:SetParent(AFKMode.bottom.factionb)
	AFKMode.bottom.faction:SetInside()
	AFKMode.bottom.faction:SetTexture(TEXTURE_FACTIONLOGO)

	-- Add more info in the name and position it to the center
	AFKMode.bottom.name = AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	AFKMode.bottom.name:SetFont(M.Fonts.Normal, 20)
	AFKMode.bottom.name:SetPoint("TOP", AFKMode.bottom.factionb, "BOTTOM")
	AFKMode.bottom.name:SetFormattedText("%s - %s \n%s %s %s %s", S.MyName, S['MyRealm'], LEVEL, S.MyLevel, S.MyRace, nonCapClass)
	AFKMode.bottom.name:SetJustifyH("CENTER")

	-- Add guild
	AFKMode.bottom.guild = AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	AFKMode.bottom.guild:SetFont(M.Fonts.Normal, 20)
	AFKMode.bottom.guild:SetText("No Guild")
	AFKMode.bottom.guild:SetPoint("TOP", AFKMode.bottom.name, "BOTTOM", 0, -6)
	AFKMode.bottom.guild:SetTextColor(0.7, 0.7, 0.7)

	-- Random stats decor (taken from install routine)
	AFKMode.statMsg = CreateFrame("Frame", nil, AFKMode)
	AFKMode.statMsg:Size(418, 72)
	AFKMode.statMsg:Point("CENTER", 0, 200)
	
	AFKMode.statMsg.bg = AFKMode.statMsg:CreateTexture(nil, 'BACKGROUND')
	AFKMode.statMsg.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFKMode.statMsg.bg:SetPoint('BOTTOM')
	AFKMode.statMsg.bg:Size(326, 103)
	AFKMode.statMsg.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	AFKMode.statMsg.bg:SetVertexColor(1, 1, 1, 0.7)
	
	AFKMode.statMsg.lineTop = AFKMode.statMsg:CreateTexture(nil, 'BACKGROUND')
	AFKMode.statMsg.lineTop:SetDrawLayer('BACKGROUND', 2)
	AFKMode.statMsg.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFKMode.statMsg.lineTop:SetPoint("TOP")
	AFKMode.statMsg.lineTop:Size(418, 7)
	AFKMode.statMsg.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
	
	AFKMode.statMsg.lineBottom = AFKMode.statMsg:CreateTexture(nil, 'BACKGROUND')
	AFKMode.statMsg.lineBottom:SetDrawLayer('BACKGROUND', 2)
	AFKMode.statMsg.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFKMode.statMsg.lineBottom:SetPoint("BOTTOM")
	AFKMode.statMsg.lineBottom:Size(418, 7)
	AFKMode.statMsg.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	-- Countdown decor
	AFKMode.countd = CreateFrame("Frame", nil, AFKMode)
	AFKMode.countd:Size(418, 36)
	AFKMode.countd:Point("TOP", AFKMode.statMsg.lineBottom, "BOTTOM")
	
	AFKMode.countd.bg = AFKMode.countd:CreateTexture(nil, 'BACKGROUND')
	AFKMode.countd.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFKMode.countd.bg:SetPoint('BOTTOM')
	AFKMode.countd.bg:Size(326, 56)
	AFKMode.countd.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	AFKMode.countd.bg:SetVertexColor(1, 1, 1, 0.7)
	
	AFKMode.countd.lineBottom = AFKMode.countd:CreateTexture(nil, 'BACKGROUND')
	AFKMode.countd.lineBottom:SetDrawLayer('BACKGROUND', 2)
	AFKMode.countd.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFKMode.countd.lineBottom:SetPoint('BOTTOM')
	AFKMode.countd.lineBottom:Size(418, 7)
	AFKMode.countd.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	-- 30 mins countdown text
	AFKMode.countd.text = AFKMode.countd:CreateFontString(nil, 'OVERLAY')
	AFKMode.countd.text:SetFont(M.Fonts.Normal, 12)
	AFKMode.countd.text:SetPoint("CENTER", AFKMode.countd, "CENTER")
	AFKMode.countd.text:SetJustifyH("CENTER")
	AFKMode.countd.text:SetFormattedText("%s: |cfff0ff00-30:00|r", "Logout Timer")
	AFKMode.countd.text:SetTextColor(0.7, 0.7, 0.7)

	-- Random stats frame
	AFKMode.statMsg.info = CreateFrame("ScrollingMessageFrame", nil, AFKMode.statMsg)
	AFKMode.statMsg.info:SetFont(M.Fonts.Normal, 18)
	AFKMode.statMsg.info:SetPoint("CENTER", AFKMode.statMsg, "CENTER", 0, 0)
	AFKMode.statMsg.info:SetSize(800, 24)
	AFKMode.statMsg.info:AddMessage(string.format("|cffb3b3b3%s|r", "Random Stats"))
	AFKMode.statMsg.info:SetFading(true)
	AFKMode.statMsg.info:SetFadeDuration(1)
	AFKMode.statMsg.info:SetTimeVisible(4)
	AFKMode.statMsg.info:SetJustifyH("CENTER")
	AFKMode.statMsg.info:SetTextColor(0.7, 0.7, 0.7)

	--Use this frame to control position of the model
	AFKMode.bottom.modelHolder = CreateFrame("Frame", nil, AFKMode.bottom)
	AFKMode.bottom.modelHolder:SetSize(150, 150)
	AFKMode.bottom.modelHolder:SetPoint("BOTTOMRIGHT", AFKMode.bottom, "BOTTOMRIGHT", -200, 220)

	AFKMode.bottom.model = CreateFrame("PlayerModel", "ElvUIAFKPlayerModel", AFKMode.bottom.modelHolder)
	AFKMode.bottom.model:SetPoint("CENTER", AFKMode.bottom.modelHolder, "CENTER")
	AFKMode.bottom.model:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2) --YES, double screen size. This prevents clipping of models. Position is controlled with the helper frame.
	AFKMode.bottom.model:SetCamDistanceScale(4.5) --Since the model frame is huge, we need to zoom out quite a bit.
	AFKMode.bottom.model:SetFacing(6)
	AFKMode.bottom.model:SetScript("OnUpdateModel", function(self)
		local timePassed = GetTime() - self.startTime
		if(timePassed > self.duration) and self.isIdle ~= true then
			self:SetAnimation(0)
			self.isIdle = true
			self.animTimer = AFK:ScheduleTimer("LoopAnimations", self.idleDuration)
		end
	end)
end

CreateFrame()
