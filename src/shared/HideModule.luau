local HideModule = {}
PlayerHidden = false
--This is just smth i making before i make entity spawning! <3

local Event = game.ReplicatedStorage.Events:WaitForChild("ItemSpawnEvent")
function HideModule:HidePlayer(Player,RoomClone)
	local Character = Player.Character
	local Humanoid = Character:FindFirstChild("Humanoid")
	local RootPart = Character:FindFirstChild("HumanoidRootPart")
	PlayerHidden = false
	local HideSpotFolder = RoomClone:FindFirstChild("HideSpots")

end

Event:connect(HideModule:HidePlayer())
return HideModule
