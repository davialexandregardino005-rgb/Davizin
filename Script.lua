-- CyberRaptor GUI (versão adaptada para KRNL)
-- Basta executar no seu executor (KRNL) que a GUI vai aparecer.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Helper: HSV -> RGB
local function HSV(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q end
    return Color3.new(r, g, b)
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CyberRaptor"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui") -- <- no executor, use CoreGui

-- Main window
local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Size = UDim2.new(0, 640, 0, 640)
main.Position = UDim2.new(0.5, -320, 0.5, -320)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui

-- Cantos arredondados
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 12)
uicorner.Parent = main

-- Sombra
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5052993270"
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(20, 20, 200, 200)
shadow.Parent = main
shadow.ZIndex = 0

-- Conteúdo
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -24, 1, -64)
content.Position = UDim2.new(0, 12, 0, 52)
content.BackgroundTransparency = 1
content.Parent = main
content.ZIndex = 2

-- Barra de título
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 48)
titleBar.BackgroundTransparency = 1
titleBar.Parent = main

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "CyberRaptor"
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextSize = 22
titleLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Botão minimizar
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 44, 0, 28)
toggleBtn.Position = UDim2.new(1, -56, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.Text = "—"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
toggleBtn.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)
toggleBtn.Parent = titleBar

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 44, 0, 28)
closeBtn.Position = UDim2.new(1, -100, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(240,240,240)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.Parent = titleBar

-- Arrastar GUI
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
    end
end)

-- Funções de minimizar/fechar
local minimized, originalSize = false, main.Size
local function minimize()
    minimized = true
    TweenService:Create(main, TweenInfo.new(0.25), {Size = UDim2.new(0, 220, 0, 40)}):Play()
    content.Visible = false
end
local function restore()
    minimized = false
    TweenService:Create(main, TweenInfo.new(0.25), {Size = originalSize}):Play()
    content.Visible = true
end
toggleBtn.MouseButton1Click:Connect(function()
    if minimized then restore() else minimize() end
end)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tabs
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(0, 140, 1, -80)
tabsFrame.Position = UDim2.new(0, 12, 0, 52)
tabsFrame.BackgroundTransparency = 1
tabsFrame.Parent = main
local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = tabsFrame

local pages, tabButtons = {}, {}
for i=1,5 do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
    btn.Text = "Tab "..i
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.Parent = tabsFrame
    
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -172, 1, -80)
    page.Position = UDim2.new(0, 164, 0, 52)
    page.BackgroundTransparency = 1
    page.Parent = main
    page.Visible = (i==1)

    pages[i], tabButtons[i] = page, btn
end

local function showPage(index)
    for i,p in pairs(pages) do p.Visible = (i == index) end
    for i,b in pairs(tabButtons) do
        b.BackgroundColor3 = (i==index) and Color3.fromRGB(60,60,60) or Color3.fromRGB(28,28,28)
    end
end
for i,btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function() showPage(i) end)
end

-- Exemplo de botão dentro das páginas
for i,page in pairs(pages) do
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 28)
    title.Text = "Page "..i
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(230,230,230)
    title.BackgroundTransparency = 1
    title.Parent = page
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 180, 0, 36)
    toggle.Position = UDim2.new(0, 0, 0, 40)
    toggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
    toggle.Text = "Toggle Feature"
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 16
    toggle.TextColor3 = Color3.fromRGB(230,230,230)
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)
    toggle.Parent = page
    
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(70,140,70) or Color3.fromRGB(45,45,45)
        print("Page", i, "feature state:", state)
    end)
end

-- Animação de aparecer
main.Size = UDim2.new(0, 60, 0, 60)
main.BackgroundTransparency = 1
local appearTween = TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize, BackgroundTransparency = 0})
appearTween:Play()

-- Barra arco-íris
local accent = Instance.new("Frame")
accent.Size = UDim2.new(1, 0, 0, 6)
accent.Position = UDim2.new(0, 0, 0, 48)
accent.BorderSizePixel = 0
accent.Parent = main
Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 6)

local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.08) % 1
    accent.BackgroundColor3 = HSV(hue, 0.9, 0.95)
end)
