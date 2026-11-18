-- Original geometry built from user-approved turnarounds. Materials follow approved visual-polish references.
local Style=require(script.Parent.SurfaceStyle)
local A={}
local steel=Color3.fromRGB(182,199,203)
local edge=Color3.fromRGB(144,164,173)
local dark=Color3.fromRGB(32,51,61)
local gold=Color3.fromRGB(230,184,74)
local wood=Color3.fromRGB(154,104,71)
local rust=Color3.fromRGB(175,101,62)
local function model(name,asset,version)
    local m=Instance.new("Model") m.Name=name m.WorldPivot=CFrame.identity
    if asset=='A-F-01' or asset=='A-MAGNET' or name=='CleaningBrush' then m:SetAttribute('SurfaceClass','Item') end
    m:SetAttribute("AssetId",asset) m:SetAttribute("ApprovedReferenceVersion",version) m:SetAttribute("Placeholder",false)
    return m
end
local function part(m,name,size,cf,color,shape)
    local p=Instance.new("Part") p.Name=name p.Size=size p.CFrame=cf p.Color=color
    p.Anchored=true p.CanCollide=false p.CanTouch=false p.Material=Enum.Material.SmoothPlastic
    p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth
    if shape then p.Shape=shape end p.Parent=m Style.part(p) return p
end
-- Two crossbars and four overlapping diamonds form an exact chamfered outline.
-- Every surface remains a queryable primitive shared by the cleaning mask.
local function chamfer(m,name,size,cf,color,b)
    b=math.min(b,size.X/3,size.Y/3)
    part(m,name,Vector3.new(size.X-2*b,size.Y,size.Z),cf,color)
    part(m,name,Vector3.new(size.X,size.Y-2*b,size.Z),cf,color)
    for _,x in {-1,1} do for _,y in {-1,1} do
        part(m,name,Vector3.new(b*math.sqrt(2),b*math.sqrt(2),size.Z),cf*CFrame.new(x*(size.X/2-b),y*(size.Y/2-b),0)*CFrame.Angles(0,0,math.pi/4),color)
    end end
end
local function cylinder(m,name,length,diameter,cf,color)
    return part(m,name,Vector3.new(length,diameter,diameter),cf,color,Enum.PartType.Cylinder)
end
local function rod(m,name,a,b,width,color)
    return part(m,name,Vector3.new(width,width,(b-a).Magnitude),CFrame.lookAt((a+b)/2,b),color)
end
local function ring(m,name,center,radius,width,color,plane)
    for i=0,7 do
        local function point(angle)
            if plane=="YZ" then return center+Vector3.new(0,math.cos(angle)*radius,math.sin(angle)*radius) end
            return center+Vector3.new(math.cos(angle)*radius,math.sin(angle)*radius,0)
        end
        rod(m,name,point(i*math.pi/4),point((i+1)*math.pi/4),width,color)
    end
end
function A.robot(dirty)
    local m=model("F-01","A-F-01","r02")
    local metal=dirty and rust or steel local trim=dirty and Color3.fromRGB(139,98,54) or gold
    local rim=dirty and Color3.fromRGB(137,75,46) or edge
    chamfer(m,"Head",Vector3.new(1.42,1.26,.92),CFrame.new(0,2.25,0),rim,.14)
    chamfer(m,"Face",Vector3.new(1.23,1.08,.035),CFrame.new(0,2.25,-.477),metal,.10)
    chamfer(m,"HeadBack",Vector3.new(1.23,1.08,.035),CFrame.new(0,2.25,.477),metal,.10)
    for _,x in {-.34,.34} do
        cylinder(m,"Eye",.065,.26,CFrame.new(x,2.26,-.525)*CFrame.Angles(0,math.pi/2,0),dark)
        cylinder(m,"Ear",.16,.37,CFrame.new(x<0 and -.78 or .78,2.25,0),trim)
    end
    part(m,"Mouth",Vector3.new(.36,.065,.03),CFrame.new(0,1.99,-.51),dark)
    part(m,"Neck",Vector3.new(.38,.18,.38),CFrame.new(0,1.65,0),dark)
    chamfer(m,"Torso",Vector3.new(1.07,.86,.68),CFrame.new(0,1.16,0),metal,.105)
    chamfer(m,"ChestPlate",Vector3.new(.70,.61,.07),CFrame.new(0,1.18,-.383),trim,.065)
    for _,x in {-.23,.23} do for _,y in {-.19,.19} do
        cylinder(m,"ChestBolt",.035,.085,CFrame.new(x,1.18+y,-.435)*CFrame.Angles(0,math.pi/2,0),trim)
    end end
    for _,sign in {-1,1} do
        chamfer(m,"Shoulder",Vector3.new(.35,.36,.47),CFrame.new(sign*.735,1.40,0)*CFrame.Angles(0,0,sign*.10),metal,.055)
        part(m,"Elbow",Vector3.new(.20,.22,.26),CFrame.new(sign*.79,1.13,0),dark)
        chamfer(m,"Hand",Vector3.new(.31,.43,.40),CFrame.new(sign*.83,.91,-.02)*CFrame.Angles(0,0,sign*.10),metal,.055)
        part(m,"Leg",Vector3.new(.25,.34,.32),CFrame.new(sign*.29,.55,0),dark)
        chamfer(m,"Boot",Vector3.new(.56,.34,.035),CFrame.new(sign*.31,.21,-.502),metal,.065)
        part(m,"Foot",Vector3.new(.56,.33,.76),CFrame.new(sign*.31,.22,-.1),metal)
        part(m,"Sole",Vector3.new(.56,.07,.78),CFrame.new(sign*.31,.035,-.1),trim)
    end
    cylinder(m,"WindingHub",.35,.22,CFrame.new(0,1.20,.48)*CFrame.Angles(0,math.pi/2,0),trim)
    ring(m,"WindingKey",Vector3.new(0,1.43,.89),.19,.105,trim,"YZ")
    ring(m,"WindingKey",Vector3.new(0,1.01,.89),.19,.105,trim,"YZ")
    rod(m,"KeySpine",Vector3.new(0,.97,.70),Vector3.new(0,1.47,.70),.105,trim)
    if dirty then
        -- Small surviving metal islands contrast with the mostly rusted shell.
        for _,v in {{-.49,2.72,-.499,.16,.09},{.50,2.15,-.499,.09,.17},{-.46,1.30,-.348,.11,.10},{.86,.91,-.228,.08,.12},{-.32,.31,-.525,.17,.07},{.40,2.64,.499,.13,.09}} do
            part(m,"SurvivingMetal",Vector3.new(v[4],v[5],.008),CFrame.new(v[1],v[2],v[3])*CFrame.Angles(0,0,.25),steel)
        end
    end
    Style.item(m,dirty) m.WorldPivot=CFrame.identity return m
end
function A.magnet()
    local m=model("Magnet","A-MAGNET","r01")
    local root=part(m,"Core",Vector3.new(.1,.1,.1),CFrame.identity,dark) root.Transparency=1 root.CanQuery=false m.PrimaryPart=root
    local turn=CFrame.Angles(0,0,math.pi/2)
    cylinder(m,"YellowHousing",.40,1.2,turn,gold)
    cylinder(m,"UpperRim",.065,1.15,CFrame.new(0,.225,0)*turn,steel)
    cylinder(m,"LowerRim",.065,1.15,CFrame.new(0,-.225,0)*turn,steel)
    cylinder(m,"MagneticFace",.035,1.05,CFrame.new(0,-.275,0)*turn,steel)
    ring(m,"EyeLoop",Vector3.new(0,.48,0),.235,.10,dark,"XY")
    rod(m,"RopeKnot",Vector3.new(0,.64,0),Vector3.new(.08,.81,0),.12,wood)
    rod(m,"RopeEnd",Vector3.new(.08,.81,0),Vector3.new(.25,1.02,0),.11,wood)
    local attach=Instance.new("Attachment") attach.Name="RopeAttachment" attach.Position=Vector3.new(.25,1.02,0) attach.Parent=root
    Style.item(m,false) m.WorldPivot=CFrame.identity return m
end
function A.brush()
    local m=model("CleaningBrush","A-BENCH","r01")
    chamfer(m,"WoodGrip",Vector3.new(1.05,.17,.42),CFrame.new(0,.20,0),wood,.07)
    for x=-4,4 do for z=-1,1 do
        part(m,"Bristles",Vector3.new(.095,.17,.115),CFrame.new(x*.105,.085,z*.12),Color3.fromRGB(235,219,169))
    end end
    Style.item(m,false) m.WorldPivot=CFrame.identity return m
end
function A.bench()
    local m=model("BenchVisual","A-BENCH","r01")
    for _,x in {-2.75,2.75} do for _,z in {-1.7,1.7} do
        local leg=part(m,"WoodLeg",Vector3.new(.50,3,.50),CFrame.new(x,1.5,z),wood) leg.CanCollide=true
        part(m,"CornerBracket",Vector3.new(.56,.52,.56),CFrame.new(x,2.94,z),dark)
    end end
    for _,z in {-1.7,1.7} do part(m,"Apron",Vector3.new(5.5,.56,.22),CFrame.new(0,2.65,z),wood) end
    for _,x in {-2.75,2.75} do part(m,"Apron",Vector3.new(.22,.56,3.4),CFrame.new(x,2.65,0),wood) end
    local top=part(m,"MetalWorktop",Vector3.new(6.4,.25,4.4),CFrame.new(0,3.15,0),steel) top.CanCollide=true
    -- Thin frame leaves the central working mat unobstructed.
    for _,x in {-2.40,2.40} do part(m,"SlotFrame",Vector3.new(.065,.04,2.94),CFrame.new(x,3.31,.27),edge) end
    for _,z in {-1.20,1.74} do part(m,"SlotFrame",Vector3.new(4.865,.04,.065),CFrame.new(0,3.31,z),edge) end
    part(m,"TrayBottom",Vector3.new(.83,.055,.66),CFrame.new(2.46,3.31,-1.55),edge)
    for _,x in {2.02,2.90} do part(m,"TrayWall",Vector3.new(.065,.28,.78),CFrame.new(x,3.46,-1.55),steel) end
    for _,z in {-1.94,-1.16} do part(m,"TrayWall",Vector3.new(.945,.28,.065),CFrame.new(2.46,3.46,z),steel) end
    local brush=A.brush() brush:PivotTo(CFrame.new(-2.06,3.29,-1.62)) brush.Parent=m
    m.WorldPivot=CFrame.identity return m
end
function A.installBench(plot)
    local old=plot:FindFirstChild("BenchVisual") if old then old:Destroy() end
    local trigger=plot.Bench local top=plot.BenchTop local slot=plot.CleaningSlot
    trigger.Transparency=1 trigger.CanCollide=false trigger.CanQuery=false
    top.Transparency=1 top.CanCollide=false top.CanQuery=false
    slot.Size=Vector3.new(4.7,.08,2.8) slot.CFrame=top.CFrame*CFrame.new(0,.18,.27)
    slot:SetAttribute("Placeholder",false) slot:SetAttribute("AssetId","A-BENCH") slot.CanCollide=false
    local visual=A.bench() visual:PivotTo(top.CFrame*CFrame.new(0,-3.15,0)) visual.Parent=plot
    return visual
end
function A.installMagnets(points)
    for _,v in points:GetChildren() do if v.Name=="Winch" or v.Name=="MagnetDisplay" or (v:IsA("Model") and v:GetAttribute("AssetId")=="A-MAGNET") then v:Destroy() end end
    for _,point in points:GetChildren() do if point:IsA("BasePart") and point:GetAttribute("ZoneId") and not point:GetAttribute("PierVisualId") then
        local m=A.magnet() m.Name="MagnetDisplay_"..point.Name m:SetAttribute("PointId",point.Name)
        m:PivotTo(point.CFrame*CFrame.new(2,point.Size.Y/2+.30,0)) m.Parent=points
    end end
end
return A
