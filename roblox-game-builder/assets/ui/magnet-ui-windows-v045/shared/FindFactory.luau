-- Original low-poly models derived from approved collection board r02.
local Assets=require(script.Parent.ApprovedAssets)
local Style=require(script.Parent.SurfaceStyle)
local F={}
function F.create(itemId,dirty)
    if itemId=='F-01' then return Assets.robot(dirty) end
    local n=tonumber(string.sub(itemId,3)) assert(n and n>=2 and n<=12,'Unknown find')
    local m=Instance.new('Model') m.Name=itemId m:SetAttribute('SurfaceClass','Item') m:SetAttribute('Placeholder',false)
    m:SetAttribute('ApprovedReferenceVersion','visual-polish-r02')
    local metal=Color3.fromRGB(182,199,203) local teal=Color3.fromRGB(53,88,91)
    local dark=Color3.fromRGB(32,44,48) local gold=Color3.fromRGB(224,169,65) local cream=Color3.fromRGB(236,222,188)
    local function part(name,size,cf,color,shape)
        local p=Instance.new('Part') p.Name=name p.Size=size p.CFrame=typeof(cf)=='Vector3' and CFrame.new(cf) or cf
        p.Color=color or teal p.Material=Enum.Material.Metal p.Anchored=true p.CanCollide=false p.CanTouch=false
        if shape then p.Shape=shape end p.Parent=m return p
    end
    local function rod(name,a,b,w,color)
        return part(name,Vector3.new(w,w,(b-a).Magnitude),CFrame.lookAt((a+b)/2,b),color)
    end
    local function cyl(name,center,length,diameter,color,rotation)
        return part(name,Vector3.new(length,diameter,diameter),CFrame.new(center)*(rotation or CFrame.Angles(0,0,math.pi/2)),color,Enum.PartType.Cylinder)
    end
    local function ring(name,center,rx,ry,w,color,plane)
        for j=0,11 do
            local function at(t)
                local a,b=math.cos(t)*rx,math.sin(t)*ry
                return center+(plane=='XZ' and Vector3.new(a,0,b) or Vector3.new(a,b,0))
            end
            rod(name,at(j*math.pi/6),at((j+1)*math.pi/6),w,color)
        end
    end
    if n==2 then
        cyl('EnamelCup',Vector3.new(0,.8,0),1.5,1.3,cream)
        cyl('CupRim',Vector3.new(0,1.57,0),.09,1.40,teal)
        cyl('Opening',Vector3.new(0,1.62,0),.012,1.20,Color3.fromRGB(65,62,49))
        cyl('EnamelBase',Vector3.new(0,.08,0),.10,1.36,teal)
        ring('Handle',Vector3.new(.89,.85,0),.42,.51,.16,teal)
    elseif n==3 then
        cyl('CompassCase',Vector3.new(0,.23,0),.42,2,teal)
        cyl('DialFace',Vector3.new(0,.47,0),.035,1.73,cream)
        ring('Bezel',Vector3.new(0,.50,0),.91,.91,.10,metal,'XZ')
        for j=0,11 do local t=j*math.pi/6 local a=Vector3.new(math.sin(t)*.65,.51,math.cos(t)*.65)
            rod('DialMark',a,Vector3.new(math.sin(t)*.77,.51,math.cos(t)*.77),.035,dark) end
        rod('Needle',Vector3.new(-.44,.56,.44),Vector3.new(.44,.56,-.44),.09,Color3.fromRGB(184,62,47))
        cyl('NeedlePin',Vector3.new(0,.59,0),.04,.19,gold)
        ring('HangingLoop',Vector3.new(0,.20,1.18),.20,.20,.09,gold,'XZ')
    elseif n==4 then
        for j=0,5 do cyl('BellShell',Vector3.new(0,.35+j*.21,0),.24,2.10-j*.22,gold) end
        cyl('BellLip',Vector3.new(0,.22,0),.17,2.36,gold)
        cyl('BellInterior',Vector3.new(0,.12,0),.035,1.84,dark)
        part('Clapper',Vector3.new(.30,.45,.30),Vector3.new(0,.12,0),gold,Enum.PartType.Ball)
        part('Mount',Vector3.new(.52,.92,.15),Vector3.new(0,1.59,.55),teal)
        rod('BellHook',Vector3.new(0,1.8,.52),Vector3.new(0,1.8,0),.19,gold)
    elseif n==5 or n==8 then
        local w=n==5 and 2.6 or 2.5
        if n==5 then part('Post',Vector3.new(.25,2,.25),Vector3.new(0,1,0),teal) end
        local y=n==5 and 2.25 or 1.3
        part('SignFrame',Vector3.new(w,1.62,.22),Vector3.new(0,y,0),teal)
        part('SignFace',Vector3.new(w-.22,1.38,.035),Vector3.new(0,y,-.13),cream)
        for _,x in {-1,1} do for _,v in {-1,1} do cyl('SignBolt',Vector3.new(x*(w/2-.15),y+v*.62,-.16),.04,.09,gold,CFrame.Angles(0,math.pi/2,0)) end end
        if n==5 then
            rod('Arrow',Vector3.new(-.70,y,-.17),Vector3.new(.70,y,-.17),.13,teal)
            rod('Arrow',Vector3.new(.35,y+.30,-.17),Vector3.new(.70,y,-.17),.13,teal)
            rod('Arrow',Vector3.new(.35,y-.30,-.17),Vector3.new(.70,y,-.17),.13,teal)
        else
            part('CoffeeIcon',Vector3.new(.83,.53,.035),Vector3.new(-.08,y-.1,-.17),teal)
            ring('CupHandle',Vector3.new(.45,y-.06,-.17),.20,.21,.065,teal)
            for _,x in {-.25,.1} do rod('Steam',Vector3.new(x,y+.23,-.17),Vector3.new(x+.1,y+.48,-.17),.05,teal) end
            for _,x in {-.8,.8} do ring('Hanger',Vector3.new(x,y+.94,0),.12,.19,.06,gold) end
            rod('Bracket',Vector3.new(-1.28,y+1.23,0),Vector3.new(1.28,y+1.23,0),.13,teal)
        end
    elseif n==6 or n==7 then
        local spread=n==7 and 1.38 or 1.05
        for _,x in {-spread,spread} do
            local c=Vector3.new(x,.62,0)
            ring('WheelTire',c,.57,.57,.17,dark)
            ring('WheelRim',c,.46,.46,.055,cream)
            for j=0,5 do local t=j*math.pi/3 rod('Spoke',c,c+Vector3.new(math.cos(t)*.45,math.sin(t)*.45,0),.025,metal) end
            part('Axle',Vector3.new(.12,.12,.2),c,gold)
        end
        rod('Fork',Vector3.new(spread,.62,0),Vector3.new(.95,2.1,0),.13,teal)
        rod('Handlebar',Vector3.new(.95,2.1,-.48),Vector3.new(.95,2.1,.48),.13,metal)
        for _,z in {-.42,.42} do part('Grip',Vector3.new(.22,.17,.29),Vector3.new(.95,2.1,z),gold) end
        if n==6 then
            part('Deck',Vector3.new(1.8,.13,.48),Vector3.new(-.10,.40,0),cream)
            rod('Frame',Vector3.new(-spread,.62,0),Vector3.new(.8,.40,0),.12,teal)
        else
            local a,b,c=Vector3.new(-spread,.62,0),Vector3.new(-.25,.66,0),Vector3.new(-.55,1.65,0)
            for _,ends in {{a,b},{a,c},{b,c},{b,Vector3.new(spread,.62,0)},{c,Vector3.new(.95,1.65,0)},{b,Vector3.new(.95,1.65,0)}} do rod('Frame',ends[1],ends[2],.12,teal) end
            part('Seat',Vector3.new(.70,.16,.45),Vector3.new(-.55,1.85,0),gold)
            rod('SeatPost',c,Vector3.new(-.55,1.85,0),.09,metal)
            cyl('PedalHub',b,.20,.28,gold,CFrame.Angles(0,math.pi/2,0))
        end
    elseif n==9 then
        part('RadioCase',Vector3.new(2.6,1.65,.85),Vector3.new(0,.85,0),teal)
        part('RadioFace',Vector3.new(2.34,1.38,.045),Vector3.new(0,.85,-.45),cream)
        for j=0,4 do part('Speaker',Vector3.new(1.14,.075,.04),Vector3.new(-.40,.55+j*.19,-.49),dark) end
        cyl('TuningDial',Vector3.new(.77,.81,-.52),.12,.56,gold,CFrame.Angles(0,math.pi/2,0))
        for _,x in {-.78,.78} do rod('HandleUpright',Vector3.new(x,1.67,0),Vector3.new(x,2.02,0),.14,gold) end
        rod('HandleTop',Vector3.new(-.78,2.02,0),Vector3.new(.78,2.02,0),.16,gold)
    elseif n==10 then
        for _,x in {-.92,.92} do cyl('Flange',Vector3.new(x,1.25,0),.22,2.5,teal,CFrame.identity) end
        cyl('CableCore',Vector3.new(0,1.25,0),1.7,1.7,dark,CFrame.identity)
        for j=-6,6 do cyl('CableWrap',Vector3.new(j*.12,1.25,0),.065,1.8,dark,CFrame.identity) end
        for _,x in {-.92,.92} do cyl('Spindle',Vector3.new(x,1.25,0),.31,.38,gold,CFrame.identity) end
        part('Cradle',Vector3.new(2.4,.18,1.1),Vector3.new(0,.10,0),teal)
    elseif n==11 then
        part('Drawer',Vector3.new(2.3,.58,1.6),Vector3.new(0,.30,0),teal)
        part('DrawerFace',Vector3.new(2.05,.38,.06),Vector3.new(0,.30,-.83),cream)
        cyl('DrawerLock',Vector3.new(0,.30,-.88),.06,.18,gold,CFrame.Angles(0,math.pi/2,0))
        part('KeyboardBody',Vector3.new(2.05,.85,1.30),CFrame.new(0,.93,.05)*CFrame.Angles(math.rad(-12),0,0),teal)
        for row=0,2 do for col=0,2 do cyl('Key',Vector3.new((col-1)*.51,1.30+row*.12,-.44+row*.35),.12,.23,gold) end end
        part('DisplayHood',Vector3.new(1.83,.63,.45),Vector3.new(0,1.82,.55),teal)
        part('DisplayFace',Vector3.new(1.52,.33,.035),Vector3.new(0,1.82,.30),cream)
        rod('Crank',Vector3.new(1.13,.85,0),Vector3.new(1.42,1.35,0),.12,gold)
        part('CrankGrip',Vector3.new(.3,.2,.2),Vector3.new(1.48,1.35,0),gold)
    else
        rod('Shank',Vector3.new(0,.25,0),Vector3.new(0,2.65,0),.25,teal)
        ring('Eye',Vector3.new(0,2.83,0),.30,.30,.14,teal)
        rod('Stock',Vector3.new(-.80,2.20,0),Vector3.new(.80,2.20,0),.16,teal)
        for _,sign in {-1,1} do
            rod('Arm',Vector3.new(0,.28,0),Vector3.new(sign*.70,.51,0),.23,teal)
            rod('Arm',Vector3.new(sign*.70,.51,0),Vector3.new(sign*1.13,1.17,0),.23,teal)
            part('Fluke',Vector3.new(.48,.45,.17),CFrame.new(sign*1.1,1.23,0)*CFrame.Angles(0,0,-sign*.35),gold)
        end
    end
    Style.item(m,dirty)
    local cf,size=m:GetBoundingBox() local offset=Vector3.new(-cf.Position.X,-(cf.Position.Y-size.Y/2),-cf.Position.Z)
    for _,p in m:GetChildren() do if p:IsA('BasePart') then p.CFrame+=offset end end
    m.WorldPivot=CFrame.identity return m
end
return F
