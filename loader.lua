-- Wave-compatible loader.lua
local player = game.Players.LocalPlayer
local allowed = false

-- ================= WHITELIST =================
-- Format: ["Username"] = "YYYY-MM-DD"
local WHITELIST = {
    ["SteFunTim"] = "2025-12-31"
}

-- Check if player is whitelisted and not expired
local function isAllowed(name)
    local expireDate = WHITELIST[name]
    if not expireDate then return false end
    local y, m, d = expireDate:match("(%d+)-(%d+)-(%d+)")
    local expireTime = os.time{year=tonumber(y), month=tonumber(m), day=tonumber(d)}
    return os.time() <= expireTime
end

if not isAllowed(player.Name) then
    warn("You are not whitelisted or your access expired")
    return
end

-- ================= MAIN SCRIPT =================
-- Paste your tp_script.lua code here as a string
local mainScript = [[
-- Example content of tp_script.lua
-- Replace this with your full teleport/UI code

print("Script running for "..game.Players.LocalPlayer.Name)
-- Add all your UI, teleport, anti-death logic here
]]

-- Execute the main script
loadstring(mainScript)()
