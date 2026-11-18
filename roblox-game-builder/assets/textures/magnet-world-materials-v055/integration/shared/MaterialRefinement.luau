-- Unified, tint-preserving material finish pass. No geometry, overlays or item changes.
local S=require(script.Parent.SurfaceStyle)
local B=require(script.Parent.BiomeCatalog)
local E=require(script.Parent.EnvironmentAssets)
local M={version='0.5.5'}
local function biomeOf(p)
 local node=p
 while node do local id=node:GetAttribute('BiomeId') if id and B.byId[id] then return B.byId[id] end node=node.Parent end
end
local function isCloud(p)
 local node=p
 while node do if node.Name=='Clouds' or node.Name:match('^Cloud_') then return true end node=node.Parent end
 return false
end
function M.apply(world)
 assert(not game:GetService('RunService'):IsRunning(),'Bake texture refinements in Edit')
 S.installMaterials()
 local out={parts=0,finishes={},itemsSkipped=0}
 for _,p in world:GetDescendants() do if p:IsA('BasePart') then
  if S.isItem(p) then out.itemsSkipped+=1
  elseif p.Transparency<1 then
   local d=biomeOf(p) local name=p.Name local finish=p:GetAttribute('SurfaceFinish')
   local isLake=name=='Lake'
   local ripple=p.Parent and p.Parent.Parent==world:FindFirstChild('LakeRipples')
   -- Bench sheet metal used to share the same flat plastic finish as its work mat.
   if name=='MetalWorktop' or name=='SlotFrame' or name=='TrayWall' or name=='TrayBottom' or name=='CornerBracket' then p.Material=Enum.Material.Metal
   elseif name=='Apron' or name=='WoodLeg' then p.Material=Enum.Material.Wood end
   if isLake or ripple then finish='Water'
   elseif p.Material==Enum.Material.WoodPlanks then finish=d and 'BiomeTimber' or 'StarterWoodPlanks'
   elseif p.Material==Enum.Material.Wood then
    local bark=name:match('Trunk') or name:match('^Root') or name:match('^Branch')
    finish=bark and (d and 'BiomeBark' or 'StarterBark') or d and 'BiomeWood' or 'StarterWood'
   elseif p.Material==Enum.Material.Grass then
    local mesh=p:IsA('MeshPart') and (p.MeshId==E.meshes.Leaf or p.MeshId==E.meshes.LeafTall)
    local leaves=mesh or name:match('^Leaf') or name:match('Frond')
    finish=leaves and (d and 'BiomeLeaves' or 'StarterLeaves') or 'Ground'
   elseif p.Material==Enum.Material.Sand then finish='StarterSand'
   elseif p.Material==Enum.Material.Slate then finish=d and d.theme=='oasis' and 'Sandstone' or d and 'BiomeStone' or 'StarterSlate'
   elseif p.Material==Enum.Material.Metal then finish='StarterMetal'
   elseif p.Material==Enum.Material.SmoothPlastic and p.Transparency<.1 then
    if isCloud(p) then finish='StarterSmoothPlastic'
    elseif d and d.theme=='ice' or name:match('^Snow') or name:match('^Ice') or name:match('Crystal') then finish='Frost'
    else finish='Paint' end
   end
   p:SetAttribute('SurfaceFinish',finish)
   if p.Material==Enum.Material.Metal then p.Reflectance=.035
   elseif p.Material==Enum.Material.Wood or p.Material==Enum.Material.WoodPlanks then p.Reflectance=.005
   elseif p.Material==Enum.Material.Slate or p.Material==Enum.Material.Grass or p.Material==Enum.Material.Sand then p.Reflectance=0
   elseif p.Material==Enum.Material.SmoothPlastic and p.Transparency<.1 then p.Reflectance=finish=='Frost' and .025 or .008 end
   if isLake then p.Reflectance=d and .03 or .035 if d then p:SetAttribute('BiomeWaterReflectance',.03) end end
   if ripple then
    local id=p.Parent:GetAttribute('BiomeId') local lake=id=='BIO-01' and world.Lake or world.Biomes:FindFirstChild(id or '') and world.Biomes[id].Lake
    if lake then p.Color=lake.Color:Lerp(Color3.fromRGB(224,240,220),.32) end p.Reflectance=0
   end
   S.part(p) out.parts+=1 local key=finish or p.Material.Name out.finishes[key]=(out.finishes[key] or 0)+1
   if out.parts%600==0 then task.wait() end
  end
 end end
 world:SetAttribute('MaterialRefinementVersion',M.version)
 return out
end
function M.preload()
 task.spawn(function()
  local unique,ids={},{}
  for _,id in S.albedos do if id~='' and not unique[id] then unique[id]=true table.insert(ids,id) end end
  for _,id in S.baseAlbedos or {} do if id~='' and not unique[id] then unique[id]=true table.insert(ids,id) end end
  table.insert(ids,S.normalMap)
  pcall(function() game:GetService('ContentProvider'):PreloadAsync(ids) end)
 end)
end
return M
