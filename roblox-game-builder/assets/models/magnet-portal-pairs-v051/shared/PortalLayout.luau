-- Copy the approved live hub portals, aligning their real marker rather than their pivot.
local B=require(script.Parent.BiomeCatalog)
local G=require(script.Parent.PortalGeometry)
local K=require(script.Parent.SceneKit)
local L={version='0.5.1'}
function L.applyOne(world,id)
 local d=assert(B.byId[id]) local biome=world.Biomes:FindFirstChild(id)
 local portals=world:FindFirstChild('PortalHub') and world.PortalHub:FindFirstChild('Portals')
 local source=portals and portals:FindFirstChild(id)
 if not biome or not source then return end
 if id=='BIO-01' then
  if biome:FindFirstChild('Arrival') then biome.Arrival.CFrame=G.arrival(source.PortalPoint) end
  return
 end
 local clone=source:Clone() clone.Name='ReturnPortal'
 local target=CFrame.new(d.origin+Vector3.new(0,1,72))
 local delta=target*G.base(source.PortalPoint):Inverse()
 clone:PivotTo(delta*clone:GetPivot()) clone.WorldPivot=target
 clone:SetAttribute('AssetId','A-RETURN-PORTAL-'..id)
 clone:SetAttribute('SourcePortalId',id) clone:SetAttribute('PortalAssemblyVersion',L.version)
 local arrivalCopy=clone:FindFirstChild('PortalArrival') if arrivalCopy then arrivalCopy:Destroy() end
 local old=biome:FindFirstChild('ReturnPortal') if old then old:Destroy() end
 old=biome:FindFirstChild('ReturnPoint') if old then old:Destroy() end
 for _,p in biome:GetChildren() do
  if p:IsA('BasePart') and (p.Name:match('^ReturnArchPost') or p.Name:match('^ReturnArchTop')) then p:Destroy() end
 end
 local marker=clone.PortalPoint marker.Name='ReturnPoint'
 marker:SetAttribute('PortalId','HUB') marker:SetAttribute('SourceBiomeId',id)
 marker:SetAttribute('CaptionTop',target.Y+14)
 marker.Label.Text.Text=d.name..'\nВ хаб · войди в портал'
 for _,p in clone:GetDescendants() do if p:IsA('ProximityPrompt') then p.Enabled=false end end
 clone.Parent=biome marker.Parent=biome
 biome.Arrival.CFrame=G.arrival(marker)
 local finish=biome:FindFirstChild('BiomeFinish')
 local sign=finish and finish:FindFirstChild('LakeSign')
 if sign and sign:FindFirstChild('Label') then sign.Label.Enabled=false end
 biome:SetAttribute('PortalAssemblyVersion',L.version)
end
function L.apply(world)
 assert(not game:GetService('RunService'):IsRunning(),'Bake portal copies in Edit')
 for _,d in B.list do
  local portal=world.PortalHub.Portals:FindFirstChild(d.id)
  if portal then
   local arrival=portal:FindFirstChild('PortalArrival') or K.marker(portal,'PortalArrival',G.arrival(portal.PortalPoint))
   arrival.CFrame=G.arrival(portal.PortalPoint) arrival:SetAttribute('BiomeId','BIO-01')
  end
  L.applyOne(world,d.id) task.wait()
 end
 world:SetAttribute('PortalAssemblyVersion',L.version)
end
return L
