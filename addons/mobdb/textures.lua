local function LoadTexture(filePath)
    local dx_texture_ptr = ffi.new('IDirect3DTexture8*[1]');
    if (ffi.C.D3DXCreateTextureFromFileA(d3d8_device, filePath, dx_texture_ptr) == ffi.C.S_OK) then
        return d3d8.gc_safe_release(ffi.cast('IDirect3DTexture8*', dx_texture_ptr[0]));
    end
    return nil;
end

local textures = {};

textures.Initialize = function(self)
    if self.Cache then
        return;
    end

    self.Cache = {};
    local directory = string.format('%saddons/mobdb/icons/', AshitaCore:GetInstallPath());
    local contents = ashita.fs.get_directory(directory, '.*');
    for _,file in pairs(contents) do
        local index = string.find(file, '%.');        
        local key = string.sub(file, 1, index - 1);
        self.Cache[key] = LoadTexture(string.format('%saddons/mobdb/icons/%s', AshitaCore:GetInstallPath(), file));
    end
end

textures.Release = function(self)

end


return textures;