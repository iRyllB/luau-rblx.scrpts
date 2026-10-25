-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Variables
local LocalPlayer = Players.LocalPlayer

-- Clean up existing UI instance
local env = typeof(getgenv) == "function" and getgenv() or _G
local oldUI = env.__PepeFakerUI
if oldUI then
    pcall(oldUI.Destroy, oldUI)
end

-- Configuration & Theme
local col = {
    bg           = Color3.fromRGB(15, 15, 15),
    panel        = Color3.fromRGB(28, 28, 28),
    button       = Color3.fromRGB(50, 50, 50),
    buttonActive = Color3.fromRGB(80, 80, 80),
    text         = Color3.fromRGB(255, 255, 255),
    dimText      = Color3.fromRGB(160, 160, 160),
    accent       = Color3.fromRGB(255, 65, 65),
    green        = Color3.fromRGB(100, 255, 140)
}

local img = {
    home   = "rbxassetid://70573525526341",
    faker  = "rbxassetid://117975333704340",
    logger = "rbxassetid://109982256018444",
    passes = "rbxassetid://84787327728949",
    copy   = "rbxassetid://101160281432561"
}

-- Interface Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PepeVaronaFakerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = (typeof(gethui) == "function" and gethui()) 
        or game:GetService("CoreGui") 
        or LocalPlayer:WaitForChild("PlayerGui")
end)

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleFakerBtn"
ToggleButton.Size = UDim2.fromOffset(150, 40)
ToggleButton.Position = UDim2.fromScale(0.1, 0.2)
ToggleButton.BackgroundColor3 = col.panel
ToggleButton.Text = "Fake Buy gamepass"
ToggleButton.TextColor3 = col.text
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 16
ToggleButton.Parent = ScreenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = ToggleButton

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = col.button
btnStroke.Thickness = 1
btnStroke.Parent = ToggleButton

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "SquareMain"
MainFrame.Size = UDim2.fromOffset(400, 400)
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = col.bg
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = col.panel
mainStroke.Thickness = 2
mainStroke.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = col.panel
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Position = UDim2.fromOffset(15, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "PRODUCT FAKER V2 : @Pepe-m2f1c"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.TextColor3 = col.text
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Bottom Bar Navigation
local BottomBar = Instance.new("Frame")
BottomBar.Size = UDim2.new(1, 0, 0, 50)
BottomBar.Position = UDim2.new(0, 0, 1, -50)
BottomBar.BackgroundColor3 = col.panel
BottomBar.BorderSizePixel = 0
BottomBar.Parent = MainFrame

local bottomCorner = Instance.new("UICorner")
bottomCorner.CornerRadius = UDim.new(0, 12)
bottomCorner.Parent = BottomBar

local NavLayout = Instance.new("UIListLayout")
NavLayout.FillDirection = Enum.FillDirection.Horizontal
NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLayout.VerticalAlignment = Enum.VerticalAlignment.Center
NavLayout.Padding = UDim.new(0, 15)
NavLayout.Parent = BottomBar

-- Tab Container & Controller
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 1, -115)
TabContainer.Position = UDim2.fromOffset(10, 55)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local tabScreens = {}
local tabButtons = {}

local function createTab(name, iconId)
    local screen = Instance.new("ScrollingFrame")
    screen.Size = UDim2.fromScale(1, 1)
    screen.BackgroundTransparency = 1
    screen.BorderSizePixel = 0
    screen.ScrollBarThickness = 4
    screen.CanvasSize = UDim2.new(0, 0, 0, 0)
    screen.AutomaticCanvasSize = Enum.AutomaticSize.Y
    screen.Visible = false
    screen.Parent = TabContainer

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = screen

    local navBtn = Instance.new("ImageButton")
    navBtn.Size = UDim2.fromOffset(36, 36)
    navBtn.BackgroundColor3 = col.button
    navBtn.Image = iconId
    navBtn.Parent = BottomBar

    local navCorner = Instance.new("UICorner")
    navCorner.CornerRadius = UDim.new(0, 6)
    navCorner.Parent = navBtn

    tabScreens[name] = screen
    tabButtons[name] = navBtn

    return screen
end

local Tab1_Credits = createTab("Credits", img.home)
local Tab2_Faker   = createTab("Faker", img.faker)
local Tab3_Logger  = createTab("Logger", img.logger)
local Tab4_Scanner = createTab("Scanner", img.passes)

local function switchTab(targetName)
    for name, screen in pairs(tabScreens) do
        screen.Visible = (name == targetName)
        tabButtons[name].BackgroundColor3 = (name == targetName) and col.buttonActive or col.button
    end
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

switchTab("Credits")

-- Dragging Handler
local function handleDrag(uiElement, handle)
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = uiElement.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    uiElement.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            uiElement.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

handleDrag(ToggleButton, ToggleButton)
handleDrag(MainFrame, TopBar)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Tab 1: Credits Content
local function createCreditLabel(txt, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 30)
    lbl.BackgroundTransparency = 1
    lbl.Text = txt
    lbl.TextColor3 = color or col.text
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 16
    lbl.Parent = Tab1_Credits
end

createCreditLabel("Fakes gamepass/product purchases.", col.dimText)
createCreditLabel("Created By: PepeVarona279", col.accent)
createCreditLabel("YouTube: @Pepe-m2f1c", Color3.fromRGB(255, 80, 80))
createCreditLabel("Discord: ???", Color3.fromRGB(80, 150, 255))
createCreditLabel("Website: RobloxExploit.org", Color3.fromRGB(240, 240, 100))

-- Tab 2: Faker Content
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, 0, 0, 40)
InputBox.BackgroundColor3 = col.panel
InputBox.PlaceholderText = "Paste Gamepass/Product ID here"
InputBox.Text = ""
InputBox.TextColor3 = col.text
InputBox.Font = Enum.Font.Code
InputBox.TextSize = 14
InputBox.Parent = Tab2_Faker

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = InputBox

local FireFakeBtn = Instance.new("TextButton")
FireFakeBtn.Size = UDim2.new(1, 0, 0, 40)
FireFakeBtn.BackgroundColor3 = col.buttonActive
FireFakeBtn.Text = "Fake it!"
FireFakeBtn.TextColor3 = col.text
FireFakeBtn.Font = Enum.Font.SourceSansBold
FireFakeBtn.TextSize = 16
FireFakeBtn.Parent = Tab2_Faker

local fireCorner = Instance.new("UICorner")
fireCorner.CornerRadius = UDim.new(0, 6)
fireCorner.Parent = FireFakeBtn

local function fireFakePurchase(targetId)
    if not targetId then return end
    
    pcall(function()
        MarketplaceService:SignalPromptGamePassPurchaseFinished(LocalPlayer, targetId, true)
    end)
    
    pcall(function()
        MarketplaceService:SignalPromptProductPurchaseFinished(LocalPlayer.UserId, targetId, true)
    end)
end

FireFakeBtn.MouseButton1Click:Connect(function()
    local rawId = tonumber((InputBox.Text:gsub("%s", "")))
    if rawId then
        fireFakePurchase(rawId)
    end
end)

-- Tab 3: Logger Content
local function logMessage(msg)
    local txtLabel = Instance.new("TextLabel")
    txtLabel.Size = UDim2.new(1, 0, 0, 25)
    txtLabel.BackgroundTransparency = 1
    txtLabel.Text = " [LOG] " .. msg
    txtLabel.TextColor3 = col.green
    txtLabel.Font = Enum.Font.SourceSansItalic
    txtLabel.TextSize = 14
    txtLabel.TextXAlignment = Enum.TextXAlignment.Left
    txtLabel.Parent = Tab3_Logger
end

pcall(function()
    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, assetId, isPurchased)
        if player == LocalPlayer and isPurchased then
            logMessage("Successfully Faked Gamepass ID: " .. tostring(assetId))
        end
    end)
end)

pcall(function()
    MarketplaceService.PromptProductPurchaseFinished:Connect(function(userId, assetId, isPurchased)
        if userId == LocalPlayer.UserId and isPurchased then
            logMessage("Successfully Faked Product ID: " .. tostring(assetId))
        end
    end)
end)

-- Tab 4: Scanner Content & Operations
local function appendScannedAsset(id, name, price, iconUrl)
    local rowFrame = Instance.new("Frame")
    rowFrame.Size = UDim2.new(1, -5, 0, 60)
    rowFrame.BackgroundColor3 = col.panel
    rowFrame.Parent = Tab4_Scanner

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 6)
    rowCorner.Parent = rowFrame

    local iconImg = Instance.new("ImageLabel")
    iconImg.Size = UDim2.fromOffset(46, 46)
    iconImg.Position = UDim2.fromOffset(7, 7)
    iconImg.BackgroundColor3 = col.button
    iconImg.Image = iconUrl or ""
    iconImg.Parent = rowFrame

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 4)
    iconCorner.Parent = iconImg

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0.5, 0, 0, 20)
    titleLbl.Position = UDim2.fromOffset(60, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = name
    titleLbl.Font = Enum.Font.SourceSansBold
    titleLbl.TextColor3 = col.text
    titleLbl.TextSize = 15
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = rowFrame

    local costLbl = Instance.new("TextLabel")
    costLbl.Size = UDim2.new(0.5, 0, 0, 15)
    costLbl.Position = UDim2.fromOffset(60, 30)
    costLbl.BackgroundTransparency = 1
    costLbl.Text = price and ("R$ " .. tostring(price)) or "Offsale"
    costLbl.Font = Enum.Font.SourceSans
    costLbl.TextColor3 = col.green
    costLbl.TextSize = 13
    costLbl.TextXAlignment = Enum.TextXAlignment.Left
    costLbl.Parent = rowFrame

    local actionBtn = Instance.new("ImageButton")
    actionBtn.Size = UDim2.fromOffset(30, 30)
    actionBtn.Position = UDim2.new(1, -40, 0.5, -15)
    actionBtn.BackgroundColor3 = col.button
    actionBtn.Image = img.copy
    actionBtn.Parent = rowFrame

    local actionCorner = Instance.new("UICorner")
    actionCorner.CornerRadius = UDim.new(0, 6)
    actionCorner.Parent = actionBtn

    actionBtn.MouseButton1Click:Connect(function()
        InputBox.Text = tostring(id)
        switchTab("Faker")
    end)
end

task.spawn(function()
    -- Scan Developer Products
    local productOk, productPage = pcall(function()
        return MarketplaceService:GetDeveloperProductsAsync():GetCurrentPage()
    end)
    
    if productOk and type(productPage) == "table" then
        for _, item in ipairs(productPage) do
            local assetId = item.ProductId or item.DeveloperProductId
            local iconId = item.IconImageAssetId and ("rbxassetid://" .. item.IconImageAssetId) or ""
            appendScannedAsset(assetId, item.Name or "Developer Product", item.PriceInRobux, iconId)
        end
    end

    -- Scan Gamepasses via HTTP
    local fallbackUrl = "roproxy.com" .. tostring(game.GameId) .. "/game-passes?limit=100&sortOrder=Asc"
    local ok, body = pcall(function()
        return game:HttpGet(fallbackUrl)
    end)

    if ok and body then
        local success, data = pcall(function()
            return HttpService:JSONDecode(body)
        end)
        
        if success and data and data.data then
            for _, pass in ipairs(data.data) do
                local thumb = "rbxthumb://type=GamePass&id=" .. tostring(pass.id) .. "&w=150&h=150"
                appendScannedAsset(pass.id, pass.name or "Gamepass", pass.price, thumb)
            end
        end
    end
end)

-- Environment Reference Registration
env.__PepeFakerUI = ScreenGui