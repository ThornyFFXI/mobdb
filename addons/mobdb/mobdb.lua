addon.name      = 'mobdb'
addon.author    = 'Thorny';
addon.version   = '1.19';
addon.desc      = 'Displays various information about monsters.';
addon.link      = 'https://ashitaxi.com/';

require('common');
chat = require('chat');
d3d8 = require('d3d8');
d3d8_device = d3d8.get_device();
ffi = require('ffi');
imgui = require('imgui');

gCompatibility = require('compatibility');
gData = require('database');
gSettings = require('settings');
gTextures = require('textures');
gTextures:Initialize();

gBar = require('bar');
gDetails = require('details');

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
        if (string.lower(args[2]) == 'detail') then
            gSettings.DetailView = not gSettings.DetailView;
            gSettings:Save(gSettings.CharacterSpecific);
            
        elseif (string.lower(args[2]) == 'test') then
            local successCount = 0;
            local totalCount = 0;
            for index = 1,300 do
                local path = string.format('%saddons/mobdb/data/%u.lua', AshitaCore:GetInstallPath(), index);
                if ashita.fs.exists(path) then
                    totalCount = totalCount + 1;
                    local success, loadError = loadfile(path);
                    if not success then
                        print(chat.header('MobDB') .. chat.error(string.format('Failed to load resource file: %s', path)));
                        print(chat.header('MobDB') .. chat.error(loadError));
                        return nil;
                    end

                    local result, output = pcall(success);
                    if not result then
                        print(chat.header('MobDB') .. chat.error(string.format('Failed to call resource file: %s', path)));
                        print(chat.header('MobDB') .. chat.error(loadError));
                        return nil;
                    end

                    if type(output) ~= 'table' then
                        print(chat.header('MobDB') .. chat.error(string.format('Resource file did not return a table: %s', path)));
                    else
                        successCount = successCount + 1;
                    end
                end
            end

        elseif (string.lower(args[2]) == 'import') then
            if (#args > 2) then
                local importer = string.format('%saddons/mobdb/import_%s.lua', AshitaCore:GetInstallPath(), args[3]);
                if ashita.fs.exists(importer) then
                    local success, loadError = loadfile(importer);
                    if not success then
                        print(chat.header('MobDB') .. chat.error(string.format('Failed to load resource file: %s', importer)));
                        print(chat.header('MobDB') .. chat.error(loadError));
                        return;
                    end
                
                    local result, output = pcall(success);
                    if not result then
                        print(chat.header('MobDB') .. chat.error(string.format('Failed to call importer file: %s', importer)));
                        print(chat.header('MobDB') .. chat.error(output));
                        return;
                    end

                    output:BuildTables(false);
                    output:GenerateData();
                else
                    print(chat.header('MobDB') .. chat.error('Failed to locate importer at: ' .. chat.color1(2, importer) .. chat.error('.')));
                end
                return;
            end
            print(chat.header('MobDB') .. chat.error('Invalid syntax.  Please use ') .. chat.color1(2, '/mobdb import [importer]') .. chat.error(' or ') .. chat.color1(2, '/mobdb import test') .. chat.error('.'));
        end
    end
end);


ashita.events.register('d3d_present', 'mobdb_main_render', function()
    if (gSettings.DetailView) then
        gDetails:Render();
    else
        gBar:Render();
    end
end);


ashita.events.register('packet_in', 'mobdb_zone_change_check', function(e)
    if e.id == 0x00A then
        local zone = struct.unpack('H', e.data, 0x30 + 1);
        gData:Load(zone);
    end
end);
