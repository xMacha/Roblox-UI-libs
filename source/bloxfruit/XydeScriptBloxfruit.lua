local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/xMacha/xReaper-blox-fruit-script/refs/heads/main/Rayfield.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Xreaper for blox fruit",
   Icon = "skull",
   LoadingTitle = "loading Xreaper for blox fruit....",
   LoadingSubtitle = "by Macha",
   Theme = "",

   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = Xreaper, 
      FileName = "cfg"
   },

   Discord = {
      Enabled = true, 
      Invite = "EtjXnWjt",
      RememberJoins = true 
   },

   KeySystem = false, 
   KeySettings = {
      Title = "Enter Key",
      Subtitle = "https://discord.gg/EtjXnWjt",
      Note = "Join ours discord to get key", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"admin"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

Rayfield:Notify({
   Title = "Welcome",
   Content = "Use K to hide/unhide menu",
   Duration = 6.5,
   Image = "skull",
})

local PlayerTab = Window:CreateTab("Player", "user")

local Section = PlayerTab:CreateSection("Movement")

local Speed = PlayerTab:CreateSlider({
   Name = "Player speed multiplier",
   Range = {1, 30},
   Increment = 0.1,
   Suffix = "x Speed",
   CurrentValue = 1,
   Flag = "Speed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
local player = game.Players.LocalPlayer

local function applySpeedMultiplier()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    -- Ustawienie SpeedMultiplier (zmień `Value` na rzeczywistą wartość, np. 12)
    character:SetAttribute("SpeedMultiplier", Value)
	local speed = Value
end

-- Wywołanie funkcji przy pierwszym uruchomieniu
applySpeedMultiplier()

-- Ponowne ustawianie po respawnie gracza
player.CharacterAdded:Connect(function()
    applySpeedMultiplier()
end)
   end,
})

local Slider = PlayerTab:CreateSlider({
   Name = "Dash length",
   Range = {1, 800},
   Increment = 1,
   Suffix = "Length",
   CurrentValue = 1,
   Flag = "DashLenght", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
local player = game.Players.LocalPlayer

local function applySpeedMultiplier()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    -- Ustawienie SpeedMultiplier (zmień `Value` na rzeczywistą wartość, np. 12)
    character:SetAttribute("DashLength", Value)
end

-- Wywołanie funkcji przy pierwszym uruchomieniu
applySpeedMultiplier()

-- Ponowne ustawianie po respawnie gracza
player.CharacterAdded:Connect(function()
    applySpeedMultiplier()
end)

   end,
})

 local Slider = PlayerTab:CreateSlider({
    Name = "Jump Height",
    Range = {50, 500},
    Increment = 1,
    Suffix = "Height",
    CurrentValue = 50,
    Flag = "Height", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
    local player = game.Players.LocalPlayer

	local function applySpeedMultiplier()
 	   local character = player.Character or player.CharacterAdded:Wait()
 	   local humanoid = character:WaitForChild("Humanoid")

 	   -- Ustawienie SpeedMultiplier (zmień `Value` na rzeczywistą wartość, np. 12)
  	   game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
	end

	-- Wywołanie funkcji przy pierwszym uruchomieniu
	applySpeedMultiplier()

	-- Ponowne ustawianie po respawnie gracza
	player.CharacterAdded:Connect(function()
    applySpeedMultiplier()
	end)

  	  end,
})



local Toggle = PlayerTab:CreateToggle({
   Name = "Large Attack Range on melle",
   CurrentValue = false,
   Flag = "largeattackrange", -- Unikalny identyfikator
   Callback = function(Value)
       local ply = game:GetService("Players").LocalPlayer.Character
       if Value then
           -- Ustaw rozmiar rąk na większy (przykładowo Vector3.new(30,30,30); dostosuj według potrzeb)
           ply.RightHand.Size = Vector3.new(1, 1, 50)
           ply.LeftHand.Size  = Vector3.new(1, 1, 50)
		   ply.LeftHand.Transparency = 1
		   ply.RightHand.Transparency = 1
       else
           -- Przywróć domyślny rozmiar rąk (przykładowo Vector3.new(5,5,5); dostosuj według potrzeb)
           ply.RightHand.Size = Vector3.new(1, 1, 1)
           ply.LeftHand.Size  = Vector3.new(1, 1, 1)
		   ply.LeftHand.Transparency = 0
		   ply.RightHand.Transparency = 0
       end
   end,
})

 local Section = PlayerTab:CreateSection("Teleport")
 ------------------------- --TELEPORT--------------------------------------

 local Keybind = PlayerTab:CreateKeybind({
   Name = "teleport to nearest player",
   CurrentKeybind = "none",
   HoldToInteract = false,
   Flag = "Keybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Keybind)
           local localPlayer = game.Players.LocalPlayer
        local localCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local localHRP = localCharacter:FindFirstChild("HumanoidRootPart")
        if not localHRP then
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "Local HumanoidRootPart not found!",
                Duration = 6.5,
                Image = "rewind"
            })
            return
        end

        local nearestPlayer = nil
        local nearestDistance = math.huge

        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = player.Character.HumanoidRootPart
                local distance = (targetHRP.Position - localHRP.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestPlayer = player
                end
            end
        end

        if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = nearestPlayer.Character.HumanoidRootPart
            -- Ustawienie teleportacji z niewielkim offsetem, aby uniknąć kolizji
            local newCFrame = targetHRP.CFrame * CFrame.new(0, 0, -5)
            localHRP.CFrame = newCFrame

            Rayfield:Notify({
                Title = "Teleport",
                Content = "Teleported to nearest player: " .. nearestPlayer.Name,
                Duration = 6.5,
                Image = "rewind"
            })
        else
            Rayfield:Notify({
                Title = "Teleport Error",
                Content = "No nearest player found!",
                Duration = 6.5,
                Image = "rewind"
            })
        end
   end,
})

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local selectedPlayerName = nil

-- Pobierz listę aktualnych graczy i utwórz tablicę z ich nazwami
local players = Players:GetPlayers()
local options = {}
for _, plr in ipairs(players) do
    table.insert(options, plr.Name)
end
local SelectPlayer = PlayerTab:CreateDropdown({
    Name = "Select Player",
    Options = options,
    CurrentOption = { options[1] or "No player" },
    MultipleOptions = false,
    Flag = "TeleportToPlayer",
    Callback = function(Options)
		targetPlayer = Options[1]
		Rayfield:Notify({
            Title = "Player Selected",
            Content = "Selected player: " .. targetPlayer,
            Duration = 6.5,
            Image = "rewind",
        })
	end,
})
local TeleportPlayerRefreshButton = PlayerTab:CreateButton({
    Name = "Refresh",
    Callback = function()
        local players = Players:GetPlayers()
        local options = {}

        for _, plr in ipairs(players) do
            table.insert(options, plr.Name)
        end

        -- Odśwież dropdown nową listą opcji
        SelectPlayer:Refresh(options)

        -- Opcjonalnie ustaw domyślnie wybraną opcję, np. pierwszą z listy:
        SelectPlayer:Set({ options[1] or "No player" })
    end,
})

local TeleportButton = PlayerTab:CreateButton({
   Name = "Teleport",
   Callback = function()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local TargetPlayer = targetPlayer

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local function setNoclip(state)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

local targetPlayer = Players:FindFirstChild(TargetPlayer)
if not targetPlayer then
    warn("Gracz docelowy nie został znaleziony: " .. TargetPlayer)
    return
end

local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
local targetHRP = targetCharacter:WaitForChild("HumanoidRootPart")

setNoclip(true)

hrp.Anchored = false

local speed = 350
local distance = (hrp.Position - targetHRP.Position).Magnitude
local tweenTime = distance / speed

-- Przygotowanie tweena (ruchu) – interpolujemy CFrame z aktualnej pozycji do pozycji gracza docelowego
local tweenInfo = TweenInfo.new(
    tweenTime,              -- czas trwania przelotu
    Enum.EasingStyle.Linear -- liniowa interpolacja
)

local tween = TweenService:Create(hrp, tweenInfo, { CFrame = targetHRP.CFrame })

-- Po zakończeniu tweena wyłączamy noclip oraz odblokowujemy postać
tween.Completed:Connect(function()
    hrp.Anchored = false
    setNoclip(false)
	humanoid.WalkSpeed = 16
	local speed = 16
	local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
	character:SetAttribute("SpeedMultiplier", 1)

end)

-- Rozpoczęcie przelotu
tween:Play()

   end,
})

------------------------------------------------------------------
-- Sekcja Teleport do Miejscówek
local firstsea  = 2753915549
local secondsea = 4442272183
local thirdsea  = 7449423635

local TeleportLocations = {}  -- zadeklarowana globalnie lub w zasięgu, gdzie będziemy ją używać

if game.PlaceId == firstsea then
    TeleportLocations = {
        ["Second sea"]   = Vector3.new(-1163.0552978515625, 7.730201721191406, 1727.9244384765625),
        ["Middle Town"]  = Vector3.new(-689.303466796875, 8.012133598327637, 1583.14306640625),
        ["Jungle"]       = Vector3.new(-1440.9144287109375, 61.34035110473633, 5.870068550109863),
        ["Coloseum"]     = Vector3.new(-1650.7550048828125, 56.65516662597656, -3169.927978515625),
        ["Desert"]       = Vector3.new(1216.3438720703125, 32.10291290283203, 4366.6875),
        ["Fishmen"]      = Vector3.new(3855.323486328125, 4.8794779777526855, -1875.3719482421875),
        ["Fountain"]     = Vector3.new(5713.72265625, 283.83465576171875, 4392.4111328125),
        ["Ice"]          = Vector3.new(1432.46240234375, 86.77574920654297, -1388.4036865234375),
        ["Magma"]        = Vector3.new(-5574.34814453125, 118.35784912109375, 8670.2802734375),
        ["Marine Base"]  = Vector3.new(-4934.0712890625, 165.3853302001953, 4324.09765625),
        ["Marine Start"] = Vector3.new(-3117.447265625, 208.01431274414062, 2048.0693359375),
        ["Mob Boss"]     = Vector3.new(-2885.309814453125, 30.808130264282227, 5402.78662109375),
        ["Pirate"]       = Vector3.new(-1087.8214111328125, 51.44248580932617, 4148.3681640625),
        ["Prison"]       = Vector3.new(5272.056640625, 69.61725616455078, 747.977294921875),
        ["Windmill"]     = Vector3.new(1068.079833984375, 32.67471694946289, 1442.68115234375),
        ["Sky"]          = Vector3.new(-4631.361328125, 848.5858154296875, -1939.8021240234375)
    }
elseif game.PlaceId == secondsea then
    TeleportLocations = {
        ["Port"]			 = Vector3.new(109.5929946899414, 18.14961814880371, 2832.624267578125),
		["first sea"] 		 = Vector3.new(109.5929946899414, 18.14961814880371, 2832.624267578125),
		["Colosseum"]		 = Vector3.new(-1837.10986328125, 17.22287368774414, 1363.89794921875),
		["Kindom of rose 1"] = Vector3.new(-429.581298828125, 72.54814910888672, 1836.175537109375),
		["Kindom of rose 2"] = Vector3.new(638.4208984375, 72.56649017333984, 918.284423828125),
		["Mansion"]			 = Vector3.new(-337.3038024902344, 330.9158630371094, 643.4093017578125),
		["Jeremy"] 			 = Vector3.new(2338.507080078125, 445.12896728515625, 760.1799926757812),
		["factory"] 		 = Vector3.new(272.713134765625, 84.80889892578125, -274.45196533203125),
		["Cafe"]			 = Vector3.new(-377.603271484375, 72.41827392578125, 322.8168029785156),
		["Green zone"] 		 = Vector3.new(-2440.791015625, 72.54467010498047, -3216.10302734375),
		["Graveyard"] 		 = Vector3.new(-5497.0546875, 48.562530517578125, -795.21630859375),
		["Cursed ship"] 	 = Vector3.new(-6496.89794921875, 89.03499603271484, -116.50946044921875),
		["Hot and cold"]	 = Vector3.new(-4989.2373046875, 43.594356536865234, -4457.04296875),
		["Raid"] 			 = Vector3.new(-6502.59130859375, 249.37265014648438, -4528.81103515625),
		["Forgotten island"] = Vector3.new(-2599.527587890625, 238.3115692138672, -10316.03125),
		["Snow mountain"]	 = Vector3.new(391.800048828125, 400.9197998046875, -5314.6025390625),
		["Ice castle"]		 = Vector3.new(5839.1318359375, 145.20716857910156, -6113.7529296875),
		["Dark arena"]		 = Vector3.new(3780.00439453125, 18.500125885009766, -3499.567138671875),
		["Cave island"]		 = Vector3.new(-5171.4423828125, 104.97344207763672, 2425.376953125)
    }
elseif game.PlaceId == thirdsea then
    TeleportLocations = {
        ["Port"] = Vector3.new(-384.96710205078125, 20.636030197143555, 5438.5927734375),
		["Second sea"] = Vector3.new(-384.96710205078125, 20.636030197143555, 5438.5927734375),
		["Hydra Arena"] = Vector3.new(5166.3701171875, 50.2464599609375, -1545.9783935546875),
		["Hydra"] = Vector3.new(4370.1708984375, 1250.6451416015625, 583.9122314453125),
		["Castle"] = Vector3.new(-5075.6435546875, 370.0659484863281, -3174.4423828125),
		["Great tree"] = Vector3.new(1799.307373046875, 25.909912109375, -7099.75732421875),
		["Sea of threats"] = Vector3.new(-2552.8515625, 38.47640609741211, -12278.3388671875),
		["Mansion"] = Vector3.new(-12634.736328125, 458.2341003417969, -7429.14208984375),
		["Floating turtle"] = Vector3.new(-11154.443359375, 568.4527587890625, -8994.1474609375),
		["Haunted castle"] = Vector3.new(-8777.0185546875, 140.97418212890625, 6277.13623046875),
		["Top of great tree"] = Vector3.new(3032.780029296875, 2280.85107421875, -7325.47802734375),
		["Tiki"] = Vector3.new(-16224.1162109375, 136.81129455566406, 1027.419921875)


    }
end

-- Teraz możesz używać zmiennej TeleportLocations

-- Sekcja nagłówkowa


-- Przygotuj listę nazw lokalizacji
local locationNames = {}
for name, _ in pairs(TeleportLocations) do
    table.insert(locationNames, name)
end

local selectedLocation = locationNames[1] -- domyślnie pierwsza opcja

local TeleportDropdown = PlayerTab:CreateDropdown({
    Name = "Select Location",
    Options = locationNames,
    CurrentOption = { locationNames[1] },
    MultipleOptions = false,
    Flag = "TeleportLocation",
    Callback = function(Options)
        selectedLocation = Options[1]
        Rayfield:Notify({
            Title = "Location Selected",
            Content = "Selected location: " .. selectedLocation,
            Duration = 6.5,
            Image = 4483362458,
        })
    end,
})

local TeleportLocationButton = PlayerTab:CreateButton({
    Name = "Teleport to Location",
    Callback = function()
        local destination = TeleportLocations[selectedLocation]
        if not destination then
            Rayfield:Notify({
                Title = "Error",
                Content = "Location not found: " .. tostring(selectedLocation),
                Duration = 6.5,
                Image = 4483362458,
            })
            return
        end

        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        
        -- Obliczenie odległości między aktualną pozycją a miejscówką
        local distance = (destination - hrp.Position).Magnitude
        local duration = distance / 350

        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(destination) })
        tween:Play()
        
        Rayfield:Notify({
            Title = "Teleporting",
            Content = "Teleporting to " .. selectedLocation,
            Duration = 6.5,
            Image = 4483362458,
        })
    end,
})

local Section = PlayerTab:CreateSection("Exit")

local Button = PlayerTab:CreateButton({
   Name = "Exit",
   Callback = function()
   Rayfield:Destroy()
   end,
})

-------------------------ESP----------------------------------
-- Zakładka ESP z Twojego menu
local ESPTab = Window:CreateTab("ESP", "eye")

-- Globalne zmienne sterujące ESP
local ESPEnabledGlobal = false
local ShowOutline = false
local ShowFill = false
local ShowUsername = false
local ShowLevel = false
local ShowFruit = false
local ESPOutlineColor = Color3.fromRGB(255,255,255)
local ESPFillColor = Color3.fromRGB(255,0,0)

-------------------------------------------------------------------
-- Funkcja tworząca ESP dla danej postaci gracza (poza lokalnym)
local function createESP(player, character)
    if character:FindFirstChild("ESPHighlight") then
        return
    end

    -- Utwórz Highlight (obrys) na postaci
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Adornee = character
    -- Ustawienia wypełnienia
    highlight.FillTransparency = ShowFill and 0.5 or 1
    highlight.FillColor = ESPFillColor
    -- Ustawienia obrysu
    highlight.OutlineTransparency = ShowOutline and 0 or 1
    highlight.OutlineColor = ESPOutlineColor
    highlight.Parent = character

    -- Utwórz BillboardGui do wyświetlania informacji nad postacią
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPInfo"
    billboard.Adornee = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 150, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = character

    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.TextScaled = false
    textLabel.TextSize = 14
    textLabel.TextColor3 = Color3.fromRGB(255,255,255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboard

    -- Funkcja aktualizująca wyświetlany tekst w ESP
    local function updateText()
        local info = ""
        if ShowUsername then
            info = info .. player.Name
        end
        if ShowLevel then
            local level = "N/A"
            if player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") then
                level = tostring(player.Data.Level.Value)
            end
            info = info .. " | Lvl: " .. level
        end
        if ShowFruit then
            local fruit = "N/A"
            if player:FindFirstChild("Data") and player.Data:FindFirstChild("DevilFruit") then
                fruit = tostring(player.Data.DevilFruit.Value)
            end
            info = info .. " | Fruit: " .. fruit
        end
        textLabel.Text = info
    end

    updateText()
    spawn(function()
        while character and character.Parent do
            updateText()
            wait(1)
        end
    end)
end

-- Funkcja usuwająca ESP z postaci
local function removeESP(character)
    local highlight = character:FindFirstChild("ESPHighlight")
    if highlight then highlight:Destroy() end
    local billboard = character:FindFirstChild("ESPInfo")
    if billboard then billboard:Destroy() end
end

-------------------------------------------------------------------
-- MENU: Toggle ESP (główne włączenie/wyłączenie)
local ToggleESP = ESPTab:CreateToggle({
   Name = "Toggle ESP",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(Value)
       ESPEnabledGlobal = Value
       if not Value then
           for _, player in ipairs(game.Players:GetPlayers()) do
               if player ~= game.Players.LocalPlayer and player.Character then
                   removeESP(player.Character)
               end
           end
       else
           for _, player in ipairs(game.Players:GetPlayers()) do
               if player ~= game.Players.LocalPlayer and player.Character then
                   createESP(player, player.Character)
               end
           end
       end
   end,
})

-- MENU: Toggle Outline
local ToggleOutline = ESPTab:CreateToggle({
   Name = "ESP out line",
   CurrentValue = false,
   Flag = "espoutlineaaa",
   Callback = function(Value)
       ShowOutline = Value
       for _, player in ipairs(game.Players:GetPlayers()) do
           if player ~= game.Players.LocalPlayer and player.Character then
               local highlight = player.Character:FindFirstChild("ESPHighlight")
               if highlight then
                   highlight.OutlineTransparency = ShowOutline and 0 or 1
                   highlight.OutlineColor = ESPOutlineColor
               end
           end
       end
   end,
})

-- MENU: Toggle Fill
local ToggleESPFill = ESPTab:CreateToggle({
   Name = "Esp fill",
   CurrentValue = false,
   Flag = "espfill",
   Callback = function(Value)
       ShowFill = Value
       for _, player in ipairs(game.Players:GetPlayers()) do
           if player ~= game.Players.LocalPlayer and player.Character then
               local highlight = player.Character:FindFirstChild("ESPHighlight")
               if highlight then
                   highlight.FillTransparency = ShowFill and 0.5 or 1
                   highlight.FillColor = ESPFillColor
               end
           end
       end
   end,
})

-- MENU: Toggle Player Username
local ToggleUsername = ESPTab:CreateToggle({
   Name = "Player Username",
   CurrentValue = false,
   Flag = "Tuser",
   Callback = function(Value)
       ShowUsername = Value
    end,
})

-- MENU: Toggle Player level
local ToggleLevel = ESPTab:CreateToggle({
   Name = "Player level",
   CurrentValue = false,
   Flag = "levbelsad",
   Callback = function(Value)
       ShowLevel = Value
    end,
})

-- MENU: Toggle Player fruit
local ToggleFruit = ESPTab:CreateToggle({
   Name = "Player fruit",
   CurrentValue = false,
   Flag = "Toggle121",
   Callback = function(Value)
       ShowFruit = Value
    end,
})

-------------------------------------------------------------------
-- MENU: Color pickers
local ESPOutLinecolorpicker = ESPTab:CreateColorPicker({
    Name = "ESP out line color",
    Color = Color3.fromRGB(255,255,255),
    Flag = "ESPoutlinecolor",
    Callback = function(Value)
        ESPOutlineColor = Value
        for _, player in ipairs(game.Players:GetPlayers()) do
           if player ~= game.Players.LocalPlayer and player.Character then
               local highlight = player.Character:FindFirstChild("ESPHighlight")
               if highlight and ShowOutline then
                   highlight.OutlineColor = ESPOutlineColor
               end
           end
        end
    end,
})

local ESPFillcolorpicker = ESPTab:CreateColorPicker({
    Name = "ESP Fill color",
    Color = Color3.fromRGB(255,0,0),
    Flag = "ESP Fill color",
    Callback = function(Value)
        ESPFillColor = Value
        for _, player in ipairs(game.Players:GetPlayers()) do
           if player ~= game.Players.LocalPlayer and player.Character then
               local highlight = player.Character:FindFirstChild("ESPHighlight")
               if highlight and ShowFill then
                   highlight.FillColor = ESPFillColor
               end
           end
        end
    end,
})

-------------------------------------------------------------------
-- MENU: Exit Button

local Section = ESPTab:CreateSection("Exit")
local ExitButtonESP = ESPTab:CreateButton({
   Name = "Exit",
   Callback = function()
       Rayfield:Destroy()
   end,
})

-------------------------------------------------------------------
-- Obsługa graczy dołączających później
game.Players.PlayerAdded:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            wait(1)
            if ESPEnabledGlobal then
                createESP(player, character)
            end
        end)
    end
end)
