local memMgr = AshitaCore:GetMemoryManager();
local entMgr = memMgr:GetEntity();
local partyMgr = memMgr:GetParty();
local playMgr = memMgr:GetPlayer();
local resMgr = AshitaCore:GetResourceManager();

local function PrintMods(mods)
    for index,mod in ipairs(mods) do
        if (gTextures.Cache[mod.Type] ~= nil) then
            imgui.Image(tonumber(ffi.cast("uint32_t", gTextures.Cache[mod.Type])), {13 * gSettings.Scale, 13 * gSettings.Scale });
            imgui.SameLine();
        end

        if (index == #mods) or (mods[index+1].Potency ~= mod.Potency) then
            local outstring = '';
            if (mod.Potency > 1) then
                outstring = outstring .. '+' .. string.format('%.2f', ((mod.Potency - 1) * 100)):gsub('0+$', ''):gsub('%.$', '') .. '%%';
            else
                outstring = outstring .. '-' .. string.format('%.2f', ((1 - mod.Potency) * 100)):gsub('0+$', ''):gsub('%.$', '') .. '%%';
            end

            local lastLine = (index == #mods);
            if not lastLine then
                outstring = outstring .. ' ';
            end
            imgui.Text(outstring);
            if not lastLine then
                imgui.SameLine();
            end
        end
    end
end

local function PrintFlags(resource)
    if (resource.Notorious) then
        if (resource.Aggro) then
            imgui.Image(tonumber(ffi.cast("uint32_t", gTextures.Cache['AggroHQ'])), {13 * gSettings.Scale, 13 * gSettings.Scale });
        else
            imgui.Image(tonumber(ffi.cast("uint32_t", gTextures.Cache['PassiveHQ'])), {13 * gSettings.Scale, 13 * gSettings.Scale });
        end
    else
        if (resource.Aggro) then
            imgui.Image(tonumber(ffi.cast("uint32_t", gTextures.Cache['AggroNQ'])), {13 * gSettings.Scale, 13 * gSettings.Scale });
        else
            imgui.Image(tonumber(ffi.cast("uint32_t", gTextures.Cache['PassiveNQ'])), {13 * gSettings.Scale, 13 * gSettings.Scale });
        end
    end

    local flags = {
        'Link',
        'TrueSight',
        'Sight',
        'Sound',
        'Scent',
        'Magic',
        'JA',
        'Blood',
    };

    for _,flag in ipairs(flags) do
        if (resource[flag] == true) and (gTextures.Cache[flag] ~= nil) then
            imgui.SameLine();
            imgui.Image(tonumber(ffi.cast("uint32_t", gTextures.Cache[flag])), {13 * gSettings.Scale, 13 * gSettings.Scale });            
        end
    end
end
local function PrintDebugFlags()
    local flags = {
        'AggroHQ',
        'PassiveHQ',
        'AggroNQ',
        'PassiveNQ',
        'Link',
        'TrueSight',
        'Sight',
        'Sound',
        'Scent',
        'Magic',
        'JA',
        'Blood',        
    };
    local first = true;
    for index,flag in ipairs(flags) do
        if (gTextures.Cache[flag] ~= nil) then
            if not first then
                imgui.SameLine();
            end
            imgui.Image(tonumber(ffi.cast("uint32_t", gTextures.Cache[flag])), {13 * gSettings.Scale, 13 * gSettings.Scale });
            first = false;
        end
    end
    flags = {
        'H2H',
        'Impact',
        'Piercing',
        'Slashing',
        'Fire',
        'Earth',
        'Water',
        'Wind',
        'Ice',
        'Lightning',
        'Light',
        'Dark'
    };
    first = true;
    for index,flag in ipairs(flags) do
        if (gTextures.Cache[flag] ~= nil) then
            if not first then
                imgui.SameLine();
            end
            imgui.Image(tonumber(ffi.cast("uint32_t", gTextures.Cache[flag])), {13 * gSettings.Scale, 13 * gSettings.Scale });
            first = false;
        end
    end
end

return {
    ['$name'] = function(mob)
        local resource = gData.Mobs[mob];
        if resource and resource.Name then
            imgui.Text(resource.Name);
        else
            imgui.Text(entMgr:GetName(mob));
        end
        return true;
    end,
    ['$index'] = function(mob)
        imgui.Text(tostring(mob));
        return true;
    end,
    ['$id'] = function(mob)
        imgui.Text(tostring(entMgr:GetServerId(mob)));
        return true;
    end,
    ['$zone'] = function(mob)
        local zoneId = partyMgr:GetMemberZone(0);
        local string = resMgr:GetString(gCompatibility.Resource.Zone, zoneId);
        if string then
            imgui.Text(string);
        else
            imgui.Text('Unknown');
        end
        return true;
    end,
    ['$job'] = function(mob)        
        local resource = gData.Mobs[mob];
        if resource and resource.Job > 0 then
            local output = resMgr:GetString(gCompatibility.Resource.Jobs, resource.Job);
            if (resource.SubJob ~= nil) and (resource.SubJob > 0) then
                output = output .. '/' .. resMgr:GetString(gCompatibility.Resource.Jobs, resource.SubJob);                    
            end
            imgui.Text(output);
        elseif mob <= 0x3FF then
            imgui.Text('???');
        else
            if (mob == AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0)) then
                local mainJob = playMgr:GetMainJob();
                local subJob = playMgr:GetSubJob();
                imgui.Text(string.format('%s/%s', resMgr:GetString(gCompatibility.Resource.Jobs, mainJob), resMgr:GetString(gCompatibility.Resource.Jobs, subJob)));
            else
                for i = 1,17 do
                    if partyMgr:GetMemberZone(i) == partyMgr:GetMemberZone(0) then
                        if partyMgr:GetMemberTargetIndex(i) == mob then
                            local mainJob = partyMgr:GetMemberMainJob(i);
                            local subJob = partyMgr:GetMemberSubJob(i);
                            if ((mainJob ~= 0) or (subJob ~= 0)) then
                                imgui.Text(string.format('%s/%s', resMgr:GetString(gCompatibility.Resource.Jobs, mainJob), resMgr:GetString(gCompatibility.Resource.Jobs, subJob)));
                            end
                            break;
                        end
                    end
                end
                imgui.Text('???');
            end
        end
        return true;
    end,
    ['$level'] = function(mob)
        local resource = gData.Mobs[mob];
        if resource then
            if resource.Level then
                imgui.Text(tostring(resource.Level));
            else
                imgui.Text(string.format('%d-%d', resource.MinLevel, resource.MaxLevel));
            end
        elseif mob <= 0x3FF then
            imgui.Text('???');
        else
            if (mob == AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0)) then
                imgui.Text(tostring(playMgr:GetMainJobLevel()));
            else
                for i = 1,17 do
                    if partyMgr:GetMemberZone(i) == partyMgr:GetMemberZone(0) then
                        if partyMgr:GetMemberTargetIndex(i) == mob then
                            local level = partyMgr:GetMemberMainJobLevel(i);
                            if (level > 0) then
                                imgui.Text(tostring(level));
                                return;
                            end
                        end
                    end
                end
                imgui.Text('???');
            end
        end
        return true;
    end,
    ['$joblevel'] = function(mob)
        local resource = gData.Mobs[mob];
        if resource then
            local output = string.format('[Lv%d-%d', resource.MinLevel, resource.MaxLevel);
            if (resource.Job > 0) then
                output = output .. ' ' .. resMgr:GetString(gCompatibility.Resource.Jobs, resource.Job);
                if (resource.SubJob ~= nil) and (resource.SubJob > 0) then
                    output = output .. '/' .. resMgr:GetString(gCompatibility.Resource.Jobs, resource.SubJob);                    
                end
            end
            output = output .. ']';
            imgui.Text(output);
            return true;
        elseif mob <= 0x3FF then
            return false;
        else
            if (mob == AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0)) then
                local output = string.format('[%s%u/%s%u]',
                    resMgr:GetString(gCompatibility.Resource.Jobs, playMgr:GetMainJob()),
                    playMgr:GetMainJobLevel(),
                    resMgr:GetString(gCompatibility.Resource.Jobs, playMgr:GetSubJob()),
                    playMgr:GetSubJobLevel());
                imgui.Text(output);
                return true;
            else
                for i = 1,17 do
                    if partyMgr:GetMemberZone(i) == partyMgr:GetMemberZone(0) then
                        if partyMgr:GetMemberTargetIndex(i) == mob then
                            local level = partyMgr:GetMemberMainJobLevel(i);
                            if (level > 0) then
                                local output = string.format('[%s%u/%s%u]',
                                    resMgr:GetString(gCompatibility.Resource.Jobs, partyMgr:GetMemberMainJob(i)),
                                    partyMgr:GetMemberMainJobLevel(i),
                                    resMgr:GetString(gCompatibility.Resource.Jobs, partyMgr:GetMemberSubJob(i)),
                                    partyMgr:GetMemberSubJobLevel(i));
                                imgui.Text(output);
                                return true;
                            end
                        end
                    end
                end
            end
        end
        return false;
    end,
    ['$position1'] = function(mob)
        imgui.Text(string.format('(%.2f,%.2f) Z:%.2f',
            entMgr:GetLocalPositionX(mob),
            entMgr:GetLocalPositionY(mob),
            entMgr:GetLocalPositionZ(mob)));
        return true;
    end,
    ['$position2'] = function(mob)
        imgui.Text(string.format('(%.0f,%.0f) Z:%.0f',
            entMgr:GetLocalPositionX(mob),
            entMgr:GetLocalPositionY(mob),
            entMgr:GetLocalPositionZ(mob)));
        return true;
    end,
    ['$position3'] = function(mob)
        imgui.Text(string.format('X:%.2f Y:%.2f Z:%.2f',
            entMgr:GetLocalPositionX(mob),
            entMgr:GetLocalPositionY(mob),
            entMgr:GetLocalPositionZ(mob)));
        return true;
    end,
    ['$position4'] = function(mob)
        imgui.Text(string.format('X:%.0f Y:%.0f Z:%.0f',
            entMgr:GetLocalPositionX(mob),
            entMgr:GetLocalPositionY(mob),
            entMgr:GetLocalPositionZ(mob)));
        return true;
    end,
    ['$strength'] = function(mob)
        local resource = gData.Mobs[mob];
        if resource then
            local mods = T{};
            for name,potency in pairs(resource.Modifiers) do
                if (potency < 1.0) then
                    mods:append({ Type=name, Potency=potency });
                end
                table.sort(mods, function(a,b)
                    return (a.Potency < b.Potency);
                end);
            end
            if (#mods > 0) then
                PrintMods(mods);
                return true;
            else
                return false;
            end
        end
        return false;
    end,
    ['$weakness'] = function(mob)
        local resource = gData.Mobs[mob];
        if resource then
            local mods = T{};
            for name,potency in pairs(resource.Modifiers) do
                if (potency > 1.0) then
                    mods:append({ Type=name, Potency=potency });
                end
                table.sort(mods, function(a,b)
                    return (a.Potency > b.Potency);
                end);
            end
            if (#mods > 0) then
                PrintMods(mods);
                return true;
            else
                return false;
            end
        end
        return false;
    end,
    ['$physical'] = function(mob)
        local resource = gData.Mobs[mob];
        if resource then
            local mods = T{};
            for name,potency in pairs(resource.Modifiers) do
                if (potency ~= 1.0) and T{'H2H', 'Impact', 'Piercing', 'Slashing'}:contains(name) then
                    mods:append({ Type=name, Potency=potency });
                end
                table.sort(mods, function(a,b)
                    return (a.Potency > b.Potency);
                end);
            end
            if (#mods > 0) then
                PrintMods(mods);
                return true;
            else
                return false;
            end
        end
        return false;
    end,
    ['$magical'] = function(mob)
        local resource = gData.Mobs[mob];
        if resource then
            local mods = T{};
            for name,potency in pairs(resource.Modifiers) do
                if (potency ~= 1.0) and (not T{'H2H', 'Impact', 'Piercing', 'Slashing'}:contains(name)) then
                    mods:append({ Type=name, Potency=potency });
                end
                table.sort(mods, function(a,b)
                    return (a.Potency > b.Potency);
                end);
            end
            if (#mods > 0) then
                PrintMods(mods);
                return true;
            else
                return false;
            end
        end
        return false;
    end,
    ['$physmagic'] = function(mob)
        local resource = gData.Mobs[mob];
        local retvalue =  false;
        if resource then
            local mods = T{};
            for name,potency in pairs(resource.Modifiers) do
                if (potency ~= 1.0) and T{'H2H', 'Impact', 'Piercing', 'Slashing'}:contains(name) then
                    mods:append({ Type=name, Potency=potency });
                end
                table.sort(mods, function(a,b)
                    return (a.Potency > b.Potency);
                end);
            end
            
            if (#mods > 0) then
                PrintMods(mods);
                retvalue = true;
            end

            mods = T{};
            for name,potency in pairs(resource.Modifiers) do
                if (potency ~= 1.0) and (not T{'H2H', 'Impact', 'Piercing', 'Slashing'}:contains(name)) then
                    mods:append({ Type=name, Potency=potency });
                end
                table.sort(mods, function(a,b)
                    return (a.Potency > b.Potency);
                end);
            end
            if (#mods > 0) then
                if (retvalue) then
                    imgui.SameLine();
                    imgui.Text(' ');
                    imgui.SameLine();
                end
                PrintMods(mods);
                return true;
            else
                return retvalue;
            end
        end
        return false;
    end,
    ['$hpp'] = function(mob)
        imgui.Text(tostring(entMgr:GetHPPercent(mob)));
        return true;
    end,
    ['$aggro'] = function(mob)
        local resource = gData.Mobs[mob];
        if resource then
            PrintFlags(resource);
            return true;
        else
            return false;
        end
    end,
    ['$debugflags'] = function(mob)
        PrintDebugFlags();
        return true;
    end,
    ['$spawncount'] = function(mob)
        
    end,
    ['$speed'] = function(mob)

    end,
    ['$notes'] = function(mob)
        local resource = gData.Mobs[mob];
        if resource then
            if (resource.Notes) and (#resource.Notes > 0) then
                for _,note in ipairs(resource.Notes) do
                    imgui.Text(note);
                end
                return true;
            end
        end
        return false;
    end
};