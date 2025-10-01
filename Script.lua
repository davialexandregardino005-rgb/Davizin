-- CyberRaptor GUI (com funções reais) - KRNL
-- Basta executar no KRNL

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Helper HSV -> RGB
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

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CyberRaptor"
screenGui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Size = UDim2.new(0, 640, 0, 640)
main.Position = UDim2.new(0.5, -320, 0.5, -320) -- centro da tela
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Barra de título
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 48)
titleBar.BackgroundTransparency = 1
titleBar.Parent = main

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🌌 CyberRaptor GUI"
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextSize = 22
titleLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 44, 0, 28)
closeBtn.Position = UDim2.new(1, -56, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(240,240,240)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Drag
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

-- Tabs
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(0, 140, 1, -60)
tabsFrame.Position = UDim2.new(0, 12, 0, 52)
tabsFrame.BackgroundTransparency = 1
tabsFrame.Parent = main
local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = tabsFrame

local pages, tabButtons = {}, {}
local tabNames = {"Teleport", "Speed", "Fly", "ESP", "Utils"}

for i,name in pairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
    btn.Text = name
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
for i,btn in pairs(tabButtons) do btn.MouseButton1Click:Connect(function() showPage(i) end) end

-- ============ FUNÇÕES ============

-- Teleport Tab
do
    local page = pages[1]
    local tpBtn = Instance.new("TextButton", page)
    tpBtn.Size = UDim2.new(0, 200, 0, 40)
    tpBtn.Position = UDim2.new(0, 10, 0, 10)
    tpBtn.Text = "Teleport to Random Player"
    tpBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    tpBtn.TextColor3 = Color3.fromRGB(230,230,230)
    Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

    tpBtn.MouseButton1Click:Connect(function()
        local players = Players:GetPlayers()
        if #players > 1 then
            local target = players[math.random(1,#players)]
            if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            end
        end
    end)
end

-- Speed Tab
do
    local page = pages[2]
    local speed = 16
    local toggle = Instance.new("TextButton", page)
    toggle.Size = UDim2.new(0, 200, 0, 40)
    toggle.Position = UDim2.new(0, 10, 0, 10)
    toggle.Text = "Toggle Speed Boost"
    toggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
    toggle.TextColor3 = Color3.fromRGB(230,230,230)
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

    local active = false
    toggle.MouseButton1Click:Connect(function()
        active = not active
        speed = active and 60 or 16
        player.Character.Humanoid.WalkSpeed = speed
        toggle.BackgroundColor3 = active and Color3.fromRGB(70,140,70) or Color3.fromRGB(45,45,45)
    end)
end

-- Fly Tab
do
    local page = pages[3]
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 10)
    btn.Text = "Toggle Fly"
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.TextColor3 = Color3.fromRGB(230,230,230)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local flying = false
    local bodyGyro, bodyVel
    btn.MouseButton1Click:Connect(function()
        flying = not flying
        if flying then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            bodyGyro = Instance.new("BodyGyro", hrp)
            bodyVel = Instance.new("BodyVelocity", hrp)
            bodyGyro.P = 9e4 bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
            bodyVel.Velocity = Vector3.new(0,0,0)
            bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
            RunService.RenderStepped:Connect(function()
                if flying then
                    bodyGyro.CFrame = workspace.CurrentCamera.CFrame
                    local vel = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + workspace.CurrentCamera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - workspace.CurrentCamera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - workspace.CurrentCamera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + workspace.CurrentCamera.CFrame.RightVector end
                    bodyVel.Velocity = vel * 50
                end
            end)
        else
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVel then bodyVel:Destroy() end
        end
        btn.BackgroundColor3 = flying and Color3.fromRGB(70,140,70) or Color3.fromRGB(45,45,45)
    end)
end

-- ESP Tab
do
    local page = pages[4]
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 10)
    btn.Text = "Toggle ESP"
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.TextColor3 = Color3.fromRGB(230,230,230)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local espEnabled = false
    btn.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        for _,v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                if espEnabled then
                    local bill = Instance.new("BillboardGui", v.Character.Head)
                    bill.Name = "ESP"
                    bill.Size = UDim2.new(0,100,0,50)
                    bill.AlwaysOnTop = true
                    local label = Instance.new("TextLabel", bill)
                    label.Size = UDim2.new(1,0,1,0)
                    label.Text = v.Name
                    label.TextColor3 = Color3.fromRGB(255,0,0)
                    label.BackgroundTransparency = 1
                else
                    if v.Character.Head:FindFirstChild("ESP") then
                        v.Character.Head.ESP:Destroy()
                    end
                end
            end
        end
        btn.BackgroundColor3 = espEnabled and Color3.fromRGB(70,140,70) or Color3.fromRGB(45,45,45)
    end)
end

-- Utils Tab
do
    local page = pages[5]
    local reBtn = Instance.new("TextButton", page)
    reBtn.Size = UDim2.new(0, 200, 0, 40)
    reBtn.Position = UDim2.new(0, 10, 0, 10)
    reBtn.Text = "Respawn"
    reBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    reBtn.TextColor3 = Color3.fromRGB(230,230,230)
    Instance.new("UICorner", reBtn).CornerRadius = UDim.new(0, 6)

    reBtn.MouseButton1Click:Connect(function()
        player.Character:BreakJoints()
    end)
end

-- Animação aparecer
main.Size = UDim2.new(0, 60, 0, 60)
main.BackgroundTransparency = 1
local appearTween = TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,640,0,640), BackgroundTransparency = 0})
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
