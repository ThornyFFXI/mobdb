local memMgr = AshitaCore:GetMemoryManager();
local entMgr = memMgr:GetEntity();
local partyMgr = memMgr:GetParty();
local playMgr = memMgr:GetPlayer();
local resMgr = AshitaCore:GetResourceManager();

return {
    ['$name'] = function(mob)
        local resource = gData.Mobs[mob.Index];
        if resource and resource.Name then
            return resource.Name;
        else
            return entMgr:GetName(mob.Index);
        end
    end,
    ['$index'] = function(mob)
        return tostring(mob.Index);
    end,
    ['$id'] = function(mob)
        return entMgr:GetServerId(mob.Index);
    end,
    ['$zone'] = function(mob)
        local zoneId = partyMgr:GetMemberZone(0);
        local string = resMgr:GetString('zones.names', zoneId);
        if string then
            return string;
        else
            return 'Unknown';
        end
    end,
    ['$job'] = function(mob)
        if (mob.Type == 'self') then
            local mainJob = playMgr:GetMainJob();
            local subJob = playMgr:GetSubJob();
            return string.format('%s/%s', resMgr:GetString('jobs.names_abbr', mainJob), resMgr:GetString('jobs.names_abbr', subJob));
        elseif (mob.Type == 'party') then
            for i = 1,17 do
                if partyMgr:GetMemberZone(i) == partyMgr:GetMemberZone(0) then
                    if partyMgr:GetMemberTargetIndex(i) == mob.Index then
                        local mainJob = partyMgr:GetMemberMainJob(i);
                        local subJob = partyMgr:GetMemberSubJob(i);
                        if ((mainJob ~= 0) or (subJob ~= 0)) then
                            return string.format('%s/%s', resMgr:GetString('jobs.names_abbr', mainJob), resMgr:GetString('jobs.names_abbr', subJob));
                        end
                        break;
                    end
                end
            end
            return '???/???';
        elseif (mob.Type == 'npc') then
            return 'N/A';
        elseif (mob.Type == 'enemy') then
            local resource = gData.Mobs[mob.Index];
            if resource and resource.Job then
                return resource.Job;
            else
                return '???/???';
            end
        end
    end,
    ['$level'] = function(mob)
        if (mob.Type == 'self') then
            return tostring(playMgr:GetMainJobLevel());
        elseif (mob.Type == 'party') then
            for i = 1,17 do
                if partyMgr:GetMemberZone(i) == partyMgr:GetMemberZone(0) then
                    if partyMgr:GetMemberTargetIndex(i) == mob.Index then
                        local level = partyMgr:GetMemberMainJobLevel(i);
                        if (level > 0) then
                            return tostring(level);
                        end
                        break;
                    end
                end
            end
            return '???';
        elseif (mob.Type == 'npc') then
            return 'N/A';
        elseif (mob.Type == 'enemy') then
            local resource = gData.Mobs[mob.Index];
            if resource and resource.Level then
                return tostring(resource.Level);
            elseif resource and resource.MinLevel and resource.MaxLevel then
                return string.format('%d-%d', resource.MinLevel, resource.MaxLevel);
            else
                return '???';
            end
        end
    end,
    ['$position'] = function(mob)
        return string.format('(%.2f,%.2f) Z:%.2f',
            entMgr:GetLocalX(mob.Index),
            entMgr:GetLocalY(mob.Index),
            entMgr:GetLocalZ(mob.Index));
    end,
    ['$elements'] = function(mob)

    end,
    ['$hp'] = function(mob)

    end,
    ['$hpp'] = function(mob)

    end,
    ['$aggro'] = function(mob)

    end,
    ['$spawncount'] = function(mob)

    end,
    ['$speed'] = function(mob)

    end,
    ['$notes'] = function(mob)

    end
};