addon.name      = 'mobdb'
addon.author    = 'Thorny';
addon.version   = '1.0';
addon.desc      = 'Displays various information about monsters.';
addon.link      = 'https://ashitaxi.com/';

require('common');
chat = require('chat');
ffi = require('ffi');
imgui = require('imgui');

gData = require('database');
gSettings = require('settings');
gTextures = require('textures');
gTextures:Initialize();

gBar = require('bar');

ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0) then
        return;
    end
    args[1] = string.lower(args[1]);
    if (args[1] ~= '/md') and (args[1] ~= '/mobdb') then
        return;
    end
    e.blocked = true;

    if (#args == 1) or (args[2] == 'config') then
        gSettings.GUI.IsOpen[1] = not gSettings.GUI.IsOpen[1];
        return;
    end

    if (#args > 1) then
        if (args[2] == 'import') then
            local import = require('import');
            import:BuildTables();
            import:GenerateData();            
        end
    end
end);


ashita.events.register('d3d_present', 'mobdb_main_render', function()
    gBar:Render();
end);


ashita.events.register('packet_in', 'mobdb_zone_change_check', function(e)
    if e.id == 0x00A then
        local zone = struct.unpack('H', e.data, 0x30 + 1);
        gData:Load(zone);
    end
end);