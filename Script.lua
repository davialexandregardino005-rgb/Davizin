-- CyberRaptor Hub - GUI com 5 Abas
-- Script para Executor

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

-- Frame principal grande e quadrado
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 500, 0, 500)
main.Position = UDim2.new(0.3, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.Text = "⚡ CyberRaptor Hub ⚡"
title.TextColor3 = Color3.fromRGB(0, 255, 100)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.Parent = main

-- Botão toggle abrir/fechar
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(1, -50, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
toggleBtn.Text = "X"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 22
toggleBtn.Parent = main

local aberto = true
toggleBtn.MouseButton1Click:Connect(function()
    if aberto then
        main.Size = UDim2.new(0, 500, 0, 50) -- só barra do título
        toggleBtn.Text = "+"
        aberto = false
    else
        main.Size = UDim2.new(0, 500, 0, 500)
        toggleBtn.Text = "X"
        aberto = true
    end
end)

-- Abas
local abas = {"Player", "Teleport", "Combat", "Farm", "Visual"}
local abaButtons = {}
local conteudoAbas = {}

for i, nome in ipairs(abas) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 40)
    btn.Position = UDim2.new(0, 10 + (i-1)*95, 0, 60)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = nome
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = main
    abaButtons[nome] = btn
    
    -- Conteúdo de cada aba
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 1, -120)
    frame.Position = UDim2.new(0, 10, 0, 110)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Visible = (i == 1) -- só primeira aba visível
    frame.Parent = main
    conteudoAbas[nome] = frame
    
    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(conteudoAbas) do
            f.Visible = false
        end
        frame.Visible = true
    end)
end

-- Função para criar botões dentro das abas
local function criarBotao(frame, texto, ordem, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, 10 + (ordem-1)*50)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
end

-- ===== FUNÇÕES DE EXEMPLO =====
-- Aba Player
criarBotao(conteudoAbas["Player"], "Velocidade Turbo", 1, function()
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 120 end
end)
criarBotao(conteudoAbas["Player"], "Super Pulo", 2, function()
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = 200 end
end)
criarBotao(conteudoAbas["Player"], "GodMode", 3, function()
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Health = math.huge
        hum:GetPropertyChangedSignal("Health"):Connect(function()
            hum.Health = math.huge
        end)
    end
end)

-- Aba Teleport
criarBotao(conteudoAbas["Teleport"], "Teleport Spawn", 1, function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(0, 50, 0)
end)

-- Aba Combat
criarBotao(conteudoAbas["Combat"], "Resetar Player", 1, function()
    player.Character:BreakJoints()
end)

-- Aba Farm
criarBotao(conteudoAbas["Farm"], "AutoFarm Coins", 1, function()
    while true do
        task.wait(1)
        pcall(function()
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "Coin" and v:IsA("Part") then
                    hrp.CFrame = v.CFrame
                    task.wait(0.2)
                end
            end
        end)
    end
end)

-- Aba Visual
criarBotao(conteudoAbas["Visual"], "Toggle GUI Glow", 1, function()
    -- Exemplo simples de efeito visual
    main.BackgroundColor3 = (main.BackgroundColor3 == Color3.fromRGB(20,20,20)) and Color3.fromRGB(0,100,0) or Color3.fromRGB(20,20,20)
end)
