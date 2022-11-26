# MobDB
MobDB is an addon that displays monster information onscreen, in the same vein as ibar.  For most users, you should not need to do anything besides loading the addon.<br><br>

## /mobdb config ##
You can type this command to edit the size of mobdb and change the tokens, either for a specific character or for all characters.<br><br>
This will let you adjust the size of mobdb, or you can click the edit tokens button to change what information is displayed.<br><br>

## To-Do ##
1. Data parser already handles drop lists and spell lists, among other information.  A later version will include the ability to display a detailed window with far more information about the monster.  This would be larger onscreen, so it will be entirely optional and driven by a command to toggle it on/off.
2. Manual revisions for Dynamis-D and Odyssey to increase usefulness for retail players.
3. Add editor window so mobs can be edited in realtime, and quick note command to save notes on any target.

## Generating Data For Your Custom Server ##
This process is only intended for advanced users, and will allow you to generate data files that exactly match your LSB-based private server.  To do this, follow these directions:
1. Load the addon to generate initial configurations if you haven't.<br>
2. Copy the following files into Ashita/addons/config/mobdb/inputs from your LSB server source:<br>
- mob_droplist.sql
- mob_family_system.sql
- mob_groups.sql
- mob_resistances.sql
- mob_spawn_points.sql
- mob_spell_lists.sql
3. Type the command ingame.  This will freeze your instance for a considerable period while it generates files.<br>
4. Copy the files generated from Ashita/addons/config/mobdb/outputs to Ashita/addons/mobdb/data.