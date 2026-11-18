-- Approved starter-location materials, shore boardwalk and sunny cloud backdrop.
local K=require(script.Parent.SceneKit)
local Style=require(script.Parent.SurfaceStyle)
local L=require(script.Parent.StarterLayout)
local P={version='0.3.5'}
local V=Vector3.new local CF=CFrame.new
local function set(p,color,material,finish)
 p.Color=color if material then p.Material=material end
 if finish then p:SetAttribute('SurfaceFinish',finish) end Style.part(p)
end
function P.apply(w)
 assert(not game:GetService('RunService'):IsRunning(),'Bake starter polish in Edit')
 Style.installMaterials()
 local old=w:FindFirstChild('StarterPolish') if old then old:Destroy() end
 local decor=Instance.new('Folder') decor.Name='StarterPolish' decor.Parent=w K.resetNames()
 local ring=K.model(decor,'LakeBoardwalk') ring:SetAttribute('Radius',110) ring:SetAttribute('Width',14) ring:SetAttribute('DeckTop',1.41)
 for i=1,96 do
  local a=(i-1)*math.pi/48 local cf=CF(math.sin(a)*110,0,math.cos(a)*110)*CFrame.Angles(0,a,0)
  local solid=K.block(ring,'RingSupport',V(7.85,.7,14),cf*CF(0,1.045,0),K.wood,Enum.Material.WoodPlanks,true)
  solid.Transparency=1 solid.CastShadow=false
  for j=-1,1 do
   K.block(ring,'RingPlank',V(2.61,.12,14),cf*CF(j*2.6,1.35,0),Color3.fromRGB(181+(i+j)%3*5,128+(i+j)%3*4,79),Enum.Material.WoodPlanks)
  end
  if i%4==0 then for _,r in {-5,5} do
   local p=K.block(ring,'WetSupport',V(1.1,3,1.1),cf*CF(0,-.5,r),Color3.fromRGB(91,72,49),Enum.Material.Wood)
   p:SetAttribute('SurfaceFinish','Bark') Style.part(p)
  end end
  if i%24==0 then task.wait() end
 end
 local function dress(root)
  for _,p in root:GetDescendants() do if p:IsA('BasePart') and not Style.isItem(p) and p.Transparency<1 then
   local name=p.Name local n=math.floor(math.abs(p.Position.X*3+p.Position.Z*7))%7-3
   if name:match('^Bank_') then set(p,Color3.fromRGB(118+n,160+n,66+n),Enum.Material.Grass,'Ground')
   elseif name:match('^RingPath') or name:match('^WorkshopWalk') then set(p,Color3.fromRGB(228+n,209+n,165+n))
   elseif name:match('^Leaf') or name:match('PalmFrond') then set(p,Color3.fromRGB(112+n*2,155+n*2,66+n),Enum.Material.Grass,'Foliage')
   elseif name:match('^Trunk') or name:match('^Root') then set(p,Color3.fromRGB(139+n,95+n,52+n),Enum.Material.Wood,'Bark')
   elseif p:IsA('MeshPart') and p.MeshId==require(script.Parent.EnvironmentAssets).meshes.Rock then set(p,Color3.fromRGB(139+n*2,149+n*2,132+n),Enum.Material.Slate,'Stone')
   elseif p.Material==Enum.Material.WoodPlanks then
    set(p,Color3.fromRGB(179+n*2,126+n,77+n),nil,'Timber')
    if name:match('Plank') then
     local t=p:FindFirstChild('FinishGrain') or Instance.new('Texture') t.Name='FinishGrain' t.Face=Enum.NormalId.Top t.Texture='rbxassetid://9920625290' t.StudsPerTileU=7 t.StudsPerTileV=3 t.Transparency=.83 t.Color3=Color3.fromRGB(144,123,94) t.Parent=p
    end
   end
  end end
 end
 dress(w.RadialShore) dress(ring)
 -- The main-shore dressing only; remote biomes keep their authored palettes.
 for _,m in w.FinishDecor:GetChildren() do if not m.Name:match('^BIO%-') then dress(m) end end
 local moss=K.model(decor,'CliffMoss')
 for _,p in w.RadialShore:GetChildren() do if p:IsA('MeshPart') and p.MeshId==require(script.Parent.EnvironmentAssets).meshes.Rock then
  local leaf=K.mesh(moss,'LeafTall',V(p.Size.X*.78,.4,p.Size.Z*.64),CF(p.Position+V(0,p.Size.Y*.43,0))*p.CFrame.Rotation,Color3.fromRGB(123,149,75),Enum.Material.Grass)
  leaf:SetAttribute('SurfaceFinish','Foliage') Style.part(leaf)
 end end
 for _,plot in w.Plots:GetChildren() do for _,p in plot:GetDescendants() do if p:IsA('BasePart') and not Style.isItem(p) then
  local n=p.Name
  if n=='BackWall' or n=='SideWall' or n:match('Gable') then set(p,Color3.fromRGB(237,222,185))
  elseif n=='PaintPanel' or n:match('Wainscot') or n:match('Eave') or n=='Lintel' then set(p,Color3.fromRGB(48,119,117))
  elseif n=='RoofLeft' or n=='RoofRight' or n=='RidgeCap' then set(p,Color3.fromRGB(43,81,111),Enum.Material.Slate,'Stone')
  elseif n:match('TimberPost') or n:match('Beam') or n:match('KingPost') or n=='FloorPlank' then set(p,Color3.fromRGB(181,128,77),Enum.Material.WoodPlanks,'Timber') end
 end end end
 w.Lake.Color=Color3.fromRGB(37,151,161) w.Lake.Reflectance=.12
 -- Sparse non-colliding cloud models, above the cliffs and outside the map.
 local clouds=K.model(decor,'Clouds') clouds.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
 for i,row in {{-300,108,-175},{-260,128,180},{270,120,-220},{315,105,130},{0,140,-325},{-80,125,330}} do
  local group=K.model(clouds,'Cloud'..i)
  for j=-2,2 do
   local p=K.ball(group,'Puff',V(27,18+(2-math.abs(j))*5,25),CF(row[1]+j*17,row[2]+(2-math.abs(j))*4,row[3]+(j%2)*4),Color3.fromRGB(248,251,255),Enum.Material.SmoothPlastic)
   p.CastShadow=false p:SetAttribute('CloudVisual',true)
  end
 end
 local light=game:GetService('Lighting') light.ClockTime=11.5 light.Brightness=2.4 light.Ambient=Color3.fromRGB(130,145,155) light.OutdoorAmbient=Color3.fromRGB(160,175,185)
 light.ExposureCompensation=0 light.ShadowSoftness=.65 light.EnvironmentDiffuseScale=.7 light.EnvironmentSpecularScale=.5
 local atmosphere=light:FindFirstChild('MagnetAtmosphere') if atmosphere then atmosphere.Density=.1 atmosphere.Haze=.3 atmosphere.Glare=0 end
 K.clearCache() w:SetAttribute('StarterPolishVersion',P.version) w:SetAttribute('BuildVersion',P.version)
 return decor
end
return P
