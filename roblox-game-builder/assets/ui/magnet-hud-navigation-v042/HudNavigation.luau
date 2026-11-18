-- Portable icon navigation. Callbacks own game actions; this module only renders UI.
local TweenService=game:GetService('TweenService')
local Icons=require(script.Parent.HudIcons)
local N={version='0.4.2'}
local paper=Color3.fromRGB(247,238,218)
local ink=Color3.fromRGB(45,70,75)
local teal=Color3.fromRGB(45,153,157)
local rows={{'Inventory','inventory','Инвентарь'},{'Journal','collection','Коллекция'},{'Shop','shop','Магазин'},{'Upgrades','upgrades','Улучшения'},{'Sell','sell','Продажа'},{'Settings','settings','Настройки'}}
local function make(class,parent,name,props)
 local v=Instance.new(class) v.Name=name for k,value in props do v[k]=value end v.Parent=parent return v
end
local function corner(p,r) make('UICorner',p,'Corner',{CornerRadius=UDim.new(0,r)}) end
function N.header(parent,page)
 local key=({journal='collection',inventory='inventory',sell='sell',shop='shop',upgrades='upgrades',settings='settings'})[page]
 if not key then return false end
 make('ImageLabel',parent,'PageIcon',{Image=Icons[key],BackgroundTransparency=1,Size=UDim2.fromOffset(42,42),Position=UDim2.fromOffset(16,8),ScaleType=Enum.ScaleType.Fit})
 return true
end
function N.create(parent,callbacks)
 local previous=parent:FindFirstChild('Navigation') if previous then previous:Destroy() end
 local root=make('Frame',parent,'Navigation',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1})
 local tiles=make('Frame',root,'Tiles',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1})
 local utility=make('Frame',root,'Utility',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1})
 local entries={} local enabled=false local selected=nil
 local function bind(button,id)
  local stroke=make('UIStroke',button,'Outline',{Color=Color3.fromRGB(199,177,141),Thickness=1.2,Transparency=.15,ApplyStrokeMode=Enum.ApplyStrokeMode.Border})
  local hovered,pressed=false,false local tween
  local function paint()
   if tween then tween:Cancel() end
   local active=selected==id
   local color=not enabled and Color3.fromRGB(216,215,204) or pressed and Color3.fromRGB(181,216,209) or (hovered or active) and Color3.fromRGB(224,242,230) or paper
   stroke.Color=(hovered or active) and teal or Color3.fromRGB(199,177,141) stroke.Thickness=active and 2 or 1.2
   tween=TweenService:Create(button,TweenInfo.new(.1),{BackgroundColor3=color}) tween:Play()
   local image=button:FindFirstChild('Icon') if image then image.ImageTransparency=enabled and 0 or .45 end
   local caption=button:FindFirstChild('Caption') if caption then caption.TextTransparency=enabled and 0 or .45 end
   button.Interactable=enabled
  end
  button.MouseEnter:Connect(function() hovered=true paint() end)
  button.MouseLeave:Connect(function() hovered=false pressed=false paint() end)
  button.SelectionGained:Connect(function() hovered=true paint() end)
  button.SelectionLost:Connect(function() hovered=false pressed=false paint() end)
  button.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then pressed=true paint() end end)
  button.InputEnded:Connect(function() pressed=false paint() end)
  button.Activated:Connect(function() if enabled then callbacks.activate(id) end end)
  table.insert(entries,{button=button,paint=paint,id=id}) paint()
 end
 for i,row in rows do
  local b=make('TextButton',tiles,row[1],{Text='',LayoutOrder=i,BackgroundColor3=paper,BorderSizePixel=0,AutoButtonColor=false,Selectable=true}) corner(b,12)
  make('ImageLabel',b,'Icon',{Image=Icons[row[2]],BackgroundTransparency=1,Size=UDim2.fromOffset(58,58),Position=UDim2.new(.5,-29,0,1),ScaleType=Enum.ScaleType.Fit})
  make('TextLabel',b,'Caption',{Text=row[3],BackgroundTransparency=1,Position=UDim2.new(0,2,1,-23),Size=UDim2.new(1,-4,0,22),Font=Enum.Font.GothamBold,TextSize=12,TextColor3=ink})
  bind(b,row[1])
 end
 for i,row in {{'Home','Домой'},{'Workshops','Мастерские'}} do
  local b=make('TextButton',utility,row[1],{Text=row[2],Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=ink,BackgroundColor3=paper,BorderSizePixel=0,AutoButtonColor=false,Size=UDim2.new(.5,-4,1,0),Position=UDim2.new((i-1)*.5,(i-1)*4,0,0)}) corner(b,8) bind(b,row[1])
 end
 local function layout(size)
  -- Two edge groups leave the middle clear at every aspect ratio.
  -- Low landscape uses a small 2x2 group on each side above touch controls.
  local short=size.Y<=440 and size.X>=520
  local narrow=size.X<700
  local cellW=short and (narrow and 68 or 74) or (narrow and 78 or 90)
  local cellH=short and 66 or (narrow and 74 or 82)
  local gap=6 local margin=12
  local total=short and cellH*2+gap or cellH*3+gap*2+8+44
  local top=math.max(52,math.min((size.Y-total)/2,size.Y-total-84))
  local groupWidth=short and cellW*2+gap or cellW
  local slots={Inventory={0,0},Journal={0,1},Sell={0,2},Home={0,3},Shop={1,0},Upgrades={1,1},Settings={1,2},Workshops={1,3}}
  for _,e in entries do
   local slot=slots[e.id] local side,index=slot[1],slot[2]
   local x=side==0 and margin or size.X-margin-groupWidth
   local y=top local w,h=cellW,cellH
   if short then x+=index%2*(cellW+gap) y+=math.floor(index/2)*(cellH+gap)
   elseif index==3 then y+=cellH*3+gap*2+8 h=44
   else y+=index*(cellH+gap) end
   e.button.Position=UDim2.fromOffset(x,y) e.button.Size=UDim2.fromOffset(w,h)
   local image=e.button:FindFirstChild('Icon') if image then
    local icon=short and 42 or (narrow and 50 or 58)
    image.Size=UDim2.fromOffset(icon,icon) image.Position=UDim2.new(.5,-icon/2,0,1)
   end
  end
 end
 local connection=parent:GetPropertyChangedSignal('AbsoluteSize'):Connect(function() layout(parent.AbsoluteSize) end)
 root.Destroying:Connect(function() connection:Disconnect() end)
 layout(parent.AbsoluteSize)
 local api={root=root,layout=layout}
 function api.refresh(page,available)
  local id=({inventory='Inventory',journal='Journal',shop='Shop',upgrades='Upgrades',sell='Sell',settings='Settings'})[page]
  if enabled==available and selected==id then return end enabled=available selected=id
  for _,e in entries do e.paint() end
 end
 return api
end
return N
