-- Shared server-clock timing, dressed with the existing native window theme.
local RunService=game:GetService('RunService')
local Shared=game.ReplicatedStorage.MagnetWorkshop.Shared
local C=require(Shared.Config) local Rules=require(Shared.CastRules)
local T=require(script.Parent.WindowTheme)
local M={version='0.5.7'}
local root,view,marker,value,throwButton,connection=nil,nil,nil,nil,nil,nil
local releaseCallback=nil local frozenAt=nil local openedAt=0 local geometry=nil local fill,distance=nil,nil
function M.stop()
 if connection then connection:Disconnect() connection=nil end
 if root then root:Destroy() end root=nil view=nil frozenAt=nil releaseCallback=nil geometry=nil fill=nil distance=nil
end
function M.resume() frozenAt=nil if throwButton then T.enabled(throwButton,true) throwButton.Text='Бросить' end end
function M.confirm()
 if not view or frozenAt or os.clock()-openedAt<.18 then return end
 frozenAt=math.max(0,workspace:GetServerTimeNow()-view.started)
 T.enabled(throwButton,false) throwButton.Text='Бросаем…'
 releaseCallback(view.id,frozenAt)
end
local function draw()
 if not root or not root.Parent or not geometry then return end
 local elapsed=frozenAt or math.max(0,workspace:GetServerTimeNow()-view.started)
 local position=Rules.position(elapsed) local power=Rules.powerAt(position)
 marker.Position=UDim2.fromOffset(geometry.x,geometry.top+geometry.height*(1-position))
 fill.Size=UDim2.fromScale(1,power)
 value.Text=math.floor(power*100+.5)..'%'
 distance.Text=string.format('%.0f / %d студ.',Rules.distance(power),C.cast.maxDistance)
 root:SetAttribute('Power',power) root:SetAttribute('Distance',Rules.distance(power)) root:SetAttribute('Elapsed',elapsed) root:SetAttribute('SliderPosition',position)
end
function M.show(parent,data,onRelease,onCancel)
 M.stop() view=data releaseCallback=onRelease openedAt=os.clock()
 root=T.frame(parent,'CastMeter',UDim2.fromOffset(320,330),UDim2.fromScale(.5,.48)) root.AnchorPoint=Vector2.new(.5,.5) root.ZIndex=6 root:SetAttribute('Page','aiming') root:SetAttribute('Orientation','Vertical')
 local title=T.label(root,'Heading','Выбери силу броска',UDim2.new(1,-74,0,28),UDim2.fromOffset(14,8),18,true)
 local cancel=T.button(root,'Cancel','×',UDim2.fromOffset(44,44),UDim2.new(1,-52,0,4),onCancel) cancel.TextSize=26
 local instruction=T.label(root,'Instruction','Останови ползунок ближе к верху',UDim2.new(1,-28,0,26),UDim2.fromOffset(14,38),12,false,T.muted)
 local track=T.make('Frame',root,'Track',{BackgroundColor3=T.tan,BackgroundTransparency=.55,BorderSizePixel=0,ClipsDescendants=true})
 T.make('UICorner',track,'Corner',{CornerRadius=UDim.new(0,10)})
 fill=T.make('Frame',track,'Fill',{Size=UDim2.fromScale(1,0),Position=UDim2.fromScale(0,1),AnchorPoint=Vector2.new(0,1),BackgroundColor3=T.teal,BorderSizePixel=0})
 local strongZone=T.make('Frame',track,'StrongZone',{Size=UDim2.fromScale(1,C.cast.strongMax-C.cast.strongMin),Position=UDim2.fromScale(0,1-C.cast.strongMax),BackgroundColor3=T.green,BackgroundTransparency=.15,BorderSizePixel=0})
 marker=T.make('Frame',root,'Slider',{Size=UDim2.fromOffset(42,7),AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=Color3.fromRGB(255,251,240),BorderSizePixel=0,ZIndex=8}) T.make('UICorner',marker,'Corner',{CornerRadius=UDim.new(0,3)}) T.make('UIStroke',marker,'Edge',{Color=T.ink,Thickness=2})
 value=T.label(root,'Power','0%',UDim2.fromOffset(180,42),nil,32,true) value.TextXAlignment=Enum.TextXAlignment.Center
 distance=T.label(root,'Distance','',UDim2.fromOffset(180,22),nil,13,false,T.muted) distance.TextXAlignment=Enum.TextXAlignment.Center
 local strong=T.label(root,'Strong','СИЛЬНЫЙ БРОСОК',UDim2.fromOffset(180,18),nil,10,true,T.teal) strong.TextXAlignment=Enum.TextXAlignment.Center
 local high=T.label(root,'Maximum','100%',UDim2.fromOffset(40,20),nil,11,true,T.teal) high.TextXAlignment=Enum.TextXAlignment.Right
 local low=T.label(root,'Minimum','0%',UDim2.fromOffset(40,20),nil,11,false,T.muted) low.TextXAlignment=Enum.TextXAlignment.Right
 local keys=T.label(root,'InputHint','Пробел / E / тап',UDim2.fromOffset(160,22),nil,12,false) keys.TextXAlignment=Enum.TextXAlignment.Center
 throwButton=T.button(root,'ReleaseCast','Бросить',UDim2.fromOffset(300,48),nil,M.confirm) throwButton.TextSize=18
 local function adapt()
  local size=parent.AbsoluteSize local short=size.Y<340 local width=math.min(320,size.X-24) local height=math.min(330,size.Y-24)
  root.Size=UDim2.fromOffset(width,height) root.Position=UDim2.fromScale(.5,.48)
  geometry={x=72,top=80,height=height-176}
  track.Position=UDim2.fromOffset(60,geometry.top) track.Size=UDim2.fromOffset(24,geometry.height)
  high.Position=UDim2.fromOffset(8,geometry.top-10) low.Position=UDim2.fromOffset(8,geometry.top+geometry.height-10)
  local infoWidth=width-116 local middle=geometry.top+geometry.height*.5
  strong.Size=UDim2.fromOffset(infoWidth,18) strong.Position=UDim2.fromOffset(102,geometry.top)
  value.Size=UDim2.fromOffset(infoWidth,42) value.Position=UDim2.fromOffset(102,middle-22) value.TextSize=short and 27 or 32
  distance.Size=UDim2.fromOffset(infoWidth,22) distance.Position=UDim2.fromOffset(102,middle+22)
  keys.Size=UDim2.new(1,-28,0,22) keys.Position=UDim2.fromOffset(14,height-84)
  throwButton.Size=UDim2.new(1,-28,0,48) throwButton.Position=UDim2.fromOffset(14,height-60)
 end
 local resize=parent:GetPropertyChangedSignal('AbsoluteSize'):Connect(adapt) root.Destroying:Once(function() resize:Disconnect() end)
 adapt() draw()
 connection=RunService.Heartbeat:Connect(draw)
 return root
end
return M
