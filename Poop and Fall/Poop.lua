-- ไม่ได้ปิดโค้ดน่ะครับ ศึกษากัันได้เลย ระบบง่ายๆ
-- ไม่ได้ปิดโค้ดน่ะครับ ศึกษากัันได้เลย ระบบง่ายๆ
-- ไม่ได้ปิดโค้ดน่ะครับ ศึกษากัันได้เลย ระบบง่ายๆ

spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/wackshopr-tech/script-roblox-all/refs/heads/main/Anti-Afk.lua"))()
    end)
end)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Name = "ProAnimatedGui"

local OpenCloseBtn = Instance.new("TextButton", ScreenGui)
OpenCloseBtn.Size = UDim2.new(0,100,0,40)
OpenCloseBtn.Position = UDim2.new(0,15,0.5,-20)
OpenCloseBtn.Text = "MENU"
OpenCloseBtn.Font = Enum.Font.GothamBold
OpenCloseBtn.TextSize = 14
OpenCloseBtn.TextColor3 = Color3.new(1,1,1)
OpenCloseBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner",OpenCloseBtn).CornerRadius = UDim.new(0,12)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,260,0,210)
MainFrame.Position = UDim2.new(0.5,-130,0.5,-105)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner",MainFrame).CornerRadius = UDim.new(0,16)

local UIGradient = Instance.new("UIGradient", MainFrame)
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,170,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170,0,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,170))
}
UIGradient.Rotation = 0

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0,255,200)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,45)
Title.BackgroundTransparency = 1
Title.Text = "AUTO FARM PANEL"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.TextColor3 = Color3.new(1,1,1)

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Position = UDim2.new(0,0,0.7,0)
StatusLabel.Size = UDim2.new(1,0,0,30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "รอการเริ่มงาน..."
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 13
StatusLabel.TextColor3 = Color3.fromRGB(200,200,200)

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Position = UDim2.new(0.1,0,0.35,0)
ToggleBtn.Size = UDim2.new(0.8,0,0,45)
ToggleBtn.Text = "สถานะ: ปิดอยู่"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 15
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner",ToggleBtn).CornerRadius = UDim.new(0,14)

ToggleBtn.MouseEnter:Connect(function()
    TweenService:Create(ToggleBtn,TweenInfo.new(0.2),{Size=UDim2.new(0.82,0,0,48)}):Play()
end)

ToggleBtn.MouseLeave:Connect(function()
    TweenService:Create(ToggleBtn,TweenInfo.new(0.2),{Size=UDim2.new(0.8,0,0,45)}):Play()
end)

spawn(function()
    while true do
        TweenService:Create(Title,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.new(0,0,0,5)}):Play()
        task.wait(2)
        TweenService:Create(Title,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.new(0,0,0,0)}):Play()
        task.wait(2)
    end
end)

RunService.RenderStepped:Connect(function()
    UIGradient.Rotation += 0.5
end)

local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

OpenCloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Enabled = false

ToggleBtn.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    
    if Enabled then
        ToggleBtn.Text = "สถานะ: กำลังทำงาน"
        TweenService:Create(ToggleBtn,TweenInfo.new(0.3),{BackgroundColor3=Color3.fromRGB(0,180,120)}):Play()
    else
        ToggleBtn.Text = "สถานะ: ปิดอยู่"
        TweenService:Create(ToggleBtn,TweenInfo.new(0.3),{BackgroundColor3=Color3.fromRGB(120,0,0)}):Play()
    end
end)

spawn(function()
    while task.wait(2) do
        if Enabled then
            pcall(function()
                RS:WaitForChild("PoopChargeStart"):FireServer()
            end)
        end
    end
end)

spawn(function()
    while task.wait() do
        if Enabled then
            local remote = RS:FindFirstChild("PoopChargeStart")
            if remote then
                StatusLabel.Text = "กำลังฟาร์มรัวๆ..."
                repeat
                    RS:WaitForChild("PoopEvent"):FireServer(0,true)
                    task.wait(0.02)
                until not RS:FindFirstChild("PoopChargeStart") or not Enabled
                StatusLabel.Text = "หยุดพัก..."
            end
        end
    end
end)

spawn(function()
    while task.wait(300) do
        if Enabled then
            pcall(function()
                RS:WaitForChild("Sell_Inventory"):FireServer()
                StatusLabel.Text = "ขายของเรียบร้อย"
            end)
        end
    end
end)
