 loadstring(game:HttpGet("https://pastefy.app/asJVzcjy/raw",true))() 

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local TargetPlaceId = 11276071411 
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ฟังก์ชันสำหรับส่งสคริปต์ไปรันต่อที่แมพใหม่ (Queue on Teleport)
local function queueScript()
    local syn = syn or (http and http.request and syn) or nil
    local queue_on_teleport = syn and syn.queue_on_teleport or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
    
    if queue_on_teleport then
        -- ใส่ Script เดิมของคุณลงไปในนี้เพื่อให้มันรันต่อเมื่อย้ายแมพเสร็จ
        queue_on_teleport([[
            loadstring(game:HttpGet("ลิงก์สคริปต์ของคุณตรงนี้"))()
        ]])
    end
end

-- ฟังก์ชันสร้าง GUI (เหมือนเดิมแต่ปรับ Logic เล็กน้อย)
local function createWarningGui(statusText, showBar)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MapCheckerGui"
    screenGui.Parent = playerGui
    screenGui.IgnoreGuiInset = true -- ให้เต็มจอจริงๆ

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.4, 0, 0.4, 0)
    frame.Position = UDim2.new(0.3, 0, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0.3, 0)
    label.Position = UDim2.new(0.05, 0, 0.2, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Text = statusText
    label.Font = Enum.Font.GothamBold
    label.Parent = frame

    local loadingBarBg = Instance.new("Frame")
    loadingBarBg.Size = UDim2.new(0.8, 0, 0.05, 0)
    loadingBarBg.Position = UDim2.new(0.1, 0, 0.6, 0)
    loadingBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    loadingBarBg.Visible = showBar
    loadingBarBg.Parent = frame

    local loadingBarFill = Instance.new("Frame")
    loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    loadingBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    loadingBarFill.BorderSizePixel = 0
    loadingBarFill.Parent = loadingBarBg

    local countLabel = Instance.new("TextLabel")
    countLabel.Size = UDim2.new(1, 0, 2, 0)
    countLabel.Position = UDim2.new(0, 0, 1, 0)
    countLabel.BackgroundTransparency = 1
    countLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    countLabel.TextSize = 20
    countLabel.Text = ""
    countLabel.Parent = loadingBarBg

    return screenGui, label, loadingBarFill, countLabel
end

-- ตรวจสอบแมพ
if game.PlaceId == TargetPlaceId then
    -- ถ้าอยู่ถูกแมพแล้ว
    local gui, label = createWarningGui("สำเร็จ! แมพถูกต้อง", false)
    task.wait(1.5)
    gui:Destroy()
    print("Wack Shop Ok ......")
    -- รันโค้ดหลักของคุณที่นี่ --
else
    -- ถ้าอยู่ผิดแมพ
    local gui, label, fill, count = createWarningGui("ผิดแมพ! กำลังเตรียมย้าย...", true)
    
    -- เตรียมสคริปต์ไว้รันต่อในแมพหน้า
    queueScript()

    -- นับ 1-10
    for i = 1, 10 do
        count.Text = "กำลังโหลดข้อมูล: " .. i .. " / 10"
        fill.Size = UDim2.new(i/10, 0, 1, 0)
        task.wait(0.50) -- วาร์ปค่อนข้างเร็ว
    end

    -- ย้ายแมพ
    local success, err = pcall(function()
        TeleportService:Teleport(TargetPlaceId, player)
    end)

    if not success then
        label.Text = "สคริปต์ใช้ไม่ได้กับแมพนี้ โปรดเข้าให้ถูกแมพ"
        label.TextColor3 = Color3.fromRGB(255, 100, 100)
        fill.Parent.Visible = false
        count.Text = "ผิดพลาด: " .. tostring(err)
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variables สำหรับระบบหายตัว (Dodge System)
local isDodging = false
local fakeChar = nil
local syncConnection = nil

-- ==========================================
-- UI LIBRARY CORE
-- ==========================================
local Library = {}

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
            dragInput = input 
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:NewWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WACKSHOP_V6_ULTIMATE"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 450) -- เพิ่มความสูงเพื่อใส่ Stats
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(60, 60, 80)

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TitleBar.Parent = MainFrame
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- [ ระบบสถานะผู้เล่น (Stats Panel) ]
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(1, -20, 0, 80)
    StatsFrame.Position = UDim2.new(0, 10, 1, -90)
    StatsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    StatsFrame.Parent = MainFrame
    Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", StatsFrame).Color = Color3.fromRGB(45, 45, 60)

    local PlayerIcon = Instance.new("ImageLabel")
    PlayerIcon.Size = UDim2.new(0, 60, 0, 60)
    PlayerIcon.Position = UDim2.new(0, 10, 0.5, -30)
    PlayerIcon.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    PlayerIcon.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=420&height=420&format=png"
    PlayerIcon.Parent = StatsFrame
    Instance.new("UICorner", PlayerIcon).CornerRadius = UDim.new(1, 0)

    local StatText = Instance.new("TextLabel")
    StatText.Size = UDim2.new(1, -85, 1, -10)
    StatText.Position = UDim2.new(0, 80, 0, 5)
    StatText.BackgroundTransparency = 1
    StatText.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatText.TextSize = 13
    StatText.Font = Enum.Font.GothamSemibold
    StatText.TextXAlignment = Enum.TextXAlignment.Left
    StatText.RichText = true
    StatText.Parent = StatsFrame

    task.spawn(function()
        while task.wait(0.5) do
            local hp = math.floor(LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health or 0)
            
            -- ดึงข้อมูล Cash และ Level จาก Path ที่ระบุมา
            local cash = "0"
            local level = "0"
            pcall(function()
                cash = LocalPlayer.PlayerGui.UI.BottomBar.Frame.Bottom.Cash.Amount.Text
                level = LocalPlayer.PlayerGui.UI.BottomBar.Frame.Bottom.XPFrame.Level.Text
            end)

            StatText.Text = string.format([[
<b>ผู้เล่น:</b> <font color='#00c3ff'>%s</font>
<b>เลือด:</b> <font color='#ff4b4b'>%s</font> | <b>เลเวล:</b> <font color='#ffff4b'>%s</font>
<b>เงินในเกม:</b> <font color='#4bff4b'>%s</font>]], 
            LocalPlayer.DisplayName, hp, level, cash)
        end
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -140)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Sidebar.Parent = MainFrame
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -150, 1, -150)
    ContentFrame.Position = UDim2.new(0, 145, 0, 50)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0, 50, 0, 50)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    ToggleBtn.Text = "W"
    ToggleBtn.TextColor3 = Color3.fromRGB(0, 195, 255)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 25
    ToggleBtn.Parent = ScreenGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(0, 195, 255)

    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
    MakeDraggable(MainFrame, TitleBar)
    MakeDraggable(ToggleBtn, ToggleBtn)

    local Tabs = {}
    local WindowFunctions = {}

    function WindowFunctions:NewTab(name, icon)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -10, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "  " .. icon .. " " .. name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 170)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 2
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Parent = ContentFrame
        Instance.new("UIListLayout", TabContent).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Tabs) do v.Btn.BackgroundTransparency = 1 v.Content.Visible = false end
            TabBtn.BackgroundTransparency = 0.8
            TabContent.Visible = true
        end)

        table.insert(Tabs, {Btn = TabBtn, Content = TabContent})
        if #Tabs == 1 then TabBtn.BackgroundTransparency = 0.8 TabContent.Visible = true end

        local TabFunctions = {}
        
        function TabFunctions:NewToggle(text, callback)
            local Toggled = false
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Size = UDim2.new(1, -5, 0, 40)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            ToggleFrame.Text = "     " .. text
            ToggleFrame.TextColor3 = Color3.fromRGB(220, 220, 220)
            ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left
            ToggleFrame.Font = Enum.Font.Gotham
            ToggleFrame.TextSize = 14
            ToggleFrame.Parent = TabContent
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 34, 0, 18)
            Indicator.Position = UDim2.new(1, -44, 0.5, -9)
            Indicator.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            Indicator.Parent = ToggleFrame
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

            local Dot = Instance.new("Frame")
            Dot.Size = UDim2.new(0, 14, 0, 14)
            Dot.Position = UDim2.new(0, 2, 0.5, -7)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dot.Parent = Indicator
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local targetPos = Toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                local targetColor = Toggled and Color3.fromRGB(0, 195, 255) or Color3.fromRGB(50, 50, 60)
                TweenService:Create(Dot, TweenInfo.new(0.2), {Position = targetPos}):Play()
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                pcall(callback, Toggled)
            end)
        end

        function TabFunctions:NewSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -5, 0, 50)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            SliderFrame.Parent = TabContent
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size = UDim2.new(1, -10, 0, 20)
            TitleLabel.Position = UDim2.new(0, 10, 0, 5)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Text = text .. ": " .. default
            TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            TitleLabel.Font = Enum.Font.GothamSemibold
            TitleLabel.TextSize = 13
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Parent = SliderFrame

            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -30, 0, 6)
            SliderBar.Position = UDim2.new(0, 15, 1, -15)
            SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            SliderBar.Parent = SliderFrame
            Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(0, 195, 255)
            SliderFill.Parent = SliderBar
            Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

            local SliderThumb = Instance.new("Frame")
            SliderThumb.Size = UDim2.new(0, 14, 0, 14)
            SliderThumb.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
            SliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderThumb.Parent = SliderBar
            Instance.new("UICorner", SliderThumb).CornerRadius = UDim.new(1, 0)

            local dragging = false
            local function update(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                SliderThumb.Position = UDim2.new(pos, -7, 0.5, -7)
                TitleLabel.Text = text .. ": " .. value
                callback(value)
            end
            SliderThumb.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
            callback(default)
        end

        function TabFunctions:NewButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -5, 0, 35)
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.Parent = TabContent
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
            Button.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        function TabFunctions:NewPlayerList(text, callback)
            local Dropdown = Instance.new("TextButton")
            Dropdown.Size = UDim2.new(1, -5, 0, 35)
            Dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            Dropdown.Text = "   " .. text .. ": (คลิก)"
            Dropdown.TextColor3 = Color3.fromRGB(200, 200, 200)
            Dropdown.TextXAlignment = Enum.TextXAlignment.Left
            Dropdown.Parent = TabContent
            Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)

            local ListFrame = Instance.new("Frame")
            ListFrame.Size = UDim2.new(1, 0, 0, 120)
            ListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            ListFrame.Visible = false
            ListFrame.Parent = TabContent
            
            local Scroll = Instance.new("ScrollingFrame")
            Scroll.Size = UDim2.new(1,0,1,0)
            Scroll.BackgroundTransparency = 1
            Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            Scroll.Parent = ListFrame
            Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 2)

            Dropdown.MouseButton1Click:Connect(function()
                ListFrame.Visible = not ListFrame.Visible
                for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer then
                        local pBtn = Instance.new("TextButton")
                        pBtn.Size = UDim2.new(1, -5, 0, 25)
                        pBtn.Text = " " .. p.DisplayName
                        pBtn.Parent = Scroll
                        pBtn.MouseButton1Click:Connect(function() Dropdown.Text = " 🎯 " .. p.DisplayName ListFrame.Visible = false callback(p) end)
                    end
                end
            end)
        end

        return TabFunctions
    end
    return WindowFunctions
end

-- ==========================================
-- MAIN LOGIC (FEATURES COMBINED)
-- ==========================================
local Window = Library:NewWindow("WACKSHOP V6 | PLAYER STATS")

local MainTab = Window:NewTab("Main", "🏠")
local ESPTab = Window:NewTab("ESP", "👁️")
local MoveTab = Window:NewTab("Move", "⚡")

-- --- Main Tab ---
MainTab:NewToggle("⚡ ภารกิจไว (Instant Interact)", function(state)
    _G.InstantInteract = state
    task.spawn(function()
        while _G.InstantInteract do
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
            end
            task.wait(2)
        end
    end)
end)

MainTab:NewButton("🌫️ ลบหมอก", function()
    game.Lighting.FogEnd = 100000
    for _, v in pairs(game.Lighting:GetChildren()) do if v:IsA("Atmosphere") then v:Destroy() end end
end)

-- --- ESP Tab ---
local playerConnections = {}
local function applyESP(player, character)
    if not character or player == LocalPlayer then return end
    local head = character:WaitForChild("Head", 10)
    if not head then return end
    
    if character:FindFirstChild("HL") then character.HL:Destroy() end
    local hl = Instance.new("Highlight", character)
    hl.Name = "HL"
    hl.FillColor = Color3.fromRGB(255, 0, 0)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    if head:FindFirstChild("Tag") then head.Tag:Destroy() end
    local bg = Instance.new("BillboardGui", head)
    bg.Name = "Tag"
    bg.Size = UDim2.new(0, 150, 0, 50)
    bg.AlwaysOnTop = true
    bg.StudsOffset = Vector3.new(0, 3, 0)
    local txt = Instance.new("TextLabel", bg)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = player.DisplayName
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 12
end

ESPTab:NewToggle("เปิดมองทะลุ", function(state)
    _G.ESP = state
    if state then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                playerConnections[p] = p.CharacterAdded:Connect(function(c) if _G.ESP then task.wait(0.5) applyESP(p, c) end end)
                if p.Character then applyESP(p, p.Character) end
            end
        end
    else
        for _, conn in pairs(playerConnections) do conn:Disconnect() end
        playerConnections = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                if p.Character:FindFirstChild("HL") then p.Character.HL:Destroy() end
                if p.Character.Head:FindFirstChild("Tag") then p.Character.Head.Tag:Destroy() end
            end
        end
    end
end)

local targetTp
ESPTab:NewPlayerList("เลือกผู้เล่นเพื่อวาร์ป", function(p) targetTp = p end)
ESPTab:NewButton("วาร์ปไปหา", function()
    if targetTp and targetTp.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetTp.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,0)
    end
end)

-- --- Movement Tab ---
local walkSpeed = 16
MoveTab:NewSlider("ปรับความเร็ว", 16, 250, 16, function(v) walkSpeed = v end)

task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character.Humanoid then
                if LocalPlayer.Character.Humanoid.WalkSpeed ~= walkSpeed then
                    LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
                end
            end
        end)
    end
end)

MoveTab:NewToggle("เดินทะลุ (Noclip)", function(state)
    _G.Noclip = state
    RunService.Stepped:Connect(function()
        if _G.Noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

MoveTab:NewToggle("🎭 หายตัว/สลับร่าง (Dodge)", function(state)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not root or not hum then return end
    isDodging = state
    if isDodging then
        char.Archivable = true
        fakeChar = char:Clone()
        fakeChar.Parent = Workspace
        char.Archivable = false
        local fakeHum = fakeChar:FindFirstChild("Humanoid")
        local fakeRoot = fakeChar:FindFirstChild("HumanoidRootPart")
        for _, part in pairs(fakeChar:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
        Camera.CameraSubject = fakeHum
        syncConnection = RunService.RenderStepped:Connect(function()
            if fakeChar and fakeRoot and root then
                fakeHum:Move(hum.MoveDirection, false)
                fakeHum.Jump = hum.Jump
                root.CFrame = fakeRoot.CFrame * CFrame.new(0, -20, 0)
                root.AssemblyLinearVelocity = Vector3.new(0,0,0)
            end
        end)
    else
        if syncConnection then syncConnection:Disconnect() end
        if fakeChar and fakeChar:FindFirstChild("HumanoidRootPart") and root then root.CFrame = fakeChar.HumanoidRootPart.CFrame end
        if hum then Camera.CameraSubject = hum end
        if fakeChar then fakeChar:Destroy() fakeChar = nil end
    end
end)

-- Start Notification
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "WACKSHOP V6"; Text = "ระบบสถานะผู้เล่นทำงานแล้ว!"; Duration = 5})
