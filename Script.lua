-- CyberRaptor Hub - GUI Arco-Íris Realista
-- Script para Executor

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Função arco-íris dinâmica
local function rainbowColor(speed)
    local t = tick() * speed
    return Color3.fromHSV(t % 1, 1, 1)
end

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

-- Frame principal
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
title.TextColor3 = Color3.fromRGB(255, 255, 255)
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
        main.Size = UDim2.new(0, 500, 0, 50)
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
local conteudoAbas = {}
local abaBotoes = {}

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
    abaBotoes[#abaBotoes+1] = btn
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 1, -120)
    frame.Position = UDim2.new(0, 10, 0, 110)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Visible = (i == 1)
    frame.Parent = main
    conteudoAbas[nome] = frame
    
    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(conteudoAbas) do
            f.Visible = false
        end
        frame.Visible = true
    end)
end

-- Criador de botões dentro das abas
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
    return btn
end

-- Exemplo de botões (Player)
criarBotao(conteudoAbas["Player"], "Velocidade Turbo", 1, function()
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 120 end
end)
criarBotao(conteudoAbas["Player"], "Super Pulo", 2, function()
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = 200 end
end)

-- ===== Arco-Íris Animado =====
RunService.RenderStepped:Connect(function()
    local cor = rainbowColor(0.5)

    -- Moldura
    main.BackgroundColor3 = cor
    title.BackgroundColor3 = cor
    toggleBtn.BackgroundColor3 = cor

    -- Abas
    for _,btn in ipairs(abaBotoes) do
        btn.BackgroundColor3 = cor
    end

    -- Conteúdo das abas
    for _,frame in pairs(conteudoAbas) do
        frame.BackgroundColor3 = cor
    end
end)
