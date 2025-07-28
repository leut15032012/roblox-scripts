local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

for _, part in ipairs(character:GetDescendants()) do
	if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
		part.LocalTransparencyModifier = 1
	elseif part:IsA("Decal") then
		part.Transparency = 1
	end
end

for _, acc in ipairs(character:GetChildren()) do
	if acc:IsA("Accessory") and acc:FindFirstChild("Handle") then
		acc.Handle.LocalTransparencyModifier = 1
	end
end
