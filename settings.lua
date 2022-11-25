local function LoadCallbackFunction(self)
    if (type(self.ExcludePack) == 'table') then
        self.ExcludePack = T(self.ExcludePack);
    else
        self.ExcludePack = T{};
    end
    if (type(self.ExcludeUnpack) == 'table') then
        self.ExcludeUnpack = T(self.ExcludeUnpack);
    else
        self.ExcludeUnpack = T{};
    end
    if (type(self.ForceDisableContainers) == 'table') then
        self.ForceDisableContainers = T(self.ForceDisableContainers);
    else
        self.ForceDisableContainers = T{};
    end
    if (type(self.ForceEnableContainers) == 'table') then
        self.ForceEnableContainers = T(self.ForceEnableContainers);
    else
        self.ForceEnableContainers = T{};
    end
end

local function WriteItemArray(input, file, depth)
    local resMgr = AshitaCore:GetResourceManager();
    for _,v in ipairs(input) do
        local resource = resMgr:GetItemById(v);
        file:write(string.rep(' ', depth));
        file:write(v);
        file:write(',');
        if resource then
            file:write(' --' .. resource.Name[1]);
        else
            file:write(' --Resource Lookup Failed')
        end
        file:write('\n');
    end
end

local function WriteNumericArray(input, file)
    local first = true;
    for _,v in ipairs(input) do
        if not first then
            file:write(', ');
        end
        file:write(v);
        first = false;
    end
end

local function SaveFunction(self, characterSpecific)
    if not self.Path then
        print(chat.header(addon.name) .. chat.error('No path is set.  Could not save settings.'));
    end
    self:CreateDirectories(('%sconfig\\addons\\porter\\lists\\'):fmt(AshitaCore:GetInstallPath(), addon.name));
    local file = io.open(self.Path, 'w');
    file:write('--Automatically generated settings file for: ' .. addon.name .. '\n');
    file:write('local settings = {\n');
    if characterSpecific then
        file:write('    CharacterSpecific = ' .. tostring(self.CharacterSpecific) .. ',\n');
    end
    file:write('    ExcludePack = {\n');
    WriteItemArray(self.ExcludePack, file, 8);
    file:write('    },\n');
    file:write('    ExcludeUnpack = {\n');
    WriteItemArray(self.ExcludeUnpack, file, 8);
    file:write('    },\n');
    file:write('    ForceDisableContainers = { ');
    WriteNumericArray(self.ForceDisableContainers, file);
    file:write(' },\n');
    file:write('    ForceEnableContainers = { ');
    WriteNumericArray(self.ForceEnableContainers, file);
    file:write(' },\n');
    file:write('    BlockInput = ' .. tostring(self.BlockInput) .. ',\n');
    file:write('    RetryDelay = ' .. self.RetryDelay .. ',\n');
    file:write('    MaxPackets = ' .. self.MaxPackets .. '\n');
    file:write('};\n\n');
    file:write('return settings;');
    file:close();
end

local defaultSettings = {
    CharacterSpecific = true,
    ExcludePack = { },
    ExcludeUnpack = {},
    ForceDisableContainers = {}, 
    ForceEnableContainers = {},
    BlockInput = true,
    RetryDelay = 6,
    MaxPackets = 1
};

local settingsManager = require('settingsmanager'):New();
settingsManager.LoadCallback = LoadCallbackFunction;
settingsManager.Save = SaveFunction;
settingsManager:InitializeWithGui(defaultSettings, require('gui'));
return settingsManager;