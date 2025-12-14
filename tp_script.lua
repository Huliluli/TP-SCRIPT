--// Services
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
title.Text = "Maor's Teleport"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(0,255,170)
title.Parent = frame

-- Status
local status = Instance.new("TextLabel")
status.Position = UDim2.new(0,0,0,40)
status.Size = UDim2.new(1,0,0,20)
status.BackgroundTransparency = 1
status.Text = "ready to steal"
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(180,180,180)
status.Parent = frame

-- Button
local button = Instance.new("TextButton")
button.Position = UDim2.new(0.5,-110,0,80)
button.Size = UDim2.new(0,220,0,42)
button.Text = "teleport"
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
    Vector3.new(-331.24,-4.59,23.64)
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
    status.Text = "Teleporting...."
    equipCarpet()

    for _, pos in ipairs(positions) do
        if hrp and hrp.Parent then
            hrp.CFrame = CFrame.new(pos + Vector3.new(0,2,0))
            task.wait(0.15)
        end
    end

    status.Text = "Successfully teleported!"
    busy = false
end

button.MouseButton1Click:Connect(startTeleport)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode.Name == keyBox.Text then
        startTeleport()
    end
end)

--========================================================--
--=        SLEEK ADMIN PANEL UI  (FINAL)                 =--
--=  Click Player → Select | Spam Keybind | Y = Toggle   =--
--========================================================--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Remote = ReplicatedStorage:WaitForChild("Packages")
	:WaitForChild("Net")
	:FindFirstChild("RE/AdminPanelService/ExecuteCommand")

-- =====================
-- COMMANDS
-- =====================
local commandsToSend = {
	"balloon", "jumpscare", "morph", "tiny",
	"inverse", "rocket"
}

-- =====================
-- STATE
-- =====================
local selectedPlayer = nil
local uiVisible = true
local spamKey = Enum.KeyCode.R
local waitingForKeybind = false

-- =====================
-- GUI BASE
-- =====================
local adminGui = Instance.new("ScreenGui")
adminGui.Name = "SleekAdminGUI"
adminGui.ResetOnSpawn = false
adminGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 480)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = adminGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- =====================
-- DRAGGABLE
-- =====================
local dragging, dragStart, startPos

mainFrame.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = i.Position
		startPos = mainFrame.Position
	end
end)

mainFrame.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local d = i.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + d.X,
			startPos.Y.Scale,
			startPos.Y.Offset + d.Y
		)
	end
end)

-- =====================
-- TITLE
-- =====================
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Maor Spammer"
title.Font = Enum.Font.GothamBlack
title.TextSize = 26
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Parent = mainFrame

-- =====================
-- PLAYER LIST
-- =====================
local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 1, -120)
list.Position = UDim2.new(0, 10, 0, 50)
list.ScrollBarThickness = 6
list.BackgroundTransparency = 1
list.Parent = mainFrame

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0, 8)

local function updateCanvas()
	list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

-- =====================
-- RUN COMMANDS
-- =====================
local function runAllCommands(plr)
	if not plr then return end
	task.spawn(function()
		for _, cmd in ipairs(commandsToSend) do
			pcall(function()
				Remote:FireServer(plr, cmd)
			end)
			task.wait(0.01)
		end
	end)
end

-- =====================
-- PLAYER CARD
-- =====================
local function createPlayerCard(plr)
	if plr == player then return end
	if list:FindFirstChild(plr.Name .. "_Card") then return end

	local card = Instance.new("TextButton")
	card.Name = plr.Name .. "_Card"
	card.Size = UDim2.new(1, 0, 0, 60)
	card.Text = ""
	card.AutoButtonColor = false
	card.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
	card.Parent = list
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -20, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = plr.Name
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 18
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = card

	card.MouseButton1Click:Connect(function()
		for _, c in ipairs(list:GetChildren()) do
			if c:IsA("TextButton") then
				c.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
			end
		end
		card.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
		selectedPlayer = plr
	end)

	updateCanvas()
end

-- =====================
-- INIT
-- =====================
for _, plr in ipairs(Players:GetPlayers()) do
	createPlayerCard(plr)
end

Players.PlayerAdded:Connect(function(plr)
	task.wait(1)
	createPlayerCard(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
	local c = list:FindFirstChild(plr.Name .. "_Card")
	if c then c:Destroy() end
	if selectedPlayer == plr then selectedPlayer = nil end
	updateCanvas()
end)

-- =====================
-- KEYBIND LABEL
-- =====================
local keybindLabel = Instance.new("TextButton")
keybindLabel.Size = UDim2.new(1, -20, 0, 30)
keybindLabel.Position = UDim2.new(0, 10, 1, -40)
keybindLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
keybindLabel.Text = "Spam Key: [ R ]"
keybindLabel.Font = Enum.Font.GothamBold
keybindLabel.TextSize = 14
keybindLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
keybindLabel.AutoButtonColor = false
keybindLabel.Parent = mainFrame
Instance.new("UICorner", keybindLabel).CornerRadius = UDim.new(0, 8)

keybindLabel.MouseButton1Click:Connect(function()
	waitingForKeybind = true
	keybindLabel.Text = "Press any key..."
	keybindLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
end)

-- =====================
-- HOTKEYS
-- =====================
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end

	if waitingForKeybind and input.KeyCode ~= Enum.KeyCode.Unknown then
		spamKey = input.KeyCode
		waitingForKeybind = false
		keybindLabel.Text = "Spam Key: [ " .. spamKey.Name .. " ]"
		keybindLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
		return
	end

	if input.KeyCode == spamKey then
		runAllCommands(selectedPlayer)
	end

	if input.KeyCode == Enum.KeyCode.Y then
		uiVisible = not uiVisible
		adminGui.Enabled = uiVisible
	end
end)

print("ADMIN PANEL READY | Select → Spam Key | Y toggle")
