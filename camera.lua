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

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Biến lưu trạng thái spectate
local spectateTarget = nil

-- Hàm bật/tắt spectate
local function setSpectate(player)
    if player then
        spectateTarget = player
    else
        spectateTarget = nil
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
    end
end

-- Cập nhật danh sách người chơi
local function refreshPlayerList()
    for _, child in ipairs(Frame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
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
                    setSpectate(nil) -- tắt spectate
                    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                else
                    setSpectate(player) -- bật spectate
                    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                end
            end)
        end
    end
end

-- Cập nhật camera mỗi frame
RunService.RenderStepped:Connect(function()
    if spectateTarget and spectateTarget.Character and spectateTarget.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = spectateTarget.Character:FindFirstChild("Humanoid")
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- Lắng nghe khi có người ra/vào
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- Lần đầu load
refreshPlayerList()
