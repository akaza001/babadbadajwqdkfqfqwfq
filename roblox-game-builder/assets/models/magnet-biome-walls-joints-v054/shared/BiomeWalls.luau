-- Extend the approved biome cliffs and SceneKit decorations into solid themed boundaries.
local B=require(script.Parent.BiomeCatalog)
local K=require(script.Parent.SceneKit)
local S=require(script.Parent.SurfaceStyle)
local W={version='0.5.4',innerRadius=79,outerRadius=87,segments=32}
local V=Vector3.new local CF=CFrame.new
local palettes={
 ice={height=18,stone={181,210,225},cap={232,242,245},mat='SmoothPlastic'},
 jungle={height=21,stone={123,140,114},cap={91,143,67},mat='Slate'},
 volcano={height=25,stone={70,73,82},cap={91,89,91},mat='Slate'},
 swamp={height=16,stone={102,113,86},cap={106,142,73},mat='Slate'},
 oasis={height=19,stone={212,186,134},cap={232,207,153},mat='Slate'},
 mushroom={height=20,stone={111,119,143},cap={143,124,173},mat='Slate'},
 crystal={height=23,stone={119,138,162},cap={161,184,207},mat='Slate'},
 sky={height=6,stone={224,225,208},cap={203,167,91},mat='Slate'},
}
local function color(rgb) return Color3.fromRGB(table.unpack(rgb)) end
-- A centre rectangle plus two horizontal wedges makes a disjoint trapezoid.
local function sector(parent,name,index,bottom,height,rgb,material)
 local step=2*math.pi/W.segments local angle=(index-.5)*step
 local inner,outer=W.innerRadius,W.outerRadius local radius=(inner+outer)/2
 local iw=2*inner*math.tan(step/2) local ow=2*outer*math.tan(step/2) local extra=(ow-iw)/2
 local frame=CF(math.sin(angle)*radius,bottom+height/2,math.cos(angle)*radius)*CFrame.Angles(0,angle,0)
 local function finish(p)
  p:SetAttribute('BoundarySolid',true) p:SetAttribute('BoundarySegment',index)
  p:SetAttribute('SurfaceFinish',material==Enum.Material.Slate and 'BiomeStone' or nil) S.part(p)
 end
 local p=K.block(parent,name,V(iw,height,outer-inner),frame,rgb,material,true) finish(p)
 for _,side in {-1,1} do
  local edge=Instance.new('WedgePart') edge.Name=name..'Edge' edge.Size=V(height,extra,outer-inner)
  edge.CFrame=frame*CF(side*(iw/2+extra/2),0,0)*CFrame.Angles(0,0,-side*math.pi/2)
  edge.Color=rgb edge.Material=material edge.Anchored=true edge.CanCollide=true edge.CanQuery=true edge.CanTouch=false
  edge.TopSurface=Enum.SurfaceType.Smooth edge.BottomSurface=Enum.SurfaceType.Smooth finish(edge) edge.Parent=parent
 end
end
function W.apply(world)
 assert(not game:GetService('RunService'):IsRunning(),'Bake biome walls in Edit')
 local totals={biomes=0,parts=0}
 for _,d in B.list do if d.id~='BIO-01' then
  local biome=world.Biomes:FindFirstChild(d.id)
  if biome then
   K.resetNames()
   local old=biome:FindFirstChild('BoundaryWalls') if old then old:Destroy() end
   local wall=K.model(nil,'BoundaryWalls') wall:SetAttribute('BiomeId',d.id) wall:SetAttribute('BoundaryVersion',W.version)
   wall:SetAttribute('SourceRecipe','approved-biome-cliffs/SceneKit/Stud-Asset-Pack')
   local palette=palettes[d.theme] local material=Enum.Material[palette.mat]
   for i=1,W.segments do
    local h=palette.height+((i*7)%5)*.85
    sector(wall,'Wall',i,-6,h+6,color(palette.stone),material)
    sector(wall,'Coping',i,h,.65,color(palette.cap),material)
   end
   -- Cover floating-point cracks at exact wedge seams with a narrow keyed stone.
   -- Its rotated faces and raised top avoid coplanar surfaces against either sector.
   for i=1,W.segments do
    local a=i*2*math.pi/W.segments local nextIndex=i%W.segments+1
    local h=palette.height+math.max((i*7)%5,(nextIndex*7)%5)*.85+1.25
    local radius=83/math.cos(math.pi/W.segments)
    local p=K.block(wall,'JointKey',V(.5,h+6,8.4),CF(math.sin(a)*radius,(h-6)/2,math.cos(a)*radius)*CFrame.Angles(0,a,0),color(palette.stone),material,true)
    p:SetAttribute('BoundarySolid',true) p:SetAttribute('BoundarySegment',i)
    if material==Enum.Material.Slate then p:SetAttribute('SurfaceFinish','BiomeStone') end S.part(p)
   end
   -- Reuse the existing themed decoration recipes, leaving the inner walk and portal free.
   for i=1,12 do
    local a=(i-.5)*math.pi/6 local frame=CF(math.sin(a)*78.5,0,math.cos(a)*78.5)*CFrame.Angles(0,a,0)
    local h=palette.height
    if d.theme=='ice' then K.crystal(wall,frame*CF(0,1,0),4+i%3,Color3.fromRGB(135,208,229))
    elseif d.theme=='jungle' or d.theme=='swamp' then
     local points={frame*V(-.5,h-1,-.5),frame*V(.8,h*.6,-.6),frame*V(-.8,3,-.7)}
     for j=1,2 do K.rod(wall,'WallVine',points[j],points[j+1],.32,color(palette.cap),Enum.Material.Wood,false) end
    elseif d.theme=='volcano' then
     local seam=K.block(wall,'AmberSeam',V(.16,5+i%3,.12),frame*CF(0,8, .44),Color3.fromRGB(239,145,64),Enum.Material.Neon,false)
     seam.CastShadow=false
    elseif d.theme=='oasis' then K.block(wall,'StoneInlay',V(.6,8,.22),frame*CF(0,6,.35),Color3.fromRGB(177,139,76),Enum.Material.Slate,false)
    elseif d.theme=='mushroom' and i%2==0 then K.mushroom(wall,frame*CF(0,.6,-.4),5+i%3,Color3.fromRGB(160,126,194))
    elseif d.theme=='crystal' then K.crystal(wall,frame*CF(0,.8,-.3),5+i%4,i%2==0 and Color3.fromRGB(107,202,222) or Color3.fromRGB(207,154,196))
    end
   end
   for _,p in wall:GetDescendants() do if p:IsA('BasePart') then
    -- All walls are stationary world art, using the saved normal, never an item exemption.
    if p.Material==Enum.Material.Slate then p:SetAttribute('SurfaceFinish','BiomeStone') end S.part(p)
   end end
   local origin=CF(d.origin) for _,p in wall:GetDescendants() do if p:IsA('BasePart') then p.CFrame=origin*p.CFrame end end
   wall.WorldPivot=origin wall.Parent=biome
   biome:SetAttribute('BoundaryWallVersion',W.version) totals.biomes+=1 totals.parts+=#wall:GetDescendants()
   task.wait()
  end
 end end
 world:SetAttribute('BiomeWallsVersion',W.version) return totals
end
return W
