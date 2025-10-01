-- CuberRaptor Hub com Key (Verificação) - versão menor
-- Key: Pqnvue
-- Colar no executor ou em LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove GUIs antigas com mesmo nome
for _, v in pairs(playerGui:GetChildren()) do
	if v.Name == "CuberRaptorHub" or v.Name == "CuberRaptorKeyUI" then
		v:Destroy()
	end
end

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

-- #########################
-- # Interface de Key (pequena)
-- #########################
local keyGui = new("ScreenGui", {
	Name = "CuberRaptorKeyUI",
	DisplayOrder = 2000,
	Parent = playerGui,
	ResetOnSpawn = false,
})

local keyMain = new("Frame", {
	Name = "KeyMain",
	Parent = keyGui,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0.5, 0.5, -60),
	Size = UDim2.new(0, 380, 0, 160),
	BackgroundColor3 = Color3.fromRGB(24,24,24),
	BorderSizePixel = 0,
})
new("UICorner", {Parent = keyMain, CornerRadius = UDim.new(0, 12)})

-- Título da key UI
new("TextLabel", {
	Name = "Title",
	Parent = keyMain,
	Size = UDim2.new(1, 0, 0, 44),
	Position = UDim2.new(0,0,0,0),
	BackgroundTransparency = 1,
	Text = "CuberRaptor — Enter Key",
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	TextColor3 = Color3.fromRGB(240,240,240),
	TextXAlignment = Enum.TextXAlignment.Center,
})

-- Caixa de texto para key
local keyBox = new("TextBox", {
	Name = "KeyBox",
	Parent = keyMain,
	Position = UDim2.new(0, 20, 0, 52),
	Size = UDim2.new(1, -40, 0, 36),
	BackgroundColor3 = Color3.fromRGB(18,18,18),
	Text = "",
	PlaceholderText = "Digite a key aqui...",
	Font = Enum.Font.Gotham,
	TextSize = 16,
	TextColor3 = Color3.fromRGB(220,220,220),
	ClearTextOnFocus = false,
})
new("UICorner", {Parent = keyBox, CornerRadius = UDim.new(0, 8)})

-- Mensagem de feedback
local feedback = new("TextLabel", {
	Name = "Feedback",
	Parent = keyMain,
	Position = UDim2.new(0, 20, 0, 96),
	Size = UDim2.new(1, -40, 0, 20),
	BackgroundTransparency = 1,
	Text = "",
	Font = Enum.Font.Gotham,
	TextSize = 14,
	TextColor3 = Color3.fromRGB(200,200,200),
	TextXAlignment = Enum.TextXAlignment.Left,
})

-- Buttons
local btnFrame = new("Frame", {
	Name = "BtnFrame",
	Parent = keyMain,
	Position = UDim2.new(0, 20, 0, 120),
	Size = UDim2.new(1, -40, 0, 32),
	BackgroundTransparency = 1,
})
local verifyBtn = new("TextButton", {
	Name = "Verify",
	Parent = btnFrame,
	Size = UDim2.new(1, 0, 1, 0),
	Text = "Verify",
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	BackgroundColor3 = Color3.fromRGB(200,0,80),
	TextColor3 = Color3.fromRGB(255,255,255),
	AutoButtonColor = true,
})
new("UICorner", {Parent = verifyBtn, CornerRadius = UDim.new(0, 8)})

-- Key correta
local CORRECT_KEY = "Pqnvue"

-- Função que cria a Hub (chamaremos ao verificar)
local function createHub()
	-- Remove se já existir (segurança)
	for _, v in pairs(playerGui:GetChildren()) do
		if v.Name == "CuberRaptorHub" then
			v:Destroy()
		end
	end

	-- Root ScreenGui
	local screenGui = new("ScreenGui", {
		Name = "CuberRaptorHub",
		DisplayOrder = 1000,
		Parent = playerGui,
		ResetOnSpawn = false,
	})

	-- Main frame (janela) - um pouco menor que antes
	local main = new("Frame", {
		Name = "Main",
		Parent = screenGui,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 700, 0, 460), -- menor
		BackgroundColor3 = Color3.fromRGB(24, 24, 24),
		BorderSizePixel = 0,
	})
	new("UICorner", {Parent = main, CornerRadius = UDim.new(0, 12)})

	-- Sombra sutil (menor)
	local shadow = new("Frame", {
		Name = "Shadow",
		Parent = main,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 4),
		Size = UDim2.new(1, 8, 1, 8),
		BackgroundColor3 = Color3.new(0,0,0),
		BackgroundTransparency = 0.86,
		BorderSizePixel = 0,
		ZIndex = 0,
	})
	new("UICorner", {Parent = shadow, CornerRadius = UDim.new(0, 14)})

	-- Title bar (arrastável)
	local titleBar = new("Frame", {
		Name = "TitleBar",
		Parent = main,
		Size = UDim2.new(1, 0, 0, 44),
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

	-- Close button
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
		TweenService:Create(main, TweenInfo.new(0.18), {Position = UDim2.new(0.5, 0, 1.4, 0)}):Play()
		wait(0.18)
		screenGui:Destroy()
	end)

	-- Left panel for tabs
	local leftPanel = new("Frame", {
		Name = "LeftPanel",
		Parent = main,
		Position = UDim2.new(0, 12, 0, 64),
		Size = UDim2.new(0, 180, 0, 384),
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
		Position = UDim2.new(0, 208, 0, 64),
		Size = UDim2.new(0, 480, 0, 384),
		BackgroundColor3 = Color3.fromRGB(12,12,12),
		BorderSizePixel = 0,
		ZIndex = 2,
	})
	new("UICorner", {Parent = contentArea, CornerRadius = UDim.new(0, 10)})

	-- Tabs
	local tabs = {
		{key = "Home", text = "Home"},
		{key = "Stats", text = "Stats"},
		{key = "Videos", text = "Videos"},
		{key = "Tools", text = "Tools"},
		{key = "Settings", text = "Settings"},
	}

	local contentFrames = {}

	local function createTabButton(tabInfo, order)
		local btn = new("TextButton", {
			Name = tabInfo.key .. "Btn",
			Parent = leftPanel,
			Size = UDim2.new(1, -12, 0, 44),
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

	for i, t in ipairs(tabs) do
		local btn, ind = createTabButton(t, i)

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

		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(28,28,28)}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(22,22,22)}):Play()
		end)

		btn.MouseButton1Click:Connect(function()
			for k,v in pairs(contentFrames) do
				v.frame.Visible = false
				v.indicator.Visible = false
				v.button.TextColor3 = Color3.fromRGB(220,220,220)
			end
			contentFrames[t.key].frame.Visible = true
			contentFrames[t.key].indicator.Visible = true
			contentFrames[t.key].button.TextColor3 = Color3.fromRGB(255,255,255)
			TweenService:Create(contentFrames[t.key].frame, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 10, 0, 10)}):Play()
		end)
	end

	-- Abrir aba Home por padrão
	if contentFrames["Home"] then
		contentFrames["Home"].frame.Visible = true
		contentFrames["Home"].indicator.Visible = true
		contentFrames["Home"].button.TextColor3 = Color3.fromRGB(255,255,255)
	end

	-- -------------------------
	-- Home: botão para abrir canal do YouTube / copiar link
	-- -------------------------
	local homeFrame = contentFrames["Home"].frame
	local ytButton = new("TextButton", {
		Name = "YTButton",
		Parent = homeFrame,
		Size = UDim2.new(0, 300, 0, 44),
		Position = UDim2.new(0, 8, 0, 72),
		Text = "Abrir Canal no YouTube",
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = Color3.fromRGB(255,255,255),
		BackgroundColor3 = Color3.fromRGB(200,0,80),
		AutoButtonColor = true,
		ZIndex = 5,
	})
	new("UICorner", {Parent = ytButton, CornerRadius = UDim.new(0, 8)})

	local channelLink = "https://www.youtube.com/@Davizinscripts-d4k"

	ytButton.MouseButton1Click:Connect(function()
		-- Copia pro clipboard se disponível
		if setclipboard then
			pcall(function()
				setclipboard(channelLink)
			end)
		end

		-- Tenta abrir via requests se executor permitir (varia por executor)
		local successOpen = false
		if syn and syn.request then
			pcall(function()
				syn.request({Url = channelLink, Method = "GET"})
				successOpen = true
			end)
		elseif http_request then
			pcall(function()
				http_request({Url = channelLink, Method = "GET"})
				successOpen = true
			end)
		elseif request then
			pcall(function()
				request({Url = channelLink, Method = "GET"})
				successOpen = true
			end)
		end

		-- Feedback pro usuário
		if successOpen then
			ytButton.Text = "Tentando abrir... ✓"
		else
			ytButton.Text = "Link copiado! Cole no navegador 🚀"
		end
		wait(2)
		ytButton.Text = "Abrir Canal no YouTube"
	end)

	-- -------------------------
	-- Dragging (arrastar segurando o título)
	-- -------------------------
	local dragging = false
	local dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		-- clamp position
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

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)

	-- Entrada suave
	main.Position = UDim2.new(0.5, 0, 1.35, 0)
	TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()

	-- Fechar com ESC
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.Escape then
			screenGui:Destroy()
		end
	end)
end

-- #########################
-- # Lógica de verificação (Key)
-- #########################
local function showFeedback(msg, color)
	feedback.Text = msg
	if color then
		feedback.TextColor3 = color
	else
		feedback.TextColor3 = Color3.fromRGB(200,200,200)
	end
end

local function attemptOpenHub()
	local entered = tostring(keyBox.Text or "")
	if entered == CORRECT_KEY then
		showFeedback("Key correta! Abrindo Hub...", Color3.fromRGB(100,255,150))
		-- animação de saída da key UI
		TweenService:Create(keyMain, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0.5, -200)}):Play()
		wait(0.18)
		keyGui:Destroy()
		-- cria a hub
		createHub()
	else
		showFeedback("Key incorreta. Tente novamente.", Color3.fromRGB(255,120,120))
		-- efeito de shake curto
		local orig = keyMain.Position
		for i = 1, 6 do
			local offset = (i % 2 == 0) and 8 or -8
			TweenService:Create(keyMain, TweenInfo.new(0.04), {Position = UDim2.new(orig.X.Scale, orig.X.Offset + offset, orig.Y.Scale, orig.Y.Offset)}):Play()
			wait(0.04)
		end
		TweenService:Create(keyMain, TweenInfo.new(0.06), {Position = orig}):Play()
	end
end

verifyBtn.MouseButton1Click:Connect(function()
	attemptOpenHub()
end)

-- Permitir Enter para verificar
keyBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		attemptOpenHub()
	end
end)

-- Pequena animação de entrada da key UI
keyMain.Position = UDim2.new(0.5, 0, 0.5, -260)
TweenService:Create(keyMain, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, -60)}):Play()
