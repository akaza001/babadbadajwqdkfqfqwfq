-- Non-overlapping horizontal surfaces. Invisible supports retain their collision role.
local S=require(script.Parent.SurfaceStyle)
local J={version='0.5.3'}
local function part(parent,name,size,cf,source,cls)
 local p=Instance.new(cls or 'Part') p.Name=name p.Size=size p.CFrame=cf
 p.Color=source.Color p.Material=source.Material p.MaterialVariant=source.MaterialVariant
 p.Anchored=true p.CanCollide=source.CanCollide p.CanQuery=source.CanQuery p.CanTouch=false
 p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth
 for k,v in source:GetAttributes() do p:SetAttribute(k,v) end
 p.Parent=parent return p
end
function J.slab(parent,name,width,depth,height,y,color,bevel)
 local template=Instance.new('Part') template.Color=color template.Material=Enum.Material.SmoothPlastic
 S.part(template)
 part(parent,name,Vector3.new(width-2*bevel,height,depth),CFrame.new(0,y,0),template)
 for _,x in {-1,1} do
  part(parent,name,Vector3.new(bevel,height,depth-2*bevel),CFrame.new(x*(width/2-bevel/2),y,0),template)
  for _,z in {-1,1} do
   part(parent,name,Vector3.new(height,bevel,bevel),CFrame.new(x*(width/2-bevel/2),y,z*(depth/2-bevel/2))*CFrame.Angles(0,z==1 and math.pi or 0,x*z*math.pi/2),template,'WedgePart')
  end
 end
 template:Destroy()
end
function J.apply(w)
 for _,p in w:GetDescendants() do
  if p:IsA('BasePart') and (p.Name:match('^JoinedFenceRail_') or p.Name:match('^IslandRail_')) and not p:GetAttribute('JointTrimmed') then
   p.Size-=Vector3.new(0,0,p.Name:match('^Joined') and .68 or .5) p:SetAttribute('JointTrimmed',true)
  end
 end
 local needPedestals=w:GetAttribute('SurfaceJointsVersion')~=J.version
 local changed=0
 -- Retile the existing ring rectangles as exact trapezoids, preserving materials and height.
 for _,biome in w.Biomes:GetChildren() do
  for _,p in biome:GetChildren() do if p:IsA('Part') and (p.Name:match('^Shore_') or p.Name:match('^Walkway_')) and not biome:FindFirstChild(p.Name..'Edge') then
   local width=p.Size.Z local radius=67 local inner=radius-width/2 local outer=radius+width/2
   local iw=2*inner*math.tan(math.pi/24) local ow=2*outer*math.tan(math.pi/24) local d=(ow-iw)/2
   part(biome,p.Name,Vector3.new(iw,p.Size.Y,width),p.CFrame,p)
   for _,side in {-1,1} do part(biome,p.Name..'Edge',Vector3.new(p.Size.Y,d,width),p.CFrame*CFrame.new(side*(iw/2+d/2),0,0)*CFrame.Angles(0,0,-side*math.pi/2),p,'WedgePart') end
   p:Destroy() changed+=1
  end end
  biome:SetAttribute('SurfaceJointsVersion',J.version)
 end
 -- Rebuild only pedestal skins; logical slot/UID/exhibit anchors remain unchanged.
 local Map=require(script.Parent.MapAssets)
 if needPedestals then for _,plot in w.Plots:GetChildren() do for _,slot in plot.Slots:GetChildren() do
  local old=slot:FindFirstChild('PedestalVisual')
  if old then
   local new=Map.pedestal() local cf=slot.CFrame new:PivotTo(cf)
   for _,p in new:GetChildren() do
    if p:IsA('BasePart') then local source=old:FindFirstChild(p.Name) if source then p.Color=source.Color p.Material=source.Material p.MaterialVariant=source.MaterialVariant p.CanCollide=source.CanCollide for k,v in source:GetAttributes() do p:SetAttribute(k,v) end end end
   end
   old:Destroy() new.Parent=slot Map.setPedestalState(slot,(slot:GetAttribute('Slot') or 1)<=6) changed+=1
  end
 end end end
 for _,p in w:GetDescendants() do if p:IsA('BasePart') and p.Name:match('^BridgeCollider') then p.Transparency=1 end end
 w:SetAttribute('SurfaceJointsVersion',J.version) return changed
end
-- Finishing pass for old baked scenes as well as the updated constructors.
function J.finish(w)
 J.apply(w)
 local changed=0
 local function update(p,size,cf)
  if p:GetAttribute('DetailJointVersion')=='0.5.4' then return end
  p.Size=size if cf then p.CFrame=cf end
  p:SetAttribute('DetailJointVersion','0.5.4') changed+=1
 end
 for _,plot in w.Plots:GetChildren() do
  local frame=plot.Floor.CFrame local scale=plot:GetAttribute('CompactWorkshop') and .7 or 1
  local bench=plot:FindFirstChild('BenchVisual')
  if bench then for _,p in bench:GetChildren() do if p:IsA('BasePart') then
   local s=p.Size
   if p.Name=='Apron' then update(p,Vector3.new(s.X>1 and 5.28 or .22,s.Y,s.X>1 and .22 or 3.62))
   elseif p.Name=='SlotFrame' and s.X<1 then update(p,Vector3.new(s.X,s.Y,2.875))
   elseif p.Name=='TrayWall' and s.X<.1 then update(p,Vector3.new(s.X,s.Y,.715)) end
  end end end
  for _,p in plot:GetChildren() do if p.Name=='SideWall' then
   local sign=frame:PointToObjectSpace(p.Position).X<0 and -1 or 1
   update(p,Vector3.new(.8*scale,9.65,38.8*scale),frame*CFrame.new(sign*24*scale,5.175,.2*scale))
  end end
  local visual=plot:FindFirstChild('WorkshopVisual')
  if visual then for _,p in visual:GetChildren() do if p:IsA('BasePart') then
   if p.Name:match('^WainscotLeft') or p.Name:match('^WainscotRight') then
    local localCF=frame:ToObjectSpace(p.CFrame)
    update(p,Vector3.new(p.Size.X,p.Size.Y,38.855*scale),frame*CFrame.new(localCF.X,localCF.Y,-.0725*scale)*localCF.Rotation)
   elseif p.Name=='SideBeam' and p.Size.Z>30*scale then
    local sign=frame:PointToObjectSpace(p.Position).X<0 and -1 or 1
    for _,ends in {{-18.775,-.525},{.525,19.075}} do
     local q=p:Clone() q.Size=Vector3.new(.8*scale,.8,(ends[2]-ends[1])*scale)
     q.CFrame=frame*CFrame.new(sign*24*scale,9.85,(ends[1]+ends[2])/2*scale)
     q:SetAttribute('DetailJointVersion','0.5.4') q.Parent=visual
    end
    p:Destroy() changed+=1
   end
  end end end
 end
 for _,biome in w.Biomes:GetChildren() do
  local boards={}
  for _,p in biome:GetDescendants() do if p:IsA('BasePart') then
   if p.Name:match('^PierSupport_') and not p:GetAttribute('DetailJointVersion') then update(p,Vector3.new(p.Size.X,p.Size.Y,9),p.Size.Z>10 and p.CFrame*CFrame.new(0,0,-1.5) or p.CFrame)
   elseif p.Name:match('^HutSide_') then update(p,Vector3.new(p.Size.X,p.Size.Y,11.4))
   elseif p.Name:match('^Boardwalk_') and biome.Name=='BIO-05' then table.insert(boards,p) end
  end end
  table.sort(boards,function(a,b) return a.Position.X<b.Position.X end)
  if #boards==7 then for i,p in boards do
   local width=(i==1 or i==7) and 10.5 or 8
   local origin=require(script.Parent.BiomeCatalog).byId[biome.Name].origin
   local x=-30+i*8+(i==1 and -1.25 or i==7 and 1.25 or 0)
   update(p,Vector3.new(width,.5,6),CFrame.new(origin+Vector3.new(x,1.2,-42)))
  end end
 end
 w:SetAttribute('DetailJointsVersion','0.5.4') return changed
end
return J
