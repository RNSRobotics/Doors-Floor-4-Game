local ActiveRooms = game.Workspace:WaitForChild("ActiveRooms") 
local RoomsFolder = game.ReplicatedStorage:WaitForChild("Rooms") 
local FurthestRoom = script.FurthestRoom 
local OldestRoom = script.OldestRoom 
local ItemModule = game.ReplicatedStorage:WaitForChild("ItemSpawnerModuleScript") 
require(ItemModule) 
local KnobLogic = require(game.ReplicatedStorage.KnobsLogic) 

--------------------------------------------------------------------------- 
--entity logic here!

local EntityEvent = game.ReplicatedStorage.Events:WaitForChild("SpawnEntity")
local EntityChances = {
	{Name = "Rush", Chance = 0, BaseChance = 10,},
	{Name = "ItemMimic", Chance = 0, BaseChance = 4},
	{Name = "Illusion", Chance = 100, BaseChance = 100},
	{Name = "Insanity", Chance = 0, BaseChance = 7},
	{Name = "Insomnia", Chance = 0, BaseChance = 10},
	{Name = "Ambush", Chance = 0, BaseChance = 2},
	{Name = "Monkadoo", Chance = 0, BaseChance = 7},
	
}


function RollEntity()
	for _, entitys in ipairs(EntityChances) do
		local roll = math.random(1,100)
		if roll <= entitys.Chance then
			IllusionNext = false
			if entitys.Name == "Illusion" then
				IllusionNext = true
				entitys.Chance = entitys.BaseChance
				EntityEvent:Fire(entitys.Name)
			end
		else
			EntityEvent:Fire(entitys.Name)
			entitys.Chance = entitys.BaseChance
			entitys.Chance = entitys.Chance + math.random(1,entitys.BaseChance)
		end
			return entitys.Name
	end
end










--------------------------------------------------------------------------- 
local debounce = false 

function DeleteRoom() 
	local DeletedRoom = ActiveRooms:FindFirstChild(tostring(FurthestRoom.Value)) 
	if DeletedRoom then 
		DeletedRoom:Destroy() 
	end 
	FurthestRoom.Value = FurthestRoom.Value + 1 
end 

--------------------------------------------------------------------------- 
local ItemsFolder = game.ReplicatedStorage:WaitForChild("Items") 
local Items = ItemsFolder:GetChildren() 

function SpawnItemsInRoom(RoomClone) 
	local BenchesFolder = RoomClone:FindFirstChild("Benches") 
	local Event = game.ReplicatedStorage.Events:WaitForChild("ItemSpawnEvent") 
	if BenchesFolder then 
		for _, Bench in pairs(BenchesFolder:GetChildren()) do 
			Event:Fire(Bench) 
		end 
	end 
end 

--------------------------------------------------------------------------- 
function Generate() 
	local templates = RoomsFolder:GetChildren() 
	if #templates == 0 then 
		print("Cuh theres no room templates") 
		return 
	end 

	local New
	local nextRoomNumber = OldestRoom.Value + 1 

	-- Fixed special rooms index checking by matching strings or values properly
	if IllusionNext == true then
		print("IllusionNext is true!") 
	end 
	if FurthestRoom.Value == 50 or FurthestRoom.Value == 100 then 
		local specialTemplates = game.ReplicatedStorage.Rooms:WaitForChild("SpecialRooms") 
		-- Safe check to get template
		local ChosenTemplate = specialTemplates:FindFirstChild(tostring(FurthestRoom.Value)) or specialTemplates:GetChildren()[1]
		New = ChosenTemplate:Clone() 
	else 
		print("Room is NOT 450/500!") 
		local randomIndex = math.random(1, #templates) 
		local ChosenTemplate = templates[randomIndex] 
		New = ChosenTemplate:Clone() 
	end 

	New.Name = tostring(nextRoomNumber) 
	local HighestRoomObject = ActiveRooms:FindFirstChild(tostring(OldestRoom.Value)) 

	if HighestRoomObject then 
		local OldDoor = HighestRoomObject:FindFirstChild("ExitDoor") 
		local NewEntryDoor = New:FindFirstChild("EntryDoor") 
		if OldDoor and NewEntryDoor then 
			task.wait()
			local offset = NewEntryDoor.CFrame:ToObjectSpace(New:GetPivot()) 
			New:PivotTo(OldDoor.CFrame * offset) 
		else 
			warn("Missing EntryDoor or ExitDoor in room models!") 
		end 
	end 

	New.Parent = ActiveRooms 
	SpawnItemsInRoom(New) 

	local ExitDoor = New:FindFirstChild("ExitDoor") 
	local Locked = New:FindFirstChild("Locked") 

	if ExitDoor then
		if Locked and Locked.Value == true then 
			warn("Door is locked") 
			-- Add your key/unlock logic here later!
		else 
			-- Pass the door itself or the room to the function dynamically
			ExitDoor.Touched:Connect(function(hit)
				OpenDoor(hit, ExitDoor)
			end) 
		end 
	end

	OldestRoom.Value = nextRoomNumber 
end 

--------------------------------------------------------------------------- 
function OpenDoor(hit, doorPart) 
	local character = hit.Parent 
	local humanoid = character:FindFirstChildOfClass("Humanoid") 

	if humanoid and humanoid.Health > 0 and not debounce then 
		debounce = true 

		-- Use the door passed dynamically to locate the current room accurately
		if doorPart and doorPart.Parent then
			local CurrentRoomObject = doorPart.Parent
			local ExitDoor = CurrentRoomObject:FindFirstChild("ExitDoor") 
			if ExitDoor then 
				ExitDoor:Destroy() 
			end
			local EntryDoor = CurrentRoomObject:FindFirstChild("EntryDoor") 
			if EntryDoor then 
				EntryDoor.CanCollide = true 
			end 
		end 

		Generate() 
		if OldestRoom.Value <= 5 then
		return
		else
			RollEntity()
		end
		if (OldestRoom.Value - FurthestRoom.Value) >= 3 then 
			DeleteRoom() 
		else 
			print("Cant delete room") 
		end 

		task.wait(1) 
		debounce = false 
	end 
end 

--------------------------------------------------------------------------- 
-- IMPORTANT POOKIES
local FirstRoom = ActiveRooms:FindFirstChild(tostring(OldestRoom.Value)) 
if FirstRoom and FirstRoom:FindFirstChild("ExitDoor") then 
	FirstRoom.ExitDoor.Touched:Connect(function(hit)
		OpenDoor(hit, FirstRoom.ExitDoor)
	end) 
	task.wait() 
	SpawnItemsInRoom(FirstRoom)
end
