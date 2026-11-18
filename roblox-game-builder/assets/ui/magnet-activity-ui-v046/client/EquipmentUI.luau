local Players=game:GetService('Players')
local StarterGui=game:GetService('StarterGui')
local Shared=game.ReplicatedStorage.MagnetWorkshop.Shared
local Assets=require(Shared.ApprovedAssets)
local C=require(Shared.Config)
local player=Players.LocalPlayer
local U={}
local views={} local options
local backpackEnabled=nil
local function findTool()
    for _,container in {player.Character,player:FindFirstChild('Backpack')} do if container then
        for _,t in container:GetChildren() do if t:IsA('Tool') and t:GetAttribute('MagnetEquipment') then return t end end
    end end
end
function U.equipped() local t=findTool() return t~=nil and t.Parent==player.Character end
local function icon(parent,size,pos)
    local f=Instance.new('ViewportFrame') f.Name='MagnetIcon' f.Size=size f.Position=pos f.BackgroundTransparency=1 f.Ambient=Color3.fromRGB(190,190,190) f.LightColor=Color3.new(1,1,1) f.Parent=parent
    local world=Instance.new('WorldModel') world.Parent=f local m=Assets.magnet() m.Parent=world
    local cam=Instance.new('Camera') cam.CFrame=CFrame.lookAt(Vector3.new(2,1.8,2.5),Vector3.new(0,.25,0)) cam.FieldOfView=38 cam.Parent=f f.CurrentCamera=cam
end
local function button(parent,size,pos)
    local b=Instance.new('TextButton') b.Size=size b.Position=pos b.BackgroundColor3=C.palette.ink b.TextColor3=C.palette.paper b.Font=Enum.Font.GothamBold b.TextSize=14 b.BorderSizePixel=0 b.Parent=parent
    local corner=Instance.new('UICorner') corner.CornerRadius=UDim.new(0,9) corner.Parent=b
    b.Activated:Connect(function() if options.canToggle() then options.toggle() end end)
    return b
end
function U.row(parent)
    local row=Instance.new('Frame') row.Name='MagnetEquipment' row.Size=UDim2.new(1,-8,0,106) row.BackgroundColor3=Color3.fromRGB(229,221,207) row.BorderSizePixel=0 row.Parent=parent
    icon(row,UDim2.fromOffset(64,64),UDim2.fromOffset(2,2))
    local title=Instance.new('TextLabel') title.Name='Description' title.Position=UDim2.fromOffset(70,2) title.Size=UDim2.new(1,-74,0,56) title.BackgroundTransparency=1 title.Font=Enum.Font.GothamMedium title.TextSize=14 title.TextColor3=C.palette.ink title.TextWrapped=true title.TextXAlignment=Enum.TextXAlignment.Left title.Parent=row
    local b=button(row,UDim2.new(1,-16,0,36),UDim2.fromOffset(8,64)) b.Name='EquipMagnet'
    table.insert(views,{row=row,title=title,button=b})
end
function U.refresh()
    local equipped=U.equipped() local t=findTool() local level=t and t:GetAttribute('ToolLevel') or 1
    -- Roblox owns hotbar layout, selection, and keyboard/touch/gamepad input.
    local enabled=options.showHotbar()
    if backpackEnabled~=enabled then
        local ok=pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,enabled) end)
        if ok then backpackEnabled=enabled end
    end
    for i=#views,1,-1 do local v=views[i] if not v.row.Parent then table.remove(views,i) else
        v.title.Text='Магнит и верёвка '..level..' / 3\nДо '..C.toolLevels[level].maxWeightKg..' кг'
        v.button.Text=equipped and 'Убрать в рюкзак' or 'Взять в руку' v.button.Interactable=options.canToggle()
    end end
end
function U.init(gui,args)
    options=args
    task.spawn(function() while gui.Parent do
        U.refresh() task.wait(.1)
    end end)
end
return U
