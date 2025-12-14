- ===== LOADER =====
local WHITELIST = {
    ["SteFunTim"] = "2077-12-31",
    ["stefuntimsno"] = "2077-12-31",
    ["daproeti3"] = "2077-12-31"
}

local player = game:GetService("Players").LocalPlayer

local function isAllowed()
    local expire = WHITELIST[player.Name]
    if not expire then return false end
    local y,m,d = expire:match("(%d+)-(%d+)-(%d+)")
    if not y then return false end
    return os.time() <= os.time({year=tonumber(y), month=tonumber(m), day=tonumber(d)})
end

if not isAllowed() then
    warn("❌ You are not whitelisted or access expired")
    return
end

-- ===== LOAD MAIN TP SCRIPT =====
local ok, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Huliluli/TP-SCRIPT/main/tp.lua", true))()
end)

if not ok then
    warn("❌ Failed to load main TP script:", err)
end
