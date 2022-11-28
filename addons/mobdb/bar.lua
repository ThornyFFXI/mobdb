local tokens = require('tokens');

local MobFormat = '$name[$joblevel] $aggro$LB$physmagic';
local PlayerFormat = 'PLAYER:';
local NPCFormat = 'NPC:';
local NothingFormat = 'NOTHING';
local PetFormat = 'PET';

local bar = {};

bar.Layout = {
    ItemSpacing = 0
}

bar.State = {
    IsOpen = { true }
};

local function ResolveToken(input, outTable)
    local longestMatch = 0;
    local bestFunc = nil;
    for token,func in pairs(tokens) do
        local start,finish = string.find(input, token);
        if (start == 1) and (finish > longestMatch) then
            longestMatch = finish;
            bestFunc = func;
        end
    end
    if bestFunc then
        outTable:append(bestFunc);
        return longestMatch;
    else
        return 1;
    end
end

local function SplitTokens(input)
    local outTable = T{};
    local nextToken = string.find(input, '%$');
    while (nextToken ~= nil) do
        if (nextToken == 1) then
            if string.sub(input, 1, 3) == '$LB' then
                outTable:append('$LB');
                input = string.sub(input, 4);
            else
                local length = ResolveToken(input, outTable);
                input = string.sub(input, length + 1);
            end
            nextToken = string.find(input, '%$');
        else
            outTable:append(string.sub(input, 1, nextToken - 1));
            input = string.sub(input, nextToken);
            nextToken = 1;
        end
    end
    if (string.len(input) > 0) then
        outTable:append(input);
    end

    return outTable;
end

bar.ParseFormats = function(self, format)
    if type(format) == 'string' then
        self.Layout[format] = SplitTokens(gSettings[format]);
    else
        self.Layout.MobFormat = SplitTokens(gSettings.MobFormat);
        self.Layout.PlayerFormat = SplitTokens(gSettings.PlayerFormat);
        self.Layout.NPCFormat = SplitTokens(gSettings.NPCFormat);
        self.Layout.NothingFormat = SplitTokens(gSettings.NothingFormat);
        self.Layout.PetFormat = SplitTokens(gSettings.PetFormat);
    end
end

bar.Render = function(self)
    local memMgr = AshitaCore:GetMemoryManager();
    local targetMgr = memMgr:GetTarget();
    local targetIndex = targetMgr:GetTargetIndex(targetMgr:GetIsSubTargetActive());
    local renderTable = self.Layout.NothingFormat;
    if (targetIndex > 0) then
        if (targetIndex < 0x400) then
            local spawnFlags = AshitaCore:GetMemoryManager():GetEntity():GetSpawnFlags(targetIndex);
            if (spawnFlags == 0x10) then
                renderTable = self.Layout.MobFormat;
            else
                renderTable = self.Layout.NPCFormat;
            end            
        elseif (targetIndex < 0x700) then
            renderTable = self.Layout.PlayerFormat;
        else
            renderTable = self.Layout.PetFormat;
        end
    end

    if (self.State.IsOpen[1]) and (#renderTable > 0) then
        imgui.PushStyleVar(ImGuiStyleVar_ItemSpacing, { self.Layout.ItemSpacing, self.Layout.ItemSpacing });
        if gSettings.Color then
            imgui.PushStyleColor(ImGuiCol_WindowBg, gSettings.Color);
        end
        imgui.SetNextWindowBgAlpha(gSettings.Alpha);
        if imgui.Begin('mobdb_infobar', self.State.IsOpen, bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize)) then
            imgui.SetWindowFontScale(gSettings.Scale);
            local renderIndex = 1;
            while (renderIndex <= #renderTable) do
                local currentObject = renderTable[renderIndex];
                if (type(currentObject) == 'function') then
                    if (currentObject(targetIndex)) then                        
                        local nextObject = renderTable[renderIndex + 1];
                        if (type(nextObject) ~= 'string') or (nextObject ~= '$LB') then
                            imgui.SameLine();
                        end
                    end
                elseif (type(currentObject) == 'string') then
                    if (currentObject ~= '$LB') then
                        imgui.Text(currentObject);
                        local nextObject = renderTable[renderIndex + 1];
                        if (type(nextObject) ~= 'string') or (nextObject ~= '$LB') then
                            imgui.SameLine();
                        end
                    end
                end
                renderIndex = renderIndex + 1;
            end
            imgui.End();
        end
        if (gSettings.Color) then
            imgui.PopStyleColor();
        end
    end
end

bar:ParseFormats();
return bar;