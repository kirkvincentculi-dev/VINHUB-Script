-- VinHub | Speed & Jump Controller
-- Roblox LocalScript

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "VinHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 240)
main.Position = UDim2.new(0.5, -150, 0.5, -120)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
main.Active = true
main.Draggable = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius =
    UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "VinHub"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 25
title.Font = Enum.Font.GothamBold
title.Parent = main

local function createSlider(label, y, default, callback)
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -20, 0, 30)
    text.Position = UDim2.new(0, 10, 0, y)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.new(1,1,1)
    text.Text = label .. ": " .. default
    text.Parent = main

    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(1, -20, 0, 35)
    slider.Position = UDim2.new(0, 10, 0, y + 35)
    slider.BackgroundColor3 = Color3.fromRGB(45,45,60)
    slider.TextColor3 = Color3.new(1,1,1)
    slider.Text = tostring(default)
    slider.PlaceholderText = "1-100"
    slider.Parent = main

    slider.FocusLost:Connect(function()
        local value = math.clamp(tonumber(slider.Text) or default, 1, 100)
        slider.Text = tostring(value)
        text.Text = label .. ": " .. value
        callback(value)
    end)
end

local function updateCharacter(speed, jump)
    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
        humanoid.UseJumpPower = true
        humanoid.JumpPower = jump
    end
end

local speed = 16
local jump = 50

createSlider("Speed", 50, speed, function(v)
    speed = v
    updateCharacter(speed, jump)
end)

createSlider("Jump Height", 130, jump, function(v)
    jump = v
    updateCharacter(speed, jump)
end)

-- Resize support
local resize = Instance.new("UIAspectRatioConstraint")
resize.AspectRatio = 1.25
resize.Parent = main

-- Reapply settings after respawn
player.CharacterAdded:Connect(function()
    task.wait(1)
    updateCharacter(speed, jump)
end)

-- Toggle button
local open = Instance.new("TextButton")
open.Size = UDim2.new(0, 100, 0, 40)
open.Position = UDim2.new(0, 15, 0, 100)
open.Text = "Open VinHub"
open.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
open.TextColor3 = Color3.new(1,1,1)
open.Parent = gui

open.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)