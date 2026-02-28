-- มแจกเป็นซอสครับน่ะคับ ศึกษากันได้เลยแมพมันเก่าละน่าจะม่มีคนพัฒนาต่อ 


--[[ 
    WACKSHOP V3 - PREMIER EDITION (FULL SOURCE)
    UI Style: Modern Glassmorphism / Dark Grey Tone
    Features: Smooth Toggle Switches, Real-time Animations, Optimized Logic
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Weapons = ReplicatedStorage:WaitForChild("Weapons")

-- // การตั้งค่าระบบ (Settings)
local Settings = {
    FastGun = false, FireRate = 0.03, NoRecoil = false, 
    InfiniteAmmo = false, Automatic = false, NoSpread = false,
    Aimbot = false, AimbotFOV = 100, ShowFOV = false, Smoothing = 0.2,
    ESP_Box = false, ESP_Tracer = false, ESP_Color = Color3.fromRGB(0, 255, 255),
    SpeedValue = 16
}

-- // เก็บค่าเดิมของปืนไว้สำหรับ Reset
local OriginalStats = {}
for _, gun in pairs(Weapons:GetChildren()) do
    OriginalStats[gun] = {}
    for _, val in pairs(gun:GetChildren()) do
        if val:IsA("ValueBase") then
            OriginalStats[gun][val.Name] = val.Value
        end
    end
end

-- // UI Theme Configuration
local Theme = {
    Main = Color3.fromRGB(20, 20, 20),
    Secondary = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 255, 255),
    Text = Color3.fromRGB(240, 240, 240),
    Transparency = 0.25 -- ปรับความใส (0 = ทึบ, 1 = ใสมาก)
}

-- // Utility Functions
local function Tween(obj, info, goal)
    local tween = TweenService:Create(obj, TweenInfo.new(info, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- // Drawing (FOV & ESP)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Theme.Accent

local ESP_Objects = {}
local function CreateESP(TargetPlayer)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Theme.Accent
    Box.Thickness = 1.5
    Box.Filled = false

    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Theme.Accent
    Tracer.Thickness = 1

    ESP_Objects[TargetPlayer] = {Box = Box, Tracer = Tracer}
end

for _, p in pairs(Players:GetPlayers()) do if p ~= Player then CreateESP(p) end end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(function(p)
    if ESP_Objects[p] then
        ESP_Objects[p].Box:Remove()
        ESP_Objects[p].Tracer:Remove()
        ESP_Objects[p] = nil
    end
end)

-- // UI Library Creation
local Library = {}

function Library:NewWindow(title)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "WACKSHOP_V3"

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 550, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
    MainFrame.BackgroundColor3 = Theme.Main
    MainFrame.BackgroundTransparency = Theme.Transparency
    MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
    
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Theme.Accent
    Stroke.Thickness = 1.5
    Stroke.Transparency = 0.6

    local TitleBar = Instance.new("Frame", MainFrame)
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundTransparency = 1
    
    local TitleLabel = Instance.new("TextLabel", TitleBar)
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.Text = title; TitleLabel.TextColor3 = Theme.Text; TitleLabel.Font = "GothamBold"; TitleLabel.TextSize = 18; TitleLabel.BackgroundTransparency = 1; TitleLabel.TextXAlignment = "Left"

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 150, 1, -60); Sidebar.Position = UDim2.new(0, 12, 0, 50); Sidebar.BackgroundTransparency = 1
    local SidebarLayout = Instance.new("UIListLayout", Sidebar); SidebarLayout.Padding = UDim.new(0, 8)

    local ContentFrame = Instance.new("Frame", MainFrame)
    ContentFrame.Size = UDim2.new(1, -185, 1, -70); ContentFrame.Position = UDim2.new(0, 172, 0, 60); ContentFrame.BackgroundTransparency = 1

    local ToggleBtn = Instance.new("TextButton", ScreenGui)
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Position = UDim2.new(0, 20, 0.5, 0); ToggleBtn.BackgroundColor3 = Theme.Main; ToggleBtn.BackgroundTransparency = 0.3; ToggleBtn.Text = "W"; ToggleBtn.TextColor3 = Theme.Accent; ToggleBtn.Font = "GothamBold"; ToggleBtn.TextSize = 25
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", ToggleBtn).Color = Theme.Accent
    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    MakeDraggable(MainFrame, TitleBar); MakeDraggable(ToggleBtn, ToggleBtn)

    local Tabs = {}
    local WindowFunctions = {}

    function WindowFunctions:NewTab(name, icon)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 38); TabBtn.BackgroundColor3 = Theme.Secondary; TabBtn.BackgroundTransparency = 0.8; TabBtn.Text = "  "..icon.."  "..name; TabBtn.TextColor3 = Color3.fromRGB(160,160,160); TabBtn.Font = "GothamSemibold"; TabBtn.TextSize = 13; TabBtn.TextXAlignment = "Left"
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 10)

        local TabContent = Instance.new("ScrollingFrame", ContentFrame)
        TabContent.Size = UDim2.new(1, 0, 1, 0); TabContent.BackgroundTransparency = 1; TabContent.Visible = false; TabContent.ScrollBarThickness = 0; TabContent.AutomaticCanvasSize = "Y"
        Instance.new("UIListLayout", TabContent).Padding = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Tabs) do 
                Tween(v.Btn, 0.3, {BackgroundTransparency = 0.8, TextColor3 = Color3.fromRGB(160,160,160)})
                v.Content.Visible = false 
            end
            Tween(TabBtn, 0.3, {BackgroundTransparency = 0.4, TextColor3 = Theme.Accent})
            TabContent.Visible = true
        end)
        table.insert(Tabs, {Btn = TabBtn, Content = TabContent})

        local TabFunctions = {}

        function TabFunctions:NewToggle(text, callback)
            local Enabled = false
            local TglFrame = Instance.new("Frame", TabContent)
            TglFrame.Size = UDim2.new(1, -10, 0, 42); TglFrame.BackgroundColor3 = Theme.Secondary; TglFrame.BackgroundTransparency = 0.6
            Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 8)
            
            local TglLabel = Instance.new("TextLabel", TglFrame)
            TglLabel.Size = UDim2.new(1, -60, 1, 0); TglLabel.Position = UDim2.new(0, 15, 0, 0); TglLabel.Text = text; TglLabel.TextColor3 = Theme.Text; TglLabel.Font = "Gotham"; TglLabel.TextSize = 13; TglLabel.BackgroundTransparency = 1; TglLabel.TextXAlignment = "Left"
            
            local SwitchOuter = Instance.new("TextButton", TglFrame)
            SwitchOuter.Size = UDim2.new(0, 42, 0, 22); SwitchOuter.Position = UDim2.new(1, -55, 0.5, -11); SwitchOuter.BackgroundColor3 = Color3.fromRGB(50, 50, 50); SwitchOuter.Text = ""
            Instance.new("UICorner", SwitchOuter).CornerRadius = UDim.new(1, 0)
            
            local SwitchInner = Instance.new("Frame", SwitchOuter)
            SwitchInner.Size = UDim2.new(0, 16, 0, 16); SwitchInner.Position = UDim2.new(0, 3, 0.5, -8); SwitchInner.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            Instance.new("UICorner", SwitchInner).CornerRadius = UDim.new(1, 0)

            SwitchOuter.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                if Enabled then
                    Tween(SwitchOuter, 0.25, {BackgroundColor3 = Theme.Accent})
                    Tween(SwitchInner, 0.25, {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                else
                    Tween(SwitchOuter, 0.25, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                    Tween(SwitchInner, 0.25, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(180, 180, 180)})
                end
                pcall(callback, Enabled)
            end)
        end

        function TabFunctions:NewSlider(text, min, max, default, callback)
            local SldFrame = Instance.new("Frame", TabContent)
            SldFrame.Size = UDim2.new(1, -10, 0, 58); SldFrame.BackgroundColor3 = Theme.Secondary; SldFrame.BackgroundTransparency = 0.6
            Instance.new("UICorner", SldFrame).CornerRadius = UDim.new(0, 8)
            
            local Lbl = Instance.new("TextLabel", SldFrame); Lbl.Size = UDim2.new(1, -20, 0, 25); Lbl.Position = UDim2.new(0, 15, 0, 6); Lbl.Text = text..": "..default; Lbl.TextColor3 = Theme.Text; Lbl.BackgroundTransparency = 1; Lbl.TextXAlignment = "Left"; Lbl.Font = "Gotham"; Lbl.TextSize = 12
            
            local Bar = Instance.new("Frame", SldFrame); Bar.Size = UDim2.new(1, -30, 0, 5); Bar.Position = UDim2.new(0, 15, 0, 42); Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)
            
            local function Update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                Lbl.Text = text..": "..val
                Tween(Fill, 0.15, {Size = UDim2.new(pos, 0, 1, 0)})
                pcall(callback, val)
            end
            
            local drag = false
            SldFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = true Update(input) end end)
            UserInputService.InputChanged:Connect(function(input) if drag and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
        end

        function TabFunctions:NewButton(text, callback)
            local Btn = Instance.new("TextButton", TabContent)
            Btn.Size = UDim2.new(1, -10, 0, 42); Btn.BackgroundColor3 = Theme.Secondary; Btn.BackgroundTransparency = 0.4; Btn.Text = text; Btn.TextColor3 = Theme.Text; Btn.Font = "GothamBold"; Btn.TextSize = 13
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
            Btn.MouseButton1Click:Connect(function()
                Tween(Btn, 0.1, {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.new(0,0,0)})
                task.wait(0.1)
                Tween(Btn, 0.2, {BackgroundColor3 = Theme.Secondary, TextColor3 = Theme.Text})
                pcall(callback)
            end)
        end

        return TabFunctions
    end
    return WindowFunctions
end

-- // Logic Loop (Aimbot, ESP, Gun Mods)
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.ShowFOV

    local ClosestTarget = nil
    local MaxDist = Settings.AimbotFOV

    for p, obj in pairs(ESP_Objects) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
            local Pos, OnScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            local HeadPos = Camera:WorldToViewportPoint(p.Character.Head.Position)
            
            if OnScreen and p.Team ~= Player.Team then
                if Settings.ESP_Box then
                    obj.Box.Size = Vector2.new(2000 / Pos.Z, 2500 / Pos.Z)
                    obj.Box.Position = Vector2.new(Pos.X - obj.Box.Size.X/2, Pos.Y - obj.Box.Size.Y/2)
                    obj.Box.Visible = true
                else obj.Box.Visible = false end

                if Settings.ESP_Tracer then
                    obj.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    obj.Tracer.To = Vector2.new(Pos.X, Pos.Y); obj.Tracer.Visible = true
                else obj.Tracer.Visible = false end
                
                local Dist = (Vector2.new(HeadPos.X, HeadPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if Dist < MaxDist then ClosestTarget = p.Character.Head; MaxDist = Dist end
            else
                obj.Box.Visible = false; obj.Tracer.Visible = false
            end
        end
    end

    if Settings.Aimbot and ClosestTarget then
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, ClosestTarget.Position), Settings.Smoothing)
    end

    -- Gun Mods Logic
    for _, gun in pairs(Weapons:GetChildren()) do
        if Settings.FastGun and gun:FindFirstChild("FireRate") then gun.FireRate.Value = Settings.FireRate end
        if Settings.NoRecoil and gun:FindFirstChild("RecoilControl") then gun.RecoilControl.Value = 0 end
        if Settings.Automatic and gun:FindFirstChild("Auto") then gun.Auto.Value = true end
        if Settings.NoSpread and gun:FindFirstChild("Spread") then gun.Spread.Value = 0 end
        if Settings.InfiniteAmmo then
            if not gun:FindFirstChild("Infinite") then Instance.new("Folder", gun).Name = "Infinite" end
        else
            if gun:FindFirstChild("Infinite") then gun.Infinite:Destroy() end
        end
    end
end)

-- WalkSpeed Logic
task.spawn(function()
    while task.wait() do
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            local hum = Player.Character.Humanoid
            if hum.MoveDirection.Magnitude > 0 then
                Player.Character:TranslateBy(hum.MoveDirection * (Settings.SpeedValue / 60))
            end
        end
    end
end)

-- // สร้างเมนูหน้าหลัก
local Window = Library:NewWindow("WACKSHOP V3 | GLOBAL EDITION")

-- TAB 1: Combat
local Tab1 = Window:NewTab("ล็อคเป้า", "🎯")
Tab1:NewToggle("เปิดใช้งาน Aimbot", function(v) Settings.Aimbot = v end)
Tab1:NewToggle("แสดงวงกลม FOV", function(v) Settings.ShowFOV = v end)
Tab1:NewSlider("ขนาดรัศมี FOV", 50, 600, 100, function(v) Settings.AimbotFOV = v end)
Tab1:NewSlider("ความหน่วง (Smoothing)", 1, 10, 2, function(v) Settings.Smoothing = v/10 end)

-- TAB 2: Visuals
local Tab2 = Window:NewTab("มองทะลุ", "👁️")
Tab2:NewToggle("แสดงกรอบ (Box ESP)", function(v) Settings.ESP_Box = v end)
Tab2:NewToggle("แสดงเส้น (Tracer snap)", function(v) Settings.ESP_Tracer = v end)

-- TAB 3: Weapon Mods
local Tab3 = Window:NewTab("อาวุธ", "🔫")
Tab3:NewToggle("ยิงเร็ว (Fast Gun)", function(v) Settings.FastGun = v end)
Tab3:NewSlider("ปรับความเร็วปืน", 1, 10, 3, function(v) Settings.FireRate = v/100 end)
Tab3:NewToggle("ปืนนิ่ง (No Recoil)", function(v) Settings.NoRecoil = v end)
Tab3:NewToggle("เป้าตรง (No Spread)", function(v) Settings.NoSpread = v end)
Tab3:NewToggle("ยิงอัตโนมัติ (Auto)", function(v) Settings.Automatic = v end)
Tab3:NewToggle("กระสุนไม่จำกัด", function(v) Settings.InfiniteAmmo = v end)

-- TAB 4: Character & Misc
local Tab4 = Window:NewTab("ตัวละคร", "🚶")
Tab4:NewSlider("ความเร็วการเดิน", 16, 250, 16, function(v) Settings.SpeedValue = v end)
Tab4:NewButton("ล้างค่าสถานะปืน (Reset)", function()
    for gun, stats in pairs(OriginalStats) do
        for name, val in pairs(stats) do if gun:FindFirstChild(name) then gun[name].Value = val end end
    end
end)

-- Start Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "WACKSHOP V3 LOADED",
    Text = "Enjoy your game session!",
    Icon = "rbxassetid://6023426926",
    Duration = 5
})
