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
            for i=1, 55 do
                lplr.character.HumanoidRootPart.Velocity = lplr.character.HumanoidRootPart.Velocity + Vector3.new(0,11.7,0)
                wait(0.00001)
                lplr.character.HumanoidRootPart.Velocity = lplr.character.HumanoidRootPart.Velocity + Vector3.new(0,18,0)
            end
            wait(1)
            Highjump.Toggle()
        end
	end,
	ArrayText = function() return "Bedwars" end
})

NoFall = GuiLibrary.Objects.MiscellaneousWindow.API.CreateOptionsButton({
	["Name"] = "NoFall",
	["Function"] = function(callback) 
		if callback then
            repeat
                game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit:FireServer()
                task.wait(0.1)
            until not NoFall.Enabled
        end
	end,
	ArrayText = function() return "Packet" end
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
