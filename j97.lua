for _, player in pairs(game.Players:GetPlayers()) do
	local char = player.Character
	if char then
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				if part.Transparency >= 0.9 then
					warn(player.Name .. " is probably invisible (Transparency = " .. part.Transparency .. ")")
				end
			end
		end
	end
end
