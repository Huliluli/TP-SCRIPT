player.CharacterAdded:Connect(function()
    task.wait(1)
    if PlayerGui:FindFirstChild("CarpetTP_UI") then
        PlayerGui.CarpetTP_UI:Destroy()
    end
end)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local Backpack = player:WaitForChild("Backpack")

--// Character Loader
local function getChar()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    return char, hum, hrp
end

local char, hum, hrp = getChar()

--// Anti One-Hit Death
hum.HealthChanged:Connect(function(h)
    if h <= 1 then
        hum.Health = math.max(hum.MaxHealth * 0.5, 10)
    end
end)

--// ================= UI =================

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
Instance.new("UIStroke", frame).Thickness = 2

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "הטלפורט של מאור"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(0,255,170)
title.Parent = frame

-- Status
local status = Instance.new("TextLabel")
status.Position = UDim2.new(0,0,0,40)
status.Size = UDim2.new(1,0,0,20)
status.BackgroundTransparency = 1
status.Text = "מוכן."
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(180,180,180)
status.Parent = frame

-- Button
local button = Instance.new("TextButton")
button.Position = UDim2.new(0.5,-110,0,80)
button.Size = UDim2.new(0,220,0,42)
button.Text = "תשתגר"
button.Font = Enum.Font.GothamBold
button.TextSize = 17
button.BackgroundColor3 = Color3.fromRGB(45,45,45)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.AutoButtonColor = false
button.Parent = frame
Instance.new("UICorner", button)

-- Keybind
local keyLabel = Instance.new("TextLabel")
keyLabel.Position = UDim2.new(0,15,1,-30)
keyLabel.Size = UDim2.new(0,80,0,20)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "Keybind:"
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextSize = 12
keyLabel.TextColor3 = Color3.fromRGB(140,140,140)
keyLabel.Parent = frame

local keyBox = Instance.new("TextBox")
keyBox.Position = UDim2.new(0,95,1,-30)
keyBox.Size = UDim2.new(0,40,0,20)
keyBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
keyBox.BorderSizePixel = 0
keyBox.Text = "F"
keyBox.Font = Enum.Font.GothamBold
keyBox.TextSize = 14
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.ClearTextOnFocus = true
keyBox.Parent = frame
Instance.new("UICorner", keyBox)

keyBox.FocusLost:Connect(function()
    if keyBox.Text == "" then
        keyBox.Text = "F"
    else
        keyBox.Text = string.upper(string.sub(keyBox.Text,1,1))
    end
end)

-- Dragging
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

--// ================= INSTANT TELEPORT =================

local positions = {
    Vector3.new(-349.9, -5.8, 116.4),
    Vector3.new(-347.3, -5.8, 8.6),
    Vector3.new(-331.4, -4.1, 19.3)
}

local function equipCarpet()
    char, hum, hrp = getChar()
    local tool = Backpack:FindFirstChild("Flying Carpet") or char:FindFirstChild("Flying Carpet")
    if tool then
        hum:EquipTool(tool)
    end
end

local busy = false
local function startTeleport()
    if busy then return end
    busy = true
    status.Text = "משתגר..."
    equipCarpet()

    for _, pos in ipairs(positions) do
        if hrp and hrp.Parent then
            hrp.CFrame = CFrame.new(pos + Vector3.new(0,2,0))
            task.wait(0.15)
        end
    end

    status.Text = "טלפורט הושלם!"
    busy = false
end

button.MouseButton1Click:Connect(startTeleport)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode.Name == keyBox.Text then
        startTeleport()
    end
end)
