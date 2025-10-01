# Davizin
-- Painel Avançado - GUI Arrastável
-- Script para Executor

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 250, 0, 360)
main.Position = UDim2.new(0.3, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "Painel Avançado"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = main

-- Criador de Botões
local function criarBotao(texto, ordem, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, 40 + ((ordem-1) * 40))
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = main
    btn.MouseButton1Click:Connect(callback)
end

-- Funções
criarBotao("Velocidade Turbo", 1, function()
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 120 end
end)

criarBotao("Super Pulo", 2, function()
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = 200 end
end)

criarBotao("God Mode", 3, function()
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

criarBotao("AutoFarm Coins", 5, function()
    -- Exemplo simples (pode ser adaptado p/ cada jogo)
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

criarBotao("Resetar Player", 6, function()
    player.Character:BreakJoints()
end)

criarBotao("Fechar GUI", 7, function()
    gui:Destroy()
end)
