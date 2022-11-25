local import = {};
local FFXIPATH = 'C:\\Ashita 4\\client\\FINAL FANTASY XI';
local entityDatPaths = {
    [1] = 'ROM3\\2\\111.DAT',
    [2] = 'ROM3\\2\\112.DAT',
    [3] = 'ROM3\\2\\113.DAT',
    [4] = 'ROM3\\2\\114.DAT',
    [5] = 'ROM3\\2\\115.DAT',
    [6] = 'ROM3\\2\\116.DAT',
    [7] = 'ROM3\\2\\117.DAT',
    [8] = 'ROM3\\2\\118.DAT',
    [9] = 'ROM3\\2\\119.DAT',
    [10] = 'ROM3\\2\\120.DAT',
    [11] = 'ROM3\\2\\121.DAT',
    [12] = 'ROM3\\2\\122.DAT',
    [13] = 'ROM3\\2\\123.DAT',
    [14] = 'ROM3\\2\\124.DAT',
    [15] = 'ROM\\25\\80.DAT',
    [16] = 'ROM3\\2\\126.DAT',
    [17] = 'ROM3\\2\\127.DAT',
    [18] = 'ROM3\\3\\0.DAT',
    [19] = 'ROM3\\3\\1.DAT',
    [20] = 'ROM3\\3\\2.DAT',
    [21] = 'ROM3\\3\\3.DAT',
    [22] = 'ROM3\\3\\4.DAT',
    [23] = 'ROM3\\3\\5.DAT',
    [24] = 'ROM3\\3\\6.DAT',
    [25] = 'ROM3\\3\\7.DAT',
    [26] = 'ROM3\\3\\8.DAT',
    [27] = 'ROM3\\3\\9.DAT',
    [28] = 'ROM3\\3\\10.DAT',
    [29] = 'ROM3\\3\\11.DAT',
    [30] = 'ROM3\\3\\12.DAT',
    [31] = 'ROM3\\3\\13.DAT',
    [32] = 'ROM3\\3\\14.DAT',
    [33] = 'ROM3\\3\\15.DAT',
    [34] = 'ROM3\\3\\16.DAT',
    [35] = 'ROM3\\3\\17.DAT',
    [36] = 'ROM3\\3\\18.DAT',
    [37] = 'ROM3\\3\\19.DAT',
    [38] = 'ROM3\\3\\20.DAT',
    [39] = 'ROM3\\3\\21.DAT',
    [40] = 'ROM3\\3\\22.DAT',
    [41] = 'ROM3\\3\\23.DAT',
    [42] = 'ROM3\\3\\24.DAT',
    [43] = 'ROM3\\3\\25.DAT',
    [44] = 'ROM3\\3\\26.DAT',
    [45] = 'ROM\\25\\110.DAT',
    [46] = 'ROM4\\1\\45.DAT',
    [47] = 'ROM4\\1\\46.DAT',
    [48] = 'ROM4\\1\\47.DAT',
    [50] = 'ROM4\\1\\49.DAT',
    [51] = 'ROM4\\1\\50.DAT',
    [52] = 'ROM4\\1\\51.DAT',
    [53] = 'ROM4\\1\\52.DAT',
    [54] = 'ROM4\\1\\53.DAT',
    [55] = 'ROM4\\1\\54.DAT',
    [56] = 'ROM4\\1\\55.DAT',
    [57] = 'ROM4\\1\\56.DAT',
    [58] = 'ROM4\\1\\57.DAT',
    [59] = 'ROM4\\1\\58.DAT',
    [60] = 'ROM4\\1\\59.DAT',
    [61] = 'ROM4\\1\\60.DAT',
    [62] = 'ROM4\\1\\61.DAT',
    [63] = 'ROM4\\1\\62.DAT',
    [64] = 'ROM4\\1\\63.DAT',
    [65] = 'ROM4\\1\\64.DAT',
    [66] = 'ROM4\\1\\65.DAT',
    [67] = 'ROM4\\1\\66.DAT',
    [68] = 'ROM4\\1\\67.DAT',
    [69] = 'ROM4\\1\\68.DAT',
    [70] = 'ROM4\\1\\69.DAT',
    [71] = 'ROM4\\1\\70.DAT',
    [72] = 'ROM4\\1\\71.DAT',
    [73] = 'ROM4\\1\\72.DAT',
    [74] = 'ROM4\\1\\73.DAT',
    [75] = 'ROM4\\1\\74.DAT',
    [76] = 'ROM4\\1\\75.DAT',
    [77] = 'ROM4\\1\\76.DAT',
    [78] = 'ROM4\\1\\77.DAT',
    [79] = 'ROM4\\1\\78.DAT',
    [80] = 'ROM\\26\\17.DAT',
    [81] = 'ROM\\26\\18.DAT',
    [82] = 'ROM\\26\\19.DAT',
    [83] = 'ROM\\26\\20.DAT',
    [84] = 'ROM\\26\\21.DAT',
    [85] = 'ROM\\26\\22.DAT',
    [86] = 'ROM\\26\\23.DAT',
    [87] = 'ROM\\26\\24.DAT',
    [88] = 'ROM\\26\\25.DAT',
    [89] = 'ROM\\26\\26.DAT',
    [90] = 'ROM\\26\\27.DAT',
    [91] = 'ROM\\26\\28.DAT',
    [92] = 'ROM\\26\\29.DAT',
    [93] = 'ROM\\26\\30.DAT',
    [94] = 'ROM\\26\\31.DAT',
    [95] = 'ROM\\26\\32.DAT',
    [96] = 'ROM\\26\\33.DAT',
    [97] = 'ROM\\26\\34.DAT',
    [98] = 'ROM\\26\\35.DAT',
    [99] = 'ROM\\26\\36.DAT',
    [100] = 'ROM\\26\\37.DAT',
    [101] = 'ROM\\26\\38.DAT',
    [102] = 'ROM\\26\\39.DAT',
    [103] = 'ROM\\26\\40.DAT',
    [104] = 'ROM\\26\\41.DAT',
    [105] = 'ROM\\26\\42.DAT',
    [106] = 'ROM\\26\\43.DAT',
    [107] = 'ROM\\26\\44.DAT',
    [108] = 'ROM\\26\\45.DAT',
    [109] = 'ROM\\26\\46.DAT',
    [110] = 'ROM\\26\\47.DAT',
    [111] = 'ROM\\26\\48.DAT',
    [112] = 'ROM\\26\\49.DAT',
    [113] = 'ROM2\\13\\95.DAT',
    [114] = 'ROM2\\13\\96.DAT',
    [115] = 'ROM\\26\\52.DAT',
    [116] = 'ROM\\26\\53.DAT',
    [117] = 'ROM\\26\\54.DAT',
    [118] = 'ROM\\26\\55.DAT',
    [119] = 'ROM\\26\\56.DAT',
    [120] = 'ROM\\26\\57.DAT',
    [121] = 'ROM2\\13\\97.DAT',
    [122] = 'ROM2\\13\\98.DAT',
    [123] = 'ROM2\\13\\99.DAT',
    [124] = 'ROM2\\13\\100.DAT',
    [125] = 'ROM2\\13\\101.DAT',
    [126] = 'ROM\\26\\63.DAT',
    [127] = 'ROM\\26\\64.DAT',
    [128] = 'ROM2\\13\\102.DAT',
    [129] = 'ROM\\26\\66.DAT',
    [130] = 'ROM2\\13\\103.DAT',
    [131] = 'ROM\\26\\68.DAT',
    [132] = 'ROM\\26\\69.DAT',
    [134] = 'ROM2\\13\\104.DAT',
    [135] = 'ROM2\\13\\105.DAT',
    [136] = 'ROM\\26\\73.DAT',
    [137] = 'ROM\\26\\74.DAT',
    [138] = 'ROM\\26\\75.DAT',
    [139] = 'ROM\\26\\76.DAT',
    [140] = 'ROM\\26\\77.DAT',
    [141] = 'ROM\\26\\78.DAT',
    [142] = 'ROM\\26\\79.DAT',
    [143] = 'ROM\\26\\80.DAT',
    [144] = 'ROM\\26\\81.DAT',
    [145] = 'ROM\\26\\82.DAT',
    [146] = 'ROM\\26\\83.DAT',
    [147] = 'ROM\\26\\84.DAT',
    [148] = 'ROM\\26\\85.DAT',
    [149] = 'ROM\\26\\86.DAT',
    [150] = 'ROM\\26\\87.DAT',
    [151] = 'ROM\\26\\88.DAT',
    [152] = 'ROM\\26\\89.DAT',
    [153] = 'ROM2\\13\\106.DAT',
    [154] = 'ROM2\\13\\107.DAT',
    [155] = 'ROM\\26\\92.DAT',
    [156] = 'ROM\\26\\93.DAT',
    [157] = 'ROM\\26\\94.DAT',
    [158] = 'ROM\\26\\95.DAT',
    [159] = 'ROM2\\13\\108.DAT',
    [160] = 'ROM2\\13\\109.DAT',
    [161] = 'ROM\\26\\98.DAT',
    [162] = 'ROM\\26\\99.DAT',
    [163] = 'ROM2\\13\\110.DAT',
    [164] = 'ROM\\26\\101.DAT',
    [165] = 'ROM\\26\\102.DAT',
    [166] = 'ROM\\26\\103.DAT',
    [167] = 'ROM\\26\\104.DAT',
    [168] = 'ROM2\\13\\111.DAT',
    [169] = 'ROM\\26\\106.DAT',
    [170] = 'ROM2\\13\\112.DAT',
    [171] = 'ROM\\26\\108.DAT',
    [172] = 'ROM\\26\\109.DAT',
    [173] = 'ROM2\\13\\113.DAT',
    [174] = 'ROM2\\13\\114.DAT',
    [175] = 'ROM\\26\\112.DAT',
    [176] = 'ROM2\\13\\115.DAT',
    [177] = 'ROM2\\13\\116.DAT',
    [178] = 'ROM2\\13\\117.DAT',
    [179] = 'ROM2\\13\\118.DAT',
    [180] = 'ROM2\\13\\119.DAT',
    [181] = 'ROM2\\13\\120.DAT',
    [182] = 'ROM\\26\\119.DAT',
    [183] = 'ROM\\26\\120.DAT',
    [184] = 'ROM\\26\\121.DAT',
    [185] = 'ROM2\\13\\121.DAT',
    [186] = 'ROM2\\13\\122.DAT',
    [187] = 'ROM2\\13\\123.DAT',
    [188] = 'ROM2\\13\\124.DAT',
    [190] = 'ROM\\26\\127.DAT',
    [191] = 'ROM\\27\\0.DAT',
    [192] = 'ROM\\27\\1.DAT',
    [193] = 'ROM\\27\\2.DAT',
    [194] = 'ROM\\27\\3.DAT',
    [195] = 'ROM\\27\\4.DAT',
    [196] = 'ROM\\27\\5.DAT',
    [197] = 'ROM\\27\\6.DAT',
    [198] = 'ROM\\27\\7.DAT',
    [200] = 'ROM\\27\\9.DAT',
    [201] = 'ROM2\\13\\125.DAT',
    [202] = 'ROM2\\13\\126.DAT',
    [203] = 'ROM2\\13\\127.DAT',
    [204] = 'ROM\\27\\13.DAT',
    [205] = 'ROM2\\14\\0.DAT',
    [206] = 'ROM\\27\\15.DAT',
    [207] = 'ROM2\\14\\1.DAT',
    [208] = 'ROM2\\14\\2.DAT',
    [209] = 'ROM2\\14\\3.DAT',
    [210] = 'ROM\\27\\19.DAT',
    [211] = 'ROM2\\14\\4.DAT',
    [212] = 'ROM2\\14\\5.DAT',
    [213] = 'ROM2\\14\\6.DAT',
    [215] = 'ROM\\27\\24.DAT',
    [216] = 'ROM\\27\\25.DAT',
    [217] = 'ROM\\27\\26.DAT',
    [218] = 'ROM\\27\\27.DAT',
    [220] = 'ROM\\27\\29.DAT',
    [221] = 'ROM\\27\\30.DAT',
    [222] = 'ROM\\27\\31.DAT',
    [223] = 'ROM\\27\\32.DAT',
    [224] = 'ROM\\27\\33.DAT',
    [225] = 'ROM\\27\\34.DAT',
    [226] = 'ROM2\\14\\7.DAT',
    [227] = 'ROM\\27\\36.DAT',
    [228] = 'ROM\\27\\37.DAT',
    [230] = 'ROM\\27\\39.DAT',
    [231] = 'ROM\\27\\40.DAT',
    [232] = 'ROM\\27\\41.DAT',
    [233] = 'ROM\\27\\42.DAT',
    [234] = 'ROM\\27\\43.DAT',
    [235] = 'ROM\\27\\44.DAT',
    [236] = 'ROM\\27\\45.DAT',
    [237] = 'ROM\\27\\46.DAT',
    [238] = 'ROM\\27\\47.DAT',
    [239] = 'ROM\\27\\48.DAT',
    [240] = 'ROM\\27\\49.DAT',
    [241] = 'ROM\\27\\50.DAT',
    [242] = 'ROM\\27\\51.DAT',
    [243] = 'ROM\\27\\52.DAT',
    [244] = 'ROM\\27\\53.DAT',
    [245] = 'ROM\\27\\54.DAT',
    [246] = 'ROM\\27\\55.DAT',
    [247] = 'ROM2\\14\\8.DAT',
    [248] = 'ROM\\27\\57.DAT',
    [249] = 'ROM\\27\\58.DAT',
    [250] = 'ROM2\\14\\9.DAT',
    [251] = 'ROM2\\14\\10.DAT',
    [252] = 'ROM2\\14\\11.DAT',
    [253] = 'ROM\\27\\62.DAT',
    [254] = 'ROM\\27\\63.DAT',
    [255] = 'ROM\\27\\64.DAT',
    [256] = 'ROM9\\6\\45.DAT',
    [257] = 'ROM9\\6\\46.DAT',
    [258] = 'ROM9\\6\\47.DAT',
    [259] = 'ROM9\\6\\48.DAT',
    [260] = 'ROM9\\6\\49.DAT',
    [261] = 'ROM9\\6\\50.DAT',
    [262] = 'ROM9\\6\\51.DAT',
    [263] = 'ROM9\\6\\52.DAT',
    [264] = 'ROM9\\6\\53.DAT',
    [265] = 'ROM9\\6\\54.DAT',
    [266] = 'ROM9\\6\\55.DAT',
    [267] = 'ROM9\\6\\56.DAT',
    [268] = 'ROM9\\6\\57.DAT',
    [269] = 'ROM9\\6\\58.DAT',
    [270] = 'ROM9\\6\\59.DAT',
    [271] = 'ROM9\\6\\60.DAT',
    [272] = 'ROM9\\6\\61.DAT',
    [273] = 'ROM9\\6\\62.DAT',
    [274] = 'ROM9\\6\\63.DAT',
    [275] = 'ROM9\\6\\64.DAT',
    [276] = 'ROM9\\6\\65.DAT',
    [277] = 'ROM9\\6\\66.DAT',
    [278] = 'ROM9\\6\\67.DAT',
    [279] = 'ROM9\\6\\68.DAT',
    [280] = 'ROM\\303\\36.DAT',
    [281] = 'ROM\\315\\114.DAT',
    [282] = 'ROM\\315\\115.DAT',
    [284] = 'ROM\\303\\37.DAT',
    [285] = 'ROM\\306\\61.DAT',
    [287] = 'ROM\\362\\25.DAT',
    [288] = 'ROM\\332\\109.DAT',
    [289] = 'ROM\\337\\66.DAT',
    [290] = 'ROM\\342\\93.DAT',
    [291] = 'ROM\\342\\94.DAT',
    [292] = 'ROM\\353\\61.DAT',
    [293] = 'ROM\\342\\95.DAT',
    [294] = 'ROM\\354\\116.DAT',
    [295] = 'ROM\\355\\5.DAT',
    [296] = 'ROM\\355\\39.DAT',
    [297] = 'ROM\\355\\54.DAT',
    [298] = 'ROM\\361\\92.DAT'    
};
--This is used for jobs.  Every mob under the sun isn't actually a WAR just because it has DA.
--Most are almost certainly implemented with their job as RAPTOR, BEETLE, etc.
--Beastmen, humanoids, aerns, etc.. do have actual jobs and retain their stats and traits.
local humanoid_families = T{
    3, 25, 61, 68, 74, 77, 86, 92, 94, 98, 106, 115, 116, 125, 68, 138, 141, 151
};


local function LoadEntityDat(zone)
    local path = entityDatPaths[zone];
    if not path then return nil; end
    
    local filePath = string.format('%s\\%s', FFXIPATH, path);
    if not ashita.fs.exists(filePath) then return false; end;

    local dat = io.open(filePath, 'rb');
    if not dat then return nil; end

    local outputTable = {};
    local data = dat:read('*all');
    local offset = 1;
    while (offset < #data) do
        local entityName = struct.unpack('c28', data, offset);
        local entityId = struct.unpack('L', data, offset + 28);
        local entityIndex = bit.band(entityId, 0x7FF);

        local truncate = string.find(entityName, '\x00');
        if truncate then
            entityName = string.sub(entityName, 1, truncate - 1);
        end

        if (entityId > 0) and (entityIndex > 0) then
            outputTable[entityIndex] = { Name = entityName, Id = entityId, Index = entityIndex };
        end        

        offset = offset + 32;
    end

    return outputTable;
end

import.BuildDropTable = function(self)
    local startTime = os.clock();
    self.Drops = T{};
    local raw = io.open(string.format('%saddons/mobdb/inputs/mob_droplist.sql', AshitaCore:GetInstallPath()));
    local lines = raw:lines();
    for line in lines do
        local _,comment = string.find(line, '%-%-');
        if comment then
            line = string.sub(line, 0, comment-1);
        end
        if string.match(line, 'INSERT INTO') then
            local _,start = string.find(line, "%(");
            local _,finish = string.find(line, "%)");
            local sub = string.sub(line, start + 1, finish - 1);
            local split = {};
            for i in string.gmatch(sub, "([^,]+)") do
                split[#split + 1] = i;
            end
            self.Drops:append({
                DropPoolId=tonumber(split[1]),
                ItemId=tonumber(split[5])
            });
        end
    end
    raw:close();
    print(chat.header('MobDB') .. chat.message(string.format('Built drop table in %.2fs.  Total Entries:%u', os.clock() - startTime, #self.Drops)));
end

import.BuildSpellTable = function(self)
    local startTime = os.clock();
    self.Spells = T{};
    local raw = io.open(string.format('%saddons/mobdb/inputs/mob_spell_lists.sql', AshitaCore:GetInstallPath()));
    local lines = raw:lines();
    for line in lines do
        local _,comment = string.find(line, '%-%-');
        if comment then
            line = string.sub(line, 0, comment-1);
        end
        if string.match(line, 'INSERT INTO') then
            local _,start = string.find(line, "%(");
            local _,finish = string.find(line, "%)");
            local sub = string.sub(line, start + 1, finish - 1);
            local split = {};
            for i in string.gmatch(sub, "([^,]+)") do
                split[#split + 1] = i;
            end
            self.Spells:append({
                SpellGroupId=tonumber(split[2]),
                MinLevel=tonumber(split[4]),
                MaxLevel=tonumber(split[5]),
                Spell=tonumber(split[3])
            });
        end
    end
    raw:close();
    print(chat.header('MobDB') .. chat.message(string.format('Built spell table in %.2fs.  Total Entries:%u', os.clock() - startTime, #self.Spells)));
end


import.BuildGroupTables = function(self)
    local startTime = os.clock();
    self.Groups = T{};
    local raw = io.open(string.format('%saddons/mobdb/inputs/mob_groups.sql', AshitaCore:GetInstallPath()));
    local lines = raw:lines();
    local groupCount = 0;
    for line in lines do
        local _,comment = string.find(line, '%-%-');
        if comment then
            line = string.sub(line, 0, comment-1);
        end
        if string.match(line, 'INSERT INTO') then
            local _,start = string.find(line, "%(");
            local _,finish = string.find(line, "%)");
            local sub = string.sub(line, start + 1, finish - 1);
            local split = {};
            for i in string.gmatch(sub, "([^,]+)") do
                split[#split + 1] = i;
            end

            local group = {
                GroupId = tonumber(split[1]),
                PoolId = tonumber(split[2]),
                Zone = tonumber(split[3]),
                RespawnTime = tonumber(split[5]),
                DropPoolId = tonumber(split[7]),
                MinLevel = tonumber(split[10]),
                MaxLevel = tonumber(split[11])
            };
            
            if self.Groups[group.Zone] == nil then
                self.Groups[group.Zone] = T{};
            end

            self.Groups[group.Zone][group.GroupId] = group;
            groupCount = groupCount + 1;
        end
    end
    raw:close();
    print(chat.header('MobDB') .. chat.message(string.format('Built group tables in %.2fs.  Total Entries:%u', os.clock() - startTime, groupCount)));
end

import.BuildPoolTable = function(self)
    local startTime = os.clock();
    self.Pools = T{};
    local raw = io.open(string.format('%saddons/mobdb/inputs/mob_pools.sql', AshitaCore:GetInstallPath()));
    local lines = raw:lines();
    for line in lines do
        local _,comment = string.find(line, '%-%-');
        if comment then
            line = string.sub(line, 0, comment-1);
        end
        if string.match(line, 'INSERT INTO') then
            local _,start = string.find(line, "%(");
            local _,finish = string.find(line, "%)");
            local sub = string.sub(line, start + 1, finish - 1);
            local split = {};
            for i in string.gmatch(sub, "([^,]+)") do
                split[#split + 1] = i;
            end

            local pool = {
                PoolId = tonumber(split[1]),
                FamilyId = tonumber(split[4]),
                MainJob = tonumber(split[6]),
                Aggressive = (split[12] == '1'),
                TrueSight = (split[13] == '1'),
                Linking = (split[14] == '1'),
                MobType = tonumber(split[15]),
                SpellGroup = tonumber(split[22]),
                ResistGroup = tonumber(split[26])
            };
            
            self.Pools[pool.PoolId] = pool;
        end
    end
    raw:close();
    print(chat.header('MobDB') .. chat.message(string.format('Built pool table in %.2fs.  Total Entries:%u', os.clock() - startTime, #self.Pools)));
end

import.BuildFamilyTable = function(self)
    local startTime = os.clock();
    self.Families = T{};
    local raw = io.open(string.format('%saddons/mobdb/inputs/mob_family_system.sql', AshitaCore:GetInstallPath()));
    local lines = raw:lines();
    for line in lines do
        local _,comment = string.find(line, '%-%-');
        if comment then
            line = string.sub(line, 0, comment-1);
        end
        if string.match(line, 'INSERT INTO') then
            local _,start = string.find(line, "%(");
            local _,finish = string.find(line, "%)");
            local sub = string.sub(line, start + 1, finish - 1);
            local split = {};
            for i in string.gmatch(sub, "([^,]+)") do
                split[#split + 1] = i;
            end

            local family = {
                FamilyId = tonumber(split[1]),
                SuperFamilyId = tonumber(split[3]),
                Detection = tonumber(split[23])
            };
            self.Families[family.FamilyId] = family;
        end
    end
    raw:close();
    print(chat.header('MobDB') .. chat.message(string.format('Built family table in %.2fs.  Total Entries:%u', os.clock() - startTime, #self.Families)));
end

import.BuildResistanceTable = function(self)
    local startTime = os.clock();
    self.Resists = T{};
    local raw = io.open(string.format('%saddons/mobdb/inputs/mob_resistances.sql', AshitaCore:GetInstallPath()));
    local lines = raw:lines();
    for line in lines do
        local _,comment = string.find(line, '%-%-');
        if comment then
            line = string.sub(line, 0, comment-1);
        end
        if string.match(line, 'INSERT INTO') then
            local _,start = string.find(line, "%(");
            local _,finish = string.find(line, "%)");
            local sub = string.sub(line, start + 1, finish - 1);
            local split = {};
            for i in string.gmatch(sub, "([^,]+)") do
                split[#split + 1] = i;
            end

            local resist = {
                FamilyId = tonumber(split[1]),
                Slashing = tonumber(split[3]),
                Piercing = tonumber(split[4]),
                HandToHand = tonumber(split[5]),
                Impact = tonumber(split[6]),
                Fire = 1 + (tonumber(split[7]) * -0.0001),
                Ice = 1 + (tonumber(split[8]) * -0.0001),
                Wind = 1 + (tonumber(split[9]) * -0.0001),
                Earth = 1 + (tonumber(split[10]) * -0.0001),
                Lightning = 1 + (tonumber(split[11]) * -0.0001),
                Water = 1 + (tonumber(split[12]) * -0.0001),
                Light = 1 + (tonumber(split[13]) * -0.0001),
                Dark = 1 + (tonumber(split[14]) * -0.0001)
            };
            
            self.Resists[resist.FamilyId] = resist;
        end
    end
    raw:close();
    print(chat.header('MobDB') .. chat.message(string.format('Built resistance table in %.2fs.  Total Entries:%u', os.clock() - startTime, #self.Resists)));
end

import.BuildMonsterTables = function(self)
    local startTime = os.clock();
    self.Monsters = T{};
    local raw = io.open(string.format('%saddons/mobdb/inputs/mob_spawn_points.sql', AshitaCore:GetInstallPath()));
    local lines = raw:lines();
    local monsterCount = 0;
    for line in lines do
        local _,comment = string.find(line, '%-%-');
        if comment then
            line = string.sub(line, 0, comment-1);
        end
        if string.match(line, 'INSERT INTO') then
            local _,start = string.find(line, "%(");
            local _,finish = string.find(line, "%)");
            local sub = string.sub(line, start + 1, finish - 1);
            local split = {};
            for i in string.gmatch(sub, "([^,]+)") do
                split[#split + 1] = i;
            end

            local monster = {
                Id = tonumber(split[1]),
                Name = string.sub(split[3], 2, #split[3] - 1),
                Group = tonumber(split[4]),
            };
            monster.Index = bit.band(monster.Id, 0x3FF);
            monster.Zone = bit.band(bit.rshift(monster.Id, 12), 0x1FF);
            
            if (self.Monsters[monster.Zone] == nil) then
                self.Monsters[monster.Zone] = T{};
            end

            self.Monsters[monster.Zone][monster.Index] = monster;
            monsterCount = monsterCount + 1;
        end
    end
    raw:close();
    print(chat.header('MobDB') .. chat.message(string.format('Built monster tables in %.2fs.  Total Entries:%u', os.clock() - startTime, monsterCount)));
end

import.BuildTables = function(self)
    self:BuildDropTable();
    self:BuildSpellTable();
    self:BuildGroupTables();
    self:BuildPoolTable();
    self:BuildFamilyTable();
    self:BuildResistanceTable();
    self:BuildMonsterTables();
end

import.CheckFiles = function(self)
    for index = 1,300 do
        local path = string.format('%saddons/mobdb/test/%u.lua', AshitaCore:GetInstallPath(), index);
        if ashita.fs.exists(path) then
            local output = self:LoadTable(path);
            if type(output) == 'table' then
                print(chat.header('MobDB') .. chat.message('Successfully loaded zone: ') .. chat.color1(2, AshitaCore:GetResourceManager():GetString('zones.names', index)));
            end
        end
    end
end

import.GenerateData = function(self)
    local timeStart = os.clock();
    local zoneCount = 0;
    local totalSuccess = 0;
    local totalGroup = 0;
    local totalPool = 0;
    local totalFamily = 0;
    local errors = io.open(string.format('%saddons/mobdb/output/errors.txt', AshitaCore:GetInstallPath()), 'w');
    for zoneId,mobs in pairs(self.Monsters) do
        local groups = self.Groups[zoneId];        
        local outFile = io.open(string.format('%saddons/mobdb/output/%u.lua', AshitaCore:GetInstallPath(), zoneId), 'w');
        local zoneDat = LoadEntityDat(zoneId);
        local groupFailCount = 0;
        local poolFailCount = 0;
        local familyFailCount = 0;
        local successCount = 0;

        outFile:write(string.format('--Zone: %s\n', AshitaCore:GetResourceManager():GetString('zones.names', zoneId)));
        outFile:write(string.format('--Zone ID: %u\n', zoneId));
        outFile:write('return {\n');
        for mobIndex = 1,0x3FF do
            local data = mobs[mobIndex];
            if (data ~= nil) then
                if (type(zoneDat) == 'table') and (zoneDat[mobIndex] ~= nil) then
                    local datName = zoneDat[mobIndex].Name;
                    if (string.lower(string.gsub(data.Name, '%W', '')) ~= string.lower(string.gsub(datName, '%W', ''))) then
                        errors:write(string.format('[LSB MISMATCH] Zone:%s Index:%u Id:%u Name:%s LSB Name:%s\n', AshitaCore:GetResourceManager():GetString('zones.names', zoneId), mobIndex, data.Id, zoneDat[mobIndex].Name, data.Name));                        
                    else
                        data.Name = datName;
                        local groupId = data.Group;
                        local group = groups[groupId];
                        if not group then
                            groupFailCount = groupFailCount + 1;
                        else
                            local poolId = group.PoolId;
                            local pool = self.Pools[poolId];
                            if not pool then
                                poolFailCount = poolFailCount + 1;
                            else
                                local familyId = pool.FamilyId;
                                local family = self.Families[familyId];
                                local resists = self.Resists[familyId];
                                if (not family) or (not resists) then
                                    familyFailCount = familyFailCount + 1;
                                else
                                    if pool.MobType == 2 then
                                        data.NM = true;
                                    end
                                    local detectFlags = family.Detection;
                                    local isNotorious = data.NM and 'true' or 'false';
                                    local isAggro = pool.Aggressive and 'true' or 'false';
                                    local isTrueSight = pool.TrueSight and 'true' or 'false';
                                    local isLinking = pool.Linking and 'true' or 'false';
                                    local detection = T{};
                                    local isSight = (bit.band(detectFlags, 0x01) ~= 0) and 'true' or 'false';
                                    local isSound = (bit.band(detectFlags, 0x02) ~= 0) and 'true' or 'false';
                                    local isBlood = (bit.band(detectFlags, 0x04) ~= 0) and 'true' or 'false';
                                    local isMagic = (bit.band(detectFlags, 0x20) ~= 0) and 'true' or 'false';
                                    local isJA = (bit.band(detectFlags, 0xC0) ~= 0) and 'true' or 'false';
                                    local isScent = (bit.band(detectFlags, 0x100) ~= 0) and 'true' or 'false';
                                    local minLevel = group.MinLevel;
                                    local maxLevel = group.MaxLevel;
                                    
                                    local job = 0;
                                    if humanoid_families:contains(family.SuperFamilyId) then
                                        job = pool.MainJob;
                                    end

                                    local spellPool = pool.SpellGroup;
                                    local spells = T{};
                                    if (spellPool ~= 0) then
                                        for _,spell in pairs(self.Spells) do
                                            if (spell.SpellGroupId == spellPool) then
                                                if (minLevel <= spell.MaxLevel) and (maxLevel >= spell.MinLevel) then
                                                    spells:append(spell.Spell);
                                                end
                                            end
                                        end
                                    end

                                    local dropPool = group.DropPoolId;
                                    local drops = T{};
                                    if (dropPool ~= 0) then
                                        for _,drop in pairs(self.Drops) do
                                            if (drop.DropPoolId == dropPool) and (not drops:contains(drop.ItemId)) then
                                                drops:append(drop.ItemId);
                                            end
                                        end
                                    end

                                    outFile:write(string.format('    [%d] = { Name=\'%s\', Notorious=%s, Aggro=%s, Link=%s, TrueSight=%s, Job=%d, Detection={ Sight=%s, Sound=%s, Blood=%s, Magic=%s, JA=%s, Scent=%s }, Drops={',
                                    mobIndex, string.gsub(data.Name, '\'', '\\\''), isNotorious, isAggro, isLinking, isTrueSight, job, isSight, isSound, isBlood, isMagic,  isJA, isScent));
                                    local first = true;
                                    for _,itemId in ipairs(drops) do
                                        if not first then outFile:write(','); end
                                        outFile:write(itemId);
                                        first = false;
                                    end

                                    outFile:write('}, Spells={');
                                    first = true;
                                    for _,spellId in ipairs(spells) do
                                        if not first then outFile:write(','); end
                                        outFile:write(spellId);
                                        first = false;
                                    end

                                    outFile:write('}, Modifiers={');                                    
                                    local modifiers = { 'Slashing', 'Piercing', 'HandToHand', 'Impact', 'Fire', 'Ice', 'Wind', 'Earth', 'Lightning', 'Water', 'Light', 'Dark' };
                                    local first = true;
                                    for _,mod in ipairs(modifiers) do
                                        if not first then
                                            outFile:write(', ');
                                        end
                                        local text = string.gsub(string.format('%s=%f', mod, resists[mod]), "0+$", ""):gsub('%.$', '');
                                        outFile:write(text);
                                        first = false;
                                    end
                                    outFile:write('} },\n');
                                    successCount = successCount + 1;
                                end
                            end
                        end
                    end
                end
            end
        end
        outFile:write('};');
        outFile:close();
        
        errors:write('Zone:' .. AshitaCore:GetResourceManager():GetString('zones.names', zoneId));
        errors:write(' Resolved Mobs:' .. successCount);
        errors:write(' Group Fail:' .. groupFailCount);
        errors:write(' Pool Fail:' .. poolFailCount);
        errors:write(' Family Fail:' .. familyFailCount);
        errors:write('\n');
        zoneCount = zoneCount + 1;
        totalSuccess = totalSuccess + successCount;
        totalGroup = totalGroup + groupFailCount;
        totalPool = totalPool + poolFailCount;
        totalFamily = totalFamily + familyFailCount;
    end
    errors:write('Total Zones:' .. zoneCount);
    errors:write(' Resolved Mobs:' .. totalSuccess);
    errors:write(' Group Fail:' .. totalGroup);
    errors:write(' Pool Fail:' .. totalPool);
    errors:write(' Family Fail:' .. totalFamily);
    errors:write('\n');
    errors:close();
    print(chat.header('MobDB') .. chat.message('Total Mobs:') .. chat.color1(2, totalSuccess) .. chat.message(' Total Time:') .. chat.color1(2, string.format('%.2fs', os.clock() - timeStart)));
end

return import;