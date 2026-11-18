-- Approved hub/portal references 11 Nov 2026; built in Edit and serialized.
local K=require(script.Parent.SceneKit)
local B=require(script.Parent.BiomeCatalog)
local H={version='0.3.1'}
local V=Vector3.new local CF=CFrame.new
local bronze=Color3.fromRGB(151,119,68) local stone=Color3.fromRGB(119,134,124)
local function statue(parent)
 local m=K.model(parent,'Statue') m:SetAttribute('AssetId','A-HUB-STATUE') m:SetAttribute('ReferenceVersion','r02')
 local base=CF(B.center)
 local function p(name,size,x,y,z,col,mat,solid) return K.block(m,name,size,base*CF(x,y,z),col,mat,solid) end
 p('Foot',V(12,1.2,12),0,.6,0,stone,Enum.Material.Slate,true)
 p('Step',V(10.8,1,10.8),0,1.7,0,stone,Enum.Material.Slate,true)
 -- Narrow tiers create a taper without any external mesh dependency.
 for i=1,7 do local w=9.9-i*.24 p('PedestalShaft',V(w,2.08,w),0,2.2+(i-.5)*2.08,0,stone,Enum.Material.Slate,true) end
 p('Crown',V(10.4,1.24,10.4),0,17.38,0,stone,Enum.Material.Slate,true)
 p('BlankPlaque',V(3.5,1.1,.13),0,15.7,4.3,K.gold,Enum.Material.Metal)
 -- Figure faces +Z, toward the workshops. Anatomical right is local -X.
 for _,x in {-1.3,1.3} do
  p('Boot',V(2.25,1.1,3),x,18.55,.3,bronze,Enum.Material.Metal)
  p('Leg',V(2.1,4.5,2.25),x,21.3,0,bronze,Enum.Material.Metal)
 end
 p('Torso',V(4.7,4.4,2.8),0,25.65,0,bronze,Enum.Material.Metal)
 K.cylinder(m,'Head',3.3,3.3,base*CF(0,30,0),bronze,Enum.Material.Metal)
 for _,x in {-.55,.55} do p('Eye',V(.18,.48,.1),x,30.3,1.65,Color3.fromRGB(69,64,44)) end
 for i=1,5 do local a=math.rad(210+i*20) p('Smile',V(.24,.15,.09),math.cos(a)*.67,29.85+math.sin(a)*.5,1.66,Color3.fromRGB(69,64,44)) end
 local shoulderR=V(-3,26.5,0) local elbowR=V(-4,24.7,1) local handR=V(-4.4,25.3,2.5)
 local shoulderL=V(3,26.5,0) local elbowL=V(4.1,25.2,.1) local handL=V(3.4,23.9,2)
 for _,a in {{shoulderR,elbowR},{elbowR,handR},{shoulderL,elbowL},{elbowL,handL}} do K.rod(m,'Arm',base*a[1],base*a[2],1.85,bronze,Enum.Material.Metal) end
 for _,v in {handR,handL} do K.block(m,'Hand',V(1.9,1.7,1.8),base*CF(v),bronze,Enum.Material.Metal) end
 local rope=Color3.fromRGB(126,90,47)
 local points={handR,V(-4.2,24,2.6),V(-4.2,22,2.6)}
 for i=1,2 do K.rod(m,'HangingRope',base*points[i],base*points[i+1],.28,rope,Enum.Material.Wood) end
 local curve={handR,V(-2.4,24.1,2.6),V(0,23.2,2.8),V(2,23.4,2.6),handL}
 for i=1,#curve-1 do K.rod(m,'SlackRope',base*curve[i],base*curve[i+1],.3,rope,Enum.Material.Wood) end
 for i=1,3 do K.ring(m,'Coil',base*CF(3.6,23.1,2.25+i*.23),.8,1.15,.23,rope,12) end
 K.ring(m,'Eyelet',base*CF(-4.2,21.8,2.6),.32,.4,.16,K.metal,10)
 K.cylinder(m,'DiskMagnet',.65,2.3,base*CF(-4.2,21.1,2.6),Color3.fromRGB(207,158,45),Enum.Material.Metal)
 K.cylinder(m,'WorkingFace',.13,2.12,base*CF(-4.2,20.7,2.6),K.metal,Enum.Material.Metal)
 m.WorldPivot=base m:SetAttribute('FeetHeight',B.center.Y+18) m:SetAttribute('MagnetBottomHeight',B.center.Y+20.6)
 return m
end
local function portal(parent,d,cf)
 local m=K.model(parent,d.id) m:SetAttribute('AssetId','A-PORTAL-'..d.id) m:SetAttribute('ReferenceVersion','r01') m:SetAttribute('BiomeId',d.id)
 local t=d.theme local color=K.stone local mat=Enum.Material.Slate local accent=d.water
 if t=='forest' or t=='swamp' then color=t=='forest' and K.wood or Color3.fromRGB(91,85,61) mat=Enum.Material.WoodPlanks
 elseif t=='ice' then color=Color3.fromRGB(179,202,216) accent=Color3.fromRGB(94,220,238)
 elseif t=='volcano' then color=Color3.fromRGB(61,61,68) accent=Color3.fromRGB(244,134,51)
 elseif t=='oasis' then color=Color3.fromRGB(217,187,126) accent=Color3.fromRGB(182,139,57)
 elseif t=='mushroom' then color=Color3.fromRGB(70,72,99) accent=Color3.fromRGB(168,119,229)
 elseif t=='crystal' or t=='factory' then color=K.metal mat=Enum.Material.Metal
 elseif t=='sky' then color=K.paper accent=K.gold end
 local function p(name,size,x,y,z,c,ma,solid) return K.block(m,name,size,cf*CF(x,y,z),c or color,ma or mat,solid) end
 local round=t=='crystal'
 for _,side in {-1,1} do
  p('Foot',V(3.1,.8,3.4),side*5.4,.4,0,K.stone,Enum.Material.Slate,true)
  if not round then p('Post',V(2.1,8.4,2.1),side*5.3,5,0,nil,nil,true) end
 end
 if round then K.ring(m,'Hoop',cf*CF(0,7,0),5.2,6,1.5,color,20)
 else
  for i=1,7 do local a=(i-1)*math.pi/7 local b=i*math.pi/7
   K.rod(m,'Arch',cf*V(math.cos(a)*5.3,9+math.sin(a)*3.4,0),cf*V(math.cos(b)*5.3,9+math.sin(b)*3.4,0),2.1,color,mat)
  end
 end
 local veil=p('Energy',V(8.3,10,.12),0,5.6,0,accent,Enum.Material.SmoothPlastic) veil.Transparency=.74 veil.CastShadow=false
 for _,side in {-1,1} do
  p('Inset',V(.2,7.5,.15),side*4.21,5.5,1.1,accent,Enum.Material.Neon)
  p('Band',V(2.3,.45,2.3),side*5.3,3.3,0,K.metal,Enum.Material.Metal)
 end
 if t=='forest' then
  for _,side in {-1,1} do for i=1,3 do K.mesh(m,'LeafTall',V(2.8,1.2,2),cf*CF(side*6,4+i*1.6,0),Color3.fromRGB(88,132,64),Enum.Material.Grass) end end
  K.cylinder(m,'MagnetEmblem',.4,2.2,cf*CF(0,12.7,1.15)*CFrame.Angles(math.pi/2,0,0),K.gold,Enum.Material.Metal)
 elseif t=='ice' then
  for _,x in {-5.3,0,5.3} do p('Snow',V(3,.65,2.6),x,x==0 and 13 or 9.5,0,Color3.fromRGB(231,241,244)) end
  for _,x in {-6.7,6.7} do K.crystal(m,cf*CF(x,.6,0),3,accent) end
 elseif t=='jungle' then
  for _,s in {-1,1} do local chain={V(s*5.8,1,1.2),V(s*6,5,1.2),V(s*4.6,8,1.2),V(s*4.4,11,1.2)} for i=1,3 do K.rod(m,'Vine',cf*chain[i],cf*chain[i+1],.45,Color3.fromRGB(99,119,65),Enum.Material.Wood) end
   for i=1,3 do K.ball(m,'Leaf',V(1.6,.7,.7),cf*CF(s*6,2+i*2,1.4),Color3.fromRGB(87,136,65)) end
  end
 elseif t=='volcano' then
  for _,s in {-1,1} do for i=1,3 do p('GlowingSeam',V(.18,2,.15),s*5.35,2+i*2.5,1.1,accent,Enum.Material.Neon) end end
 elseif t=='swamp' then
  for _,s in {-1,1} do K.rod(m,'Chain',cf*V(s*6.8,9,0),cf*V(s*6.8,7,0),.18,K.metal,Enum.Material.Metal) K.lamp(m,cf*CF(s*6.8,6.3,0),Color3.fromRGB(146,213,113),1) end
 elseif t=='oasis' then
  for _,s in {-1,1} do for _,y in {2,8,10} do p('BrassInlay',V(2.3,.18,2.3),s*5.3,y,0,K.gold,Enum.Material.Metal) end end
 elseif t=='mushroom' then K.mushroom(m,cf*CF(-6,.8,0),7,accent) K.mushroom(m,cf*CF(6,.8,0),4,accent)
 elseif t=='crystal' then K.crystal(m,cf*CF(-6.2,.8,0)*CFrame.Angles(0,0,.12),5,Color3.fromRGB(89,210,228)) K.crystal(m,cf*CF(6.2,.8,0)*CFrame.Angles(0,0,-.16),4.6,Color3.fromRGB(219,140,195))
 elseif t=='factory' then
  for _,s in {-1,1} do local gear=cf*CF(s*6.1,10,1.2) K.ring(m,'Gear',gear,1.6,1.6,.5,Color3.fromRGB(160,101,58),12)
   for i=1,8 do local a=i*math.pi/4 K.block(m,'Tooth',V(.6,.7,.5),gear*CF(math.cos(a)*1.85,math.sin(a)*1.85,0)*CFrame.Angles(0,0,a),K.gold,Enum.Material.Metal) end
   for i=1,3 do p('Hazard',V(.45,.14,2.8),s*5.4+(i-2)*.75,.86,0,i%2==0 and K.metal or K.gold,Enum.Material.Metal) end
  end
 elseif t=='sky' then
  for _,s in {-1,1} do for i=1,3 do K.block(m,'Wing',V(2.3,.5,.6),cf*CF(s*(5.8+i*.45),10+i*.55,0)*CFrame.Angles(0,0,s*.4),K.gold,Enum.Material.Metal) end
   for i=1,3 do K.ball(m,'Cloud',V(2.1,1.2,1.7),cf*CF(s*(5.2+i*.5),1.2+i*.3,1),K.paper) end
  end
 end
 K.lamp(m,cf*CF(-6.8,6,0),t=='mushroom' and accent or nil,.65)
 local trigger=K.marker(m,'PortalPoint',cf*CF(0,3,2.4)) trigger:SetAttribute('PortalId',d.id) trigger:SetAttribute('CaptionTop',cf.Y+14)
 K.caption(trigger,d.name,d.id=='BIO-01' and 'Войти' or 'Скоро',cf.Y+14)
 local prompt=Instance.new('ProximityPrompt') prompt.ObjectText=d.name prompt.ActionText='Выбрать' prompt.MaxActivationDistance=9 prompt.RequiresLineOfSight=false prompt.Enabled=false prompt.Parent=trigger
 m.WorldPivot=cf return m
end
H.portal=portal
function H.expandLayout(world)
 if world:GetAttribute('HubLayoutVersion')==H.version then return end
 local shore=world.Shore
 for _,plot in world.Plots:GetChildren() do plot:PivotTo(plot:GetPivot()+V(0,0,100)) end
 for i=1,6 do local p=shore:FindFirstChild('WorkshopApproach'..i) if p then p.CFrame+=V(0,0,100) end end
 shore.WorkshopBank.Size+=V(0,0,120) shore.WorkshopBank.CFrame+=V(0,0,60)
 shore.Foundation.Size+=V(0,0,120) shore.Foundation.CFrame+=V(0,0,60)
 shore.WorkshopLane.CFrame+=V(0,0,100)
 for _,p in world.BoundaryWalls:GetChildren() do if p:IsA('BasePart') then
  if p.Name:match('^SideWall') or p.Name:match('^GrassCap') then p.Size+=V(0,0,120) p.CFrame+=V(0,0,60)
  elseif p.Name=='BackWall' or p.Name=='BackGrassCap' then p.CFrame+=V(0,0,120) end
 end end
 for _,row in {{'Buyer',-70,130},{'Shop',70,130},{'Visitors',110,130}} do
  local p=world.Plaza[row[1]] local delta=V(row[2]-p.Position.X,0,row[3]-p.Position.Z)
  for _,v in world.Plaza:GetChildren() do if v:IsA('BasePart') and v.Name:sub(1,#row[1])==row[1] then v.CFrame+=delta end end
 end
 world:SetAttribute('HubLayoutVersion',H.version)
end
-- Reposition the existing approved models using their real marker frame (XML-safe).
function H.relayoutPortals(world)
 local hub=world.PortalHub local angles=require(script.Parent.StarterLayout).portalAngles
 for _,m in hub.Portals:GetChildren() do if not B.byId[m.Name] then m:Destroy() end end
 for i,d in B.list do
  local m=assert(hub.Portals:FindFirstChild(d.id)) local marker=m.PortalPoint
  local base=marker.CFrame*CF(0,-3,-2.4) local a=math.rad(angles[i])
  local pos=V(math.sin(a)*B.radius,base.Y,math.cos(a)*B.radius)
  local target=CFrame.lookAt(pos,V(0,pos.Y,0))
  m:PivotTo(target*base:Inverse()*m:GetPivot())
  marker:SetAttribute('CaptionTop',marker.Position.Y+11)
  m:SetAttribute('LayoutAngle',angles[i])
 end
 hub:SetAttribute('PortalLayoutVersion','0.4.0')
end
function H.apply(world)
 assert(not game:GetService('RunService'):IsRunning(),'Build hub in Edit')
 H.expandLayout(world) K.resetNames()
 local old=world:FindFirstChild('PortalHub') local hub=K.model(nil,'PortalHub')
 K.cylinder(hub,'Plaza',.35,108,CF(B.center+V(0,.2,0)),Color3.fromRGB(172,177,159),Enum.Material.Slate,true)
 K.block(hub,'MainWalk',V(14,.28,132),CF(0,.85,72),Color3.fromRGB(199,195,175),Enum.Material.Slate,true)
 for i=1,24 do local a=i*math.pi/12
  K.block(hub,'BorderPaver',V(8,.25,2),CF(B.center+V(math.sin(a)*52,.55,math.cos(a)*52))*CFrame.Angles(0,a,0),stone,Enum.Material.Slate)
 end
 statue(hub)
 local portals=K.model(hub,'Portals')
 local angles=require(script.Parent.StarterLayout).portalAngles
 for i,d in B.list do local a=math.rad(angles[i]) local pos=B.center+V(math.sin(a)*B.radius,0,math.cos(a)*B.radius)
  portal(portals,d,CFrame.lookAt(pos,V(B.center.X,pos.Y,B.center.Z)))
 end
 local arrival=K.marker(hub,'HubArrival',B.hub)
 local neck=K.cylinder(hub.Statue,'Neck',.7,1.4,CF(B.center)*CF(0,28.1,0),bronze,Enum.Material.Metal)
 neck.Name='Neck'
 if old then old:Destroy() end hub.Parent=world
 world:SetAttribute('BuildVersion',H.version) world:SetAttribute('Layout','HubAndActiveBiomes') world:SetAttribute('StudioBiomePreview',true)
 K.clearCache() return hub
end
return H
