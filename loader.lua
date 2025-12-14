-- ================= WAVE VERSION (NO HTTP) =================

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local Backpack = player:WaitForChild("Backpack")

-- ================= WHITELIST =================
-- Add buyers here
-- ["Username"] = "YYYY-MM-DD"
local WHITELIST = {
    ["SteFunTim"] = "2025-12-31",
    ["stefuntimsno"] = "2025-12-31"
}

local function isAllowed()
    local expire = WHITELIST[player.Name]
    if not expire then return false end

    local y,m,d = expire:match("(%d+)-(%d+)-(%d+)")
    if not y then return false end

    return os.time() <= os.time({
        year = tonumber(y),
        month = tonumber(m),
        day = tonumber(d)
    })
end

if not isAllowed() then
    warn("Not whitelisted or expired")
    return
end

-- ================= CLEAN UI ON RESPAWN =================
player.CharacterAdded:Connect(function()
    task.wait(1)
    if PlayerGui:FindFirstChild("CarpetTP_UI") then
        PlayerGui.CarpetTP_UI:Destroy()
    end
end)

-- ================= CHARACTER =================
local function getChar()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    return char, hum, hrp
end

local char, hum, hrp = getChar()

-- Anti one-hit
hum.HealthChanged:Connect(function(h)
    if h <= 1 then
        hum.Health = math.max(hum.MaxHealth * 0.5, 10)
    end
end)

-- ================= UI =================
if PlayerGui:FindFirstChild("CarpetTP_UI") then
    PlayerGui.CarpetTP_UI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "CarpetTP_UI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,260,0,180)
frame.Position = UDim2.new(0.5,-130,0.5,-90)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "הטלפורט של מאור"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(0,255,170)
title.Parent = frame

local status = Instance.new("TextLabel")
status.Position = UDim2.new(0,0,0,40)
status.Size = UDim2.new(1,0,0,20)
status.BackgroundTransparency = 1
status.Text = "מוכן."
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(180,180,180)
status.Parent = frame

local button = Instance.new("TextButton")
button.Position = UDim2.new(0.5,-110,0,80)
button.Size = UDim2.new(0,220,0,42)
button.Text = "תשתגר"
button.Font = Enum.Font.GothamBold
button.TextSize = 17
button.BackgroundColor3 = Color3.fromRGB(45,45,45)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Parent = frame
Instance.new("UICorner", button)

-- ================= TELEPORT =================
local positions = {
    Vector3.new(-349.9, -5.8, 116.4),
    Vector3.new(-347.3, -5.8, 8.6),
    Vector3.new(-331.4, -4.1, 19.3)
}

local function equipCarpet()
    char, hum, hrp = getChar()
    local tool = Backpack:FindFirstChild("Flying Carpet") or char:FindFirstChild("Flying Carpet")
    if tool then hum:EquipTool(tool) end
end

local busy = false
local function teleport()
    if busy then return end
    busy = true
    status.Text = "משתגר..."
    equipCarpet()

    for _,pos in ipairs(positions) do
        if hrp then
            hrp.CFrame = CFrame.new(pos + Vector3.new(0,2,0))
            task.wait(0.15)
        end
    end

    status.Text = "טלפורט הושלם!"
    busy = false
end

button.MouseButton1Click:Connect(teleport)

print("TP Script loaded for:", player.Name)
