-- Approved window designs rendered as live controls, using current profile data.
local T=require(script.Parent.WindowTheme)
local Shared=game.ReplicatedStorage.MagnetWorkshop.Shared
local C=require(Shared.Config) local Factory=require(Shared.FindFactory)
local Style=require(Shared.SurfaceStyle)
local Assets=require(Shared.ApprovedAssets) local Map=require(Shared.MapAssets)
local W={version='0.4.5'} local selected={} local filter='Все' local themeChoice='Marine'
local U=UDim2.fromOffset
local function number(n) return tostring(n):gsub('%.',',') end
local function preview(parent,name,kind,size,pos,dirty,unknown,level)
 local v=T.make('ViewportFrame',parent,name,{Size=size,Position=pos or UDim2.new(),BackgroundTransparency=1,Ambient=Color3.fromRGB(210,215,204),LightColor=Color3.fromRGB(255,244,223),LightDirection=Vector3.new(-1,-1,-1)})
 local world=T.make('WorldModel',v,'World') local model
 if kind=='magnet' then model=Assets.magnet()
 elseif kind=='Default' or kind=='Marine' then
  model=Map.workshop(true)
  for _,p in model:GetDescendants() do if p:IsA('BasePart') then
   if p:GetAttribute('ThemePanel') then p.Color=kind=='Marine' and Color3.fromRGB(63,112,175) or Map.defaultTheme end
   if not Style.isItem(p) and table.find(Style.baseNames,p.Material.Name) then p:SetAttribute('SurfaceFinish','Starter'..p.Material.Name) Style.part(p) end
  end end
 elseif kind=='display' then model=Map.pedestal()
 else model=Factory.create(kind,dirty==true) end
 model.Parent=world
 if unknown then for _,p in model:GetDescendants() do
  if p:IsA('BasePart') then p.Color=Color3.fromRGB(96,112,114) p.Material=Enum.Material.SmoothPlastic p.MaterialVariant='' if p:IsA('MeshPart') then p.TextureID='' end
  elseif p:IsA('SurfaceAppearance') or p:IsA('Texture') or p:IsA('Decal') then p:Destroy() end
 end end
 if kind=='magnet' and level and level>1 then for _,p in model:GetDescendants() do if p:IsA('BasePart') and p.Name=='YellowHousing' then p.Color=level==2 and T.teal or Color3.fromRGB(226,184,79) end end end
 local camera=T.make('Camera',v,'Camera',{FieldOfView=35}) v.CurrentCamera=camera
 local cf,box=model:GetBoundingBox()
 local function fit()
  local aspect=math.max(.45,v.AbsoluteSize.X/math.max(v.AbsoluteSize.Y,1))
  local direction=(kind=='Default' or kind=='Marine') and Vector3.new(-.35,.25,-1).Unit or Vector3.new(1,.6,1.5).Unit
  local basis=CFrame.lookAt(Vector3.zero,-direction) local distance=.1 local tangent=math.tan(math.rad(17.5))
  for _,x in {-1,1} do for _,y in {-1,1} do for _,z in {-1,1} do
   local point=cf:VectorToWorldSpace(box*Vector3.new(x,y,z)/2)
   local depth=point:Dot(direction)
   distance=math.max(distance,depth+math.abs(point:Dot(basis.UpVector))/tangent,depth+math.abs(point:Dot(basis.RightVector))/(tangent*aspect))
  end end end
  camera.CFrame=CFrame.lookAt(cf.Position+direction*distance*1.12,cf.Position)
 end
 v:GetPropertyChangedSignal('AbsoluteSize'):Connect(fit) fit() return v
end
W.preview=preview
local function chip(parent,name,value,size,pos,color)
 local f=T.frame(parent,name,size,pos) f.BackgroundColor3=color or T.green
 local l=T.label(f,'Text',value,UDim2.new(1,-8,1,0),U(4,0),12,true) l.TextXAlignment=Enum.TextXAlignment.Center return f
end
local function panels(body)
 local left=T.make('Frame',body,'Left',{BackgroundTransparency=1})
 local right=T.scroll(body,'Detail',UDim2.new())
 local detailLayout=T.list(right,8) T.make('UIPadding',right,'Padding',{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,8)})
 local function layout()
  local wide=body.AbsoluteSize.X>=580 local h=body.AbsoluteSize.Y
  if wide then left.Size=UDim2.new(.60,-8,0,h) right.Size=UDim2.new(.40,-4,0,h) right.Position=UDim2.new(.60,8,0,0)
  else left.Size=UDim2.new(1,0,0,math.max(300,h)) right.Size=UDim2.new(1,0,0,360) right.Position=UDim2.fromOffset(0,math.max(300,h)+12) end
  detailLayout.Padding=UDim.new(0,wide and h<320 and 6 or 8)
 end
 body:GetPropertyChangedSignal('AbsoluteSize'):Connect(layout) layout() return left,right
end
local function clearDetail(right)
 for _,p in right:GetChildren() do if not p:IsA('UIListLayout') and not p:IsA('UIPadding') then p:Destroy() end end
 right.CanvasPosition=Vector2.zero
end
local function labelRow(parent,name,value,height,bold,color)
 return T.label(parent,name,value,UDim2.new(1,-4,0,height or 30),nil,bold and 18 or 14,bold,color)
end
local function itemDetail(right,o,f,selling,draw)
 clearDetail(right)
 if not f then labelRow(right,'EmptyDetail','Выбери находку',60,true) return end
 local d=C.itemsById[f.itemId] local compact=right.AbsoluteSize.Y<320
 preview(right,'SelectedPreview',f.itemId,UDim2.new(1,-4,0,compact and (selling and 48 or 72) or 130),nil,f.state=='Dirty')
 labelRow(right,'ItemName',d.name,compact and (selling and 28 or 36) or 46,true)
 if not selling then chip(right,'State',f.displaySlot and 'На полке' or f.state=='Clean' and 'Очищен' or 'Ржавый',UDim2.new(1,-4,0,25),nil,f.state=='Clean' and T.green or Color3.fromRGB(229,202,170)) end
 labelRow(right,'Properties',number(d.weightKg)..' кг   ·   '..d.sellCoins..' монет',compact and 22 or 24)
 if f.state=='Dirty' then
  if selling then labelRow(right,'Blocked','Сначала очисти предмет у своего стола',52)
  else T.button(right,'Clean','Очистить',UDim2.new(1,-4,0,44),nil,function() o.request('StartClean',{findUid=f.uid}) end,true,true) end
  return
 end
 if selling then
  if f.displaySlot then labelRow(right,'Blocked','Сначала сними находку с полки',46) return end
  local copies=0 for _,other in o.profile.finds do if other.itemId==f.itemId then copies+=1 end end
  local warning=T.frame(right,'Confirmation',UDim2.new(1,-4,0,copies==1 and (compact and 44 or 78) or 46)) warning.BackgroundColor3=T.amber
  T.label(warning,'Text',copies==1 and 'Последний экземпляр\nЗапись останется в коллекции' or 'Подтвердить продажу находки?',UDim2.new(1,-16,1,-8),U(8,4),compact and 13 or 14,true)
  T.button(right,'ConfirmSell','Подтвердить · '..d.sellCoins..' монет',UDim2.new(1,-4,0,compact and 44 or 48),nil,function() o.request('Sell',{findUid=f.uid,confirmLast=true}) end,true,true)
  if not compact then labelRow(right,'Location','Продажа у скупщика',30) end
 else
  local actions=T.make('Frame',right,'Actions',{Size=UDim2.new(1,-4,0,44),BackgroundTransparency=1})
  T.button(actions,'Place',f.displaySlot and 'Снять с полки' or 'На полку',UDim2.new(f.displaySlot and 1 or .5,f.displaySlot and 0 or -4,1,0),nil,function()
   if f.displaySlot then o.request('Remove',{findUid=f.uid}) else o.slots(f.uid) end
  end,true,true)
  if not f.displaySlot then T.button(actions,'Sell','Продать',UDim2.new(.5,-4,1,0),UDim2.new(.5,4,0,0),function() o.sell(f.uid) end) end
 end
end
function W.inventory(body,o,selling)
 local left,right=panels(body) local tabs=T.make('Frame',left,'Tabs',{Size=UDim2.new(1,0,0,44),BackgroundTransparency=1})
 local grid=T.scroll(left,'Items',UDim2.new(1,0,1,selling and -50 or -114),U(0,50))
 local layout=selling and T.list(grid,8) or T.make('UIGridLayout',grid,'Grid',{CellPadding=U(6,6),CellSize=U(110,112),SortOrder=Enum.SortOrder.LayoutOrder})
 body.Destroying:Connect(function() if not layout.Parent then layout:Destroy() end end)
 local cards={} local key=selling and 'sell' or 'inventory' local choose
 local function highlight()
  for uid,b in cards do b.BackgroundColor3=uid==selected[key] and Color3.fromRGB(232,242,219) or T.card b.Edge.Color=uid==selected[key] and T.teal or T.tan b.Edge.Thickness=uid==selected[key] and 2.5 or 1 end
 end
 local function draw()
  for _,p in grid:GetChildren() do if p:IsA('GuiObject') then p:Destroy() end end cards={}
  layout.Parent=grid
  local entries={} for _,f in o.profile.finds do if filter=='Все' or filter=='Очищенные' and f.state=='Clean' or filter=='Ржавые' and f.state=='Dirty' then table.insert(entries,f) end end
  table.sort(entries,function(a,b) if a.foundAt==b.foundAt then return a.uid<b.uid end return a.foundAt>b.foundAt end)
  local valid=false for _,f in entries do if f.uid==selected[key] then valid=true end end
  if not valid then selected[key]=entries[1] and entries[1].uid end
  for i,f in entries do
   local d=C.itemsById[f.itemId] local b=T.make('TextButton',grid,f.uid,{Text='',BackgroundColor3=T.card,LayoutOrder=i,AutoButtonColor=false}) T.surface(b)
   if selling then
    b.Size=UDim2.new(1,-6,0,84)
    preview(b,'Preview',f.itemId,U(58,70),U(4,4),f.state=='Dirty')
    T.label(b,'Name',d.name,UDim2.new(1,-78,0,38),U(68,3),13,true)
    chip(b,'State',f.displaySlot and 'На полке' or f.state=='Clean' and 'Очищен' or 'Сначала очисти',UDim2.new(1,-174,0,25),U(68,47),f.state=='Clean' and T.green or Color3.fromRGB(229,202,170))
    local price=T.label(b,'Price',d.sellCoins..' монет',U(92,25),UDim2.new(1,-100,0,47),12,true) price.TextXAlignment=Enum.TextXAlignment.Right
   else
    preview(b,'Preview',f.itemId,UDim2.new(1,-8,1,-54),U(4,0),f.state=='Dirty')
    local name=T.label(b,'Name',d.name,UDim2.new(1,-10,0,30),UDim2.new(0,5,1,-54),12,true) name.TextXAlignment=Enum.TextXAlignment.Center
    chip(b,'State',f.displaySlot and 'На полке' or f.state=='Clean' and 'Очищен' or 'Ржавый',UDim2.new(1,-12,0,21),UDim2.new(0,6,1,-23),f.state=='Clean' and T.green or Color3.fromRGB(229,202,170))
   end
   b.Activated:Connect(function() selected[key]=f.uid highlight() itemDetail(right,o,f,selling,draw) if o.pending then o.pending() end end) cards[f.uid]=b
  end
  if #entries==0 then layout.Parent=nil local empty=labelRow(grid,'Empty','Пока пусто. Сделай заброс с помоста.',90,true) empty.TextXAlignment=Enum.TextXAlignment.Center end
  highlight() itemDetail(right,o,selected[key] and o.profile.finds[selected[key]],selling,draw)
  if o.pending then o.pending() end
 end
 for i,value in {'Все','Очищенные','Ржавые'} do
  local b=T.button(tabs,'Filter'..i,value,UDim2.new(1/3,-4,1,0),UDim2.new((i-1)/3,2,0,0),function()
   filter=value for _,p in tabs:GetChildren() do if p:IsA('TextButton') then p.BackgroundColor3=p.Text==filter and T.teal or Color3.fromRGB(191,171,143) end end draw()
  end)
  b.TextSize=12 b.BackgroundColor3=value==filter and T.teal or Color3.fromRGB(191,171,143)
 end
 local function resize()
  if selling then return end
  local width=grid.AbsoluteSize.X local cols=math.max(2,math.floor((width+6)/122)) local cell=math.floor((width-6*(cols-1)-6)/cols)
  layout.CellSize=U(cell,math.max(104,math.min(142,cell,grid.AbsoluteSize.Y)))
 end
 grid:GetPropertyChangedSignal('AbsoluteSize'):Connect(resize) resize()
 if not selling then
  local eq=T.frame(left,'Equipment',UDim2.new(1,0,0,58),UDim2.new(0,0,1,-58))
  preview(eq,'MagnetPreview','magnet',U(54,54),U(0,0),false,false,o.profile.toolLevel)
  T.label(eq,'Level','Магнит '..o.profile.toolLevel..' / 3',UDim2.new(1,-148,1,0),U(56,0),12,true)
  T.button(eq,'EquipMagnet',o.equipped() and 'Убрать' or 'Взять',U(84,44),UDim2.new(1,-90,0,7),o.toggle,true,true)
 end
 if o.selectUid then selected[key]=o.selectUid end draw()
end
function W.collection(body,o)
 local progress=T.frame(body,'Progress',UDim2.new(1,0,0,12))
 local n=0 for _ in o.profile.discovered do n+=1 end
 local fill=T.make('Frame',progress,'Fill',{Size=UDim2.fromScale(n/#C.items,1),BackgroundColor3=T.teal,BorderSizePixel=0}) T.make('UICorner',fill,'Round',{CornerRadius=UDim.new(0,6)})
 local grid=T.scroll(body,'Catalog',UDim2.new(1,0,1,-76),U(0,24)) local layout=T.make('UIGridLayout',grid,'Grid',{CellPadding=U(8,8),SortOrder=Enum.SortOrder.LayoutOrder})
 local footer=T.frame(body,'Selected',UDim2.new(1,0,0,44),UDim2.new(0,0,1,-44))
 local info=T.label(footer,'Text','Выбери находку',UDim2.new(1,-16,1,-4),U(8,2),14,true)
 local cards={}
 for i,d in C.items do local found=o.profile.discovered[d.id] local b=T.make('TextButton',grid,d.id,{Text='',LayoutOrder=i,BackgroundColor3=T.card,AutoButtonColor=false}) T.surface(b)
  preview(b,'Preview',d.id,UDim2.new(1,-8,1,-40),U(4,0),false,not found)
  local l=T.label(b,'Name',found and d.name or 'Не найдено',UDim2.new(1,-8,0,36),UDim2.new(0,4,1,-38),12,true) l.TextXAlignment=Enum.TextXAlignment.Center
  if not found then local q=T.label(b,'Unknown','?',UDim2.fromScale(1,.6),nil,30,true,T.paper) q.TextXAlignment=Enum.TextXAlignment.Center end
  b.Activated:Connect(function()
   for id,card in cards do card.Edge.Color=id==d.id and T.teal or T.tan card.Edge.Thickness=id==d.id and 2.5 or 1 end
   info.Text=found and d.name..' · '..C.zonesById[d.zone].name..' · '..number(d.weightKg)..' кг' or 'Не найдено · '..C.zonesById[d.zone].name
  end) cards[d.id]=b
 end
 local function resize() local cols=grid.AbsoluteSize.X>=560 and 4 or 2 local cell=math.floor((grid.AbsoluteSize.X-(cols-1)*8-6)/cols) layout.CellSize=U(cell,math.max(110,math.min(154,cell*.85))) end
 grid:GetPropertyChangedSignal('AbsoluteSize'):Connect(resize) resize()
end
function W.upgrades(body,o)
 local content=T.make('Frame',body,'Equipment',{Size=UDim2.new(1,0,0,384),BackgroundTransparency=1})
 local tierCards={}
 for i,d in C.toolLevels do
  local card=T.frame(content,'Tier'..i,UDim2.new(1/3,-8,0,196),UDim2.new((i-1)/3,4,0,0))
  T.label(card,'Title','Уровень '..i,UDim2.new(1,-12,0,30),U(6,0),16,true).TextXAlignment=Enum.TextXAlignment.Center
  preview(card,'Preview','magnet',UDim2.new(1,-8,0,88),U(4,30),false,false,i)
  T.label(card,'Weight','До '..d.maxWeightKg..' кг',UDim2.new(1,-12,0,26),U(6,120),14,true).TextXAlignment=Enum.TextXAlignment.Center
  chip(card,'State',i<=o.profile.toolLevel and 'Куплено' or d.cost..' монет',UDim2.new(1,-12,0,30),U(6,154),i<=o.profile.toolLevel and T.green or T.paper)
  if i==o.profile.toolLevel+1 then card.Edge.Color=T.teal card.Edge.Thickness=2 end tierCards[i]=card
 end
 local level=o.profile.toolLevel local nextLevel=C.toolLevels[level+1] local affordable=nextLevel and o.profile.coins>=nextLevel.cost
 T.button(content,'ToolUpgrade',not nextLevel and 'Улучшено полностью' or affordable and 'Улучшить · '..nextLevel.cost..' монет' or 'Не хватает '..nextLevel.cost-o.profile.coins..' монет',UDim2.new(1,-8,0,44),U(4,208),function() o.request('BuyUpgrade',{upgradeId='Tool'}) end,affordable==true,true)
 local expansion=T.frame(content,'Expansion',UDim2.new(1,-8,0,82),U(4,268))
 T.label(expansion,'Title','Места для экспонатов  ·  6 → 12',UDim2.new(1,-16,0,28),U(8,2),15,true)
 local cost=C.upgrades[1].cost local can=not o.profile.expandedDisplay and o.profile.coins>=cost
 T.button(expansion,'Expand',o.profile.expandedDisplay and 'Все места открыты' or can and 'Расширить · '..cost..' монет' or 'Не хватает '..cost-o.profile.coins..' монет',UDim2.new(1,-16,0,44),U(8,32),function() o.request('BuyUpgrade',{upgradeId='Display'}) end,can,true)
 T.label(content,'Location','Покупка у стойки оборудования',UDim2.new(1,-8,0,26),U(4,356),13)
 local function resize()
  local compact=body.AbsoluteSize.Y<320
  local shift=compact and 20 or 0
  for _,card in tierCards do
   card.Size=UDim2.new(1/3,-8,0,196-shift)
   card.Preview.Size=UDim2.new(1,-8,0,88-shift)
   card.Weight.Position=U(6,120-shift) card.State.Position=U(6,154-shift)
  end
  content.ToolUpgrade.Position=U(4,208-shift)
  expansion.Position=U(4,268-shift) content.Location.Position=U(4,356-shift)
  content.Size=UDim2.new(1,0,0,384-shift)
 end
 body:GetPropertyChangedSignal('AbsoluteSize'):Connect(resize) resize()
end
function W.shop(body,o)
 local left,right=panels(body) local cards={}
 for i,key in {'Default','Marine'} do
  local card=T.make('TextButton',left,key,{Text='',Size=UDim2.new(.5,-4,1,0),Position=UDim2.new((i-1)*.5,(i-1)*4,0,0),BackgroundColor3=T.card,AutoButtonColor=false}) T.surface(card)
  preview(card,'Preview',key,UDim2.new(1,-8,1,-100),U(4,4))
  T.label(card,'Name',key=='Default' and 'Обычная' or 'Морская',UDim2.new(1,-12,0,30),UDim2.new(0,6,1,-94),16,true).TextXAlignment=Enum.TextXAlignment.Center
  chip(card,'State',o.profile.selectedTheme==key and 'Используется' or (key=='Default' or o.profile.ownedCoinThemes.Marine) and 'Куплено' or C.upgrades[2].cost..' монет',UDim2.new(1,-12,0,46),UDim2.new(0,6,1,-58))
  cards[key]=card
 end
 local function draw()
  clearDetail(right)
  for key,card in cards do card.Edge.Color=key==themeChoice and T.teal or T.tan card.Edge.Thickness=key==themeChoice and 2.5 or 1 end
  labelRow(right,'Name',themeChoice=='Default' and 'Обычная' or 'Морская',26,true)
  preview(right,'WorkshopPreview',themeChoice,UDim2.new(1,-4,0,right.AbsoluteSize.Y<320 and 58 or 150))
  labelRow(right,'Cosmetic','Меняет только внешний вид',24)
  local owned=themeChoice=='Default' or o.profile.ownedCoinThemes.Marine local current=o.profile.selectedTheme==themeChoice local cost=C.upgrades[2].cost
  local available=not current and (owned or o.profile.coins>=cost)
  local value=current and 'Используется' or owned and 'Применить' or o.profile.coins>=cost and 'Купить · '..cost..' монет' or 'Не хватает '..cost-o.profile.coins..' монет'
  T.button(right,'Marine',value,UDim2.new(1,-4,0,44),nil,function() if owned then o.request('SelectTheme',{themeId=themeChoice}) else o.request('BuyUpgrade',{upgradeId='Marine'}) end end,available,true)
  T.button(right,'OpenUpgrades','Улучшения оборудования',UDim2.new(1,-4,0,48),nil,o.upgrades)
  labelRow(right,'Location','Покупка у стойки оборудования',42)
  if o.pending then o.pending() end
 end
 for key,card in cards do card.Activated:Connect(function() themeChoice=key draw() end) end draw()
end
return W
