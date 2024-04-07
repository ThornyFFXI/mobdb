local tokens = require('tokens');
local details = {
    IsOpen = { true },
    Header = { 1.0, 0.75, 0.55, 1.0 },
};
local entMgr = AshitaCore:GetMemoryManager():GetEntity();
local resMgr = AshitaCore:GetResourceManager();
local errorPrinted = T{};

local function GetDirection(index)
    local myIndex = AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0);
    local myX = entMgr:GetLocalPositionX(myIndex);
    local myY = entMgr:GetLocalPositionY(myIndex);
    local targetX = entMgr:GetLocalPositionX(index);
    local targetY = entMgr:GetLocalPositionY(index);

    local rads = math.atan2(targetX - myX, targetY - myY);

    if (rads > 2.74) then
        return 'South';
    elseif (rads > 1.96) then
        return 'South-East';
    elseif (rads > 1.17) then
        return 'East';
    elseif (rads > 0.39) then
        return 'North-East';
    elseif (rads > -0.39) then
        return 'North';
    elseif (rads > -1.17) then
        return 'North-West';
    elseif (rads > -1.96) then
        return 'West';
    elseif (rads > -2.7) then
        return 'South-West';
    else
        return 'South';
    end
end

local function GetPosition(index)
    return string.format('(%.2f,%.2f) Z:%.2f',
        entMgr:GetLocalPositionX(index),
        entMgr:GetLocalPositionY(index),
        entMgr:GetLocalPositionZ(index));
end

local function GetSpeed(index)
    local entity = AshitaCore:GetMemoryManager():GetEntity():GetRawEntity(index);
    if entity == nil then
        return 'Unknown';
    else
        local speed = entMgr:GetAnimationSpeed(index);
        local relative = speed / 4;
        if (index > 0x3FF) and (index < 0x700) then
            speed = entMgr:GetMovementSpeed(index);
            relative = speed / 5;
        end

        if (relative < 0) then
            if (ashita.addons_version < 2.2) then
                relative = string.format('-%.2d%%%%', math.floor((1 - relative) * 100));
            else
                relative = string.format('-%.2d%%', math.floor((1 - relative) * 100));
            end
        elseif (relative > 0) then
            if (ashita.addons_version < 2.2) then
                relative = string.format('+%.2d%%%%', math.floor((relative - 1) * 100));
            else
                relative = string.format('+%.2d%%', math.floor((relative - 1) * 100));
            end
        else
            relative = '+0%';
        end
        
        return string.format('%.2f Yalms/Second (%s)', speed, relative);
    end
end

local function DrawImage(file)
    local texture = gTextures.Cache[file];
    if (texture == nil) then
        if errorPrinted[file] == nil then
            print(chat.header('MobDB') .. chat.error('Texture not found: ' .. file));
            errorPrinted[file] = true;
        end
        return;
    end
    imgui.Image(tonumber(ffi.cast("uint32_t", gTextures.Cache[file])), {13 * gSettings.DetailScale, 13 * gSettings.DetailScale }, { 0, 0 }, { 1, 1 }, { 1, 1, 1, 1 }, { 0, 0, 0, 0 });
    if imgui.IsItemHovered() then
        imgui.SetTooltip(file);
    end
end

local function PrintMods(mods)
    local first = true;
    for index,mod in ipairs(mods) do
        if not first then
            imgui.SameLine();
        end

        if (gTextures.Cache[mod.Type] ~= nil) then
            DrawImage(mod.Type);
            first = false;
        end

        if (index == #mods) or (mods[index+1].Potency ~= mod.Potency) then
            local outstring = '';
            if (mod.Potency > 1) then
                if (ashita.addons_version < 2.2) then
                    outstring = outstring .. '+' .. string.format('%.2f', ((mod.Potency - 1) * 100)):gsub('0+$', ''):gsub('%.$', '') .. '%%';
                else
                    outstring = outstring .. '+' .. string.format('%.2f', ((mod.Potency - 1) * 100)):gsub('0+$', ''):gsub('%.$', '') .. '%';
                end
            else
                if (ashita.addons_version < 2.2) then
                    outstring = outstring .. '-' .. string.format('%.2f', ((1 - mod.Potency) * 100)):gsub('0+$', ''):gsub('%.$', '') .. '%%';
                else
                    outstring = outstring .. '-' .. string.format('%.2f', ((1 - mod.Potency) * 100)):gsub('0+$', ''):gsub('%.$', '') .. '%';
                end
            end

            local lastLine = (index == #mods);
            if not lastLine then
                outstring = outstring .. ' ';
            end
            imgui.SameLine();
            imgui.Text(outstring);
        end
    end
end

local function PrintFlags(resource)
    if (resource.Notorious) then
        if (resource.Aggro) then
            DrawImage('AggroHQ');
        else
            DrawImage('PassiveHQ');
        end
    else
        if (resource.Aggro) then
            DrawImage('AggroNQ');
        else
            DrawImage('PassiveNQ');
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
            DrawImage(flag);
        end
    end
end

local function PrintImmunities(resource)
    local flags = {
        { flag=0x01, icon='ImmuneSleep' },
        { flag=0x02, icon='ImmuneGravity' },
        { flag=0x04, icon='ImmuneBind' },
        { flag=0x08, icon='ImmuneStun' },
        { flag=0x10, icon='ImmuneSilence' },
        { flag=0x20, icon='ImmuneParalyze' },
        { flag=0x40, icon='ImmuneBlind' },
        { flag=0x80, icon='ImmuneSlow' },
        { flag=0x100, icon='ImmunePoison' },
        { flag=0x200, icon='ImmuneElegy' },
        { flag=0x400, icon='ImmuneRequiem' },
        { flag=0x800, icon='ImmuneLightSleep' },
        { flag=0x1000, icon='ImmuneDarkSleep' },
        { flag=0x2000, icon='ImmunePetrify' }, 
    }

    local first = true;
    for _,flag in ipairs(flags) do
        if (bit.band(resource.Immunities, flag.flag) ~= 0) then
            if (gTextures.Cache[flag.icon] ~= nil) then
                if not first then
                    imgui.SameLine();
                else
                    imgui.TextColored(details.Header, 'Status Immunities');
                    first = false;
                end
                DrawImage(flag.icon);
            end
        end
    end
end

local function TimeToString(time)
    local days = math.floor(time / 86400);
    time = math.fmod(time, 86400);
    local hours = math.floor(time / 3600);
    time = math.fmod(time, 3600);
    local minutes = math.floor(time / 60);
    local seconds = math.fmod(time, 60);

    if (days > 0) then
        if (hours == 0) and (minutes == 0) and (seconds == 0) then
            return string.format('%u days', days);
        else
            return string.format('%u days + %02u:%02u:%02u', days, hours, minutes, seconds);
        end
    elseif (hours > 0) then
        return string.format('%u:%02u:%02u', hours, minutes, seconds);
    else
        return string.format('%u:%02u', minutes, seconds);
    end
end

function details:Render()
    local targetMgr = AshitaCore:GetMemoryManager():GetTarget();
    local index = targetMgr:GetTargetIndex(targetMgr:GetIsSubTargetActive());
    local resource = nil;
    if (index == 0) then
        return;
    end
    
    if (bit.band(AshitaCore:GetMemoryManager():GetEntity():GetSpawnFlags(index), 0x10) ~= 0) then
        resource = gData.Indices[index];
        if resource == nil then
            resource = gData.Names[entMgr:GetName(index)];
        end
    end

    imgui.PushStyleVar(ImGuiStyleVar_ItemSpacing, { 0, 0 });
    if (imgui.Begin(string.format('%s v%s##MobDB Detail View', addon.name, addon.version), { true }, ImGuiWindowFlags_AlwaysAutoResize)) then
        imgui.SetWindowFontScale(gSettings.DetailScale);
        imgui.BeginGroup();
        imgui.TextColored(self.Header, 'Name:');
        imgui.SameLine();
        if resource and resource.Name then
            imgui.Text(resource.Name);
        else
            local name = entMgr:GetName(index);
            if (name ~= nil) then
                imgui.Text(name);
            else
                imgui.Text('Unknown');
            end
        end

        imgui.TextColored(self.Header, 'Index:');
        imgui.SameLine();
        imgui.Text(string.format('%u[0x%X]', index, index));
        
        imgui.TextColored(self.Header, 'Id:');
        imgui.SameLine();
        local id = entMgr:GetServerId(index);
        imgui.Text(string.format('%u[0x%08X]', id, id));

        imgui.TextColored(self.Header, 'Position:');
        imgui.SameLine();
        imgui.Text(GetPosition(index));
            
        imgui.TextColored(self.Header, 'Direction:');
        imgui.SameLine();
        imgui.Text(GetDirection(index));
                        
        imgui.TextColored(self.Header, 'Speed:');
        imgui.SameLine();
        imgui.Text(GetSpeed(index));

        if (index > 0) and (index < 0x900) and (bit.band(entMgr:GetSpawnFlags(index), 0x10) ~= 0) then
            imgui.TextColored(self.Header, 'Is Custom Mob:');
            imgui.SameLine();
            if ((index >= 0x700) and (index <= 0x900)) then
                imgui.Text('Yes');
            else
                imgui.Text('No');
            end
        end

        if resource then
            if resource.Job > 0 then
                imgui.TextColored(self.Header, 'Job:');
                imgui.SameLine();
                local output = resMgr:GetString(gCompatibility.Resource.Jobs, resource.Job);
                if (resource.SubJob ~= nil) and (resource.SubJob > 0) then
                    output = output .. '/' .. resMgr:GetString(gCompatibility.Resource.Jobs, resource.SubJob);                    
                end
                imgui.Text(output);
            end

            imgui.TextColored(self.Header, 'Level:');
            imgui.SameLine();
            if (resource.Level) then
                imgui.Text(resource.Level);                    
            else
                imgui.Text(string.format('%d-%d', resource.MinLevel, resource.MaxLevel));
            end

            if (resource.Respawn ~= nil) and (resource.Respawn > 0) then
                imgui.TextColored(self.Header, 'Respawn Time:');
                imgui.SameLine();
                imgui.Text(TimeToString(resource.Respawn));
            end
            
            imgui.TextColored(self.Header, 'Flags');
            PrintFlags(resource);
            
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
                imgui.TextColored(self.Header, 'Physical Modifiers');
                PrintMods(mods);
            end
        
            mods = T{};
            for name,potency in pairs(resource.Modifiers) do
                if (potency ~= 1.0) and (T{'Fire', 'Ice', 'Wind', 'Earth', 'Lightning', 'Water', 'Light', 'Dark'}:contains(name)) then
                    mods:append({ Type=name, Potency=potency });
                end
                table.sort(mods, function(a,b)
                    return (a.Potency > b.Potency);
                end);
            end
            if (#mods > 0) then
                imgui.TextColored(self.Header, 'Magical Modifiers');
                PrintMods(mods);
            end
            
            PrintImmunities(resource);
        end
        imgui.EndGroup();

        if (resource) then
            local beganGroup = false;
            local drops = (resource.Drops) and (resource.Drops[1]);
            local spells = (resource.Spells) and (resource.Spells[1]);

            if drops or spells then
                imgui.PushStyleVar(ImGuiStyleVar_ItemSpacing, { 8, 0 });
                imgui.SameLine();
                imgui.BeginGroup();
            end
            
            if drops then
                local dropNames = T{};
                imgui.TextColored(self.Header, 'Drops');
                for _,item in ipairs(resource.Drops) do
                    dropNames:append(resMgr:GetItemById(item).Name[1]);
                end
                table.sort(dropNames);
                for _,dropName in ipairs(dropNames) do
                    imgui.Text(dropName);
                end
                if spells then
                    imgui.NewLine();
                end
            end
            
            if spells then
                local spellNames = T{};
                imgui.TextColored(self.Header, 'Spells');
                local outText = T{};
                for _,spell in ipairs(resource.Spells) do
                    spellNames:append(resMgr:GetSpellById(spell).Name[1]);
                end
                table.sort(spellNames);
                for _,spellName in ipairs(spellNames) do
                    imgui.Text(spellName);
                end
            end

            if drops or spells then
                imgui.EndGroup();
                imgui.PopStyleVar();
            end
        end
        imgui.End();
    end
    imgui.PopStyleVar();
end

return details;