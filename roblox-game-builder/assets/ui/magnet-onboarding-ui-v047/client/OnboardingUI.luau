-- Optional guide: one compact HUD card and one user-opened help window.
local T=require(script.Parent.WindowTheme)
local Rules=require(game.ReplicatedStorage.MagnetWorkshop.Shared.GuideRules)
local N={version='0.4.7'} local U=UDim2.fromOffset
function N.create(parent,callbacks)
 local card=T.frame(parent,'Guide',U(340,84),U(12,52)) card.Visible=false
 local eyebrow=T.label(card,'Stage','',UDim2.new(1,-164,0,16),U(10,5),10,true,T.teal)
 local title=T.label(card,'Title','',UDim2.new(1,-164,0,28),U(10,20),14,true)
 local detail=T.label(card,'Detail','',UDim2.new(1,-164,0,28),U(10,48),11)
 local go=T.button(card,'Go','',U(84,44),UDim2.new(1,-140,0,20),callbacks.go,true,true) go.TextSize=12
 local more=T.button(card,'More','?',U(44,44),UDim2.new(1,-50,0,20),callbacks.more) more.TextSize=22
 local marker=nil local markerToken=0 local currentKey=nil
 local api={root=card}
 function api.clearMarker()
  markerToken+=1 if marker then marker:Destroy() marker=nil end
 end
 function api.mark(part,position,copy)
  api.clearMarker() if not part or not part.Parent then return end
  local anchor=part
  if (position-part.Position).Magnitude>16 then local hit=workspace:Raycast(position+Vector3.new(0,8,0),Vector3.new(0,-20,0)) if hit and hit.Instance:IsA('BasePart') then anchor=hit.Instance end end
  marker=T.make('BillboardGui',anchor,'GuideWaypoint',{Adornee=anchor,Size=U(164,44),StudsOffsetWorldSpace=position-anchor.Position+Vector3.new(0,4,0),AlwaysOnTop=true,MaxDistance=550})
  local f=T.frame(marker,'Card',UDim2.fromScale(1,1))
  local label=T.label(f,'Text','↓ '..copy,UDim2.new(1,-12,1,-4),U(6,2),14,true,T.teal) label.TextXAlignment=Enum.TextXAlignment.Center
  local token=markerToken task.delay(18,function() if token==markerToken then api.clearMarker() end end)
 end
 function api.update(view,visible,available)
  card.Visible=visible and view~=nil
  if not view then api.clearMarker() return end
  if currentKey~=view.key then api.clearMarker() currentKey=view.key end
  if marker and (not marker.Adornee or not marker.Adornee.Parent or (view.action~='Water' and view.action~='ShopMarker' and view.action~='BenchMarker')) then api.clearMarker() end
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
 for i,copy in Rules.steps do
  local done=view.kind~='tutorial' or view.index>i
  local row=T.frame(body,'Step'..i,UDim2.new(1,-8,0,44))
  row.BackgroundColor3=done and Color3.fromRGB(227,239,211) or T.card
  T.label(row,'Number',done and '✓' or tostring(i),U(30,44),U(8,0),16,true,T.teal)
  T.label(row,'Text',copy,UDim2.new(1,-56,1,-4),U(46,2),14,view.index==i)
 end
 T.label(body,'RestoreHint','Подсказки можно снова включить в настройках.',UDim2.new(1,-8,0,40),nil,12)
end
return N
