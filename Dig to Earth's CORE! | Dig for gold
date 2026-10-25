
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "DiggingForGoldGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "Digging For Gold"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Parent = frame

local dragging = false
local dragStart
local startPosition

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "MenuScroll"
scrollingFrame.Position = UDim2.new(0, 0, 0, 40)
scrollingFrame.Size = UDim2.new(1, 0, 0, 210)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 330)
scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollingFrame.Active = true
scrollingFrame.Parent = frame

local antiAFK = false
local farming = false
local money10X = false
local winsFarming = false
local winsToken = 0

local function createButton(text, position, size, parent)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 260, 0, 35)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    button.BorderSizePixel = 0
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.Text = text
    button.Parent = parent
    return button
end

local farmButton = createButton(
    "Farm Money/Gems: OFF",
    UDim2.new(0, 20, 0, 5),
    nil,
    scrollingFrame
)

farmButton.MouseButton1Click:Connect(function()
    farming = not farming
    farmButton.Text = "Farm Money/Gems: " .. (farming and "ON" or "OFF")
    farmButton.BackgroundColor3 = farming
        and Color3.fromRGB(35, 140, 70)
        or Color3.fromRGB(65, 65, 65)

    if farming then
        task.spawn(function()
            while farming and gui.Parent do
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")

                if remotes then
                    local digEvent = remotes:FindFirstChild("DigEvent")
                    local gemEvent = remotes:FindFirstChild("GemEvent")

                    if digEvent then
                        digEvent:FireServer("hello")
                    end

                    if gemEvent then
                        gemEvent:FireServer(10, "bye")
                    end
                end

                task.wait(1)
            end
        end)
    end
end)

local moneyButton = createButton(
    "10X Money: OFF",
    UDim2.new(0, 20, 0, 50),
    nil,
    scrollingFrame
)

moneyButton.MouseButton1Click:Connect(function()
    money10X = not money10X
    moneyButton.Text = "10X Money: " .. (money10X and "ON" or "OFF")
    moneyButton.BackgroundColor3 = money10X
        and Color3.fromRGB(35, 140, 70)
        or Color3.fromRGB(65, 65, 65)

    if money10X then
        task.spawn(function()
            while money10X and gui.Parent do
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local spinEvent = remotes and remotes:FindFirstChild("SpinPrizeEvent")

                if spinEvent then
                    spinEvent:FireServer(8)
                end

                task.wait(1)
            end
        end)
    end
end)

local petButton = createButton(
    "Give 50X Pet",
    UDim2.new(0, 20, 0, 95),
    nil,
    scrollingFrame
)

petButton.MouseButton1Click:Connect(function()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local spinEvent = remotes and remotes:FindFirstChild("SpinPrizeEvent")

    if spinEvent then
        spinEvent:FireServer(4)
    end
end)

local worldBox = Instance.new("TextBox")
worldBox.Size = UDim2.new(0, 260, 0, 35)
worldBox.Position = UDim2.new(0, 20, 0, 140)
worldBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
worldBox.BorderSizePixel = 0
worldBox.TextColor3 = Color3.new(1, 1, 1)
worldBox.PlaceholderText = "Enter world number (1-6)"
worldBox.Text = "1"
worldBox.TextScaled = true
worldBox.ClearTextOnFocus = false
worldBox.Parent = scrollingFrame

local winsButton = createButton(
    "Auto Farm Wins: OFF",
    UDim2.new(0, 20, 0, 185),
    nil,
    scrollingFrame
)

local destinations = {
    [1] = Vector3.new(-40, -391, 9),
    [2] = Vector3.new(-18, -391, -1008),
    [3] = Vector3.new(44, -389, -2000),
    [4] = Vector3.new(-15, -392, -2941),
    [5] = Vector3.new(1, -392, -4027),
    [6] = Vector3.new(43, -387, -5020)
}

winsButton.MouseButton1Click:Connect(function()
    if not winsFarming then
        local worldNumber = tonumber(worldBox.Text)

        if not destinations[worldNumber] then
            winsButton.Text = "Invalid World (1-6)"

            task.delay(1.5, function()
                if winsButton.Parent then
                    winsButton.Text = "Auto Farm Wins: OFF"
                end
            end)

            return
        end
    end

    winsFarming = not winsFarming
    winsToken += 1

    local currentToken = winsToken
    winsButton.Text = "Auto Farm Wins: " .. (winsFarming and "ON" or "OFF")
    winsButton.BackgroundColor3 = winsFarming
        and Color3.fromRGB(35, 140, 70)
        or Color3.fromRGB(65, 65, 65)

    if winsFarming then
        local destination = destinations[tonumber(worldBox.Text)]

        task.spawn(function()
            while winsFarming and currentToken == winsToken and gui.Parent do
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")

                if root then
                    root.CFrame = CFrame.new(destination)
                end

                task.wait(0.5)
            end
        end)
    end
end)

local godBunnyButton = createButton(
    "Equip God Bunny",
    UDim2.new(0, 20, 0, 230),
    nil,
    scrollingFrame
)

godBunnyButton.MouseButton1Click:Connect(function()
    local petRemotes = ReplicatedStorage:FindFirstChild("PetRemotes")
    local equipPet = petRemotes and petRemotes:FindFirstChild("EquipPet")

    if not equipPet then
        godBunnyButton.Text = "Remote Not Found"

        task.delay(2, function()
            if godBunnyButton.Parent then
                godBunnyButton.Text = "Equip God Bunny"
            end
        end)

        return
    end

    godBunnyButton.Active = false
    godBunnyButton.Text = "Equipping..."

    task.spawn(function()
        for i = 1, 3 do
            local success, result = pcall(function()
                return equipPet:InvokeServer(
                    "God Bunny",
                    "1792721216_4316"
                )
            end)

            if not success then
                warn("God Bunny equip call failed:", result)
            end

            if i < 3 then
                task.wait(0.2)
            end
        end

        if godBunnyButton.Parent then
            godBunnyButton.Text = "Equip God Bunny"
            godBunnyButton.Active = true
        end
    end)
end)

local antiAFKButton = createButton(
    "Anti-AFK: OFF",
    UDim2.new(1, -95, 1, -30),
    UDim2.new(0, 90, 0, 25),
    frame
)

antiAFKButton.MouseButton1Click:Connect(function()
    antiAFK = not antiAFK
    antiAFKButton.Text = antiAFK and "Anti-AFK: ON" or "Anti-AFK: OFF"
    antiAFKButton.BackgroundColor3 = antiAFK
        and Color3.fromRGB(35, 140, 70)
        or Color3.fromRGB(65, 65, 65)
end)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 25)
closeButton.Position = UDim2.new(0.5, -17, 1, 8)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeButton.BorderSizePixel = 0
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    farming = false
    money10X = false
    winsFarming = false
    winsToken += 1
    gui:Destroy()
end)
