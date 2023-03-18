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
local players = game.Players
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
	report = knit.Controllers["report-controller"],
	SwordHit = game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SwordHit,
}

local function getInv()
	for i,v in pairs(game.ReplicatedStorage.Inventories:GetChildren()) do
		if v.Name == lplr.Name then
			for i2,v2 in pairs(v:GetChildren()) do
				if tostring(v2.Name):find("pickaxe") then
					return v
				end
			end
		end
	end
	return Instance.new("Folder")
end

local function hasItem(item)
	if getInv():FindFirstChild(item) then
		return true, 1
	end
	return false
end

local weaponMeta = {
	{"rageblade", 100},
	{"emerald_sword", 99},
	{"glitch_void_sword", 98},
	{"diamond_sword", 97},
	{"iron_sword", 96},
	{"stone_sword", 95},
	{"wood_sword", 94},
	{"emerald_dao", 93},
	{"diamond_dao", 99},
	{"iron_dao", 97},
	{"stone_dao", 96},
	{"wood_dao", 95},
	{"frosty_hammer", 1},
}

local function getBestWeapon()
	local bestSword
	local bestSwordMeta = 0
	for i, sword in ipairs(weaponMeta) do
		local name = sword[1]
		local meta = sword[2]
		if meta > bestSwordMeta and hasItem(name) then
			bestSword = name
			bestSwordMeta = meta
		end
	end
	return getInv():FindFirstChild(bestSword)
end

local function getMagnitude(pos1,pos2)
	return (pos1 - pos2).Magnitude
end

local function canAttack(plr : Player)
	if lplr.Team.Name:lower() ~= "spectator" or lplr.Team.Name:lower() ~= "spectators" then
		if lplr.Team == plr.Team or plr == lplr then
			return false
		end
	end
	return true
end

local function getWeakestClosePlayer(max)
	if max == nil then max = 100000 end
	local nearest
	local nearestDist
	local lowestHP = 10000
	for i,v in pairs(players:GetPlayers()) do
		pcall(function()
			local mag = getMagnitude(lplr.Character.PrimaryPart.Position,v.Character.PrimaryPart.Position)
			if mag <= max and v.Character.Humanoid.Health < lowestHP and canAttack(v) then
				lowestHP = v.Character.Humanoid.Health
				nearest = v
				nearestDist = mag
			end
		end)
	end
	return nearest
end

Aura = GuiLibrary.Objects.CombatWindow.API.CreateOptionsButton({
	["Name"] = "Aura",
	["Function"] = function(callback)
		if callback then
			wrap(function()
				repeat
					local target = getWeakestClosePlayer(18)
					if target ~= nil then
						pcall(function()
							events.SwordHit:FireServer({
								["chargedAttack"] = {
									["chargeRatio"] = 1
								},
								["entityInstance"] = target.Character,
								["validate"] = {
									["targetPosition"] = {
										["value"] = target.Character.PrimaryPart.Position
									},
									["selfPosition"] = {
										["value"] = lplr.Character.PrimaryPart.Position
									}
								},
								["weapon"] = getBestWeapon()
							})
						end)
					end
					task.wait(0.22)
				until not Aura.Enabled
			end)
		else

		end
	end,
	ArrayText = function() return "18" end
})

AutoSprint = GuiLibrary.Objects.CombatWindow.API.CreateOptionsButton({
	["Name"] = "AutoSprint",
	["Function"] = function(callback) 
		wrap(function()
			repeat
				pcall(function()
					if lplr.Character ~= nil and lplr.Character.Humanoid.Health ~= 0 then
						events["SprintController"]:startSprinting()
						task.wait()
					end
				end)
			until not AutoSprint.Enabled
		end)
	end,
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
			repeat task.wait(0.1)
				lplr.character.HumanoidRootPart.Velocity = lplr.character.HumanoidRootPart.Velocity + Vector3.new(0,250,0)
				wait(0.00001)
				lplr.character.HumanoidRootPart.Velocity = lplr.character.HumanoidRootPart.Velocity + Vector3.new(0,18,0)
			until not Highjump.Enabled
		end)
	end,
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
