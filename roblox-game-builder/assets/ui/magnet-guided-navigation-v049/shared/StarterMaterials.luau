-- Baked starter-only albedo pass. Item geometry and other biome palettes are excluded.
local S=require(script.Parent.SurfaceStyle)
local E=require(script.Parent.EnvironmentAssets)
local M={version='0.4.5'}
function M.apply(w)
 assert(not game:GetService('RunService'):IsRunning(),'Bake starter materials in Edit') S.installMaterials()
 local count=0
 local function dress(root)
  for _,p in root:GetDescendants() do if p:IsA('BasePart') and p.Transparency<1 and not S.isItem(p) then
   local name=p.Name local n=math.floor(math.abs(p.Position.X*3+p.Position.Z*7))%7-3
   local rock=p:IsA('MeshPart') and p.MeshId==E.meshes.Rock or name:match('^RockCore') or name:match('^LayeredRock') or name:match('^Stone')
   local leaf=p:IsA('MeshPart') and (p.MeshId==E.meshes.Leaf or p.MeshId==E.meshes.LeafTall)
   if p.Material==Enum.Material.WoodPlanks then p.Color=Color3.fromRGB(187+n,137+n,86+n) p:SetAttribute('SurfaceFinish','StarterWoodPlanks') p.Reflectance=0
   elseif p.Material==Enum.Material.Wood then
    local bark=name:match('^Trunk') or name:match('^Root') or name:match('^Branch')
    p.Color=bark and Color3.fromRGB(143+n,99+n,56+n) or Color3.fromRGB(153+n,108+n,65+n)
    p:SetAttribute('SurfaceFinish',bark and 'StarterBark' or 'StarterWood') p.Reflectance=0
   elseif p.Material==Enum.Material.Grass then
    p.Color=leaf and Color3.fromRGB(102+n*2,162+n*2,69+n) or Color3.fromRGB(111+n,169+n,73+n)
    p:SetAttribute('SurfaceFinish',leaf and 'StarterLeaves' or 'StarterGrass') p.Reflectance=0
   elseif p.Material==Enum.Material.Slate and rock then
    p.Color=name:match('^RockCore') and Color3.fromRGB(131,145,135) or Color3.fromRGB(151+n,161+n,150+n)
    p:SetAttribute('SurfaceFinish','StarterSlate') p.Reflectance=0
   end
   for _,t in p:GetChildren() do if t:IsA('Texture') and (t.Name=='FinishGrain' or t.Name=='FineGrain') then t:Destroy() end end
   S.part(p) count+=1 if count%600==0 then task.wait() end
  end end
 end
 for _,name in {'RadialShore','BoardwalkFinish','StarterPolish','Plots','Plaza'} do local root=w:FindFirstChild(name) if root then dress(root) end end
 for _,root in w.FinishDecor:GetChildren() do if not root.Name:match('^BIO%-') then dress(root) end end
 local lake=w.Lake lake.Color=Color3.fromRGB(62,166,174) lake.Transparency=.66 lake.Reflectance=.045
 for _,p in w.FinishDecor.MainLakeShore:GetChildren() do if p.Name:match('^Lakebed') then p.Color=Color3.fromRGB(179,191,153) end end
 w:SetAttribute('StarterMaterialsVersion',M.version) w:SetAttribute('BuildVersion',M.version)
 require(script.Parent.ShoreAppearance).lake(w,true)
 return {parts=count,version=M.version}
end
return M
