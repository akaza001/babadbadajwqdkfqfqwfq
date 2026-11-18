-- Shared authored-pier interaction for every non-starter lake. No world art is recreated here.
local B=require(script.Parent.BiomeCatalog)
local S=require(script.Parent.SurfaceStyle)
local F={version='0.5.0'}
function F.pointName(id,index) return id=='BIO-02' and 'Z-02-ICE-'..index or 'FISH-'..id..'-'..index end
function F.apply(world)
 local expected={}
 for _,d in B.list do if d.id~='BIO-01' then
  local model=world.Biomes:FindFirstChild(d.id) local lake=model and model:FindFirstChild('Lake')
  if lake then
   lake:SetAttribute('CircularRadius',58) lake:SetAttribute('FishOuterRadius',56) lake:SetAttribute('WaterSurfaceY',.25)
   for i,x in {-31,31} do
    local name=F.pointName(d.id,i) expected[name]=true local point=world.ZonePoints:FindFirstChild(name)
    if not point then point=Instance.new('Part') point.Name=name point.Parent=world.ZonePoints end
    point.Anchored=true point.CanCollide=false point.CanTouch=false point.CanQuery=false point.Transparency=1
    point.Size=Vector3.new(11,.2,9) point.CFrame=CFrame.new(d.origin+Vector3.new(x,1.33,42))
    point:SetAttribute('ZoneId',d.zoneId) point:SetAttribute('EquipmentPool',true) point:SetAttribute('BiomeId',d.id) point:SetAttribute('BiomeFishingVersion',F.version)
    S.part(point)
   end
  end
 end end
 for _,point in world.ZonePoints:GetChildren() do if point:GetAttribute('BiomeFishingVersion') and not expected[point.Name] then point:Destroy() end end
 world:SetAttribute('BiomeFishingVersion',F.version)
end
return F
