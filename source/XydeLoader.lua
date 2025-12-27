-- Xyde Loader: Auto-Rejoin + Auto-Login
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer
local BASE_URL = "https://xxMacha.pythonanywhere.com/api/check_key?k="
local KEY_URL = "https://macha.lol" 
local FILE_NAME = "XydeKeySystem.txt"
discord = "p9jCxg5m"

-- LINK DO TEGO KONKRETNEGO LOADERA (Zmień jeśli masz własny raw link do tego pliku)
local SCRIPT_URL = 'https://raw.githubusercontent.com/xMacha/Xyde/refs/heads/main/source/XydeLoader.lua' 

-- =================================================================
-- 1. SYSTEM PERSYSTENCJI (AUTO-RESTART PO TELEPORCIE)
-- =================================================================
local queue_on_teleport = queue_on_teleport or syn.queue_on_teleport or fluxus.queue_on_teleport or (function(...) end)

-- Ta komenda sprawia, że po zmianie serwera skrypt odpali się samoczynnie
queue_on_teleport([[
    repeat task.wait() until game:IsLoaded()
    loadstring(game:HttpGet(']] .. SCRIPT_URL .. [['))()
]])

-- Zabezpieczenie na wypadek, gdyby queue_on_teleport wymagało odświeżenia przy samym teleporcie
Player.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        queue_on_teleport([[
            repeat task.wait() until game:IsLoaded()
            loadstring(game:HttpGet(']] .. SCRIPT_URL .. [['))()
        ]])
    end
end)

-- =================================================================
-- 2. LOGIKA ŁADOWANIA SKRYPTÓW GRY
-- =================================================================
local function RunScript()
    local currentPlaceId = game.PlaceId
    
    if currentPlaceId == 8417221956 then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/xMacha/Xyde/refs/heads/main/source/specter/XydeScriptSpecter.lua'))()
    elseif currentPlaceId == 2753915549 or currentPlaceId == 4442272183 or currentPlaceId == 7449423635 then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/xMacha/Xyde/refs/heads/main/source/bloxfruit/XydeScriptBloxfruit.lua'))()
    else
        warn("Xyde: Gra nieobsługiwana lub skrypt uniwersalny nie został zdefiniowany.")
        -- Tutaj możesz dodać uniwersalne GUI jeśli gra nie jest na liście
    end
end

-- =================================================================
-- 3. FUNKCJE KLUCZA
-- =================================================================
local function CheckKey(key)
    if not key or key == "" then return false end
    -- Usuwamy spacje i znaki nowej linii dla pewności
    key = key:gsub("%s+", "")
    
    local success, response = pcall(function()
        return game:HttpGet(BASE_URL .. key)
    end)
    
    if success and response == "true" then
        return true
    end
    return false
end

local function SaveKey(key)
    if writefile then
        writefile(FILE_NAME, key)
    end
end

local function LoadSavedKey()
    if isfile and isfile(FILE_NAME) then
        return readfile(FILE_NAME)
    end
    return ""
end

-- =================================================================
-- 4. INTERFEJS UŻYTKOWNIKA (GUI)
-- =================================================================

-- Najpierw sprawdzamy, czy mamy zapisany klucz. 
-- Jeśli tak i jest poprawny -> pomijamy GUI całkowicie!
local savedKey = LoadSavedKey()
if savedKey ~= "" then
    -- Szybkie sprawdzenie w tle (opcjonalne, można pominąć sprawdzanie online dla szybkości, ale bezpieczniej sprawdzić)
    if CheckKey(savedKey) then
        -- Klucz poprawny, odpalamy skrypt od razu bez GUI
        RunScript()
        return -- Kończymy działanie tego loadera, bo gra już działa
    end
end

-- Jeśli klucza nie ma lub jest błędny, rysujemy GUI:

if CoreGui:FindFirstChild("XydeKeySystem") then
    CoreGui.XydeKeySystem:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XydeKeySystem"
if pcall(function() ScreenGui.Parent = CoreGui end) then else ScreenGui.Parent = Player.PlayerGui end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 200)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(148, 0, 211)
Stroke.Thickness = 2
Stroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "XYDE SCRIPT"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = MainFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0, 40)
KeyBox.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
KeyBox.TextColor3 = Color3.fromRGB(200, 200, 200)
KeyBox.PlaceholderText = "Enter Key Here..."
KeyBox.Text = savedKey -- Wpisz stary klucz, nawet jak nie zadziałał w auto-loginie
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.Parent = MainFrame

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 6)
KeyCorner.Parent = KeyBox

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Text = "CHECK KEY"
VerifyBtn.Size = UDim2.new(0.38, 0, 0, 35)
VerifyBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(148, 0, 211)
VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 14
VerifyBtn.Parent = MainFrame

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 6)
BtnCorner1.Parent = VerifyBtn

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Text = "GET KEY"
GetKeyBtn.Size = UDim2.new(0.38, 0, 0, 35)
GetKeyBtn.Position = UDim2.new(0.52, 0, 0.6, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 14
GetKeyBtn.Parent = MainFrame

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 6)
BtnCorner2.Parent = GetKeyBtn

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Text = "Waiting..."
StatusLbl.Size = UDim2.new(1, 0, 0, 20)
StatusLbl.Position = UDim2.new(0, 0, 0.85, 0)
StatusLbl.BackgroundTransparency = 1
StatusLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextSize = 12
StatusLbl.Parent = MainFrame

-- LOGIKA PRZYCISKÓW
GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(KEY_URL)
        StatusLbl.Text = "Link copied!"
        StatusLbl.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        StatusLbl.Text = "Clipboard not supported"
    end
end)

local function TryLogin()
    local inputKey = KeyBox.Text
    StatusLbl.Text = "Checking..."
    StatusLbl.TextColor3 = Color3.fromRGB(255, 200, 0)
    VerifyBtn.Text = "..."
    
    task.wait(0.1)
    
    if CheckKey(inputKey) then
        StatusLbl.Text = "Success!"
        StatusLbl.TextColor3 = Color3.fromRGB(0, 255, 0)
        SaveKey(inputKey) 
        
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        tween:Play()
        MainFrame.Visible = false
        ScreenGui:Destroy()
        
        RunScript()
    else
        StatusLbl.Text = "Invalid Key!"
        StatusLbl.TextColor3 = Color3.fromRGB(255, 50, 50)
        VerifyBtn.Text = "CHECK KEY"
    end
end

VerifyBtn.MouseButton1Click:Connect(TryLogin)
