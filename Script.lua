-- CuberRaptor Hub (UI) - script para executor / LocalScript
-- Cria uma ScreenGui, janela arrastável segurando o título, 5 abas e animações

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove uma GUI anterior com mesmo nome (evita duplicatas)
for _, v in pairs(playerGui:GetChildren()) do
	if v.Name == "CuberRaptorHub" then
		v:Destroy()
	end
end

-- Helper: cria um objeto simples com propriedades
local function new(classname, props)
	local obj = Instance.new(classname)
	if props then
		for k,v in pairs(props) do
			if k == "Parent" then
				obj.Parent = v
			else
				obj[k] = v
			end
		end
	end
	return obj
end

-- Root ScreenGui
local screenGui = new("ScreenGui", {
	Name = "CuberRaptorHub",
	DisplayOrder = 1000,
	Parent = playerGui,
	ResetOnSpawn = false,
})

-- Main frame (janela)
local main = new("Frame", {
	Name = "Main",
	Parent = screenGui,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 820, 0, 520),
	BackgroundColor3 = Color3.fromRGB(24, 24, 24),
	BorderSizePixel = 0,
})

-- Sombra sutil
local shadow = new("Frame", {
	Name = "Shadow",
	Parent = main,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 4),
	Size = UDim2.new(1, 10, 1, 10),
	BackgroundColor3 = Color3.new(0,0,0),
	BackgroundTransparency = 0.85,
	BorderSizePixel = 0,
	ZIndex = 0,
})
new("UICorner", {Parent = shadow, CornerRadius = UDim.new(0, 14)})

-- Rounded corners for main
new("UICorner", {Parent = main, CornerRadius = UDim.new(0, 12)})

-- Title bar (arrastável)
local titleBar = new("Frame", {
	Name = "TitleBar",
	Parent = main,
	Size = UDim2.new(1, 0, 0, 46),
	BackgroundTransparency = 1,
	ZIndex = 2,
})

local titleBg = new("Frame", {
	Name = "TitleBg",
	Parent = titleBar,
	AnchorPoint = Vector2.new(0,0),
	Position = UDim2.new(0,0,0,0),
	Size = UDim2.new(1,0,1,0),
	BackgroundColor3 = Color3.fromRGB(17,17,17),
	BorderSizePixel = 0,
	ZIndex = 1,
})
new("UICorner", {Parent = titleBg, CornerRadius = UDim.new(0, 12)})

local titleLabel = new("TextLabel", {
	Name = "TitleLabel",
	Parent = titleBar,
	AnchorPoint = Vector2.new(0,0.5),
	Position = UDim2.new(0, 14, 0.5, 0),
	Size = UDim2.new(0.6, -28, 1, -12),
	Text = "CuberRaptor",
	TextSize = 20,
	Font = Enum.Font.GothamBold,
	TextColor3 = Color3.fromRGB(240,240,240),
	TextXAlignment = Enum.TextXAlignment.Left,
	BackgroundTransparency = 1,
	ZIndex = 3,
})

-- Close button (X)
local closeBtn = new("TextButton", {
	Name = "Close",
	Parent = titleBar,
	AnchorPoint = Vector2.new(1,0.5),
	Position = UDim2.new(1, -14, 0.5, 0),
	Size = UDim2.new(0, 34, 0, 28),
	Text = "✕",
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	TextColor3 = Color3.fromRGB(220,220,220),
	BackgroundTransparency = 0.9,
	AutoButtonColor = false,
	ZIndex = 3,
})
new("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0, 8)})

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0.7}):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0.9}):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(main, TweenInfo.new(0.18), {Position = UDim2.new(0.5, 0, 1.2, 0)}):Play()
	wait(0.18)
	screenGui:Destroy()
end)

-- Left panel for tabs
local leftPanel = new("Frame", {
	Name = "LeftPanel",
	Parent = main,
	Position = UDim2.new(0, 12, 0, 66),
	Size = UDim2.new(0, 200, 0, 430),
	BackgroundColor3 = Color3.fromRGB(16,16,16),
	BorderSizePixel = 0,
	ZIndex = 2,
})
new("UICorner", {Parent = leftPanel, CornerRadius = UDim.new(0, 10)})

local tabList = new("UIListLayout", {Parent = leftPanel, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
tabList.Padding = UDim.new(0, 8)

-- Right content area
local contentArea = new("Frame", {
	Name = "ContentArea",
	Parent = main,
	Position = UDim2.new(0, 224, 0, 66),
	Size = UDim2.new(0, 584, 0, 430),
	BackgroundColor3 = Color3.fromRGB(12,12,12),
	BorderSizePixel = 0,
	ZIndex = 2,
})
new("UICorner", {Parent = contentArea, CornerRadius = UDim.new(0, 10)})

-- Tab buttons data
local tabs = {
	{key = "Home", text = "Home"},
	{key = "Stats", text = "Stats"},
	{key = "Videos", text = "Videos"},
	{key = "Tools", text = "Tools"},
	{key = "Settings", text = "Settings"},
}

local contentFrames = {}

-- Function para criar botão de aba
local function createTabButton(tabInfo, order)
	local btn = new("TextButton", {
		Name = tabInfo.key .. "Btn",
		Parent = leftPanel,
		Size = UDim2.new(1, -12, 0, 48),
		BackgroundColor3 = Color3.fromRGB(22,22,22),
		BorderSizePixel = 0,
		Text = tabInfo.text,
		TextSize = 16,
		Font = Enum.Font.Gotham,
		TextColor3 = Color3.fromRGB(220,220,220),
		AutoButtonColor = false,
		LayoutOrder = order,
		ZIndex = 3,
	})
	new("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 8)})
	local indicator = new("Frame", {
		Name = "Indicator",
		Parent = btn,
		Size = UDim2.new(0, 4, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 0, 128),
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 4,
	})
	return btn, indicator
end

-- Create content frames and buttons
for i, t in ipairs(tabs) do
	local btn, ind = createTabButton(t, i)
	
	-- content frame (right side)
	local frame = new("Frame", {
		Name = t.key .. "Content",
		Parent = contentArea,
		Size = UDim2.new(1, -20, 1, -20),
		Position = UDim2.new(0, 10, 0, 10),
		BackgroundTransparency = 1,
		ZIndex = 2,
		Visible = false,
	})
	contentFrames[t.key] = {frame = frame, button = btn, indicator = ind}
	
	-- Sample content: header
	new("TextLabel", {
		Name = "Header",
		Parent = frame,
		Position = UDim2.new(0, 8, 0, 0),
		Size = UDim2.new(1, -16, 0, 28),
		Text = t.text,
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = Color3.fromRGB(235,235,235),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	
	-- Example body text
	new("TextLabel", {
		Name = "Body",
		Parent = frame,
		Position = UDim2.new(0, 8, 0, 36),
		Size = UDim2.new(1, -16, 1, -44),
		Text = "Conteúdo da aba " .. t.text .. "\n\nCustomize aqui com botões, sliders, imagens, etc.",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(200,200,200),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	})
	
	-- Hover effect
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(28,28,28)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(22,22,22)}):Play()
	end)
	
	-- Click to change tab
	btn.MouseButton1Click:Connect(function()
		for k,v in pairs(contentFrames) do
			-- hide all
			v.frame.Visible = false
			v.indicator.Visible = false
			v.button.TextColor3 = Color3.fromRGB(220,220,220)
		end
		contentFrames[t.key].frame.Visible = true
		contentFrames[t.key].indicator.Visible = true
		contentFrames[t.key].button.TextColor3 = Color3.fromRGB(255,255,255)
		-- small tween to content for realism
		TweenService:Create(contentFrames[t.key].frame, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 10, 0, 10)}):Play()
	end)
end

-- Open the default tab (Home)
if contentFrames["Home"] then
	contentFrames["Home"].frame.Visible = true
	contentFrames["Home"].indicator.Visible = true
	contentFrames["Home"].button.TextColor3 = Color3.fromRGB(255,255,255)
end

-- Make the title text draggable (arrastar segurando)
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	-- clamp position to viewport bounds
	local screenSize = workspace.CurrentCamera.ViewportSize
	local mainSize = main.AbsoluteSize
	local maxX = screenSize.X - mainSize.X
	local maxY = screenSize.Y - mainSize.Y
	local px = math.clamp(newPos.X.Offset, 0, maxX)
	local py = math.clamp(newPos.Y.Offset, 0, maxY)
	main.Position = UDim2.new(0, px, 0, py)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Pequena animação de entrada (slide + fade)
main.Position = UDim2.new(0.5, 0, 1.5, 0)
TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()

-- Opcional: atalhos para fechar com ESC
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Escape then
		screenGui:Destroy()
	end
end)

-- Fim do script
