-- สร้าง GUI หลัก
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local StatusLabel = Instance.new("TextLabel")
local ProgressBarBackground = Instance.new("Frame")
local ProgressBarFill = Instance.new("Frame")
local CreatorLabel = Instance.new("TextLabel")

-- ตั้งค่า ScreenGui
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ตั้งค่า MainFrame (พื้นหลังหลัก)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true -- ทำให้ลากไปมาได้

-- ตกแต่งความโค้งมน
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- ข้อความชื่อผู้สร้าง (WACK SHOP / Cyber nuvex)
CreatorLabel.Parent = MainFrame
CreatorLabel.Size = UDim2.new(1, 0, 0, 50)
CreatorLabel.Position = UDim2.new(0, 0, 0, 20)
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Text = "ผู้สร้างสคริปต์นี้คือ\nWACK SHOP หรือ Cyber nuvex"
CreatorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CreatorLabel.TextSize = 20
CreatorLabel.Font = Enum.Font.GothamBold

-- ข้อความสถานะ (สคริปต์ HACK แอดมิน)
StatusLabel.Parent = MainFrame
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 80)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "สคริปต์ HACK แอดมิน"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 16
StatusLabel.Font = Enum.Font.GothamMedium

-- แถบโหลด (Background)
ProgressBarBackground.Parent = MainFrame
ProgressBarBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ProgressBarBackground.Position = UDim2.new(0.1, 0, 0.65, 0)
ProgressBarBackground.Size = UDim2.new(0.8, 0, 0, 15)

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = ProgressBarBackground

-- แถบโหลด (Fill)
ProgressBarFill.Parent = ProgressBarBackground
ProgressBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150) -- สีเขียวนีออน
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = ProgressBarFill

--- ระบบการทำงาน ---

-- 1. ฟังก์ชันคัดลอกลิงก์ Discord
local function setClipboard(text)
    if setclipboard then
        setclipboard(text)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "WACK SHOP / Cyber nuvex",
            Text = "คัดลอกลิงก์ discord ผู้สร้างแล้ว",
            Duration = 5
        })
    end
end

setClipboard("discord.gg/cnx")

-- 2. อนิเมชั่นหลอดโหลด 100% ภายใน 5 วินาที
ProgressBarFill:TweenSize(
    UDim2.new(1, 0, 1, 0), -- ขยายจนเต็ม
    Enum.EasingDirection.Out,
    Enum.EasingStyle.Linear,
    5, -- เวลา 5 วินาที
    true
)

-- 3. รอให้โหลดเสร็จแล้วรันสคริปต์จริง
task.wait(5.5)
ScreenGui:Destroy() -- ลบหน้าจอโหลดทิ้ง

-- รันสคริปต์เป้าหมาย
loadstring(game:HttpGet("https://raw.githubusercontent.com/wackshopr-tech/script-map/refs/heads/main/College%20War/College%20War.lua"))()
