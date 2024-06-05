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
		if lplr.Team == plr.Team or plr == lplr and plr.Character.Health > 0 then
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

local function animate(animID)
	local animation = Instance.new("Animation")
	animation.AnimationId = animID
	local animatior = lplr.Character.Humanoid:WaitForChild("Animator")
	animatior:LoadAnimation(animation):Play()
end
local AuraAnims = {
	["Normal"] = {
		{frame = CFrame.new(0.7, -0.4, 0.612) * CFrame.Angles(math.rad(285), math.rad(65), math.rad(293)),time = 0.1},
		{frame = CFrame.new(0.61, -0.41, 0.6) * CFrame.Angles(math.rad(210), math.rad(70), math.rad(3)),time = 0.08},
	},
	["Slow"] = {
		{frame = CFrame.new(0.7, -0.4, 0.612) * CFrame.Angles(math.rad(285), math.rad(65), math.rad(293)),time = 0.3},
		{frame = CFrame.new(0.61, -0.41, 0.6) * CFrame.Angles(math.rad(210), math.rad(70), math.rad(3)),time = 0.2},
	},
}
local viewmodel = workspace.Camera.Viewmodel.RightHand.RightWrist
local weld = viewmodel.C0
local oldweld = viewmodel.C0
local function getSelectedAuraAnim()
	if #animTable > 0 then
		for i,v in pairs(AuraAnims) do
			if tostring(i) == AuraAnim.Value then
				return v
			end
		end
	end
	return "None"
end
local auraAnimPlaying = false
Aura = GuiLibrary.Objects.CombatWindow.API.CreateOptionsButton({
	["Name"] = "Aura",
	["Function"] = function(callback)
		if callback then
			wrap(function()
				repeat
					local target = getWeakestClosePlayer(18)
					local Anim = getSelectedAuraAnim()
					local totalAnimTime = 0
					if target ~= nil then
						if Anim ~= "None" and not auraAnimPlaying then
							wrap(function()
								for i,v in pairs(Anim) do
									totalAnimTime += v.time
								end
								for i,v in pairs(Anim) do
									local animation = game:GetService("TweenService"):Create(viewmodel,TweenInfo.new(v.time),{C0 = oldweld * v.frame})
									animation:Play()
									auraAnimPlaying = true
									animation.Completed:Wait()
								end
								auraAnimPlaying = false
							end)
						end
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
					else
						local animation = game:GetService("TweenService"):Create(viewmodel,TweenInfo.new(0.15),{C0 = oldweld})
						animation:Play()
					end
					task.wait(0.12)
				until not Aura.Enabled
			end)
		end
	end,
	ArrayText = function() return "18" end
})
animTable = {}
for i,v in pairs(AuraAnims) do
	table.insert(animTable,tostring(i))
end
if #animTable > 0 then
	AuraAnim = Aura.CreateSelector({
		Name = "Anim",
		Function = function(value) end,
		List = animTable
	})
end

Velocity = GuiLibrary.Objects.CombatWindow.API.CreateOptionsButton({
	["Name"] = "Velocity",
	["Function"] = function(callback) 
		if callback then
			events.Knockback.kbUpwardStrength = 0
			events.Knockback.kbDirectionStrength = 0
		else
			events.Knockback.kbUpwardStrength = 100
			events.Knockback.kbDirectionStrength = 100
		end
	end,
})

AutoSprint = GuiLibrary.Objects.CombatWindow.API.CreateOptionsButton({
	["Name"] = "AutoSprint",
	["Function"] = function(callback) 
		wrap(function()
			repeat
				pcall(function()
					if lplr.Character ~= nil and lplr.Character.Humanoid.Health ~= 0 then
						events["SprintController"]:startSprinting()
					end
				end)
				task.wait()
			until not AutoSprint.Enabled
		end)
	end,
})

--Movement

local SpeedEnabled = false
speed = GuiLibrary.Objects.MovementWindow.API.CreateOptionsButton({
	["Name"] = "Speed",
	["Function"] = function(callback) 
		if callback then
			SpeedEnabled = true
			repeat
				lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + lplr.Character.HumanoidRootPart.CFrame.lookVector * 15
				task.wait(1.25)
			until not SpeedEnabled
		else
			SpeedEnabled = false
		end
	end,
	ArrayText = function() return "HeatSeeker" end
})


--[[
CustomSpeed = GuiLibrary.Objects.MovementWindow.API.CreateOptionsButton({
	["Name"] = "CustomSpeed",
	["Function"] = function(callback) 
		if callback then
			
		else
			
		end
	end,
	ArrayText = function() return "Ws" end
})
Teleport = CustomSpeed.CreateToggle({
	Name = "Teleport",
	Function = function(value) end
})
Jump = CustomSpeed.CreateToggle({
	Name = "Jump",
	Function = function(value) end
})]]

local flyConnection
local Flight = {["Enabled"] = false}
Flight = GuiLibrary.Objects.MovementWindow.API.CreateOptionsButton({
	["Name"] = "Flight",
	["Function"] = function(callback) 
		if callback then
			wrap(function()
				flyConnection = game["Run Service"].Heartbeat:Connect(function(delta)
					lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X,0.1 * delta,lplr.Character.PrimaryPart.Velocity.Z)
					if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
						lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X,60,lplr.Character.PrimaryPart.Velocity.Z)
					end
					if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
						lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X,-60,lplr.Character.PrimaryPart.Velocity.Z)
					end
					task.wait()
				end)
			end)
		else
			if flyConnection then
				flyConnection:Disconnect()
			end
		end
	end,
	ArrayText = function() return "Velo" end
})


Highjump = GuiLibrary.Objects.MovementWindow.API.CreateOptionsButton({
	["Name"] = "HighJump",
	["Function"] = function(callback) 
		wrap(function()
			repeat
				lplr.character.HumanoidRootPart.Velocity = lplr.character.HumanoidRootPart.Velocity + Vector3.new(0,10,0)
				wait(0.0001)
				lplr.character.HumanoidRootPart.Velocity = lplr.character.HumanoidRootPart.Velocity + Vector3.new(0,20,0)
			until not Highjump.Enabled
		end)
	end,
	ArrayText = function() return "Velo" end
})

Longjump = GuiLibrary.Objects.MovementWindow.API.CreateOptionsButton({
	["Name"] = "LongJump",
	["Function"] = function(callback) 
		if callback then
			game.Workspace.Gravity = 0
			for i = 1, 4 do
				if Teleport["Enabled"] then
					lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + lplr.Character.HumanoidRootPart.CFrame.lookVector * 3
				else
					lplr.character.HumanoidRootPart.Velocity = lplr.character.HumanoidRootPart.Velocity + Vector3.new(0,1,0)
				end
				task.wait(0.35)
			end
			task.wait(0.3)
			wrap(function()
				Longjump.Toggle()
			end)
		else
			game.Workspace.Gravity = 196.2
		end
	end,
})

--Miscellaneous

NoFall = GuiLibrary.Objects.MiscellaneousWindow.API.CreateOptionsButton({
	["Name"] = "NoFall",
	["Function"] = function(callback) 
		pcall(function()
			repeat
				events["GroundHit"]:FireServer()
				task.wait(0.03)
			until not NoFall.Enabled
		end)
	end,
	ArrayText = function() return "Packet" end
})

Gravity = GuiLibrary.Objects.WorldWindow.API.CreateOptionsButton({
	["Name"] = "Gravity",
	["Function"] = function(callback) 
		if callback then
			wrap(function()
				repeat task.wait()
					game.Workspace.Gravity = GravityAmount["Value"]
				until not Gravity.Enabled
			end)
		else
			game.Workspace.Gravity = 196.2
		end
	end,
})
GravityAmount = Gravity.CreateSlider({
	Name = "GravityAmount",
	Function = function(value) end,
	Min = 0,
	Max = 196.2,
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

-- config load
task.wait(3)
GuiLibrary["LoadConfig"](GuiLibrary["CurrentConfig"])
