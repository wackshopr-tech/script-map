local function hardHack(tool)
    if not tool:IsA("Tool") then return end

    -- 1. ล็อคค่าใน Setting (ดาเมจ, ยิงรัว, จอนิ่ง, กระสุนไม่กระจาย)
    local setting = tool:FindFirstChild("Setting") or tool:FindFirstChildWhichIsA("ModuleScript")
    if setting then
        pcall(function()
            local s = require(setting)
            -- ดาเมจและระบบยิง
            if s.Damage then s.Damage = 999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 end
            if s.HeadshotDamage then s.HeadshotDamage = 99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 end
            if s.FireRate then s.FireRate = 0.000001 end
            if s.Auto then s.Auto = true end
            
            -- [เพิ่มใหม่] จอนิ่งและเป้านิ่ง (No Recoil & No Spread)
            if s.Recoil then s.Recoil = 0 end
            if s.RecoilPower then s.RecoilPower = 0 end
            if s.Shake then s.Shake = 0 end -- ป้องกันหน้าจอสั่น
            if s.Spread then s.Spread = 0 end
            if s.MaxSpread then s.MaxSpread = 0 end
            if s.MinSpread then s.MinSpread = 0 end
            
            -- กระสุน
            if s.MaxAmmo then s.MaxAmmo = 9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 end
            if s.MagSize then s.MagSize = 9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 end
        end)
    end

    -- 2. วนลูปแก้ค่าสถานะ (ป้องกันการดีดและการลดของกระสุน)
    task.spawn(function()
        while tool.Parent ~= nil do 
            for _, v in pairs(tool:GetDescendants()) do
                if v:IsA("NumberValue") or v:IsA("IntValue") then
                    local name = v.Name:lower()
                    
                    -- ล็อคกระสุน
                    if name:find("mag") or name:find("ammo") or name:find("bullet") then
                        v.Value = 999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
                    end
                    
                    -- [เพิ่มใหม่] ล็อคค่าการสั่นและการดีดใน Value
                    if name:find("recoil") or name:find("shake") or name:find("spread") then
                        v.Value = 0
                    end

                    -- ปืนไม่ร้อน
                    if name:find("heat") then
                        v.Value = 0
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

-- ระบบตรวจจับไอเทม (ส่วนเดิม)
local player = game:GetService("Players").LocalPlayer

local function monitorBackpack()
    for _, item in pairs(player.Backpack:GetChildren()) do
        hardHack(item)
    end
    if player.Character then
        for _, item in pairs(player.Character:GetChildren()) do
            hardHack(item)
        end
    end

    player.Backpack.ChildAdded:Connect(hardHack)
    if player.Character then
        player.Character.ChildAdded:Connect(hardHack)
    end
end

monitorBackpack()
player.CharacterAdded:Connect(monitorBackpack)

print("เช็คครันได้้ครับ")







local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Destroy old GUI if exists
if CoreGui:FindFirstChild("ToolGiverGui") then
    CoreGui:FindFirstChild("ToolGiverGui"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToolGiverGui"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- === MAIN FRAME ===
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Active = true
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.05, 0, 0.08, 0)
Frame.Size = UDim2.new(0, 240, 0, 290)
Frame.ClipsDescendants = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = Frame

-- Frame border glow
local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(100, 60, 220)
FrameStroke.Thickness = 1.5
FrameStroke.Transparency = 0.3
FrameStroke.Parent = Frame

-- === HEADER BAR ===
local Header = Instance.new("Frame")
Header.Parent = Frame
Header.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 42)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Fix bottom corners of header
local HeaderFix = Instance.new("Frame")
HeaderFix.Parent = Header
HeaderFix.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
HeaderFix.BorderSizePixel = 0
HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)

-- Icon dot
local IconDot = Instance.new("Frame")
IconDot.Parent = Header
IconDot.BackgroundColor3 = Color3.fromRGB(120, 70, 255)
IconDot.BorderSizePixel = 0
IconDot.Position = UDim2.new(0, 12, 0.5, -5)
IconDot.Size = UDim2.new(0, 10, 0, 10)
local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = IconDot

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Header
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 32, 0, 0)
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Tool Giver"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Subtitle
local SubLabel = Instance.new("TextLabel")
SubLabel.Parent = Header
SubLabel.BackgroundTransparency = 1
SubLabel.Position = UDim2.new(0, 32, 0, 22)
SubLabel.Size = UDim2.new(1, -70, 0, 16)
SubLabel.Font = Enum.Font.Gotham
SubLabel.Text = "Workspace Scanner"
SubLabel.TextColor3 = Color3.fromRGB(120, 100, 200)
SubLabel.TextSize = 11
SubLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(1, -30, 0.5, -10)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- === STATUS BAR ===
local StatusBar = Instance.new("Frame")
StatusBar.Parent = Frame
StatusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
StatusBar.BorderSizePixel = 0
StatusBar.Position = UDim2.new(0, 10, 0, 50)
StatusBar.Size = UDim2.new(1, -20, 0, 28)
local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusBar

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = StatusBar
StatusLabel.BackgroundTransparency = 1
StatusLabel.Size = UDim2.new(1, -10, 1, 0)
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "⬡  Ready — press Scan to load tools"
StatusLabel.TextColor3 = Color3.fromRGB(140, 130, 180)
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- === SCROLLING FRAME ===
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = Frame
ScrollFrame.Active = true
ScrollFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.Position = UDim2.new(0, 10, 0, 86)
ScrollFrame.Size = UDim2.new(1, -20, 0, 148)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 60, 220)
local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 8)
ScrollCorner.Parent = ScrollFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollFrame
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 4)

local ListPadding = Instance.new("UIPadding")
ListPadding.Parent = ScrollFrame
ListPadding.PaddingTop = UDim.new(0, 6)
ListPadding.PaddingLeft = UDim.new(0, 6)
ListPadding.PaddingRight = UDim.new(0, 6)

-- === SCAN BUTTON ===
local ScanBtn = Instance.new("TextButton")
ScanBtn.Parent = Frame
ScanBtn.BackgroundColor3 = Color3.fromRGB(90, 50, 200)
ScanBtn.BorderSizePixel = 0
ScanBtn.Position = UDim2.new(0, 10, 0, 244)
ScanBtn.Size = UDim2.new(1, -20, 0, 36)
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.Text = "⟳  SCAN TOOLS"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.TextSize = 13
local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 8)
ScanCorner.Parent = ScanBtn

-- Scan button gradient
local ScanGrad = Instance.new("UIGradient")
ScanGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 60, 230)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 30, 160))
})
ScanGrad.Rotation = 90
ScanGrad.Parent = ScanBtn

-- Hover effect
ScanBtn.MouseEnter:Connect(function()
    TweenService:Create(ScanBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(120, 70, 255)
    }):Play()
end)
ScanBtn.MouseLeave:Connect(function()
    TweenService:Create(ScanBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(90, 50, 200)
    }):Play()
end)

-- === TOOL BUTTON TEMPLATE ===
local function createToolButton(tool)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(28, 26, 45)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Font = Enum.Font.Gotham
    btn.Text = "  🔧  " .. tool.Name
    btn.TextColor3 = Color3.fromRGB(210, 200, 255)
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(60, 50, 100)
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(60, 45, 110)
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), {
            Color = Color3.fromRGB(120, 80, 255)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(28, 26, 45)
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), {
            Color = Color3.fromRGB(60, 50, 100)
        }):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        local cloned = tool:Clone()
        cloned.Parent = Players.LocalPlayer:WaitForChild("Backpack")
        -- Flash effect
        TweenService:Create(btn, TweenInfo.new(0.05), {
            BackgroundColor3 = Color3.fromRGB(80, 200, 120)
        }):Play()
        task.delay(0.2, function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(28, 26, 45)
            }):Play()
        end)
        StatusLabel.Text = "✔  Got: " .. tool.Name
        StatusLabel.TextColor3 = Color3.fromRGB(80, 200, 120)
        task.delay(2, function()
            StatusLabel.Text = "⬡  Ready — press Scan to load tools"
            StatusLabel.TextColor3 = Color3.fromRGB(140, 130, 180)
        end)
    end)

    return btn
end

-- === SCAN LOGIC ===
local function updateList()
    -- Clear old buttons
    for _, v in ScrollFrame:GetDescendants() do
        if v:IsA("TextButton") then v:Destroy() end
    end

    StatusLabel.Text = "⟳  Scanning workspace..."
    StatusLabel.TextColor3 = Color3.fromRGB(180, 150, 255)
    ScanBtn.Text = "⟳  SCANNING..."
    ScanBtn.Active = false

    task.wait(0.3)

    local count = 0
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Tool") and v.Parent and v.Parent.Parent ~= Players.LocalPlayer then
            local btn = createToolButton(v)
            btn.Parent = ScrollFrame
            count += 1
        end
    end

    -- Update canvas size
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, count * 40 + 10)

    ScanBtn.Text = "⟳  SCAN TOOLS"
    ScanBtn.Active = true

    if count == 0 then
        StatusLabel.Text = "✖  No tools found in workspace"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 80, 80)
    else
        StatusLabel.Text = "✔  Found " .. count .. " tool(s)"
        StatusLabel.TextColor3 = Color3.fromRGB(80, 200, 120)
        task.delay(3, function()
            StatusLabel.Text = "⬡  Click a tool to add it"
            StatusLabel.TextColor3 = Color3.fromRGB(140, 130, 180)
        end)
    end
end

ScanBtn.MouseButton1Click:Connect(updateList)

-- === DRAG SYSTEM ===
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        TweenService:Create(Frame, TweenInfo.new(0.05), {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }):Play()
    end
end)

-- === ENTRY ANIMATION ===
Frame.Position = UDim2.new(Frame.Position.X.Scale, Frame.Position.X.Offset, Frame.Position.Y.Scale - 0.05, Frame.Position.Y.Offset)
Frame.BackgroundTransparency = 1
TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.05, 0, 0.08, 0),
    BackgroundTransparency = 0
}):Play()
