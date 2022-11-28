# MobDB
MobDB is an addon that displays monster information onscreen, in the same vein as ibar.  For most users, you should not need to do anything besides loading the addon.<br><br>

## /mobdb config ##
You can type this command to edit the appearance of mobdb and change the tokens, either for a specific character or for all characters.  The 'Edit Tokens' button will allow you to change the display strings.

## To-Do ##
1. Data parser already handles drop lists and spell lists, among other information.  A later version will include the ability to display a detailed window with far more information about the monster.  This would be larger onscreen, so it will be entirely optional and driven by a command to toggle it on/off.
2. Manual revisions for Dynamis-D and Odyssey to increase usefulness for retail players.
3. Add editor window so mobs can be edited in realtime, and quick note command to save notes on any target.

## Generating Data For Your Custom Server ##
This process is only intended for advanced users, and will allow you to generate data files that exactly match your LSB or wings based private server.  To do this, follow these directions:
1. Change line 2 of import.lua to reflect your current FFXI install path.
2. Load the addon to generate initial configurations if you haven't.  Reload to update path if you changed it.
3. Copy the following files into Ashita/config/addons/mobdb/input/ from your LSB server source:
- mob_droplist.sql
- mob_family_system.sql
- mob_groups.sql
- mob_pools.sql
- mob_resistances.sql (only for LSB-based servers, wings based won't have this)
- mob_spawn_points.sql
- mob_spell_lists.sql
4. Type the command "/mobdb import wings" or "/mobdb import lsb" ingame.  This may take several minutes depending on your system.
5. Copy the files generated from Ashita/config/addons/mobdb/output/ to Ashita/addons/mobdb/data.