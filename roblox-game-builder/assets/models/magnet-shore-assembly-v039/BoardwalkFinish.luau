-- Raised structural deck and shared shore fishing regions; authored in Edit.
local K=require(script.Parent.SceneKit)
local S=require(script.Parent.SurfaceStyle)
local L=require(script.Parent.StarterLayout)
local B={version='0.3.9',top=4.01}
local V=Vector3.new local CF=CFrame.new
-- Exact trapezoid: no coplanar overlap at adjacent sectors.
local function sector(parent,name,r,width,a,step,y,color,mat,solid,height)
 height=height or .16
 local inner,outer=r-width/2,r+width/2 local iw=2*inner*math.tan(step/2) local ow=2*outer*math.tan(step/2)
 local cf=CF(math.sin(a)*r,y,math.cos(a)*r)*CFrame.Angles(0,a,0)
 local center=K.block(parent,name,V(iw,height,width),cf,color,mat,solid)
 if mat==Enum.Material.WoodPlanks then
  center:SetAttribute('SurfaceFinish','Timber') S.part(center)
  local texture=Instance.new('Texture') texture.Name='FinishGrain' texture.Face=Enum.NormalId.Top texture.Texture='rbxassetid://9920625290' texture.StudsPerTileU=7 texture.StudsPerTileV=3 texture.Transparency=.83 texture.Parent=center
 end
 local d=(ow-iw)/2
 for _,side in {-1,1} do
  local p=Instance.new('WedgePart') p.Name=name..'Edge' p.Size=V(height,d,width)
  p.CFrame=cf*CF(side*(iw/2+d/2),0,0)*CFrame.Angles(0,0,-side*math.pi/2)
  p.Color=color p.Material=mat if mat==Enum.Material.WoodPlanks then p:SetAttribute('SurfaceFinish','Timber') end p.Anchored=true p.CanCollide=solid==true p.CanTouch=false p.CanQuery=solid==true S.part(p) p.Parent=parent
 end
end
function B.replaceFoundation(w)
 -- Saved stepped Rock mesh, kept near its native 2:1:2 proportions. Solid core closes through-gaps.
 local root=assert(w:FindFirstChild('BoardwalkFinish'))
 local old=root:FindFirstChild('RockFoundation')
 local rocks=Instance.new('Model') rocks.Name='RockFoundation'
 for i=1,192 do local a=(i-1)*math.pi/96
  sector(rocks,'RockCore',110,14,a,math.pi/96,-.82,Color3.fromRGB(117,135,128),Enum.Material.Slate,true,9.36)
 end
 task.wait()
 local function stairClear(pos)
  for _,a in {0,90,180} do local d=L.direction(a) if pos:Dot(d)>115 and math.abs(pos.X*d.Z-pos.Z*d.X)<7 then return false end end
  for _,plot in w.Plots:GetChildren() do local v=plot.Floor.CFrame:PointToObjectSpace(pos) if math.abs(v.X+6)<7 and v.Z> -31 and v.Z< -15 then return false end end
  return true
 end
 for i=1,48 do local a=i*math.pi/24 local frame=CFrame.Angles(0,a,0)
  for _,r in {104.8,117} do for layer,y in {-3.9,-1.7,.4,2.18} do
   for _,offset in {-5,0,5} do local stagger=layer%2==0 and 2.5 or 0 local pos=V(math.sin(a)*r,y,math.cos(a)*r)+frame.RightVector*(offset+stagger)
    if r<110 or stairClear(pos) then
     local p=K.mesh(rocks,'Rock',V(6.2,3.1,6.2),CF(pos)*CFrame.Angles(0,a+(i%3-1)*.08,0),Color3.fromRGB(132+i%4*2,149+i%4*2,141+i%4*2),Enum.Material.Slate)
     p.Name='LayeredRock' p:SetAttribute('SurfaceFinish','StarterSlate') S.part(p)
    end
   end
  end end
  if i%12==0 then task.wait() end
 end
 S.installMaterials()
 for _,p in rocks:GetDescendants() do if p:IsA('BasePart') then p:SetAttribute('SurfaceFinish','StarterSlate') S.part(p) end end
 rocks:SetAttribute('RockVisualVersion',B.version)
 if old then old:Destroy() end rocks.Parent=root
 K.clearCache()
 w:SetAttribute('BuildVersion',B.version) w:SetAttribute('BoardwalkFinishVersion',B.version)
 return rocks
end
function B.apply(w)
 local old=w:FindFirstChild('BoardwalkFinish') if old then old:Destroy() end
 local root=K.model(w,'BoardwalkFinish') K.resetNames()
 local ring=w.StarterPolish:FindFirstChild('LakeBoardwalk') if ring then ring:Destroy() end
 local deck=K.model(root,'LakeBoardwalk') deck:SetAttribute('DeckTop',B.top)
 for i=1,192 do local a=(i-1)*math.pi/96 local cf=CF(math.sin(a)*110,0,math.cos(a)*110)*CFrame.Angles(0,a,0)
  sector(deck,'DeckPlank',110,14,a,math.pi/96,B.top-.08,Color3.fromRGB(174+i%3*3,122+i%3*2,74),Enum.Material.WoodPlanks,true)
  if i%8==0 then
   for _,r in {-5.5,5.5} do K.block(deck,'Pile',V(1.2,9,1.2),cf*CF(0,-.6,r),Color3.fromRGB(104,76,48),Enum.Material.Wood,true) end
   K.block(deck,'CrossBeam',V(1.4,.8,15),cf*CF(0,3,0),K.wood,Enum.Material.Wood,true)
  end
 end
 -- Raise existing bridge/platform parts once using saved authored heights.
 for _,p in w.RadialShore:GetDescendants() do if p:IsA('BasePart') then
  local n=p.Name
  if n:match('^Bridge') or p.Parent.Name=='CentralPlatform' then
   local base=p:GetAttribute('PreRaisedY') if base==nil then base=p.Position.Y p:SetAttribute('PreRaisedY',base) end
   p.CFrame=CF(p.Position.X,base+2.6,p.Position.Z)*p.CFrame.Rotation
   if n:match('^PlatformDeck') then p.Transparency=1 p.CastShadow=false end
   if n:match('^BridgePlank') then
    local r=V(p.Position.X,0,p.Position.Z).Magnitude
    if (r>101 and r<119) or r<59 then p.CFrame-=V(0,.22,0) end
   end
   if n:match('^BridgeRail') or n:match('^BridgePost') then p.CanCollide=true p.CanQuery=true end
  elseif n:match('^PierSupport') or n:match('^DeckPlank') or n:match('^Piling') or n:match('^WorkshopWalk') then p:Destroy()
  elseif n:match('^Bank_') or n:match('^RingPath_') then p.Transparency=1 p.CastShadow=false
  end
 end end
 -- Continuous grass and path skins replace overlapping rotated rectangles.
 for i=1,192 do local a=(i-1)*math.pi/96
  sector(root,'GrassSkin',147.5,75,a,math.pi/96,.42,Color3.fromRGB(118,160,66),Enum.Material.Grass,false)
  sector(root,'PathSkin',166,8,a,math.pi/96,.82,Color3.fromRGB(228,209,165),Enum.Material.Sand,false)
 end
 local hub=w.PortalHub local shift=4-(hub.Statue.Neck.Position.Y-28.1) hub:PivotTo(hub:GetPivot()+V(0,shift,0))
 for _,m in hub.Portals:GetChildren() do m.PortalPoint:SetAttribute('CaptionTop',m.PortalPoint.Position.Y+11) end
 hub.HubArrival.CFrame=CF(0,7,53)
 hub.Statue:SetAttribute('FeetHeight',22) hub.Statue:SetAttribute('MagnetBottomHeight',24.6)
 -- Ground-level entrances, a clear landing and eight shallow steps to the deck.
 for i=1,6 do local plot=w.Plots[string.format('Plot%02d',i)] local frame=plot.Floor.CFrame
  plot.Entrance.CFrame=frame*CF(-6,2,-16)
  local landing=K.block(root,'EntranceLanding'..i,V(10,.2,3.2),frame*CF(-6,.15,-15.6),K.wood,Enum.Material.WoodPlanks,true)
  landing:SetAttribute('PlotId',i)
  local ground=frame*V(-6,-.5,-28.2)
  local stairFrame=CF(ground)*frame.Rotation
  for step=1,8 do
   local height=4-step*.4225
   local localZ=(step-.5)*1.5
   K.block(root,'WorkshopStair'..i,V(10,height-.5,1.53),stairFrame*CF(0,(height+.5)/2,localZ),K.wood,Enum.Material.WoodPlanks,true)
  end
  -- Rails follow the staircase sides; the entrance landing remains open.
  for _,side in {-1,1} do
   local top=stairFrame*V(side*4.8,5.25,0)
   local foot=stairFrame*V(side*4.8,1.9,12)
   K.rod(root,'StairHandrail',top,foot,.3,K.wood,Enum.Material.Wood,true)
   for _,t in {0,.5,1} do local pos=top:Lerp(foot,t)
    K.block(root,'StairPost',V(.45,1.8,.45),CF(pos-V(0,.8,0)),K.wood,Enum.Material.Wood,true)
   end
  end
 end
 -- Public shore access stays separate from the six level workshop exits.
 for _,a in {0,90,180} do local frame=CFrame.Angles(0,math.rad(a),0)
  for i=1,8 do local height=4-i*.4225
   K.block(root,'PublicShoreStep',V(10,height+.5,2.1),frame*CF(0,(height-.5)/2,116.8+(i-.5)*2),K.wood,Enum.Material.WoodPlanks,true)
  end
 end
 -- Inner (water-facing) ring fence only. Leave all bridge junctions open.
 local function fence(r,waterSide)
  for i=1,96 do local a=i*math.pi/48 local d=V(math.sin(a),0,math.cos(a))
   if L.bridgeClear(d.X*r,d.Z*r,10) then local frame=CF(d*r)*CFrame.Angles(0,a,0)
    K.block(root,'FencePost',V(.6,2.4,.6),frame*CF(0,5.2,0),K.wood,Enum.Material.Wood,true)
    K.block(root,'FenceRail',V(2*r*math.tan(math.pi/96)+.1,.3,.35),frame*CF(0,5.55,0),K.wood,Enum.Material.Wood,true)
   end
  end
 end
 fence(103.25,true) fence(57.25,true)
 for i=1,16 do local a=i*math.pi/8 K.block(root,'PlatformPile',V(1.5,9,1.5),CF(math.sin(a)*49,-.6,math.cos(a)*49),K.wood,Enum.Material.Wood,true) end
 for _,a in L.bridgeAngles do local frame=CFrame.Angles(0,math.rad(a),0)
  for r=65,105,20 do for _,side in {-1,1} do K.block(root,'BridgePile',V(1.2,9,1.2),frame*CF(side*5.8,-.6,r),K.wood,Enum.Material.Wood,true) end
   K.block(root,'BridgeBeam',V(15,.8,1.4),frame*CF(0,3,r),K.wood,Enum.Material.Wood,true)
  end
 end
 -- Fully filled circular water volume and a contrasting visible floor.
 local water=w.Lake water.Size=V(6,224,224) water.CFrame=CF(0,-2.75,0)*CFrame.Angles(0,0,math.pi/2)
 water.Transparency=.68 water.Reflectance=.025 water.Color=Color3.fromRGB(70,171,174) water:SetAttribute('FishOuterRadius',100.5)
 local bed=w.FinishDecor.MainLakeShore:FindFirstChildWhichIsA('Part')
 for _,p in w.FinishDecor.MainLakeShore:GetChildren() do if p.Name:match('^Lakebed') then bed=p break end end
 if bed then bed.Size=V(.5,224,224) bed.CFrame=CF(0,-5.6,0)*CFrame.Angles(0,0,math.pi/2) bed.Material=Enum.Material.Sand bed.MaterialVariant='MW_SquareRelief_Sand' bed.Color=Color3.fromRGB(168,181,140) bed.CanCollide=true bed.CanQuery=true end
 for i=1,24 do local a=i*math.pi/12 local r=72+i%4*7 K.mesh(root,'Rock',V(2+i%3,.8,2),CF(math.sin(a)*r,-5,math.cos(a)*r),Color3.fromRGB(135,151,126),Enum.Material.Slate) end
 B.replaceFoundation(w)
 -- Sparse saved-pack trees and stones, outside entrances, stairs and service counters.
 local green=K.model(root,'GrassDecor') local count=0
 local function free(pos)
  if not L.clearOfAccess(pos.X,pos.Z,13) then return false end
  for _,a in {0,90,180} do local d=L.direction(a) local along=pos:Dot(d) if along>112 and along<154 and (pos-d*along).Magnitude<12 then return false end end
  for _,p in w.Plaza:GetChildren() do if p:IsA('BasePart') and (pos-V(p.Position.X,0,p.Position.Z)).Magnitude<19 then return false end end
  return true
 end
 for i=1,96 do local a=i*2.399963229728653 local r=134+(i%4)*6 local pos=V(math.sin(a)*r,0,math.cos(a)*r)
  if free(pos) and count<12 then
   K.tree(green,CF(pos+V(0,.5,0)),8+i%4,Color3.fromRGB(102+i%3*8,148+i%3*5,65),'forest') count+=1
  end
 end
 local placed=0
 for i=1,96 do local a=(i+.45)*2.399963229728653 local r=132+(i%4)*6 local pos=V(math.sin(a)*r,0,math.cos(a)*r)
  if free(pos) and placed<30 then
   K.ball(green,'Stone',V(2+i%3*.5,2+i%3*.5,2+i%3*.5),CF(pos+V(0,.85,0))*CFrame.Angles(0,a,0),Color3.fromRGB(128,144,116),Enum.Material.Slate) placed+=1
  end
 end
 -- All edges share the same server/client region tests; no tiny fixed stations.
 w.ZonePoints:ClearAllChildren()
 local function area(name,kind,cf)
  local p=K.marker(w.ZonePoints,name,cf) p:SetAttribute('FishArea',kind) p:SetAttribute('ZoneId','Z-01') p:SetAttribute('EquipmentPool',true) p:SetAttribute('DeckTop',B.top)
 end
 area('Z-01-RING','Ring',CF(0,4,0)) area('Z-01-CENTER','Center',CF(0,4,0))
 for i,a in L.bridgeAngles do area('Z-01-BRIDGE'..i,'Bridge',CFrame.Angles(0,math.rad(a),0)) end
 -- One normal-map scale; remove duplicate grain overlays that disagreed at triangle seams.
 S.installMaterials()
 local function unify(container)
  local entries=container:GetDescendants() if container:IsA('BasePart') then table.insert(entries,container) end
  for _,p in entries do if p:IsA('BasePart') and not S.isItem(p) then
   if table.find(S.baseNames,p.Material.Name) then p:SetAttribute('SurfaceFinish','Starter'..p.Material.Name) S.part(p) end
   for _,t in p:GetChildren() do if t:IsA('Texture') and (t.Name=='FinishGrain' or t.Name=='FineGrain') then t:Destroy() end end
  end end
 end
 unify(root) unify(w.RadialShore) unify(w.Plots) unify(w.PortalHub) unify(w.Lake) unify(w.StarterPolish) unify(w.Plaza)
 for _,m in w.FinishDecor:GetChildren() do if not m.Name:match('^BIO%-') then unify(m) end end
 S.apply(root) require(script.Parent.WorldLabels).applyWorld(w) K.clearCache()
 w:SetAttribute('BuildVersion',B.version) w:SetAttribute('BoardwalkFinishVersion',B.version) w:SetAttribute('UniformStarterRelief',true)
 return root
end
return B
