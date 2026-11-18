-- User-selected square recess normal map. Albedo colors, geometry and physics stay intact.
local S={version='0.5.0',normalMap='rbxassetid://119928944196293',studsPerTile=2,prefix='MW_SquareRelief_'}
S.finishes={Bark={'Wood',1.35},Foliage={'Grass',1.6},Stone={'Slate',2.5},Timber={'WoodPlanks',1.6},Water={'SmoothPlastic',3},Ground={'Grass',2}}
S.baseNames={'Plastic','SmoothPlastic','Wood','WoodPlanks','Metal','Slate','Grass','Sand','Fabric'}
-- A common physical tile scale for all starter-location surfaces.
for _,name in S.baseNames do S.finishes['Starter'..name]={name,2} end
S.finishes.StarterBark={'Wood',2}
S.finishes.StarterLeaves={'Grass',2}
S.albedos={StarterWood='rbxassetid://118637355280789',StarterWoodPlanks='rbxassetid://118637355280789',StarterBark='rbxassetid://99387544784525',StarterSlate='rbxassetid://85528190109653',StarterGrass='rbxassetid://80297686646822',StarterLeaves='rbxassetid://80297686646822'}
for _,name in {'Wood','Timber','Bark','Leaves','Stone'} do
 local base=({Wood='Wood',Timber='WoodPlanks',Bark='Wood',Leaves='Grass',Stone='Slate'})[name]
 S.finishes['Biome'..name]={base,2}
 S.albedos['Biome'..name]=S.albedos[({Wood='StarterWood',Timber='StarterWoodPlanks',Bark='StarterBark',Leaves='StarterLeaves',Stone='StarterSlate'})[name]]
end
function S.installMaterials()
    local service=game:GetService('MaterialService')
    for _,name in S.baseNames do
        local key=S.prefix..name local v=service:FindFirstChild(key)
        if game:GetService('RunService'):IsRunning() then
            assert(v and v:IsA('MaterialVariant'),'Install square relief materials in Edit before Play')
        else
            if not v then v=Instance.new('MaterialVariant') v.Name=key end
            assert(v:IsA('MaterialVariant'),'Material name is occupied: '..key)
            -- Plugin-only properties are authored in Edit and serialized into the place.
            if v.BaseMaterial~=Enum.Material[name] then v.BaseMaterial=Enum.Material[name] end
            for key,value in {ColorMap='',NormalMap=S.normalMap,RoughnessMap='',MetalnessMap='',StudsPerTile=S.studsPerTile,MaterialPattern=Enum.MaterialPattern.Regular} do
                if v[key]~=value then v[key]=value end
            end
            if v.Parent~=service then v.Parent=service end
        end
    end
    for name,spec in S.finishes do
        local key='MW_Finish_'..name local v=service:FindFirstChild(key)
        if game:GetService('RunService'):IsRunning() then assert(v,'Missing finish '..name) else
            if not v then v=Instance.new('MaterialVariant') v.Name=key v.Parent=service end
            if v.BaseMaterial~=Enum.Material[spec[1]] then v.BaseMaterial=Enum.Material[spec[1]] end
            local albedo=S.albedos[name] or ''
            if v.ColorMap~=albedo then v.ColorMap=albedo end
            if v.NormalMap~=S.normalMap then v.NormalMap=S.normalMap end
            if v.StudsPerTile~=spec[2] then v.StudsPerTile=spec[2] end
            v.MaterialPattern=Enum.MaterialPattern.Regular
        end
    end
end
-- Classification is carried by models so bootstrap/rebuild cannot restyle tools.
function S.isItem(p)
    local node=p
    while node do
        if node:IsA('Tool') or node:GetAttribute('SurfaceClass')=='Item' then return true end
        node=node.Parent
    end
    return false
end
function S.part(p)
    if S.isItem(p) then p.MaterialVariant='' return end
    local finish=p:GetAttribute('SurfaceFinish') local spec=finish and S.finishes[finish]
    if spec and p.Material==Enum.Material[spec[1]] then p.MaterialVariant='MW_Finish_'..finish
    elseif table.find(S.baseNames,p.Material.Name) then p.MaterialVariant=S.prefix..p.Material.Name
    else p.MaterialVariant='' end
end
function S.item(root,dirty)
    root:SetAttribute('SurfaceClass','Item')
    root:SetAttribute('MaterialReference','visual-polish-2026-11-11')
    local i=0
    for _,p in root:GetDescendants() do if p:IsA('BasePart') then
        i+=1 p.MaterialVariant=''
        local name=string.lower(p.Name)
        local organic=string.find(name,'rope') or string.find(name,'wood') or string.find(name,'seat') or string.find(name,'bristle')
        local rubber=string.find(name,'wheel') or string.find(name,'cable')
        local dark=p.Color.R+p.Color.G+p.Color.B<.65
        if organic then
            p.Material=string.find(name,'wood') and Enum.Material.Wood or Enum.Material.Fabric
        elseif rubber then p.Material=Enum.Material.SmoothPlastic
        elseif string.find(name,'face') and root.Name~='Magnet' and root.Name~='F-01' then p.Material=Enum.Material.SmoothPlastic
        elseif not dark then
            p.Material=Enum.Material.Metal
            if dirty then
                local tones={Color3.fromRGB(155,78,43),Color3.fromRGB(181,99,53),Color3.fromRGB(124,65,39),Color3.fromRGB(193,118,68)}
                p.Color=tones[(i*7)%#tones+1]
            end
        end
        p.Reflectance=0
    end end
end
function S.apply(root)
    if root:IsA('BasePart') then S.part(root) end
    for _,p in root:GetDescendants() do if p:IsA('BasePart') then S.part(p) end end
end
return S
