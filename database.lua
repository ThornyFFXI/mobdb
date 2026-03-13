local database = {};

database.Load = function(self, zone, subZone)
    -- Upper bound isn't verified in client but currently legit subzones are around 1000-1030~
    -- Just an extra safety check in case signature breaks.
    if subZone < 1000 or subZone > 1299 then
        subZone = nil;
    end

    if (zone == self.CurrentZone) and (subZone == self.SubZone) then
        return;
    end

    self.CurrentZone = zone;
    self.SubZone = subZone;
    self.Names = T{};
    self.Indices = T{};
    if (zone == 0) then
        return;
    end

    local path = string.format('%saddons/mobdb/data/%u.lua', AshitaCore:GetInstallPath(), zone);
    if (self.SubZone ~= nil) then
        local subPath = string.format('%saddons/mobdb/data/%u.lua', AshitaCore:GetInstallPath(), self.SubZone);
        if ashita.fs.exists(subPath) then
            path = subPath;
        end
    end
    if (ashita.fs.exists(path)) then
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
    
        self.Indices = output.Indices;
        self.Names = output.Names;
    end
end

do
    local playerIndex = AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0);
    if playerIndex ~= 0 then
        --Initialize zone/subzone. Credit to atom0s for locating signature and offsets.
        local zonePointer = ashita.memory.find(0, 0, 'A1????????668B88????????668B90????????5152E8????????A3', 0x00, 0x00);
        local offset1 = ashita.memory.read_uint32(zonePointer + 0x08);
        local offset2 = ashita.memory.read_uint32(zonePointer + 0x0F);
        local pointer = ashita.memory.read_uint32(zonePointer + 0x01);
        if (pointer ~= 0) then
            pointer = ashita.memory.read_uint32(pointer);
            if (pointer ~= 0) then
                database:Load(ashita.memory.read_uint32(pointer + offset2), ashita.memory.read_uint16(pointer + offset1));
            end
        end
    end
end

return database;