repeat task.wait() until game:IsLoaded()
local Future = shared.Future
repeat task.wait()
	Future = shared.Future
until Future ~= nil
local GuiLibrary = Future.GuiLibrary
local lplr = game.Players.LocalPlayer
local mouse = lplr:GetMouse()
local cam = workspace.CurrentCamera
local getcustomasset = GuiLibrary.getRobloxAsset
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
local function wrap(func)
	local function toWrap()
		func()
	end
	coroutine.wrap(toWrap)()
end
print("Module")
local Fly = {["Enabled"] = false}
Fly = GuiLibrary.Objects.MovementWindow.API.CreateOptionsButton({
	["Name"] = "Fly",
	["Function"] = function(callback) 
		wrap(function()
			repeat task.wait()
				lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X,1.5,lplr.Character.PrimaryPart.Velocity.Z)
				if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
					lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X,60,lplr.Character.PrimaryPart.Velocity.Z)
				end
				if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
					lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X,-60,lplr.Character.PrimaryPart.Velocity.Z)
				end
			until not Fly.Enabled
		end)
	end,
	ArrayText = function() return "Velo" end
})


Highjump = GuiLibrary.Objects.MovementWindow.API.CreateOptionsButton({
	["Name"] = "Highjump",
	["Function"] = function(callback) 
		if callback then
            for i=1, 50 do
                lplr.character.HumanoidRootPart.Velocity = lplr.character.HumanoidRootPart.Velocity + Vector3.new(0,HighjumpVelo1["Value"],0)
                wait(0.00001)
                lplr.character.HumanoidRootPart.Velocity = lplr.character.HumanoidRootPart.Velocity + Vector3.new(0,HighjumpVelo2["Value"],0)
            end
            Highjump.Toggle()
        end
	end,
	ArrayText = function() return "Bedwars" end
})
HighjumpVelo1 = Aura.CreateSlider({
    Name = "HighjumpVelocity1",
    Function = function(value) end,
    Min = 1,
    Max = 20,
    Default = 11.7
})
HighjumpVelo2 = Aura.CreateSlider({
    Name = "HighjumpVelocity2",
    Function = function(value) end,
    Min = 1,
    Max = 20,
    Default = 18
})
RepeatTimes = Aura.CreateSlider({
    Name = "RepeatTimes",
    Function = function(value) end,
    Min = 1,
    Max = 55,
    Default = 50
})

--[[
AuraAnimation = Aura.CreateSelector({
    Name = "Anim",
    Function = function(value) end,
    List = AuraAnimations
})
AuraShowTarget = Aura.CreateToggle({
    Name = "ShowTarget",
    Function = function(value) end,
    Default = true,
})
]]

task.wait(3)
GuiLibrary["LoadConfig"](GuiLibrary["CurrentConfig"])
