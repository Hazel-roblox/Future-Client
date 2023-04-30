pcall(function()
error("SUCCESS")
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Hazel-roblox/Hazel-Ware/main/WhitelistLibrary.lua", true))()
local ChatEvents = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")
local messageDoneFiltering = ChatEvents:WaitForChild("OnMessageDoneFiltering")
local players = game:GetService("Players")
local currentplr
local usersFiltered = {}
local doneMessages = {}
local defaultChat = {}
local chatFrame = game:GetService("Players")[game.Players.LocalPlayer.Name].PlayerGui.Chat.Frame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller
for i,v in pairs(game:GetService("Players")[game.Players.LocalPlayer.Name].PlayerGui.Chat:GetDescendants()) do
	table.insert(defaultChat,v)
end
messageDoneFiltering.OnClientEvent:Connect(function(msg)
	
end)
