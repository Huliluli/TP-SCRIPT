local WHITELIST_URL = "https://pastebin.com/raw/WHITELIST_ID"
local SCRIPT_URL = "https://pastebin.com/raw/SCRIPT_ID"

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
