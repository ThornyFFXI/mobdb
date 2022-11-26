local database = {};

database.Load = function(self, zone)
    if (zone == self.CurrentZone) then
        return;
    end

    self.CurrentZone = zone;
    self.Mobs = {};
    if (zone == 0) then
        return;
    end

    local path = string.format('%saddons/mobdb/data/%u.lua', AshitaCore:GetInstallPath(), zone);
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
    
    self.Mobs = output;
end

database:Load(AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0));
return database;