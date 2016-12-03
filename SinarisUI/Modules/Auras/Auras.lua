--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local insert = table.insert
local CreateFrame = CreateFrame

local Headers = {}

local HeaderNames = {
	'BuffHeader',
	'DebuffHeader',
	'ConsolidatedHeader',
}

local DisableBlizzard = function()
	BuffFrame:Kill()
	TemporaryEnchantFrame:Kill()
	InterfaceOptionsFrameCategoriesButton12:SetScale( 0.00001 )
	InterfaceOptionsFrameCategoriesButton12:SetAlpha( 0 )
end

local CreateMover = function()
	local Mover_BuffFrame = CreateFrame( 'Frame', 'Mover_BuffFrame', UIParent )
	Mover_BuffFrame['movingname'] = 'Mover: BuffFrame'
	Mover_BuffFrame['point'] = {
		Healer = { a1 = 'TOPRIGHT', parent = 'UIParent', a2 = 'TOPRIGHT', x = -23, y = -42 },
		DPS = { a1 = 'TOPRIGHT', parent = 'UIParent', a2 = 'TOPRIGHT', x = -23, y = -42 },
	}
	Mover_BuffFrame:Size( 250, 20 )
	S['CreateDragFrame']( Mover_BuffFrame )

	local Mover_DebuffFrame = CreateFrame( 'Frame', 'Mover_DebuffFrame', UIParent )
	Mover_DebuffFrame['movingname'] = 'Mover: DebuffFrame'
	Mover_DebuffFrame['point'] = {
		Healer = { a1 = 'TOPRIGHT', parent = 'UIParent', a2 = 'TOPRIGHT', x = -23, y = -177 },
		DPS = { a1 = 'TOPRIGHT', parent = 'UIParent', a2 = 'TOPRIGHT', x = -23, y = -177 },
	}
	Mover_DebuffFrame:Size( 250, 20 )
	S['CreateDragFrame']( Mover_DebuffFrame )
end

local CreateFrames = function()
	for index = 1, 3 do
		local Header

		if( index == 3 ) then
			Header = CreateFrame( 'Frame', HeaderNames[index], S['PetUIFrame'], 'SecureFrameTemplate' )
			Header:SetAttribute( 'wrapAfter', 1 )
			Header:SetAttribute( 'wrapYOffset', -35 )
		else
			Header = CreateFrame( 'Frame', HeaderNames[index], S['PetUIFrame'], 'SecureAuraHeaderTemplate' )
			Header:SetClampedToScreen( true )
			Header:SetMovable( true )
			Header:SetAttribute( 'minHeight', 30 )
			Header:SetAttribute( 'wrapAfter', sCoreCDB['Auras']['Auras_WrapAfter'] )
			Header:SetAttribute( 'wrapYOffset', -sCoreCDB['Auras']['Auras_RowSpacing'] )
			Header:SetAttribute( 'xOffset', -( sCoreCDB['Auras']['Auras_Size'] + sCoreCDB['Auras']['Auras_ColSpacing'] ) )
		end

		Header:SetAttribute( 'minWidth', sCoreCDB['Auras']['Auras_WrapAfter'] * 35 )
		Header:SetAttribute( 'template', ( 'AurasTemplate%d' ):format( sCoreCDB['Auras']['Auras_Size'] ) )
		Header:SetAttribute( 'weaponTemplate', ( 'AurasTemplate%d' ):format( sCoreCDB['Auras']['Auras_Size'] ) )
		Header:SetSize( 30, 30 )
		Header:SetFrameStrata( 'BACKGROUND' )

		RegisterAttributeDriver( Header, 'unit', '[vehicleui] vehicle; player' )

		table.insert( Headers, Header )
	end

	local Buffs = Headers[1]
	local Debuffs = Headers[2]
	local Consolidate = Headers[3]
	local Filter = ( sCoreCDB['Auras']['Auras_Consolidate'] and 1 ) or 0
	local Proxy = CreateFrame( 'Frame', nil, Buffs, 'AurasProxyTemplate' )
	local DropDown = CreateFrame( 'BUTTON', nil, Proxy, 'SecureHandlerClickTemplate' )

	Buffs:Point( 'TOPRIGHT', Mover_BuffFrame, 'TOPRIGHT', 0, 0 )
	Buffs:SetAttribute( 'template', ( 'AurasTemplate%d' ):format( sCoreCDB['Auras']['Auras_Size'] ) )
	Buffs:SetAttribute( 'filter', 'HELPFUL' )
	Buffs:SetAttribute( 'consolidateProxy', Proxy )
	Buffs:SetAttribute( 'consolidateHeader', Consolidate )
	Buffs:SetAttribute( 'consolidateTo', Filter )
	Buffs:SetAttribute( 'includeWeapons', 1 )
	Buffs:SetAttribute( 'consolidateDuration', -1 )
	Buffs:Show()

	Proxy = Buffs:GetAttribute( 'consolidateProxy' )
	Proxy:HookScript( 'OnShow', function( self )
		if( Consolidate:IsShown() ) then
			Consolidate:Hide()
		end
	end )

	DropDown:SetAllPoints()
	DropDown:RegisterForClicks( 'AnyUp' )
	DropDown:SetAttribute( '_onclick', [=[
		local Header = self:GetParent():GetFrameRef( 'header' )
		local NumChild = 0

		repeat
			NumChild = NumChild + 1
			local child = Header:GetFrameRef( 'child' .. NumChild )
			until not child or not child:IsShown()

		NumChild = NumChild - 1

		local x, y = self:GetWidth(), self:GetHeight()
		Header:SetWidth( x )
		Header:SetHeight( y )

		if( Header:IsShown() ) then
			Header:Hide()
		else
			Header:Show()
		end
	]=] )

	Consolidate:SetAttribute( 'point', 'RIGHT' )
	Consolidate:SetAttribute( 'minHeight', nil )
	Consolidate:SetAttribute( 'minWidth', nil )
	Consolidate:SetParent( Proxy )
	Consolidate:ClearAllPoints()
	Consolidate:Point( 'CENTER', Proxy, 'CENTER', 0, -35 )
	Consolidate:Hide()
	SecureHandlerSetFrameRef( Proxy, 'header', Consolidate )

	Buffs.Proxy = Proxy
	Buffs.DropDown = DropDown

	Debuffs:Point( 'TOPRIGHT', Mover_DebuffFrame, 'TOPRIGHT', 0, 0 )
	Debuffs:SetAttribute( 'filter', 'HARMFUL' )
	Debuffs:Show()
end

local StartOrStopFlash = function( self, timeleft )
	if( timeleft < sCoreCDB['Auras']['Auras_FlashTimer'] ) then
		if( not self:IsPlaying() ) then
			self:Play()
		end
	elseif( self:IsPlaying() ) then
		self:Stop()
	end
end

local OnUpdate = function( self, elapsed )
	local TimeLeft

	if( self['Enchant'] ) then
		local Expiration = select( self['Enchant'], GetWeaponEnchantInfo() )

		if( Expiration ) then
			TimeLeft = Expiration / 1e3
		else
			TimeLeft = 0
		end
	else
		TimeLeft = self['TimeLeft'] - elapsed
	end

	self['TimeLeft'] = TimeLeft

	if( TimeLeft <= 0 ) then
		self['TimeLeft'] = nil
		self['Duration']:SetText( '' )

		if( self['Enchant'] ) then
			self.Dur = nil
		end

		return self:SetScript( 'OnUpdate', nil )
	else
		local Text = S['FormatTime']( TimeLeft )
		local r, g, b = S['ColorGradient']( self['TimeLeft'], self.Dur, 0.8, 0, 0, 0.8, 0.8, 0, 0, 0.8, 0 )

		if( self['Enchant'] ) then
			self['Bar']:SetMinMaxValues( 0, self.Dur )
		end

		self['Bar']:SetValue( self['TimeLeft'] )
		self['Bar']:SetStatusBarColor( r, g, b )

		if( TimeLeft < 60.5 ) then
			if( sCoreCDB['Auras']['Auras_Flash'] ) then
				StartOrStopFlash( self['Animation'], TimeLeft )
			end

			if( TimeLeft < 5 ) then
				self['Duration']:SetTextColor( 1, 0.08, 0.08 )
			else
				self['Duration']:SetTextColor( 1, 0.7, 0 )
			end
		else
			if( self['Animation'] and self['Animation']:IsPlaying() ) then
				self['Animation']:Stop()
			end

			self['Duration']:SetTextColor( 0.9, 0.9, 0.9 )
		end

		self['Duration']:SetText( Text )
	end
end

local UpdateAura = function( self, index )
	local Name, Rank, Texture, Count, DType, Duration, ExpirationTime, Caster, IsStealable, ShouldConsolidate, SpellID, CanApplyAura, IsBossDebuff = UnitAura( self:GetParent():GetAttribute( 'unit' ), index, self['Filter'] )

	if( Name ) then
		if( not sCoreCDB['Auras']['Auras_Consolidate'] ) then
			ShouldConsolidate = false
		end

		if( ShouldConsolidate or sCoreCDB['Auras']['Auras_ClassicTimer'] ) then
			self['Holder']:Hide()
		else
			self['Duration']:Hide()
		end

		if( Duration > 0 and ExpirationTime and not ShouldConsolidate ) then
			local TimeLeft = ExpirationTime - GetTime()

			if( not self['TimeLeft'] ) then
				self['TimeLeft'] = TimeLeft
				self:SetScript( 'OnUpdate', OnUpdate )
			else
				self['TimeLeft'] = TimeLeft
			end

			self.Dur = Duration

			if( sCoreCDB['Auras']['Auras_Flash'] ) then
				StartOrStopFlash( self['Animation'], TimeLeft )
			end

			self['Bar']:SetMinMaxValues( 0, Duration )

			if( not sCoreCDB['Auras']['Auras_ClassicTimer'] ) then
				self['Holder']:Show()
			end
		else
			if( sCoreCDB['Auras']['Auras_Flash'] ) then
				self['Animation']:Stop()
			end

			self['TimeLeft'] = nil
			self.Dur = nil
			self['Duration']:SetText( '' )
			self:SetScript( 'OnUpdate', nil )

			local min, max  = self['Bar']:GetMinMaxValues()

			self['Bar']:SetValue( max )
			self['Bar']:SetStatusBarColor( 0, 0.8, 0 )

			if( not sCoreCDB['Auras']['Auras_ClassicTimer'] ) then
				self['Holder']:Hide()
			end
		end

		if( Count > 1 ) then
			self['Count']:SetText( Count )
		else
			self['Count']:SetText( '' )
		end

		if( self['Filter'] == 'HARMFUL' ) then
			local Color = DebuffTypeColor[DType or 'none']
			self:SetBackdropBorderColor( Color.r * 3/5, Color.g * 3/5, Color.b * 3/5 )
			self['Holder']:SetBackdropBorderColor( Color.r * 3/5, Color.g * 3/5, Color.b * 3/5 )
		end

		self['Icon']:SetTexture( Texture )
	end
end

local UpdateTempEnchant = function( self, slot )
	local Enchant = ( slot == 16 and 2 ) or 6
	local Expiration = select( Enchant, GetWeaponEnchantInfo() )
	local Icon = GetInventoryItemTexture( 'player', slot )

	if( sCoreCDB['Auras']['Auras_ClassicTimer'] ) then
		self['Holder']:Hide()
	else
		self['Duration']:Hide()
	end

	if( Expiration ) then
		if( not self.Dur ) then
			self.Dur = Expiration / 1e3
		end

		self['Enchant'] = Enchant
		self:SetScript( 'OnUpdate', OnUpdate )
	else
		self.Dur = nil
		self['Enchant'] = nil
		self['TimeLeft'] = nil
		self:SetScript( 'OnUpdate', nil )
	end

	if( Icon ) then
		self:SetAlpha( 1 )
		self['Icon']:SetTexture( Icon )
	else
		self:SetAlpha( 0 )
	end
end

local OnAttributeChanged = function( self, attribute, value )
	if( attribute == 'index' ) then
		return UpdateAura( self, value )
	elseif( attribute == 'target-slot' ) then
		return UpdateTempEnchant( self, value )
	end
end

S['Auras_SkinAuras'] = function( self )
	local Proxy = self.IsProxy

	local Icon = self:CreateTexture( nil, 'BORDER' )
	Icon:SetTexCoord( unpack( S['TextureCoords'] ) )
	Icon:SetInside()

	local Count = S['Construct_FontString']( self, 'OVERLAY', M['Fonts']['Normal'], 10, 'OUTLINE', 'CENTER', true )
	Count:Point( 'BOTTOMRIGHT', self, 'BOTTOMRIGHT', -1, 1 )

	if( not Proxy ) then
		local Holder = CreateFrame( 'Frame', nil, self )
		Holder:Size( self:GetWidth(), 7 )
		Holder:Point( 'TOP', self, 'BOTTOM', 0, -3 )
		Holder:ApplyStyle( nil, true )

		local Bar = S['Construct_StatusBar']( nil, Holder )
		Bar:SetStatusBarColor( 0, 0.8, 0 )
		Bar:SetInside()

		local Duration = S['Construct_FontString']( self, 'OVERLAY', M['Fonts']['Normal'], 10, 'OUTLINE', 'CENTER', true )
		Duration:Point( 'BOTTOM', self, 'BOTTOM', 0, -5 )

		if( sCoreCDB['Auras']['Auras_Flash'] ) then
			local Animation = self:CreateAnimationGroup()
			Animation:SetLooping( 'BOUNCE' )

			local FadeOut = Animation:CreateAnimation( 'Alpha' )
			FadeOut:SetFromAlpha( 1 )
			FadeOut:SetToAlpha( 0.5 )
			FadeOut:SetDuration( 0.6 )
			FadeOut:SetSmoothing( 'IN_OUT' )

			self['Animation'] = Animation
		end

		if( not self['AuraGrowth'] ) then
			local AuraGrowth = self:CreateAnimationGroup()

			local Grow = AuraGrowth:CreateAnimation( 'Scale' )
			Grow:SetOrder( 1 )
			Grow:SetDuration( 0.2 )
			Grow:SetScale( 1.25, 1.25 )

			local Shrink = AuraGrowth:CreateAnimation( 'Scale' )
			Shrink:SetOrder( 2 )
			Shrink:SetDuration( 0.2 )
			Shrink:SetScale( 0.75, 0.75 )

			self['AuraGrowth'] = AuraGrowth

			self:SetScript( 'OnShow', function( self )
				if( self['AuraGrowth'] ) then
					self['AuraGrowth']:Play()
				end
			end )
		end

		self['Duration'] = Duration
		self['Bar'] = Bar
		self['Holder'] = Holder
		self['Filter'] = self:GetParent():GetAttribute( 'filter' )

		self:SetScript( 'OnAttributeChanged', OnAttributeChanged )
	else
		local x = self:GetWidth()
		local y = self:GetHeight()

		local Overlay = self:CreateTexture( nil, 'OVERLAY' )
		Overlay:SetTexture( 'Interface\\Icons\\misc_arrowdown' )
		Overlay:SetInside()
		Overlay:SetTexCoord( unpack( S['TextureCoords'] ) )

		self['Overlay'] = Overlay
	end

	self['Icon'] = Icon
	self['Count'] = Count
	self:ApplyStyle( nil, true )
end

local OnEnterWorld = function()
	for _, Header in next, Headers do
		local Child = Header:GetAttribute( 'child1' )
		local index = 1

		while( Child ) do
			UpdateAura( Child, Child:GetID() )

			index = index + 1
			Child = Header:GetAttribute( 'child' .. index )
		end
	end
end

S['Auras_Init'] = function()
	if( not sCoreCDB['Auras']['Auras_Enable'] ) then
		return
	end

	DisableBlizzard()
	CreateMover()
	CreateFrames()

	local EnterWorld = CreateFrame( 'Frame' )
	EnterWorld:RegisterEvent( 'PLAYER_ENTERING_WORLD' )
	EnterWorld:SetScript( 'OnEvent', function( self, event )
		OnEnterWorld()
	end )
end
