--// Loader.lua (SHORT & SAFE)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ===== DATE WHITELIST =====
-- Format: ["Username"] = "YYYY-MM-DD"
local WHITELIST = {
    ["SteFunTim"] = "2077-12-31",
    ["stefuntimsno"] = "2077-12-31",
    ["daproeti3"] = "2077-12-31"
}

local function isAllowed()
    local expire = WHITELIST[player.Name]
    if not expire then return false end

    local y,m,d = expire:match("(%d+)-(%d+)-(%d+)")
    if not y then return false end

    local expireTime = os.time({
        year = tonumber(y),
        month = tonumber(m),
        day = tonumber(d)
    })

    return os.time() <= expireTime
end

if not isAllowed() then
    warn("❌ You are not whitelisted or access expired")
    return
end

local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Huliluli/TP-SCRIPT/refs/heads/main/loader.lua", true))()
end)

if not ok then
    warn("❌ Failed to load main script:", err)
end

-- Load the main TP script from GitHub
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Huliluli/TP-SCRIPT/refs/heads/main/loader.lua", true))()
end)

if not success then
    warn("Failed to load TP script:", err)
end
