-- Inspired by "Trashcan Man" - Fake invis by sending character far
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Hiệu ứng rung nhẹ
local RunService = game:GetService("RunService")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Đẩy nhân vật lên rất cao để "mất tầm nhìn"
hrp.Velocity = Vector3.new(0, 500, 0)

-- Option: làm tàng hình luôn
for _, part in ipairs(character:GetDescendants()) do
	if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
		part.LocalTransparencyModifier = 1
	elseif part:IsA("Decal") then
		part.Transparency = 1
	end
end

-- Cho rung nhẹ trong vài giây
local t = 0
local connection
connection = RunService.RenderStepped:Connect(function(dt)
	t += dt
	hrp.CFrame = hrp.CFrame * CFrame.Angles(0, 0.05, 0) -- quay nhẹ
	if t > 3 then
		connection:Disconnect()
	end
end)
