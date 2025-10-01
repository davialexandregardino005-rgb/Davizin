-- CyberRaptor Hub - GUI Avançada
-- Script para Executor

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Criando ScreenGui
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

-- Frame principal (grande por padrão)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 400, 0, 500)
main.Position = UDim2.new(0.3, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.Text = "⚡ CyberRaptor Hub ⚡"
title.TextColor3 = Color3.fromRGB(0, 255, 100)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.Parent = main

-- Botão Fechar/Abrir
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(1, -40, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
toggleBtn.Text = "X"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 18
toggleBtn.Parent = main

-- Variável para toggle
local aberto = true

toggleBtn.MouseButton1Click:Connect(function()
    if aberto then
        main.Size = UDim2.new(0, 400, 0, 40) -- fecha, só barra do título
        toggleBtn.Text = "+"
        aberto = false
    else
        main.Size = UDim2.new(0, 400, 0, 500) -- abre de novo
        toggleBtn.Text = "X"
        aberto = true
    end
end)

-- Criador de botões
local function criarBotao(texto, ordem, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, 50 + ((ordem-1) * 40))
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = main
    btn.MouseButton1Click:Connect(callback)
end

-- Funções de exemplo
criarBotao("Velocidade Turbo", 1, function()
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 120 end
end)

criarBotao("Super Pulo", 2, function()
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = 200 end
end)

criarBotao("GodMode", 3, function()
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Health = math.huge
        hum:GetPropertyChangedSignal("Health"):Connect(function()
            hum.Health = math.huge
        end)
    end
end)

criarBotao("Teleport Spawn", 4, function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(0, 50, 0)
end)

criarBotao("Resetar Player", 5, function()
    player.Character:BreakJoints()
end)

criarBotao("Fechar GUI", 6, function()
    gui:Destroy()
end)
