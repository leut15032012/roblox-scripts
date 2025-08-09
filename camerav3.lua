-- ⚠️ Chạy trong exploit executor hoặc LocalScript
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0

local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 5, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Spectate Menu"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Nút thu nhỏ
local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.Size = UDim2.new(0, 30, 1, 0)
MinimizeBtn.Position = UDim2.new(1, -60, 0, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Nút đóng
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.FillDirection = Enum.FillDirection.Vertical

-- Biến lưu trạng thái
local spectateTarget = nil
local minimized = false

-- Hàm bật/tắt spectate
local function setSpectate(player)
    if player then
        spectateTarget = player
    else
        spectateTarget = nil
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
    end
end

-- Hàm tạo danh sách player
local function refreshPlayerList()
    for _, child in ipairs(Frame:GetChildren()) do
        if child:IsA("TextButton") and child ~= MinimizeBtn and child ~= CloseBtn then
            child:Destroy()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton", Frame)
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = player.Name
            btn.MouseButton1Click:Connect(function()
                if spectateTarget == player then
                    setSpectate(nil)
                    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                else
                    setSpectate(player)
                    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                end
            end)
        end
    end
end

-- Sự kiện nút thu nhỏ
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        for _, child in ipairs(Frame:GetChildren()) do
            if child ~= TitleBar and not child:IsA("UIListLayout") then
                child.Visible = false
            end
        end
        Frame.Size = UDim2.new(0, 250, 0, 30)
    else
        for _, child in ipairs(Frame:GetChildren()) do
            child.Visible = true
        end
        Frame.Size = UDim2.new(0, 250, 0, 300)
    end
end)

-- Sự kiện nút đóng
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    spectateTarget = nil
end)

-- Camera follow
RunService.RenderStepped:Connect(function()
    if spectateTarget and spectateTarget.Character and spectateTarget.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = spectateTarget.Character:FindFirstChild("Humanoid")
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- Update danh sách khi có người vào/ra
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- Lần đầu load
refreshPlayerList()
