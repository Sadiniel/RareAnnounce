-- RareAnnounce
-- By Sadiniel <Dispel Stupid> of Garona

local RAversion = GetAddOnMetadata("RareAnnounce", "Version");
local RareAnnounce = CreateFrame("Frame", "RareAnnounce");
	
function RareAnnounce_Config()

	-- This is all to set up the options window.
	-- I really hated making this, worst documented API EVER.
	
	RareAnnounceOptions = CreateFrame("Frame", "RareAnnounceOptionPanel", UIParent);
	RareAnnounceOptions.name = "RareAnnounce";
	InterfaceOptions_AddCategory(RareAnnounceOptions);

	RareAnnounceOptions.title = RareAnnounceOptions:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
	RareAnnounceOptions.title:SetText("RareAnnounce Options");
	RareAnnounceOptions.title:SetPoint("TOPLEFT", RareAnnounceOptions,"TOPLEFT" , 10, -15);

	RareAnnounceOptions.AnnounceRareCheck = CreateFrame("CheckButton", "AnnounceRareCheck", RareAnnounceOptions, "InterfaceOptionsCheckButtonTemplate");
	AnnounceRareCheckText:SetText("Enable Announcement for Rares.");
	RareAnnounceOptions.AnnounceRareCheck:SetPoint("TOPLEFT", RareAnnounceOptions, "TOPLEFT", 15, -50);
	
	RareMenu = CreateFrame("Frame", "AnnounceRareChannel", RareAnnounceOptions, "UIDropDownMenuTemplate");
	RareMenu:SetPoint("TOPLEFT", RareAnnounceOptions, "TOPLEFT" , 30, -80);
	RareMenu_OnEvent(RareMenu);
	
	RareAnnounceOptions.AnnounceRareChannelText = RareAnnounceOptions:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	RareAnnounceOptions.AnnounceRareChannelText:SetText("Rare Announcement Channel");
	RareAnnounceOptions.AnnounceRareChannelText:SetPoint("TOPLEFT", RareAnnounceOptions,"TOPLEFT" , 190, -87);
	
	RareAnnounceOptions.AnnounceBossCheck = CreateFrame("CheckButton", "AnnounceBossCheck", RareAnnounceOptions, "InterfaceOptionsCheckButtonTemplate");
	AnnounceBossCheckText:SetText("Enable Announcement for Bosses.");
	RareAnnounceOptions.AnnounceBossCheck:SetPoint("TOPLEFT", RareAnnounceOptions, "TOPLEFT", 15, -150);
	
	RareAnnounceOptions.AnnounceBossLeaderCheck = CreateFrame("CheckButton", "AnnounceBossLeaderCheck", RareAnnounceOptions, "InterfaceOptionsCheckButtonTemplate");
	AnnounceBossLeaderCheckText:SetText("Announce only when you are the Party or Raid Leader.");
	RareAnnounceOptions.AnnounceBossLeaderCheck:SetPoint("TOPLEFT", RareAnnounceOptions, "TOPLEFT", 30, -180);
	
	RareAnnounceOptions.AnnounceBossLooterCheck = CreateFrame("CheckButton", "AnnounceBossLooterCheck", RareAnnounceOptions, "InterfaceOptionsCheckButtonTemplate");
	AnnounceBossLooterCheckText:SetText("Announce only when you are the Master Looter.");
	RareAnnounceOptions.AnnounceBossLooterCheck:SetPoint("TOPLEFT", RareAnnounceOptions, "TOPLEFT", 30, -210);
	
	BossMenu = CreateFrame("Frame", "AnnounceBossChannel", RareAnnounceOptions, "UIDropDownMenuTemplate");
	BossMenu:SetPoint("TOPLEFT", RareAnnounceOptions, "TOPLEFT" , 30, -240);
	BossMenu_OnEvent(BossMenu);
	
	RareAnnounceOptions.AnnounceBossChannelText = RareAnnounceOptions:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	RareAnnounceOptions.AnnounceBossChannelText:SetText("Boss Announcement Channel");
	RareAnnounceOptions.AnnounceBossChannelText:SetPoint("TOPLEFT", RareAnnounceOptions,"TOPLEFT" , 190, -247);
	
	RareAnnounceOptions.okay = function (self) RareAnnounce_Okay(); end;
	RareAnnounceOptions.cancel = function (self) RareAnnounce_Cancel(); end;
end

function RareMenu_OnEvent(self, event, ...)
	
	local value = RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL;
	self.defaultValue = "guild";
	self.oldValue = value;
	self.value = self.oldValue or self.defaultValue;
	
	UIDropDownMenu_Initialize(self, RareMenu_Initialize);
	UIDropDownMenu_SetSelectedValue(self, value);

	self.SetValue = 
		function (self, value)
			self.value = value;
			UIDropDownMenu_SetSelectedValue(self, value);
		end
	self.GetValue =
		function (self)
			return UIDropDownMenu_GetSelectedValue(self);
		end
	self.RefreshValue =
		function (self)
			UIDropDownMenu_Initialize(self, RareMenu_Initialize);
			UIDropDownMenu_SetSelectedValue(self, self.value);
		end
	
end

function BossMenu_OnEvent(self, event, ...)
	
	local value = RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL;
	self.defaultValue = "group";
	self.oldValue = value;
	self.value = self.oldValue or self.defaultValue;
	
	UIDropDownMenu_Initialize(self, BossMenu_Initialize);
	UIDropDownMenu_SetSelectedValue(self, value);

	self.SetValue = 
		function (self, value)
			self.value = value;
			UIDropDownMenu_SetSelectedValue(self, value);
		end
	self.GetValue =
		function (self)
			return UIDropDownMenu_GetSelectedValue(self);
		end
	self.RefreshValue =
		function (self)
			UIDropDownMenu_Initialize(self, BossMenu_Initialize);
			UIDropDownMenu_SetSelectedValue(self, self.value);
		end

end

function RareMenu_OnClick( self )

	RareMenu:SetValue(self.value);

end

function BossMenu_OnClick( self )
	
	BossMenu:SetValue(self.value);

end

function RareMenu_Initialize(self)
	
	local selectedValue = UIDropDownMenu_GetSelectedValue(self);
	local info = UIDropDownMenu_CreateInfo();
	
	info.text = "Say";
	info.func = RareMenu_OnClick;
	info.value = "say";
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.tooltipTitle = "Say";
	info.tooltipText = "Announce to the /Say chat channel";
	UIDropDownMenu_AddButton(info);
	
	info.text = "Guild";
	info.func = RareMenu_OnClick;
	info.value = "guild";
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.tooltipTitle = "Guild";
	info.tooltipText = "Announce to the /Guild chat channel";
	UIDropDownMenu_AddButton(info);
	
	info.text = "Yell";
	info.func = RareMenu_OnClick;
	info.value = "yell";
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.tooltipTitle = "Yell";
	info.tooltipText = "Announce to the /Yell chat channel";
	UIDropDownMenu_AddButton(info);
	
end

function BossMenu_Initialize(self)
	
	local selectedValue = UIDropDownMenu_GetSelectedValue(self);
	local info = UIDropDownMenu_CreateInfo();
	
	info.text = "Say";
	info.func = BossMenu_OnClick;
	info.value = "say";
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.tooltipTitle = "Say";
	info.tooltipText = "Announce to the /Say chat channel";
	UIDropDownMenu_AddButton(info);
	
	info.text = "Group";
	info.func = BossMenu_OnClick;
	info.value = "group";
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.tooltipTitle = "Group";
	info.tooltipText = "Announce to the /Party or /Raid chat channel";
	UIDropDownMenu_AddButton(info);
	
	info.text = "Guild";
	info.func = BossMenu_OnClick;
	info.value = "guild";
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.tooltipTitle = "Guild";
	info.tooltipText = "Announce to the /Guild chat channel";
	UIDropDownMenu_AddButton(info);
	
	info.text = "Yell";
	info.func = BossMenu_OnClick;
	info.value = "yell";
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.tooltipTitle = "Yell";
	info.tooltipText = "Announce to the /Yell chat channel";
	UIDropDownMenu_AddButton(info);
		
end

function RareAnnounce_Okay()

	-- When you click that little "Okay" button in the options window
	-- the game saves all that information to your Saved Variables
	
	RareAnnounceConfig.ANNOUNCE_RARE = AnnounceRareCheck:GetChecked();
	RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL = UIDropDownMenu_GetSelectedValue(RareMenu);
    
	RareAnnounceConfig.ANNOUNCE_BOSS = AnnounceBossCheck:GetChecked();
	RareAnnounceConfig.ANNOUNCE_BOSS_IF_LEADER = AnnounceBossLeaderCheck:GetChecked();
	RareAnnounceConfig.ANNOUNCE_BOSS_IF_LOOTER = AnnounceBossLooterCheck:GetChecked();
	RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL = UIDropDownMenu_GetSelectedValue(BossMenu);
	
end

function RareAnnounce_Cancel()

	-- When you click that little "Cancel" button in the options window
	-- the game replaces the information in the window with your Saved Variables
	
	local rarevalue = RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL
	local bossvalue = RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL
	
	AnnounceRareCheck:SetChecked(RareAnnounceConfig.ANNOUNCE_RARE);
	RareMenu:RefreshValue();
	
	AnnounceBossCheck:SetChecked(RareAnnounceConfig.ANNOUNCE_BOSS);
	AnnounceBossLeaderCheck:SetChecked(RareAnnounceConfig.ANNOUNCE_BOSS_IF_LEADER);
	AnnounceBossLooterCheck:SetChecked(RareAnnounceConfig.ANNOUNCE_BOSS_IF_LOOTER);
	BossMenu:RefreshValue();
	
end

function RareAnnounce_OnLoad(self)

	-- Version message for the chat window and registering events
	
	ChatFrame1:AddMessage("RareAnnounce version " .. RAversion .. " loaded successfully.", .9, 0, .9);
	self:RegisterEvent("LOOT_OPENED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_LOGIN");
	
	-- If we don't have a Saved Variables entry, we will after this
	-- Saved variables are by character so if you just want to announce on certain ones you can.
	
	if	(RareAnnounceConfig == nil) then
		RareAnnounceConfig = {};
	end
	
	if	RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL == nil then RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL = "guild"; end
	if	RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL == nil then RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL = "group"; end
	
	-- Setting up the otions window

	RareAnnounce_Config();
	
	-- Everyone loves /commands, so much more convenient than clicking
	-- 40 buttons to find the options window.
	
	SlashCmdList["RAREANNOUNCE"] = RareAnnounce_SlashCommand;
	SLASH_RAREANNOUNCE1 = "/rare"
	SLASH_RAREANNOUNCE2 = "/rareannounce"
end

function RareAnnounce_SlashCommand()

	-- The only thing I do with the /command is open the options window
	-- Talk about being lazy.
	
	InterfaceOptionsFrame_OpenToCategory(RareAnnounceOptions);
end

function RareAnnounce_OnEvent(self, event, ...)

	-- Event catching:
	
	if	( event == "PLAYER_LOGIN" ) then
	
		-- We use the options window '_Cancel()' function to fill in the addon options window
		-- from the saved variables file before we see it
	
		RareAnnounce_Cancel();
		
	elseif	( event == "LOOT_OPENED" ) then
	
		-- This is where the magic happens
		
		local targetclass = UnitClassification("target");
		local tarclass
		
		-- The API function 'UnitClassification("target")' uses all lowercase letters
		-- so we change them here to something that looks better in chat.
		
		if	( targetclass == "rare" ) then
			tarclass = "Rare";
		elseif	( targetclass == "rareelite" ) then
			tarclass = "Rare-Elite";
		elseif	( targetclass == "worldboss" ) then
			tarclass = "Boss";
		elseif	( targetclass == "elite" ) then
			tarclass = "Elite";
		end
		
		-- Rare Section starts here
		
		if	( RareAnnounceConfig.ANNOUNCE_RARE ) then
			if	( targetclass == "rare" ) or
				( targetclass == "rareelite" ) then
				local numitems = GetNumLootItems();
				for i=1, numitems, 1 do
					if ( not LootSlotIsCoin(i)) then
						local icon, name, quantity, quality = GetLootSlotInfo(i);
						
						--[[ debug
						ChatFrame1:AddMessage( "Found item: " .. name .. " Quality: " .. quality, .9, 0, .9 );
						--]]
						
						-- Quality: 0 is Gray, 1 is White, 2 is Green, 3 is Blue, 4 is Purple, and 5 is Orange
						-- We only want to announce if the Quality is above White ( > 1 ) for rares
							
						if (quality > 1) then
							local itemlink = GetLootSlotLink(i);
							local tarname = UnitName("target");
							
							--[[ debug
							ChatFrame1:AddMessage( tarclass .. ": " .. tarname .. " Dropped: " .. itemlink, .9, 0, .9 );
							--]]
							
							SendChatMessage( tarclass .. ": " .. tarname .. " Dropped: " .. itemlink  , RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL , nil , nil );
						end
					end
				end
			end
		end
		
		-- Boss Section starts here
		
		if	( RareAnnounceConfig.ANNOUNCE_BOSS ) then
			local inInstance, instanceType = IsInInstance();
			local lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod();
			
			-- First thing to do is see if the player is looting a world boss or inside an instance.
			-- Also, we check here to see if the group is using Master Looter, since displaying the loot
			-- won't matter if everyone has roll boxes anyway.
			
			if	( ( ( targetclass == "worldboss" ) or ( inInstance ) ) and ( lootmethod == "master" ) ) then
				
				--[[ debug
				ChatFrame1:AddMessage( "-- Boss Checked", .9, 0, .9 );
				-- ]]
				
				-- This is a cenfusing section.
				-- In short, if you did not choose one of the special boss options,
				-- or if you did and meet the requirements we announce the loot to chat.
				
				local announcepermission = false;
				if	( ( RareAnnounceConfig.ANNOUNCE_BOSS_IF_LEADER == nil ) and ( RareAnnounceConfig.ANNOUNCE_BOSS_IF_LOOTER == nil ) ) then
					announcepermission = true;
					
					--[[ debug
					ChatFrame1:AddMessage( "-- Leader & Looter not Checked", .9, 0, .9 );
					ChatFrame1:AddMessage( "-- Permission Granted", .9, 0, .9 );
					--]]
					
				elseif	( ( IsPartyLeader() or IsRaidLeader() ) and ( RareAnnounceConfig.ANNOUNCE_BOSS_IF_LEADER ) ) then
					announcepermission = true;
					
					--[[ debug
					ChatFrame1:AddMessage( "-- Group Leader & Leader Checked", .9, 0, .9 );
					ChatFrame1:AddMessage( "-- Permission Granted", .9, 0, .9 );
					--]]
					
				elseif	( lootmethod == "master" ) then
					if	( ( masterlooterPartyID == 0 ) or ( masterlooterRaidID == UnitInRaid("player") ) and ( RareAnnounceConfig.ANNOUNCE_BOSS_IF_LOOTER ) ) then
						announcepermission = true;
						
						--[[ debug
						ChatFrame1:AddMessage( "-- Master Looter & Looter Checked", .9, 0, .9 );
						ChatFrame1:AddMessage( "-- Permission Granted", .9, 0, .9 );
						--]]
						
					end
				elseif	( UnitLevel("player") > 59 ) then
					if	( UnitLevel("target") > ( UnitLevel("player") - 5 ) ) then
						if	not ( targetclass == "worldboss" ) then
							announcepermission = true;
						
							--[[ debug
							ChatFrame1:AddMessage( "-- Level 60+ Non-Trivial instance Trash drop", .9, 0, .9 );
							ChatFrame1:AddMessage( "-- Permission Granted", .9, 0, .9 );
							--]]
							
						end
					end
				else
					--[[ debug
					ChatFrame1:AddMessage( "-- Permission Denied", .9, 0, .9 );
					--]]
				end
				
				if	(announcepermission) then	
				
					-- Now that we're inside we need to see if there's anything worth announcing
					
					local tarname = UnitName("target");
					local numitems = GetNumLootItems();
					
					-- Instances sometimes have Chests, so we need to catch that error before it happens
						
					if ( tarclass == nil ) then
						tarclass = "Chest";
					end
					if ( tarname == nil ) then
						tarname = "Chest";
					end
					
					if ( not ( lasttarname == tarname ) ) then
					
						for i=1, numitems, 1 do
							if (not LootSlotIsCoin(i)) then
								local icon, name, quantity, quality= GetLootSlotInfo(i);	
							
								--[[ debug 
								ChatFrame1:AddMessage( "-- Found item: " .. name .. " Quality: " .. quality, .9, 0, .9 );	
								--]]
							
								-- Quality: 0 is Gray, 1 is White, 2 is Green, 3 is Blue, 4 is Purple, and 5 is Orange
								-- We only want to announce if the Quality is above Green ( > 2 ) for bosses or chests
							
								if ( quality > 2 ) then
									local itemlink = GetLootSlotLink(i);
								
									--[[ debug 
									ChatFrame1:AddMessage( "-- " .. tarclass .. ": " .. tarname .. " Dropped: " .. itemlink, .9, 0, .9 );
									--]]
								
									-- Since there are two types of "group" we have to do something special for them.
								
									if	( RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL == "group" ) then
										local partyorraid;
										if ( UnitInRaid("player") ) then
											partyorraid = "raid";
										else
											partyorraid = "party";
										end
										SendChatMessage( tarclass .. ": " .. tarname .. " Dropped: " .. itemlink  , partyorraid , nil , nil);
									else
										SendChatMessage( tarclass .. ": " .. tarname .. " Dropped: " .. itemlink  , RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL , nil , nil );
									end
								end
							end
						end
					
						-- Since we don't want to constantly spam the chat if we loot the body multiple times
						-- we copy the name of the last mob we announced to prevent announcing again.
					
						lasttarname = tarname;
					end
				end
			end
		end
	end	
end -- That's all. 482 lines of nightmarish code. With no library dependencies.