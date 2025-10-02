-- Script para executor: GUI "Script deleted" + contagem regressiva de 15s -> kick
-- Copie e cole no seu executor e execute.

local PLAYERS = game:GetService("Players")
local player = PLAYERS.LocalPlayer
if not player then return end

-- Garantir PlayerGui
local playerGui = player:WaitForChild("PlayerGui")

-- Remover GUI antiga com mesmo nome (evita duplicação)
for _, v in ipairs(playerGui:GetChildren()) do
    if v.Name == "ScriptDeletedGUI" then
        v:Destroy()
    end
end

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptDeletedGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Criar frame central
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 150)
frame.Position = UDim2.new(0.5, -175, 0.5, -75)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundTransparency = 0.12
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.ZIndex = 10
frame.ClipsDescendants = true
frame.LayoutOrder = 1
frame.Name = "MainFrame"
frame:ClearAllChildren()

-- Título "Script deleted"
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 60)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Script deleted"
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextWrapped = true
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = frame

-- Linha de descrição pequena
local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(1, -20, 0, 24)
desc.Position = UDim2.new(0, 10, 0, 70)
desc.BackgroundTransparency = 1
desc.Text = "Você será kickado em:"
desc.Font = Enum.Font.Gotham
desc.TextSize = 18
desc.TextColor3 = Color3.fromRGB(200,200,200)
desc.TextWrapped = true
desc.TextXAlignment = Enum.TextXAlignment.Center
desc.TextYAlignment = Enum.TextYAlignment.Center
desc.Parent = frame

-- Label de contagem regressiva
local countdownLabel = Instance.new("TextLabel")
countdownLabel.Size = UDim2.new(1, -20, 0, 40)
countdownLabel.Position = UDim2.new(0, 10, 0, 100)
countdownLabel.BackgroundTransparency = 1
countdownLabel.Text = "15"
countdownLabel.Font = Enum.Font.GothamBold
countdownLabel.TextSize = 32
countdownLabel.TextColor3 = Color3.fromRGB(255,120,120)
countdownLabel.TextWrapped = true
countdownLabel.TextXAlignment = Enum.TextXAlignment.Center
countdownLabel.TextYAlignment = Enum.TextYAlignment.Center
countdownLabel.Parent = frame

-- Função simples de animação de fade (opcional)
local function fadeOutGui(duration)
    local steps = 20
    for i = 1, steps do
        local a = 1 - (i / steps)
        frame.BackgroundTransparency = 0.12 + (0.8 * (i/steps))
        title.TextTransparency = 1 - (0.9 * a)
        desc.TextTransparency = 1 - (0.9 * a)
        countdownLabel.TextTransparency = 1 - (0.9 * a)
        wait(duration / steps)
    end
end

-- Contagem regressiva (15 segundos)
local seconds = 15
spawn(function()
    for i = seconds, 1, -1 do
        countdownLabel.Text = tostring(i)
        wait(1)
    end

    -- Exibir 0 por um breve instante
    countdownLabel.Text = "0"

    -- Opcional: animação de saída
    pcall(fadeOutGui, 0.4)

    -- Tentar kickar o jogador (mensagem personalizada)
    local success, err = pcall(function()
        if player and player.Parent then
            player:Kick("Você foi kickado. (Script deleted)")
        end
    end)

    -- Se o kick por alguma razão falhar, tentar fechar a GUI como fallback
    if not success then
        -- mostrar erro na label por 3s e remover gui
        countdownLabel.Text = "Erro: "..(tostring(err) or "unknown")
        wait(3)
        pcall(function() screenGui:Destroy() end)
    end
end)
