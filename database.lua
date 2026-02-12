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
    local ptr = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????85C974??8B44240450E8????????C383C8FFC3', 2, 0)
    ptr = ashita.memory.read_uint32(ptr) + 0xF78;
    ptr = ashita.memory.read_uint32(ptr)
    local subZone = ashita.memory.read_uint16(ptr + 0x200);
    database:Load(AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0), subZone);
end

return database;