-- World captions use pixel dimensions; their lower edge stays above the object.
local L={}
function L.apply(gui,worldTop)
    local part=gui.Adornee or gui.Parent
    if not part or not part:IsA("BasePart") then return end
    local width=gui.Size.X.Offset>0 and gui.Size.X.Offset or 230
    local height=gui.Size.Y.Offset>0 and gui.Size.Y.Offset or 40
    gui.Size=UDim2.fromOffset(width,height)
    gui.DistanceLowerLimit=20 gui.DistanceUpperLimit=20
    gui.SizeOffset=Vector2.new(0,.5)
    gui.StudsOffset=Vector3.zero
    local top=worldTop or part:GetAttribute("CaptionTop") or part.Position.Y+part.Size.Y/2
    if not worldTop and part.Parent then
        local canopy=part.Parent:FindFirstChild(part.Name.."Canopy")
        if canopy and canopy:IsA("BasePart") then top=math.max(top,canopy.Position.Y+canopy.Size.Y/2) end
        if part.Name=="Bench" then
            local visual=part.Parent:FindFirstChild("BenchVisual")
            if visual then local cf,size=visual:GetBoundingBox() top=math.max(top,cf.Y+size.Y/2) end
        end
    end
    gui.StudsOffsetWorldSpace=Vector3.new(0,top-part.Position.Y+1.5,0)
    gui.AlwaysOnTop=false gui.LightInfluence=0
    for _,v in gui:GetDescendants() do
        if v:IsA("GuiObject") then v.BackgroundTransparency=1 v.BorderSizePixel=0 end
        if v:IsA("TextLabel") then
            v.TextScaled=false v.TextSize=16 v.TextTransparency=0
            v.TextColor3=Color3.fromRGB(245,235,221)
            v.TextStrokeColor3=Color3.fromRGB(32,51,61) v.TextStrokeTransparency=.45
        elseif v:IsA("UICorner") or v:IsA("UIStroke") then v:Destroy() end
    end
end
function L.applyWorld(world)
    for _,v in world:GetDescendants() do if v:IsA("BillboardGui") then L.apply(v) end end
end
return L
