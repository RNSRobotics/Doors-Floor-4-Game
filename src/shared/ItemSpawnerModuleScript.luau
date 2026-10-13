local ItemModule = {} 
local ItemEvent = game.ReplicatedStorage.Events:WaitForChild("ItemSpawnEvent") 
local TweenService = game:GetService("TweenService")
local RS = game.ReplicatedStorage 
local Items = RS:WaitForChild("Items"):GetChildren() 

local DROP_TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local DROP_DISTANCE = 4

local OVERLAP_PARAMS = OverlapParams.new()
OVERLAP_PARAMS.FilterType = Enum.RaycastFilterType.Include

local function findPerfectSurfaceCFrame(model, bench, targetX, targetZ, initialY)
	local baseRot = model:GetPivot().Rotation
	local currentY = initialY - 1.5 

	model:PivotTo(CFrame.new(targetX, currentY, targetZ) * baseRot)

	OVERLAP_PARAMS.FilterDescendantsInstances = {bench}
	local partToCheck = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")

	for _ = 1, 40 do
		local partsOverlapping = workspace:GetPartsInPart(partToCheck, OVERLAP_PARAMS)
		if #partsOverlapping == 0 then break end

		currentY = currentY + 0.1
		model:PivotTo(CFrame.new(targetX, currentY, targetZ) * baseRot)
	end

	return model:GetPivot()
end

function ItemModule.OnItemSpawn(Bench) 
	local ItemSpawnsFolder = Bench:FindFirstChild("ItemSpawns") 
	if not ItemSpawnsFolder then return end

	local ItemSpawns = ItemSpawnsFolder:GetChildren() 
	local spawnedItemsFolder = workspace.SpawnedItems

	for _, spawnPoint in ipairs(ItemSpawns) do 
		local randomItem = Items[math.random(1, #Items)]
		local newItem = randomItem:Clone() 

		local primary = newItem.PrimaryPart
		if primary then
			for _, child in ipairs(newItem:GetDescendants()) do
				if child:IsA("BasePart") and child ~= primary then
					local weld = Instance.new("WeldConstraint")
					weld.Parent = Bench
					weld.Part0 = primary
					weld.Part1 = child
					weld.Parent = primary
					child.CanCollide = false 
					child.Anchored = false
				end
			end
		end

		newItem.Parent = spawnedItemsFolder 

		local targetCFrame = findPerfectSurfaceCFrame(newItem, Bench, spawnPoint.Position.X, spawnPoint.Position.Z, spawnPoint.Position.Y)
		local startCFrame = targetCFrame + Vector3.new(0, DROP_DISTANCE, 0)
		newItem:PivotTo(startCFrame)

		if primary then
			local tween = TweenService:Create(primary, DROP_TWEEN_INFO, {CFrame = targetCFrame})
			tween:Play()

			tween.Completed:Connect(function()
				tween:Destroy()
				newItem:PivotTo(targetCFrame) 
			end)
		else
			newItem:PivotTo(targetCFrame)
		end
	end 
end 

ItemEvent.Event:Connect(ItemModule.OnItemSpawn) 

return ItemModule
