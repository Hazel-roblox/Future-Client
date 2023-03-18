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

--modules

--Combat


local binds = {}
local boundParts = {}

function binds:BindPartToTouch(part,whitelisted,func)
    boundParts[part.Name] = part.Touched:Connect(function(hit)
        local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
        if whitelisted and plr == lplr or not whitelisted then
            func()
        end
    end)
end

function binds:BindToPlayerJoin(func,name)
    joinEvents[name] = func
end
function binds:UnbindFromPlayerJoin(func,name)
    joinEvents[name] = nil
end

function binds:UnBindPartFromTouch(part)
    pcall(function() boundParts[part.Name]:Disconnect() end)
    boundParts[part.Name] = nil
end

local function getMaxValue(val,val2)
    return val / val2
end

function binds:RepeatForTime(time,delay,func,afterfunc)
    local currentTime = 0
    repeat task.wait(delay)
        currentTime += getMaxValue(time,delay)
        func()
    until currentTime == time
    afterfunc()
end

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

local function spoofHand(item)
    if hasItem(item) then
        game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SetInvItem:InvokeServer({
            ["hand"] = getInv()[item]
        })
    end
end
function nearestUserToPosition(max,pos)
    if max == nil then max = math.huge end
    local closestDistance = math.huge
    local closestPlayer = nil
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= lplr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - pos).Magnitude
            if distance < closestDistance and distance < max and player.Character.Humanoid.Health > 0.1 and player.Team ~= lplr.Team then
                closestDistance = distance
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end
function nearestUserToMouse(max)
    return nearestUserToPosition(max,lplr:GetMouse().Hit.p)
end

local anim = {val = CFrame.new(1, -2, 1) * CFrame.Angles(math.rad(310), math.rad(60), math.rad(270))}
local viewmodel = workspace.Camera.Viewmodel.RightHand.RightWrist
local weld = viewmodel.C0
local oldweld = viewmodel.C0
local function CFrameAnimate(cframe)
    for i,v in pairs(cframe) do
        TweenService:Create(viewmodel,TweenInfo.new(0.3),{C0 = oldweld * v}):Play()
    end
end
local function CFrameAnimate2(cframe)
    TweenService:Create(viewmodel,TweenInfo.new(0.3),{C0 = oldweld}):Play()
end

local function alive(plr)
    if plr == nil then plr = lplr end
    if not plr.Character then return false end
    if not plr.Character.Head then return false end
    if not plr.Character.Humanoid then return false end
    if plr.Character.Humanoid.Health < 0.1 then return false end
    return true
end

function nearestUser(max)
    if max == nil then max = math.huge end
    local closestDistance = math.huge
    local closestPlayer = nil
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= lplr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - lplr.Character.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance and distance < max and player.Character.Humanoid.Health > 0.1 and player.Team ~= lplr.Team then
                closestDistance = distance
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

function nearestUser2(max)
    if max == nil then max = math.huge end
    local closestDistance = math.huge
    local closestPlayer = nil
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= lplr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - lplr.Character.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance and distance < max and player.Team ~= lplr.Team then
                closestDistance = distance
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

local aurabind
wrap(function()
    local AuraToggle = false
	local animrunning = false
	local lasthit = 0
	local function starthittimer()
		runfunc(function()
			for i = 1,5 do task.wait(0.025)
				lasthit -= 1
			end
		end)
	end
	local function IsFirstPerson()
		return (lplr.Character:WaitForChild("Head").CFrame.p - workspace.CurrentCamera.CFrame.p).Magnitude < 2
	end
    local SwordEvent = {
        SwordController = knit.Controllers["SwordController"]
    }
    Aura = GuiLibrary.Objects.CombatWindow.API.CreateOptionsButton({
        ["Name"] = "Aura",
        ["Function"] = function(callback) 
            if callback then
                pcall(function()
                    AuraToggle = true
                    local function StartAura()
                        if not AuraToggle then return end
                        runfunc(function()
                            aurabind = game:GetService("RunService").RenderStepped:Connect(function()
                                local nearest = nearestUser(20)
                                if nearest and nearest.Character and nearest.Character.Humanoid.Health > 0 then
                                    if getPriority(nearest.UserId) <= getPriority(lplr.UserId) then
                                        runfunc(function()
                                            local sword = getBestWeapon()
                                            game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SwordHit:FireServer({
                                                ["chargedAttack"] = {
                                                    ["chargeRatio"] = 0.8
                                                },
                                                ["entityInstance"] = nearest.Character,
                                                ["validate"] = {
                                                    ["targetPosition"] = {
                                                        ["value"] = nearest.Character.PrimaryPart.Position
                                                    },
                                                    ["selfPosition"] = {
                                                        ["value"] = lplr.Character.PrimaryPart.Position
                                                    }
                                                },
                                                ["weapon"] = sword
                                            })
                                        end)
                                        runfunc(function()
                                            if IsFirstPerson() then
                                                if not animrunning then
                                                    animrunning = true
                                                    CFrameAnimate(anim)
                                                    task.wait(0.29)
                                                    animrunning = false
                                                    CFrameAnimate2()
                                                end
                                            else
                                                SwordEvent["SwordController"]:swingSwordAtMouse()
                                            end
                                        end)
                                    end
                                end
                            end)
                        end)
                    end
				    StartAura()
                end)
			else
				AuraToggle = false
				pcall(function()
					aurabind:Disconnect()
				end)
			end
        end,
        ArrayText = function() return "18" end
    })
end)

wrap(function()
    local SprintEvent = {
        SprintController = knit.Controllers["SprintController"]
    }
    AutoSprint = GuiLibrary.Objects.CombatWindow.API.CreateOptionsButton({
        ["Name"] = "AutoSprint",
        ["Function"] = function(callback) 
            wrap(function()
                repeat task.wait()
                     SprintEvent["SprintController"]:startSprinting()
                 until not AutoSprint.Enabled
             end)
        end,
        ArrayText = function() return "Packet" end
    })
end)

--Movement

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
	ArrayText = function() return "Bw" end
})

--Miscellaneous

NoFall = GuiLibrary.Objects.MiscellaneousWindow.API.CreateOptionsButton({
    ["Name"] = "NoFall",
    ["Function"] = function(callback) 
        pcall(function()
            repeat
                game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit:FireServer()
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
