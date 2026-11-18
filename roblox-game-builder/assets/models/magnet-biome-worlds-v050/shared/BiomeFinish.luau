-- Edit-baked adaptation of the approved biome references and saved SceneKit/Stud assets.
local B=require(script.Parent.BiomeCatalog)
local K=require(script.Parent.SceneKit)
local S=require(script.Parent.SurfaceStyle)
local E=require(script.Parent.EnvironmentAssets)
local F={version='0.5.0'} local V=Vector3.new local CF=CFrame.new
local timber={ice={174,145,104},jungle={167,123,76},volcano={136,108,79},swamp={149,126,87},oasis={191,149,94},mushroom={167,133,104},crystal={175,142,110},sky={198,169,116}}
local waterAlpha={ice=.54,jungle=.49,volcano=.40,swamp=.34,oasis=.59,mushroom=.45,crystal=.65,sky=.61}
local function dress(model,d)
 local n=0
 for _,p in model:GetDescendants() do if p:IsA('BasePart') and p.Transparency<1 and not S.isItem(p) then
  local name=p.Name local finish=nil
  if p.Material==Enum.Material.WoodPlanks then finish='BiomeTimber'
  elseif p.Material==Enum.Material.Wood then finish=(name:match('Trunk') or name:match('^Root') or name:match('^Branch')) and 'BiomeBark' or 'BiomeWood'
  elseif p.Material==Enum.Material.Grass and (name:match('^Leaf') or name:match('Frond')) then finish='BiomeLeaves'
  elseif p.Material==Enum.Material.Slate then
   if d.theme=='ice' and (name:match('^Leaf') or name:match('^Shore')) and p.Color.R>.7 then p.Material=Enum.Material.SmoothPlastic p:SetAttribute('SurfaceFinish',nil)
   else finish='BiomeStone' end
  end
  if finish then p:SetAttribute('SurfaceFinish',finish) end
  if finish=='BiomeTimber' or finish=='BiomeWood' then
   local rgb=timber[d.theme] local variation=math.floor(math.abs(p.Position.X*3+p.Position.Z*7))%5-2
   p.Color=Color3.fromRGB(rgb[1]+variation,rgb[2]+variation,rgb[3]+variation) p.Reflectance=0
  end
  for _,t in p:GetChildren() do if t:IsA('Texture') and (t.Name=='FinishGrain' or t.Name=='FineGrain') then t:Destroy() end end
  S.part(p) n+=1 if n%600==0 then task.wait() end
 end end
end
local function block(folder,name,size,cf,color,material,solid)
 local p=K.block(folder,name,size,cf,color,material,solid) return p
end
function F.apply(world)
 assert(not game:GetService('RunService'):IsRunning(),'Bake biome art in Edit')
 S.installMaterials()
 for _,d in B.list do if d.id~='BIO-01' then
  local model=world.Biomes:FindFirstChild(d.id)
  if model then
   local old=model:FindFirstChild('BiomeFinish') if old then old:Destroy() end
   local folder=K.model(model,'BiomeFinish') folder:SetAttribute('BiomeFinishVersion',F.version) K.resetNames()
   local cf=CF(d.origin) local rgb=timber[d.theme] local wood=Color3.fromRGB(table.unpack(rgb))
   local bedColor=d.theme=='oasis' and Color3.fromRGB(205,183,135) or d.theme=='volcano' and Color3.fromRGB(104,111,113) or d.theme=='mushroom' and Color3.fromRGB(145,150,168) or Color3.fromRGB(164,188,171)
   local bed=K.cylinder(folder,'Lakebed',.4,116,cf*CF(0,-1.8,0),bedColor,Enum.Material.Slate,false) bed.Name='Lakebed'
   local lake=model:FindFirstChild('Lake')
   if lake then lake:SetAttribute('BiomeWaterAlpha',waterAlpha[d.theme] or .5) lake:SetAttribute('BiomeWaterReflectance',.035) lake.Transparency=waterAlpha[d.theme] or .5 lake.Reflectance=.035 lake.CastShadow=false lake:SetAttribute('WaterSurfaceY',.25) end
   -- The old Sky mesh protruded over the water. Keep its art silhouette below the bed.
   if d.theme=='sky' then for _,p in model:GetChildren() do if p:IsA('MeshPart') and p.Size.X>130 then p.CFrame=CF(d.origin+V(0,-28,0))*p.CFrame.Rotation end end end
   for _,x in {-31,31} do
    for _,side in {-1,1} do
     for _,z in {37.8,46.2} do block(folder,'PierPost',V(.65,3,.65),cf*CF(x+side*6,2.1,z),wood,Enum.Material.Wood,true) end
     for _,y in {2.15,3.15} do block(folder,'PierRail',V(.35,.3,8.4),cf*CF(x+side*6,y,42),wood,Enum.Material.Wood,true) end
    end
   end
   local board=K.marker(folder,'LakeSign',cf*CF(8,2,72)) K.caption(board,d.name,'Ловля с двух причалов',6)
   -- Sparse saved-pack stones on the outer bank; landing and pier access remain clear.
   local template=nil for _,p in model:GetDescendants() do if p:IsA('MeshPart') and p.MeshId==E.meshes.Rock then template=p break end end
   if template then for i=1,8 do
    local a=math.rad(75+i*31) local rock=template:Clone() rock.Name='BankStone'..i rock.Size=V(3+i%3,1.8+i%2,3.2) rock.CFrame=cf*CF(math.sin(a)*74,.75,math.cos(a)*74)*CFrame.Angles(0,a,0)
    rock.CanCollide=false rock.CanQuery=false rock.Parent=folder
   end end
   if d.theme=='jungle' then
    local trees={} for _,m in model:GetChildren() do if m:IsA('Model') and m:GetAttribute('TreeTheme')=='jungle' then table.insert(trees,m) end end
    local tree=trees[1]
    if tree then for i=1,5 do
     local a=math.rad(102+i*29) local clone=tree:Clone() clone.Name='JungleTree'..i clone:PivotTo(cf*CF(math.sin(a)*75,.5,math.cos(a)*75)*CFrame.Angles(0,a,0)) clone.Parent=folder
    end end
    for i=1,6 do local x=-43+i*12 local z=-62
     K.rod(folder,'Vine',d.origin+V(x,12,z),d.origin+V(x+.5,5,z),.28,Color3.fromRGB(77,117,56),Enum.Material.Grass,false)
    end
   end
   if d.theme=='sky' then
    for i=1,24 do local a=(i-1)*math.pi/12 local b=i*math.pi/12
     local one=d.origin+V(math.sin(a)*77,2.1,math.cos(a)*77) local two=d.origin+V(math.sin(b)*77,2.1,math.cos(b)*77)
     K.rod(folder,'IslandRail',one,two,.45,wood,Enum.Material.Wood,true)
     block(folder,'IslandPost',V(.6,3.1,.6),CF(one-V(0,.55,0)),wood,Enum.Material.Wood,true)
    end
   end
   if d.theme=='mushroom' or d.theme=='crystal' or d.theme=='swamp' then
    for i,x in {-31,31} do
     local anchor=block(folder,'PierLight',V(.5,.8,.5),cf*CF(x-5,3.3,38),Color3.fromRGB(243,213,153),Enum.Material.Neon,false)
     local light=Instance.new('PointLight') light.Color=Color3.fromRGB(247,216,173) light.Brightness=.7 light.Range=20 light.Shadows=false light.Parent=anchor
    end
   end
   dress(model,d)
   local shore=world:FindFirstChild('FinishDecor') and world.FinishDecor:FindFirstChild(d.id..'_Shore') if shore then dress(shore,d) end
   model:SetAttribute('BiomeFinishVersion',F.version)
   task.wait()
  end
 end end
 world:SetAttribute('BiomeFinishVersion',F.version)
end
return F
