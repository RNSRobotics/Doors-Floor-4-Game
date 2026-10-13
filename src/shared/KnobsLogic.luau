local KnobLogicModule = {}

local function setupPlayer(player)
	task.wait(1)
	local Rooms = game.ServerScriptService.RoomsSystem:WaitForChild("FurthestRoom")
	local Room = Rooms.Value - 1
	local stats = player:WaitForChild("stats")
	local knobs = stats:WaitForChild("Knobs")
	local KnobsIncrement = Instance.new("IntValue")
	KnobsIncrement.Parent = knobs
	KnobsIncrement.Value = 2
	KnobsIncrement.Name = "KnobsIncrement"
	local gold = stats:WaitForChild("gold")

if gold then
	print("gold!")
else
	print("No gold ):")
end
	local function ExchangeGoldOnDeath()
		local ExchangeRate = math.floor(gold.Value / 100)
		knobs.Value = knobs.Value + ExchangeRate + (KnobsIncrement.Value * Room)
		gold.Value = 0
		print("Turned round into ".. knobs.Value .. "Knobs!")
	end
	player.CharacterAdded:Connect(function(charecter)
		local Humanoid = charecter:WaitForChild("Humanoid")
		Humanoid.Died:Connect(ExchangeGoldOnDeath)
	end)
end

for _, player in ipairs(game.Players:GetPlayers()) do
	setupPlayer(player)
end


game.Players.PlayerAdded:Connect(setupPlayer)
return KnobLogicModule