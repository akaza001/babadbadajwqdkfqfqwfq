-- Reuses the two authored ice piers. Interaction markers are invisible world parts.
local B=require(script.Parent.BiomeCatalog)
local S=require(script.Parent.SurfaceStyle)
local F={version='0.4.8'}
function F.apply(world)
 local model=world.Biomes:FindFirstChild('BIO-02') if not model then return end
 local lake=model:FindFirstChild('Lake') if not lake then return end
 lake:SetAttribute('CircularRadius',58) lake:SetAttribute('FishOuterRadius',56) lake:SetAttribute('WaterSurfaceY',.25)
 for i,x in {-31,31} do
  local name='Z-02-ICE-'..i local point=world.ZonePoints:FindFirstChild(name)
  if not point then point=Instance.new('Part') point.Name=name point.Parent=world.ZonePoints end
  point.Anchored=true point.CanCollide=false point.CanTouch=false point.CanQuery=false point.Transparency=1
  point.Size=Vector3.new(12,.2,9) point.CFrame=CFrame.new(B.byId['BIO-02'].origin+Vector3.new(x,1.33,42))
  point:SetAttribute('ZoneId','Z-02') point:SetAttribute('BiomeId','BIO-02') point:SetAttribute('BiomeFishingVersion',F.version)
  S.part(point)
 end
 world:SetAttribute('BiomeFishingVersion',F.version)
end
return F
