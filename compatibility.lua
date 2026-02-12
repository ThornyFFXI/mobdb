local compat = {};

compat.Resource = {
    Jobs = 'jobs.names_abbr',
    Zone = 'zones.names',
};

if (AshitaCore:GetResourceManager():GetString('jobs.names_abbr', 1) ~= 'WAR') then
    compat.Resource.Jobs = 'jobs_abbr';
    compat.Resource.Zone = 'zones';
end

--Credit to heals for this method
local d3dx_call_successful, _ = pcall(function()
    return ffi.C.D3DXCreateTextureFromFileInMemoryEx(nil, nil, 0, 0, 0, 0, 0, ffi.C.D3DFMT_A8R8G8B8, ffi.C.D3DPOOL_MANAGED, ffi.C.D3DX_DEFAULT, ffi.C.D3DX_DEFAULT, 0, nil, nil, nil); 
end);
if (not d3dx_call_successful) then
    ffi.cdef[[
        HRESULT __stdcall D3DXCreateTextureFromFileA(IDirect3DDevice8* pDevice, const char* pSrcFile, IDirect3DTexture8** ppTexture);
    ]];
end

return compat;