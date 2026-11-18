local C=require(game.ReplicatedStorage.MagnetWorkshop.Shared.Config)
local Geometry=require(game.ReplicatedStorage.MagnetWorkshop.Shared.CleaningGeometry)
local New=require(game.Players.LocalPlayer.PlayerScripts.MagnetWorkshop.CleaningPresentation)
local Old=require(game.ReplicatedStorage.AdminOldCamera056)
local view={slotCFrame=CFrame.identity};local ratios={};local misses={};local cases=0
for _,size in {Vector2.new(1920,1080),Vector2.new(1280,720),Vector2.new(768,437),Vector2.new(568,320),Vector2.new(390,844)} do
 for _,item in C.items do
  local d=Geometry.describe(item.id)
  local cf,_,fov=New.framing(view,d,size,58,0)
  local before=Old.framing(view,d,size,58,0)
  table.insert(ratios,cf.Position.Y/before.Position.Y);cases+=1
  local short=size.Y-58<300;local top=58+(short and 72 or 112);local bottom=size.Y-(short and 48 or 60)
  for step=0,180 do
   local angle=math.pi*step/180;local lift=math.sin(angle)*(d.depth/2+.2)
   local frame=CFrame.new(0,d.height/2+lift,0)*CFrame.Angles(angle,0,0)*CFrame.new(0,-d.height/2,0)
   for _,x in {-d.width/2,d.width/2} do for _,y in {0,d.height} do for _,z in {-d.depth/2,d.depth/2} do
    local p=cf:PointToObjectSpace(frame*Vector3.new(x,y,z));local k=size.Y/2/math.tan(math.rad(fov/2))
    local px=size.X/2+p.X/(-p.Z)*k;local py=size.Y/2-p.Y/(-p.Z)*k
    if (px<16 or px>size.X-16 or py<top or py>bottom or p.Z>=0) and #misses<12 then table.insert(misses,{id=item.id,size=tostring(size),step=step,x=px,y=py}) end
   end end end
  end
  task.wait()
 end
end
table.sort(ratios);return {cases=cases,vertices=cases*181*8,misses=misses,minRatio=ratios[1],medianRatio=ratios[math.ceil(#ratios/2)],maxRatio=ratios[#ratios]}
