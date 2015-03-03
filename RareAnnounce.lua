-- RareAnnounce
-- By Sadiniae <Prophet of Cthulhu> on Garona-Alliance-US
local DEBUG = false;

local RAversion = GetAddOnMetadata("RareAnnounce", "Version");
local RareAnnounce = CreateFrame("Frame", "RareAnnounce");
--[[
local RareAnnounceLocal = CreateFrame("Frame", "RareAnnounceLocal", UIParent);
	RareAnnounceLocal:SetPoint("CENTER");
	RareAnnounceLocal:SetHeight(60);
	local tex = RareAnnounceLocal:CreateTexture("ARTWORK");
	tex:SetAllPoints();
	tex:SetTexture(1.0, 0.5, 0); tex:SetAlpha(0.5);
--]]
local BlockedItemIDs = {	30311, 30312, 30313, 30314, 30315, 30316, 30317, 30318, -- Throwaway Legendaries from the Eye
							10978, 11084, 11138, 11139, 11177, 11178, 14343, 14344, 20725, 22448, 22450, 22449, 34052, 34057, 34053, 52720, 105718, -- Enchanting Shards
							52722, 52721, 74252, 102218, 94289, 74248, 74247, 80433, 115504, 115502, 113588, 111245, 113589, -- More Shards
							15410, 44128, 52980, 98617, 72163, 110611, -- Skinning Materials
							120945, -- Primal Spirit
}

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
	
	RareAnnounceOptions.AnnounceLootCheck = CreateFrame("CheckButton", "AnnounceLootCheck", RareAnnounceOptions, "InterfaceOptionsCheckButtonTemplate");
	AnnounceLootCheckText:SetText("Enable Announcement of Special Loot. (LFR / Bonus Rolls)");
	RareAnnounceOptions.AnnounceLootCheck:SetPoint("TOPLEFT", RareAnnounceOptions, "TOPLEFT", 15, -310);
	
	LootMenu = CreateFrame("Frame", "AnnounceLootChannel", RareAnnounceOptions, "UIDropDownMenuTemplate");
	LootMenu:SetPoint("TOPLEFT", RareAnnounceOptions, "TOPLEFT" , 30, -340);
	LootMenu_OnEvent(LootMenu);
	
	RareAnnounceOptions.AnnounceLootChannelText = RareAnnounceOptions:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	RareAnnounceOptions.AnnounceLootChannelText:SetText("Special Loot Announcement Channel");
	RareAnnounceOptions.AnnounceLootChannelText:SetPoint("TOPLEFT", RareAnnounceOptions,"TOPLEFT" , 190, -347);
	
	-- RareAnnounceOptions.AnnounceLocalCheck = CreateFrame("CheckButton", "AnnounceLocalCheck", RareAnnounceOptions, "InterfaceOptionsCheckButtonTemplate");
	-- AnnounceLocalCheckText:SetText("Enable display of announced drops in a window.");
	-- RareAnnounceOptions.AnnounceLocalCheck:SetPoint("TOPLEFT", RareAnnounceOptions, "TOPLEFT", 15, -410);
	
	RareAnnounceOptions.okay = function (self) RareAnnounce_Okay(); end;
	RareAnnounceOptions.cancel = function (self) RareAnnounce_Cancel(); end;
	RareAnnounceOptions.default = function (self) RareAnnounce_Default(); end;
end

function RareMenu_OnEvent(self, event, ...)
	
	-- All this terrible code you see in the next six functions are what
	-- make the DropDownBoxes work. The code is ugly as sin and a terrible
	-- pain to work with, but it's the only thing I found that would produce
	-- functional results.
	
	-- This is basically copied directly from the Blizzard Options Panel.
	
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

function LootMenu_OnEvent(self, event, ...)
	
	local value = RareAnnounceConfig.ANNOUNCE_LOOT_CHANNEL;
	self.defaultValue = "guild";
	self.oldValue = value;
	self.value = self.oldValue or self.defaultValue;
	
	UIDropDownMenu_Initialize(self, LootMenu_Initialize);
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
			UIDropDownMenu_Initialize(self, LootMenu_Initialize);
			UIDropDownMenu_SetSelectedValue(self, self.value);
		end

end

function RareMenu_OnClick( self )

	-- These two functions may look entirely pointless and look like
	-- something you could just write in the appropriate locations
	-- but I assure you, that doesn't work.
	
	RareMenu:SetValue(self.value);

end

function BossMenu_OnClick( self )
	
	BossMenu:SetValue(self.value);

end

function LootMenu_OnClick( self )
	
	LootMenu:SetValue(self.value);

end

function RareMenu_Initialize(self)
	
	-- Making the DropDownBox List for the Rare Menu.
	
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
	
	local channelList = RareAnnounceConfig.CHANNEL_LIST;
	if ( channelList ~= nil ) then
	local n = #channelList;
		for i=1 , n , 2 do
			info.text = "#" .. channelList[i] .. ". " .. channelList[i+1];
			info.func = RareMenu_OnClick;
			info.value = channelList[i];
			if ( info.value == selectedValue ) then
				info.checked = 1;
			else
				info.checked = nil;
			end
			info.tooltipTitle = "Channel";
			info.tooltipText = "Announce to the " .. channelList[i+1] .. " chat channel";
			UIDropDownMenu_AddButton(info);
		end
	end
end

function BossMenu_Initialize(self)
	
	-- Making the DropDownBox List for the Boss Menu.
	-- The lists are different because the Boss list has more destination options.
	
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
	
	local channelList = RareAnnounceConfig.CHANNEL_LIST;
	if ( channelList ~= nil ) then
		local n = #channelList;
		for i=1 , n , 2 do
			info.text = "#" .. channelList[i] .. ". " .. channelList[i+1];
			info.func = BossMenu_OnClick;
			info.value = channelList[i];
			if ( info.value == selectedValue ) then
				info.checked = 1;
			else
				info.checked = nil;
			end
			info.tooltipTitle = "Channel";
			info.tooltipText = "Announce to the " .. channelList[i+1] .. " chat channel";
			UIDropDownMenu_AddButton(info);
		end
	end
end

function LootMenu_Initialize(self)
	
	-- Making the DropDownBox List for the Special Loot Menu. This list is much smaller.
	
	local selectedValue = UIDropDownMenu_GetSelectedValue(self);
	local info = UIDropDownMenu_CreateInfo();
		
	info.text = "Guild";
	info.func = LootMenu_OnClick;
	info.value = "guild";
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.tooltipTitle = "Guild";
	info.tooltipText = "Announce to the /Guild chat channel";
	UIDropDownMenu_AddButton(info);
	
	local channelList = RareAnnounceConfig.CHANNEL_LIST;
	if ( channelList ~= nil ) then
	local n = #channelList;
		for i=1 , n , 2 do
			info.text = "#" .. channelList[i] .. ". " .. channelList[i+1];
			info.func = LootMenu_OnClick;
			info.value = channelList[i];
			if ( info.value == selectedValue ) then
				info.checked = 1;
			else
				info.checked = nil;
			end
			info.tooltipTitle = "Channel";
			info.tooltipText = "Announce to the " .. channelList[i+1] .. " chat channel";
			UIDropDownMenu_AddButton(info);
		end
	end
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
	
	RareAnnounceConfig.ANNOUNCE_LOOT = AnnounceLootCheck:GetChecked();
	RareAnnounceConfig.ANNOUNCE_LOOT_CHANNEL = UIDropDownMenu_GetSelectedValue(LootMenu);
	
	-- RareAnnounceConfig.LOCAL_DISPLAY = AnnounceLocalCheck:GetChecked();
	
end

function RareAnnounce_Cancel()

	-- When you click that little "Cancel" button in the options window
	-- the game replaces the information in the window with your Saved Variables
	
	AnnounceRareCheck:SetChecked(RareAnnounceConfig.ANNOUNCE_RARE);
	RareMenu:SetValue(RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL);
	RareMenu:RefreshValue();
		
	AnnounceBossCheck:SetChecked(RareAnnounceConfig.ANNOUNCE_BOSS);
	AnnounceBossLeaderCheck:SetChecked(RareAnnounceConfig.ANNOUNCE_BOSS_IF_LEADER);
	AnnounceBossLooterCheck:SetChecked(RareAnnounceConfig.ANNOUNCE_BOSS_IF_LOOTER);
	BossMenu:SetValue(RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL);
	BossMenu:RefreshValue();
	
	AnnounceLootCheck:SetChecked(RareAnnounceConfig.ANNOUNCE_LOOT);
	LootMenu:SetValue(RareAnnounceConfig.ANNOUNCE_LOOT_CHANNEL);
	LootMenu:RefreshValue();
	
	-- AnnounceLocalCheck:SetChecked(RareAnnounceConfig.LOCAL_DISPLAY);
	
end

function RareAnnounce_Default()

	-- When you click that little "Default" button in the options window
	-- the game replaces the information in the window with these defaults
	
	AnnounceRareCheck:SetChecked(nil);
	RareMenu:SetValue("guild");
	RareMenu:RefreshValue();
		
	AnnounceBossCheck:SetChecked(nil);
	AnnounceBossLeaderCheck:SetChecked(1);
	AnnounceBossLooterCheck:SetChecked(1);
	BossMenu:SetValue("group");
	BossMenu:RefreshValue();
	
	AnnounceLootCheck:SetChecked(nil);
	LootMenu:SetValue("guild");
	LootMenu:RefreshValue();
	
	-- AnnounceLocalCheck:SetChecked(nil);
	
end

function RareAnnounce_OnLoad(self)

	-- Version message for the chat window and registering events
	
	-- ChatFrame1:AddMessage("RareAnnounce version " .. RAversion .. " loaded.", .9, 0, .9);
	self:RegisterEvent("LOOT_READY");
	self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE");
	self:RegisterEvent("CHAT_MSG_ADDON");
	self:RegisterEvent("PLAYER_LOGIN");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("SHOW_LOOT_TOAST");
	
	-- If we don't have a Saved Variables entry, we will after this
	-- Saved variables are by character so if you just want to announce on certain ones you can.
	
	if	(RareAnnounceConfig == nil) then RareAnnounceConfig = {}; end
	if	(RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL == nil) then RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL = "guild"; end
	if	(RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL == nil) then RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL = "group"; end
	if	(RareAnnounceConfig.ANNOUNCE_LOOT_CHANNEL == nil) then RareAnnounceConfig.ANNOUNCE_LOOT_CHANNEL = "guild"; end
	
	RareAnnounceConfig.ANNOUNCED_ITEMS_LIST = {};
	
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

function RareAnnounce_Announce( targetName, dropText, itemList, channel )

	-- This section actually makes the announcements to chat and sends the target name
	-- over the addon channel to prevent others using the addon from repeating the announcement
	-- I added this function when I added the ability to announce more than 1 item per message
	-- it was the only way it worked without adding dozens of lines of superfluous code
	
	if ( itemList[2] == nil ) then itemList[2] = " "; end
	if ( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST == nil ) then RareAnnounceConfig.ANNOUNCED_ITEMS_LIST = {}; end
	
	if (type(channel) == "number") then
		SendChatMessage( dropText .. itemList[1] .. itemList[2] , "channel" , nil , channel );
	else
		SendChatMessage( dropText .. itemList[1] .. itemList[2] , channel , nil , nil );
	end
	tinsert( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST, itemList[1] )
	tinsert( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST, itemList[2] )
	
	if ( #itemList > 2 ) then
	
		for i=3, #itemList, 3 do
			if ( itemList[i+1] == nil ) then itemList[i+1] = " "; end
			if ( itemList[i+2] == nil ) then itemList[i+2] = " "; end
			if (type(channel) == "number") then
				SendChatMessage( "#" .. (i/3)+1 .. " " .. itemList[i] .. itemList[i+1] .. itemList[i+2] , "channel" , nil , channel );
			else
				SendChatMessage( "#" .. (i/3)+1 .. " " .. itemList[i] .. itemList[i+1] .. itemList[i+2] , channel , nil , nil );
			end
			tinsert( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST, itemList[i] )
			tinsert( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST, itemList[i+1] )
			tinsert( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST, itemList[i+2] )
		end
	end
end

function RareAnnounce_OnEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)

	-- Event catching:
	
	if	( event == "PLAYER_LOGIN" ) then
		
		-- Setting up the otions window has to be done before the game starts up the UI
		-- I chose to do it at login although there are a couple of other choices

		RareAnnounce_Config();
	
		-- We use the options window '_Cancel()' function to fill in the addon options window
		-- from the saved variables file before we see it
	
		RareAnnounce_Cancel();
		
		RARegistered = false;
		RARegistered = RegisterAddonMessagePrefix("RareAnnounce");
		if	( RARegistered ) then
			ChatFrame1:AddMessage("RareAnnounce version " .. RAversion .. " loaded.", .9, 0, .9);
		end
		if	( DEBUG ) then
			ChatFrame1:AddMessage("Warning: RareAnnounce is running in DEBUG MODE", 1, 0, 0);
		end
		
	elseif  ( event == "PLAYER_REGEN_DISABLED" ) then
	
		if	( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST ~= nil ) then
			wipe( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST );
		end
		
	elseif	( event == "CHAT_MSG_CHANNEL_NOTICE" ) then
		
		if	( ( arg1 == "YOU_JOINED" ) and ( arg7 == 0 ) ) then
		
			-- When you join a Custom Chat Channel this section adds the channel information
			-- to the SavedVariables so it can be selected next time the UI reloads
			
			if	( RareAnnounceConfig.CHANNEL_LIST == nil ) then
			
				-- If there's no channel list in SavedVariables we just make a new list
				
				ChatFrame1:AddMessage( "Channel #" .. arg8 .. " Name: " .. arg9 .. " added to RareAnnounce channel list and will be available next time the UI reloads. (The UI reloads anytime you zone or you can force it with '/console reloadui'.)", .9, 0, .9 );
				RareAnnounceConfig.CHANNEL_LIST = { arg8, arg9 };
				
			elseif not ( tContains(RareAnnounceConfig.CHANNEL_LIST, arg8) ) then
			
				-- If there is a channel list we need to make sure this channel isn't in it
				-- and add it to the list if it's not found
				
				ChatFrame1:AddMessage( "Channel #" .. arg8 .. " Name: " .. arg9 .. " added to RareAnnounce channel list and will be available next time the UI reloads. (The UI reloads anytime you zone or you can force it with '/console reloadui'.)", .9, 0, .9 );
				tinsert(RareAnnounceConfig.CHANNEL_LIST, arg8);
				tinsert(RareAnnounceConfig.CHANNEL_LIST, arg9); 
				
			end
			
		elseif ( ( arg1 == "YOU_LEFT" ) and ( arg7 == 0 ) ) then
			
			-- When you leave a custom chat channel we need to remove it from the channel list
			-- but first we change your announcement channel if you were announcing to it
			
			if ( arg8 == RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL ) then
				ChatFrame1:AddMessage( "You left Channel #" .. arg8 .. " Name: " .. arg9 .. ". Changing your Rare announcement channel to Guild.", .9, 0, .9 );
				RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL = "guild";
			elseif ( arg8 == RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL ) then
				ChatFrame1:AddMessage( "You left Channel #" .. arg8 .. " Name: " .. arg9 .. ". Changing your Boss announcement channel to Group.", .9, 0, .9 );
				RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL = "group";
			end
			
			-- This section searches the saved channel list and actually removes the channel
			
			if tContains(RareAnnounceConfig.CHANNEL_LIST, arg8) then
				local n = 1;
				while RareAnnounceConfig.CHANNEL_LIST[n] do
					if ( RareAnnounceConfig.CHANNEL_LIST[n] == arg8 ) then
					tremove(RareAnnounceConfig.CHANNEL_LIST,n);
					tremove(RareAnnounceConfig.CHANNEL_LIST,n);
					end
					n = n + 1;
				end
			end

		end

	elseif	( ( event == "CHAT_MSG_ADDON" ) and ( arg1 == "RareAnnounce" ) ) then
	
		if ( DEBUG ) then ChatFrame1:AddMessage( "Recieved message containing: " .. arg2 , .9, 0, .9 ); end
		
		if	( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST == nil ) then RareAnnounceConfig.ANNOUNCED_ITEMS_LIST = {}; end
		
		if 	( tContains( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST, arg2 ) ) then
			
			if ( DEBUG ) then ChatFrame1:AddMessage( arg2 .. " already announced, skipping." , .9, 0, .9 ); end
			
		else
			tinsert( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST, arg2 )
			
			if	( ( RareAnnounceConfig.LOCAL_DISPLAY ) and ( GetNumLootItems() == nil ) ) then
			
				-- I'm making this section interesting so I can find it again. I have a lot of work to do to it.
				-- #############################################################################################
				-- #############################################################################################
				
				ChatFrame1:AddMessage( "It worked! If this was implemented you would have a window of icons right now. " .. arg2 , .9, 0, .9 );
				
				--[[
				if	( #RareAnnounceConfig.ANNOUNCED_ITEMS_LIST == 1 ) then
					RareAnnounceLocal:SetWidth(60);
					local itemName, _, _, _, _, _, _, _, _, itemTexture, _ = GetItemInfo(RareAnnounceConfig.ANNOUNCED_ITEMS_LIST[1]);
					
					RareAnnounceLocal.itemButton = CreateFrame("Button", "itemButton", RareAnnounceLocal, "ItemButtonTemplate");
					itemButton:SetNormalTexture(itemTexture);
					itemButton:SetText(itemName);
					itemButton:SetPoint("TOPLEFT", RareAnnounceLocal, "TOPLEFT", 0, 0);
					
					RareAnnounceLocal:Show();
				elseif ( #RareAnnounceConfig.ANNOUNCED_ITEMS_LIST > 1 ) then
					RareAnnounceLocal:Hide();
					for i=1, #RareAnnounceConfig.ANNOUNCED_ITEMS_LIST, 1 do
				
					end
				end
				--]]			
			end
		end
		
	
	elseif	( event == "SHOW_LOOT_TOAST" ) then
		
		-- The Loot Toast is the popup box when you win an item from LFR or a Bonus Loot roll.
		-- This is probably the easiest announcement ever since you don't need to compare it
		-- with anything else, just check if you're inside an instance and pop it out.
		
		if ( RareAnnounceConfig.ANNOUNCE_LOOT ) then
		
			if ( (arg1 ~= nil ) and ( DEBUG ) ) then ChatFrame1:AddMessage( "arg1: " .. arg1, .9, 0, .9 ); end
			if ( (arg2 ~= nil ) and ( DEBUG ) ) then ChatFrame1:AddMessage( "arg2: " .. arg2, .9, 0, .9 ); end
			if ( (arg3 ~= nil ) and ( DEBUG ) ) then ChatFrame1:AddMessage( "arg3: " .. arg3, .9, 0, .9 ); end
			if ( (arg4 ~= nil ) and ( DEBUG ) ) then ChatFrame1:AddMessage( "arg4: " .. arg4, .9, 0, .9 ); end
			
			if ( arg1 == "item" ) then
			
				local inInstance, instanceType = IsInInstance();
			
				if ( ( inInstance ) or ( DEBUG ) ) then
					
					if (type(RareAnnounceConfig.ANNOUNCE_LOOT_CHANNEL) == "number") then
						SendChatMessage( "Received Personal Loot: " .. arg2 , "channel" , nil , RareAnnounceConfig.ANNOUNCE_LOOT_CHANNEL );
					else
						SendChatMessage( "Received Personal Loot: " .. arg2 , RareAnnounceConfig.ANNOUNCE_LOOT_CHANNEL , nil , nil );
					end
				end
			end
		end
	
	elseif	( event == "LOOT_READY" ) then
	
		-- This is where the magic happens
		
		local targetclass = UnitClassification("target");
		local tarclass
		local droptext
		
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
		else
			tarclass = "";
		end
		
		if ( DEBUG ) then ChatFrame1:AddMessage( "Target Class: " .. tarclass, .9, 0, .9 ); end
		
		-- Rare Section starts here
		
		if	( RareAnnounceConfig.ANNOUNCE_RARE ) then
			if	( ( targetclass == "rare" ) or ( targetclass == "rareelite" ) or DEBUG) then
				local numitems = GetNumLootItems();
				local tarname = UnitName("target");
				
				if ( tarname == nil ) then tarname = "Personal loot"; end
				
				if ( DEBUG ) then ChatFrame1:AddMessage( "Number of loot items: " .. numitems, .9, 0, .9 ); end
				
				local lootTable = {};
				for i=1, numitems, 1 do
					if (LootSlotHasItem(i)) then
						local icon, name, quantity, quality = GetLootSlotInfo(i);
						
						if ( name == "Apexis Crystal" ) then quality = 1 end; -- a hack because you can't parse currency links
						
						if ( DEBUG ) then ChatFrame1:AddMessage( "Found item: " .. name .. " Quality: " .. quality, .9, 0, .9 ); end
					
						-- Quality: 0 is Gray, 1 is White, 2 is Green, 3 is Blue, 4 is Purple, and 5 is Orange
						-- We only want to announce if the Quality is above White ( > 1 ) for rares
						
						
						if ((quality > 1) or DEBUG) then -- change to 0 for debug
							local itemlink = GetLootSlotLink(i);
							
							if ( itemlink ~= nil ) then
							
								local itemString = string.match(itemlink, "item[%-?%d:]+");
								local _, itemID, _, _, _, _, _, _, _ = strsplit(":", itemString);
							
								if ( DEBUG ) then ChatFrame1:AddMessage( "Item ID: " .. itemID, .9, 0, .9 ); end
							
								-- We filter out items we don't want to hear about here.
							
								local tempID = tonumber(itemID);
							
								if ( tContains( BlockedItemIDs , tempID ) ) then
								else
									droptext = tarclass .. ": " .. tarname .. " Dropped: ";
						
									if ( DEBUG ) then ChatFrame1:AddMessage( tarclass .. ": " .. tarname .. " Dropped: " .. itemlink, .9, 0, .9 ); end
							
									if	( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST == nil ) then
										RareAnnounceConfig.ANNOUNCED_ITEMS_LIST = { itemlink };
										tinsert(lootTable, itemlink);
										if (type(RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL) == "number") then
										else
											SendAddonMessage( "RareAnnounce" , itemlink , RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL , nil);
										end
									elseif	( tContains( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST, itemlink ) ) then
									else
										tinsert(lootTable, itemlink);
										if (type(RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL) == "number") then
										else
											SendAddonMessage( "RareAnnounce" , itemlink , RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL , nil);
										end
									end
								end
							end
						end
					end
				end
				
				if ( #lootTable > 0 ) then
					RareAnnounce_Announce( tarname, droptext, lootTable, RareAnnounceConfig.ANNOUNCE_RARE_CHANNEL );				
				end
			end -- comment for debug
		end
		
		-- Boss Section starts here
		
		if	( RareAnnounceConfig.ANNOUNCE_BOSS ) then
			local inInstance, instanceType = IsInInstance();
			local lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod();
			
			-- First thing to do is see if the player is looting a world boss or inside an instance.
			-- Also, we check here to see if the group is using Master Looter or we are announcing elsewhere
			-- since displaying the loot to the group won't matter if everyone has roll boxes anyway.
			
			local tempchannel = RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL;
			local announcepermission = false;
			if	( ( targetclass == "worldboss" ) or ( inInstance ) ) then
				if not ( ( tempchannel == "group" ) or ( tempchannel == "say" ) or ( tempchannel == "yell" ) ) then
					announcepermission = true;
				elseif ( ( lootmethod == "master" ) or (lootmethod == "freeforall" ) ) then
				
					-- This is a confusing section.
					-- If we're dealing with a boss and using Master Looter or FFA
					-- and you did not choose one of the special boss options,
					-- or if you did and meet the requirements we gain permission to announce the loot.
				
					if	( ( RareAnnounceConfig.ANNOUNCE_BOSS_IF_LEADER == nil ) and ( RareAnnounceConfig.ANNOUNCE_BOSS_IF_LOOTER == nil ) ) then
						announcepermission = true;
					elseif	( ( UnitIsGroupLeader("player") ) and ( RareAnnounceConfig.ANNOUNCE_BOSS_IF_LEADER ) ) then
						announcepermission = true;
					elseif	( ( masterlooterPartyID == 0 ) or ( masterlooterRaidID == UnitInRaid("player") ) and ( RareAnnounceConfig.ANNOUNCE_BOSS_IF_LOOTER ) ) then
						announcepermission = true;
					elseif	( UnitLevel("player") > 59 ) then
						if	( UnitLevel("target") > ( UnitLevel("player") - 5 ) ) then
							if	( targetclass ~= "worldboss" ) then
								announcepermission = true;
							end
						end
					end
				end
			end
			
			if	(announcepermission) then	
			
				-- Now that we're inside we need to see if there's anything worth announcing
				
				local tarname = UnitName("target");
				local numitems = GetNumLootItems();
				local droptext;
				
				-- Instances sometimes have Chests, so we need to catch that error before it happens
				
				if ( tarclass == nil ) then
					tarclass = "Chest";
					if (GameTooltipTextLeft1:GetText()) then
						tarname = GameTooltipTextLeft1:GetText();
					else
						tarname = "Chest";
					end
				end
				
				local lootTable = {};
				
				for i=1, numitems, 1 do
					if (LootSlotHasItem(i)) then
						local icon, name, quantity, quality= GetLootSlotInfo(i);	
						
						if ( name == "Apexis Crystal" ) then quality = 1 end; -- a hack because you can't parse currency links
						
						if ( DEBUG ) then ChatFrame1:AddMessage( "-- Found item: " .. name .. " Quality: " .. quality, .9, 0, .9 ); end
						
						if ( tarclass == "Chest" ) then
							droptext = tarname .. " Contained: ";
						else
							droptext = tarclass .. ": " .. tarname .. " Dropped: ";
						end
						
						-- Quality: 0 is Gray, 1 is White, 2 is Green, 3 is Blue, 4 is Purple, and 5 is Orange
						-- We only want to announce if the Quality is above Green ( > 2 ) for bosses or chests
					
						if ( quality > 2 ) then
							local itemlink = GetLootSlotLink(i);
							
							local itemString = string.match(itemlink, "item[%-?%d:]+");
							local _, itemID, _, _, _, _, _, _, _ = strsplit(":", itemString);
								
							-- We filter out items we don't want to hear about here.
							
							local tempID = tonumber(itemID);
							
							if ( tContains( BlockedItemIDs , tempID ) ) then
							else
							
								if	( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST == nil ) then
									RareAnnounceConfig.ANNOUNCED_ITEMS_LIST = { itemlink };
									tinsert(lootTable, itemlink);
									
									if	( RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL == "group" ) then
										local partyorraid;
										if ( UnitInRaid("player") ) then
											partyorraid = "raid";
										else
											partyorraid = "party";
										end
										SendAddonMessage( "RareAnnounce" , itemlink , partyorraid , nil);
									else
										SendAddonMessage( "RareAnnounce" , itemlink , RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL , nil);
									end
									
								elseif	( tContains( RareAnnounceConfig.ANNOUNCED_ITEMS_LIST, itemlink ) ) then
								
								else
								
									tinsert(lootTable, itemlink);
									
									if	( RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL == "group" ) then
										local partyorraid;
										if ( UnitInRaid("player") ) then
											partyorraid = "raid";
										else
											partyorraid = "party";
										end
										SendAddonMessage( "RareAnnounce" , itemlink , partyorraid , nil);
									else
										SendAddonMessage( "RareAnnounce" , itemlink , RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL , nil);
									end
								end
							end
						end
					end
				end
				
				-- Since there are two types of "group" (Party or Raid) we have to do something special for them.
				
				if ( #lootTable > 0 ) then
					if	( RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL == "group" ) then
						local partyorraid;
						if ( UnitInRaid("player") ) then
							partyorraid = "raid";
						else
							partyorraid = "party";
						end
						RareAnnounce_Announce( tarname, droptext, lootTable, partyorraid );
					else
					RareAnnounce_Announce( tarname, droptext, lootTable, RareAnnounceConfig.ANNOUNCE_BOSS_CHANNEL );
					end
				end
			end
		end
	end	
end
