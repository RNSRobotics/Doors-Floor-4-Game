--[[
	Notes:	
	Transparency Modifier is what is the end result when "zooming in", it can be changed to whatever you like.
	
	Camera Offset is changed to allow the player to see at lower angles without clipping the view with the torso.
	This may or maynot effect certian tools if they change the players camera position IE crouching or crawling.
	
	Use:
	Place into StarterPlayer.StarterChacterScripts
--]]

local character = (game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:wait())

game:GetService("RunService").RenderStepped:connect(function()
	if (character:FindFirstChild("RightUpperArm") and character:FindFirstChild("LeftUpperArm")) then
-- detection
		character:FindFirstChild("RightUpperArm").LocalTransparencyModifier = 0
		
		character:FindFirstChild("RightLowerArm").LocalTransparencyModifier = 0
		
		character:FindFirstChild("RightHand").LocalTransparencyModifier = 0
-- Right Arm
		character:FindFirstChild("LeftUpperArm").LocalTransparencyModifier = 0
		
		character:FindFirstChild("LeftLowerArm").LocalTransparencyModifier = 0
		
		character:FindFirstChild("LeftHand").LocalTransparencyModifier = 0
-- Left Arm
		character:FindFirstChild("RightUpperLeg").LocalTransparencyModifier = 0
		
		character:FindFirstChild("RightLowerLeg").LocalTransparencyModifier = 0
		
		character:FindFirstChild("RightFoot").LocalTransparencyModifier = 0
-- Right Leg
		character:FindFirstChild("LeftUpperLeg").LocalTransparencyModifier = 0
		
		character:FindFirstChild("LeftLowerLeg").LocalTransparencyModifier = 0
		
		character:FindFirstChild("LeftFoot").LocalTransparencyModifier = 0
-- Left Leg
		character:FindFirstChild("UpperTorso").LocalTransparencyModifier = 0	
		
		character:FindFirstChild("LowerTorso").LocalTransparencyModifier = 0	
-- Torso
		character:FindFirstChild("Humanoid").CameraOffset = Vector3.new(0,0,-2)
	end
end)