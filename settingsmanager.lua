local mReservedKeys = T{
    'CreateDirectories',
    'DefaultSettings',
    'HandlePacket',
    'HandlePluginEvent',
    'Destroy',
    'GUI',
    'Initialize',
    'Load',
    'LoadCallback',
    'LoadDefaults',
    'PacketEvent',
    'PluginEvent',
    'PluginEventName',
    'RenderEvent',
    'Path',
    'PlayerName',
    'PlayerId',
    'Reset',
    'Save'
};

if not chat then
    chat = require('chat');
end

local function RecursiveFill(target, source)
    for k,v in pairs(source) do
        if type(v) == 'table' then
            local fillTable = {};
            RecursiveFill(fillTable, v);
            target[k] = fillTable;
        else
            target[k] = v;
        end
    end
end

local SettingsManager = {};

function SettingsManager:CreateDirectories(path)
    local backSlash = string.byte('\\');
    for c = 1,#path,1 do
        if (path:byte(c) == backSlash) then
            local directory = string.sub(path,1,c);            
            if (ashita.fs.create_directory(directory) == false) then
                print(chat.header(addon.name) .. chat.error('Failed to create directory: ' .. directory));
                return false;
            end
        end
    end
    return true;
end

function SettingsManager:HandlePacket(e)
    if e.id == 0x00A then
        local id = struct.unpack('L', e.data, 0x04 + 1);
        local name = struct.unpack('c16', e.data, 0x84 + 1);
        local i,j = string.find(name, '\0');
        if (i ~= nil) then
            name = string.sub(name, 1, i - 1);
        end
        if name ~= self.PlayerName or id ~= self.PlayerId then
            self:Reset();
            self.PlayerName = name;
            self.PlayerId = id;
            self:LoadDefaults();
        end
    end
end

function SettingsManager:Destroy()
    ashita.events.unregister('packet_in', self.PacketEvent);
    ashita.events.unregister('plugin_event', self.PluginEvent);
    if (self.RenderEvent) then
        ashita.events.unregister('d3d_present', self.RenderEvent);
    end
end

function SettingsManager:Load(path)
    local loadedFile, errorText = loadfile(path);
    if not loadedFile then
        print(chat.header(addon.name) .. chat.error('Failed to load settings file: ') .. chat.color1(2, path));
        print(chat.header(addon.name) .. chat.error(errorText));
        return false;
	end

    local settings = loadedFile();
    if not settings then
        return false;
    end

    for k,v in pairs(settings) do
        if not mReservedKeys:contains(k) then
            if type(v) == 'table' then
                local fillTable = {};
                RecursiveFill(fillTable, v);
                self[k] = fillTable;
            else
                self[k] = v;
            end
        end
    end

    self.Path = path;
    if (self.LoadCallback) then
        self:LoadCallback();
    end
    return true;
end

function SettingsManager:New(o)
    o = o or {};
    setmetatable(o, self)
    self.__index = self
    return o;
end

function SettingsManager:HandlePluginEvent(e)
    if (e.name == self.PluginEventName) and (not self.CharacterSpecific) then
        if not self:Load(self.Path) then
            print(chat.header(addon.name) .. chat.error('Failed to reload file: ' .. self.Path));
            self:Reset();
        end
    end
end

function SettingsManager:Initialize(defaultSettings, alias)
    self.DefaultSettings = T(defaultSettings):copy(true);
    self:Reset();
    self.PlayerName = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);
    self.PlayerId = AshitaCore:GetMemoryManager():GetParty():GetMemberServerId(0);
    self:LoadDefaults();
    self.PacketEvent = 'packet_in_cb_SettingsManager';
    self.PluginEvent = 'packet_in_cb_SettingsManager';
    self.PluginEventName = string.format('SettingsManager_%s_Reload_Event', addon.name);
    if type(alias) == 'string' then
        self.PacketEvent = 'packet_in_cb_' .. alias;
        self.PluginEvent = 'plugin_event_cb_' .. alias;
        self.PluginEventName = string.format('SettingsManager_%s_%s_Reload_Event', addon.name, alias);
    end
    ashita.events.register('packet_in', self.PacketEvent, self.HandlePacket:bind1(self));
    ashita.events.register('plugin_event', self.PluginEvent, self.HandlePluginEvent:bind1(self));
end

function SettingsManager:InitializeWithGui(defaultSettings, gui, alias)
    self.DefaultSettings = T(defaultSettings):copy(true);
    self.GUI = gui;
    self.PlayerName = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);
    self.PlayerId = AshitaCore:GetMemoryManager():GetParty():GetMemberServerId(0);
    self:LoadDefaults();
    self.GUI:Initialize(self);
    self.PacketEvent = 'packet_in_cb_SettingsManager';
    self.PluginEvent = 'packet_in_cb_SettingsManager';
    self.PluginEventName = string.format('SettingsManager_%s_Reload_Event', addon.name);
    self.RenderEvent = 'd3d_present_cb_SettingsManager';
    if type(alias) == 'string' then
        self.PacketEvent = 'packet_in_cb_' .. alias;
        self.PluginEvent = 'plugin_event_cb_' .. alias;
        self.PluginEventName = string.format('SettingsManager_%s_%s_Reload_Event', addon.name, alias);
        self.RenderEvent = 'd3d_present_cb_' .. alias;
    end
    ashita.events.register('packet_in', self.PacketEvent, self.HandlePacket:bind1(self));
    ashita.events.register('plugin_event', self.PluginEvent, self.HandlePluginEvent:bind1(self));
    ashita.events.register('d3d_present', self.RenderEvent, self.GUI.Render:bind1(self.GUI));
end

function SettingsManager:LoadDefaults()
    --Load character-specific file if it already exists.  Keep it if character-specific is enabled.
    self:Reset();
    local characterPath = string.format('%sconfig\\addons\\%s\\%s_%u.lua', AshitaCore:GetInstallPath(), addon.name, self.PlayerName, self.PlayerId);
    if ashita.fs.exists(characterPath) and self:Load(characterPath) then
        if self.CharacterSpecific then
            return;
        end
    end

    --Load or write default file otherwise.
    self:Reset();
    local defaultPath = string.format('%sconfig\\addons\\%s\\default.lua', AshitaCore:GetInstallPath(), addon.name);
    if not ashita.fs.exists(defaultPath) or not self:Load(defaultPath) then
        self.CharacterSpecific = false;
        self.Path = defaultPath;
        self:Save(false);
    else
        self.CharacterSpecific = false;
    end
end

function SettingsManager:Save(characterSpecific)
    print(chat.header(addon.name) .. chat.error('No save function was defined.  Settings cannot be saved.'));
end

function SettingsManager:ToggleCharacterSpecific()
    if not self.CharacterSpecific then
        --We are in default mode, changing to char specific.  We don't have to edit the default file for this, so just load character file.
        local characterPath = string.format('%sconfig\\addons\\%s\\%s_%u.lua', AshitaCore:GetInstallPath(), addon.name, self.PlayerName, self.PlayerId);
        local loaded = false;
        if ashita.fs.exists(characterPath) then
            if self:Load(characterPath) then
                if not self.CharacterSpecific then
                    self.CharacterSpecific = true;
                    self:Save(true);
                end
                return;
            end
        end

        self:Reset();
        self.CharacterSpecific = true;
        self.Path = characterPath;
        self:Save(true);
    else
        --Save character specific file as non-character specific, so next load it doesn't activate.
        self.CharacterSpecific = false;
        self:Save(true);

        --Reset settings, load default file, then write it if load failed.
        self:Reset();
        local defaultPath = string.format('%sconfig\\addons\\%s\\default.lua', AshitaCore:GetInstallPath(), addon.name);
        local loaded = (ashita.fs.exists(defaultPath) and self:Load(defaultPath));
        self.CharacterSpecific = false;
        if not loaded then
            self.Path = defaultPath;
            self:Save(false);
        end
    end
end

function SettingsManager:Reset()
    for k,v in pairs(self) do
        if not mReservedKeys:contains(k) then
            self[k] = nil;
        end
    end
    if (type(self.Save) ~= 'function') then
        self.Save = SaveFunction;
    end
    RecursiveFill(self, self.DefaultSettings);
    if (self.LoadCallback) then
        self:LoadCallback();
    end
end

return SettingsManager;