local HttpService = game:GetService("HttpService")

local WHITELIST_URL = "https://pastebin.com/raw/zByKDzHd"
local SCRIPT_URL = "https://pastebin.com/raw/YZcaL8Hi"

local player = game.Players.LocalPlayer
local allowed = false

local function httpget(url)
    return HttpService:GetAsync(url)
end

local data = httpget(WHITELIST_URL)
for line in data:gmatch("[^\r\n]+") do
    local user, date = line:match("(.+)|(.+)")
    if user and date and user == player.Name then
        local y,m,d = date:match("(%d+)-(%d+)-(%d+)")
        local expire = os.time{year=y, month=m, day=d}
        if os.time() <= expire then
            allowed = true
        end
        break
    end
end

if not allowed then
    warn("You are not whitelisted or your access expired")
    return
end

loadstring(httpget(SCRIPT_URL))()
