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
        local nextString = string.sub(input, 2);
        local nextTokenIndex = string.find(nextString, '%$');
        if (nextTokenIndex ~= nil) then
            outTable:append(string.sub(input, 1, nextTokenIndex));
            return nextTokenIndex;
        else
            return -1;
        end
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
                if (length == -1) then
                    break;
                end
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
    local entMgr = memMgr:GetEntity();
    local targetMgr = memMgr:GetTarget();
    local targetIndex = targetMgr:GetTargetIndex(targetMgr:GetIsSubTargetActive());
    local renderTable = self.Layout.NothingFormat;
    local targetResource = nil;
    if (targetIndex > 0) then
        if (targetIndex >= 0x400) and (targetIndex < 0x700) then
            renderTable = self.Layout.PlayerFormat;
        elseif (targetIndex >= 0x700) and (entMgr:GetTrustOwnerTargetIndex(targetIndex) ~= 0) then
            renderTable = self.Layout.PetFormat;
        elseif (bit.band(AshitaCore:GetMemoryManager():GetEntity():GetSpawnFlags(targetIndex), 0x10) ~= 0) then
            renderTable = self.Layout.MobFormat;
            targetResource = gData.Indices[targetIndex];
            if targetResource == nil then
                targetResource = gData.Names[entMgr:GetName(targetIndex)];
            end
        else
            renderTable = self.Layout.NPCFormat;
        end
    end

    if (self.State.IsOpen[1]) and (#renderTable > 0) then
        imgui.PushStyleVar(ImGuiStyleVar_ItemSpacing, { self.Layout.ItemSpacing, self.Layout.ItemSpacing });
        local pushColor = gSettings.Color;
        if pushColor then
            imgui.PushStyleColor(ImGuiCol_WindowBg, gSettings.Color);
        end
        imgui.SetNextWindowBgAlpha(gSettings.Alpha);
        if imgui.Begin('mobdb_infobar', self.State.IsOpen, bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize)) then
            imgui.SetWindowFontScale(gSettings.Scale);
            gTokenState.FirstElement = true;
            gTokenState.LineBreak = false;
            for index,currentObject in ipairs(renderTable) do
                if (type(currentObject) == 'function') then
                    currentObject(targetIndex, targetResource);
                elseif (type(currentObject) == 'string') then
                    if (currentObject == '$LB') then
                        gTokenState.LineBreak = true;
                    else
                        gTokenState:ProcessSameLines();
                        imgui.Text(currentObject);
                    end
                end
            end
            imgui.End();
        end
        if pushColor then
            imgui.PopStyleColor();
        end
        imgui.PopStyleVar();
    end
end

bar:ParseFormats();
return bar;