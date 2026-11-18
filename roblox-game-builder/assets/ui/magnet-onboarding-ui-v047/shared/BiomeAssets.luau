local K=require(script.Parent.SceneKit) local B=require(script.Parent.BiomeCatalog)
local A={version='0.3.1'} local V=Vector3.new local CF=CFrame.new
local function fall(m,cf,height,width)
 local f=K.model(m,'Waterfall') f:SetAttribute('SourcePack','waterfall.rbxm') f:SetAttribute('Width',width)
 K.marker(f,'Top',cf*CF(0,height,0)) K.marker(f,'Bottom',cf)
 local sheet=K.block(f,'WaterSheet',V(width,height,.6),cf*CF(0,height/2,0),Color3.fromRGB(97,190,204)) sheet.Transparency=.3 sheet.CastShadow=false
 for i=1,4 do local streak=K.block(f,'FoamStreak',V(width*.07,height*.9,.15),cf*CF((i-2.5)*width*.22,height/2,.4),K.paper) streak.Transparency=.65 end
end
local function arch(m,cf,color,width,height)
 for _,s in {-1,1} do K.block(m,'RuinPillar',V(3,height,3),cf*CF(s*(width/2+1.5),height/2,0),color,Enum.Material.Slate,true) end
 for i=1,7 do local a=(i-1)*math.pi/7 local b=i*math.pi/7
  K.rod(m,'RuinArch',cf*V(math.cos(a)*(width/2+1.5),height+math.sin(a)*width*.35,0),cf*V(math.cos(b)*(width/2+1.5),height+math.sin(b)*width*.35,0),3,color,Enum.Material.Slate)
 end
end
local function wheel(m,cf,r)
 K.ring(m,'Wheel',cf,r,r,.7,K.wood,16)
 for i=1,10 do local a=i*math.pi/5 K.rod(m,'WheelSpoke',cf.Position,cf*V(math.cos(a)*r,math.sin(a)*r,0),.45,K.wood,Enum.Material.Wood)
  K.block(m,'WheelPaddle',V(1,2,2.2),cf*CF(math.cos(a)*r,math.sin(a)*r,0)*CFrame.Angles(0,0,a),K.wood,Enum.Material.WoodPlanks)
 end
end
local function tower(m,cf,color)
 for _,s in {-1,1} do K.block(m,'TowerLeg',V(.6,14,.6),cf*CF(s*2,7,0),color,Enum.Material.Metal) end
 for i=1,4 do K.rod(m,'TowerBrace',cf*V(-2,(i-1)*3.5,0),cf*V(2,i*3.5,0),.3,color,Enum.Material.Metal) end
 K.rod(m,'Antenna',cf*V(0,11,0),cf*V(0,20,0),.25,color,Enum.Material.Metal)
 K.cylinder(m,'RadioDish',.3,4,cf*CF(0,15,0)*CFrame.Angles(.3,0,0),color,Enum.Material.Metal)
end
local function buildBiome(world,d)
 K.resetNames()
 local m=K.model(nil,d.id) m:SetAttribute('BiomeId',d.id) m:SetAttribute('AssetId',d.id..'-ENVIRONMENT') m:SetAttribute('ReferenceVersion',d.id=='BIO-05' and 'r02' or 'r01')
 local o=d.origin local cf=CF(o) local theme=d.theme
 local function p(name,size,x,y,z,color,mat,solid) return K.block(m,name,size,cf*CF(x,y,z),color,mat,solid) end
 local rock=theme=='volcano' and Color3.fromRGB(73,71,78) or theme=='oasis' and Color3.fromRGB(190,159,106) or theme=='crystal' and Color3.fromRGB(104,115,139) or K.stone
 K.cylinder(m,'IslandFoundation',8,158,cf*CF(0,-6,0),rock,Enum.Material.Slate,true)
 local lake=K.cylinder(m,'Lake',1,116,cf*CF(0,-.25,0),d.water) lake.Name='Lake' lake.CanCollide=false lake.Transparency=.16
 -- Tangential, overlapping shore segments leave the water free of colliders.
 for i=1,24 do local a=i*math.pi/12 local rot=cf*CF(math.sin(a)*67,0,math.cos(a)*67)*CFrame.Angles(0,a,0)
  K.block(m,'Shore',V(19,3,25),rot*CF(0,-1,0),d.ground,theme=='oasis' and Enum.Material.Sand or Enum.Material.Grass,true)
  K.block(m,'Walkway',V(18,.2,7),rot*CF(0,.64,0),theme=='oasis' and K.paper or Color3.fromRGB(174,171,149),Enum.Material.Slate,true)
  if i>=9 and i<=18 then
   local h=theme=='crystal' and 24 or theme=='volcano' and 26 or 8+(i%4)*3
   K.mesh(m,'Rock',V(23,h,17),rot*CF(0,h*.3,-5),rock,Enum.Material.Slate)
  end
 end
 for _,x in {-31,31} do K.pier(m,cf*CF(x,0,43)) p('PierApproach',V(14,.6,16),x,.8,54,K.wood,Enum.Material.WoodPlanks,true) end
 p('ArrivalLanding',V(16,.6,14),0,.7,72,K.wood,Enum.Material.WoodPlanks,true)
 local arrival=K.marker(m,'Arrival',d.arrival) arrival:SetAttribute('BiomeId',d.id)
 local returning=K.marker(m,'ReturnPoint',cf*CF(-8,3,72)) returning:SetAttribute('PortalId','HUB') returning:SetAttribute('SourceBiomeId',d.id)
 K.caption(returning,'В хаб','Войди в арку',o.Y+8)
 for _,x in {-11,-5} do p('ReturnArchPost',V(.7,7,.7),x,3.5,72,K.metal,Enum.Material.Metal) end
 p('ReturnArchTop',V(6.7,.7,.7),-8,7,72,K.metal,Enum.Material.Metal)
 local pr=Instance.new('ProximityPrompt') pr.ActionText='Вернуться' pr.ObjectText='Площадь порталов' pr.RequiresLineOfSight=false pr.MaxActivationDistance=9 pr.Enabled=false pr.Parent=returning
 for _,s in {-1,1} do K.block(m,'ArrivalPost',V(.6,6,.6),cf*CF(s*8,3,75),K.wood,Enum.Material.Wood,true) K.lamp(m,cf*CF(s*8,6,75),nil,.9) end
 for i=1,8 do local a=math.rad(35+i*36) local pos=CF(o+V(math.sin(a)*72,.5,math.cos(a)*72))*CFrame.Angles(0,a,0)
  if theme=='oasis' then K.palm(m,pos,14+i%3*2)
  elseif theme=='mushroom' then K.mushroom(m,pos,11+i%3*5,Color3.fromRGB(120+i%3*13,99,168+i%2*16))
  elseif theme=='crystal' then K.crystal(m,pos*CFrame.Angles(0,0,(i%3-1)*.12),12+i%3*5,i%2==0 and Color3.fromRGB(101,203,221) or Color3.fromRGB(214,145,193))
  elseif theme~='factory' and theme~='volcano' then K.tree(m,pos,13+i%3*3,theme=='jungle' and Color3.fromRGB(62,110,55) or Color3.fromRGB(88,118,68),theme)
  elseif theme=='volcano' then K.crystal(m,pos,10+i%3*3,Color3.fromRGB(84,75,77)) end
 end
 if theme=='ice' then
  K.hut(m,cf*CF(-26,3,-52),Color3.fromRGB(137,115,96),Color3.fromRGB(220,234,239)) tower(m,cf*CF(-42,4,-52),K.metal)
  for i=1,7 do local x=-40+i*11 local ice=K.cylinder(m,'IceFloe',.55,5+i%3*2,cf*CF(x,.55,(i%3-1)*16),Color3.fromRGB(201,234,243)) ice.Transparency=.12 end
  for _,x in {-26,-12,5,19,31} do p('IceShelf',V(11,7+(x%4)*2,6),x,5,-52,Color3.fromRGB(114,203,225)) end
  for i=1,3 do local aurora=p('Aurora',V(70,.5,1.5),0,42+i*2,-65,Color3.fromRGB(116,203,181+i*15),Enum.Material.Neon) aurora.Transparency=.62 end
 elseif theme=='jungle' then
  arch(m,cf*CF(18,4,-58),Color3.fromRGB(131,139,109),16,13)
  for i=1,7 do p('OldGate',V(.6,12,.6),10+i*2,10,-58,K.wood,Enum.Material.Wood) end
  wheel(m,cf*CF(36,7,-56),4)
  fall(m,cf*CF(-24,1,-47),18,12)
  for _,x in {-37,-12} do p('WaterfallRock',V(9,21,10),x,10,-51,rock,Enum.Material.Slate) end
 elseif theme=='volcano' then
  p('ResearchPlatform',V(30,2,16),0,3,-47,K.metal,Enum.Material.Metal,true)
  K.hut(m,cf*CF(0,4,-52),Color3.fromRGB(110,113,112),Color3.fromRGB(103,91,80)) tower(m,cf*CF(18,4,-52),K.metal)
  for _,x in {-40,-15,18,38} do p('BasaltFissure',V(.3,14,1),x,12,-65,Color3.fromRGB(231,128,49),Enum.Material.Neon) end
  for _,x in {-34,34} do for i=1,3 do local steam=K.ball(m,'Steam',V(2+i*1.3,2+i,2+i),cf*CF(x,4+i*4,-49),K.paper) steam.Transparency=.8 end end
 elseif theme=='swamp' then
  K.hut(m,cf*CF(20,2,-48)*CFrame.Angles(0,0,.035),Color3.fromRGB(104,94,68),Color3.fromRGB(94,102,61))
  for i=1,7 do p('Boardwalk',V(13,.5,6),-30+i*8,1.2,-42,K.wood,Enum.Material.WoodPlanks,true) end
  for i=1,18 do local a=i*math.pi/9 for j=1,3 do K.rod(m,'Reed',o+V(math.sin(a)*58+j,.5,math.cos(a)*58),o+V(math.sin(a)*58+j,3+j*.45,math.cos(a)*58+.3),.2,d.ground,Enum.Material.Grass) end
   K.ball(m,'Firefly',V(.16,.16,.16),cf*CF(math.sin(a)*56,3+i%3,math.cos(a)*56),Color3.fromRGB(187,223,112),Enum.Material.Neon)
  end
 elseif theme=='oasis' then
  for i=-1,1 do arch(m,cf*CF(i*19,0,-48),Color3.fromRGB(213,188,135),12,10) end
  wheel(m,cf*CF(42,8,-42),7) fall(m,cf*CF(44,1,-38),6,3)
  for _,x in {-45,45} do K.hut(m,cf*CF(x,1,-52),Color3.fromRGB(211,181,124),Color3.fromRGB(184,112,62)) end
 elseif theme=='mushroom' then
  K.hut(m,cf*CF(0,1,-54),Color3.fromRGB(100,113,131),Color3.fromRGB(81,94,123))
  K.mushroom(m,cf*CF(-18,1,-62),32,Color3.fromRGB(124,102,175))
  for i=1,7 do K.ball(m,'Spore',V(.2,.2,.2),cf*CF(-24+i*7,6+i%3*3,-35),Color3.fromRGB(197,162,239),Enum.Material.Neon) end
  for i=1,4 do p('LabShelf',V(9,.4,3),20,2+i*2,-55,K.wood,Enum.Material.Wood) K.cylinder(m,'SampleJar',1.2,1,cf*CF(18+i%2*3,2.8+i*2,-55),Color3.fromRGB(167,128,205),Enum.Material.Neon) end
 elseif theme=='crystal' then
  K.crystal(m,cf*CF(18,2,-48)*CFrame.Angles(0,0,-.12),31,Color3.fromRGB(103,209,227)) K.crystal(m,cf*CF(31,1,-48)*CFrame.Angles(0,0,.2),23,Color3.fromRGB(219,151,198))
  for i=1,9 do local a=math.rad(-65+i*15) local pos=o+V(math.sin(a)*74,22,-math.cos(a)*74)
   K.mesh(m,'Rock',V(25,12,22),CF(pos),rock,Enum.Material.Slate)
  end
  p('MineCart',V(5,3,4),-17,2,67,K.metal,Enum.Material.Metal)
  for _,x in {-20,-14} do p('CartRail',V(.3,.2,15),x,.9,66,K.metal,Enum.Material.Metal) end
  for _,x in {-18,-15} do K.crystal(m,cf*CF(x,3,67),3,d.water) end
 elseif theme=='factory' then
  local rust=Color3.fromRGB(151,96,62)
  p('FactoryRear',V(91,23,2),0,12,-64,Color3.fromRGB(128,91,74),Enum.Material.Slate,true)
  for _,x in {-45,45} do p('FactorySide',V(2,18,32),x,9,-49,Color3.fromRGB(128,91,74),Enum.Material.Slate,true) end
  for _,x in {-30,30} do p('CranePillar',V(3,28,3),x,14,-35,K.gold,Enum.Material.Metal,true) end
  p('CraneBeam',V(65,3,3),0,28,-35,rust,Enum.Material.Metal)
  K.rod(m,'CraneCable',o+V(0,27,-35),o+V(0,7,-35),.3,K.metal,Enum.Material.Metal)
  K.cylinder(m,'CraneMagnet',1,6,cf*CF(0,6,-35),K.gold,Enum.Material.Metal)
  for _,x in {-37,37} do K.cylinder(m,'PipeRiser',12,5,cf*CF(x,6,-20),rust,Enum.Material.Metal) K.cylinder(m,'PipeOutlet',8,5,cf*CF(x,10,-15)*CFrame.Angles(math.pi/2,0,0),rust,Enum.Material.Metal) end
  for _,x in {-30,-10,10,30} do p('FactoryWindow',V(12,6,.2),x,16,-62.8,K.metal,Enum.Material.Metal) end
 elseif theme=='sky' then
  K.mesh(m,'Rock',V(138,40,132),cf*CF(0,-16,0),rock,Enum.Material.Slate)
  K.cylinder(m,'Observatory',12,19,cf*CF(0,6.5,-58),K.paper,nil,true)
  K.ball(m,'ObservatoryDome',V(20,12,20),cf*CF(0,13.2,-58),Color3.fromRGB(80,144,181))
  K.cylinder(m,'DomeTrim',.7,20,cf*CF(0,13,-58),K.gold,Enum.Material.Metal)
  K.cylinder(m,'Telescope',8,2.4,cf*CF(0,18,-55)*CFrame.Angles(.8,0,0),K.gold,Enum.Material.Metal)
  for _,x in {-5,5} do p('ObservatoryWindow',V(2,3,.2),x,8,-48.5,d.water,Enum.Material.Neon) end
  p('ObservatoryDoor',V(3,6,.2),0,3.5,-48.5,K.wood,Enum.Material.Wood)
  for i=1,5 do p('Stair',V(6,1.2,2.5),0,.6+i*.35,-46+i*2,K.paper,nil,true) end
  K.rod(m,'MooringMast',o+V(35,1,-47),o+V(35,19,-47),1,K.wood,Enum.Material.Wood) K.block(m,'Windsock',V(7,2.5,2.5),cf*CF(38,18,-47),d.water)
  for _,x in {-47,47} do fall(m,cf*CF(x,-32,47),32,10) end
  for i=1,9 do local a=i*math.pi*2/9 K.ball(m,'Cloud',V(22,9,15),cf*CF(math.sin(a)*78,-10-i%3*4,math.cos(a)*78),K.paper) end
  for i=1,3 do K.ring(m,'Armillary',cf*CF(-28,8,-54)*CFrame.Angles(0,i*.7,0),5,5,.35,K.gold,16) end
 end
 m.WorldPivot=cf
 local old=world.Biomes:FindFirstChild(d.id) if old then old:Destroy() end
 m.Parent=world.Biomes task.wait() return m
end
function A.buildOne(world,id)
 assert(not game:GetService('RunService'):IsRunning(),'Bake biomes in Edit')
 local d=assert(B.byId[id])
 if not world:FindFirstChild('Biomes') then local f=Instance.new('Folder') f.Name='Biomes' f.Parent=world end
 if id=='BIO-01' then
  local old=world.Biomes:FindFirstChild(id) if old then old:Destroy() end
  local m=K.model(world.Biomes,id) m:SetAttribute('BiomeId',id) m:SetAttribute('AssetId',id..'-ENVIRONMENT') m:SetAttribute('ExistingWorld',true)
  K.marker(m,'Arrival',d.arrival) return m
 end
 return buildBiome(world,d)
end
function A.apply(world)
 local old=world:FindFirstChild('Biomes')
 if old then for _,m in old:GetChildren() do if m:GetAttribute('BiomeId') and not B.byId[m.Name] then m:Destroy() end end end
 for _,d in B.list do A.buildOne(world,d.id) end
 require(script.Parent.WaterfallAssets).apply(world) K.clearCache()
 return world.Biomes
end
return A
