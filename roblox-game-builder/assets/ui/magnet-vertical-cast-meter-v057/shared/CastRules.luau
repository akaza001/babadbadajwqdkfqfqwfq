-- Shared timing and distance math; the server owns the accepted release time.
local C=require(script.Parent.Config)
local R={}
function R.position(elapsed)
    return (math.max(0,elapsed)%C.cast.sweepSeconds)/C.cast.sweepSeconds
end
function R.powerAt(position)
    return math.clamp(position,0,1)
end
function R.power(elapsed) return R.powerAt(R.position(elapsed)) end
function R.distance(power)
    return C.cast.minDistance+(C.cast.maxDistance-C.cast.minDistance)*math.clamp(power,0,1)
end
function R.direction(origin,point)
 local kind=point:GetAttribute('FishArea')
 if kind=='Ring' or kind=='Center' then return Vector3.new(origin.X,0,origin.Z).Unit*(kind=='Ring' and -1 or 1) end
 if kind=='Bridge' then return point.CFrame.RightVector*(point.CFrame:PointToObjectSpace(origin).X>=0 and 1 or -1) end
 return (point.CFrame.LookVector*Vector3.new(1,0,1)).Unit
end
local function edge(origin,point)
 local kind=point:GetAttribute('FishArea') local forward=R.direction(origin,point)
 if kind=='Ring' then return Vector3.new(origin.X,0,origin.Z).Unit*101 end
 if kind=='Center' then return Vector3.new(origin.X,0,origin.Z).Unit*61 end
 if kind=='Bridge' then local v=point.CFrame:PointToObjectSpace(origin) return point.CFrame*Vector3.new(v.X>=0 and 9 or -9,0,v.Z) end
 return point.Position+forward*(point.Size.Z/2+2)
end
function R.target(origin,point,power,lake)
    local forward=R.direction(origin,point)
    forward=forward.Unit
    local edge=edge(origin,point)
    local target=origin+forward*math.max(R.distance(power),(edge-origin):Dot(forward))
    if lake:GetAttribute('CircularRadius') then
        local center=Vector3.new(lake.Position.X,0,lake.Position.Z)
        local flat=Vector3.new(target.X,0,target.Z)-center local radius=math.clamp(flat.Magnitude,(lake:GetAttribute('InnerRadius') or 0)+4,(lake:GetAttribute('FishOuterRadius') or lake:GetAttribute('CircularRadius')-2))
        if flat.Magnitude>.01 then flat=flat.Unit*radius end
        if point:GetAttribute('FishArea') then
            for _,a in require(script.Parent.StarterLayout).bridgeAngles do
                local d=require(script.Parent.StarterLayout).direction(a) local cross=Vector3.new(d.Z,0,-d.X) local along=flat:Dot(d) local side=flat:Dot(cross)
                if along>55 and math.abs(side)<10 then
                    local sign=origin:Dot(cross)>=0 and 1 or -1
                    -- Keep the bridge clearance without extending a maximum-strength cast.
                    local sideOffset=10*sign local originAlong=origin:Dot(d)
                    local reach=math.sqrt(math.max(0,C.cast.maxDistance^2-(sideOffset-origin:Dot(cross))^2))
                    local safeAlong=math.clamp(math.sqrt(math.max(0,radius*radius-100)),originAlong-reach,originAlong+reach)
                    flat=d*safeAlong+cross*sideOffset
                end
            end
        end
        return Vector3.new(flat.X+center.X,(lake:GetAttribute('WaterSurfaceY') or .25)+.55,flat.Z+center.Z)
    end
    local localPoint=lake.CFrame:PointToObjectSpace(target)
    localPoint=Vector3.new(math.clamp(localPoint.X,-lake.Size.X/2+1,lake.Size.X/2-1),0,
        math.clamp(localPoint.Z,-lake.Size.Z/2+1,lake.Size.Z/2-1))
    local world=lake.CFrame:PointToWorldSpace(localPoint)
    return Vector3.new(world.X,.8,world.Z)
end
function R.retrieveTo(origin,point)
    local forward=R.direction(origin,point)
    local edge=edge(origin,point)
    local along=math.max(0,(edge-origin):Dot(forward))
    local target=origin+forward*along
    return Vector3.new(target.X,.8,target.Z)
end
function R.pullDuration(level,distance)
    local range=math.max(.001,C.cast.maxDistance-C.cast.minDistance)
    local fraction=math.clamp((distance-C.cast.minDistance)/range,0,1)
    return C.toolLevels[level].pullDurationSeconds+fraction*C.pull.distanceExtraSeconds
end
return R
