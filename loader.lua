local WHITELIST_URL = "https://raw.githubusercontent.com/YOURNAME/REPO/main/whitelist.txt"
local SCRIPT_URL = "https://raw.githubusercontent.com/YOURNAME/REPO/main/tp_script.lua"

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
