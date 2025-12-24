local SimpleUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Helper: Funkcja do tworzenia dragowania (przesuwania okna)
local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		game:GetService("TweenService"):Create(object, TweenInfo.new(0.25), {Position = Position}):Play()
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

-- Główna funkcja tworząca okno
function SimpleUI:CreateWindow(settings)
	local Library = {}
	
	-- 1. Tworzenie ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "SimpleUI_" .. settings.Name
	
	-- Zabezpieczenie: Jeśli jesteś w Studio użyj PlayerGui, jeśli w exploicie użyj CoreGui
	if game:GetService("RunService"):IsStudio() then
		ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	else
		-- Większość executorów obsługuje protect_gui lub parentowanie do CoreGui
		ScreenGui.Parent = CoreGui
	end

	-- 2. Główne tło (Main Frame)
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 500, 0, 350)
	MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
	MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui
	
	-- Zaokrąglone rogi
	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 6)
	MainCorner.Parent = MainFrame

	-- 3. Pasek tytułowy (Top Bar)
	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(1, 0, 0, 40)
	TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	TopBar.BorderSizePixel = 0
	TopBar.Parent = MainFrame
	
	local TopBarCorner = Instance.new("UICorner")
	TopBarCorner.CornerRadius = UDim.new(0, 6)
	TopBarCorner.Parent = TopBar
	
	-- Fix dla dolnych rogów paska (żeby nie były zaokrąglone na dole)
	local HideBottomCorner = Instance.new("Frame")
	HideBottomCorner.Size = UDim2.new(1, 0, 0, 10)
	HideBottomCorner.Position = UDim2.new(0, 0, 1, -10)
	HideBottomCorner.BorderSizePixel = 0
	HideBottomCorner.BackgroundColor3 = TopBar.BackgroundColor3
	HideBottomCorner.Parent = TopBar

	local Title = Instance.new("TextLabel")
	Title.Text = settings.Name
	Title.Size = UDim2.new(1, -20, 1, 0)
	Title.Position = UDim2.new(0, 10, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.GothamBold
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 18
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TopBar
	
	-- Włączanie przesuwania
	MakeDraggable(TopBar, MainFrame)

	-- 4. Kontener na zakładki (Tab Buttons)
	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Name = "TabContainer"
	TabContainer.Size = UDim2.new(0, 120, 1, -50)
	TabContainer.Position = UDim2.new(0, 10, 0, 45)
	TabContainer.BackgroundTransparency = 1
	TabContainer.ScrollBarThickness = 0
	TabContainer.Parent = MainFrame
	
	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.Padding = UDim.new(0, 5)
	TabListLayout.Parent = TabContainer

	-- 5. Kontener na strony (Pages)
	local PagesFolder = Instance.new("Folder")
	PagesFolder.Name = "Pages"
	PagesFolder.Parent = MainFrame

	-- Funkcja tworzenia nowej zakładki
	function Library:CreateTab(tabName)
		local TabFunctions = {}
		
		-- Przycisk zakładki (po lewej)
		local TabButton = Instance.new("TextButton")
		TabButton.Name = tabName .. "Button"
		TabButton.Size = UDim2.new(1, 0, 0, 35)
		TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		TabButton.Text = tabName
		TabButton.Font = Enum.Font.Gotham
		TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
		TabButton.TextSize = 14
		TabButton.AutoButtonColor = false
		TabButton.Parent = TabContainer
		
		local TabBtnCorner = Instance.new("UICorner")
		TabBtnCorner.CornerRadius = UDim.new(0, 4)
		TabBtnCorner.Parent = TabButton
		
		-- Strona z elementami (po prawej)
		local Page = Instance.new("ScrollingFrame")
		Page.Name = tabName .. "Page"
		Page.Size = UDim2.new(1, -145, 1, -50)
		Page.Position = UDim2.new(0, 140, 0, 45)
		Page.BackgroundTransparency = 1
		Page.ScrollBarThickness = 2
		Page.Visible = false -- Domyślnie ukryta
		Page.Parent = PagesFolder
		
		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Padding = UDim.new(0, 5)
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Parent = Page
		
		-- Logika przełączania zakładek
		TabButton.MouseButton1Click:Connect(function()
			-- Ukryj wszystkie strony
			for _, v in pairs(PagesFolder:GetChildren()) do
				v.Visible = false
			end
			-- Pokaż obecną
			Page.Visible = true
			
			-- Animacja koloru przycisku
			for _, btn in pairs(TabContainer:GetChildren()) do
				if btn:IsA("TextButton") then
					TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
				end
			end
			TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end)
		
		-- Jeśli to pierwsza zakładka, włącz ją
		if #PagesFolder:GetChildren() == 1 then
			Page.Visible = true
			TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		end

		-- === ELEMENTY UI === --

		-- BUTTON
		function TabFunctions:CreateButton(btnSettings)
			local ButtonFrame = Instance.new("Frame")
			ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
			ButtonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			ButtonFrame.Parent = Page
			
			local BtnCorner = Instance.new("UICorner")
			BtnCorner.CornerRadius = UDim.new(0, 4)
			BtnCorner.Parent = ButtonFrame
			
			local TextBtn = Instance.new("TextButton")
			TextBtn.Size = UDim2.new(1, 0, 1, 0)
			TextBtn.BackgroundTransparency = 1
			TextBtn.Text = btnSettings.Name
			TextBtn.Font = Enum.Font.Gotham
			TextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBtn.TextSize = 14
			TextBtn.Parent = ButtonFrame
			
			TextBtn.MouseButton1Click:Connect(function()
				-- Prosta animacja kliknięcia
				TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
				task.wait(0.1)
				TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
				
				if btnSettings.Callback then btnSettings.Callback() end
			end)
		end

		-- TOGGLE
		function TabFunctions:CreateToggle(toggleSettings)
			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			ToggleFrame.Parent = Page
			
			local TogCorner = Instance.new("UICorner")
			TogCorner.CornerRadius = UDim.new(0, 4)
			TogCorner.Parent = ToggleFrame

			local TogLabel = Instance.new("TextLabel")
			TogLabel.Size = UDim2.new(0.8, 0, 1, 0)
			TogLabel.Position = UDim2.new(0, 10, 0, 0)
			TogLabel.BackgroundTransparency = 1
			TogLabel.Text = toggleSettings.Name
			TogLabel.Font = Enum.Font.Gotham
			TogLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TogLabel.TextXAlignment = Enum.TextXAlignment.Left
			TogLabel.TextSize = 14
			TogLabel.Parent = ToggleFrame
			
			local Checkbox = Instance.new("Frame")
			Checkbox.Size = UDim2.new(0, 20, 0, 20)
			Checkbox.Position = UDim2.new(1, -30, 0.5, -10)
			Checkbox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			Checkbox.Parent = ToggleFrame
			
			local CheckCorner = Instance.new("UICorner")
			CheckCorner.CornerRadius = UDim.new(0, 4)
			CheckCorner.Parent = Checkbox
			
			local CheckBtn = Instance.new("TextButton")
			CheckBtn.Size = UDim2.new(1, 0, 1, 0)
			CheckBtn.BackgroundTransparency = 1
			CheckBtn.Text = ""
			CheckBtn.Parent = Checkbox

			local isToggled = toggleSettings.CurrentValue or false

			-- Funkcja aktualizująca wygląd
			local function UpdateToggle()
				if isToggled then
					TweenService:Create(Checkbox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 100)}):Play()
				else
					TweenService:Create(Checkbox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
				end
				if toggleSettings.Callback then toggleSettings.Callback(isToggled) end
			end
			
			-- Inicjalizacja stanu początkowego
			if isToggled then 
				Checkbox.BackgroundColor3 = Color3.fromRGB(0, 255, 100) 
			end

			CheckBtn.MouseButton1Click:Connect(function()
				isToggled = not isToggled
				UpdateToggle()
			end)
		end
		
		-- SLIDER
		function TabFunctions:CreateSlider(sliderSettings)
			local min = sliderSettings.Min
			local max = sliderSettings.Max
			local default = sliderSettings.CurrentValue or min
			
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, 0, 0, 50)
			SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			SliderFrame.Parent = Page
			
			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, 4)
			SliderCorner.Parent = SliderFrame
			
			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Size = UDim2.new(1, -20, 0, 20)
			SliderLabel.Position = UDim2.new(0, 10, 0, 5)
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Text = sliderSettings.Name
			SliderLabel.Font = Enum.Font.Gotham
			SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
			SliderLabel.TextSize = 14
			SliderLabel.Parent = SliderFrame
			
			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Size = UDim2.new(1, -20, 0, 20)
			ValueLabel.Position = UDim2.new(0, 0, 0, 5)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Text = tostring(default)
			ValueLabel.Font = Enum.Font.Gotham
			ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.TextSize = 14
			ValueLabel.Parent = SliderFrame
			
			local SliderBar = Instance.new("Frame")
			SliderBar.Size = UDim2.new(1, -20, 0, 6)
			SliderBar.Position = UDim2.new(0, 10, 0, 35)
			SliderBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			SliderBar.Parent = SliderFrame
			
			local BarCorner = Instance.new("UICorner")
			BarCorner.CornerRadius = UDim.new(1, 0)
			BarCorner.Parent = SliderBar
			
			local SliderFill = Instance.new("Frame")
			SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
			SliderFill.BorderSizePixel = 0
			SliderFill.Parent = SliderBar
			
			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = SliderFill
			
			local TriggerBtn = Instance.new("TextButton")
			TriggerBtn.Size = UDim2.new(1, 0, 1, 0)
			TriggerBtn.BackgroundTransparency = 1
			TriggerBtn.Text = ""
			TriggerBtn.Parent = SliderBar
			
			local isDragging = false
			
			local function UpdateSlider(input)
				local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
				TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = pos}):Play()
				
				local value = math.floor(((pos.X.Scale * (max - min)) + min) * 10) / 10
				ValueLabel.Text = tostring(value)
				if sliderSettings.Callback then sliderSettings.Callback(value) end
			end
			
			TriggerBtn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					isDragging = true
					UpdateSlider(input)
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					UpdateSlider(input)
				end
			end)
			
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					isDragging = false
				end
			end)
		end

		return TabFunctions
	end
	
	return Library
end

return SimpleUI
