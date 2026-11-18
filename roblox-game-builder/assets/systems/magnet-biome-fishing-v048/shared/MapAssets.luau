-- Original static models built from A-WORKSHOP/A-PIER/A-PEDESTAL r01.
-- Logical anchors remain separate from decorative geometry.
local Assets=require(script.Parent.ApprovedAssets)
local Style=require(script.Parent.SurfaceStyle)
local M={}
local timber=Color3.fromRGB(154,104,71)
local endgrain=Color3.fromRGB(172,120,80)
local cream=Color3.fromRGB(245,235,221)
local teal=Color3.fromRGB(66,113,119)
local slate=Color3.fromRGB(32,51,61)
local silver=Color3.fromRGB(182,199,203)
M.defaultTheme=teal
local function model(name,id)
    local m=Instance.new("Model") m.Name=name m.WorldPivot=CFrame.identity
    m:SetAttribute("AssetId",id) m:SetAttribute("ApprovedReferenceVersion","r01") m:SetAttribute("Placeholder",false)
    return m
end
local function box(m,name,size,cf,color,collide,material)
    local p=Instance.new("Part") p.Name=name p.Size=size p.CFrame=cf p.Color=color
    p.Anchored=true p.CanCollide=collide==true p.CanTouch=false
    p.Material=material or Enum.Material.SmoothPlastic
    p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth Style.part(p) p.Parent=m
    return p
end
-- Exact octagonal outline using two crossbars and four diamonds, in the XZ plane.
local function slab(m,name,width,depth,height,y,color,bevel)
    box(m,name,Vector3.new(width-2*bevel,height,depth),CFrame.new(0,y,0),color)
    box(m,name,Vector3.new(width,height,depth-2*bevel),CFrame.new(0,y,0),color)
    for _,x in {-1,1} do for _,z in {-1,1} do
        box(m,name,Vector3.new(bevel*math.sqrt(2),height,bevel*math.sqrt(2)),
            CFrame.new(x*(width/2-bevel),y,z*(depth/2-bevel))*CFrame.Angles(0,math.pi/4,0),color)
    end end
end
function M.pedestal()
    -- Pivot at the old slot centre; upper surface remains exactly y=.5.
    local m=model("PedestalVisual","A-PEDESTAL")
    slab(m,"BottomLip",5,5,.19,-.405,slate,.32)
    slab(m,"WoodBand",4.72,4.72,.59,-.015,timber,.25)
    slab(m,"TopRim",4.94,4.94,.14,.35,slate,.30)
    slab(m,"DisplayTop",4.72,4.72,.08,.46,silver,.27)
    box(m,"Nameplate",Vector3.new(1.85,.24,.04),CFrame.new(0,-.01,-2.38),cream)
    m.WorldPivot=CFrame.identity return m
end
function M.setPedestalState(base,unlocked)
    local visual=base:FindFirstChild("PedestalVisual")
    if not visual then return end
    visual:SetAttribute("Unlocked",unlocked)
    for _,p in visual:GetChildren() do if p.Name=="DisplayTop" then p.Color=unlocked and silver or slate end end
    base:SetAttribute("Unlocked",unlocked)
end
function M.installPedestals(plot)
    local floor=plot.Floor.CFrame
    for _,base in plot.Slots:GetChildren() do if base:IsA("BasePart") then
        local old=base:FindFirstChild("PedestalVisual") if old then old:Destroy() end
        -- Seat the bottom on the actual floor; retain the existing XZ grid.
        local slot=base:GetAttribute("Slot")
        local compact=plot:GetAttribute('CompactWorkshop')
        local x=compact and (12-((slot-1)%3)*7) or (15-((slot-1)%3)*7)
        local z=compact and (-10.5+math.floor((slot-1)/3)*7) or (-11+math.floor((slot-1)/3)*7)
        base.CFrame=floor*CFrame.new(x,.85,z) base.Size=Vector3.new(5,1,5)
        base.Transparency=1 base.CanCollide=false base.CanQuery=false
        base:SetAttribute("AssetId","A-PEDESTAL") base:SetAttribute("ApprovedReferenceVersion","r01") base:SetAttribute("Placeholder",false)
        local visual=M.pedestal() visual:PivotTo(base.CFrame) visual.Parent=base
        -- One compact octagonal collision surface; the centre box stays inside the bevel.
        for _,p in visual:GetChildren() do if p.Name=="DisplayTop" then p.CanCollide=true end end
        M.setPedestalState(base,base:GetAttribute("Slot")<=6)
    end end
end
function M.workshop(compact)
    local m=model("WorkshopVisual","A-WORKSHOP")
    for i=1,16 do
        box(m,"FloorPlank",Vector3.new(47.8,.12,2.47),CFrame.new(0,.29,-20+(i-.5)*2.5),
            i%3==0 and Color3.fromRGB(206,166,112) or Color3.fromRGB(216,177,125),false,Enum.Material.Wood)
    end
    -- The solid wall shells live in the plot, while these boards provide the visible joinery.
    for row=1,4 do
        local y=.35+(row-.5)*.78
        for _,side in {-1,1} do
            local p=box(m,(side<0 and "WainscotLeft" or "WainscotRight")..row,Vector3.new(.15,.75,39),CFrame.new(side*23.43,y,0),teal)
            p:SetAttribute("ThemePanel",true)
        end
        local p=box(m,"WainscotBack"..row,Vector3.new(47,.75,.15),CFrame.new(0,y,19.43),teal)
        p:SetAttribute("ThemePanel",true)
    end
    for _,x in {-24,0,24} do
        for _,z in (x==0 and {19.6} or {-19.3,0,19.6}) do
            box(m,"TimberPost",Vector3.new(1.05,9.9,1.05),CFrame.new(x,5.30,z),timber,true)
            box(m,"PostFoot",Vector3.new(1.35,.45,1.35),CFrame.new(x,.575,z),endgrain)
            box(m,"PostCap",Vector3.new(1.45,.55,1.45),CFrame.new(x,10.05,z),endgrain)
        end
    end
    box(m,"FrontBeam",Vector3.new(47,.85,1),CFrame.new(0,9.85,-19.3),timber,true)
    box(m,"BackBeam",Vector3.new(47,.85,1),CFrame.new(0,9.85,19.6),timber)
    for _,x in {-23.5,23.5} do box(m,"SideBeam",Vector3.new(.8,.8,40),CFrame.new(x,9.85,0),timber) end
    local roof=Instance.new("Model") roof.Name="RoofAssembly" roof.Parent=m
    -- Shallow gable, open full-width entrance. Every overhead piece participates in local cleaning hide.
    local rise,run=3.0,25.0 local angle=math.atan(rise/run)
    for _,side in {-1,1} do
        local cf=CFrame.new(side*12.5,11.8,0)*CFrame.Angles(0,0,-side*angle)
        local suffix=side<0 and "Left" or "Right"
        box(roof,"Roof"..suffix,Vector3.new(math.sqrt(run*run+rise*rise),.42,42),cf,slate,true)
        local fascia=box(roof,"EaveTrim"..suffix,Vector3.new(25.3,.32,.38),cf*CFrame.new(0,-.34,-20.7),teal)
        fascia:SetAttribute("ThemePanel",true)
        box(roof,"RearEave"..suffix,Vector3.new(25.3,.32,.38),cf*CFrame.new(0,-.34,20.7),teal)
    end
    box(roof,"RidgeCap",Vector3.new(.5,.20,42.2),CFrame.new(0,13.44,0),slate)
    -- Closely stepped cream gable fill sits behind the fascia, with a timber king post.
    for _,z in {-19.3,19.6} do
        for row=1,10 do
            box(roof,(z<0 and "FrontGable" or "RearGable")..row,Vector3.new(46*(1-(row-.5)/10),.30,.45),CFrame.new(0,10.15+(row-.5)*.30,z),cream)
        end
        box(roof,z<0 and "FrontKingPost" or "RearKingPost",Vector3.new(.85,3.2,.65),CFrame.new(0,11.72,z),timber)
    end
    for _,p in roof:GetDescendants() do if p:IsA("BasePart") then p:SetAttribute("CleaningOccluder",true) end end
    if compact then
        -- Adapt the approved facade to a smaller footprint. Keep its height so
        -- the full-size cleaning bench and overhead camera stay below the roof.
        for _,p in m:GetDescendants() do if p:IsA('BasePart') then
            local pos=p.Position
            p.CFrame=CFrame.new(pos.X*.7,pos.Y,pos.Z*.7)*p.CFrame.Rotation
            p.Size*=Vector3.new(.7,1,.7)
            if p.Parent==roof and (p.Name=='RoofLeft' or p.Name=='RoofRight' or string.find(p.Name,'Eave')) then
                local left=string.find(p.Name,'Left')~=nil
                p.CFrame=CFrame.new(p.Position)*CFrame.Angles(0,0,(left and 1 or -1)*math.atan(3/17.5))
                if p.Name=='RoofLeft' or p.Name=='RoofRight' then p.Size=Vector3.new(math.sqrt(17.5^2+3^2),p.Size.Y,p.Size.Z) end
            end
        end end
    end
    m.WorldPivot=CFrame.identity return m
end
function M.installWorkshop(plot)
    local old=plot:FindFirstChild("WorkshopVisual") if old then old:Destroy() end
    -- Remove only the obsolete shell pieces replaced by the approved model.
    for _,v in plot:GetChildren() do if v.Name=="Post" or v.Name=="Roof" then v:Destroy() end end
    local floor=plot.Floor floor.Transparency=1 floor.CanCollide=true
    local frame=floor.CFrame
    local compact=plot:GetAttribute('CompactWorkshop')
    local scale=compact and .7 or 1
    local function anchor(p,size,pos,color)
        p.Size=size*Vector3.new(scale,1,scale) p.CFrame=frame*CFrame.new(pos*Vector3.new(scale,1,scale)) p.Color=color
    end
    anchor(plot.BackWall,Vector3.new(48,9.65,.8),Vector3.new(0,5.175,20),cream)
    for _,p in plot:GetChildren() do
        if p.Name=="SideWall" then
            local sign=frame:PointToObjectSpace(p.Position).X<0 and -1 or 1
            anchor(p,Vector3.new(.8,9.65,39.2),Vector3.new(sign*24,5.175,.4),cream)
        elseif p.Name=="PaintPanel" then
            local sign=frame:PointToObjectSpace(p.Position).X<0 and -1 or 1
            anchor(p,Vector3.new(.12,3.12,40),Vector3.new(sign*24.46,1.91,0),teal)
        end
    end
    -- Functional theme anchor, integrated under the front timber beam.
    anchor(plot.Lintel,Vector3.new(45,.22,.12),Vector3.new(0,9.55,-19.86),teal)
    anchor(plot.OwnerBoard,Vector3.new(.74,1.10,.16),Vector3.new(-24,6.5,-19.90),cream)
    for z=1,3 do anchor(plot["Collection"..z],Vector3.new(5.6,1.8,.18),Vector3.new(-11+(z-1)*11,6.8,19.3),cream) end
    -- From the open entrance, the reference places exhibits left and the workbench right.
    plot.Bench.CFrame=frame*CFrame.new(compact and -11 or -15,1.85,compact and 4.5 or 7)
    plot.BenchTop.CFrame=frame*CFrame.new(compact and -11 or -15,3.5,compact and 4.5 or 7)
    plot.CleaningSlot.CFrame=plot.BenchTop.CFrame*CFrame.new(0,.18,.27)
    local benchVisual=plot:FindFirstChild("BenchVisual")
    if benchVisual then benchVisual:PivotTo(plot.BenchTop.CFrame*CFrame.new(0,-3.15,0)) end
    local visual=M.workshop(compact) visual:PivotTo(frame) visual.Parent=plot
    plot:SetAttribute("Placeholder",false) plot:SetAttribute("AssetId","A-WORKSHOP") plot:SetAttribute("ApprovedReferenceVersion","r01")
    return visual
end
function M.setTheme(plot,color)
    for _,p in plot:GetDescendants() do if p:IsA("BasePart") and (p.Name=="PaintPanel" or p.Name=="Lintel" or p:GetAttribute("ThemePanel")) then p.Color=color end end
end
function M.pier()
    -- Local -Z faces water, +Z faces the path. Pivot lies on the deck surface.
    local m=model("PierVisual","A-PIER")
    local collider=box(m,"DeckCollider",Vector3.new(24,.30,16),CFrame.new(0,-.15,0),timber,true)
    collider.Transparency=1
    for i=1,8 do
        box(m,"DeckPlank",Vector3.new(23.8,.30,1.98),CFrame.new(0,-.15,-8+(i-.5)*2),
            i%3==0 and Color3.fromRGB(197,158,108) or Color3.fromRGB(210,174,125),false,Enum.Material.Wood)
    end
    for _,z in {-7.8,7.8} do box(m,"DeckBeam",Vector3.new(24,.65,.55),CFrame.new(0,-.60,z),timber,true) end
    for _,x in {-11.6,11.6} do box(m,"SideBeam",Vector3.new(.55,.65,16),CFrame.new(x,-.60,0),timber) end
    for _,x in {-11,0,11} do for _,z in {-7,7} do
        box(m,"Piling",Vector3.new(1.1,1.8,1.1),CFrame.new(x,-1.5,z),timber,true)
    end end
    for _,x in {-11.35,11.35} do
        for _,z in {-7.4,0,7.4} do
            box(m,"RailPost",Vector3.new(.8,2.55,.8),CFrame.new(x,1.275,z),timber,true)
            box(m,"PostCap",Vector3.new(.95,.16,.95),CFrame.new(x,2.63,z),teal)
        end
        for _,y in {.75,1.95} do box(m,"SideRail",Vector3.new(.5,.44,15.0),CFrame.new(x,y,0),timber,true) end
    end
    for _,z in {-7.83,7.83} do for _,x in {-11.2,11.2} do
        box(m,"BeamBracket",Vector3.new(1.05,.52,.12),CFrame.new(x,-.55,z),teal)
        box(m,"BracketBolt",Vector3.new(.18,.18,.15),CFrame.new(x,-.55,z+math.sign(z)*.10),slate)
    end end
    for step=1,3 do
        box(m,"EntranceStep",Vector3.new(7.6,.20,1.1),CFrame.new(0,-step*.20+.05,8+(step-.5)*1.1),
            Color3.fromRGB(205,166,114),true,Enum.Material.Wood)
    end
    for _,x in {-4,4} do
        box(m,"StairStringer",Vector3.new(.35,.35,3.6),CFrame.new(x,-.33,9.65)*CFrame.Angles(math.atan(.20/1.1),0,0),timber)
    end
    box(m,"SignPost",Vector3.new(.65,2.5,.65),CFrame.new(5,1.25,7.4),timber,true)
    for _,y in {.25,2.10} do box(m,"SignBand",Vector3.new(.72,.25,.72),CFrame.new(5,y,7.4),teal) end
    box(m,"SignArm",Vector3.new(2,.20,.25),CFrame.new(5.7,2.30,7.4),slate)
    local magnet=Assets.magnet() magnet.Name="HangingMagnet" magnet:PivotTo(CFrame.new(6.45,1.28,7.4)) magnet.Parent=m
    m.WorldPivot=CFrame.identity
    require(script.Parent.ShoreAppearance).pier(m)
    return m
end
function M.installPiers(points)
    local old=points:FindFirstChild("ApprovedPiers") if old then old:Destroy() end
    local group=Instance.new("Folder") group.Name="ApprovedPiers" group.Parent=points
    -- One continuous public deck, reusing the approved pier's boards and joinery.
    local pier=model('SharedPier','A-PIER')
    pier:SetAttribute('LayoutVariant','Shared216')
    local collider=box(pier,'DeckCollider',Vector3.new(216,.30,16),CFrame.new(0,-.15,0),timber,true)
    collider.Transparency=1
    for bay=1,9 do
        local x=-108+(bay-.5)*24
        for row=1,8 do
            box(pier,'DeckPlank',Vector3.new(23.94,.30,1.98),CFrame.new(x,-.15,-8+(row-.5)*2),
                row%3==0 and Color3.fromRGB(197,158,108) or Color3.fromRGB(210,174,125),false,Enum.Material.Wood)
        end
        for _,z in {-7.8,7.8} do box(pier,'DeckBeam',Vector3.new(24,.65,.55),CFrame.new(x,-.60,z),timber,true) end
    end
    for x=-105,105,21 do for _,z in {-7,7} do
        box(pier,'Piling',Vector3.new(1.1,2.3,1.1),CFrame.new(x,-1.65,z),timber,true)
    end end
    for _,x in {-107.35,107.35} do
        for _,z in {-7.4,0,7.4} do
            box(pier,'RailPost',Vector3.new(.8,2.55,.8),CFrame.new(x,1.275,z),timber,true)
            box(pier,'PostCap',Vector3.new(.95,.16,.95),CFrame.new(x,2.63,z),teal)
        end
        for _,y in {.75,1.95} do box(pier,'SideRail',Vector3.new(.5,.44,15),CFrame.new(x,y,0),timber,true) end
    end
    for step=1,3 do
        box(pier,'EntranceStep',Vector3.new(208,.20,1.1),CFrame.new(0,-step*.20+.05,8+(step-.5)*1.1),
            Color3.fromRGB(205,166,114),true,Enum.Material.Wood)
    end
    for _,x in {-104,-52,0,52,104} do
        box(pier,'StairStringer',Vector3.new(.35,.35,3.6),CFrame.new(x,-.33,9.65)*CFrame.Angles(math.atan(.20/1.1),0,0),timber)
    end
    local cf=CFrame.new(0,1.4,0)
    pier.WorldPivot=CFrame.identity pier:PivotTo(cf) pier.Parent=group
    for index=1,6 do
        local point=points[string.format('Z-01-P%d',index)]
        point.CFrame=cf*CFrame.new(-90+(index-1)*36,-.4,0) point.Size=Vector3.new(36,.8,16)
        point.Transparency=1 point.CanCollide=false point.CanQuery=false point.CanTouch=false
        point:SetAttribute('PierVisualId',pier.Name) point:SetAttribute('Placeholder',false)
        point:SetAttribute('EquipmentPool',true) point:SetAttribute('CaptionTop',cf.Y+2.8)
        point:SetAttribute('TargetX',point.Position.X) point:SetAttribute('TargetZ',-31)
        point:SetAttribute('TargetWidth',26) point:SetAttribute('TargetDepth',18)
    end
    require(script.Parent.ShoreAppearance).pier(pier)
    return pier
end
return M
