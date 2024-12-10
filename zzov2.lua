-- JumpPower Menu Script
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Slider = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local SliderInner = Instance.new("Frame")
local UICorner_3 = Instance.new("UICorner")
local ValueLabel = Instance.new("TextLabel")

-- Properties
ScreenGui.Name = "JumpPowerMenu"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.2, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Draggable = true
MainFrame.Active = true

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 10)

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Font = Enum.Font.GothamBold
Title.Text = "JumpPower Control"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

Slider.Name = "Slider"
Slider.Parent = MainFrame
Slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Slider.Position = UDim2.new(0.1, 0, 0.5, 0)
Slider.Size = UDim2.new(0.8, 0, 0, 6)

SliderButton.Name = "SliderButton"
SliderButton.Parent = Slider
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.Position = UDim2.new(0.5, -8, 0.5, -8)
SliderButton.Size = UDim2.new(0, 16, 0, 16)
SliderButton.Text = ""

UICorner_2.Parent = SliderButton
UICorner_2.CornerRadius = UDim.new(1, 0)

SliderInner.Name = "SliderInner"
SliderInner.Parent = Slider
SliderInner.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
SliderInner.Size = UDim2.new(0.5, 0, 1, 0)

UICorner_3.Parent = Slider
UICorner_3.CornerRadius = UDim.new(1, 0)

ValueLabel.Name = "ValueLabel"
ValueLabel.Parent = MainFrame
ValueLabel.BackgroundTransparency = 1
ValueLabel.Position = UDim2.new(0, 0, 0.8, 0)
ValueLabel.Size = UDim2.new(1, 0, 0, 20)
ValueLabel.Font = Enum.Font.Gotham
ValueLabel.Text = "JumpPower: 50"
ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ValueLabel.TextSize = 12

-- Rainbow Effect
local function updateRainbow()
    while true do
        for i = 0, 1, 0.001 do
            MainFrame.BorderColor3 = Color3.fromHSV(i, 1, 1)
            Title.TextColor3 = Color3.fromHSV(i, 1, 1)
            wait()
        end
    end
end
coroutine.wrap(updateRainbow)()

-- Slider Functionality
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local dragging = false
local minJumpPower = 24
local maxJumpPower = 350
local currentJumpPower = minJumpPower -- Store current JumpPower

-- Function to update JumpPower
local function updateJumpPower(relativeX)
    currentJumpPower = minJumpPower + (maxJumpPower - minJumpPower) * relativeX
    humanoid.JumpPower = currentJumpPower
    ValueLabel.Text = string.format("JumpPower: %.0f", currentJumpPower)
end

SliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = Slider.AbsolutePosition
        local sliderSize = Slider.AbsoluteSize
        
        local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        SliderButton.Position = UDim2.new(relativeX, -8, 0.5, -8)
        SliderInner.Size = UDim2.new(relativeX, 0, 1, 0)
        
        updateJumpPower(relativeX)
    end
    -- Always set the stored JumpPower
    if humanoid then
        humanoid.JumpPower = currentJumpPower
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    -- Set the stored JumpPower when character respawns
    humanoid.JumpPower = currentJumpPower
end)

-- Additional loop to ensure JumpPower stays constant
RunService.Heartbeat:Connect(function()
    if humanoid then
        humanoid.JumpPower = currentJumpPower
    end
end)

