RareAnnounce
This addon originally started as a way to announce loot drops from Rare mobs but has grown to be useful in instances and against world bosses.

Use /rare or /rareannounce to open the options menu. All options are DISABLED by default.

If you enable Boss announcement I highly recommend using the filtering options.

RareAnnounce will only announce Boss drops to the Group in the "Master Looter" or "Free for All" loot method.

RareAnnounce will always announce Boss drops if you choose a channel other than "Group" "Say" or "Yell".

Current Features

Announce Rares looted to /Say, /Guild, /Yell, or Custom Chat Channel.
Announce Bosses/Chests looted to /Say, "Group", /Guild, /Yell, or Custom Chat Channel.
Automatically determines whether to use /Party or /Raid when you select the "Group" announcement method.
Announced loot is grouped into fewer lines. First line is target class and name with 2 item links, then each line after contains 3 item links.
Passes the last mob announced to the addon channel to prevent others running RareAnnounce from announcing.
Shows Chest names if the mouse is still on it when the loot window opens.
If you are announcing to a custom chat channel and leave that channel RareAnnounce will change your setting to the default.
Default Announcements are: "Guild" for Rares and "Group" for Bosses.
Request Features you want to see in the comments.

Coming (Eventually)

I'm working on a popup window option for non-announcers in groups similar to the roll window, So using this addon in a group while you aren't announcing will pop up a small window with icons for the dropped items allowing you to mouseover them to see stats. This update may take a while to appear though. I'm not sure when this feature will ever make it in, but I'll keep working on it in my spare time. Not that I have much time to call spare.
Known Issues

No currently reported issues. If you see something drop a note.
Resolved Issues

The Cancel button is now properly canceling dropdownmenu selections.
Custom Chat Channels are now saved in SavedVariables and can now be selected after the UI reloads.
Sometimes was not announcing drops to /Guild or Custom Chat Channel if you weren't the first person to loot. This had to do with the way the addon prevents others running the addon from spamming the same information to the group.
Disenchanting and Skinning Loot no longer triggers an announcement.
Should no longer announce the same items if you have more than one boss with loot and you go back and forth between them. ( Ex. Omnotron Defense System )
I Think I finally fixed Multi-Announcements. Recent changes in WoW prevented addons from receiving messages they sent over the addon channel so RA wasn't getting its own announcement prevention messages anymore.
Now Compatible with 5.0.4