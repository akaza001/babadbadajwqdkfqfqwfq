-- Canonical primitive models for the24 user-approved biome-find reference designs r01.
-- Used/carried collectibles: retain their own materials, never the world square normal.
local A={version='0.5.0'} local V=Vector3.new local CF=CFrame.new
local silver=Color3.fromRGB(178,191,194) local steel=Color3.fromRGB(77,89,98)
local ivory=Color3.fromRGB(235,226,201) local gold=Color3.fromRGB(199,152,62)
local teal=Color3.fromRGB(43,133,137) local dark=Color3.fromRGB(38,48,54)
local purple=Color3.fromRGB(87,76,136) local orange=Color3.fromRGB(216,130,55)
local green=Color3.fromRGB(86,112,76) local cyan=Color3.fromRGB(71,200,216)
function A.create(itemId,dirty)
 local n=tonumber(itemId:sub(3)) assert(n and n>=13 and n<=36,'Unknown biome find')
 local m=Instance.new('Model') m.Name=itemId m:SetAttribute('SurfaceClass','Item') m:SetAttribute('Placeholder',false) m:SetAttribute('ApprovedReferenceVersion','biome-finds-r01')
 local index=0
 local function part(name,size,frame,color,shape,keep)
  index+=1 local p=Instance.new('Part') p.Name=name..'_'..index p.Size=size p.CFrame=typeof(frame)=='Vector3' and CF(frame) or frame
  p.Color=color or silver p.Material=Enum.Material.Metal p.Anchored=true p.CanCollide=false p.CanTouch=false p.CanQuery=true p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth
  if shape then p.Shape=shape end
  if dirty and not keep and p.Color.R+p.Color.G+p.Color.B>.5 then
   local tones={Color3.fromRGB(146,74,43),Color3.fromRGB(176,94,51),Color3.fromRGB(123,69,43),Color3.fromRGB(188,109,62)}
   p.Color=p.Color:Lerp(tones[index%4+1],index%5==0 and .48 or .88)
  end
  p.MaterialVariant='' p.Reflectance=0 p.Parent=m return p
 end
 local function rod(name,a,b,width,color,keep)
  return part(name,V(width,width,(b-a).Magnitude),CFrame.lookAt((a+b)/2,b),color,nil,keep)
 end
 local function cyl(name,pos,height,diameter,color,axis,keep)
  return part(name,V(height,diameter,diameter),CF(pos)*(axis=='Z' and CFrame.Angles(0,math.pi/2,0) or axis=='X' and CFrame.identity or CFrame.Angles(0,0,math.pi/2)),color,Enum.PartType.Cylinder,keep)
 end
 local function ball(name,pos,diameter,color,keep)
  return part(name,V(diameter,diameter,diameter),pos,color,Enum.PartType.Ball,keep)
 end
 local function ring(name,center,rx,ry,width,color,plane,rotation)
  local basis=CF(center)*(rotation or CFrame.identity)
  for j=0,11 do local function at(t) return basis*(plane=='XZ' and V(math.cos(t)*rx,0,math.sin(t)*ry) or plane=='YZ' and V(0,math.cos(t)*rx,math.sin(t)*ry) or V(math.cos(t)*rx,math.sin(t)*ry,0)) end
   rod(name,at(j*math.pi/6),at((j+1)*math.pi/6),width,color)
  end
 end
 local function gear(center,r,color,teeth)
  cyl('GearDisk',center,.18,r*1.64,color,'Z') cyl('Axle',center-V(0,0,.14),.18,r*.34,gold,'Z')
  for j=1,teeth or 10 do local a=j*math.pi*2/(teeth or 10) part('GearTooth',V(r*.38,r*.27,.18),CF(center+V(math.cos(a)*r,math.sin(a)*r,0))*CFrame.Angles(0,0,a),color) end
 end
 local function handle(center,width,height,color)
  rod('Handle',center+V(-width/2,0,0),center+V(-width/2,height,0),.18,color)
  rod('Handle',center+V(width/2,0,0),center+V(width/2,height,0),.18,color)
  rod('Handle',center+V(-width/2,height,0),center+V(width/2,height,0),.20,color)
 end
 local function dial(center,width,height,face,pointer)
  part('DialFace',V(width,height,.045),center,face,nil,true)
  rod('DialPointer',center+V(-width*.2,-height*.22,-.04),center+V(width*.28,height*.25,-.04),.055,pointer or dark,true)
  for i=0,4 do local a=math.rad(30+i*30) local r=math.min(width,height)*.43 local pos=center+V(math.cos(a)*r,math.sin(a)*r,-.04)
   part('DialMark',V(.035,.09,.02),CF(pos)*CFrame.Angles(0,0,-a),dark,nil,true)
  end
 end
 local function lantern(body,cage,accent,kerosene)
  cyl('LampFoot',V(0,.22,0),.4,1.35,body) cyl('GlobeLower',V(0,.48,0),.15,1.15,cage)
  local glass=cyl('GlassGlobe',V(0,1.02,0),1.0,.98,ivory,nil,true) glass.Material=Enum.Material.SmoothPlastic glass.Transparency=.12
  for _,x in {-.54,.54} do for _,z in {-.38,.38} do rod('ProtectiveCage',V(x,.42,z),V(x,1.58,z),.12,cage) end end
  cyl('CageBelt',V(0,1.02,0),.09,1.12,cage) cyl('LampCap',V(0,1.62,0),.24,1.3,body) cyl('Vent',V(0,1.86,0),.26,.74,accent)
  if kerosene then ring('CarryHandle',V(0,1.8,0),.68,.82,.14,cage)
  else ring('CarryLoop',V(0,2.18,0),.29,.31,.15,accent) end
 end
 if n==13 then
  cyl('AugerStem',V(0,1.22,0),2.3,.18,silver)
  for i=0,23 do local a=i*math.pi/6 local b=(i+1)*math.pi/6 local one=V(math.cos(a)*.35,.18+i*.075,math.sin(a)*.35) local two=V(math.cos(b)*.35,.18+(i+1)*.075,math.sin(b)*.35)
   part('SpiralBlade',V(.46,.10,(two-one).Magnitude+.04),CFrame.lookAt((one+two)/2,two),Color3.fromRGB(51,119,180))
  end
  rod('Crank',V(0,2.3,0),V(.58,2.65,0),.18,steel) rod('Crank',V(.58,2.65,0),V(.58,3.02,0),.18,steel)
  cyl('IvoryGrip',V(.58,3.08,0),.75,.27,ivory,'X')
 elseif n==14 then
  cyl('ThermosBody',V(0,1.02,0),1.7,1.16,silver) cyl('RubberBase',V(0,.15,0),.25,1.23,dark,nil,true)
  cyl('CopperCap',V(0,2.02,0),.37,1.18,orange) ring('MetalLoop',V(.78,1.65,0),.23,.24,.11,silver)
 elseif n==15 then
  part('RadioCase',V(2.5,1.75,.88),V(0,.9,0),ivory) part('Controls',V(.9,1.36,.06),V(.65,.96,-.48),teal)
  for _,y in {.62,1.25} do cyl('Dial',V(.68,y,-.55),.13,.39,dark,'Z',true) rod('DialLine',V(.68,y,-.63),V(.75,y+.12,-.63),.04,ivory,true) end
  for i=0,3 do part('SpeakerSlot',V(.8,.09,.035),V(-.63,.55+i*.22,-.49),dark,nil,true) end
  handle(V(0,1.76,0),1.65,.5,orange) rod('Antenna',V(1.05,1.75,0),V(1.05,2.9,0),.08,steel) ball('AntennaTip',V(1.05,2.9,0),.14,steel)
 elseif n==16 then
  cyl('CompassCase',V(0,.22,0),.4,1.85,gold) cyl('CompassFace',V(0,.45,0),.035,1.57,ivory,nil,true) ring('CompassBezel',V(0,.48,0),.83,.83,.09,gold,'XZ')
  for i=1,8 do local a=i*math.pi/4 rod('CompassTick',V(math.sin(a)*.60,.49,math.cos(a)*.60),V(math.sin(a)*.73,.49,math.cos(a)*.73),.035,green,true) end
  rod('Needle',V(-.42,.53,.34),V(.42,.53,-.34),.10,green,true) cyl('NeedlePin',V(0,.57,0),.07,.16,gold)
  cyl('OpenLid',V(0,1.3,.84),.16,1.86,gold,'Z') cyl('LidInset',V(0,1.3,.73),.03,1.6,Color3.fromRGB(151,121,63),'Z')
  cyl('Hinge',V(0,.45,.78),1.3,.16,gold,'X') ring('TetherLoop',V(0,.24,-1.1),.19,.20,.10,gold,'XZ')
 elseif n==17 then lantern(green,gold,gold,false)
 elseif n==18 then
  for _,x in {-1.18,1.18} do part('GateFrame',V(.22,1.65,.38),V(x,.98,0),green) end
  for _,y in {.18,1.78} do part('GateFrame',V(2.58,.22,.38),V(0,y,0),green) end
  gear(V(-.48,.92,-.18),.61,gold,10) gear(V(.67,.96,-.18),.42,gold,8)
  rod('DriveLink',V(-.48,.92,-.43),V(.67,.96,-.43),.11,ivory)
  for _,x in {-1.15,1.15} do for _,y in {.22,1.75} do cyl('FrameBolt',V(x,y,-.25),.08,.17,gold,'Z') end end
 elseif n==19 then lantern(steel,steel,orange,false) part('Badge',V(.4,.22,.03),V(0,.24,-.67),ivory)
 elseif n==20 then
  cyl('CrownBody',V(0,.75,0),1.2,1.85,steel) cyl('LowerBearing',V(0,.18,0),.3,1.93,teal) cyl('Band',V(0,.4,0),.15,1.95,ivory)
  cyl('Socket',V(0,1.37,0),.03,.76,dark,nil,true)
  for i=1,6 do local a=i*math.pi/3 part('CuttingTooth',V(.43,.37,.43),CF(math.cos(a)*.81,1.51,math.sin(a)*.81)*CFrame.Angles(0,a,0),orange) end
 elseif n==21 then
  part('SampleCase',V(2.5,1.32,1.25),V(0,.75,0),steel) part('CaseLid',V(2.58,.25,1.32),V(0,1.55,0),steel)
  part('AccentBand',V(2.53,.12,1.28),V(0,.43,0),teal) handle(V(0,1.65,0),1.05,.4,orange)
  for _,x in {-1.1,1.1} do for _,y in {.24,1.46} do for _,z in {-.5,.5} do part('CornerGuard',V(.36,.34,.36),V(x,y,z),orange) end end end
  for _,x in {-.65,.65} do part('Latch',V(.30,.48,.08),V(x,1.25,-.7),ivory) end
 elseif n==22 then lantern(green,green,green,true)
 elseif n==23 then
  for _,x in {-1.05,1.05} do ring('BasketRim',V(x,.76,0),.65,.65,.13,steel,'YZ') end
  for i=1,10 do local a=i*math.pi/5 local y,z=.76+math.sin(a)*.65,math.cos(a)*.65 rod('BasketBar',V(-1.05,y,z),V(1.05,y,z),.09,steel)
   rod('FunnelBar',V(-1.05,y,z),V(-1.5,.76,0),.07,steel)
  end
  ring('CenterBelt',V(0,.76,0),.65,.65,.11,steel,'YZ') ring('CarryLoop',V(0,1.56,0),.18,.2,.09,steel)
 elseif n==24 then
  for i=0,5 do cyl('BellBody',V(0,.3+i*.22,0),.27,2.0-i*.22,Color3.fromRGB(125,143,123)) end
  cyl('BellRim',V(0,.2,0),.18,2.25,steel) cyl('BellOpening',V(0,.08,0),.02,1.8,dark,nil,true) ball('Clapper',V(0,.04,0),.35,gold)
  ring('HangingEye',V(0,1.78,0),.20,.28,.15,steel)
 elseif n==25 then
  ball('PitcherBelly',V(0,1,0),1.85,gold) cyl('PitcherFoot',V(0,.16,0),.19,1.35,gold) cyl('Neck',V(0,1.93,0),.55,1.04,gold) cyl('Rim',V(0,2.22,0),.14,1.17,gold)
  cyl('PitcherOpening',V(0,2.30,0),.025,.85,dark,nil,true) cyl('TurquoiseBand',V(0,1.75,0),.13,1.09,teal)
  ring('PitcherHandle',V(1.02,1.23,0),.53,.72,.16,gold) rod('Spout',V(-.65,1.8,0),V(-1.43,2.22,0),.39,gold)
 elseif n==26 then
  cyl('AstrolabeCase',V(0,1.15,0),.28,2.02,gold,'Z') cyl('Inlay',V(0,1.15,-.17),.03,1.76,teal,'Z',true)
  ring('AstrolabeRim',V(0,1.15,-.22),.93,.93,.10,gold) ring('InnerRing',V(0,1.15,-.23),.58,.58,.075,ivory)
  for i=1,8 do local a=i*math.pi/4 rod('ScaleSpoke',V(math.cos(a)*.33,1.15+math.sin(a)*.33,-.25),V(math.cos(a)*.83,1.15+math.sin(a)*.83,-.25),.055,ivory) end
  rod('Pointer',V(-.64,.51,-.33),V(.64,1.79,-.33),.12,gold) cyl('Pivot',V(0,1.15,-.39),.12,.22,gold,'Z') ring('Suspension',V(0,2.4,0),.20,.23,.12,gold)
 elseif n==27 then
  for _,x in {-1,1} do part('WheelSupport',V(.23,1.8,.6),V(x,.98,0),ivory) end
  part('Base',V(2.45,.25,.9),V(0,.12,0),ivory) gear(V(0,1.12,-.18),.82,gold,10)
  for _,x in {-1,1} do part('BearingCap',V(.3,.4,.65),V(x,.92,0),teal) end
  rod('Axle',V(-1.2,.92,0),V(1.52,.92,0),.25,gold) rod('Crank',V(1.52,.92,0),V(1.52,.5,0),.18,gold) rod('CrankGrip',V(1.52,.5,0),V(1.9,.5,0),.23,ivory)
 elseif n==28 then
  local glass=cyl('GlassJar',V(0,.94,0),1.45,1.6,Color3.fromRGB(153,123,190),nil,true) glass.Material=Enum.Material.SmoothPlastic glass.Transparency=.38
  cyl('MetalJarBase',V(0,.16,0),.22,1.65,steel) cyl('ScrewLid',V(0,1.81,0),.30,1.75,steel)
  for i=1,10 do local a=i*math.pi/5 part('LidGrip',V(.12,.24,.13),CF(math.cos(a)*.84,1.81,math.sin(a)*.84)*CFrame.Angles(0,a,0),steel) end
  for i=1,5 do local p=ball('Spore',V(math.sin(i*2)*.45,.48+(i%3)*.32,math.cos(i*2)*.35),.18+i%2*.12,Color3.fromRGB(191,143,234),true) p.Material=Enum.Material.Neon end
 elseif n==29 then
  cyl('KettleBelly',V(0,.84,0),1.30,1.85,purple) cyl('KettleBase',V(0,.15,0),.20,1.9,steel) cyl('AccentBand',V(0,.62,0),.17,1.88,teal)
  cyl('Lid',V(0,1.55,0),.20,1.47,steel) cyl('Knob',V(0,1.74,0),.22,.35,steel)
  rod('Spout',V(-.77,1.05,0),V(-1.35,1.65,0),.40,purple) part('SpoutOpening',V(.24,.05,.24),CF(-1.36,1.69,0)*CFrame.Angles(0,0,-.7),dark,nil,true)
  for i=0,8 do local a=i*math.pi/8 local b=(i+1)*math.pi/8 rod('ArchedHandle',V(math.cos(a)*.9,1.2+math.sin(a)*1.1,0),V(math.cos(b)*.9,1.2+math.sin(b)*1.1,0),.17,steel) end
 elseif n==30 then
  part('MeterCase',V(1.65,1.55,.65),V(0,.9,0),silver) part('LowerPanel',V(1.36,.43,.04),V(0,.45,-.35),teal)
  dial(V(0,1.15,-.36),1.23,.68,ivory) cyl('Control',V(0,.48,-.43),.13,.3,steel,'Z')
  cyl('SensorHead',V(0,2.04,0),.35,.86,steel,'Z') cyl('SensorFace',V(0,2.04,-.21),.05,.65,ivory,'Z',true)
  for _,y in {.4,1.45} do rod('SideGrip',V(.83,y,0),V(1.18,y,0),.16,purple) end rod('SideGrip',V(1.18,.4,0),V(1.18,1.45,0),.20,purple)
 elseif n==31 then
  cyl('HammerHandle',V(0,1.03,0),1.9,.25,steel) cyl('Grip',V(0,.85,0),1.28,.39,teal) cyl('ButtCap',V(0,.14,0),.15,.43,silver)
  part('HammerHead',V(1.65,.58,.6),V(0,2.08,0),silver) part('StrikingFace',V(.24,.67,.7),V(-.89,2.08,0),steel)
  part('ChiselEnd',V(.66,.24,.47),CF(.94,2.12,0)*CFrame.Angles(0,0,.22),steel)
 elseif n==32 then
  for _,y in {.18,1.92} do part('CagePlate',V(1.85,.25,1.45),V(0,y,0),steel) end
  for _,x in {-.72,.72} do for _,z in {-.53,.53} do part('CageBar',V(.18,1.65,.18),V(x,1.05,z),steel) end end
  handle(V(0,2.05,0),.7,.38,steel) part('CrystalCradle',V(.85,.25,.85),V(0,.42,0),silver)
  part('CrystalBody',V(.65,.83,.65),CF(0,.98,0)*CFrame.Angles(0,math.pi/4,0),cyan,nil,true) part('CrystalCrown',V(.48,.48,.48),CF(0,1.38,0)*CFrame.Angles(0,0,math.pi/4),cyan,nil,true)
 elseif n==33 then
  part('DetectorCase',V(1.5,1.5,.65),V(0,.94,0),gold) part('FrameBase',V(1.72,.22,.8),V(0,.18,0),steel)
  dial(V(0,1.04,-.36),1.1,.94,ivory,Color3.fromRGB(175,66,51))
  for _,x in {-.65,.65} do for _,y in {.35,1.56} do ball('CaseBolt',V(x,y,-.38),.13,silver) end end
  rod('ProbeArm',V(-.75,.9,0),V(-1.43,.9,0),.18,steel) ring('ProbeLoop',V(-1.52,.9,0),.49,.49,.13,steel)
  part('SensorCrystal',V(.35,.50,.35),CF(0,1.94,0)*CFrame.Angles(0,0,math.pi/4),cyan,nil,true)
 elseif n==34 then
  cyl('WeatherCase',V(0,1.25,0),.55,2.12,ivory,'Z') cyl('GoldBezel',V(0,1.25,-.32),.13,1.91,gold,'Z') cyl('SkyDial',V(0,1.25,-.41),.035,1.65,Color3.fromRGB(131,196,199),'Z',true)
  rod('WeatherNeedle',V(-.25,.96,-.46),V(.49,1.77,-.46),.07,dark,true) cyl('NeedlePin',V(-.25,.96,-.51),.08,.18,gold,'Z')
  for i=1,7 do local a=math.rad(18+i*20) part('WeatherMark',V(.035,.1,.02),CF(math.cos(a)*.7,1.25+math.sin(a)*.7,-.46)*CFrame.Angles(0,0,-a),dark,nil,true) end
  for _,x in {-.9,.9} do cyl('TealBolt',V(x,1.25,-.35),.08,.18,teal,'Z') end cyl('TealBolt',V(0,2.24,-.35),.08,.18,teal,'Z')
  part('WeatherFoot',V(1.7,.25,.85),V(0,.14,0),ivory)
 elseif n==35 then
  cyl('PropellerHub',V(0,1.8,0),.55,.95,gold,'Z') cyl('HubCap',V(0,1.8,-.34),.12,.61,gold,'Z')
  for i=1,4 do local a=math.pi/4+i*math.pi/2 local basis=CF(0,1.8,0)*CFrame.Angles(0,0,a)
   part('IvoryBlade',V(.55,1.0,.20),basis*CF(0,1.0,0),ivory) cyl('BladeRoundEnd',(basis*CF(0,1.5,0)).Position,.20,.55,ivory,'Z')
   cyl('CyanBolt',(basis*CF(0,.30,-.34)).Position,.08,.15,teal,'Z')
  end
 else
  ball('StarSphere',V(0,1.56,0),1.7,Color3.fromRGB(43,79,112),true)
  ring('ArmillaryRing',V(0,1.56,0),1.0,1.0,.12,gold,'XY') ring('ArmillaryRing',V(0,1.56,0),1.0,1.0,.12,gold,'XZ')
  ring('ArmillaryRing',V(0,1.56,0),1.0,1.0,.12,gold,'XY',CFrame.Angles(0,.9,.5))
  for _,v in {V(-.35,1.94,-.76),V(.45,1.74,-.76),V(-.24,1.14,-.76)} do part('Star',V(.14,.14,.035),CF(v)*CFrame.Angles(0,0,math.pi/4),gold) end
  cyl('GlobeStand',V(0,.4,0),.55,.63,ivory) cyl('GlobeBase',V(0,.14,0),.25,1.62,ivory)
  for _,x in {-.45,.45} do part('StandInlay',V(.35,.16,.04),V(x,.16,-.72),teal) end
 end
 local cf,size=m:GetBoundingBox() local offset=V(-cf.X,-(cf.Y-size.Y/2),-cf.Z)
 for _,p in m:GetChildren() do if p:IsA('BasePart') then p.CFrame+=offset end end
 m.WorldPivot=CFrame.identity return m
end
return A
