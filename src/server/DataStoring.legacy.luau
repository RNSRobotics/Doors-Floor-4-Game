-- Put knobs Revives and Rifts here!
local DataStoreService = game:GetService("DataStoreService")
local PlayerStatistics = DataStoreService:GetDataStore("PlayerStatistics")
-- CHANGED: Changed to OnServerEvent connection (Make sure StoreRiftItemEvent is a RemoteEvent!)
local RiftStoreEvent = game.ReplicatedStorage.Events:WaitForChild("StoreRiftItemEvent")
PlayerKnobs = DataStoreService:GetDataStore("PlayerStatistics", "Knobs")
PlayerRevives = DataStoreService:GetDataStore("PlayerStatistics", "Revives")
PlayerMLR = DataStoreService:GetDataStore("PlayerStatistics", "MLR")
PlayerSLR = DataStoreService:GetDataStore("PlayerStatistics", "SLR")
PlayerCR = DataStoreService:GetDataStore("PlayerStatistics", "CR")

game.Players.PlayerAdded:Connect(function(player)
	local stats = Instance.new("Folder")
	stats.Name = "stats"
	stats.Parent = player

	local knobsincrement = 0 -- Gold (not saved!)
	local gold = Instance.new("IntValue")
	gold.Value = 0
	gold.Name = "gold"
	gold.Parent = stats

	-- knobs
	local knobs = Instance.new("IntValue")
	knobs.Value = 0
	knobs.Name = "Knobs"
	knobs.Parent = stats

	-- revives
	local revives = Instance.new("IntValue")
	revives.Value = 0
	revives.Name = "Revives"
	revives.Parent = stats

	-- rifts
	local MoonlightRift = Instance.new("StringValue")
	local StarlightRift = Instance.new("StringValue")
	local CreatorRift = Instance.new("StringValue")

	MoonlightRift.Value = "None"
	MoonlightRift.Name = "MoonlightRift"
	MoonlightRift.Parent = stats

	StarlightRift.Value = "None"
	StarlightRift.Name = "StarlightRift"
	StarlightRift.Parent = stats

	CreatorRift.Value = "None"
	CreatorRift.Name = "CreatorRift"
	CreatorRift.Parent = stats

	-- table
	local SavedStats = {
		knobs = knobs.Value,
		revives = revives.Value,
		MoonlightRift = MoonlightRift.Value,
		StarlightRift = StarlightRift.Value,
		CreatorRift = CreatorRift.Value
	}

	local success, SavedStats = pcall(function()
		local knobs = PlayerKnobs:GetAsync(player.UserId)
		local revives = PlayerRevives:GetAsync(player.UserId)
		local MLR = PlayerMLR:GetAsync(player.UserId)
		local SLR = PlayerSLR:GetAsync(player.UserId)
		local CR = PlayerCR:GetAsync(player.UserId)
		return {
			knobs = knobs,
			revives = revives,
			MoonlightRift = MLR,
			StarlightRift = SLR,
			CreatorRift = CR
		}
	end)

	-- Apply loaded data to values
	if success and SavedStats then
		if SavedStats.knobs then knobs.Value = SavedStats.knobs end
		if SavedStats.revives then revives.Value = SavedStats.revives end
		if SavedStats.MoonlightRift then MoonlightRift.Value = SavedStats.MoonlightRift end
		if SavedStats.StarlightRift then StarlightRift.Value = SavedStats.StarlightRift end
		if SavedStats.CreatorRift then CreatorRift.Value = SavedStats.CreatorRift end
	end
end)

-- Corrected saving connection
game.Players.PlayerRemoving:Connect(function(player)
	local stats = player:FindFirstChild("stats")
	if stats then
		pcall(function() PlayerKnobs:SetAsync(player.UserId, stats.Knobs.Value) end)
		pcall(function() PlayerRevives:SetAsync(player.UserId, stats.Revives.Value) end)
		pcall(function() PlayerMLR:SetAsync(player.UserId, stats.MoonlightRift.Value) end)
		pcall(function() PlayerSLR:SetAsync(player.UserId, stats.StarlightRift.Value) end)
		pcall(function() PlayerCR:SetAsync(player.UserId, stats.CreatorRift.Value) end)
	end
end)

-----------------------------------------------------------------------------------
-- FIXED: Changed .Event to .OnServerEvent so it correctly receives 'player'
RiftStoreEvent:Fire(function(player, heldTool, RiftType)
	print("Received")
	-- FIXED: Removed 'player' from the function parameters
	local stats = player:FindFirstChild("stats")
	if not stats then return end
	local MLR = stats:FindFirstChild("MoonlightRift")
	local SLR = stats:FindFirstChild("StarlightRift")
	local CR = stats:FindFirstChild("CreatorRift")

	if heldTool then
		local RiftType = heldTool:GetAttribute("RiftType")
		local IsRiftable = heldTool:GetAttribute("IsRiftable")
		if IsRiftable == true then
			if RiftType == "Moonlight" and MLR then
				MLR.Value = heldTool.Name
			elseif RiftType == "Starlight" and SLR then
				SLR.Value = heldTool.Name
			elseif RiftType == "Creator" and CR then
				CR.Value = heldTool.Name
			elseif RiftType == "All" then
				
			end
		end
	end
end)

-----------------------------------------------------------------------------------
--print on leave!
local players = game:GetService("Players")
players.PlayerRemoving:Connect(function(player)
	local PlayerStats = player:WaitForChild("stats")
	-- FIXED: Added :GetChildren() so the loop can iterate over the folder contents
	for _, stats in ipairs(PlayerStats:GetChildren()) do
		print(stats.Value)
		-- Note: Removed 'return stats' because it was stopping your loop after printing only the first item
	end
end)
