
addon.name      = 'mobdb'
addon.author    = 'Thorny';
addon.version   = '1.0';
addon.desc      = 'Displays various information about monsters.';
addon.link      = 'https://ashitaxi.com/';

require('common');
chat = require('chat');
local bar = require('bar');
local import = require('import');

ashita.events.register('d3d_present', 'mobdb_main_render', function()
    bar:Render();
end);

import:BuildTables();
import:GenerateData();