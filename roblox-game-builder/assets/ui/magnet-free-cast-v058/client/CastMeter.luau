-- Minimal translucent strip; input is shared with the host's cast controls.
local RunService=game:GetService('RunService')
local Shared=game.ReplicatedStorage.MagnetWorkshop.Shared
local C=require(Shared.Config) local Rules=require(Shared.CastRules)
local T=require(script.Parent.WindowTheme)
local M={version='0.5.8'}
local root,view,marker,fill,hit,connection,resize=nil,nil,nil,nil,nil,nil,nil
local releaseCallback=nil local frozenAt=nil local openedAt=0 local height=0
function M.stop()
 if connection then connection:Disconnect() connection=nil end
 if resize then resize:Disconnect() resize=nil end
 if root then root:Destroy() end root=nil view=nil frozenAt=nil releaseCallback=nil
end
function M.resume() frozenAt=nil if hit then hit.Interactable=true end end
function M.confirm()
 if not view or frozenAt or os.clock()-openedAt<.18 then return end
 frozenAt=math.max(0,workspace:GetServerTimeNow()-view.started) hit.Interactable=false
 releaseCallback(view.id,frozenAt)
end
local function draw()
 if not root or not root.Parent then return end
 local elapsed=frozenAt or math.max(0,workspace:GetServerTimeNow()-view.started)
 local position=Rules.position(elapsed) local power=Rules.powerAt(position)
 marker.Position=UDim2.fromOffset(22,6+height*(1-position)) fill.Size=UDim2.fromScale(1,power)
 root:SetAttribute('Power',power) root:SetAttribute('Elapsed',elapsed) root:SetAttribute('SliderPosition',position)
end
function M.show(parent,data,onRelease,onCancel)
 M.stop() view=data releaseCallback=onRelease openedAt=os.clock()
 root=T.make('Frame',parent,'CastMeter',{Size=UDim2.fromOffset(44,190),Position=UDim2.fromScale(.6,.5),AnchorPoint=Vector2.new(.5,.5),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=6})
 root:SetAttribute('Page','aiming') root:SetAttribute('Orientation','Vertical') root:SetAttribute('Minimal',true)
 local track=T.make('Frame',root,'Track',{Position=UDim2.fromOffset(13,6),BackgroundColor3=T.ink,BackgroundTransparency=.55,BorderSizePixel=0,ClipsDescendants=true})
 T.make('UICorner',track,'Corner',{CornerRadius=UDim.new(0,8)})
 T.make('UIStroke',track,'Edge',{Color=T.paper,Thickness=1,Transparency=.55})
 fill=T.make('Frame',track,'Fill',{Size=UDim2.fromScale(1,0),Position=UDim2.fromScale(0,1),AnchorPoint=Vector2.new(0,1),BackgroundColor3=T.teal,BackgroundTransparency=.35,BorderSizePixel=0})
 T.make('Frame',track,'StrongZone',{Size=UDim2.fromScale(1,C.cast.strongMax-C.cast.strongMin),Position=UDim2.fromScale(0,1-C.cast.strongMax),BackgroundColor3=T.green,BackgroundTransparency=.4,BorderSizePixel=0})
 marker=T.make('Frame',root,'Slider',{Size=UDim2.fromOffset(30,5),AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=T.paper,BackgroundTransparency=.2,BorderSizePixel=0,ZIndex=8})
 T.make('UICorner',marker,'Corner',{CornerRadius=UDim.new(0,2)})
 T.make('UIStroke',marker,'Edge',{Color=T.ink,Thickness=1,Transparency=.45})
 hit=T.make('TextButton',root,'ReleaseCast',{Size=UDim2.fromScale(1,1),Text='',BackgroundTransparency=1,BorderSizePixel=0,AutoButtonColor=false,ZIndex=9}) hit.Activated:Connect(M.confirm)
 local function adapt()
  local size=parent.AbsoluteSize height=math.clamp(size.Y*.42,100,190)
  root.Size=UDim2.fromOffset(44,height+12) track.Size=UDim2.fromOffset(18,height)
 end
 resize=parent:GetPropertyChangedSignal('AbsoluteSize'):Connect(adapt)
 root.Destroying:Once(function() if resize then resize:Disconnect() resize=nil end end)
 adapt() draw() connection=RunService.Heartbeat:Connect(draw)
 return root
end
return M
