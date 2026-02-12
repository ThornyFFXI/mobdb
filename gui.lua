require('common');

local imgui = require('imgui');
local ui = T{
    IsOpen = T{ false },
}

local SettingsGui = {
    IsOpen = { false },
    SubWindows = {};
    Theme = {
        Header = { 1.0, 0.75, 0.55, 1.0 },
        Command = { 0.0, 1.0, 0.2, 1.0 }
    }
};

local speedExplanation = 'Entity speed, displayed in format 100% 125% etc.';
local speedRelativeExplanation = 'Entity speed, displayed in format +12.5% -12.5% etc.'
if (ashita.addons_version < 2.2) then
    speedExplanation = 'Entity speed, displayed in format 100%% 125%% etc.';
    speedRelativeExplanation = 'Entity speed, displayed in format +12.5%% -12.5%% etc.'
end

local TokenHelpData = {
    { Token='$name', Explanation='The name of your current target.'},
    { Token='$index', Explanation='The zone-specific index of your current target.'},
    { Token='$hexindex', Explanation='The zone-specific index of your current target, in hex notation.'},
    { Token='$hexid', Explanation='The game-specific id of your current target, in hex notation.'},
    { Token='$id', Explanation='The game-specific id of your current target.'},
    { Token='$zone', Explanation='Your current zone\'s name.'},
    { Token='$job', Explanation='Your current target\'s job if available, ??? if not.'},
    { Token='$level', Explanation='Your current target\'s level if available, ??? if not.'},
    { Token='$joblevel', Explanation='Format [Lv33-37] [Lv33-37 WAR] [WAR35/SAM18] depending on available information.  Nothing if not available.'},
    { Token='$position1', Explanation='Position in the format "(X, Y) Z:Z" with 2 decimal places.'},
    { Token='$position2', Explanation='Position in the format "(X,Y) Z:Z" with no decimals.'},
    { Token='$position3', Explanation='Position in the format "X:X Y:Y Z:Z" with 2 decimal places.'},
    { Token='$position4', Explanation='Position in the format "X:X Y:Y Z:Z" with no decimals.'},
    { Token='$strength', Explanation='Graphical display of weapons and elements the mob is strong against.'},
    { Token='$weakness', Explanation='Graphical display of weapons and elements the mob is weak against.'},
    { Token='$physical', Explanation='Graphical display of weapon types the mob is strong or weak against.'},
    { Token='$magical', Explanation='Graphical display of elements the mob is strong or weak against'},
    { Token='$physmagic', Explanation='Graphical display of elements and weapons the mob is strong or weak against.'},
    { Token='$immunity', Explanation='Graphical display of debuffs that a monster is immune to.' },
    { Token='$hpp', Explanation='The target\'s current HP percentage.'},
    { Token='$dynamic', Explanation='Dynamic if the monster is a custom spawn, Static if it is a normal spawn.'},
    { Token='$aggro', Explanation='Graphical display indicating whether the target aggros, links, is a NM, and how it detects you.'},
    { Token='$speed', Explanation=speedExplanation},
    { Token='$speedrelative', Explanation=speedRelativeExplanation}, 
    { Token='$debugflags', Explanation='Show all flags for debug purposes.' },
    { Token='$debugimmunity', Explanation='Show all immunity icons for debug purposes.' },
    { Token='$direction', Explanation='Show the cardinal direction in which the target resides.' },
    { Token='$drops', Explanation='Show target drops as a comma-seperated line.' },
    { Token='$dropssplit', Explanation='Show target drops with each drop on a new line.' },
    { Token='$notes', Explanation='Any notes saved on the target in the database.  Multiple notes always take a new line.' }
};

function SettingsGui:Initialize(parent)
    self.Parent = parent;
    self.TokenEditor = {
        IsOpen = { false },
        Categories = { 'Mob', 'Player', 'NPC', 'Pet', 'Nothing' },
        Strings = {};
    };
    self.TokenHelper = {
        IsOpen = { false }
    };
    for _,category in pairs(self.TokenEditor.Categories) do
        self.TokenEditor.Strings[category] = { self.Parent[category .. 'Format'] };
    end
end

function SettingsGui:Render()
    if (self.TokenEditor.IsOpen[1]) then
        if (imgui.Begin('MobDB Token Editor', self.TokenEditor.IsOpen, ImGuiWindowFlags_AlwaysAutoResize)) then
            for _,category in ipairs(self.TokenEditor.Categories) do
                imgui.TextColored(self.Theme.Header, string.format('%s Targeted', category));
                imgui.PushItemWidth(400);
                if imgui.InputText('##Token_' .. category, self.TokenEditor.Strings[category], 1080) then
                   self.Parent[category .. 'Format'] = self.TokenEditor.Strings[category][1];
                   gBar:ParseFormats(category .. 'Format'); 
                   self.Parent:Save(self.Parent.CharacterSpecific);
                end
                imgui.PopItemWidth();
            end
            if (imgui.Button('Help')) then
                self.TokenHelper.IsOpen[1] = true;
            end
            imgui.End();
        end

        if (self.TokenHelper.IsOpen[1]) then
            imgui.SetNextWindowSize({ 610, 597, });
            if (imgui.Begin('MobDB Token Help', self.TokenHelper.IsOpen, ImGuiWindowFlags_NoResize)) then
                for _,entry in pairs(TokenHelpData) do
                    imgui.TextColored(self.Theme.Header, entry.Token);
                    imgui.TextWrapped('  ' .. entry.Explanation);                    
                end
                imgui.End();
            end
            
        end
    else
        self.TokenHelper.IsOpen[1] = false;
        if (self.IsOpen[1]) then
            if (imgui.Begin(string.format('%s v%s', addon.name, addon.version), self.IsOpen, ImGuiWindowFlags_AlwaysAutoResize)) then
                imgui.TextColored(self.Theme.Header, 'Save Mode');
                if imgui.Checkbox('Character-Specific', { self.Parent.CharacterSpecific }) then
                    self.Parent:ToggleCharacterSpecific();
                    self.SubWindows = T{};
                end
                local details = { self.Parent.DetailView };
                imgui.TextColored(self.Theme.Header, 'Detailed View')
                if (imgui.Checkbox('Enabled##MobDB Detailed View', details)) then
                    self.Parent.DetailView = details[1];
                    self.Parent:Save(self.Parent.CharacterSpecific);
                end
                imgui.TextColored(self.Theme.Header, 'Draw Scale (Bar)');
                local scale = { self.Parent.Scale };
                if (imgui.SliderFloat('##BarScale', scale, 0.5, 3.0, '%.2f', ImGuiSliderFlags_AlwaysClamp)) then
                    if (scale[1] ~= self.Parent.Scale) then
                        self.Parent.Scale = scale[1];
                        self.Parent:Save(self.Parent.CharacterSpecific);
                    end
                end
                imgui.TextColored(self.Theme.Header, 'Draw Scale (Details)');
                local scale = { self.Parent.DetailScale };
                if (imgui.SliderFloat('##DetailScale', scale, 0.5, 3.0, '%.2f', ImGuiSliderFlags_AlwaysClamp)) then
                    if (scale[1] ~= self.Parent.DetailScale) then
                        self.Parent.DetailScale = scale[1];
                        self.Parent:Save(self.Parent.CharacterSpecific);
                    end
                end
                imgui.TextColored(self.Theme.Header, 'Opacity');
                local alpha = { self.Parent.Alpha };
                if (imgui.SliderFloat('##Alpha', alpha, 0.1, 1.0, '%.2f', ImGuiSliderFlags_AlwaysClamp)) then
                    if (alpha[1] ~= self.Parent.Alpha) then
                        self.Parent.Alpha = alpha[1];
                        self.Parent:Save(self.Parent.CharacterSpecific);
                    end
                end
                if (imgui.Button('Edit Tokens')) then
                    self.TokenEditor.IsOpen[1] = true;
                end
                imgui.End();
            end
        end
    end
end

return SettingsGui;