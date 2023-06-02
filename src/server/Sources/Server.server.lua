local HttpService = game:GetService("HttpService")
local Players=game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
Players.CharacterAutoLoads =false

local Datastore2 =require(script.Parent.Parent:WaitForChild("Modules").DataStore2)

local CharacterSelector = ReplicatedStorage:WaitForChild"CharacterSelector"

local Char_Pos =workspace:WaitForChild"Pos"



local DataKey ={
    "Character",
    "Coins"
}

local DataDefault = {
    ["Character"]="Bandit",
    ["Coins"]=0,
}



for i , v in ipairs(DataKey) do
    Datastore2.Combine("Data",v)
end


local Data=Instance.new"Folder"
Data.Parent =ReplicatedStorage
Data.Name = "PlayerDatas"


function LoadCharacter(player)
     --Load Selected Character
     task.delay(2,function()
        print(_G[player.UserId])
        local Sel_Char = CharacterSelector:FindFirstChild(_G[player.UserId][DataKey[1]]:Get())
        print(Sel_Char)
        if Sel_Char and Sel_Char:IsA("Model") then
            local cloned_ = Sel_Char:Clone()
            cloned_.Parent = workspace.Char
            cloned_.PrimaryPart.CFrame = Char_Pos.CFrame
            local AnimControl,Animations = cloned_:FindFirstChildWhichIsA("AnimationController"),cloned_:WaitForChild("Animations")
            if AnimControl and Animations then
                local AppearAnimation=AnimControl:LoadAnimation(Animations:WaitForChild("Selector"))
                local IdleAnim = AnimControl:LoadAnimation(Animations:WaitForChild("Idle"))
                AppearAnimation:Play(0)
                local net
                net = AppearAnimation:GetMarkerReachedSignal("Stop"):Connect(function()
                    print("REACHED")
                    AppearAnimation:Stop(0)
                    IdleAnim:Play(0)
                    net:Disconnect()  
                end)
            end
        else
            warn("Can't not find character")
            player:Kick("Data Error")
        end
    end)
end



Players.PlayerAdded:Connect(function(player)
    _G[player.UserId]={}
    _G[player.UserId]["Data"]={}
    local PlayerData = Instance.new"Folder"
    PlayerData.Parent = Data
    PlayerData.Name = player.Name

    local DataDisplay = Instance.new"StringValue"
    DataDisplay.Name ="Data"
    DataDisplay.Parent = PlayerData

    local DataToEnCode = {}
    for i , keys in ipairs(DataKey) do
        _G[player.UserId][keys]=Datastore2(keys,player)
        DataToEnCode[keys]= _G[player.UserId][keys]:Get()
    end
    local json = HttpService:JSONEncode(DataToEnCode)
    DataDisplay.Value =json
    local function OnUpdate(newValue)
        table.clear(DataToEnCode)
        for i , keys in ipairs(DataKey) do
            _G[player.UserId][keys]=Datastore2(keys,player)
            DataToEnCode[keys]= _G[player.UserId][keys]:Get()
        end
        DataDisplay.Value = HttpService:JSONEncode(DataToEnCode)
    end
    for i , v in ipairs(DataKey) do
        _G[player.UserId][v]:OnUpdate(OnUpdate)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    _G[player.UserId]=nil    
end)