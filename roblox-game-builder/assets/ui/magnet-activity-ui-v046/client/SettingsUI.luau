-- Local preview, debounced atomic persistence through Main's existing protocol.
local RunService=game:GetService('RunService')
local Catalog=require(game.ReplicatedStorage.MagnetWorkshop.Shared.AudioCatalog)
local text=require(game.ReplicatedStorage.MagnetWorkshop.Shared.Strings)
local Audio=require(script.Parent.AudioPresentation)
local S={}
local T=require(script.Parent.WindowTheme)
local UIS=game:GetService('UserInputService')
local drag=nil
local confirmed=table.clone(Catalog.defaults) local draft=table.clone(confirmed)
local dirty=false local version=0 local due=0 local pending=nil local failed=false
local callbacks=nil local view=nil
local function refresh()
    if not view or not view.root.Parent then return end
    for group,controls in view.groups do
        controls.toggle.Text=text(draft[group] and 'soundOn' or 'soundOff')
        controls.toggle.BackgroundColor3=draft[group] and T.teal or T.muted
        controls.value.Text=string.format('%d%%',math.floor(draft[group..'Volume']*100+.5))
        controls.minus.Interactable=draft[group..'Volume']>0 controls.plus.Interactable=draft[group..'Volume']<1
        if controls.fill then controls.fill.Size=UDim2.fromScale(draft[group..'Volume'],1) controls.thumb.Position=UDim2.fromScale(draft[group..'Volume'],.5) end
    end
    view.status.Text=text(failed and 'settingsRetry' or pending and 'settingsSaving' or dirty and 'settingsWaiting' or 'settingsSaved')
end
local function change(key,value)
    draft[key]=value version+=1 dirty=true failed=false due=os.clock()+.75
    Audio.apply(draft) refresh()
end
function S.init(value) callbacks=value end
function S.open() if callbacks and callbacks.open then callbacks.open() end end
function S.set(key,value)
    local default=Catalog.defaults[key]
    if default==nil or type(value)~=type(default) then return end
    if type(value)=='number' and (value~=value or value<0 or value>1) then return end
    change(key,value)
end
function S.profile(value)
    for k,default in Catalog.defaults do local v=value and value[k] confirmed[k]=v==nil and default or v end
    if not dirty and not pending then draft=table.clone(confirmed) Audio.apply(draft) end
    refresh()
end
function S.result(result)
    if not pending or result.actionSeq~=pending.seq or result.status=='Pending' then return end
    if result.status=='Ok' then
        confirmed=pending.value
        if pending.version==version then dirty=false draft=table.clone(confirmed) end
        failed=false
    else dirty=true failed=true due=os.clock()+2 end
    pending=nil refresh()
end
local function dragAt(x)
    if not drag or not drag.track.Parent then drag=nil return end
    S.set(drag.group..'Volume',math.clamp((x-drag.track.AbsolutePosition.X)/math.max(1,drag.track.AbsoluteSize.X),0,1))
end
UIS.InputChanged:Connect(function(i)
    if drag and (i==drag.input or drag.input.UserInputType==Enum.UserInputType.MouseButton1 and i.UserInputType==Enum.UserInputType.MouseMovement) then dragAt(i.Position.X) end
end)
UIS.InputEnded:Connect(function(i) if drag and (i==drag.input or i.UserInputType==Enum.UserInputType.MouseButton1) then drag=nil end end)
function S.render(parent)
    view={root=parent,groups={}}
    T.list(parent,10)
    parent.Destroying:Connect(function() drag=nil end)
    for index,group in {'sfx','ambience','music'} do
        local row=T.frame(parent,group..'Setting',UDim2.new(1,-6,0,102)) row.LayoutOrder=index
        T.label(row,'Title',text('sound_'..group),UDim2.new(1,-166,0,40),UDim2.fromOffset(12,2),17,true)
        local value=T.label(row,'Value','',UDim2.fromOffset(64,40),UDim2.new(1,-154,0,2),17,true) value.TextXAlignment=Enum.TextXAlignment.Center
        local toggle=T.button(row,group..'Toggle','',UDim2.fromOffset(74,44),UDim2.new(1,-82,0,2),function() S.set(group,not draft[group]) end)
        local minus=T.button(row,group..'Minus','−',UDim2.fromOffset(44,44),UDim2.fromOffset(10,50),function() S.set(group..'Volume',math.max(0,math.floor((draft[group..'Volume']-.1)*100+.5)/100)) end)
        local plus=T.button(row,group..'Plus','+',UDim2.fromOffset(44,44),UDim2.new(1,-54,0,50),function() S.set(group..'Volume',math.min(1,math.floor((draft[group..'Volume']+.1)*100+.5)/100)) end)
        local hit=T.make('TextButton',row,'VolumeSlider',{Text='',BackgroundTransparency=1,Size=UDim2.new(1,-132,0,44),Position=UDim2.fromOffset(66,50),Selectable=true})
        local track=T.frame(hit,'Track',UDim2.new(1,0,0,10),UDim2.new(0,0,.5,-5)) track.BackgroundColor3=Color3.fromRGB(215,194,164)
        local fill=T.make('Frame',track,'Fill',{Size=UDim2.fromScale(.5,1),BackgroundColor3=T.teal,BorderSizePixel=0}) T.make('UICorner',fill,'Corner',{CornerRadius=UDim.new(0,5)})
        local thumb=T.frame(track,'Thumb',UDim2.fromOffset(24,24),UDim2.fromScale(.5,.5)) thumb.AnchorPoint=Vector2.new(.5,.5)
        hit.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag={track=track,group=group,input=i} dragAt(i.Position.X)
            elseif i.KeyCode==Enum.KeyCode.Left then S.set(group..'Volume',math.max(0,draft[group..'Volume']-.05))
            elseif i.KeyCode==Enum.KeyCode.Right then S.set(group..'Volume',math.min(1,draft[group..'Volume']+.05)) end
        end)
        local title=row.Title
        local function layout()
            local wide=row.AbsoluteSize.X>=620
            row.Size=UDim2.new(1,-6,0,wide and 72 or 102)
            if wide then
                title.Size=UDim2.fromOffset(150,72) title.Position=UDim2.fromOffset(12,0)
                toggle.Size=UDim2.fromOffset(66,44) toggle.Position=UDim2.fromOffset(172,14)
                minus.Position=UDim2.fromOffset(248,14) plus.Position=UDim2.new(1,-112,0,14)
                hit.Size=UDim2.new(1,-420,0,44) hit.Position=UDim2.fromOffset(300,14)
                value.Size=UDim2.fromOffset(54,44) value.Position=UDim2.new(1,-62,0,14)
            else
                title.Size=UDim2.new(1,-166,0,40) title.Position=UDim2.fromOffset(12,2)
                toggle.Size=UDim2.fromOffset(74,44) toggle.Position=UDim2.new(1,-82,0,2)
                minus.Position=UDim2.fromOffset(10,50) plus.Position=UDim2.new(1,-54,0,50)
                hit.Size=UDim2.new(1,-132,0,44) hit.Position=UDim2.fromOffset(66,50)
                value.Size=UDim2.fromOffset(64,40) value.Position=UDim2.new(1,-154,0,2)
            end
        end
        row:GetPropertyChangedSignal('AbsoluteSize'):Connect(layout) layout()
        view.groups[group]={toggle=toggle,minus=minus,plus=plus,value=value,fill=fill,thumb=thumb}
    end
    view.status=T.label(parent,'AudioSaveStatus','',UDim2.new(1,-8,0,30),nil,14,true) view.status.LayoutOrder=4
    local hint=T.label(parent,'AudioSaveHint','Изменения сохраняются автоматически',UDim2.new(1,-8,0,36),nil,13) hint.LayoutOrder=5
    refresh()
end
RunService.Heartbeat:Connect(function()
    if not callbacks or not dirty or pending or os.clock()<due or not callbacks.canSave() then return end
    local value=table.clone(draft) local sentVersion=version
    local seq=callbacks.save(value)
    if seq then pending={seq=seq,version=sentVersion,value=value} refresh() end
end)
return S
