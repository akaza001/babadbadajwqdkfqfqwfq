-- Existing user-owned Stud Asset Pack geometry, adapted to the lakeside palette.
-- Loaded in Edit only; Play and exported places use serialized MeshParts.
local Style=require(script.Parent.SurfaceStyle)
local E={version='0.3.0'}
E.meshes={Rock='rbxassetid://93990255748897',Leaf='rbxassetid://122597062134963',Trunk='rbxassetid://99580895179988',LeafTall='rbxassetid://128022257062777'}
local prototypes={}
local function mesh(parent,kind,name,size,cf,color,material)
    if not prototypes[kind] then
        assert(not game:GetService('RunService'):IsRunning(),'Build environment meshes in Edit before Play')
        prototypes[kind]=game:GetService('AssetService'):CreateMeshPartAsync(Content.fromUri(E.meshes[kind]),{CollisionFidelity=Enum.CollisionFidelity.Box})
    end
    local p=prototypes[kind]:Clone() p.Name=name p.Size=size p.CFrame=cf p.Color=color
    p.Material=material p.TextureID='' p.Anchored=true p.CanCollide=false p.CanTouch=false p.CanQuery=false
    p:SetAttribute('SourcePack','Stud Asset Pack! TU+ KL (1).rbxm')
    Style.part(p) p.Parent=parent return p
end
local function block(parent,name,size,cf,color,material)
    local p=Instance.new('Part') p.Name=name p.Size=size p.CFrame=cf p.Color=color p.Material=material
    p.Anchored=true p.CanCollide=false p.CanTouch=false p.CanQuery=false
    Style.part(p) p.Parent=parent return p
end
function E.apply(world)
    assert(not game:GetService('RunService'):IsRunning(),'Environment replacement is Edit-only')
    local shore=assert(world:FindFirstChild('Shore')) local walls=assert(world:FindFirstChild('BoundaryWalls'))
    local old=world:FindFirstChild('EnvironmentVisuals')
    local decor=Instance.new('Folder') decor.Name='EnvironmentVisualsBuilding'
    local trees=Instance.new('Folder') trees.Name='Trees' trees.Parent=decor
    local rocks=Instance.new('Folder') rocks.Name='Rocks' rocks.Parent=decor
    local cliffs=Instance.new('Folder') cliffs.Name='Cliffs' cliffs.Parent=decor
    local foliage={Color3.fromRGB(72,117,74),Color3.fromRGB(91,137,79),Color3.fromRGB(110,150,85),Color3.fromRGB(80,125,69)}
    local stones={Color3.fromRGB(117,129,119),Color3.fromRGB(136,146,132),Color3.fromRGB(98,113,106),Color3.fromRGB(151,157,139)}
    for _,side in {-1,1} do for i=1,9 do
        local seed=(side+2)*100+i local random=Random.new(seed)
        local x,z=side*(119+random:NextNumber(-2,2)),-20-(i-1)*26
        local h=random:NextNumber(10.5,14.5) local yaw=random:NextNumber(-math.pi,math.pi)
        local t=Instance.new('Model') t.Name=string.format('Tree_%s_%02d',side==-1 and 'L' or 'R',i)
        local base=CFrame.new(x,.5,z)*CFrame.Angles(0,yaw,0)
        mesh(t,'Trunk','Trunk',Vector3.new(h*.22,h,h*.22),base*CFrame.new(0,h/2,0),Color3.fromRGB(120,82,52),Enum.Material.Wood)
        mesh(t,i%3==0 and 'LeafTall' or 'Leaf','CrownMain',i%3==0 and Vector3.new(10,5.5,9.4) or Vector3.new(8.6,7.8,8.4),base*CFrame.new(.2,h*.85,0),foliage[i%4+1],Enum.Material.Grass)
        mesh(t,'Leaf','CrownLeft',Vector3.new(6.2,5.7,6.1),base*CFrame.new(-3,h*.69,.1),foliage[(i+1)%4+1],Enum.Material.Grass)
        mesh(t,'Leaf','CrownRight',Vector3.new(5.9,5.5,5.8),base*CFrame.new(3,h*.73,.3),foliage[(i+2)%4+1],Enum.Material.Grass)
        t.WorldPivot=base t:SetAttribute('SourcePack','stud-asset-pack-tu-kl') t.Parent=trees
        local group=Instance.new('Model') group.Name=string.format('RockCluster_%s_%02d',side==-1 and 'L' or 'R',i)
        for j=1,3 do
            local sx=random:NextNumber(2.3,4.5) local sy=sx*random:NextNumber(.48,.72)
            local rx=x+side*4+(j-2)*1.7 local rz=z-8+random:NextNumber(-1.5,1.5)
            mesh(group,'Rock','Boulder'..j,Vector3.new(sx,sy,sx*.86),CFrame.new(rx,.5+sy*.37,rz)*CFrame.Angles(0,random:NextNumber(-math.pi,math.pi),0),stones[(i+j)%4+1],Enum.Material.Slate)
            if j==1 then block(group,'Moss',Vector3.new(sx*.48,.12,sx*.35),CFrame.new(rx,.5+sy*.87,rz),foliage[(i+1)%4+1],Enum.Material.Grass) end
        end
        group.Parent=rocks
    end task.wait() end
    -- Facades stand directly in front of the old solid collision shells.
    local specs={{name='Left',origin=CFrame.new(-143.2,0,-10)*CFrame.Angles(0,math.pi/2,0),length=500,height=26},
        {name='Right',origin=CFrame.new(143.2,0,-10)*CFrame.Angles(0,-math.pi/2,0),length=500,height=26},
        {name='Far',origin=CFrame.new(0,0,-255.2),length=288,height=26},
        {name='Back',origin=CFrame.new(0,0,231.2)*CFrame.Angles(0,math.pi,0),length=288,height=18}}
    for si,spec in specs do
        local region=Instance.new('Model') region.Name=spec.name..'Cliff'
        local random=Random.new(3000+si)
        local count=math.ceil(spec.length/18) local width=spec.length/count
        for column=1,count do
            local x=-spec.length/2+(column-.5)*width
            for layer=1,4 do
                local top=spec.height/4 local y=(layer-.5)*top
                local depth=1.8+random:NextNumber(0,2.2)
                local variation=random:NextInteger(-3,3)
                local shade=Color3.fromRGB(119+layer*3+variation,132+layer*3+variation,120+layer*3+variation)
                -- Slight overlap closes joints without z-fighting coplanar faces.
                local cf=spec.origin*CFrame.new(x,y,(4-layer)*.35)
                block(region,string.format('Stratum_%02d_%d',column,layer),Vector3.new(width+.25,top+.12,depth),cf,shade,Enum.Material.Slate)
            end
            local ledgeHeight=spec.height+random:NextNumber(-.2,1.0)
            block(region,string.format('GrassLedge_%02d',column),Vector3.new(width+.3,.65,4.7),spec.origin*CFrame.new(x,ledgeHeight,.6),foliage[(column+si)%4+1],Enum.Material.Grass)
            if column%3==1 then
                mesh(region,'Rock','Outcrop'..column,Vector3.new(width*.8,5.5,4.8),spec.origin*CFrame.new(x,4,1.8)*CFrame.Angles(0,column*.73,0),stones[(column+si)%4+1],Enum.Material.Slate)
            end
        end
        region.Parent=cliffs task.wait()
    end
    -- Swap only owned scenery. Keep gameplay surfaces, workshops and spawns untouched.
    for _,p in shore:GetChildren() do
        if p.Name:match('^Trunk[-%d]') or p.Name:match('^Crown[-%d]') or p.Name:match('^Rock[-%d]') then p:Destroy() end
    end
    for _,p in walls:GetChildren() do if p:IsA('BasePart') then
        if p:GetAttribute('OriginalTransparency')==nil then p:SetAttribute('OriginalTransparency',p.Transparency) end
        p.Transparency=1
        if p.Name:match('Buttress') or p.Name:match('GrassCap') then p.CanCollide=false p.CanQuery=false end
    end end
    if old then old:Destroy() end
    decor.Name='EnvironmentVisuals' decor:SetAttribute('EnvironmentVersion',E.version) decor.Parent=world
    if not world:FindFirstChild('PortalHub') then world:SetAttribute('BuildVersion',E.version) end
    for _,p in prototypes do p:Destroy() end prototypes={}
    return decor
end
return E
