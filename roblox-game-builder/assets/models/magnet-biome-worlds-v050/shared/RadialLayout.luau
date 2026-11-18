-- Revised sketch: three pairs of workshops, three spokes and a timber hub deck.
local K=require(script.Parent.SceneKit)
local L=require(script.Parent.StarterLayout)
local R={version=L.version}
function R.apply(w)
 local old=w:FindFirstChild('RadialShore') if old then old:Destroy() end
 for _,name in {'Shore','BoundaryWalls','EnvironmentVisuals','LakeRipples','Lake'} do local p=w:FindFirstChild(name) if p then p:Destroy() end end
 local shore=K.model(w,'RadialShore') K.resetNames()
 local V=Vector3.new local CF=CFrame.new
 local grass=Color3.fromRGB(130,158,112) local stone=Color3.fromRGB(119,134,124)
 -- Overlapping tangential slabs form a continuous annulus without a floor over the lake.
 for i=1,72 do local a=i*math.pi/36 local cf=CF(math.sin(a)*147.5,-1,math.cos(a)*147.5)*CFrame.Angles(0,a,0)
  K.block(shore,'Bank',V(19,3,75),cf,grass,Enum.Material.Grass,true)
  K.block(shore,'RingPath',V(19,.25,12),CF(math.sin(a)*166,.8,math.cos(a)*166)*CFrame.Angles(0,a,0),Color3.fromRGB(199,192,163),Enum.Material.Sand,true)
  K.mesh(shore,'Rock',V(23,12+i%4,13),CF(math.sin(a)*181,3,math.cos(a)*181)*CFrame.Angles(0,a,0),stone,Enum.Material.Slate)
  if i%3==0 and L.clearOfAccess(math.sin(a)*165,math.cos(a)*165,18) then K.tree(shore,CF(math.sin(a)*165,.5,math.cos(a)*165),12+i%4,Color3.fromRGB(82,125,72),'forest') end
 end
 local lake=K.cylinder(w,'Lake',1,L.lakeRadius*2,CF(0,-.25,0),Color3.fromRGB(42,137,148)) lake.Name='Lake' lake.Transparency=.16 lake.CanCollide=false
 lake:SetAttribute('CircularRadius',L.lakeRadius) lake:SetAttribute('InnerRadius',L.platformRadius)
 local deck=K.model(shore,'CentralPlatform')
 K.cylinder(deck,'PlatformHull',2.4,L.platformRadius*2,CF(0,.1,0),K.wood,Enum.Material.Wood,true)
 K.cylinder(deck,'PlatformDeck',.2,L.platformRadius*2,CF(0,1.3,0),K.wood,Enum.Material.WoodPlanks,true)
 for i=-19,19 do local x=i*2.95 local edge=math.abs(x)+1.45
  local length=2*math.sqrt(math.max(0,L.platformRadius^2-edge^2))
  if length>0 then K.block(deck,'PlatformPlank',V(2.9,.12,length),CF(x,1.35,0),Color3.fromRGB(173+(i%3)*7,119+(i%3)*5,75),Enum.Material.WoodPlanks) end
 end
 deck:SetAttribute('DeckTop',L.deckTop)
 local hub=w.PortalHub local neck=hub.Statue.Neck.Position
 local delta=V(-neck.X,L.deckTop-(neck.Y-28.1),-neck.Z)
 hub:PivotTo(hub:GetPivot()+delta)
 hub.Statue:SetAttribute('FeetHeight',L.deckTop+18)
 hub.Statue:SetAttribute('MagnetBottomHeight',L.deckTop+20.6)
 for _,p in hub:GetChildren() do if p.Name:match('^Plaza_') or p.Name:match('^BorderPaver_') then p:Destroy() end end
 -- Remove the obsolete straight approach, including SceneKit numeric suffixes.
 for _,p in hub:GetDescendants() do if p:IsA('BasePart') and (p.Name=='MainWalk' or p.Name:match('^MainWalk_')) then p:Destroy() end end
 hub.HubArrival.CFrame=CF(0,4,53)
 for _,portal in hub.Portals:GetChildren() do
  local marker=portal:FindFirstChild('PortalPoint')
  if marker then marker:SetAttribute('CaptionTop',marker.Position.Y+11) end
 end
 for index,degrees in L.bridgeAngles do local base=CFrame.Angles(0,math.rad(degrees),0)
  K.block(shore,'BridgeCollider',V(14,.7,62),base*CF(0,1.045,86),K.wood,Enum.Material.WoodPlanks,true)
  for j=1,21 do K.block(shore,'BridgePlank',V(14,.15,62/21-.05),base*CF(0,1.32,55+(j-.5)*62/21),Color3.fromRGB(173+j%3*7,119+j%3*5,75),Enum.Material.WoodPlanks) end
  for j=1,3 do for _,s in {-1,1} do
   K.block(shore,'BridgePost',V(.65,3.6,.65),base*CF(s*7,2.4,64+(j-1)*12),K.wood,Enum.Material.Wood)
   K.block(shore,'BridgeRail',V(.3,.3,12.3),base*CF(s*7,3.65,70+(j-1)*12),K.wood,Enum.Material.Wood)
  end end
 end
 local angles=L.plotAngles
 local points=w.ZonePoints points:ClearAllChildren()
 for i,deg in angles do local a=math.rad(deg) local outward=V(math.sin(a),0,math.cos(a))
  local pos=outward*L.plotRadius+V(0,L.workshopFloorY,0) local plot=w.Plots[string.format('Plot%02d',i)]
  local target=CFrame.lookAt(pos,pos-outward)
  local dy=pos.Y-plot.Floor.Position.Y
  for _,p in plot:GetDescendants() do local top=p:GetAttribute('CaptionTop') if top then p:SetAttribute('CaptionTop',top+dy) end end
  plot:PivotTo(target*plot.Floor.CFrame:Inverse()*plot:GetPivot())
  local pv=outward
  local cf=CFrame.lookAt(pv*(L.lakeRadius+4),pv*90)
  K.pier(shore,cf)
  local p=K.block(points,'Point',V(12,.8,10),cf*CF(0,.85,0),K.wood,Enum.Material.WoodPlanks,true)
  p.Name='Z-01-P'..i p:SetAttribute('ZoneId','Z-01') p:SetAttribute('EquipmentPool',true)
  local landing=L.direction(L.bridgeAngles[math.ceil(i/2)])*188
  local entrance=V(plot.Entrance.Position.X,0,plot.Entrance.Position.Z)
  local midpoint=(landing+entrance)/2+V(0,.8,0)
  K.block(shore,'WorkshopWalk',V(8,.25,(landing-entrance).Magnitude+3),CFrame.lookAt(midpoint,landing+V(0,.8,0)),Color3.fromRGB(199,192,163),Enum.Material.Sand,true)
 end
 for _,row in {{'Buyer',-42,142},{'Shop',0,151},{'Visitors',42,142}} do
  local p=w.Plaza[row[1]] local delta=V(row[2]-p.Position.X,0,row[3]-p.Position.Z)
  for _,v in w.Plaza:GetChildren() do if v:IsA('BasePart') and v.Name:sub(1,#row[1])==row[1] then v.CFrame+=delta end end
 end
 w.Biomes['BIO-01'].Arrival.CFrame=CF(0,4,133)
 w:SetAttribute('Layout','ThreeBridgeLakeHub') w:SetAttribute('StarterLayoutVersion',R.version) w:SetAttribute('BuildVersion',R.version)
 K.clearCache() return shore
end
return R
