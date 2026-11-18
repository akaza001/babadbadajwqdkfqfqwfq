-- Shared shore/facing geometry. Targets never snap sideways or turn the character.
local C=require(script.Parent.Config)
local Layout=require(script.Parent.StarterLayout)
local F={version='0.5.8'}
local flat=Vector3.new(1,0,1)
local function finiteVector(v)
 return typeof(v)=='Vector3' and v.X==v.X and v.Y==v.Y and v.Z==v.Z and math.max(math.abs(v.X),math.abs(v.Y),math.abs(v.Z))<1e6
end
function F.lake(world,biomeId)
 if not world then return nil end
 if not biomeId or biomeId=='BIO-01' then return world:FindFirstChild('Lake') end
 local biomes=world:FindFirstChild('Biomes') local biome=biomes and biomes:FindFirstChild(biomeId)
 return biome and biome:FindFirstChild('Lake')
end
local function circle(origin,direction,radius)
 local b=origin:Dot(direction) local disc=b*b-origin:Dot(origin)+radius*radius
 if disc<0 then return nil end
 local span=math.sqrt(disc) return -b-span,-b+span
end
local function subtract(intervals,lo,hi)
 if not lo then return intervals end
 local result={}
 for _,v in intervals do
  if hi<=v[1] or lo>=v[2] then table.insert(result,v)
  else
   if lo>v[1] then table.insert(result,{v[1],lo}) end
   if hi<v[2] then table.insert(result,{hi,v[2]}) end
  end
 end
 return result
end
local function rectangle(ox,oz,dx,dz,minX,maxX,minZ,maxZ)
 local lo,hi=-math.huge,math.huge
 for _,a in {{ox,dx,minX,maxX},{oz,dz,minZ,maxZ}} do
  if math.abs(a[2])<1e-7 then if a[1]<a[3] or a[1]>a[4] then return nil end
  else
   local one,two=(a[3]-a[1])/a[2],(a[4]-a[1])/a[2]
   lo=math.max(lo,math.min(one,two)) hi=math.min(hi,math.max(one,two))
   if lo>=hi then return nil end
  end
 end
 return lo,hi
end
function F.solve(origin,look,lake,biomeId)
 if not finiteVector(origin) or not finiteVector(look) then return nil,'errWaterNear' end
 if not lake or not lake:IsA('BasePart') or not lake:GetAttribute('CircularRadius') then return nil,'errLoading' end
 local y=lake:GetAttribute('WaterSurfaceY') or .25
 local direction=look*flat if direction.Magnitude<.01 then return nil,'errWaterFacing' end direction=direction.Unit
 local relative=(origin-lake.Position)*flat local radius=relative.Magnitude
 local inner=(lake:GetAttribute('InnerRadius') or -2)+2
 local outer=lake:GetAttribute('FishOuterRadius') or lake:GetAttribute('CircularRadius')-2
 if origin.Y<y+.8 or origin.Y>y+12 or math.max(inner-radius,radius-outer,0)>(C.cast.nearWaterDistance or 18) then return nil,'errWaterNear' end
 local lo,hi=circle(relative,direction,outer-.4)
 if not lo then return nil,'errWaterFacing' end
 lo=math.max(C.cast.minDistance,lo+.4) hi=math.min(C.cast.maxDistance,hi-.4)
 if hi<=lo then return nil,'errWaterFacing' end
 local intervals={{lo,hi}}
 if inner>0 then local a,b=circle(relative,direction,inner+.4) intervals=subtract(intervals,a,b) end
 if biomeId=='BIO-01' or not biomeId then
  for _,angle in Layout.bridgeAngles do
   local along=Layout.direction(angle) local cross=Vector3.new(along.Z,0,-along.X)
   local a,b=rectangle(relative:Dot(cross),relative:Dot(along),direction:Dot(cross),direction:Dot(along),-10,10,53,112)
   intervals=subtract(intervals,a,b)
  end
 else
  for _,x in {-31,31} do
   local a,b=rectangle(relative.X,relative.Z,direction.X,direction.Z,x-7.8,x+7.8,36.5,63)
   intervals=subtract(intervals,a,b)
  end
 end
 local safe={}
 for _,v in intervals do if v[2]-v[1]>.5 then table.insert(safe,{v[1]+.2,v[2]-.2}) end end
 if #safe==0 then return nil,'errWaterFacing' end
 return {origin=origin,direction=direction,lake=lake,biomeId=biomeId or 'BIO-01',intervals=safe,waterY=y}
end
function F.resolve(character,world,biomeId)
 local root=character and character:FindFirstChild('HumanoidRootPart') local h=character and character:FindFirstChildOfClass('Humanoid')
 if not root or not h or h.Health<=0 then return nil,'errBusy' end
 local view,err=F.solve(root.Position,root.CFrame.LookVector,F.lake(world,biomeId),biomeId)
 if not view then return nil,err end
 if not F.target(view,.5,world) then return nil,'errWaterFacing' end
 return view
end
function F.stillValid(character,view)
 local root=character and character:FindFirstChild('HumanoidRootPart') local h=character and character:FindFirstChildOfClass('Humanoid')
 if not root or not h or h.Health<=0 or not view or not view.lake:IsDescendantOf(workspace) then return false end
 local direction=root.CFrame.LookVector*flat
 return (root.Position-view.origin).Magnitude<=1 and direction.Magnitude>.01 and direction.Unit:Dot(view.direction)>.999
end
function F.target(view,power,world)
 local wanted=C.cast.minDistance+(C.cast.maxDistance-C.cast.minDistance)*math.clamp(power,0,1)
 local best,distance=nil,math.huge
 for _,v in view.intervals do
  local along=math.clamp(wanted,v[1],v[2]) local delta=math.abs(along-wanted)
  if delta<distance then distance=delta best=along end
 end
 if not best then return nil,'errWaterFacing' end
 -- Authored water is non-colliding; solid decks/rocks above it are invalid targets.
 local params=RaycastParams.new() params.FilterType=Enum.RaycastFilterType.Include params.FilterDescendantsInstances={world} params.RespectCanCollide=true
 local function point(t)
  local p=view.origin+view.direction*t return Vector3.new(p.X,view.waterY+.55,p.Z)
 end
 local function clear(t)
  local p=point(t)
  return workspace:Raycast(Vector3.new(p.X,view.waterY+64,p.Z),Vector3.new(0,-63.95,0),params)==nil
 end
 if not clear(best) then
  local candidates={}
  for _,v in view.intervals do
   for t=v[1],v[2],1 do table.insert(candidates,t) end table.insert(candidates,v[2])
  end
  table.sort(candidates,function(a,b) return math.abs(a-wanted)<math.abs(b-wanted) end)
  best=nil for _,t in candidates do if clear(t) then best=t break end end
  if not best then return nil,'errWaterTarget' end
 end
 local edge=best
 for _,v in view.intervals do
  local found=false
  for t=v[1],math.min(v[2],best),1 do if clear(t) then edge=t found=true break end end
  if found then break end
 end
 return point(best),point(edge)
end
return F
