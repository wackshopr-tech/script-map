-- เปิดโค้ดไว้ให้อ่านครับ ไม่นานหรอกเดะเกมก้แก้แล้ว


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WackShop_Mini"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 160, 0, 75)
Frame.Position = UDim2.new(0.5, -80, 0.5, -37)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", Frame)
Stroke.Color = Color3.fromRGB(0, 255, 170)
Stroke.Thickness = 1.2
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 2)
Title.BackgroundTransparency = 1
Title.Text = "By Wack Shop"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextColor3 = Color3.fromRGB(0, 255, 170)

local DodgeBtn = Instance.new("TextButton", Frame)
DodgeBtn.Size = UDim2.new(0.9, 0, 0, 32)
DodgeBtn.Position = UDim2.new(0.05, 0, 0.42, 0)
DodgeBtn.Text = "OFF"
DodgeBtn.Font = Enum.Font.GothamBold
DodgeBtn.TextSize = 14
DodgeBtn.TextColor3 = Color3.new(1, 1, 1)
DodgeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DodgeBtn.AutoButtonColor = false

local BtnCorner = Instance.new("UICorner", DodgeBtn)
BtnCorner.CornerRadius = UDim.new(0, 6)

local Credit = Instance.new("TextLabel", Frame)
Credit.Size = UDim2.new(1, -10, 0, 12)
Credit.Position = UDim2.new(0, 0, 1, -12)
Credit.BackgroundTransparency = 1
Credit.Text = "Wack Shop"
Credit.Font = Enum.Font.Gotham
Credit.TextSize = 9
Credit.TextColor3 = Color3.fromRGB(80, 80, 80)
Credit.TextXAlignment = Enum.TextXAlignment.Right

DodgeBtn.MouseEnter:Connect(function()
    TweenService:Create(DodgeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
end)

DodgeBtn.MouseLeave:Connect(function()
    TweenService:Create(DodgeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
end)

local isDodging = false
local fakeChar = nil
local syncConnection = nil

DodgeBtn.MouseButton1Click:Connect(function()
    isDodging = not isDodging
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if isDodging and root and hum then
        DodgeBtn.Text = "ON"
        DodgeBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
        DodgeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

        char.Archivable = true
        fakeChar = char:Clone()
        fakeChar.Parent = Workspace
        char.Archivable = false
        
        local fakeHum = fakeChar:FindFirstChild("Humanoid")
        local fakeRoot = fakeChar:FindFirstChild("HumanoidRootPart")

        for _, part in pairs(fakeChar:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end

        Camera.CameraSubject = fakeHum

        syncConnection = RunService.RenderStepped:Connect(function()
            if fakeChar and fakeRoot and root then
                fakeHum:Move(hum.MoveDirection, false)
                fakeHum.Jump = hum.Jump
                root.CFrame = fakeRoot.CFrame * CFrame.new(0, -40, 0)
                root.AssemblyLinearVelocity = Vector3.new(0,0,0)
            end
        end)
    else
        isDodging = false
        DodgeBtn.Text = "OFF"
        DodgeBtn.TextColor3 = Color3.new(1, 1, 1)
        DodgeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

        if syncConnection then syncConnection:Disconnect() end
        if fakeChar and fakeChar:FindFirstChild("HumanoidRootPart") and root then
            root.CFrame = fakeChar.HumanoidRootPart.CFrame
        end
        if hum then Camera.CameraSubject = hum end
        if fakeChar then fakeChar:Destroy() fakeChar = nil end
    end
end)
