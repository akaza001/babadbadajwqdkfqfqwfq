-- All kit geometry is stationary World art. Tools/finds use their own factories.
local Style=require(script.Parent.SurfaceStyle)
local K={wood=Color3.fromRGB(139,96,57),metal=Color3.fromRGB(66,84,89),stone=Color3.fromRGB(122,138,127),gold=Color3.fromRGB(190,143,58),paper=Color3.fromRGB(230,224,200)}
local counter=0 local templates={}
function K.resetNames() counter=0 end
function K.model(parent,name)
 local m=Instance.new('Model') m.Name=name m.WorldPivot=CFrame.identity m.Parent=parent return m
end
function K.part(m,name,size,cf,color,material,solid,shape)
 counter+=1 local p=Instance.new('Part') p.Name=name..'_'..counter p.Size=size p.CFrame=cf p.Color=color or K.stone
 p.Material=material or Enum.Material.SmoothPlastic p.Anchored=true p.CanCollide=solid==true p.CanTouch=false p.CanQuery=solid==true
 p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth
 if shape then p.Shape=shape end Style.part(p) p.Parent=m return p
end
function K.block(m,name,size,cf,color,material,solid) return K.part(m,name,size,cf,color,material,solid) end
function K.cylinder(m,name,height,diameter,cf,color,material,solid)
 return K.part(m,name,Vector3.new(height,diameter,diameter),cf*CFrame.Angles(0,0,math.pi/2),color,material,solid,Enum.PartType.Cylinder)
end
function K.ball(m,name,size,cf,color,material) return K.part(m,name,size,cf,color,material,false,Enum.PartType.Ball) end
function K.rod(m,name,a,b,width,color,material,solid)
 return K.part(m,name,Vector3.new(width,width,(b-a).Magnitude),CFrame.lookAt((a+b)/2,b),color,material,solid)
end
function K.ring(m,name,cf,rx,ry,width,color,segments)
 for i=1,segments or 16 do
  local a=(i-1)*math.pi*2/(segments or 16) local b=i*math.pi*2/(segments or 16)
  K.rod(m,name..i,cf*Vector3.new(math.cos(a)*rx,math.sin(a)*ry,0),cf*Vector3.new(math.cos(b)*rx,math.sin(b)*ry,0),width,color,Enum.Material.Metal)
 end
end
function K.mesh(m,kind,size,cf,color,material)
 if not templates[kind] then
  local id=require(script.Parent.EnvironmentAssets).meshes[kind]
  templates[kind]=game.AssetService:CreateMeshPartAsync(Content.fromUri(id),{CollisionFidelity=Enum.CollisionFidelity.Box})
 end
 counter+=1 local p=templates[kind]:Clone() p.Name=kind..'_'..counter p.Size=size p.CFrame=cf p.Color=color p.TextureID=''
 p.Material=material or Enum.Material.Slate p.Anchored=true p.CanCollide=false p.CanTouch=false p.CanQuery=false
 p:SetAttribute('SourcePack','stud-asset-pack-tu-kl') Style.part(p) p.Parent=m return p
end
function K.clearCache() for _,p in templates do p:Destroy() end templates={} end
function K.caption(p,title,detail,top)
 p:SetAttribute('CaptionTop',top or p.Position.Y+3)
 local g=Instance.new('BillboardGui') g.Name='Label' g.Size=UDim2.fromOffset(230,64) g.MaxDistance=48 g.Parent=p
 local t=Instance.new('TextLabel') t.Name='Text' t.Size=UDim2.fromScale(1,1) t.Text=title..(detail and '\n'..detail or '') t.TextWrapped=true t.Parent=g
 require(script.Parent.WorldLabels).apply(g) return g
end
function K.marker(parent,name,cf)
 local p=K.part(parent,name,Vector3.one,cf,K.paper) p.Name=name p.Transparency=1 return p
end
function K.lamp(m,cf,color,scale)
 scale=scale or 1
 K.block(m,'LampCap',Vector3.new(.9,.15,.9)*scale,cf*CFrame.new(0,.7*scale,0),K.metal,Enum.Material.Metal)
 K.block(m,'Lamp',Vector3.new(.6,1,.6)*scale,cf,color or Color3.fromRGB(247,190,89),Enum.Material.Neon)
 K.block(m,'LampBase',Vector3.new(.9,.15,.9)*scale,cf*CFrame.new(0,-.7*scale,0),K.metal,Enum.Material.Metal)
end
function K.tree(m,cf,h,color,theme)
 h=h*1.35
 local key=string.format('Tree_%d_%d',math.round(cf.X*10),math.round(cf.Z*10))
 local t=K.model(m,key) t:SetAttribute('TreeVisualVersion','0.3.3') t:SetAttribute('TreeTheme',theme or 'forest') t:SetAttribute('TreeHeight',h)
 local trunk=K.mesh(t,'Trunk',Vector3.new(h*.17,h,h*.17),cf*CFrame.new(0,h/2,0),Color3.fromRGB(116,82,51),Enum.Material.Wood)
 trunk:SetAttribute('SurfaceFinish','Bark') Style.part(trunk)
 local needle=theme=='forest' or theme=='ice'
 for i=1,4 do
  local y=needle and (.37+i*.15) or (.52+i%2*.14)
  local width=needle and (h*(.9-i*.12)) or h*.55
  local x=needle and 0 or (i-2.5)*h*.17
  local shade=color:Lerp(i%2==0 and Color3.fromRGB(159,177,116) or Color3.fromRGB(33,76,52),.10)
  local leaf=K.mesh(t,needle and 'LeafTall' or 'Leaf',Vector3.new(width,h*(needle and .28 or .38),width*.93),cf*CFrame.new(x,h*y,(i%2-.5)*h*.06),shade,Enum.Material.Grass)
  leaf:SetAttribute('SurfaceFinish','Foliage') Style.part(leaf)
  if theme=='ice' then K.mesh(t,'LeafTall',Vector3.new(width*.97,h*.1,width*.9),cf*CFrame.new(x,h*y+h*.105,0),Color3.fromRGB(226,237,239),Enum.Material.Slate) end
 end
 for _,side in {-1,1} do
  K.rod(t,'Root',cf*Vector3.new(0,.3,0),cf*Vector3.new(side*h*.13,.12,h*.07),h*.045,K.wood,Enum.Material.Wood)
  if theme=='swamp' or theme=='jungle' then K.rod(t,'Branch',cf*Vector3.new(0,h*.48,0),cf*Vector3.new(side*h*.32,h*.75,.4),h*.055,K.wood,Enum.Material.Wood) end
 end
 t.WorldPivot=cf return t
end
function K.palm(m,cf,h)
 for i=1,4 do K.block(m,'PalmTrunk',Vector3.new(1.4,h/4+.1,1.4),cf*CFrame.new(i*.27,(i-.5)*h/4,0)*CFrame.Angles(0,0,-.07),K.wood,Enum.Material.Wood) end
 for i=1,6 do
  local rot=cf*CFrame.new(1,h,0)*CFrame.Angles(0,i*math.pi/3,0)
  K.block(m,'PalmFrond',Vector3.new(2,.45,6),rot*CFrame.new(0,0,2.1)*CFrame.Angles(-.18,0,0),Color3.fromRGB(85,137,62),Enum.Material.Grass)
 end
end
function K.mushroom(m,cf,h,color)
 K.cylinder(m,'MushroomStem',h,h*.19,cf*CFrame.new(0,h/2,0),K.paper)
 K.ball(m,'MushroomCap',Vector3.new(h*.95,h*.35,h*.95),cf*CFrame.new(0,h,0),color)
 K.cylinder(m,'MushroomGills',.12,h*.72,cf*CFrame.new(0,h*.94,0),Color3.fromRGB(172,128,220),Enum.Material.Neon)
 for i=1,5 do local a=i*math.pi*2/5 K.ball(m,'CapSpot',Vector3.new(h*.12,h*.05,h*.12),cf*CFrame.new(math.cos(a)*h*.24,h*1.14,math.sin(a)*h*.24),K.paper) end
end
function K.crystal(m,cf,h,color)
 K.block(m,'Crystal',Vector3.new(h*.28,h*.76,h*.28),cf*CFrame.new(0,h*.38,0),color)
 local tip=K.block(m,'CrystalTip',Vector3.new(h*.25,h*.25,h*.25),cf*CFrame.new(0,h*.83,0)*CFrame.Angles(0,0,math.pi/4),color)
 tip.Material=Enum.Material.Neon tip.Transparency=.3
end
function K.pier(m,cf)
 K.block(m,'PierSupport',Vector3.new(14,.6,12),cf*CFrame.new(0,.8,0),K.wood,Enum.Material.WoodPlanks,true)
 for i=1,9 do K.block(m,'DeckPlank',Vector3.new(1.48,.18,12),cf*CFrame.new((i-5)*1.52,1.18,0),Color3.fromRGB(147+(i%3)*6,104,66),Enum.Material.WoodPlanks) end
 for _,x in {-6,6} do for _,z in {-5,5} do K.block(m,'Piling',Vector3.new(.9,4,.9),cf*CFrame.new(x,-.2,z),K.wood,Enum.Material.Wood,true) end end
 K.lamp(m,cf*CFrame.new(-5,3,-4),nil,.8)
end
function K.hut(m,cf,color,roof)
 K.block(m,'HutFloor',Vector3.new(16,.8,12),cf*CFrame.new(0,.4,0),K.wood,Enum.Material.WoodPlanks,true)
 K.block(m,'HutRear',Vector3.new(16,9,.6),cf*CFrame.new(0,5,-6),color,nil,true)
 for _,x in {-7.7,7.7} do K.block(m,'HutSide',Vector3.new(.6,9,12),cf*CFrame.new(x,5,0),color,nil,true) end
 for _,x in {-5.3,5.3} do K.block(m,'HutFront',Vector3.new(5.3,9,.6),cf*CFrame.new(x,5,6),color,nil,true) K.block(m,'Window',Vector3.new(2.2,2.8,.15),cf*CFrame.new(x,5.8,6.4),Color3.fromRGB(242,182,83),Enum.Material.Neon) end
 for _,side in {-1,1} do K.block(m,'Roof',Vector3.new(9.5,.7,15),cf*CFrame.new(side*4.1,11,0)*CFrame.Angles(0,0,side*-.32),roof,Enum.Material.WoodPlanks) end
end
return K
