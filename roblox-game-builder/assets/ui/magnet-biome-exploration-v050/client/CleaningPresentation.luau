local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local R=game.ReplicatedStorage.MagnetWorkshop
local C=require(R.Shared.Config)
local Geometry=require(R.Shared.CleaningGeometry)
local Assets=require(R.Shared.ApprovedAssets)
local Style=require(R.Shared.SurfaceStyle)
local Audio=require(script.Parent.AudioPresentation)
local P={}
local current=nil
local function restoreScene(a)
    for _,v in a.hidden or {} do
        if v.object.Parent then v.object[v.property]=v.value end
    end
    a.hidden={}
end
local function hideScene(view)
    local hidden={}
    local world=workspace:FindFirstChild("MagnetWorld")
    local plots=world and world:FindFirstChild("Plots")
    local plot=plots and view.plotName and plots:FindFirstChild(view.plotName)
    if plot then
        for _,v in plot:GetDescendants() do
            local property
            if v:IsA("BillboardGui") or v:IsA("ProximityPrompt") then property="Enabled"
            elseif v:IsA("BasePart") and v:FindFirstAncestor("RoofAssembly") then property="LocalTransparencyModifier" end
            if property then
                table.insert(hidden,{object=v,property=property,value=v[property]})
                v[property]=property=="LocalTransparencyModifier" and 1 or false
            end
        end
    end
    return hidden
end
local function ease(t) t=math.clamp(t,0,1) return t*t*(3-2*t) end
local function part(parent,name,size,color)
    local p=Instance.new("Part") p.Name=name p.Size=size p.Color=color p.Anchored=true p.CanCollide=false p.CanTouch=false p.CanQuery=false p.CastShadow=false p.Material=Enum.Material.SmoothPlastic p.Parent=parent Style.part(p) return p
end
local function originalCamera()
    local c=workspace.CurrentCamera local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    return {cf=c.CFrame,focus=c.Focus,fov=c.FieldOfView,kind=c.CameraType==Enum.CameraType.Scriptable and Enum.CameraType.Custom or c.CameraType,subject=c.CameraSubject,rootPosition=root and root.Position}
end
local function restore(saved)
    local camera=workspace.CurrentCamera camera.FieldOfView=saved.fov camera.CameraType=saved.kind
    local humanoid=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    local subject=saved.subject
    if subject and subject:IsDescendantOf(workspace) and (not subject:IsA("Humanoid") or subject==humanoid) then camera.CameraSubject=subject
    elseif humanoid then camera.CameraSubject=humanoid end
end
local function send(held,x,z)
    local a=current if not a then return end
    a.inputSeq+=1
    R.Remotes.CleanInput:FireServer({cleanId=a.id,inputSeq=a.inputSeq,side=a.view.side,held=held,x=x or 0,z=z or 0})
end
function P.stop(immediate)
    local a=current if not a then return end
    a.held=false send(false) Audio.brush(nil,false)
    if immediate then restore(a.saved) restoreScene(a) a.model:Destroy() current=nil return end
    if a.stopping then return end
    a.stopAngle=a.view.side==2 and math.pi or 0
    a.stopping=os.clock() a.returnFrom=workspace.CurrentCamera.CFrame a.returnFocus=workspace.CurrentCamera.Focus a.returnFov=workspace.CurrentCamera.FieldOfView
    -- A background Studio viewport can suspend RenderStepped. The activity must
    -- still release its camera and model; a later activity owns a different table.
    task.delay(.85,function()
        if current==a and a.stopping then restore(a.saved) restoreScene(a) a.model:Destroy() current=nil end
    end)
end
function P.update(view)
    local a=current if not a or a.id~=view.id or a.stopping then return end
    a.view=view
    for _,cell in a.rust do
        local bytes=cell.side==1 and view.coverage1 or view.coverage2
        cell.target=(bytes and string.byte(bytes,cell.id) or 0)/127
    end
end
-- Reserve room for the native header/footer without shrinking touch controls.
function P.framing(view,desc,size,insetTop,insetBottom)
    if size.X<=1 or size.Y<=1 then size=Vector2.new(768,437) end
    local short=size.Y-insetTop-insetBottom<300
    local topSpace,bottomSpace=short and 72 or 112,short and 48 or 60
    local tangent=math.tan(math.rad(25))
    local top,bottom=insetTop+topSpace,size.Y-insetBottom-bottomSpace
    local margin=(bottom-top)*.07 top+=margin bottom-=margin
    local slope=(top+bottom-size.Y)/size.Y*tangent
    local upper=(1-2*top/size.Y)*tangent local lower=(1-2*bottom/size.Y)*tangent
    local flipRadius=math.sqrt((desc.height/2)^2+(desc.depth/2)^2)
    local highest=desc.height/2+desc.depth/2+.2+flipRadius
    local distance=4+highest
    -- Fit the entire flip envelope to the actual free rectangle, including depth.
    for _,height in {0,highest} do for _,up in {-flipRadius,flipRadius} do
        distance=math.max(distance,height+desc.width/2/(tangent*(size.X-32)/size.Y*.86),
            (up+upper*height)/(slope+upper),(up+lower*height)/(slope+lower))
    end end
    local focus=view.slotCFrame.Position+view.slotCFrame.LookVector*slope*distance
    return CFrame.lookAt(focus+Vector3.new(0,distance,0),focus,view.slotCFrame.LookVector),focus,50
end
function P.start(view)
    Audio.brush(nil,false)
    if current and current.id==view.id and not current.stopping then P.update(view) return end
    local saved=current and current.saved or originalCamera()
    if current then restoreScene(current) current.model:Destroy() current=nil end
    local hidden=hideScene(view)
    local desc=Geometry.describe(view.itemId)
    local model=Instance.new("Model") model.Name="MagnetCleaningItem" model:SetAttribute("SurfaceClass","Item") model:SetAttribute("CleaningId",view.id)
    local base=Instance.new("Folder") base.Name="Surface" base.Parent=model
    local baseParts={}
    for _,data in desc.parts do
        local p=part(base,data.name,data.size,data.color) p.Shape=data.shape p.Material=data.material or Enum.Material.Metal p.MaterialVariant="" p:SetAttribute("ItemTransparency",data.transparency or 0) p.CanQuery=true p.CastShadow=true p.CFrame=view.slotCFrame*data.cf p.Transparency=1 table.insert(baseParts,p)
    end
    local rust={}
    for side=1,2 do
        for _,cell in desc.points[side] do
            local position=Vector3.new(cell.x,cell.y+.012,cell.z)
            local cf=CFrame.new(position)
            if side==2 then cf=desc.flip:Inverse()*cf end
            local p=part(model,"RustSurface",Vector3.new(desc.width/desc.grid*1.035,.014,desc.depth/desc.grid*1.035),C.palette.rust)
            p.MaterialVariant="" p.Material=Enum.Material.SmoothPlastic
            p.Color=({Color3.fromRGB(163,83,45),Color3.fromRGB(187,104,58),Color3.fromRGB(141,72,40),Color3.fromRGB(177,92,48)})[(cell.id*7)%4+1]
            p.CFrame=view.slotCFrame*cf p.Transparency=1
            table.insert(rust,{part=p,side=side,id=cell.id,amount=0,target=0})
        end
    end
    model.WorldPivot=view.slotCFrame model.Parent=workspace
    local brush=Assets.brush() brush:ScaleTo(desc.radius*2/1.05) brush.Parent=model
    local brushParts={} for _,p in brush:GetDescendants() do if p:IsA("BasePart") then p.CanQuery=false table.insert(brushParts,p) end end
    local camera=workspace.CurrentCamera
    local top,bottom=game:GetService('GuiService'):GetGuiInset()
    local target,targetFocus,targetFov=P.framing(view,desc,camera.ViewportSize,top.Y,bottom.Y)
    local params=RaycastParams.new() params.FilterType=Enum.RaycastFilterType.Include params.FilterDescendantsInstances={base}
    current={id=view.id,view=view,desc=desc,model=model,base=base,baseParts=baseParts,rust=rust,brush=brush,brushParts=brushParts,
        saved=saved,hidden=hidden,started=os.clock(),from=camera.CFrame,fromFocus=camera.Focus,fromFov=camera.FieldOfView,target=target,targetFocus=targetFocus,targetFov=targetFov,viewport=camera.ViewportSize,
        rayParams=params,held=false,inputSeq=0,clock=0,brushPosition=nil}
    camera.CameraType=Enum.CameraType.Scriptable P.update(view)
end
local function hitAt(position)
    local a=current
    if not a or a.stopping or workspace:GetServerTimeNow()<a.view.readyAt then return nil end
    local ray=workspace.CurrentCamera:ViewportPointToRay(position.X,position.Y)
    local result=workspace:Raycast(ray.Origin,ray.Direction*100,a.rayParams)
    if not result then return nil end
    local p=a.view.slotCFrame:PointToObjectSpace(result.Position)
    if not Geometry.surface(a.desc,a.view.side,p.X,p.Z) then return nil end
    return p
end
UIS.InputBegan:Connect(function(input,processed)
    if processed or not current or current.stopping then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        local position=input.UserInputType==Enum.UserInputType.Touch and input.Position or UIS:GetMouseLocation()
        local hit=hitAt(position)
        if hit then current.held=true current.pointer=input current.touchPosition=position send(true,hit.X,hit.Z) end
    end
end)
UIS.InputChanged:Connect(function(input)
    if current and current.pointer==input and input.UserInputType==Enum.UserInputType.Touch then current.touchPosition=input.Position end
end)
UIS.InputEnded:Connect(function(input)
    if current and (current.pointer==input or input.UserInputType==Enum.UserInputType.MouseButton1 and current.pointer and current.pointer.UserInputType==Enum.UserInputType.MouseButton1) then current.held=false current.pointer=nil send(false) Audio.brush(nil,false) end
end)
UIS.WindowFocusReleased:Connect(function() if current then current.held=false current.pointer=nil send(false) Audio.brush(nil,false) end end)
RunService:BindToRenderStep("MagnetCleaningPresentation",Enum.RenderPriority.Camera.Value+2,function(dt)
    local a=current if not a then return end
    local now=os.clock() local camera=workspace.CurrentCamera
    local opacity
    if not a.stopping and a.viewport~=camera.ViewportSize then
        local top,bottom=game:GetService('GuiService'):GetGuiInset()
        a.target,a.targetFocus,a.targetFov=P.framing(a.view,a.desc,camera.ViewportSize,top.Y,bottom.Y) a.viewport=camera.ViewportSize
    end
    if a.stopping then
        local t=ease((now-a.stopping)/.85) local cf,focus=a.saved.cf,a.saved.focus
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root and a.saved.rootPosition then local offset=root.Position-a.saved.rootPosition cf+=offset focus+=offset end
        camera.CameraType=Enum.CameraType.Scriptable camera.CFrame=a.returnFrom:Lerp(cf,t) camera.Focus=a.returnFocus:Lerp(focus,t) camera.FieldOfView=a.returnFov+(a.saved.fov-a.returnFov)*t
        opacity=1-t
        if t>=1 then restore(a.saved) restoreScene(a) a.model:Destroy() current=nil return end
    else
        local t=ease((now-a.started)/C.cleaning.cameraSeconds)
        camera.CameraType=Enum.CameraType.Scriptable camera.CFrame=a.from:Lerp(a.target,t) camera.Focus=a.fromFocus:Lerp(CFrame.new(a.targetFocus),t) camera.FieldOfView=a.fromFov+(a.targetFov-a.fromFov)*t
        opacity=ease((now-a.started)/.55)
    end
    local angle=0
    if a.stopping then angle=a.stopAngle*(1-ease((now-a.stopping)/.8))
    elseif a.view.side==2 then angle=math.pi*ease((workspace:GetServerTimeNow()-(a.view.flipAt or 0))/C.cleaning.flipSeconds) end
    a.model:SetAttribute('PresentationAngle',angle)
    local lift=math.sin(angle)*(a.desc.depth/2+.2)
    local cf=a.view.slotCFrame*CFrame.new(0,a.desc.height/2+lift+(1-opacity)*.3,0)*CFrame.Angles(angle,0,0)*CFrame.new(0,-a.desc.height/2,0)
    a.model:PivotTo(cf)
    for _,p in a.baseParts do p.Transparency=1-opacity*(1-(p:GetAttribute("ItemTransparency") or 0)) end
    for _,cell in a.rust do
        cell.amount+=(cell.target-cell.amount)*(1-math.exp(-dt*18))
        local transparency=1-(1-cell.amount)*opacity
        if math.abs(cell.part.Transparency-transparency)>.003 then cell.part.Transparency=transparency end
    end
    local pointer=a.pointer and a.pointer.UserInputType==Enum.UserInputType.Touch and a.touchPosition or UIS:GetMouseLocation()
    local hit=not a.stopping and hitAt(pointer)
    if hit then
        local target=a.view.slotCFrame:PointToWorldSpace(hit+Vector3.new(0,.13,0))
        a.brushPosition=a.brushPosition and a.brushPosition:Lerp(target,1-math.exp(-dt*24)) or target
        local localMotion=a.lastBrushHit and (hit-a.lastBrushHit) or Vector3.zero
        a.lastBrushHit=hit
        local moving=localMotion.Magnitude>.001
        local targetYaw=moving and math.atan2(-localMotion.Z,localMotion.X) or (a.brushYaw or 0)
        local yaw=a.brushYaw or targetYaw
        local difference=math.atan2(math.sin(targetYaw-yaw),math.cos(targetYaw-yaw))
        a.brushYaw=yaw+difference*(1-math.exp(-dt*16))
        local pressure=a.held and -.07 or 0
        local frame=CFrame.new(a.brushPosition+Vector3.new(0,pressure,0))*a.view.slotCFrame.Rotation*CFrame.Angles(0,a.brushYaw,0)
        a.model:SetAttribute('BrushContact',a.held)
        a.brush:PivotTo(frame) for _,p in a.brushParts do p.Transparency=.1 end
    else for _,p in a.brushParts do p.Transparency=1 end end
    local rusty=false
    if hit and a.held then
        local bytes=a.view.side==1 and a.view.coverage1 or a.view.coverage2
        for _,cell in a.desc.points[a.view.side] do
            if (cell.x-hit.X)^2+(cell.z-hit.Z)^2<=a.desc.radius^2 and (not bytes or (string.byte(bytes,cell.id) or 0)<127) then rusty=true break end
        end
    end
    Audio.brush(a.id,not a.stopping and a.held and hit~=nil and rusty)
    a.clock+=dt
    if a.clock>=.1 and not a.stopping then a.clock=0 send(a.held and hit~=nil,hit and hit.X,hit and hit.Z) end
end)
return P
