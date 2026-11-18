-- Shared activity surfaces. Server events own progress and committed rewards.
local T=require(script.Parent.WindowTheme)
local Windows=require(script.Parent.WorkshopWindows)
local C=require(game.ReplicatedStorage.MagnetWorkshop.Shared.Config)
local A={version='0.4.6'}
local U=UDim2.fromOffset
local red=Color3.fromRGB(181,76,63)
local muted=Color3.fromRGB(110,121,115)
local function center(label) label.TextXAlignment=Enum.TextXAlignment.Center return label end
local function root(parent,page)
 local r=T.make('Frame',parent,'Modal',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=6})
 r:SetAttribute('Page',page) return r
end
local function track(parent,name,size,pos,color)
 local p=T.make('Frame',parent,name,{Size=size,Position=pos,BackgroundColor3=Color3.fromRGB(218,202,175),BorderSizePixel=0})
 T.make('UICorner',p,'Round',{CornerRadius=UDim.new(0,5)})
 local f=T.make('Frame',p,'Fill',{Size=UDim2.fromScale(0,1),BackgroundColor3=color or T.teal,BorderSizePixel=0})
 T.make('UICorner',f,'Round',{CornerRadius=UDim.new(0,5)}) return p,f
end
local function resizeWith(parent,r,callback)
 local connection=parent:GetPropertyChangedSignal('AbsoluteSize'):Connect(callback)
 r.Destroying:Connect(function() connection:Disconnect() end) callback()
end
function A.fishing(parent,onCancel,onTap)
 local r=root(parent,'activity')
 local p=T.frame(r,'FishingPanel',U(560,142),UDim2.new(.5,0,1,-100)) p.AnchorPoint=Vector2.new(.5,1)
 local title=T.label(p,'Stage','Магнит летит…',UDim2.new(1,-112,0,28),U(14,8),18,true)
 T.button(p,'Cancel','Отмена',U(84,44),UDim2.new(1,-96,0,8),onCancel).TextSize=13
 local status=T.label(p,'Hint','Дождись касания воды',UDim2.new(1,-112,0,22),U(14,36),13,false,muted)
 local bar=T.make('Frame',p,'TensionBar',{Size=UDim2.new(1,-28,0,18),Position=U(14,68),BackgroundColor3=Color3.fromRGB(224,173,151),BorderSizePixel=0})
 T.make('UICorner',bar,'Round',{CornerRadius=UDim.new(0,6)})
 local safe=T.make('Frame',bar,'Safe',{Size=UDim2.fromScale(.5,1),Position=UDim2.fromScale(.25,0),BackgroundColor3=T.green,BorderSizePixel=0})
 local marker=T.make('Frame',bar,'Marker',{Size=U(5,28),Position=UDim2.new(.5,-2.5,0,-5),BackgroundColor3=T.ink,BorderSizePixel=0,ZIndex=8})
 T.make('UICorner',marker,'Round',{CornerRadius=UDim.new(0,2)})
 local caption=T.label(p,'ProgressLabel','Подъём',U(120,20),U(14,94),12,true)
 local percent=T.label(p,'ProgressValue','0%',U(58,20),UDim2.new(1,-72,0,94),13,true) percent.TextXAlignment=Enum.TextXAlignment.Right
 local progress,fill=track(p,'ProgressBar',UDim2.new(1,-28,0,8),U(14,118))
 local tap=T.button(r,'Tap','Подтянуть',U(204,58),UDim2.new(1,-16,1,-16)) tap.AnchorPoint=Vector2.new(1,1) tap.TextSize=18
 tap.InputBegan:Connect(function(input)
  if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then onTap() end
 end)
 local key=center(T.label(r,'InputHint','Тап / пробел — вправо · пауза — влево',U(320,40),UDim2.new(.5,-160,1,-69),13,true))
 key.BackgroundColor3=T.paper key.BackgroundTransparency=.05 key.TextStrokeTransparency=1 T.surface(key)
 local api={root=r,marker=marker,fill=fill,stage='Casting',low=.25,high=.75}
 function api.update(value)
  api.stage=value.stage or api.stage
  api.low=value.greenMin or api.low api.high=value.greenMax or api.high
  safe.Position=UDim2.fromScale(api.low,0) safe.Size=UDim2.fromScale(api.high-api.low,1)
  local pulling=api.stage=='Pulling'
  tap.Visible=pulling key.Visible=pulling bar.Visible=pulling
  caption.Visible=pulling percent.Visible=pulling progress.Visible=pulling or api.stage=='Revealing'
  title.Text=({Casting='Магнит летит…',Searching='Ищем зацеп…',Pulling='Есть зацеп!',RewardPending='Сохраняем…',CommitPending='Сохраняем…',Revealing='Поднимаем находку!'})[api.stage] or 'Ловля'
  if not pulling then status.Text=api.stage=='Casting' and 'Дождись касания воды' or api.stage=='Searching' and 'Магнит ищет предмет на дне' or api.stage=='Revealing' and 'Готовим находку к показу' or 'Подтверждаем результат' status.TextColor3=muted end
 end
 function api.animate(tension,amount)
  marker.Position=UDim2.new(math.clamp(tension,0,1),-2.5,0,-5)
  fill.Size=UDim2.fromScale(math.clamp(amount,0,1),1) percent.Text=math.floor(amount*100+.5)..'%'
  if api.stage=='Pulling' then
   local good=tension>=api.low and tension<=api.high
   status.Text=good and 'Натяжение в норме' or tension<api.low and 'Трос слабеет · подтяни' or 'Слишком сильно · пауза'
   status.TextColor3=good and T.ink or red tap.BackgroundColor3=good and T.teal or red
   r:SetAttribute('TensionSafe',good)
  end
 end
 resizeWith(parent,r,function()
  local size=parent.AbsoluteSize local short=size.Y<320
  local landscape=size.X>=520
  p.Size=U(landscape and math.min(420,size.X-252) or size.X-24,short and 124 or 142)
  p.Position=landscape and U(12,size.Y-12) or U(size.X/2,size.Y-112) p.AnchorPoint=Vector2.new(landscape and 0 or .5,1)
  bar.Position=U(14,short and 60 or 68)
  caption.Position=U(14,short and 83 or 94) percent.Position=UDim2.new(1,-72,0,short and 83 or 94)
  progress.Position=U(14,short and 108 or 118)
  tap.Size=U(size.X<400 and 164 or 204,56)
  tap.Position=U(size.X-16,size.Y-12)
  if landscape then key.Size=U(tap.Size.X.Offset+16,48) key.Position=U(size.X-16-tap.Size.X.Offset/2,size.Y-78) key.AnchorPoint=Vector2.new(.5,1)
  else key.Size=U(math.min(320,size.X-24),24) key.Position=U(size.X/2,size.Y-76) key.AnchorPoint=Vector2.new(.5,1) end
 end)
 api.update({stage='Casting'}) return api
end
function A.cleaning(parent,onCancel)
 local r=root(parent,'cleaning')
 local p=T.frame(r,'CleaningPanel',U(600,104),UDim2.fromOffset(0,8)) p.AnchorPoint=Vector2.new(.5,0)
 local status=T.label(p,'Stage','ОЧИСТКА · СТОРОНА 1 / 2',UDim2.new(1,-110,0,18),U(12,6),11,true,T.teal)
 local name=T.label(p,'ItemName','',UDim2.new(1,-112,0,36),U(12,23),17,true)
 T.button(p,'Cancel','Отмена',U(84,44),UDim2.new(1,-96,0,12),onCancel).TextSize=13
 local rows={}
 for side=1,2 do
  local row=T.make('Frame',p,'Side'..side,{Size=UDim2.new(.5,-18,0,34),Position=UDim2.new((side-1)*.5,side==1 and 12 or 6,0,63),BackgroundTransparency=1})
  local caption=T.label(row,'Value','Сторона '..side..' · 0%',UDim2.new(1,0,0,18),nil,12,true)
  local _,fill=track(row,'Progress',UDim2.new(1,0,0,7),U(0,23)) rows[side]={caption=caption,fill=fill,row=row}
 end
 local hint=T.frame(r,'CleaningHint',U(430,48),UDim2.new(.5,0,1,-12)) hint.AnchorPoint=Vector2.new(.5,1)
 local help=center(T.label(hint,'Text','Зажми и води по ржавчине',UDim2.new(1,-20,1,-8),U(10,4),14,true))
 local api={root=r}
 function api.update(view,pending)
  name.Text=C.itemsById[view.itemId].name
  local waiting=workspace:GetServerTimeNow()<view.readyAt
  status.Text=pending and 'СОХРАНЯЕМ РЕЗУЛЬТАТ…' or waiting and (view.side==2 and 'ПЕРЕВОРАЧИВАЕМ ПРЕДМЕТ…' or 'ПОДГОТАВЛИВАЕМ ПРЕДМЕТ…') or 'ОЧИСТКА · СТОРОНА '..view.side..' / 2'
  help.Text=pending and 'Результат подтверждается сервером' or waiting and 'Щётка станет доступна через мгновение' or 'Зажми и води по ржавчине · переворот автоматический'
  for side,row in rows do
   local amount=math.clamp(side==1 and view.progress1 or view.progress2,0,1)
   row.fill.Size=UDim2.fromScale(amount,1) row.fill.BackgroundColor3=side<view.side and T.teal or T.green
   row.caption.Text='Сторона '..side..' · '..math.floor(amount*100+.5)..'%' row.caption.TextColor3=side==view.side and T.ink or muted
  end
  r:SetAttribute('Side',view.side) r:SetAttribute('OverallProgress',(view.progress1+view.progress2)/2)
 end
 resizeWith(parent,r,function()
  local size=parent.AbsoluteSize local short=size.Y<300
  p.Size=U(math.min(600,size.X-24),short and 64 or 104) p.Position=U(size.X/2,8)
  status.Visible=not short name.Position=U(12,short and 4 or 23) name.Size=UDim2.new(1,-112,0,short and 28 or 36) name.TextSize=short and 14 or 17
  for side,row in rows do
   row.row.Size=UDim2.new(.5,short and -68 or -18,0,short and 24 or 34)
   row.row.Position=short and (side==1 and U(12,32) or UDim2.new(.5,-44,0,32)) or UDim2.new((side-1)*.5,side==1 and 12 or 6,0,63)
   row.caption.Size=UDim2.new(1,0,0,short and 14 or 18) row.caption.TextSize=short and 10 or 12
   row.fill.Parent.Position=U(0,short and 17 or 23) row.fill.Parent.Size=UDim2.new(1,0,0,short and 5 or 7)
  end
  hint.Size=U(math.min(430,size.X-24),short and 40 or 48) hint.Position=UDim2.new(.5,0,1,short and -8 or -12) help.TextSize=short and 12 or 14
 end)
 return api
end
function A.result(parent,definition,cleaned,newDiscovery,onOpen,onDismiss)
 -- No screen shade or input blocker: movement, fishing and navigation remain usable.
 local p=T.frame(parent,'FindResult',U(440,152),UDim2.fromOffset(parent.AbsoluteSize.X/2,8)) p.AnchorPoint=Vector2.new(.5,0) p.ZIndex=12
 local title=T.label(p,'Stage',cleaned and (newDiscovery and 'НОВОЕ В КОЛЛЕКЦИИ' or 'ПРЕДМЕТ ОЧИЩЕН') or 'НАХОДКА В ИНВЕНТАРЕ',UDim2.new(1,-174,0,20),U(130,8),11,true,T.teal)
 local name=T.label(p,'ItemName',definition.name,UDim2.new(1,-174,0,40),U(130,28),17,true)
 local model=Windows.preview(p,'ItemPreview',definition.id,U(112,126),U(8,12),not cleaned)
 local weight=T.label(p,'Properties',tostring(definition.weightKg):gsub('%.',',')..' кг · '..definition.sellCoins..' монет',UDim2.new(1,-146,0,24),U(130,70),14,true)
 local condition=T.label(p,'Condition',cleaned and 'Готов к выставке или продаже' or 'Стоимость после очистки',U(154,36),U(130,102),12,false,muted)
 local close=T.button(p,'Close','×',U(44,44),UDim2.new(1,-48,0,2),onDismiss) close.TextSize=26
 local open=T.button(p,'OpenInventory','Инвентарь',U(118,44),UDim2.new(1,-130,1,-52),onOpen) open.TextSize=13
 resizeWith(parent,p,function()
  local size=parent.AbsoluteSize local short=size.Y<=440 and size.X>=520
  local edge=short and (size.X<700 and 125 or 133) or 0
  local width=math.min(440,size.X-24-(short and edge*2+24 or 0)) local compact=width<360
  p.Size=U(width,compact and 154 or 152) p.Position=U(size.X/2,8)
  model.Size=U(compact and 72 or 112,compact and 72 or 126) model.Position=U(8,compact and 24 or 12)
  local x=compact and 94 or 130
  title.Position=U(compact and 12 or x,compact and 6 or 8) title.Size=UDim2.new(1,compact and -64 or -174,0,20)
  name.Position=U(x,compact and 26 or 28) name.Size=UDim2.new(1,compact and -150 or -174,0,compact and 40 or 40) name.TextSize=compact and 14 or 17
  weight.Position=U(x,compact and 66 or 70) weight.Size=UDim2.new(1,-x-12,0,compact and 18 or 24) weight.TextSize=compact and 12 or 14
  condition.Position=U(x,compact and 86 or 102) condition.Size=compact and U(width-x-12,14) or U(154,36) condition.TextSize=compact and 10 or 12
  if not compact then condition.Position=U(130,102) end
  open.Size=compact and U(width-24,44) or U(118,44) open.Position=compact and U(12,102) or U(width-130,100)
 end)
 return p
end
function A.failure(parent)
 local p=T.frame(parent,'FishingResult',U(340,66),UDim2.new(.5,0,0,8)) p.AnchorPoint=Vector2.new(.5,0) p.ZIndex=12
 T.label(p,'Heading','Зацеп сорвался',UDim2.new(1,-24,0,26),U(12,6),17,true,red)
 T.label(p,'Hint','Тап — подтянуть · пауза — ослабить',UDim2.new(1,-24,0,24),U(12,32),12)
 resizeWith(parent,p,function() local size=parent.AbsoluteSize local short=size.Y<=440 and size.X>=520 local edge=short and (size.X<700 and 125 or 133) or 0 p.Size=U(math.min(340,size.X-24-(short and edge*2+24 or 0)),66) end) return p
end
return A
