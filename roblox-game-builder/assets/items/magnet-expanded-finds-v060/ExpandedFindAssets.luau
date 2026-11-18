-- 72 carried collectibles from approved biome boards; geometry shared by Dirty/Clean.
-- No world normal maps. Deterministic primitives support CleaningGeometry ray masks.
local Catalog=require(script.Parent.ItemCatalog)
local A={version='0.6.0'} local V=Vector3.new local CF=CFrame.new
local palettes={
 ['BIO-02']={{77,168,214},{236,142,39}},['BIO-03']={{39,132,100},{216,173,64}},
 ['BIO-04']={{69,73,81},{225,123,37}},['BIO-05']={{63,110,100},{175,129,57}},
 ['BIO-06']={{39,166,166},{224,178,66}},['BIO-07']={{124,73,168},{101,191,164}},
 ['BIO-08']={{126,81,170},{72,204,220}},['BIO-10']={{67,137,195},{224,187,91}}}
function A.create(id,dirty)
 local d=assert(Catalog.byId[id],'Unknown find') local n=tonumber(id:sub(3)) assert(n>=37 and n<=108)
 local m=Instance.new('Model') m.Name=id m:SetAttribute('SurfaceClass','Item') m:SetAttribute('Placeholder',false)
 m:SetAttribute('ApprovedReferenceVersion','biome-finds-expansion-r01+replacements-r01') m:SetAttribute('FindAssetsVersion',A.version)
 m:SetAttribute('Rarity',d.rarity) m:SetAttribute('BiomeId',d.biomeId) m:SetAttribute('FindState',dirty and 'Dirty' or 'Clean')
 local p=palettes[d.biomeId] local main=Color3.fromRGB(table.unpack(p[1])) local accent=Color3.fromRGB(table.unpack(p[2]))
 local steel=Color3.fromRGB(166,182,192) local dark=Color3.fromRGB(42,52,62) local cream=Color3.fromRGB(234,225,199)
 local cyan=Color3.fromRGB(83,214,226) local wood=Color3.fromRGB(132,85,49)
 local index=0
 local function part(name,size,frame,color,shape,material)
  index+=1 local q=Instance.new('Part') q.Name=name..'_'..index q.Size=size q.CFrame=typeof(frame)=='Vector3' and CF(frame) or frame
  q.Color=color or main q.Material=material or Enum.Material.Metal q.Anchored=true q.CanCollide=false q.CanTouch=false q.CanQuery=true
  q.TopSurface=Enum.SurfaceType.Smooth q.BottomSurface=Enum.SurfaceType.Smooth q.MaterialVariant='' q.Reflectance=0
  q:SetAttribute('CleanColor',q.Color) q:SetAttribute('MaterialRole',q.Material.Name)
  if shape then q.Shape=shape end
  if dirty then
   local tones={Color3.fromRGB(145,76,43),Color3.fromRGB(184,104,54),Color3.fromRGB(114,68,43),Color3.fromRGB(132,69,37)}
   local metal=q.Material==Enum.Material.Metal
   q.Color=q.Color:Lerp(tones[(index*7)%4+1],metal and (index%4==0 and .42 or .83) or .36)
  end
  q.Parent=m return q
 end
 local function box(name,x,y,z,a,b,c,color,material) return part(name,V(x,y,z),V(a,b,c),color,nil,material) end
 local function rod(name,a,b,w,color,material) return part(name,V(w,w,(b-a).Magnitude),CFrame.lookAt((a+b)/2,b),color,nil,material) end
 local function cyl(name,center,h,diam,color,axis,material)
  return part(name,V(h,diam,diam),CF(center)*(axis=='Z' and CFrame.Angles(0,math.pi/2,0) or axis=='X' and CFrame.identity or CFrame.Angles(0,0,math.pi/2)),color,Enum.PartType.Cylinder,material)
 end
 local function ball(name,pos,diam,color,material) return part(name,V(diam,diam,diam),pos,color,Enum.PartType.Ball,material) end
 local function ring(name,pos,r,w,color,plane)
  for j=0,11 do
   local function at(t) return pos+(plane=='XZ' and V(math.cos(t)*r,0,math.sin(t)*r) or plane=='YZ' and V(0,math.cos(t)*r,math.sin(t)*r) or V(math.cos(t)*r,math.sin(t)*r,0)) end
   rod(name,at(j*math.pi/6),at((j+1)*math.pi/6),w,color)
  end
 end
 local function handle(pos,w,h,color)
  rod('Handle',pos+V(-w/2,0,0),pos+V(-w/2,h,0),.12,color or accent)
  rod('Handle',pos+V(w/2,0,0),pos+V(w/2,h,0),.12,color or accent)
  rod('Handle',pos+V(-w/2,h,0),pos+V(w/2,h,0),.14,color or accent)
 end
 local function dial(pos,r,color)
  cyl('Bezel',pos,.16,r*2,accent,'Z') cyl('DialFace',pos-V(0,0,.10),.04,r*1.7,color or cream,'Z',Enum.Material.SmoothPlastic)
  rod('Pointer',pos+V(-r*.4,-r*.4,-.14),pos+V(r*.5,r*.4,-.14),.06,main)
  for j=0,7 do local a=j*math.pi/4 box('DialMark',.05,.10,.035,pos.X+math.sin(a)*r*.68,pos.Y+math.cos(a)*r*.68,pos.Z-.14,dark) end
 end
 local function gem(pos,r,color)
  local q=part('Crystal',V(r*.8,r*1.4,r*.8),CF(pos)*CFrame.Angles(0,0,math.pi/4),color or cyan)
  q.Material=Enum.Material.SmoothPlastic
  part('CrystalFacet',V(r*.65,r*.65,r*.65),CF(pos+V(0,r*.35,0))*CFrame.Angles(0,math.pi/4,math.pi/4),color or cyan,nil,Enum.Material.SmoothPlastic)
 end
 local function chest(safe,crystals)
  box('ChestBody',1.75,1.15,1.1,0,.65,0,main) local lid=box('Lid',1.85,.28,1.18,0,1.4,.07,main)
  if crystals and not safe then lid.CFrame=CF(0,1.26,.55)*CFrame.Angles(math.rad(28),0,0)*CF(0,.14,-.48) end
  for _,x in {-.69,.69} do box('IronBand',.16,1.37,1.16,x,.74,0,accent) end
  for _,y in {.18,1.15} do box('IronBand',1.86,.13,1.18,0,y,0,accent) end
  if safe then
   box('Door',1.45,.88,.12,0,.65,-.62,main) ring('Wheel',V(0,.65,-.74),.28,.07,accent)
   for j=0,3 do local a=j*math.pi/2 rod('WheelSpoke',V(0,.65,-.75),V(math.cos(a)*.28,.65+math.sin(a)*.28,-.75),.06,accent) end
   for _,y in {.3,1} do box('Hinge',.16,.25,.16,crystals and -.72 or .72,y,-.72,accent) end
   if crystals then
    local turn=CF(-.72,0,-.62)*CFrame.Angles(0,math.rad(62),0)*CF(.72,0,.62)
    for _,q in m:GetChildren() do if q.Name:match('^Door_') or q.Name:match('^Wheel_') or q.Name:match('^WheelSpoke_') then q.CFrame=turn*q.CFrame end end
    box('VaultRecess',1.32,.85,.025,0,.65,-.57,dark)
   end
  else box('Lock',.28,.38,.15,0,.83,-.66,accent) box('Keyhole',.07,.12,.02,0,.81,-.75,dark) end
  if crystals then for j=-1,1 do gem(safe and V(j*.36,.65,-.67) or V(j*.44,1.31,-.24),.35,cyan) end end
  for _,x in {-.65,.65} do for _,z in {-.38,.38} do box('Foot',.22,.22,.22,x,.06,z,accent) end end
 end
 local function pot(cup,cauldron)
  local r=cup and .48 or .66 cyl('PotBottom',V(0,.2,0),.22,r*2,main)
  ring('Rim',V(0,1.05,0),r,.15,accent,'XZ')
  for j=0,11 do local a=j*math.pi/6 part('PotWall',V(.38,.8,.12),CF(math.cos(a)*r,.62,math.sin(a)*r)*CFrame.Angles(0,-a+math.pi/2,0),main) end
  if cup then ring('CupHandle',V(r+.22,.65,0),.3,.12,accent)
  else for _,x in {-r,r} do ring('PotHandle',V(x,.83,0),.2,.10,accent) end end
  if cauldron then for j=0,2 do local a=j*math.pi*2/3 box('Foot',.22,.3,.22,math.cos(a)*.48,.02,math.sin(a)*.48,accent) end end
 end
 local function lamp(cage)
  cyl('Base',V(0,.12,0),.24,1.18,main) cyl('Glass',V(0,.76,0),1.04,.82,cream,nil,Enum.Material.SmoothPlastic)
  for j=0,5 do local a=j*math.pi/3 rod('Cage',V(math.cos(a)*.48,.23,math.sin(a)*.48),V(math.cos(a)*.48,1.34,math.sin(a)*.48),.08,accent) end
  cyl('Lid',V(0,1.36,0),.18,1.16,main) ring('CarryLoop',V(0,1.68,0),.24,.10,accent)
  if cage then for j=-1,1 do ball('Firefly',V(j*.18,.65+j*.17,-.35),.14,accent,Enum.Material.SmoothPlastic) end end
 end
 local function wheels(x,z,r)
  for _,a in {-x,x} do for _,b in {-z,z} do cyl('RubberWheel',V(a,r,b),.18,r*2,dark,'X',Enum.Material.SmoothPlastic) cyl('Hub',V(a+(a>0 and .10 or -.10),r,b),.04,r*.9,accent,'X') end end
 end
 local function cart()
  box('Bed',1.5,.2,1.7,0,.5,0,main) box('Wall',1.5,.6,.12,0,.84,-.8,main) box('Wall',1.5,.6,.12,0,.84,.8,main)
  for _,x in {-.7,.7} do box('Wall',.12,.6,1.7,x,.84,0,main) end wheels(.8,.57,.26)
 end
 local function blade(name,a,b,width,color) rod(name,a,b,width,color) end
 -- ICE
 if n==37 then
  for _,x in {-.42,.42} do
   box('Boot',.62,.7,.75,x,.63,0,main,Enum.Material.SmoothPlastic) box('Toe',.62,.35,.55,x,.4,-.48,dark,Enum.Material.SmoothPlastic)
   for j=0,2 do box('Lace',.48,.06,.04,x,.54+j*.18,-.4,cream,Enum.Material.Fabric) end
   box('SkateBlade',.08,.15,1.1,x,.10,-.12,steel) box('BladeMount',.13,.25,.55,x,.25,-.05,accent)
  end
 elseif n==38 then
  box('WarmerCase',.95,1.4,.4,0,.72,0,main)
  for j=0,2 do box('HeatingVent',.65,.12,.05,0,.65+j*.23,-.23,accent) end box('Switch',.2,.2,.06,0,.25,-.24,steel)
 elseif n==39 then chest(false,false) handle(V(0,1.54,0),.7,.32)
 elseif n==40 then
  rod('Grip',V(0,.1,0),V(.4,1.7,0),.19,main) rod('PickHead',V(-.5,1.8,0),V(.85,1.6,0),.23,steel)
  rod('PickTip',V(-.5,1.8,0),V(-.72,1.51,0),.12,steel) ring('WristLoop',V(.02,.18,0),.18,.07,accent)
 elseif n==41 then
  cyl('FuelTank',V(0,.4,0),.7,.95,main) cyl('Burner',V(0,.9,0),.25,.4,steel)
  for j=0,3 do local a=j*math.pi/2 rod('PotSupport',V(math.cos(a)*.18,1.06,math.sin(a)*.18),V(math.cos(a)*.64,1.06,math.sin(a)*.64),.13,steel) end
  cyl('FuelValve',V(.55,.6,0),.2,.27,accent,'X')
 elseif n==42 or n==63 or n==92 or n==100 then
  box('Medallion',.85,1.06,.16,0,.65,0,n==92 and steel or accent) box('Inset',.66,.76,.04,0,.65,-.11,n==92 and dark or main)
  ring('HangingEye',V(0,1.27,0),.16,.08,n==92 and steel or accent)
  if n==92 then
   -- Raised numeral geometry remains visible in the cleaning world and all viewports.
   for _,v in {{-.18,.87,.26,.055},{-.075,.76,.055,.22},{-.18,.65,.26,.055},{-.285,.54,.055,.22},{-.18,.43,.26,.055},{.18,.87,.26,.055},{.285,.65,.055,.44}} do box('Number27',v[3],v[4],.045,-v[1],v[2],-.16,steel) end
  elseif n==100 then
   for _,s in {-1,1} do for j=0,2 do box('Wing',.48-j*.08,.14,.14,s*(.55+j*.1),.8-j*.2,0,cream) end end
   ball('BadgeStar',V(0,.86,-.16),.27,accent)
  elseif n==42 then gem(V(0,.66,-.17),.27,cyan)
  else box('AnvilMark',.4,.12,.06,0,.7,-.16,accent) box('AnvilMark',.15,.28,.06,0,.55,-.16,accent) end
 elseif n==43 then
  box('Track',1.02,.38,1.6,0,.25,.22,dark,Enum.Material.SmoothPlastic) box('Chassis',1.25,.35,1.65,0,.64,0,main)
  box('Seat',.72,.25,.66,0,.95,.45,accent,Enum.Material.SmoothPlastic)
  part('Windshield',V(.84,.61,.09),CF(0,1.12,-.48)*CFrame.Angles(-.38,0,0),cyan,nil,Enum.Material.SmoothPlastic)
  for _,x in {-.6,.6} do box('Ski',.20,.12,.92,x,.12,-.95,steel) rod('SkiStrut',V(x,.2,-.7),V(x,.65,-.4),.12,steel) end
  rod('Handlebar',V(-.45,1.12,-.1),V(.45,1.12,-.1),.13,accent)
 elseif n==44 then
  cyl('SearchlightBody',V(0,1.13,0),.7,1.35,main,'Z') cyl('Glass',V(0,1.13,-.38),.06,1.14,cream,'Z',Enum.Material.SmoothPlastic)
  ring('Bezel',V(0,1.13,-.43),.64,.1,steel)
  for _,x in {-.24,.24} do rod('Grille',V(x,.56,-.49),V(x,1.7,-.49),.07,dark) end rod('Grille',V(-.6,1.13,-.49),V(.6,1.13,-.49),.07,dark)
  for _,x in {-.75,.75} do rod('Yoke',V(x,.25,0),V(x,1.2,0),.16,accent) end box('Base',1.55,.24,.8,0,.12,0,main)
 elseif n==45 then
  ball('Helmet',V(0,1,0),1.45,accent) cyl('Collar',V(0,.26,0),.36,1.45,main)
  for _,s in {-1,1} do cyl('SidePorthole',V(s*.7,1,0),.12,.5,cyan,'X',Enum.Material.SmoothPlastic) end
  cyl('FrontPorthole',V(0,1,-.72),.1,.76,cyan,'Z',Enum.Material.SmoothPlastic) ring('PortholeFrame',V(0,1,-.8),.43,.1,accent)
  rod('Guard',V(-.36,1,-.86),V(.36,1,-.86),.07,accent) rod('Guard',V(0,.64,-.86),V(0,1.36,-.86),.07,accent)
 -- JUNGLE / FORGE TOOLS
 elseif n==46 or n==55 then
  for _,s in {-1,1} do
   rod('Handle',V(s*.42,.12,0),V(s*.10,.88,0),.15,main)
   rod('Jaw',V(s*.1,.88,0),V(s*.35,1.35,0),n==46 and .23 or .16,steel)
   if n==55 then rod('JawTip',V(s*.35,1.35,0),V(s*.18,1.52,0),.16,steel) end
  end cyl('PivotBolt',V(0,.88,-.08),.12,.22,accent,'Z')
 elseif n==47 then
  box('WhistleBody',.65,.55,.8,0,.4,0,accent) box('WhistleMouth',.44,.2,.6,0,.3,-.55,accent)
  box('AirSlot',.35,.08,.23,0,.7,-.03,dark) ring('Eye',V(0,.95,.15),.17,.09,accent)
 elseif n==48 or n==57 or n==83 or n==89 then pot(n==83,n==89)
  if n==48 then cyl('Lid',V(0,1.15,0),.12,1.4,steel) handle(V(0,1.22,0),.65,.35) end
  if n==57 then box('Spout',.3,.12,.3,.65,1.08,0,accent) end
  if n==89 then for j=-1,1 do ball('PotionBubble',V(j*.25,1.04,-.12),.23,main,Enum.Material.SmoothPlastic) end end
 elseif n==49 then
  rod('Grip',V(0,.08,0),V(0,.55,0),.21,main) box('Guard',.5,.1,.18,0,.56,0,accent)
  part('MacheteBlade',V(.4,1.2,.09),CF(.12,1.18,0)*CFrame.Angles(0,0,-.15),steel)
 elseif n==50 or n==86 then cart()
  if n==86 then handle(V(0,.9,.85),.65,.75) end
 elseif n==51 then
  cyl('Coin',V(0,.75,0),.15,1.35,accent,'Z') ring('CoinRim',V(0,.75,-.1),.57,.09,main)
  box('TempleGlyph',.14,.55,.05,0,.75,-.14,accent) box('TempleGlyph',.5,.14,.05,0,.55,-.14,accent)
 elseif n==52 then
  box('Mask',1.08,1.25,.3,0,.9,0,accent)
  for _,x in {-.26,.26} do box('Eye',.3,.18,.05,x,1.06,-.19,dark) end box('Nose',.17,.38,.25,0,.85,-.26,main)
  box('Mouth',.38,.12,.05,0,.5,-.19,dark)
  for j=-2,2 do part('Crown',V(.2,.45,.19),CF(j*.23,1.68,0)*CFrame.Angles(0,0,-j*.18),main) end
 elseif n==53 or n==62 or n==77 or n==80 or n==97 or n==98 then chest(n==53 or n==62 or n==98,n==97 or n==98)
  if n==77 then gem(V(0,1.65,0),.24,accent) end
 elseif n==54 then
  box('IdolBody',.75,1.1,.55,0,.75,0,main) box('JaguarHead',1.1,.72,.74,0,1.53,0,accent)
  box('Muzzle',.65,.35,.32,0,1.34,-.47,main)
  for _,s in {-1,1} do
   box('Ear',.27,.28,.25,s*.46,1.97,0,accent) box('Eye',.16,.12,.05,s*.28,1.63,-.4,main)
   box('Paw',.34,.22,.55,s*.37,.15,-.17,accent)
  end rod('Tail',V(.4,.6,.22),V(.68,.96,.36),.15,accent)
 elseif n==56 then
  box('GlovePalm',.8,.75,.35,0,.55,0,main,Enum.Material.Fabric) box('Wrist',.87,.3,.42,0,.13,0,accent)
  for j=0,3 do box('Finger',.17,.58-j*.04,.3,-.31+j*.21,1.08-j*.02,0,steel) end
  part('Thumb',V(.22,.55,.32),CF(-.56,.63,0)*CFrame.Angles(0,0,-.5),steel)
  box('PalmPlate',.63,.45,.08,0,.55,-.21,steel)
 elseif n==58 then
  rod('HammerHandle',V(0,.05,0),V(0,1.25,0),.2,accent) box('HammerHead',1.04,.48,.5,0,1.4,0,steel)
  for _,x in {-.42,.42} do box('HeadBand',.1,.51,.53,x,1.4,0,accent) end
 elseif n==59 then
  cyl('Pipe',V(0,.4,0),1.35,.5,main,'X') cyl('ValveStem',V(0,.85,0),.65,.18,accent)
  ring('ValveWheel',V(0,1.22,0),.5,.1,accent,'XZ')
  for j=0,3 do local a=j*math.pi/2 rod('Spoke',V(0,1.22,0),V(math.cos(a)*.5,1.22,math.sin(a)*.5),.08,accent) end
 elseif n==60 then
  for j=0,5 do box('BellowsFold',1.02-j*.06,.12,.74-j*.04,0,.28+j*.13,0,j%2==0 and Color3.fromRGB(160,43,31) or Color3.fromRGB(108,28,24),Enum.Material.Fabric) end
  box('MetalPlate',1.08,.13,.8,0,.18,0,steel) box('MetalPlate',.78,.13,.6,0,1.03,0,steel)
  for _,x in {-.7,.7} do box('WoodHandle',.4,.18,.25,x,.8,.25,wood,Enum.Material.Wood) end
  cyl('Nozzle',V(0,.4,-.7),.65,.25,accent,'Z')
 elseif n==61 then
  box('AnvilFoot',1.05,.2,.76,0,.1,0,main) box('AnvilWaist',.48,.55,.5,0,.48,0,steel)
  box('AnvilTop',1.45,.28,.68,0,.9,0,steel) rod('Horn',V(-.6,.9,0),V(-1.08,.85,0),.23,steel)
 -- SWAMP
 elseif n==64 then
  for j=0,8 do local a=math.pi*(j/8) local b=math.pi*((j+1)/8) rod('Horseshoe',V(math.cos(a)*.6,1.0-math.sin(a)*.65,0),V(math.cos(b)*.6,1-math.sin(b)*.65,0),.23,main) end
  for _,x in {-.6,.6} do box('ShoeEnd',.24,.42,.2,x,1.12,0,steel) end
 elseif n==65 then
  ring('KeyRing',V(0,1.45,0),.35,.08,steel)
  for j=-1,1 do ring('KeyBow',V(j*.3,1.12,0),.14,.09,accent) rod('KeyStem',V(j*.3,1.02,0),V(j*.3,.35,0),.12,j==0 and steel or accent) box('KeyTooth',.24,.14,.12,j*.3+.06,.35,0,accent) end
 elseif n==66 then
  rod('WoodShaft',V(0,.1,0),V(0,1.35,0),.16,wood,Enum.Material.Wood) rod('HookStem',V(0,1.35,0),V(0,1.8,0),.16,steel)
  rod('Hook',V(0,1.8,0),V(.4,1.93,0),.16,steel) rod('HookPoint',V(.4,1.93,0),V(.48,1.58,0),.13,steel)
 elseif n==67 then
  box('MailBody',1,.75,1.25,0,.55,0,main) box('Roof',1.08,.2,1.3,0,1,0,steel)
  box('Door',.85,.67,.07,0,.56,-.69,main) box('MailSlot',.5,.08,.05,0,.76,-.74,steel)
  rod('Flag',V(.59,.8,0),V(.59,1.45,0),.08,accent) box('FlagTop',.05,.28,.3,.59,1.36,-.12,accent)
 elseif n==68 then
  for _,s in {-1,1} do
   ring('TrapJaw',V(s*.34,.36,0),.45,.13,steel,'XZ')
   for j=0,4 do box('Tooth',.09,.25,.09,s*.34+math.cos(j*math.pi/2)*.37,.53,math.sin(j*math.pi/2)*.37,steel) end
  end box('Trigger',.5,.12,.5,0,.35,0,accent) box('Spring',1.3,.12,.25,0,.12,.45,main)
 elseif n==69 or n==101 then
  dial(V(0,.7,0),.63,n==101 and cream or cream) ring('WatchEye',V(0,1.47,0),.14,.08,accent)
 elseif n==70 then
  cyl('PumpBody',V(0,.65,0),1.15,.65,main) cyl('PumpBase',V(0,.12,0),.24,1.05,steel)
  rod('Outlet',V(0,.8,-.16),V(0,.8,-.55),.23,main) rod('Spout',V(0,.8,-.55),V(0,.62,-.65),.23,main)
  rod('LeverSupport',V(0,1.1,0),V(0,1.65,0),.12,steel) rod('Lever',V(0,1.65,0),V(.68,.6,0),.13,main)
 elseif n==71 then
  box('TubBottom',1.55,.2,.86,0,.36,0,main)
  for _,x in {-.79,.79} do box('TubSide',.16,.7,.92,x,.76,0,cream) end
  for _,z in {-.46,.46} do box('TubSide',1.6,.7,.16,0,.76,z,cream) end
  for _,x in {-.65,.65} do for _,z in {-.35,.35} do ball('TubFoot',V(x,.14,z),.25,accent) end end
 elseif n==72 then
  box('Cabinet',1.2,.6,1,0,.4,0,main) cyl('Record',V(0,.75,0),.05,.87,dark,nil,Enum.Material.SmoothPlastic)
  rod('HornPipe',V(.42,.7,.3),V(.42,1.3,.3),.18,accent)
  for j=0,3 do cyl('Horn',V(.42,1.35,-j*.19+.2),.22,.24+j*.24,accent,'Z') end
  ring('HornRim',V(.42,1.35,-.5),.48,.09,accent) cyl('HornMouth',V(.42,1.35,-.53),.025,.78,dark,'Z')
  rod('ToneArm',V(.36,.84,.3),V(.1,.83,-.2),.08,accent) rod('Crank',V(.6,.4,0),V(.87,.4,0),.1,steel)
 -- OASIS
 elseif n==73 then
  cyl('Saucer',V(0,.14,0),.18,1.3,accent) ring('Rim',V(0,.24,0),.59,.1,main,'XZ')
 elseif n==74 then
  cyl('LampBowl',V(0,.35,0),.48,1.02,accent) cyl('Lid',V(0,.67,0),.14,.75,main)
  gem(V(0,.9,0),.2,main) rod('Spout',V(-.4,.42,0),V(-.95,.75,0),.19,accent) ring('Handle',V(.6,.5,0),.28,.1,accent)
 elseif n==75 then
  cyl('Shield',V(0,.85,0),.17,1.55,main,'Z') ring('ShieldRim',V(0,.85,-.13),.74,.1,accent)
  ball('ShieldBoss',V(0,.85,-.22),.35,accent)
  for j=0,5 do local a=j*math.pi/3 rod('ShieldRay',V(0,.85,-.15),V(math.cos(a)*.6,.85+math.sin(a)*.6,-.15),.07,accent) end
 elseif n==76 then
  ring('KeyBow',V(0,1.35,0),.36,.13,accent) rod('KeyStem',V(0,.1,0),V(0,1.1,0),.18,accent)
  for _,y in {.2,.45} do box('KeyTooth',.4,.12,.17,.12,y,0,accent) end gem(V(0,1.35,-.08),.24,main)
 elseif n==78 then
  ring('RingBand',V(0,.6,0),.45,.16,accent) box('ScarabBase',.65,.5,.16,0,1.13,-.04,accent)
  gem(V(0,1.16,-.18),.35,main)
 elseif n==79 then
  for _,x in {-.7,.7} do box('Tower',.34,1.8,.42,x,.9,0,main) gem(V(x,1.98,0),.3,accent) end
  box('Lintel',1.6,.28,.4,0,1.58,0,accent)
  for j=-3,3 do rod('GateBar',V(j*.16,.08,0),V(j*.16,1.42,0),.07,accent) end
 elseif n==81 then
  cyl('StatueBase',V(0,.12,0),.24,1.15,accent)
  rod('CobraNeck',V(0,.2,0),V(0,1.2,0),.28,accent) box('CobraHood',.85,.85,.21,0,1.15,.08,main)
  box('CobraHead',.5,.32,.45,0,1.63,-.15,accent)
  for _,x in {-.17,.17} do ball('Eye',V(x,1.68,-.4),.1,main) end
 -- MUSHROOM
 elseif n==82 then
  rod('SpoonHandle',V(0,.1,0),V(0,1.1,0),.13,accent) cyl('SpoonBowl',V(0,1.42,0),.12,.65,accent,'Z')
  for j=-1,1 do ball('Spore',V(j*.14,1.4,-.10),.12,main,Enum.Material.SmoothPlastic) end
 elseif n==84 then
  cyl('GlassBottle',V(0,.66,0),1.1,.9,cream,nil,Enum.Material.SmoothPlastic) cyl('PumpLid',V(0,1.28,0),.17,.65,main)
  rod('PumpShaft',V(0,1.3,0),V(0,1.7,0),.12,accent) box('PumpHandle',.5,.12,.18,0,1.72,0,main)
  rod('Nozzle',V(0,1.34,0),V(-.65,1.34,0),.14,accent) handle(V(.4,.7,0),.6,.5)
 elseif n==85 then lamp(true)
 elseif n==87 then
  box('ScalesBase',1.1,.18,.65,0,.1,0,main) rod('Pillar',V(0,.15,0),V(0,1.45,0),.18,main)
  rod('BalanceBeam',V(-.75,1.4,0),V(.75,1.4,0),.12,accent)
  for _,x in {-.65,.65} do
   for _,z in {-.19,.19} do rod('Chain',V(x,1.4,0),V(x,.73,z),.04,accent) end
   cyl('ScalePan',V(x,.68,0),.1,.55,accent) gem(V(x,.86,0),.16,main)
  end
 elseif n==88 then
  cyl('Boiler',V(-.35,.6,0),1.1,.8,accent) cyl('BoilerLid',V(-.35,1.24,0),.18,.85,main)
  rod('CopperTube',V(-.35,1.3,0),V(-.35,1.7,0),.14,accent) rod('CopperTube',V(-.35,1.7,0),V(.55,1.7,0),.14,accent)
  rod('CopperTube',V(.55,1.7,0),V(.55,.8,0),.14,accent) cyl('Receiver',V(.55,.44,0),.75,.5,cream,nil,Enum.Material.SmoothPlastic)
  dial(V(-.35,.7,-.43),.23,cream)
 elseif n==90 then
  ball('BeetleShell',V(0,.55,0),.85,main) ball('Head',V(0,.47,-.5),.48,accent)
  for _,s in {-1,1} do for j=0,2 do rod('Leg',V(s*.25,.45,-.3+j*.3),V(s*.65,.12,-.4+j*.4),.09,accent) end
   ball('Eye',V(s*.14,.55,-.73),.10,cyan,Enum.Material.SmoothPlastic) end
  ring('WindingKey',V(0,1.08,.05),.16,.06,accent) rod('ShellSeam',V(0,.95,-.28),V(0,.95,.3),.035,accent)
 -- CRYSTAL
 elseif n==91 then
  cyl('Lens',V(0,1.15,0),.1,.95,cyan,'Z',Enum.Material.SmoothPlastic) ring('LensFrame',V(0,1.15,-.05),.5,.12,steel)
  rod('Grip',V(0,.1,0),V(0,.7,0),.2,main)
 elseif n==93 then
  ring('SieveRim',V(0,.25,0),.65,.14,main,'XZ')
  for j=-2,2 do local a=j*.18 local l=math.sqrt(.6^2-a^2) rod('Mesh',V(a,.23,-l),V(a,.23,l),.04,steel) rod('Mesh',V(-l,.23,a),V(l,.23,a),.04,steel) end
 elseif n==94 then
  dial(V(0,.57,0),.55) box('OpenLid',1.1,1.08,.1,0,1.65,.08,main) box('Mirror',.87,.83,.035,0,1.65,.01,cyan,Enum.Material.SmoothPlastic)
  cyl('Hinge',V(0,1.1,.05),.88,.15,steel,'X')
 elseif n==95 then
  ball('HelmetShell',V(0,.6,0),1.2,steel) cyl('HelmetBrim',V(0,.22,0),.15,1.58,steel)
  ring('HelmetBand',V(0,.54,0),.61,.09,main,'XZ') gem(V(0,.72,-.61),.34,cyan)
  box('CrownBand',.16,.15,1.1,0,1.15,0,main)
 elseif n==96 then
  cyl('CrystalMount',V(0,.18,0),.25,.9,steel) gem(V(0,.92,0),.82,cyan)
  for _,x in {-.35,.35} do rod('IronProng',V(x,.2,0),V(x,.85,0),.14,steel) end
 elseif n==99 then
  box('GongBase',1.65,.2,.7,0,.12,0,main)
  for _,x in {-.7,.7} do rod('Frame',V(x,.2,0),V(x,1.8,0),.14,steel) end
  rod('FrameTop',V(-.7,1.8,0),V(.7,1.8,0),.17,main)
  cyl('CrystalGong',V(0,.96,0),.16,1.16,cyan,'Z',Enum.Material.SmoothPlastic)
  for _,x in {-.34,.34} do rod('Chain',V(x,1.8,0),V(x,1.4,0),.05,accent) end gem(V(0,1.95,0),.25,main)
 -- SKY
 elseif n==102 then
  cyl('PropellerHub',V(0,.9,0),.28,.4,accent,'Z')
  for j=0,2 do local a=j*math.pi*2/3 part('PropellerBlade',V(.3,.88,.12),CF(math.sin(a)*.52,.9+math.cos(a)*.52,0)*CFrame.Angles(0,0,-a),cream) end
 elseif n==103 or n==108 then
  for j=0,2 do cyl('TelescopeTube',V(0,1,-.42+j*.42),.47,.48+j*.15,main,'Z') end
  cyl('GlassLens',V(0,1,.67),.04,.68,cyan,'Z',Enum.Material.SmoothPlastic)
  if n==108 then
   rod('Mount',V(0,.3,0),V(0,.85,0),.18,accent)
   for j=0,2 do local a=j*math.pi*2/3 rod('TripodLeg',V(0,.45,0),V(math.cos(a)*.65,.04,math.sin(a)*.65),.14,accent) end
  end
 elseif n==104 then
  ring('Helm',V(0,1,0),.57,.11,accent)
  for j=0,7 do local a=j*math.pi/4 rod('Spoke',V(0,1,0),V(math.cos(a)*.82,1+math.sin(a)*.82,0),.10,accent) end
  cyl('Hub',V(0,1,-.1),.2,.3,main,'Z') box('Stand',.3,.65,.35,0,.35,.13,cream) box('Base',1.0,.15,.55,0,.08,.12,accent)
 elseif n==105 then
  ball('BirdBody',V(0,.7,0),.78,cream) box('Head',.52,.5,.48,0,1.22,-.27,main)
  rod('Beak',V(0,1.19,-.48),V(0,1.19,-.78),.15,accent)
  for _,s in {-1,1} do
   box('Wing',.18,.55,.52,s*.4,.76,0,main) ball('Eye',V(s*.27,1.32,-.42),.1,dark)
   rod('Leg',V(s*.18,.45,0),V(s*.18,.14,0),.09,accent) box('Foot',.24,.1,.37,s*.18,.08,-.12,accent)
  end ring('WindingKey',V(0,.93,.47),.17,.07,accent)
 elseif n==106 then
  rod('AnchorShank',V(0,.15,0),V(0,1.65,0),.19,cream) ring('AnchorEye',V(0,1.9,0),.22,.1,accent)
  rod('AnchorStock',V(-.55,1.4,0),V(.55,1.4,0),.13,accent)
  for _,s in {-1,1} do rod('AnchorArm',V(0,.18,0),V(s*.65,.68,0),.2,main) box('Fluke',.26,.4,.18,s*.65,.75,0,main) end
 elseif n==107 then
  cyl('Pedestal',V(0,.12,0),.24,1.05,accent) rod('Stand',V(0,.2,0),V(0,.55,0),.25,accent)
  ball('Globe',V(0,1.15,0),1.08,main,Enum.Material.SmoothPlastic)
  ring('Meridian',V(0,1.15,0),.68,.1,accent) ring('Equator',V(0,1.15,0),.59,.08,accent,'XZ')
  for _,x in {-.65,.65} do ball('Axle',V(x,1.15,0),.18,accent) end
 else error('Unmodelled expanded find '..id) end
 -- Thin deterministic surface chips exist in BOTH states, so cleaning hit geometry is identical.
 -- Four largest components only; bounded 24 patches avoids an unbounded part multiplier.
 local surfaces={}
 for _,q in m:GetChildren() do
  if q:IsA('Part') and q.Size.Magnitude>.5 then table.insert(surfaces,q) end
 end
 table.sort(surfaces,function(a,b)
  local aa=a.Size.X*a.Size.Y+a.Size.X*a.Size.Z+a.Size.Y*a.Size.Z
  local bb=b.Size.X*b.Size.Y+b.Size.X*b.Size.Z+b.Size.Y*b.Size.Z
  if math.abs(aa-bb)<.00001 then return a.Name<b.Name end return aa>bb
 end)
 local patchIndex=0
 local function chip(base,frame,width,height,seed)
  if width<.07 or height<.07 then return end
  patchIndex+=1
  local q=Instance.new('Part') q.Name='SurfaceChip_'..patchIndex q.Size=V(width,height,.008)
  q.CFrame=frame q.Color=base:GetAttribute('CleanColor') or base.Color q.Material=base.Material
  q:SetAttribute('CleanColor',q.Color) q:SetAttribute('MaterialRole',base.Material.Name)
  if dirty then
   local iron={Color3.fromRGB(184,91,40),Color3.fromRGB(119,54,29),Color3.fromRGB(207,124,60)}
   q.Color=base.Material==Enum.Material.Metal and iron[seed%3+1] or q.Color:Lerp(Color3.fromRGB(92,79,48),.55)
  end
  q.Anchored=true q.CanCollide=false q.CanTouch=false q.CanQuery=true q.MaterialVariant=''
  q.TopSurface=Enum.SurfaceType.Smooth q.BottomSurface=Enum.SurfaceType.Smooth
  q:SetAttribute('SurfaceChip',true) q.Parent=m
 end
 for k=1,math.min(4,#surfaces) do
  local b=surfaces[k] local s=b.Size
  if b.Shape==Enum.PartType.Block then
   for _,sign in {-1,1} do for j=1,2 do
    local x=(j==1 and -.19 or .17)*s.X local y=(j==1 and .18 or -.16)*s.Y
    chip(b,b.CFrame*CF(x,y,sign*(s.Z/2+.005))*CFrame.Angles(0,sign==1 and 0 or math.pi,0),s.X*(j==1 and .27 or .36),s.Y*(j==1 and .22 or .29),k+j)
   end end
   for j=1,2 do chip(b,b.CFrame*CF((j==1 and -.16 or .19)*s.X,s.Y/2+.005,(j==1 and .15 or -.18)*s.Z)*CFrame.Angles(-math.pi/2,0,0),s.X*.25,s.Z*.28,k+j+1) end
  elseif b.Shape==Enum.PartType.Cylinder then
   for _,sign in {-1,1} do
    chip(b,b.CFrame*CF(sign*(s.X/2+.005),s.Y*.12,-s.Z*.1)*CFrame.Angles(0,sign*math.pi/2,0),s.Z*.28,s.Y*.25,k)
   end
   for j=1,2 do
    local a=j*1.6 local normal=V(0,math.cos(a),math.sin(a)) local point=normal*s.Y/2+V(s.X*(j==1 and -.13 or .13),0,0)
    chip(b,b.CFrame*CFrame.lookAt(point+normal*.005,point+normal),s.Y*.2,s.X*.35,k+j)
   end
  elseif b.Shape==Enum.PartType.Ball then
   local r=math.min(s.X,s.Y,s.Z)/2
   for j=1,3 do local normal=V(j==1 and -.45 or .35,j==2 and .5 or -.2,j==3 and .8 or -.8).Unit local point=normal*r
    chip(b,b.CFrame*CFrame.lookAt(point+normal*.004,point+normal),r*.35,r*.3,k+j)
   end
  end
 end
 m.WorldPivot=CFrame.identity
 local _,bounds=m:GetBoundingBox() local target=d.maxLengthStuds or 2.5
 m:ScaleTo(target/math.max(bounds.X,bounds.Y,bounds.Z))
 local center,size=m:GetBoundingBox() local delta=V(-center.X,-center.Y+size.Y/2,-center.Z)
 for _,q in m:GetChildren() do if q:IsA('BasePart') then q.CFrame+=delta end end
 m.WorldPivot=CFrame.identity m:SetAttribute('MaxLengthStuds',target)
 return m
end
return A
