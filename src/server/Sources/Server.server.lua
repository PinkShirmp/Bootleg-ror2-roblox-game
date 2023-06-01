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

Players.PlayerAdded:Connect(function(player)
    _G[player.UserId]={}
    _G[player.UserId]["Data"]={}
    for i , keys in ipairs(DataKey) do
        _G[player.UserId][keys]=Datastore2(keys,player)
        _G[player.UserId]["Data"]=_G[player.UserId][keys]:Get(DataDefault[keys])
    end
    local function OnUpdate() 
        --le funny update
    end
    for i , v in ipairs(DataKey) do
        _G[player.UserId][v]:OnUpdate(OnUpdate)
    end
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
                AnimControl:LoadAnimation(Animations:WaitForChild("Selector")):Play(0)
            end
        else
            warn("Can't not find character")
            player:Kick("Data Error")
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    _G[player.UserId]["Data"]=nil
    _G[player.UserId]=nil    
end)