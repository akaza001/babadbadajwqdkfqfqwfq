-- Client presentation only. Rewards and fishing progress remain server-owned.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local shared=game.ReplicatedStorage.MagnetWorkshop.Shared
local C=require(shared.Config)
local Factory=require(shared.FindFactory)
local Assets=require(shared.ApprovedAssets)
local Style=require(shared.SurfaceStyle)
local Audio=require(script.Parent.AudioPresentation)
local P={}
local effects={}
local cameraShot=nil
local idlePoses={}
local function clearIdle(userId)
    local pose=idlePoses[userId] if not pose then return end
    for _,j in pose.joints do if j.motor.Parent then j.motor.Transform=j.base end end
    idlePoses[userId]=nil
end
local function ease(t) t=math.clamp(t,0,1) return t*t*(3-2*t) end
local function part(parent,name,size,color,transparency)
    local v=Instance.new("Part") v.Name=name v.Size=size v.Color=color
    v.Anchored=true v.CanCollide=false v.CanQuery=false v.CanTouch=false v.Transparency=transparency or 0 Style.part(v) v.Parent=parent return v
end
function P.framing(rootPosition,target,aspect)
    local direction=Vector3.new(target.X-rootPosition.X,0,target.Z-rootPosition.Z)
    local distance=direction.Magnitude direction=distance>.01 and direction.Unit or Vector3.new(0,0,-1)
    local right=direction:Cross(Vector3.yAxis)
    local focus=rootPosition:Lerp(target,.38)+Vector3.new(0,1.5,0)
    local scale=math.max(1,1.5/math.max(aspect,.8))
    local position=rootPosition+right*math.clamp(distance*.78,15,25)*scale-direction*math.clamp(distance*.35,6,12)+Vector3.new(0,math.clamp(distance*.3,7,11),0)
    return CFrame.lookAt(position,focus),CFrame.new(focus),65
end
local function castElapsed(effect)
    return math.max(0,workspace:GetServerTimeNow()-effect.castStartedAt)
end
local function releaseAt()
    return C.timings.castWindupSeconds+C.timings.castReleaseSeconds
end
local function flightPosition(effect,t)
    local height=math.clamp((effect.target-effect.castFrom).Magnitude*.16,4,10)
    -- Linear horizontal speed and a ballistic arc: the magnet keeps momentum at impact.
    return effect.castFrom:Lerp(effect.target,t)+Vector3.new(0,4*t*(1-t)*height,0)
end
local function chaseFrame(effect,position)
    local direction=(effect.target-effect.root.Position)*Vector3.new(1,0,1)
    direction=direction.Magnitude>.01 and direction.Unit or Vector3.new(0,0,-1)
    local right=direction:Cross(Vector3.yAxis)
    local focus=position+direction*1.5
    return CFrame.lookAt(position-direction*6+right*2.5+Vector3.new(0,3,0),focus),CFrame.new(focus)
end
local function castDelta(name,elapsed)
    local right=string.find(name,'Right')~=nil
    local torso=name=='Waist' or name=='RootJoint'
    local elbow=string.find(name,'Elbow')~=nil
    local r6=string.find(name,' ')~=nil
    local rest=torso and CFrame.Angles(-.04,0,0)
        or elbow and CFrame.Angles(-.2,0,0)
        or r6 and CFrame.Angles(0,0,right and .8 or -.8)
        or CFrame.Angles(.85,0,right and -.12 or .12)
    local wind=torso and CFrame.Angles(.06,-math.rad(55),.05)
        or elbow and CFrame.Angles(right and -1.15 or -.55,0,0)
        or r6 and CFrame.Angles(0,right and -.45 or .1,right and -.45 or -.35)
        or CFrame.Angles(right and -.6 or .35,right and -.35 or .1,right and .45 or .12)
    local thrown=torso and CFrame.Angles(-.12,.22,-.04)
        or elbow and CFrame.Angles(right and -.15 or -.65,0,0)
        or r6 and CFrame.Angles(0,0,right and 1.6 or -.65)
        or CFrame.Angles(right and 1.6 or .65,.1,right and -.12 or .12)
    if elapsed<C.timings.castWindupSeconds then
        return rest:Lerp(wind,ease(elapsed/C.timings.castWindupSeconds))
    elseif elapsed<releaseAt() then
        return wind:Lerp(thrown,ease((elapsed-C.timings.castWindupSeconds)/C.timings.castReleaseSeconds))
    end
    return thrown:Lerp(rest,ease((elapsed-releaseAt())/.6))
end
local function beginCamera(effect)
    local camera=workspace.CurrentCamera
    local previous=cameraShot and cameraShot.original or {cframe=camera.CFrame,focus=camera.Focus,kind=camera.CameraType,subject=camera.CameraSubject,fov=camera.FieldOfView,rootPosition=effect.root.Position}
    -- Fishing starts only from Idle; an orphaned Scriptable camera must return to normal play.
    if previous.kind==Enum.CameraType.Scriptable then previous.kind=Enum.CameraType.Custom end
    cameraShot={id=effect.id,effect=effect,from=camera.CFrame,fromFocus=camera.Focus,fromFov=camera.FieldOfView,original=previous,returning=false}
    camera.CameraType=Enum.CameraType.Scriptable
end
local function returnCamera(id)
    if not cameraShot or cameraShot.id~=id or cameraShot.returning then return end
    local camera=workspace.CurrentCamera local original=cameraShot.original
    cameraShot={id=id,started=os.clock(),from=camera.CFrame,fromFocus=camera.Focus,fromFov=camera.FieldOfView,to=original.cframe,focus=original.focus,fov=original.fov,duration=.7,original=original,returning=true}
end
local function restoreCamera(shot)
    local camera=workspace.CurrentCamera local humanoid=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    camera.FieldOfView=shot.original.fov camera.CameraType=shot.original.kind
    local subject=shot.original.subject
    if subject and subject:IsDescendantOf(workspace) and (not subject:IsA("Humanoid") or subject==humanoid) then camera.CameraSubject=subject
    elseif humanoid then camera.CameraSubject=humanoid end
end
-- A new presentation takes camera ownership before the old return timer fires.
function P.releaseCamera()
    if cameraShot then restoreCamera(cameraShot) cameraShot=nil end
end
function P.reset()
    for userId in idlePoses do clearIdle(userId) end
    if cameraShot then restoreCamera(cameraShot) cameraShot=nil else workspace.CurrentCamera.CameraType=Enum.CameraType.Custom end
    for id,effect in effects do
        Audio.stopFishing(id)
        for _,joint in effect.joints do if joint.motor.Parent and joint.base then joint.motor.Transform=joint.base end end
        effect.model:Destroy() effects[id]=nil
    end
end
function P.start(event)
    if effects[event.id] then return end
    local owner=Players:GetPlayerByUserId(event.userId) local char=owner and owner.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local hand=char and (char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm"))
    if not root or not hand then return end
    clearIdle(event.userId)
    local left=char:FindFirstChild('LeftHand') or char:FindFirstChild('Left Arm') or hand
    local model=Instance.new("Model") model.Name="MagnetFishingEffect" model:SetAttribute("AttemptId",event.id) model.Parent=workspace
    local magnetModel=Assets.magnet() magnetModel.Parent=model
    local magnet=magnetModel.PrimaryPart
    local origin=part(model,"RopeOrigin",Vector3.new(.1,.1,.1),C.palette.paper,1)
    local wake=part(model,'ReelingWake',Vector3.new(1,.035,1),C.palette.paper,1) wake.Shape=Enum.PartType.Ball
    local start=Instance.new("Attachment") start.Parent=origin
    local tool=char:FindFirstChildOfClass('Tool')
    local feed=tool and tool:FindFirstChild('RopeFeed',true)
    local finish=magnet.RopeAttachment
    local rope=Instance.new("Beam") rope.Attachment0=feed or start rope.Attachment1=finish rope.Width0=.07 rope.Width1=.07
    rope.FaceCamera=true rope.Color=ColorSequence.new(Color3.fromRGB(163,112,67)) rope.Parent=magnet
    local joints={}
    for _,v in char:GetDescendants() do
        if (v:IsA("Motor6D") or v:IsA("AnimationConstraint")) and (v.Name=="RightShoulder" or v.Name=="LeftShoulder" or v.Name=="Right Shoulder" or v.Name=="Left Shoulder" or v.Name=='RightElbow' or v.Name=='LeftElbow' or v.Name=="Waist" or (v.Name=="RootJoint" and not char:FindFirstChild("Waist",true))) then
            table.insert(joints,{motor=v,base=v.Transform,applied=v.Transform})
        end
    end
    local effect={id=event.id,userId=event.userId,char=char,root=root,hand=hand,leftHand=left,model=model,magnet=magnet,magnetModel=magnetModel,origin=origin,rope=rope,wake=wake,
        joints=joints,target=event.target,retrieveTo=event.retrieveTo or event.target:Lerp(root.Position,.8),castDistance=event.castDistance or (event.target-root.Position).Magnitude,
        pullDuration=event.pullDuration,started=os.clock(),castStartedAt=event.castStartedAt or workspace:GetServerTimeNow(),stage="Casting",progress=0,desiredProgress=0,weight=0,castFrom=hand.Position}
    model:SetAttribute('CastDistance',effect.castDistance) model:SetAttribute('PullDuration',effect.pullDuration) model:SetAttribute('Stage','Casting')
    local held=tool and tool:FindFirstChild('MagnetAndRope')
    effect.handOffset=held and hand.CFrame:ToObjectSpace(held:GetPivot()) or CFrame.new(0,-.65,0)
    local heldFrame=hand.CFrame*effect.handOffset
    effect.castFrom=heldFrame.Position effect.releaseRotation=heldFrame.Rotation
    magnetModel:PivotTo(heldFrame) effects[event.id]=effect
    if event.userId==player.UserId then beginCamera(effect) end
end
function P.update(event)
    local effect=effects[event.id] if not effect then return end
    if event.stage=='Pulling' and effect.stage~='Pulling' then effect.pullStarted=os.clock() end
    effect.stage=event.stage or effect.stage effect.desiredProgress=event.progress or effect.desiredProgress
    effect.tension=event.tension or effect.tension effect.greenMin=event.greenMin or effect.greenMin effect.greenMax=event.greenMax or effect.greenMax
    effect.model:SetAttribute('Stage',effect.stage)
end
function P.caught(event)
    local effect=effects[event.id] if not effect or effect.ending then return end
    effect.stage="Revealing" effect.revealStarted=os.clock() effect.revealFrom=effect.magnet.Position
    effect.find=Factory.create(event.itemId,true) effect.find.Parent=effect.model effect.duration=event.duration or C.timings.revealSeconds
    effect.find:PivotTo(CFrame.new(effect.revealFrom))
end
function P.finish(id)
    Audio.stopFishing(id)
    local effect=effects[id]
    if effect and not effect.ending then effect.ending=os.clock() effect.endFrom=effect.magnet.Position effect.endRotation=effect.magnet.CFrame.Rotation end
    returnCamera(id)
    -- A background Studio viewport can suspend RenderStepped; old effects still
    -- release their camera, joints and model after the return duration.
    task.delay(.75,function()
        if cameraShot and cameraShot.id==id and cameraShot.returning then restoreCamera(cameraShot) cameraShot=nil end
        if effect and effects[id]==effect and effect.ending then
            for _,joint in effect.joints do if joint.motor.Parent then joint.motor.Transform=joint.base end end
            effect.model:Destroy() effects[id]=nil
        end
    end)
end
RunService.PreSimulation:Connect(function(dt)
    local active={}
    for _,effect in effects do active[effect.userId]=true end
    for _,owner in Players:GetPlayers() do
        local char=owner.Character local tool=char and char:FindFirstChildOfClass('Tool')
        local h=char and char:FindFirstChildOfClass('Humanoid')
        if tool and tool:GetAttribute('MagnetEquipment') and h and h.Health>0 and not active[owner.UserId] then
            local pose=idlePoses[owner.UserId]
            if pose and pose.char~=char then clearIdle(owner.UserId) pose=nil end
            if not pose then
                pose={char=char,joints={},weight=0} idlePoses[owner.UserId]=pose
                for _,v in char:GetDescendants() do
                    if (v:IsA('Motor6D') or v:IsA('AnimationConstraint')) and (v.Name=='LeftShoulder' or v.Name=='Left Shoulder' or v.Name=='LeftElbow') then
                        table.insert(pose.joints,{motor=v,base=v.Transform,applied=v.Transform})
                    end
                end
            end
            pose.weight+=(1-pose.weight)*(1-math.exp(-dt*10))
            for _,j in pose.joints do if j.motor.Parent then
                if j.motor.Transform~=j.applied then j.base=j.motor.Transform end
                local delta=j.motor.Name=='Left Shoulder' and CFrame.Angles(0,0,-.35) or CFrame.Angles(j.motor.Name=='LeftElbow' and -.55 or .35,0,.05)
                j.applied=j.base*CFrame.identity:Lerp(delta,pose.weight) j.motor.Transform=j.applied
            end end
        else clearIdle(owner.UserId) end
    end
    for userId,pose in idlePoses do if not pose.char:IsDescendantOf(workspace) then clearIdle(userId) end end
    for _,effect in effects do
        local desired=effect.ending and 0 or 1
        effect.weight+=(desired-effect.weight)*(1-math.exp(-dt*10))
        local pull=effect.stage=='Pulling' local reveal=effect.stage=='Revealing'
        local elapsed=castElapsed(effect)
        local cycle=(os.clock()-(effect.pullStarted or effect.started))*math.pi*2/1.25
        local wave=pull and math.sin(cycle) or 0
        for _,joint in effect.joints do
            local motor=joint.motor
            if motor.Parent then
                local current=motor.Transform
                if current~=joint.applied then joint.base=current end
                local delta
                local right=string.find(motor.Name,'Right')~=nil
                local reach=.5+.5*(right and wave or -wave)
                if not pull and not reveal then delta=castDelta(motor.Name,elapsed)
                elseif motor.Name=='Waist' or motor.Name=='RootJoint' then delta=CFrame.Angles(reveal and -.18 or pull and (-.12+wave*.045) or -.04,0,0)
                elseif string.find(motor.Name,'Elbow') then
                    delta=CFrame.Angles(reveal and (right and -.95 or -.55) or pull and -(.25+.7*(1-reach)) or -.2,0,0)
                elseif string.find(motor.Name,' ') then
                    delta=CFrame.Angles(0,0,(right and 1 or -1)*(reveal and (right and 1.65 or .35) or pull and (.65+.65*reach) or .8))
                else
                    delta=CFrame.Angles(reveal and (right and 1.65 or .35) or pull and (.65+.65*reach) or .85,0,right and -.12 or .12)
                end
                if motor.Name=='RootJoint' and motor:IsA('Motor6D') then
                    delta=motor.C1.Rotation:Inverse()*delta*motor.C1.Rotation
                end
                joint.applied=joint.base*CFrame.identity:Lerp(delta,effect.weight) motor.Transform=joint.applied
            end
        end
    end
end)
-- World motion keeps its timeline even if Studio suspends viewport rendering.
RunService.Heartbeat:Connect(function(dt)
    local now=os.clock()
    for id,effect in effects do
        if not effect.char:IsDescendantOf(workspace) or not effect.hand.Parent or now-effect.started>45 then P.finish(id) end
        if effect.hand.Parent then
            local hand=effect.hand.Position
            effect.origin.Position=effect.leftHand.Parent and effect.leftHand.Position or hand
            effect.progress+=(effect.desiredProgress-effect.progress)*(1-math.exp(-dt*12))
            local position local rotation=CFrame.identity
            if effect.ending then
                local t=ease((now-effect.ending)/.45) position=effect.endFrom:Lerp(hand,t) rotation=effect.endRotation:Lerp(CFrame.identity,t)
            elseif effect.revealStarted then
                local t=ease((now-effect.revealStarted)/effect.duration)
                position=effect.revealFrom:Lerp(hand+Vector3.new(0,.4,0),t)+Vector3.new(0,math.sin(t*math.pi)*3.5,0)
                -- The find hangs below the magnetic face; it never intersects the disk.
                if not effect.findHeight then local _,size=effect.find:GetBoundingBox() effect.findHeight=size.Y end
                effect.find:PivotTo(CFrame.new(position-Vector3.new(0,effect.findHeight+.30,0))*CFrame.Angles(0,t*math.pi*.25,0))
            elseif effect.stage=="Casting" then
                local elapsed=castElapsed(effect)
                if elapsed<releaseAt() then
                    local held=effect.hand.CFrame*effect.handOffset
                    position=held.Position rotation=held.Rotation effect.castFrom=position effect.releaseRotation=rotation
                else
                    local t=math.clamp((elapsed-releaseAt())/(C.timings.castSeconds-releaseAt()),0,1)
                    position=flightPosition(effect,t)
                    rotation=effect.releaseRotation:Lerp(CFrame.identity,ease(t))
                end
            else
                local surface=effect.target:Lerp(effect.retrieveTo,effect.progress)
                position=surface+Vector3.new(0,math.sin(now*3)*.045,0)
            end
            effect.magnetModel:PivotTo(CFrame.new(position)*rotation)
            effect.model:SetAttribute('ReelingProgress',effect.progress)
            local elapsed=castElapsed(effect)
            local phase=effect.ending and 'Ending' or effect.revealStarted and 'Revealing' or effect.stage=='Pulling' and 'Pulling'
                or elapsed<C.timings.castWindupSeconds and 'Windup' or elapsed<releaseAt() and 'Throw'
                or elapsed<C.timings.castSeconds and 'Flight' or 'CameraReturn'
            effect.model:SetAttribute('CastPhase',phase)
            if not effect.ending then Audio.fishing(effect,phase) end
            local held=phase=='Windup' or phase=='Throw'
            local span=(effect.origin.Position-effect.magnet.Position).Magnitude
            local sag=held and .4 or phase=='Flight' and math.clamp(span*.12,.3,2.8) or phase=='Revealing' and .6 or .08
            effect.rope.CurveSize0=sag effect.rope.CurveSize1=-sag*.5
            effect.rope.Segments=16
            if effect.stage=='Pulling' and not effect.ending then
                local pulse=(now-(effect.pullStarted or effect.started))%1.25/1.25
                local size=.8+pulse*.9 effect.wake.Size=Vector3.new(size,.035,size)
                effect.wake.Position=Vector3.new(position.X,.29,position.Z) effect.wake.Transparency=.72+pulse*.25
            elseif not effect.ending and elapsed>=C.timings.castSeconds and elapsed<C.timings.castSeconds+.8 then
                local t=(elapsed-C.timings.castSeconds)/.8 local size=1+t*3
                effect.wake.Size=Vector3.new(size,.035,size) effect.wake.Position=Vector3.new(effect.target.X,.29,effect.target.Z)
                effect.wake.Transparency=.45+.55*t
            else effect.wake.Transparency=1 end
        end
        if effect.ending and now-effect.ending>.45 then
            for _,joint in effect.joints do if joint.motor.Parent then joint.motor.Transform=joint.base end end
            effect.model:Destroy() effects[id]=nil
        elseif effect.ending then
            local opacity=math.clamp((now-effect.ending)/.45,0,1)
            for _,v in effect.model:GetDescendants() do if v:IsA("BasePart") and v~=effect.origin and v~=effect.magnet and v~=effect.wake then v.Transparency=opacity end end
            effect.rope.Transparency=NumberSequence.new(opacity)
        end
    end
end)
local function updateCamera()
    local shot=cameraShot if not shot then return end
    local camera=workspace.CurrentCamera
    local target,focus,fov
    if shot.returning then
        local t=ease((os.clock()-shot.started)/shot.duration)
        target,focus=shot.to,shot.focus
        local root=player.Character and player.Character:FindFirstChild('HumanoidRootPart')
        if root then local offset=root.Position-shot.original.rootPosition target+=offset focus+=offset end
        camera.CFrame=shot.from:Lerp(target,t) camera.Focus=shot.fromFocus:Lerp(focus,t)
        camera.FieldOfView=shot.fromFov+(shot.fov-shot.fromFov)*t
        if t>=1 then restoreCamera(shot) cameraShot=nil return end
    else
        local effect=shot.effect if not effect or not effect.root:IsDescendantOf(workspace) then return end
        local elapsed=castElapsed(effect)
        local viewport=camera.ViewportSize
        local side,sideFocus,sideFov=P.framing(effect.root.Position,effect.retrieveTo,viewport.X/math.max(1,viewport.Y))
        local phase
        if elapsed<releaseAt() then
            local t=ease(elapsed/C.timings.castWindupSeconds)
            target=shot.from:Lerp(side,t) focus=shot.fromFocus:Lerp(sideFocus,t)
            fov=shot.fromFov+(sideFov-shot.fromFov)*t phase='Windup'
        elseif elapsed<C.timings.castSeconds then
            local t=(elapsed-releaseAt())/(C.timings.castSeconds-releaseAt())
            local chase,chaseFocus=chaseFrame(effect,flightPosition(effect,t))
            local blend=ease(t/.3)
            target=side:Lerp(chase,blend) focus=sideFocus:Lerp(chaseFocus,blend)
            fov=sideFov+(62-sideFov)*blend phase='FollowMagnet'
        else
            local landed,landedFocus=chaseFrame(effect,effect.target)
            local t=ease((elapsed-C.timings.castSeconds)/C.timings.searchSeconds)
            target=landed:Lerp(side,t) focus=landedFocus:Lerp(sideFocus,t)
            fov=62+(sideFov-62)*t phase=t<1 and 'ReturnToPlayer' or 'Player'
        end
        camera.CFrame=target camera.Focus=focus camera.FieldOfView=fov
        effect.model:SetAttribute('CameraPhase',phase)
    end
    camera.CameraType=Enum.CameraType.Scriptable
end
-- Same clock in both callbacks; background Studio can suspend RenderStepped.
RunService.Heartbeat:Connect(updateCamera)
RunService:BindToRenderStep('MagnetFishingPresentation',Enum.RenderPriority.Camera.Value+1,updateCamera)
return P
