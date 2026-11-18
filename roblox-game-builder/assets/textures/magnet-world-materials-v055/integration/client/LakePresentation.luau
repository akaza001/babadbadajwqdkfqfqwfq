-- Cosmetic water movement stays local; neither the lake bounds nor its physics move.
local RunService=game:GetService('RunService')
local L={}
local connection=nil
local bases=setmetatable({},{__mode="k"})
local function collect(folder)
    local waves={} if not folder then return waves end
    for _,group in folder:GetChildren() do if group:IsA('Model') then
        local parts={}
        for _,p in group:GetChildren() do if p:IsA('BasePart') then bases[p]=bases[p] or p.CFrame table.insert(parts,{part=p,base=bases[p]}) end end
        table.insert(waves,{origin=group:GetPivot().Position,parts=parts,phase=group:GetAttribute('Phase') or 0,speed=group:GetAttribute('Speed') or .5})
    end end
    return waves
end
function L.start()
    if connection then return end
    local world=workspace:WaitForChild('MagnetWorld',15) if not world then return end
    local folder=nil local waves={} local elapsed=0 local accumulator=0
    local dirty=true local added=nil local removing=nil
    connection=RunService.Heartbeat:Connect(function(dt)
        if not world.Parent then
            connection:Disconnect() connection=nil
            if added then added:Disconnect() end if removing then removing:Disconnect() end
            return
        end
        elapsed+=dt accumulator+=dt if accumulator<.05 then return end accumulator=0
        -- Bootstrap may finish replacing decoration after LocalScripts have started.
        local current=world:FindFirstChild('LakeRipples')
        if current~=folder then
            if added then added:Disconnect() end if removing then removing:Disconnect() end
            folder=current dirty=true
            if folder then
                added=folder.DescendantAdded:Connect(function() dirty=true end)
                removing=folder.DescendantRemoving:Connect(function() dirty=true end)
            end
        end
        if dirty then
            waves=collect(folder) dirty=false
            if folder then
                local strokes=0 for _,wave in waves do strokes+=#wave.parts end
                folder:SetAttribute('AnimatedStrokes',strokes)
            end
        end
        if not folder then return end
        local camera=workspace.CurrentCamera if not camera then return end
        folder:SetAttribute('AnimationTime',elapsed)
        for _,wave in waves do
            if (camera.CFrame.Position-wave.origin).Magnitude<185 then
                local phase=elapsed*wave.speed+wave.phase
                local offset=Vector3.new(math.sin(phase*.73)*.28,0,math.sin(phase)*.38)
                local opacity=.82+.08*math.sin(phase*.85)
                for _,entry in wave.parts do
                    entry.part.CFrame=entry.base+offset entry.part.LocalTransparencyModifier=0 entry.part.Transparency=opacity
                end
            else
                for _,entry in wave.parts do entry.part.LocalTransparencyModifier=1 end
            end
        end
    end)
end
return L
