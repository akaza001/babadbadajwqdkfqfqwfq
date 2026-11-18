-- Optional guide: one compact HUD card and one user-opened help window.
local T=require(script.Parent.WindowTheme)
local Rules=require(game.ReplicatedStorage.MagnetWorkshop.Shared.GuideRules)
local N={version='0.5.0'} local U=UDim2.fromOffset
-- Screen-space projection keeps the requested waypoint readable, including behind the camera.
-- screenPoint is Camera:WorldToScreenPoint, already adjusted for the Roblox GUI inset.
local function markerBounds(size)
 local short=size.Y<=440 and size.X>=520
 local edge=short and (size.X<700 and 125 or 133) or (size.X<700 and 80 or 88)
 local width=math.min(204,math.max(160,size.X-2*(edge+12)))
 return width,edge
end
function N.project(size,screenPoint)
 local width,edge=markerBounds(size)
 local half=Vector2.new(width/2,28)
 local minX=math.min(edge+half.X+12,size.X/2) local maxX=math.max(minX,size.X-minX)
 local minY=math.min(88,size.Y/2) local maxY=math.max(minY,size.Y-72)
 local center=Vector2.new(size.X/2,(minY+maxY)/2)
 local target=Vector2.new(screenPoint.X,screenPoint.Y)-Vector2.new(0,42)
 local front=screenPoint.Z>.05
 local visible=front and target.X>=minX and target.X<=maxX and target.Y>=minY and target.Y<=maxY
 if visible then return target,180,false end
 local delta=target-center if not front then delta=-delta end
 if delta.Magnitude<.01 then delta=Vector2.new(0,-1) end
 local extent=Vector2.new(math.max(0,maxX-minX)/2,math.max(0,maxY-minY)/2)
 local scale=math.min(extent.X/math.max(.001,math.abs(delta.X)),extent.Y/math.max(.001,math.abs(delta.Y)))
 local position=center+delta*scale
 return position,math.deg(math.atan2(delta.Y,delta.X))+90,true
end
function N.create(parent,callbacks)
 local card=T.frame(parent,'Guide',U(340,84),U(12,52)) card.Visible=false
 local eyebrow=T.label(card,'Stage','',UDim2.new(1,-164,0,16),U(10,5),10,true,T.teal)
 local title=T.label(card,'Title','',UDim2.new(1,-164,0,28),U(10,20),14,true)
 local detail=T.label(card,'Detail','',UDim2.new(1,-164,0,28),U(10,48),11)
 local go=T.button(card,'Go','',U(84,44),UDim2.new(1,-140,0,20),callbacks.go,true,true) go.TextSize=12
 local more=T.button(card,'More','?',U(44,44),UDim2.new(1,-50,0,20),callbacks.more) more.TextSize=22
 local marker=nil local markerConnection=nil local markerTarget=nil local markerToken=0 local currentKey=nil
 local api={root=card}
 function api.clearMarker()
  markerToken+=1 if markerConnection then markerConnection:Disconnect() markerConnection=nil end
  if marker then marker:Destroy() marker=nil end markerTarget=nil
 end
 function api.mark(part,position,copy)
  api.clearMarker() if not part or not part.Parent then return end
  markerTarget=part
  marker=T.frame(parent,'GuideWaypoint',U(204,56)) marker.AnchorPoint=Vector2.new(.5,.5) marker.ZIndex=3
  local arrow=T.label(marker,'Arrow','↑',U(30,44),U(4,6),24,true,T.teal) arrow.TextXAlignment=Enum.TextXAlignment.Center
  T.label(marker,'Target',copy,UDim2.new(1,-46,0,32),U(38,3),13,true,T.teal)
  local hint=T.label(marker,'Hint','',UDim2.new(1,-46,0,18),U(38,35),11)
  local function project()
   if not marker then return end
   if not markerTarget or not markerTarget.Parent then api.clearMarker() return end
   local camera=workspace.CurrentCamera if not camera then marker.Visible=false return end
   local projected=camera:WorldToScreenPoint(position+Vector3.new(0,2.5,0))
   local point,rotation,clipped=N.project(parent.AbsoluteSize,projected)
   local width=markerBounds(parent.AbsoluteSize) marker.Size=U(width,56)
   marker.Position=U(point.X,point.Y) marker.Visible=true arrow.Rotation=rotation
   hint.Text=clipped and 'Следуй за стрелкой' or 'Иди к отметке'
   marker:SetAttribute('Clamped',clipped)
  end
  project() markerConnection=game:GetService('RunService').RenderStepped:Connect(project)
  local token=markerToken task.delay(18,function() if token==markerToken then api.clearMarker() end end)
 end
 function api.update(view,visible,available)
  card.Visible=visible and view~=nil
  if not view then api.clearMarker() return end
  if currentKey~=view.key then api.clearMarker() currentKey=view.key end
  if marker and (not markerTarget or not markerTarget.Parent or (view.action~='Water' and view.action~='ShopMarker' and view.action~='BenchMarker' and view.action~='PortalMarker' and view.action~='FishMarker')) then api.clearMarker() end
  eyebrow.Text=view.eyebrow title.Text=view.title detail.Text=view.detail go.Text=view.button
  T.enabled(go,available==true) more.Interactable=available==true
  card:SetAttribute('GoalKey',view.key) card:SetAttribute('GuideProgress',view.progress)
  if not visible then api.clearMarker() end
  card.Visible=visible and marker==nil
 end
 local function layout()
  local size=parent.AbsoluteSize local short=size.Y<=440 and size.X>=520
  local edge=short and (size.X<700 and 125 or 133) or 0
  local width=math.min(340,size.X-24-(short and edge*2+24 or 0))
  card.Size=U(width,84) card.Position=short and U(size.X/2,52) or U(12,52) card.AnchorPoint=Vector2.new(short and .5 or 0,0)
 end
 local connection=parent:GetPropertyChangedSignal('AbsoluteSize'):Connect(layout)
 card.Destroying:Connect(function() connection:Disconnect() api.clearMarker() end) layout() return api
end
function N.help(body,view,callbacks)
 T.list(body,8)
 local actions=T.make('Frame',body,'Actions',{Size=UDim2.new(1,-4,0,44),BackgroundTransparency=1})
 T.button(actions,'Go',view.button,UDim2.new(.5,-4,1,0),nil,callbacks.go)
 T.button(actions,'HideGuide','Скрыть подсказки',UDim2.new(.5,-4,1,0),UDim2.new(.5,4,0,0),callbacks.hide,true,true).TextSize=13
 T.label(body,'Current',view.title,UDim2.new(1,-8,0,32),nil,20,true)
 local instructions=T.label(body,'Instructions',view.help,UDim2.new(1,-8,0,96),nil,14) instructions.TextYAlignment=Enum.TextYAlignment.Top
 local function resize() instructions.Size=UDim2.new(1,-8,0,body.AbsoluteSize.X>=580 and 48 or 96) end
 local connection=body:GetPropertyChangedSignal('AbsoluteSize'):Connect(resize) body.Destroying:Connect(function() connection:Disconnect() end) resize()
 if view.kind=='goal' and view.biomes then
  for i,biome in view.biomes do
   local row=T.frame(body,'Biome'..biome.id,UDim2.new(1,-8,0,48)) row.BackgroundColor3=biome.caught and Color3.fromRGB(227,239,211) or T.card
   T.label(row,'Number',biome.caught and '✓' or tostring(i),U(30,48),U(8,0),16,true,T.teal)
   T.label(row,'Text',biome.name..'\n'..(biome.caught and 'Первая находка получена' or biome.visited and 'Посещено' or 'Ещё не посещено'),UDim2.new(1,-56,1,-4),U(46,2),13)
  end
 else
 for i,copy in Rules.steps do
  local done=view.kind~='tutorial' or view.index>i
  local row=T.frame(body,'Step'..i,UDim2.new(1,-8,0,44))
  row.BackgroundColor3=done and Color3.fromRGB(227,239,211) or T.card
  T.label(row,'Number',done and '✓' or tostring(i),U(30,44),U(8,0),16,true,T.teal)
  T.label(row,'Text',copy,UDim2.new(1,-56,1,-4),U(46,2),14,view.index==i)
 end
 end
 T.label(body,'RestoreHint','Подсказки можно снова включить в настройках.',UDim2.new(1,-8,0,40),nil,12)
end
return N
