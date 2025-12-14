local WHITELIST_URL = "PASTE_RAW_whitelist.txt_URL_HERE"
local SCRIPT_URL = "PASTE_RAW_CarpetTP.lua_URL_HERE"

local player = game.Players.LocalPlayer
local allowed = false

local data = game:HttpGet(WHITELIST_URL)
for line in data:gmatch("[^\r\n]+") do
    local user, date = line:match("(.+)|(.+)")
    if user == player.Name then
        local y,m,d = date:match("(%d+)-(%d+)-(%d+)")
        local expire = os.time{year=y, month=m, day=d}
        if os.time() <= expire then
            allowed = true
        end
        break
    end
end

if not allowed then
    warn("Not whitelisted or expired")
    return
end

loadstring(game:HttpGet(SCRIPT_URL))()
