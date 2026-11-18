-- One server-owned Tool: right-hand magnet, left-hand rope coil.
local Shared=game.ReplicatedStorage.MagnetWorkshop.Shared
local Assets=require(Shared.ApprovedAssets)
local C=require(Shared.Config)
local Style=require(Shared.SurfaceStyle)
local E={}
function E.equipped(s)
    return s.magnetTool~=nil and s.player.Character~=nil and s.magnetTool.Parent==s.player.Character
end
function E.visible(s,visible)
    local tool=s.magnetTool if not tool then return end
    local coil=tool:FindFirstChild('RopeCoil')
    for _,p in tool:GetDescendants() do if p:IsA('BasePart') then
        local show=visible or (coil and p:IsDescendantOf(coil))
        p.Transparency=show and (p:GetAttribute('RestTransparency') or 0) or 1
    end end
    local link=tool:FindFirstChild('HeldRope',true) if link then link.Enabled=visible end
end
function E.update(s)
    local t=s.magnetTool if not t then return end
    t.Name='Магнит' t.ToolTip='Магнит и верёвка · уровень '..s.data.toolLevel..' · до '..C.toolLevels[s.data.toolLevel].maxWeightKg..' кг'
    t:SetAttribute('ToolLevel',s.data.toolLevel)
end
local function physical(part)
    part.Anchored=false part.CanCollide=false part.CanTouch=false part.CanQuery=false part.Massless=true
    part:SetAttribute('RestTransparency',part.Transparency)
end
local function weld(a,b)
    local v=Instance.new('WeldConstraint') v.Part0=a v.Part1=b v.Parent=b return v
end
local function ropeCoil(tool)
    local m=Instance.new('Model') m.Name='RopeCoil'
    local grip=Instance.new('Part') grip.Name='Grip' grip.Size=Vector3.new(.1,.1,.1) grip.Transparency=1 grip.Parent=m
    physical(grip) m.PrimaryPart=grip
    local color=Color3.fromRGB(163,112,67)
    for loop=1,3 do for i=0,11 do
        local function point(t) return Vector3.new(math.cos(t)*.28,math.sin(t)*.43-.28,(loop-2)*.085) end
        local a,b=point(i*math.pi/6),point((i+1)*math.pi/6)
        local p=Instance.new('Part') p.Name='RopeLoop' p.Size=Vector3.new(.075,.075,(b-a).Magnitude+.025)
        p.CFrame=CFrame.lookAt((a+b)/2,b) p.Color=color p.Material=Enum.Material.Fabric p.Parent=m
        physical(p) weld(grip,p)
    end end
    local feed=Instance.new('Attachment') feed.Name='RopeFeed' feed.Position=Vector3.new(.26,-.28,0)
    -- A downward tangent gives the loose line between the hands a gentle sag.
    feed.Axis=Vector3.new(0,-1,0) feed.Parent=grip
    m.Parent=tool return m,feed
end
function E.give(s,onUnequip)
    local backpack=s.player:WaitForChild('Backpack',10) if not backpack or s.closing then return end
    for _,container in {backpack,s.player.Character} do if container then
        for _,t in container:GetChildren() do if t:IsA('Tool') and t:GetAttribute('MagnetEquipment') then t:Destroy() end end
    end end
    local tool=Instance.new('Tool') tool.Name='Магнит' tool.CanBeDropped=false tool.RequiresHandle=true
    tool:SetAttribute('MagnetEquipment',true) tool:SetAttribute('OwnerUserId',s.player.UserId)
    local handle=Instance.new('Part') handle.Name='Handle' handle.Size=Vector3.new(.15,.15,.15) handle.Transparency=1 handle.Parent=tool physical(handle)
    local visual=Assets.magnet() visual.Name='MagnetAndRope' visual:PivotTo(CFrame.new(0,-.65,0)) visual.Parent=tool
    for _,p in visual:GetDescendants() do if p:IsA('BasePart') then physical(p) weld(handle,p) end end
    local coil,feed=ropeCoil(tool)
    local link=Instance.new('Beam') link.Name='HeldRope' link.Attachment0=feed link.Attachment1=visual.PrimaryPart.RopeAttachment
    link.Width0=.07 link.Width1=.07 link.Color=ColorSequence.new(Color3.fromRGB(163,112,67))
    link.FaceCamera=true link.Segments=12 link.CurveSize0=.7 link.CurveSize1=0 link.Parent=coil.Grip
    tool.Grip=CFrame.new(0,-.1,0)
    s.magnetTool=tool E.update(s)
    local leftGrip=nil
    tool.Equipped:Connect(function()
        if s.magnetTool~=tool then return end
        if leftGrip then leftGrip:Destroy() leftGrip=nil end
        local char=s.player.Character
        local hand=char and (char:FindFirstChild('LeftHand') or char:FindFirstChild('Left Arm'))
        if not hand then return end
        local offset=hand.Name=='Left Arm' and CFrame.new(0,-.9,-.1) or CFrame.new(0,-.15,-.1)
        coil:PivotTo(hand.CFrame*offset)
        leftGrip=weld(hand,coil.Grip) leftGrip.Name='LeftRopeGrip'
        E.visible(s,true)
    end)
    tool.Unequipped:Connect(function()
        if leftGrip then leftGrip:Destroy() leftGrip=nil end
        if s.magnetTool==tool then onUnequip() end
    end)
    Style.item(tool,false)
    tool.Parent=backpack
end
function E.toggle(s)
    local h=s.player.Character and s.player.Character:FindFirstChildOfClass('Humanoid')
    if not h or h.Health<=0 or not s.magnetTool then return false end
    if E.equipped(s) then h:UnequipTools() else h:EquipTool(s.magnetTool) end
    return true
end
return E
