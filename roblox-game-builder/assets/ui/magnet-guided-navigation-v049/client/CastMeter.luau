-- Shared server-clock timing, dressed with the existing native window theme.
local RunService=game:GetService('RunService')
local Shared=game.ReplicatedStorage.MagnetWorkshop.Shared
local C=require(Shared.Config) local Rules=require(Shared.CastRules)
local T=require(script.Parent.WindowTheme)
local M={version='0.4.6'}
local root,view,marker,value,throwButton,connection=nil,nil,nil,nil,nil,nil
local releaseCallback=nil local frozenAt=nil local openedAt=0 local arc={} local geometry=nil
function M.stop()
 if connection then connection:Disconnect() connection=nil end
 if root then root:Destroy() end root=nil view=nil frozenAt=nil releaseCallback=nil arc={} geometry=nil
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
 local position=Rules.position(elapsed) local power=Rules.powerAt(position) local angle=math.pi*(1-position)
 marker.Position=UDim2.fromOffset(geometry.x+geometry.radius*math.cos(angle),geometry.y-geometry.radius*math.sin(angle)) marker.Rotation=90-math.deg(angle)
 value.Text=math.floor(power*100+.5)..'%'
 root:SetAttribute('Power',power) root:SetAttribute('Distance',Rules.distance(power)) root:SetAttribute('Elapsed',elapsed) root:SetAttribute('SliderPosition',position)
end
function M.show(parent,data,onRelease,onCancel)
 M.stop() view=data releaseCallback=onRelease openedAt=os.clock()
 root=T.frame(parent,'CastMeter',UDim2.fromOffset(360,274),UDim2.fromScale(.5,.48)) root.AnchorPoint=Vector2.new(.5,.5) root.ZIndex=6 root:SetAttribute('Page','aiming')
 local title=T.label(root,'Heading','Выбери силу броска',UDim2.new(1,-74,0,28),UDim2.fromOffset(14,8),18,true)
 local cancel=T.button(root,'Cancel','×',UDim2.fromOffset(44,44),UDim2.new(1,-52,0,4),onCancel) cancel.TextSize=26
 local instruction=T.label(root,'Instruction','Останови ползунок у вершины дуги',UDim2.new(1,-28,0,22),UDim2.fromOffset(14,36),12,false,Color3.fromRGB(110,121,115))
 for i=1,48 do
  local position=(i-.5)/48 local color=position>=C.cast.strongMin and position<=C.cast.strongMax and T.green or T.teal
  arc[i]=T.make('Frame',root,string.format('Arc%02d',i),{Size=UDim2.fromOffset(8,8),BackgroundColor3=color,BorderSizePixel=0,AnchorPoint=Vector2.new(.5,.5)})
  T.make('UICorner',arc[i],'Corner',{CornerRadius=UDim.new(0,2)})
 end
 marker=T.make('Frame',root,'Slider',{Size=UDim2.fromOffset(5,26),AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=T.ink,BorderSizePixel=0,ZIndex=8}) T.make('UICorner',marker,'Corner',{CornerRadius=UDim.new(0,2)})
 value=T.label(root,'Power','0%',UDim2.fromOffset(120,42),nil,30,true) value.TextXAlignment=Enum.TextXAlignment.Center
 local strong=T.label(root,'Strong','ДАЛЬНИЙ БРОСОК',UDim2.fromOffset(130,18),nil,10,true,T.teal) strong.TextXAlignment=Enum.TextXAlignment.Center
 local left=T.label(root,'NearLeft','Ближе',UDim2.fromOffset(64,20),nil,12) left.TextXAlignment=Enum.TextXAlignment.Center
 local right=T.label(root,'NearRight','Ближе',UDim2.fromOffset(64,20),nil,12) right.TextXAlignment=Enum.TextXAlignment.Center
 local keys=T.label(root,'InputHint','Пробел / E / тап',UDim2.fromOffset(160,22),nil,12,false) keys.TextXAlignment=Enum.TextXAlignment.Center
 throwButton=T.button(root,'ReleaseCast','Бросить',UDim2.fromOffset(300,48),nil,M.confirm) throwButton.TextSize=18
 local function adapt()
  local size=parent.AbsoluteSize local short=size.Y<340 local width=math.min(short and 500 or 360,size.X-24) local height=short and 196 or 274
  root.Size=UDim2.fromOffset(width,height) root.Position=UDim2.fromScale(.5,.48)
  local radius=short and math.min(76,width*.24) or math.min(106,(width-52)/2)
  geometry={x=short and width*.34 or width/2,y=short and 157 or 187,radius=radius}
  for i,p in arc do local angle=math.pi*(1-(i-.5)/48) p.Position=UDim2.fromOffset(geometry.x+radius*math.cos(angle),geometry.y-radius*math.sin(angle)) p.Rotation=90-math.deg(angle) end
  value.Position=UDim2.fromOffset(geometry.x-60,geometry.y-60)
  strong.Position=UDim2.fromOffset(geometry.x-65,geometry.y-radius+16)
  left.Position=UDim2.fromOffset(geometry.x-radius-32,geometry.y+7) right.Position=UDim2.fromOffset(geometry.x+radius-32,geometry.y+7)
  if short then
   local buttonWidth=math.max(118,width*.32)
   throwButton.Size=UDim2.fromOffset(buttonWidth,48) throwButton.Position=UDim2.fromOffset(width-14-buttonWidth,92)
   keys.Size=UDim2.fromOffset(width*.36,24) keys.Position=UDim2.new(1,-14-width*.34,0,146)
  else
   throwButton.Size=UDim2.new(1,-28,0,48) throwButton.Position=UDim2.fromOffset(14,214)
   keys.Size=UDim2.fromOffset(160,22) keys.Position=UDim2.fromOffset(width/2-80,188)
  end
 end
 local resize=parent:GetPropertyChangedSignal('AbsoluteSize'):Connect(adapt) root.Destroying:Once(function() resize:Disconnect() end)
 adapt() draw()
 connection=RunService.Heartbeat:Connect(draw)
 return root
end
return M
