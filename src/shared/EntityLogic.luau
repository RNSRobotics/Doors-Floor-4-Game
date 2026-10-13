local ReplicatedStorage = game:GetService("ReplicatedStorage")
local bindableEvent = ReplicatedStorage:WaitForChild("MyBindableEvent")

-- Connect a function to listen for when the event is fired
bindableEvent.Event:Connect(function(entity)
	print("Received data:", entity)
end)
