-- Deterministic projected surface masks for both sides of the actual primitive model.
-- No runtime Workspace test objects, per-frame rays or client-supplied completion flags.
local C=require(script.Parent.Config)
local Factory=require(script.Parent.FindFactory)
local G={}
local cache={}
local axes={Vector3.xAxis,Vector3.yAxis,Vector3.zAxis}
local function component(v,i) return i==1 and v.X or i==2 and v.Y or v.Z end
local function rayPart(origin,direction,p)
    local o=p.cf:PointToObjectSpace(origin) local d=p.cf:VectorToObjectSpace(direction) local half=p.size/2
    if p.shape==Enum.PartType.Ball then
        -- Roblox Ball queries use the smallest dimension as the sphere diameter.
        local radius=math.min(half.X,half.Y,half.Z)
        o=o/radius d=d/radius local a=d:Dot(d) local b=2*o:Dot(d) local disc=b*b-4*a*(o:Dot(o)-1)
        if disc<0 then return nil end local t=(-b-math.sqrt(disc))/(2*a) return t>=0 and t or nil
    elseif p.shape==Enum.PartType.Cylinder then
        local candidates={} local a=(d.Y/half.Y)^2+(d.Z/half.Z)^2
        local b=2*(o.Y*d.Y/half.Y^2+o.Z*d.Z/half.Z^2) local c=(o.Y/half.Y)^2+(o.Z/half.Z)^2-1
        if a>1e-10 and b*b-4*a*c>=0 then
            local disc=math.sqrt(b*b-4*a*c)
            for _,t in {(-b-disc)/(2*a),(-b+disc)/(2*a)} do if t>=0 and math.abs(o.X+d.X*t)<=half.X+.0001 then table.insert(candidates,t) end end
        end
        if math.abs(d.X)>1e-10 then
            for _,x in {-half.X,half.X} do local t=(x-o.X)/d.X local q=o+d*t if t>=0 and (q.Y/half.Y)^2+(q.Z/half.Z)^2<=1.0001 then table.insert(candidates,t) end end
        end
        if #candidates==0 then return nil end return math.min(table.unpack(candidates))
    else
        local lo,hi=-math.huge,math.huge
        for i=1,3 do
            local x,v,h=component(o,i),component(d,i),component(half,i)
            if math.abs(v)<1e-10 then if math.abs(x)>h then return nil end
            else local a,b=(-h-x)/v,(h-x)/v lo=math.max(lo,math.min(a,b)) hi=math.min(hi,math.max(a,b)) if hi<lo then return nil end end
        end
        return lo>=0 and lo or hi>=0 and hi or nil
    end
end
local function bounds(parts,rotation)
    local low=Vector3.new(math.huge,math.huge,math.huge) local high=-low
    for _,p in parts do for _,x in {-1,1} do for _,y in {-1,1} do for _,z in {-1,1} do
        local v=(rotation*p.cf):PointToWorldSpace(p.size/2*Vector3.new(x,y,z)) low=low:Min(v) high=high:Max(v)
    end end end end
    return low,high
end
function G.surface(desc,side,x,z)
    if math.abs(x)>desc.width/2 or math.abs(z)>desc.depth/2 then return nil end
    local origin=Vector3.new(x,desc.height+1,z) local direction=-Vector3.yAxis
    local best=nil
    for _,p in desc.sideParts[side] do local t=rayPart(origin,direction,p) if t and (not best or t<best) then best=t end end
    return best and origin.Y-best or nil
end
function G.describe(itemId)
    if cache[itemId] then return cache[itemId] end
    assert(C.itemsById[itemId],"Unknown cleaning item")
    local model=Factory.create(itemId,false) local _,size=model:GetBoundingBox() local parts={}
    for _,p in model:GetChildren() do if p:IsA("Part") then table.insert(parts,{name=p.Name,cf=p.CFrame,size=p.Size,color=p.Color,shape=p.Shape,material=p.Material,transparency=p.Transparency}) end end
    model:Destroy()
    local rotation
    if size.X*size.Z>size.X*size.Y*1.025 and size.X*size.Z>=size.Y*size.Z then rotation=CFrame.identity
    elseif size.Y*size.Z>size.X*size.Y*1.025 then rotation=CFrame.Angles(0,0,-math.pi/2)
    else rotation=CFrame.Angles(math.pi/2,0,0) end
    local low,high=bounds(parts,rotation) local extent=high-low
    local scale=math.min(1.3,4.4/extent.X,2.65/extent.Z)
    local offset=Vector3.new(-(low.X+high.X)/2,-low.Y,-(low.Z+high.Z)/2)
    for _,p in parts do local cf=CFrame.new(offset)*rotation*p.cf p.cf=cf.Rotation+cf.Position*scale p.size*=scale end
    local desc={itemId=itemId,parts=parts,width=extent.X*scale,depth=extent.Z*scale,height=extent.Y*scale,grid=C.cleaning.gridResolution,points={{},{}},byId={{},{}},total={0,0}}
    desc.radius=math.min(desc.width,desc.depth)*C.cleaning.brushRadiusRatio
    desc.flip=CFrame.new(0,desc.height,0)*CFrame.Angles(math.pi,0,0)
    desc.sideParts={parts,{}}
    for _,p in parts do table.insert(desc.sideParts[2],{cf=desc.flip*p.cf,size=p.size,shape=p.shape}) end
    for side=1,2 do
        for row=1,desc.grid do for col=1,desc.grid do
            local x=((col-.5)/desc.grid-.5)*desc.width local z=((row-.5)/desc.grid-.5)*desc.depth
            local y=G.surface(desc,side,x,z)
            if y then local id=(row-1)*desc.grid+col local cell={id=id,x=x,z=z,y=y} table.insert(desc.points[side],cell) desc.byId[side][id]=cell end
        end end
        desc.total[side]=#desc.points[side] assert(desc.total[side]>0,"Empty cleaning surface")
    end
    cache[itemId]=desc return desc
end
function G.paint(desc,side,coverage,x,z,dt)
    if not G.surface(desc,side,x,z) then return false end
    for _,cell in desc.points[side] do
        if (cell.x-x)^2+(cell.z-z)^2<=desc.radius^2 then coverage[cell.id]=math.min(1,(coverage[cell.id] or 0)+dt/C.cleaning.secondsPerCell) end
    end
    return true
end
function G.count(desc,side,coverage)
    local cleaned=0 for _,cell in desc.points[side] do if (coverage[cell.id] or 0)>=1 then cleaned+=1 end end return cleaned
end
function G.pack(desc,coverage)
    local bytes={} for i=1,desc.grid^2 do bytes[i]=math.floor(math.clamp(coverage[i] or 0,0,1)*127+.5) end
    return string.char(table.unpack(bytes))
end
return G
