local memMgr = AshitaCore:GetMemoryManager();
local entMgr = memMgr:GetEntity();
local partyMgr = memMgr:GetParty();
local playMgr = memMgr:GetPlayer();
local resMgr = AshitaCore:GetResourceManager();

gTokenState = {
    FirstElement = true,
    LineBreak = false,
    DrawImage = function(this, fileName)
        this:ProcessSameLines();
        imgui.Image(tonumber(ffi.cast("uint32_t", gTextures.Cache[fileName])),
            { 13 * gSettings.Scale, 13 * gSettings.Scale }, { 0, 0 }, { 1, 1 }, { 1, 1, 1, 1 }, { 0, 0, 0, 0 });
        if imgui.IsItemHovered() then
            imgui.SetTooltip(fileName);
        end
    end,
    DrawText = function(this, text)
        if (text ~= nil) then
            this:ProcessSameLines();
            imgui.Text(text);
        end
    end,
    ProcessSameLines = function(this)
        if this.FirstElement then
            if this.LineBreak then
                imgui.Text('');
                this.LineBreak = false;
            end
            this.FirstElement = false;
        else
            if not this.LineBreak then
                imgui.SameLine();
            else
                this.LineBreak = false;
            end
        end
    end
}

local function PrintAllImmunities()
    local flags = {
        { flag = 0x01, icon = 'ImmuneSleep' },
        { flag = 0x02, icon = 'ImmuneGravity' },
        { flag = 0x04, icon = 'ImmuneBind' },
        { flag = 0x08, icon = 'ImmuneStun' },
        { flag = 0x10, icon = 'ImmuneSilence' },
        { flag = 0x20, icon = 'ImmuneParalyze' },
        { flag = 0x40, icon = 'ImmuneBlind' },
        { flag = 0x80, icon = 'ImmuneSlow' },
        { flag = 0x100, icon = 'ImmunePoison' },
        { flag = 0x200, icon = 'ImmuneElegy' },
        { flag = 0x400, icon = 'ImmuneRequiem' },
        { flag = 0x800, icon = 'ImmuneLightSleep' },
        { flag = 0x1000, icon = 'ImmuneDarkSleep' },
        { flag = 0x2000, icon = 'ImmunePetrify' },
    }

    for _, flag in ipairs(flags) do
        if (gTextures.Cache[flag.icon] ~= nil) then
            gTokenState:DrawImage(flag.icon);
        end
    end
end

local function PrintImmunities(resource)
    local flags = {
        { flag = 0x01, icon = 'ImmuneSleep' },
        { flag = 0x02, icon = 'ImmuneGravity' },
        { flag = 0x04, icon = 'ImmuneBind' },
        { flag = 0x08, icon = 'ImmuneStun' },
        { flag = 0x10, icon = 'ImmuneSilence' },
        { flag = 0x20, icon = 'ImmuneParalyze' },
        { flag = 0x40, icon = 'ImmuneBlind' },
        { flag = 0x80, icon = 'ImmuneSlow' },
        { flag = 0x100, icon = 'ImmunePoison' },
        { flag = 0x200, icon = 'ImmuneElegy' },
        { flag = 0x400, icon = 'ImmuneRequiem' },
        { flag = 0x800, icon = 'ImmuneLightSleep' },
        { flag = 0x1000, icon = 'ImmuneDarkSleep' },
        { flag = 0x2000, icon = 'ImmunePetrify' },
    }

    for _, flag in ipairs(flags) do
        if (bit.band(resource.Immunities, flag.flag) ~= 0) then
            if (gTextures.Cache[flag.icon] ~= nil) then
                gTokenState:DrawImage(flag.icon);
            end
        end
    end
end

local function PrintMods(mods)
    for index, mod in ipairs(mods) do
        if (gTextures.Cache[mod.Type] ~= nil) then
            gTokenState:DrawImage(mod.Type);
        end

        if (index == #mods) or (mods[index + 1].Potency ~= mod.Potency) then
            local outstring = '';
            if (mod.Potency > 1) then
                outstring = outstring ..
                '+' .. string.format('%.2f', ((mod.Potency - 1) * 100)):gsub('0+$', ''):gsub('%.$', '') .. '%';
                if (ashita.addons_version < 2.2) then
                    outstring = outstring .. '%';
                end
            else
                outstring = outstring ..
                '-' .. string.format('%.2f', ((1 - mod.Potency) * 100)):gsub('0+$', ''):gsub('%.$', '') .. '%';
                if (ashita.addons_version < 2.2) then
                    outstring = outstring .. '%';
                end
            end

            local lastLine = (index == #mods);
            if not lastLine then
                outstring = outstring .. ' ';
            end
            gTokenState:DrawText(outstring);
        end
    end
end

local function PrintFlags(resource)
    if (resource.Notorious) then
        if (resource.Aggro) then
            gTokenState:DrawImage('AggroHQ');
        else
            gTokenState:DrawImage('PassiveHQ');
        end
    else
        if (resource.Aggro) then
            gTokenState:DrawImage('AggroNQ');
        else
            gTokenState:DrawImage('PassiveNQ');
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

    for _, flag in ipairs(flags) do
        if (resource[flag] == true) and (gTextures.Cache[flag] ~= nil) then
            gTokenState:DrawImage(flag);
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
    for index, flag in ipairs(flags) do
        if (gTextures.Cache[flag] ~= nil) then
            gTokenState:DrawImage(flag);
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
    for index, flag in ipairs(flags) do
        if (gTextures.Cache[flag] ~= nil) then
            gTokenState:DrawImage(flag);
        end
    end
end

return {
    ['$name'] = function(mob, resource)
        if resource and resource.Name then
            gTokenState:DrawText(resource.Name);
        else
            local name = entMgr:GetName(mob);
            if (name ~= nil) then
                gTokenState:DrawText(name);
            end
        end
    end,
    ['$hexindex'] = function(mob)
        gTokenState:DrawText(string.format('0x%X', mob));
    end,
    ['$hexid'] = function(mob)
        gTokenState:DrawText(string.format('0x%X', entMgr:GetServerId(mob)));
    end,
    ['$index'] = function(mob)
        gTokenState:DrawText(tostring(mob));
    end,
    ['$id'] = function(mob)
        gTokenState:DrawText(tostring(entMgr:GetServerId(mob)));
    end,
    ['$zone'] = function(mob)
        local zoneId = partyMgr:GetMemberZone(0);
        local string = resMgr:GetString(gCompatibility.Resource.Zone, zoneId);
        if string then
            gTokenState:DrawText(string);
        else
            gTokenState:DrawText('Unknown');
        end
    end,
    ['$job'] = function(mob, resource)
        if resource and resource.Job > 0 then
            local output = resMgr:GetString(gCompatibility.Resource.Jobs, resource.Job);
            if (resource.SubJob ~= nil) and (resource.SubJob > 0) then
                output = output .. '/' .. resMgr:GetString(gCompatibility.Resource.Jobs, resource.SubJob);
            end
            gTokenState:DrawText(output);
        elseif (mob > 0x3FF) and (mob < 0x700) then
            if (mob == AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0)) then
                local mainJob = playMgr:GetMainJob();
                local subJob = playMgr:GetSubJob();
                gTokenState:DrawText(string.format('%s/%s', resMgr:GetString(gCompatibility.Resource.Jobs, mainJob),
                    resMgr:GetString(gCompatibility.Resource.Jobs, subJob)));
            else
                for i = 1, 17 do
                    if partyMgr:GetMemberZone(i) == partyMgr:GetMemberZone(0) then
                        if partyMgr:GetMemberTargetIndex(i) == mob then
                            local mainJob = partyMgr:GetMemberMainJob(i);
                            local subJob = partyMgr:GetMemberSubJob(i);
                            if ((mainJob ~= 0) or (subJob ~= 0)) then
                                gTokenState:DrawText(string.format('%s/%s',
                                    resMgr:GetString(gCompatibility.Resource.Jobs, mainJob),
                                    resMgr:GetString(gCompatibility.Resource.Jobs, subJob)));
                            end
                            break;
                        end
                    end
                end
                gTokenState:DrawText('???');
            end
        else
            gTokenState:DrawText('???');
        end
    end,
    ['$level'] = function(mob, resource)
        if resource then
            if resource.Level then
                gTokenState:DrawText(tostring(resource.Level));
            else
                gTokenState:DrawText(string.format('%d-%d', resource.MinLevel, resource.MaxLevel));
            end
        elseif (mob > 0x3FF) and (mob < 0x700) then
            if (mob == AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0)) then
                gTokenState:DrawText(tostring(playMgr:GetMainJobLevel()));
            else
                for i = 1, 17 do
                    if partyMgr:GetMemberZone(i) == partyMgr:GetMemberZone(0) then
                        if partyMgr:GetMemberTargetIndex(i) == mob then
                            local level = partyMgr:GetMemberMainJobLevel(i);
                            if (level > 0) then
                                gTokenState:DrawText(tostring(level));
                                return;
                            end
                        end
                    end
                end
                gTokenState:DrawText('???');
            end
        else
            gTokenState:DrawText('???');
        end
    end,
    ['$joblevel'] = function(mob, resource)
        if resource then
            local output = string.format('[Lv%d-%d', resource.MinLevel, resource.MaxLevel);
            if (resource.Job > 0) then
                output = output .. ' ' .. resMgr:GetString(gCompatibility.Resource.Jobs, resource.Job);
                if (resource.SubJob ~= nil) and (resource.SubJob > 0) then
                    output = output .. '/' .. resMgr:GetString(gCompatibility.Resource.Jobs, resource.SubJob);
                end
            end
            output = output .. ']';
            gTokenState:DrawText(output);
        elseif (mob > 0x3FF) and (mob < 0x700) then
            if (mob == AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0)) then
                local output = string.format('[%s%u/%s%u]',
                    resMgr:GetString(gCompatibility.Resource.Jobs, playMgr:GetMainJob()),
                    playMgr:GetMainJobLevel(),
                    resMgr:GetString(gCompatibility.Resource.Jobs, playMgr:GetSubJob()),
                    playMgr:GetSubJobLevel());
                gTokenState:DrawText(output);
            else
                for i = 1, 17 do
                    if partyMgr:GetMemberZone(i) == partyMgr:GetMemberZone(0) then
                        if partyMgr:GetMemberTargetIndex(i) == mob then
                            local level = partyMgr:GetMemberMainJobLevel(i);
                            if (level > 0) then
                                local output = string.format('[%s%u/%s%u]',
                                    resMgr:GetString(gCompatibility.Resource.Jobs, partyMgr:GetMemberMainJob(i)),
                                    partyMgr:GetMemberMainJobLevel(i),
                                    resMgr:GetString(gCompatibility.Resource.Jobs, partyMgr:GetMemberSubJob(i)),
                                    partyMgr:GetMemberSubJobLevel(i));
                                gTokenState:DrawText(output);
                            end
                        end
                    end
                end
            end
        end
        return false;
    end,
    ['$position1'] = function(mob)
        gTokenState:DrawText(string.format('(%.2f,%.2f) Z:%.2f',
            entMgr:GetLocalPositionX(mob),
            entMgr:GetLocalPositionY(mob),
            entMgr:GetLocalPositionZ(mob)));
    end,
    ['$position2'] = function(mob)
        gTokenState:DrawText(string.format('(%.0f,%.0f) Z:%.0f',
            entMgr:GetLocalPositionX(mob),
            entMgr:GetLocalPositionY(mob),
            entMgr:GetLocalPositionZ(mob)));
    end,
    ['$position3'] = function(mob)
        gTokenState:DrawText(string.format('X:%.2f Y:%.2f Z:%.2f',
            entMgr:GetLocalPositionX(mob),
            entMgr:GetLocalPositionY(mob),
            entMgr:GetLocalPositionZ(mob)));
    end,
    ['$position4'] = function(mob)
        gTokenState:DrawText(string.format('X:%.0f Y:%.0f Z:%.0f',
            entMgr:GetLocalPositionX(mob),
            entMgr:GetLocalPositionY(mob),
            entMgr:GetLocalPositionZ(mob)));
    end,
    ['$strength'] = function(mob, resource)
        if resource then
            local mods = T {};
            for name, potency in pairs(resource.Modifiers) do
                if not T { 'Amnesia', 'Virus', 'Silence', 'Gravity', 'Stun', 'LightSleep', 'Charm', 'Paralyze', 'Bind', 'Slow', 'Petrify', 'Terror', 'Poison', 'DarkSleep', 'Blind' }:contains(name) then
                    if (potency < 1.0) then
                        mods:append({ Type = name, Potency = potency });
                    end
                    table.sort(mods, function(a, b)
                        return (a.Potency < b.Potency);
                    end);
                end
            end
            if (#mods > 0) then
                PrintMods(mods);
            end
        end
    end,
    ['$weakness'] = function(mob, resource)
        if resource then
            local mods = T {};
            for name, potency in pairs(resource.Modifiers) do
                if not T { 'Amnesia', 'Virus', 'Silence', 'Gravity', 'Stun', 'LightSleep', 'Charm', 'Paralyze', 'Bind', 'Slow', 'Petrify', 'Terror', 'Poison', 'DarkSleep', 'Blind' }:contains(name) then
                    if (potency > 1.0) then
                        mods:append({ Type = name, Potency = potency });
                    end
                    table.sort(mods, function(a, b)
                        return (a.Potency > b.Potency);
                    end);
                end
            end
            if (#mods > 0) then
                PrintMods(mods);
            end
        end
    end,
    ['$physical'] = function(mob, resource)
        if resource then
            local mods = T {};
            for name, potency in pairs(resource.Modifiers) do
                if (potency ~= 1.0) and T { 'H2H', 'Impact', 'Piercing', 'Slashing' }:contains(name) then
                    mods:append({ Type = name, Potency = potency });
                end
                table.sort(mods, function(a, b)
                    return (a.Potency > b.Potency);
                end);
            end
            if (#mods > 0) then
                PrintMods(mods);
            end
        end
    end,
    ['$magical'] = function(mob, resource)
        if resource then
            local mods = T {};
            for name, potency in pairs(resource.Modifiers) do
                if (potency ~= 1.0) and (T { 'Fire', 'Ice', 'Wind', 'Earth', 'Lightning', 'Water', 'Light', 'Dark' }:contains(name)) then
                    mods:append({ Type = name, Potency = potency });
                end
                table.sort(mods, function(a, b)
                    return (a.Potency > b.Potency);
                end);
            end
            if (#mods > 0) then
                PrintMods(mods);
            end
        end
    end,
    ['$physmagic'] = function(mob, resource)
        local foundPhysical = false;
        if resource then
            local mods = T {};
            for name, potency in pairs(resource.Modifiers) do
                if (potency ~= 1.0) and T { 'H2H', 'Impact', 'Piercing', 'Slashing' }:contains(name) then
                    mods:append({ Type = name, Potency = potency });
                end
                table.sort(mods, function(a, b)
                    return (a.Potency > b.Potency);
                end);
            end

            if (#mods > 0) then
                PrintMods(mods);
                foundPhysical = true;
            end

            mods = T {};
            for name, potency in pairs(resource.Modifiers) do
                if (potency ~= 1.0) and (T { 'Fire', 'Ice', 'Wind', 'Earth', 'Lightning', 'Water', 'Light', 'Dark' }:contains(name)) then
                    mods:append({ Type = name, Potency = potency });
                end
                table.sort(mods, function(a, b)
                    return (a.Potency > b.Potency);
                end);
            end
            if (#mods > 0) then
                if (foundPhysical) then
                    gTokenState:DrawText(' ');
                end
                PrintMods(mods);
            end
        end
    end,
    ['$hpp'] = function(mob)
        gTokenState:DrawText(tostring(entMgr:GetHPPercent(mob)));
    end,
    ['$aggro'] = function(mob, resource)
        if resource then
            PrintFlags(resource);
        end
    end,
    ['$debugflags'] = function(mob)
        PrintDebugFlags();
    end,
    ['$spawncount'] = function(mob)

    end,
    ['$immunity'] = function(mob, resource)
        if resource then
            PrintImmunities(resource);
        end
    end,
    ['$debugimmunity'] = function(mob)
        PrintAllImmunities();
    end,
    ['$statusresist'] = function(mob, resource)
        if resource then
            local mods = T {};
            for name, potency in pairs(resource.Modifiers) do
                if (potency ~= 1) and T { 'Amnesia', 'Virus', 'Silence', 'Gravity', 'Stun', 'LightSleep', 'Charm', 'Paralyze', 'Bind', 'Slow', 'Petrify', 'Terror', 'Poison', 'DarkSleep', 'Blind' }:contains(name) then
                    mods:append({ Type = 'Immune' .. name, Potency = potency });
                end
                table.sort(mods, function(a, b)
                    return (a.Potency > b.Potency);
                end);
            end

            if (#mods > 0) then
                PrintMods(mods);
            end
        end
    end,
    ['$dynamic'] = function(mob)
        if (mob >= 0x700) and (mob < 0x900) then
            gTokenState:DrawText('Dynamic');
        else
            gTokenState:DrawText('Static');
        end
    end,
    ['$speed'] = function(mob)
        local entity = AshitaCore:GetMemoryManager():GetEntity():GetRawEntity(mob);
        if entity == nil then
            if (ashita.addons_version < 2.2) then
                gTokenState:DrawText('??%%');
            else
                gTokenState:DrawText('??%');
            end
        else
            local speed = AshitaCore:GetMemoryManager():GetEntity():GetAnimationSpeed(mob) / 4;
            if (mob > 0x3FF) and (mob < 0x700) then
                speed = AshitaCore:GetMemoryManager():GetEntity():GetMovementSpeed(mob) / 5;
            end
            if (ashita.addons_version < 2.2) then
                gTokenState:DrawText(string.format('%.2d%%%%', speed * 100));
            else
                gTokenState:DrawText(string.format('%.2d%%', speed * 100));
            end
        end
    end,
    ['$speedrelative'] = function(mob)
        local entity = AshitaCore:GetMemoryManager():GetEntity():GetRawEntity(mob);
        if entity == nil then
            if (ashita.addons_version < 2.2) then
                gTokenState:DrawText('??%%');
            else
                gTokenState:DrawText('??%');
            end
        else
            local speed = AshitaCore:GetMemoryManager():GetEntity():GetAnimationSpeed(mob) / 4;
            if (mob > 0x3FF) and (mob < 0x700) then
                speed = AshitaCore:GetMemoryManager():GetEntity():GetMovementSpeed(mob) / 5;
            end
            if (speed == 1) then
                if (ashita.addons_version < 2.2) then
                    gTokenState:DrawText('+0%%');
                else
                    gTokenState:DrawText('+0%');
                end
            elseif (speed < 1) then
                local speedDrop = math.floor((1 - speed) * 100);
                if (ashita.addons_version < 2.2) then
                    gTokenState:DrawText(string.format('-%.2d%%%%', speedDrop));
                else
                    gTokenState:DrawText(string.format('-%.2d%%', speedDrop));
                end
            else
                local speedGain = math.floor((speed - 1) * 100);
                if (ashita.addons_version < 2.2) then
                    gTokenState:DrawText(string.format('+%.2d%%%%', speedGain));
                else
                    gTokenState:DrawText(string.format('+%.2d%%', speedGain));
                end
            end
        end
    end,
    ['$direction'] = function(mob)
        local entity = AshitaCore:GetMemoryManager():GetEntity():GetRawEntity(mob);
        if (entity == nil) then
            return;
        end

        local myIndex = AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0);
        local myPosition = {
            X = AshitaCore:GetMemoryManager():GetEntity():GetLocalPositionX(myIndex),
            Y = AshitaCore:GetMemoryManager():GetEntity():GetLocalPositionY(myIndex),
        };
        local targetPosition = {
            X = AshitaCore:GetMemoryManager():GetEntity():GetLocalPositionX(mob),
            Y = AshitaCore:GetMemoryManager():GetEntity():GetLocalPositionY(mob),
        };

        local rads = math.atan2(targetPosition.X - myPosition.X, targetPosition.Y - myPosition.Y);

        if (rads > 2.74) then
            gTokenState:DrawText('South');
        elseif (rads > 1.96) then
            gTokenState:DrawText('SouthEast');
        elseif (rads > 1.17) then
            gTokenState:DrawText('East');
        elseif (rads > 0.39) then
            gTokenState:DrawText('NorthEast');
        elseif (rads > -0.39) then
            gTokenState:DrawText('North');
        elseif (rads > -1.17) then
            gTokenState:DrawText('NorthWest');
        elseif (rads > -1.96) then
            gTokenState:DrawText('West');
        elseif (rads > -2.7) then
            gTokenState:DrawText('SouthWest');
        else
            gTokenState:DrawText('South');
        end
    end,
    ['$drops'] = function(mob, resource)
        if not resource then
            return;
        end

        local drops = (resource.Drops) and (resource.Drops[1]);
        if drops then
            local dropNames = T{};
            for _,item in ipairs(resource.Drops) do
                dropNames:append(resMgr:GetItemById(item).Name[1]);
            end
            table.sort(dropNames);
            local dropText = table.concat(dropNames, ',');
            gTokenState:DrawText(dropText);
        end
    end,
    ['$dropssplit'] = function(mob, resource)
        if not resource then
            return;
        end

        local drops = (resource.Drops) and (resource.Drops[1]);
        if drops then
            local dropNames = T{};
            for _,item in ipairs(resource.Drops) do
                dropNames:append(resMgr:GetItemById(item).Name[1]);
            end
            table.sort(dropNames);
            gTokenState:ProcessSameLines();
            for _,drop in ipairs(dropNames) do
                imgui.Text(drop);
            end
        end
    end,
    ['$notes'] = function(mob, resource)
        if resource then
            if (resource.Notes) and (#resource.Notes > 0) then
                for _, note in ipairs(resource.Notes) do
                    gTokenState:DrawText(note);
                end
            end
        end
    end
};
