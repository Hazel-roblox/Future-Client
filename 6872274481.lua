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

local knitRecieved, knit
knitRecieved, knit = pcall(function()
	repeat task.wait()
		return debug.getupvalue(require(game:GetService("Players")[game.Players.LocalPlayer.Name].PlayerScripts.TS.knit).setup, 6)
	until knitRecieved
end)
local events = {
	HangGliderController = knit.Controllers["HangGliderController"],
	SprintController = knit.Controllers["SprintController"],
	JadeHammerController = knit.Controllers["JadeHammerController"],
	PictureModeController = knit.Controllers["PictureModeController"],
	SwordController = knit.Controllers["SwordController"],
	GroundHit = game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit,
	Reach = require(game:GetService("ReplicatedStorage").TS.combat["combat-constant"]),
	Knockback = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1),
	report = knit.Controllers["report-controller"]
}
--modules

--Combat

Aura = GuiLibrary.Objects.CombatWindow.API.CreateOptionsButton({
    ["Name"] = "Aura",
    ["Function"] = function(callback) 
        wrap(function()
            repeat
				for i,v in pairs(game.Players:GetPlayers()) do
					if (v.Character) and (game.Players.LocalPlayer.Character) and v ~= game.Players.LocalPlayer then
						pcall(function()
							if (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude < AuraRange and v.Character.Humanoid.health > 1 and lplr.Character.Humanoid.Health > 1 and v.Team ~= lplr.Team then
								events["SwordController"]:swingSwordAtMouse()
							end
						end)
					end
				end
				task.wait()
			until not Aura.Enabled
        end)
    end,
    ArrayText = function() return "18" end
})

AutoSprint = GuiLibrary.Objects.CombatWindow.API.CreateOptionsButton({
    ["Name"] = "AutoSprint",
    ["Function"] = function(callback) 
        wrap(function()
            repeat
                events["SprintController"]:startSprinting()
                task.wait()
             until not AutoSprint.Enabled
         end)
    end,
    ArrayText = function() return "Packet" end
})

--Movement

local Fly = {["Enabled"] = false}
Fly = GuiLibrary.Objects.MovementWindow.API.CreateOptionsButton({
	["Name"] = "Fly",
	["Function"] = function(callback) 
		wrap(function()
			repeat
				lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X,1.5,lplr.Character.PrimaryPart.Velocity.Z)
				if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
					lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X,60,lplr.Character.PrimaryPart.Velocity.Z)
				end
				if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
					lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X,-60,lplr.Character.PrimaryPart.Velocity.Z)
				end
                task.wait()
			until not Fly.Enabled
		end)
	end,
	ArrayText = function() return "Velo" end
})


Highjump = GuiLibrary.Objects.MovementWindow.API.CreateOptionsButton({
	["Name"] = "Highjump",
	["Function"] = function(callback) 
            wrap(function()
                for i=1, 55 do
                    lplr.character.HumanoidRootPart.Velocity = lplr.character.HumanoidRootPart.Velocity + Vector3.new(0,11.7,0)
                    wait(0.00001)
                    lplr.character.HumanoidRootPart.Velocity = lplr.character.HumanoidRootPart.Velocity + Vector3.new(0,18,0)
                end
                wait(1)
                Highjump.Toggle()
            end)
        end
	end,
	ArrayText = function() return "Bw" end
})

--Miscellaneous

NoFall = GuiLibrary.Objects.MiscellaneousWindow.API.CreateOptionsButton({
    ["Name"] = "NoFall",
    ["Function"] = function(callback) 
        pcall(function()
            repeat
                events["GroundHit"]:FireServer()
                task.wait(0.1)
            until not NoFall.Enabled
        end)
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
