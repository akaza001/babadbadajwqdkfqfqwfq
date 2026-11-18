local Assets=require(game.ReplicatedStorage.MagnetWorkshop.Shared.ApprovedAssets)
local MapAssets=require(game.ReplicatedStorage.MagnetWorkshop.Shared.MapAssets)
local WorldLabels=require(game.ReplicatedStorage.MagnetWorkshop.Shared.WorldLabels)
local Style=require(game.ReplicatedStorage.MagnetWorkshop.Shared.SurfaceStyle)
local W={}
function W.build()
    assert(not workspace:FindFirstChild('MagnetWorld'),'MagnetWorld already exists; preserve it before rebuilding')
    Style.installMaterials()
    local C=require(game.ReplicatedStorage.MagnetWorkshop.Shared.Config)
    local text=require(game.ReplicatedStorage.MagnetWorkshop.Shared.Strings)
    local P=C.palette
    local root=Instance.new('Model') root.Name='MagnetWorld' root:SetAttribute('BuildVersion','0.3.1') root:SetAttribute('Layout','SingleLake') root.Parent=workspace
    local function folder(name,parent) local f=Instance.new('Folder') f.Name=name f.Parent=parent or root return f end
    local function block(parent,name,size,cf,color,material)
        local p=Instance.new('Part') p.Name=name p.Size=size p.CFrame=cf p.Color=color
        p.Material=material or Enum.Material.SmoothPlastic p.Anchored=true
        p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth Style.part(p) p.Parent=parent return p
    end
    local function label(part,value,width,height)
        local gui=Instance.new('BillboardGui') gui.Name='Label' gui.Size=UDim2.fromOffset(width or 230,height or 60)
        gui.MaxDistance=65 gui.AlwaysOnTop=false gui.Parent=part
        local l=Instance.new('TextLabel') l.Name='Text' l.Size=UDim2.fromScale(1,1) l.BackgroundTransparency=1
        l.Text=value l.TextColor3=P.paper l.Font=Enum.Font.GothamBold l.TextSize=16 l.TextWrapped=true l.Parent=gui
        WorldLabels.apply(gui) return l
    end
    local function prompt(part,action,object)
        local p=Instance.new('ProximityPrompt') p.ActionText=action p.ObjectText=object p.MaxActivationDistance=9
        p.RequiresLineOfSight=false p.HoldDuration=0 p.Parent=part return p
    end
    local shore=folder('Shore')
    local grass=Color3.fromRGB(130,158,112)
    local sand=Color3.fromRGB(210,197,164)
    block(shore,'Foundation',Vector3.new(312,6,380),CFrame.new(0,-9,-70),Color3.fromRGB(90,109,94),Enum.Material.Grass)
    -- One long lake. The public waterfront is at +Z; workshops all face -Z.
    block(shore,'WorkshopBank',Vector3.new(288,3,114),CFrame.new(0,-1,55),grass,Enum.Material.Grass)
    block(shore,'FarBank',Vector3.new(288,3,16),CFrame.new(0,-1,-252),grass,Enum.Material.Grass)
    for _,side in {-1,1} do
        block(shore,'SideBank'..side,Vector3.new(36,3,246),CFrame.new(side*126,-1,-123),grass,Enum.Material.Grass)
    end
    local water=block(root,'Lake',Vector3.new(216,1,244),CFrame.new(0,-.25,-122),P.water)
    water.CanCollide=false water.CanTouch=false water.Transparency=.18
    local promenade=block(shore,'Promenade',Vector3.new(248,.25,34),CFrame.new(0,.64,27),sand,Enum.Material.Sand)
    local lane=block(shore,'WorkshopLane',Vector3.new(248,.25,8),CFrame.new(0,.64,49),sand,Enum.Material.Sand)
    -- Visible, solid enclosure; no barriers across the common casting edge.
    local walls=folder('BoundaryWalls')
    local stone=Color3.fromRGB(108,126,116)
    for _,side in {-1,1} do
        local x=side*148
        block(walls,'SideWall'..side,Vector3.new(8,26,380),CFrame.new(x,13,-70),stone,Enum.Material.Slate)
        block(walls,'GrassCap'..side,Vector3.new(8.6,1,380),CFrame.new(x,26.5,-70),grass,Enum.Material.Grass)
        for z=-244,104,29 do
            block(walls,'Buttress'..side..'_'..z,Vector3.new(2.5,17,4),CFrame.new(side*143,8.5,z),Color3.fromRGB(121,139,127),Enum.Material.Slate)
        end
    end
    block(walls,'FarWall',Vector3.new(296,26,8),CFrame.new(0,13,-260),stone,Enum.Material.Slate)
    block(walls,'FarGrassCap',Vector3.new(296,1,8.6),CFrame.new(0,26.5,-260),grass,Enum.Material.Grass)
    block(walls,'BackWall',Vector3.new(296,18,8),CFrame.new(0,9,116),stone,Enum.Material.Slate)
    block(walls,'BackGrassCap',Vector3.new(296,1,8.6),CFrame.new(0,18.5,116),grass,Enum.Material.Grass)
    local points=folder('ZonePoints')
    for i=1,6 do
        local p=block(points,'Z-01-P'..i,Vector3.new(36,.8,16),CFrame.new(-90+(i-1)*36,1,0),P.wood)
        p:SetAttribute('ZoneId','Z-01')
        prompt(p,text('cast'),'Озеро').Enabled=false
    end
    MapAssets.installPiers(points)
    local plots=folder('Plots')
    for i=1,6 do
        local cf=CFrame.new(-100+(i-1)*40,1,77)
        local plot=Instance.new('Model') plot.Name=string.format('Plot%02d',i)
        plot:SetAttribute('OwnerUserId',0) plot:SetAttribute('CompactWorkshop',true)
        local function b(name,size,pos,color,material) return block(plot,name,size,cf*CFrame.new(pos),color,material) end
        b('Floor',Vector3.new(33.6,.7,28),Vector3.zero,P.wood,Enum.Material.WoodPlanks)
        b('BackWall',Vector3.new(33.6,10,.8),Vector3.new(0,5,14),P.paper)
        for _,side in {-1,1} do
            b('SideWall',Vector3.new(.8,10,28),Vector3.new(side*16.8,5,0),P.paper)
            b('PaintPanel',Vector3.new(.1,2,28),Vector3.new(side*17,5,0),P.water)
        end
        b('Lintel',Vector3.new(32,.22,.12),Vector3.new(0,9.55,-13.9),P.water)
        local entrance=b('Entrance',Vector3.one,Vector3.new(-6,2,-18),P.paper)
        entrance.Transparency=1 entrance.CanCollide=false entrance.CanQuery=false
        local board=b('OwnerBoard',Vector3.new(1,1,.2),Vector3.new(-16.8,6.5,-13.9),P.paper)
        label(board,text('freePlot'),190,50)
        local bench=b('Bench',Vector3.new(6,3,4),Vector3.new(-11,1.85,4.5),P.metal)
        bench:SetAttribute('PlotId',i) prompt(bench,text('browse'),text('bench')) label(bench,text('bench'),160,35)
        b('BenchTop',Vector3.new(6.4,.25,4.4),Vector3.new(-11,3.5,4.5),P.gold)
        local slot=b('CleaningSlot',Vector3.new(4.7,.08,2.8),Vector3.new(-11,3.68,4.77),P.ink)
        slot.CanCollide=false
        local slots=folder('Slots',plot)
        for n=1,12 do
            local pedestal=block(slots,tostring(n),Vector3.new(5,1,5),cf*CFrame.new(12-((n-1)%3)*7,.85,-10.5+math.floor((n-1)/3)*7),P.wood)
            pedestal:SetAttribute('Slot',n) pedestal:SetAttribute('PlotId',i)
            label(pedestal,tostring(n),70,25) pedestal.Label.MaxDistance=18
            prompt(pedestal,text('exhibit'),text('slot',n))
        end
        folder('Exhibits',plot)
        for z=1,3 do
            local plaque=b('Collection'..z,Vector3.new(4,1.8,.13),Vector3.new(-7.7+(z-1)*7.7,6.8,13.51),P.paper)
            local total=0 for _,item in C.items do if item.zone==C.zones[z].id then total+=1 end end
            label(plaque,C.zones[z].name..' 0/'..total,150,38) plaque.Label.MaxDistance=24
        end
        Assets.installBench(plot) MapAssets.installWorkshop(plot) MapAssets.installPedestals(plot)
        plot.WorldPivot=cf plot.Parent=plots
        block(shore,'WorkshopApproach'..i,Vector3.new(8,.25,17),CFrame.new(cf.X-6,.64,57),sand,Enum.Material.Sand)
        task.wait()
    end
    local plaza=folder('Plaza')
    -- Small service counters leave the centre clear between workshops and pier.
    for i,entry in {{'Buyer',-58,P.green,text('buyer')},{'Shop',0,P.gold,text('merchant')},{'Visitors',44,P.water,text('workshops')}} do
        local x=entry[2]
        local p=block(plaza,entry[1],Vector3.new(8,3,4),CFrame.new(x,2.5,34),entry[3])
        label(p,entry[4],190,40) prompt(p,text('browse'),entry[4])
        block(plaza,entry[1]..'Canopy',Vector3.new(12,.6,7),CFrame.new(x,8,35),P.paper)
        for _,dx in {-5,5} do block(plaza,entry[1]..'Post'..dx,Vector3.new(.5,7,.5),CFrame.new(x+dx,4,37),P.wood) end
    end
    require(game.ReplicatedStorage.MagnetWorkshop.Shared.HubAssets).apply(root)
    require(game.ReplicatedStorage.MagnetWorkshop.Shared.EnvironmentAssets).apply(root)
    require(game.ReplicatedStorage.MagnetWorkshop.Shared.BiomeAssets).apply(root)
    require(game.ReplicatedStorage.MagnetWorkshop.Shared.RadialLayout).apply(root)
    local lighting=game:GetService('Lighting') lighting.ClockTime=14 lighting.Brightness=2.5
    lighting.Ambient=Color3.fromRGB(145,161,160) lighting.OutdoorAmbient=Color3.fromRGB(165,178,173)
    local atmosphere=lighting:FindFirstChild('MagnetAtmosphere') or Instance.new('Atmosphere')
    atmosphere.Name='MagnetAtmosphere' atmosphere.Density=.14 atmosphere.Color=Color3.fromRGB(203,228,229) atmosphere.Parent=lighting
    game.StarterPlayer.CameraMinZoomDistance=8 game.StarterPlayer.CameraMaxZoomDistance=24
    game.StarterGui.ScreenOrientation=Enum.ScreenOrientation.LandscapeSensor
    local physics=game:GetService('PhysicsService')
    if not physics:IsCollisionGroupRegistered('MagnetPlayers') then physics:RegisterCollisionGroup('MagnetPlayers') end
    physics:CollisionGroupSetCollidable('MagnetPlayers','MagnetPlayers',false)
    workspace.CurrentCamera.CFrame=CFrame.lookAt(Vector3.new(-220,210,220),Vector3.new(0,0,-55))
    require(game.ReplicatedStorage.MagnetWorkshop.Shared.ShoreAppearance).apply(root)
    require(game.ReplicatedStorage.MagnetWorkshop.Shared.EnvironmentFinish).apply(root)
    require(game.ReplicatedStorage.MagnetWorkshop.Shared.StarterPolish).apply(root)
    require(game.ReplicatedStorage.MagnetWorkshop.Shared.BoardwalkFinish).apply(root)
    require(game.ReplicatedStorage.MagnetWorkshop.Shared.StarterMaterials).apply(root)
    require(game.ReplicatedStorage.MagnetWorkshop.Shared.BiomeFinish).apply(root)
    require(game.ReplicatedStorage.MagnetWorkshop.Shared.BiomeFishing).apply(root)
    require(game.ReplicatedStorage.MagnetWorkshop.Shared.PortalLayout).apply(root)
    Style.apply(root)
    WorldLabels.applyWorld(root)
    return root
end
return W
