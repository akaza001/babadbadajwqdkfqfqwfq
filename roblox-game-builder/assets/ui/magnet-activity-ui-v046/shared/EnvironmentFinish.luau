-- Edit-baked art pass. Original mesh/normal-map assets remain the source of detail.
local Style=require(script.Parent.SurfaceStyle)
local K=require(script.Parent.SceneKit)
local Catalog=require(script.Parent.BiomeCatalog)
local Layout=require(script.Parent.StarterLayout)
local F={version='0.3.3',grain='rbxassetid://9920625290'}
local V=Vector3.new local CF=CFrame.new
local function themeOf(p)
 local n=p
 while n do local d=Catalog.byId[n.Name] if d then return d.theme,d end n=n.Parent end
 return 'forest',Catalog.byId['BIO-01']
end
local function baseColor(p)
 if p:GetAttribute('FinishBaseR')==nil then p:SetAttribute('FinishBaseR',p.Color.R) p:SetAttribute('FinishBaseG',p.Color.G) p:SetAttribute('FinishBaseB',p.Color.B) end
 return Color3.new(p:GetAttribute('FinishBaseR'),p:GetAttribute('FinishBaseG'),p:GetAttribute('FinishBaseB'))
end
local function noise(p)
 return math.floor(math.abs(p.Position.X*7+p.Position.Z*11+p.Position.Y*13))%9-4
end
local function finish(p,key)
 p:SetAttribute('SurfaceFinish',key) p.Material=Enum.Material[Style.finishes[key][1]] Style.part(p)
end
local function surfaces(w)
 for _,p in w:GetDescendants() do if p:IsA('BasePart') and not Style.isItem(p) then
  local name=p.Name local theme,d=themeOf(p) local c=p.Color local n=noise(p)
  local rock=p:IsA('MeshPart') and p.MeshId==require(script.Parent.EnvironmentAssets).meshes.Rock
  local needsBase=rock or p.Material==Enum.Material.WoodPlanks or (p.Material==Enum.Material.Grass and not name:match('^Leaf') and not name:match('PalmFrond') and not name:match('^Bank_'))
  if needsBase then c=baseColor(p) else for _,key in {'FinishBaseR','FinishBaseG','FinishBaseB'} do p:SetAttribute(key,nil) end end
  if p.Transparency<1 then
   if p:IsA('MeshPart') and p.MeshId==require(script.Parent.EnvironmentAssets).meshes.Rock then
    finish(p,'Stone') p.Color=c:Lerp(Color3.fromRGB(110+n,121+n,116+n),theme=='forest' and .45 or .12) p.Reflectance=0
   elseif name:match('^Trunk') then finish(p,'Bark') p.Reflectance=0
   elseif name:match('^Leaf') or name:match('PalmFrond') then finish(p,'Foliage') p.Reflectance=0
   elseif p.Material==Enum.Material.WoodPlanks then
    finish(p,'Timber') p.Color=c:Lerp(Color3.fromRGB(157+n*2,111+n,71+n),.3) p.Reflectance=0
    if name:match('Plank') then
     local tex=p:FindFirstChild('FinishGrain')
     if not tex then tex=Instance.new('Texture') tex.Name='FinishGrain' tex.Face=Enum.NormalId.Top tex.Texture=F.grain tex.StudsPerTileU=7 tex.StudsPerTileV=3 tex.Transparency=.83 tex.Color3=Color3.fromRGB(144,123,94) tex.Parent=p end
    end
   elseif name:match('^Bank_') then finish(p,'Ground') p.Color=Color3.fromRGB(112+n,146+n,96+n)
   elseif name:match('^RingPath') or name:match('^WorkshopWalk') then p.Color=Color3.fromRGB(197+n,185+n,154+n)
   elseif p.Material==Enum.Material.Slate then finish(p,'Stone') p.Reflectance=0
   elseif p.Material==Enum.Material.Grass then finish(p,'Ground') p.Color=c:Lerp(d.ground,.18)
   end
  end
  if name=='Lake' then
   finish(p,'Water') p.Color=theme=='forest' and Color3.fromRGB(38,127,143) or d.water
   p.Transparency=theme=='swamp' and .09 or theme=='crystal' and .28 or .22 p.Reflectance=.09 p.CastShadow=false
   p:SetAttribute('WaterSurfaceY',p.Position.Y+p.Size.X/2)
  end
  if p.Material==Enum.Material.Neon then p.MaterialVariant='' end
 end end
end
local function distantFromPaths(x,z) return Layout.clearOfAccess(x,z,14) end
function F.apply(w)
 assert(not game:GetService('RunService'):IsRunning(),'Bake environment finish in Edit')
 Style.installMaterials()
 local old=w:FindFirstChild('FinishDecor') if old then old:Destroy() end
 local decor=Instance.new('Folder') decor.Name='FinishDecor' decor.Parent=w
 local trees={}
 for _,m in w:GetDescendants() do if m:IsA('Model') and (m.Name=='Tree' or m.Name:match('^Tree_')) and m:GetAttribute('TreeVisualVersion')~=F.version then
  local trunk=nil for _,p in m:GetChildren() do if p:IsA('MeshPart') and p.Name:match('^Trunk') then trunk=p break end end
  if trunk then table.insert(trees,{model=m,trunk=trunk}) end
 end end
 for _,entry in trees do
  local m,p=entry.model,entry.trunk local h=p.Size.Y local cf=p.CFrame*CF(0,-h/2,0)
  local theme=themeOf(m) local leaf=m:FindFirstChildWhichIsA('MeshPart') local color=Color3.fromRGB(76,122,72)
  for _,part in m:GetChildren() do if part.Name:match('^Leaf') then color=part.Color break end end
  K.resetNames() local replacement=K.tree(nil,cf,h,color,theme) replacement.Parent=m.Parent m:Destroy()
 end
 -- Tall, overlapping outer rock masses form the forest backdrop.
 for _,p in w.RadialShore:GetChildren() do if p:IsA('MeshPart') and p.MeshId==require(script.Parent.EnvironmentAssets).meshes.Rock then
  if p:GetAttribute('CliffBaseHeight')==nil then p:SetAttribute('CliffBaseHeight',p.Size.Y) p:SetAttribute('CliffBaseWidth',p.Size.X) p:SetAttribute('CliffBaseDepth',p.Size.Z) end
  local h=p:GetAttribute('CliffBaseHeight')*(1.65+(math.floor(math.abs(p.Position.X+p.Position.Z))%5)*.13)
  p.Size=V(p:GetAttribute('CliffBaseWidth')*1.08,h,p:GetAttribute('CliffBaseDepth')*1.15)
  p.CFrame=CF(p.Position.X,.5+h*.39,p.Position.Z)*p.CFrame.Rotation
 end end
 K.resetNames()
 local function edge(parent,origin,radius,count,wet)
  for i=1,count do local a=i*math.pi*2/count local x,z=math.sin(a)*radius,math.cos(a)*radius
   local mainShore=parent.Name=='MainLakeShore'
   if (mainShore and Layout.bridgeClear(x,z,9)) or (not mainShore and math.abs(x)>9 and math.abs(z)>9) then
    local width=radius*math.pi*2/count*.85 local cf=CF(origin+V(x,wet and -.02 or .28,z))*CFrame.Angles(0,a,0)
    local p=K.block(parent,wet and 'WetEdge' or 'ShoreFoam',V(width,wet and .28 or .018,wet and 2.2 or .55),cf,wet and Color3.fromRGB(99,114,89) or Color3.fromRGB(170,215,204),wet and Enum.Material.Slate or Enum.Material.SmoothPlastic)
    p.Transparency=wet and .14 or .61 p.CastShadow=false
   end
  end
 end
 local main=K.model(decor,'MainLakeShore') edge(main,V(0,0,0),Layout.lakeRadius,72,true) edge(main,V(0,0,0),Layout.lakeRadius-2,72,false) edge(main,V(0,0,0),Layout.platformRadius+1,40,false)
 K.cylinder(main,'Lakebed',.6,Layout.lakeRadius*2,CF(0,-3.2,0),Color3.fromRGB(43,87,94),Enum.Material.Slate)
 for i=1,48 do
  local a=(i+.37)*math.pi*2/48 local x,z=math.sin(a)*(Layout.outerRadius-15),math.cos(a)*(Layout.outerRadius-15)
  if distantFromPaths(x,z) then
   local group=K.model(decor,string.format('Boulders_%02d',i))
   for j=1,2 do local h=2.1+(i+j)%4*.55 local sx=4+(i+j)%3
    local rock=K.mesh(group,'Rock',V(sx,h,sx*.83),CF(x+j*1.8,.4+h*.38,z-j*.8)*CFrame.Angles(0,i*.7+j,0),Color3.fromRGB(115+i%4*3,126+i%4*2,116),Enum.Material.Slate)
    if j==1 then K.mesh(group,'LeafTall',V(sx*.65,.35,sx*.45),CF(rock.Position+V(0,h*.42,0)),Color3.fromRGB(91,123,72),Enum.Material.Grass) end
   end
  end
 end
 -- Sparse foliage near water; cardinal bridge approaches and workshop routes stay clear.
 for i=1,48 do local a=(i+.45)*math.pi/24 local x,z=math.sin(a)*(Layout.lakeRadius+11),math.cos(a)*(Layout.lakeRadius+11)
  if distantFromPaths(x,z) then
   local g=K.model(decor,'Reeds_'..i)
   for j=1,3 do K.block(g,'GrassBlade',V(.22,1.1+j*.18,.4),CF(x+j*.36,1.05,z)*CFrame.Angles(0,i,(-2+j)*.15),Color3.fromRGB(91+j*6,130+j*3,72),Enum.Material.Grass) end
  end
 end
 for index=2,#Catalog.list do local d=Catalog.list[index] local m=w.Biomes:FindFirstChild(d.id)
  if m then local g=K.model(decor,d.id..'_Shore') edge(g,d.origin,53.5,24,false)
   if d.theme=='forest' or d.theme=='jungle' or d.theme=='swamp' or d.theme=='sky' then
    for i=1,8 do local a=i*math.pi/4 local cf=CF(d.origin+V(math.sin(a)*60,.5,math.cos(a)*60))
     K.mesh(g,'LeafTall',V(3,.8,2.3),cf*CF(0,.3,0),d.ground,Enum.Material.Grass)
    end
   end
  end
  task.wait()
 end
 surfaces(w) K.clearCache()
 w:SetAttribute('EnvironmentFinishVersion',F.version) w:SetAttribute('BuildVersion',Layout.version)
 local lighting=game:GetService('Lighting') lighting.Brightness=2.1 lighting.Ambient=Color3.fromRGB(110,126,119) lighting.OutdoorAmbient=Color3.fromRGB(144,157,148)
 return decor
end
return F
