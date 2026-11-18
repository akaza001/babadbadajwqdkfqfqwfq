-- Shared material setup for the approved pier and the existing lake volume.
-- The walking collider stays unchanged; decoration never blocks input.
local Style=require(script.Parent.SurfaceStyle)
local A={version='0.3.3'}
local woodColors={Color3.fromRGB(173,119,75),Color3.fromRGB(187,137,89),Color3.fromRGB(162,108,69),Color3.fromRGB(193,144,94),Color3.fromRGB(179,127,81)}
local function detail(parent,name,size,cf,color,kind)
    local p=Instance.new('Part') p.Name=name p.Size=size p.CFrame=cf p.Color=color
    p.Material=kind or Enum.Material.SmoothPlastic p.Anchored=true p.CanCollide=false p.CanTouch=false p.CanQuery=false p.CastShadow=false
    p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth Style.part(p) p.Parent=parent return p
end
function A.pier(pier)
    local previous=pier:FindFirstChild('SurfaceDetails') if previous then previous:Destroy() end
    local details=Instance.new('Folder') details.Name='SurfaceDetails'
    local frame=pier:GetPivot()
    for _,p in pier:GetDescendants() do if p:IsA('BasePart') then
        local pos=frame:PointToObjectSpace(p.Position)
        if p.Name=='DeckPlank' then
            local bay=math.floor((pos.X+108)/24) local row=math.floor((pos.Z+8)/2)
            p.MaterialVariant='' p.Material=Enum.Material.Wood p.Color=woodColors[(bay*7+row*3)%#woodColors+1]
            local grain=p:FindFirstChild('FineGrain') if grain then grain:Destroy() end
            for _,x in {-1,1} do for _,z in {-1,1} do
                detail(details,string.format('Nail_%d_%d_%d_%d',bay,row,x,z),Vector3.new(.11,.025,.11),
                    p.CFrame*CFrame.new(x*(p.Size.X/2-.38),p.Size.Y/2+.008,z*(p.Size.Z/2-.34)),Color3.fromRGB(72,73,66),Enum.Material.Metal)
            end end
        elseif p.Name=='EntranceStep' then
            p.MaterialVariant='' p.Material=Enum.Material.Wood p.Color=Color3.fromRGB(190,142,91)
        elseif p.Name=='DeckBeam' or p.Name=='SideBeam' or p.Name=='StairStringer' or p.Name=='Piling' or p.Name=='RailPost' or p.Name=='SideRail' or p.Name=='SignPost' then
            p.MaterialVariant='' p.Material=Enum.Material.Wood p.Color=Color3.fromRGB(150,99,62)
            if p.Name=='Piling' then
                local band=detail(details,string.format('WetPiling_%d',#details:GetChildren()),Vector3.new(p.Size.X+.018,1.25,p.Size.Z+.018),
                    CFrame.new(p.Position.X,.25-1.25/2,p.Position.Z)*p.CFrame.Rotation,Color3.fromRGB(65,76,58))
                band.Material=Enum.Material.Wood
            end
        end
    end end
    details.Parent=pier
    Style.apply(pier) pier:SetAttribute('SurfaceVersion',A.version)
    return details
end
function A.lake(world,mainOnly)
    local previous=world:FindFirstChild('LakeRipples')
    local waves=Instance.new('Folder') waves.Name='LakeRipples'
    if mainOnly and previous then for _,group in previous:GetChildren() do if group:GetAttribute('BiomeId')~='BIO-01' then group.Parent=waves end end end
    if previous then previous:Destroy() end
    local lakes={{id='BIO-01',part=world:FindFirstChild('Lake'),inner=64,outer=104,count=80}}
    local catalog=require(script.Parent.BiomeCatalog)
    local layout=require(script.Parent.StarterLayout)
    local biomes=world:FindFirstChild('Biomes')
    for i=2,(mainOnly and 1 or #catalog.list) do local d=catalog.list[i] local m=biomes and biomes:FindFirstChild(d.id)
        if m and m:FindFirstChild('Lake') then table.insert(lakes,{id=d.id,part=m.Lake,inner=5,outer=49,count=d.theme=='ice' and 12 or 22,definition=d}) end
    end
    for li,entry in lakes do local lake=entry.part if lake then
        lake.Material=Enum.Material.SmoothPlastic lake:SetAttribute('SurfaceFinish',not entry.definition and world:GetAttribute('UniformStarterRelief') and 'StarterSmoothPlastic' or 'Water')
        lake.Color=entry.definition and entry.definition.water or (world:GetAttribute('StarterPolishVersion') and Color3.fromRGB(37,151,161) or Color3.fromRGB(38,127,143))
        lake.Transparency=entry.definition and entry.definition.theme=='swamp' and .09 or entry.definition and entry.definition.theme=='crystal' and .28 or .22 lake.Reflectance=not entry.definition and world:GetAttribute('BoardwalkFinishVersion') and .025 or .09 lake.CastShadow=false
        if not entry.definition and world:GetAttribute('BoardwalkFinishVersion') then lake.Transparency=.68 lake.Color=Color3.fromRGB(70,171,174) end
        if not entry.definition and world:GetAttribute('StarterMaterialsVersion') then lake.Transparency=.66 lake.Color=Color3.fromRGB(62,166,174) lake.Reflectance=.045 end
        local top=lake.Position.Y+(lake.Shape==Enum.PartType.Cylinder and lake.Size.X or lake.Size.Y)/2
        lake:SetAttribute('WaterSurfaceY',top) Style.part(lake)
        local random=Random.new(3300+li)
        for i=1,entry.count do
            local a=random:NextNumber(0,math.pi*2) local r=math.sqrt(random:NextNumber(entry.inner^2,entry.outer^2))
            local x,z=math.sin(a)*r,math.cos(a)*r
            if li~=1 or layout.bridgeClear(x,z,10) then
                local group=Instance.new('Model') group.Name=entry.id..'_Ripple'..i
                local origin=CFrame.new(lake.Position.X+x,top+.028,lake.Position.Z+z)*CFrame.Angles(0,a+.7,0)
                local length=random:NextNumber(1.8,4)
                for n=1,2 do local p=detail(group,'Stroke'..n,Vector3.new(length*(n==1 and 1 or .55),.012,.045),origin*CFrame.new(n==1 and 0 or .3,0,(n-1)*.24),lake.Color:Lerp(Color3.fromRGB(224,240,220),.46)) p.Transparency=(not entry.definition and world:GetAttribute('StarterMaterialsVersion')) and .8 or .73 p:SetAttribute('SurfaceFinish',not entry.definition and world:GetAttribute('StarterMaterialsVersion') and 'StarterSmoothPlastic' or 'Water') Style.part(p) end
                group.WorldPivot=origin group:SetAttribute('BiomeId',entry.id) group:SetAttribute('Phase',random:NextNumber(0,math.pi*2)) group:SetAttribute('Speed',random:NextNumber(.32,.55)) group.Parent=waves
            end
        end
    end end
    waves.Parent=world
end
function A.apply(world)
    A.lake(world)
    local points=world:FindFirstChild('ZonePoints') local piers=points and points:FindFirstChild('ApprovedPiers')
    if piers then for _,pier in piers:GetChildren() do if pier:IsA('Model') then A.pier(pier) end end end
end
return A
