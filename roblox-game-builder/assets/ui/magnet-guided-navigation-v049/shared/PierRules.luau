-- Same footprint test on the client and authoritative server.
local PierRules={}
function PierRules.contains(character,point)
    local root=character and character:FindFirstChild("HumanoidRootPart")
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health<=0 or not point or not point:IsA("BasePart") then return false end
    local area=point:GetAttribute('FishArea')
    if area then
        local pos=root.Position local radius=Vector3.new(pos.X,0,pos.Z).Magnitude
        if pos.Y<5 or pos.Y>10 then return false end
        local layout=require(script.Parent.StarterLayout)
        if area=='Ring' then return radius>=103.5 and radius<=108 and layout.bridgeClear(pos.X,pos.Z,9) end
        if area=='Center' then return radius>=53 and radius<=57.5 and layout.bridgeClear(pos.X,pos.Z,9) end
        local v=point.CFrame:PointToObjectSpace(pos)
        return math.abs(v.X)>=4.5 and math.abs(v.X)<=7.3 and v.Z>=60 and v.Z<=102
    end
    local localPosition=point.CFrame:PointToObjectSpace(root.Position)
    return math.abs(localPosition.X)<=point.Size.X/2 and math.abs(localPosition.Z)<=point.Size.Z/2
        and localPosition.Y>=point.Size.Y/2+.5 and localPosition.Y<=point.Size.Y/2+5.5
end
return PierRules
