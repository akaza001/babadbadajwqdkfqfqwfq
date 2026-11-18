local B=require(game.ReplicatedStorage.MagnetWorkshop.Shared.BiomeCatalog)
local Geometry=require(game.ReplicatedStorage.MagnetWorkshop.Shared.PortalGeometry)
local RunService=game:GetService('RunService')
local P={version='0.5.1'}
function P.preview(world) return RunService:IsStudio() and world:GetAttribute('StudioBiomePreview')==true end
function P.enter(s,id)
 if type(id)~='string' or #id>16 then return 'errTarget' end
 if s.state~='Idle' or s.busy or s.portalPending or s.closing or s.lost then return 'errBusy' end
 local char=s.player.Character local root=char and char:FindFirstChild('HumanoidRootPart') local h=char and char:FindFirstChildOfClass('Humanoid')
 if not root or not h or h.Health<=0 then return 'errBusy' end
 local w=workspace.MagnetWorld local source,dest,nextBiome
 if id=='HUB' then
  local biome=w.Biomes:FindFirstChild(s.currentBiomeId or 'BIO-01')
  source=biome and biome:FindFirstChild('ReturnPoint')
  local portal=w.PortalHub.Portals:FindFirstChild(s.currentBiomeId or '')
  if not portal or not source then return 'errTarget' end
  dest=Geometry.arrival(portal.PortalPoint) nextBiome='BIO-01'
 else
  local d=B.byId[id] if not d then return 'errTarget' end
  local model=w.PortalHub.Portals:FindFirstChild(id) source=model and model:FindFirstChild('PortalPoint')
  if d.requiredToolLevel and s.data.toolLevel<d.requiredToolLevel then s.errorMessage=require(game.ReplicatedStorage.MagnetWorkshop.Shared.Strings)('errLocked',d.requiredToolLevel) return 'errLocked' end
  if not B.canEnter(d,s.data.rebirthCount,P.preview(w),s.data.toolLevel) then return 'errBiomeClosed' end
  local biome=w.Biomes:FindFirstChild(id)
  if not biome or not biome:FindFirstChild('Arrival') then return 'errBiomeClosed' end
  local destinationMarker=id=='BIO-01' and source or biome:FindFirstChild('ReturnPoint')
  if not destinationMarker then return 'errBiomeClosed' end
  dest=Geometry.arrival(destinationMarker) nextBiome=id
 end
 if not source or not Geometry.contains(source,root.Position,.4) then return 'errPortalDistance' end
 if os.clock()<(s.nextPortal or 0) then return 'errRate' end
 s.nextPortal=os.clock()+1.2
 local started=os.clock()
 s.portalPending=true
 if workspace.StreamingEnabled then
  local streamed=pcall(function() s.player:RequestStreamAroundAsync(dest.Position,2) end)
  if not streamed then s.portalPending=nil end
  if not streamed then return 'errPortalLoading' end
  if s.closing or s.lost or s.player.Character~=char or not root.Parent or h.Health<=0 or s.state~='Idle' then s.portalPending=nil return 'errBusy' end
  if not Geometry.contains(source,root.Position,.4) then s.portalPending=nil return 'errPortalDistance' end
 end
 task.wait(math.max(0,.65-(os.clock()-started)))
 s.portalPending=nil
 if s.closing or s.lost or s.player.Character~=char or not root.Parent or h.Health<=0 then return 'errBusy' end
 root.AssemblyLinearVelocity=Vector3.zero root.AssemblyAngularVelocity=Vector3.zero
 char:PivotTo(dest) s.currentBiomeId=nextBiome
 return nil
end
function P.applyLabels(world)
 for _,d in B.list do
  local marker=world.PortalHub.Portals[d.id].PortalPoint
  marker.Label.Text.Text=d.name..'\n'..(d.state=='Open' and 'Войти · ловля с причалов' or d.state=='Released' and 'Магнит II · средние находки' or P.preview(world) and 'Осмотреть' or 'Скоро')
 end
end
return P
