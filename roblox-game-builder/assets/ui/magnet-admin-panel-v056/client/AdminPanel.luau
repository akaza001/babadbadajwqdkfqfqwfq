-- Reuses the approved light window theme. Forms and catalog choices come from the server.
local Players=game:GetService('Players')
local UIS=game:GetService('UserInputService')
local RunService=game:GetService('RunService')
local T=require(script.Parent.WindowTheme)
local A={version='0.5.6'}
local U=UDim2.fromOffset
function A.start(o)
 if A.instance then return A.instance end
 local player=Players.LocalPlayer
 local remotes=game.ReplicatedStorage.MagnetWorkshop.Remotes
 local request=remotes:WaitForChild('AdminRequest',20);local response=remotes:WaitForChild('AdminResponse',20)
 if not request or not response then return end
 local pg=player:WaitForChild('PlayerGui');local old=pg:FindFirstChild('MagnetAdminUI');if old then old:Destroy() end
 local screen=nil;local modal=nil;local content=nil;local nav=nil;local status=nil;local search=nil
 local view=nil;local seq=0;local group='profile';local draft={};local pending=nil;local confirmation=nil;local selector=nil
 local api={};local applyButtons={};local tabButtons={};local draw,close,open;local pendingAt=0
 local function active() return modal~=nil end
 local function describe() request:FireServer({mode='Describe'}) end
 local function setStatus(value,error)
  if status then status.Text=value;status.TextColor3=error and Color3.fromRGB(160,61,49) or T.ink end
 end
 local function pendingControls()
  for _,b in applyButtons do if b.Parent then T.enabled(b,not pending and b:GetAttribute('HasValues')~=false) end end
 end
 local function destroyOverlay()
  if selector then selector:Destroy();selector=nil end
  if confirmation then confirmation:Destroy();confirmation=nil end
 end
 local function offerRetry(payload)
  if pending==payload and active() and not modal:FindFirstChild('Retry') then
   setStatus('Ответ ещё не получен. Можно повторить тот же запрос.')
   local retry=T.button(modal,'Retry','Повторить запрос',U(150,30),UDim2.new(1,-166,1,-34),function() if pending==payload then request:FireServer(payload) end end)
   retry.ZIndex=25
  end
 end
 close=function()
  destroyOverlay();if modal then modal:Destroy();modal=nil end
  if o.changed then o.changed(false) end
 end
 local function send(command,args,token)
  if pending or not view then return end
  seq=math.max(seq,view.lastSeq or 0)+1
  local payload={mode='Execute',nonce=view.nonce,seq=seq,commandId=command,args=args,confirmation=token}
  pending=payload;pendingAt=os.clock();setStatus('Сервер выполняет команду…');pendingControls();request:FireServer(payload)
  task.delay(15,function() offerRetry(payload) end)
 end
 local function textbox(parent,name,placeholder,size,pos)
  local b=T.make('TextBox',parent,name,{Size=size,Position=pos,Text='',PlaceholderText=placeholder,ClearTextOnFocus=false,TextColor3=T.ink,PlaceholderColor3=T.muted,Font=Enum.Font.GothamMedium,TextSize=15,BackgroundColor3=Color3.fromRGB(255,249,233),TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0})
  T.surface(b);T.make('UIPadding',b,'Padding',{PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,8)}) return b
 end
 local function overlay(name,title)
  destroyOverlay()
  local shade=T.make('Frame',modal,name,{Size=UDim2.fromScale(1,1),BackgroundColor3=T.ink,BackgroundTransparency=.25,BorderSizePixel=0,Active=true,ZIndex=20})
  local panel=T.frame(shade,'Panel',UDim2.new(1,-28,1,-30),U(14,15));panel.ZIndex=21
  T.label(panel,'Title',title,UDim2.new(1,-76,0,44),U(14,0),18,true).ZIndex=22
  local x=T.button(panel,'Close','×',U(38,36),UDim2.new(1,-48,0,5),destroyOverlay);x.TextSize=25;x.ZIndex=22
  return shade,panel
 end
 local function choose(field,value,changed)
  local shade,panel=overlay('Selector',field.label);selector=shade
  local input=textbox(panel,'Search','Поиск по названию или ID',UDim2.new(1,-24,0,36),U(12,48));input.ZIndex=22
  local list=T.scroll(panel,'Options',UDim2.new(1,-24,1,-100),U(12,92));list.ZIndex=22;T.list(list,5)
  local function filter()
   for _,p in list:GetChildren() do if p:IsA('GuiObject') then p:Destroy() end end
   local needle=string.lower(input.Text)
   for i,entry in field.options do if needle=='' or string.find(string.lower(entry.label),needle,1,true) then
    local b=T.button(list,'Option'..i,entry.label,UDim2.new(1,-6,0,44),nil,function() changed(entry.value,entry.label);destroyOverlay() end)
    b.ZIndex=23;b.LayoutOrder=i;b.TextSize=14;b.BackgroundColor3=entry.value==value and T.teal or T.ink
   end end
  end
  input:GetPropertyChangedSignal('Text'):Connect(filter);filter()
 end
 local function showConfirmation(result)
  local shade,panel=overlay('Confirmation','Подтверждение');confirmation=shade
  local body=T.scroll(panel,'Review',UDim2.new(1,-28,1,-116),U(14,46));body.ZIndex=22;T.list(body,8)
  T.label(body,'Scope',result.title,UDim2.new(1,-4,0,40),nil,20,true).ZIndex=23
  local who=T.label(body,'Target','Профиль: '..view.playerName,UDim2.new(1,-4,0,32),nil,15,true);who.ZIndex=23
  local summary=T.label(body,'Parameters',result.summary,UDim2.new(1,-4,0,54),nil,15,false);summary.ZIndex=23
  T.label(body,'Warning',result.detail or 'Действие изменит выбранную часть вашего прогресса.',UDim2.new(1,-4,0,96),nil,14,true,Color3.fromRGB(155,69,47)).ZIndex=23
  local yes=T.button(panel,'Confirm','Подтвердить',UDim2.new(.5,-20,0,44),UDim2.new(0,14,1,-56),function() destroyOverlay();send(result.commandId,result.args,result.token) end);yes.BackgroundColor3=Color3.fromRGB(160,73,52);yes.ZIndex=23
  local no=T.button(panel,'Cancel','Отмена',UDim2.new(.5,-20,0,44),UDim2.new(.5,6,1,-56),destroyOverlay);no.ZIndex=23
 end
 draw=function()
  if not modal or not view then return end
  for _,p in content:GetChildren() do if p:IsA('GuiObject') then p:Destroy() end end
  applyButtons={};content.CanvasPosition=Vector2.zero
  for id,b in tabButtons do b.BackgroundColor3=id==group and T.teal or T.ink end
  if group=='audit' then
   for i=#view.audit,1,-1 do local e=view.audit[i]
    local card=T.frame(content,'Audit'..i,UDim2.new(1,-8,0,90));card.LayoutOrder=#view.audit-i
    T.label(card,'Title',os.date('%H:%M:%S',e.time)..'  '..e.title,UDim2.new(1,-24,0,32),U(12,4),16,true)
    T.label(card,'Result',e.ok and 'Выполнено для своего профиля' or 'Не выполнено: '..tostring(e.code),UDim2.new(1,-24,0,44),U(12,36),14,false,e.ok and T.teal or Color3.fromRGB(160,61,49))
   end
   if #view.audit==0 then T.label(content,'Empty','Здесь появятся результаты ваших команд.',UDim2.new(1,-8,0,70),nil,16,false) end
   return
  end
  local needle=string.lower(search.Text);local found=0
  for index,c in view.commands do if c.group==group and (needle=='' or string.find(string.lower(c.title..' '..c.detail),needle,1,true)) then
   found+=1
   local values=draft[c.id] or {};draft[c.id]=values
   local card=T.frame(content,c.id,UDim2.new(1,-8,0,126+#c.fields*48));card.LayoutOrder=index
   T.label(card,'Title',c.title,UDim2.new(1,-24,0,24),U(12,4),18,true)
   T.label(card,'Current',c.current or '',UDim2.new(1,-24,0,18),U(12,30),13,true,T.teal)
   T.label(card,'Description',c.detail,UDim2.new(1,-24,0,30),U(12,50),13,false)
   local ready=true
   for n,field in c.fields do
    local y=82+(n-1)*48
    T.label(card,field.id..'Label',field.label,UDim2.new(1,-24,0,16),U(12,y),12,true)
    if values[field.id]==nil then values[field.id]=field.default end
    if field.type=='integer' then
     local input=textbox(card,field.id,tostring(field.min)..'–'..tostring(field.max),UDim2.new(1,-24,0,30),U(12,y+17));input.Text=tostring(values[field.id] or field.default)
     input:GetPropertyChangedSignal('Text'):Connect(function() values[field.id]=tonumber(input.Text) end)
    else
     local label=nil;for _,entry in field.options do if entry.value==values[field.id] then label=entry.label break end end
     if not label then values[field.id]=field.options[1] and field.options[1].value;label=field.options[1] and field.options[1].label end
     if values[field.id]==nil then ready=false end
     local b
     b=T.button(card,field.id,label or 'Нет подходящих вариантов',UDim2.new(1,-24,0,30),U(12,y+17),function() choose(field,values[field.id],function(v,text) values[field.id]=v;b.Text=text end) end,label~=nil)
     b.TextSize=14
    end
   end
   local apply=T.button(card,'Apply',c.id=='biome.travel' and 'Перейти' or c.confirm and 'Продолжить…' or 'Применить',UDim2.new(1,-24,0,32),UDim2.new(0,12,1,-38),function()
    local args={};for _,f in c.fields do if values[f.id]==nil then setStatus('Заполните поле «'..f.label..'».',true);return end args[f.id]=values[f.id] end send(c.id,args)
   end,ready and not pending)
   apply:SetAttribute('HasValues',ready);table.insert(applyButtons,apply)
  end end
  if found==0 then T.label(content,'Empty','Ничего не найдено.',UDim2.new(1,-8,0,50),nil,16,false) end
 end
 open=function()
  if modal then close();return end
  if not screen or not view or o.canOpen and not o.canOpen() then return end
  if o.changed then o.changed(true) end
  local body;modal,body=T.window(screen,'Админ-панель','admin',close)
  modal.Bounds.MaxSize=Vector2.new(900,700);modal.Size=UDim2.new(1,-20,1,-16);modal.Position=UDim2.fromScale(.5,.5)
  body:Destroy()
  local shadow=screen:FindFirstChild('WindowShadow');if shadow then shadow.Bounds.MaxSize=Vector2.new(900,700);shadow.Size=modal.Size;shadow.Position=modal.Position+U(0,4) end
  local title=modal.Heading;title.TextSize=20;title.Size=UDim2.new(1,-88,0,42)
  local badge=T.label(modal,'Profile',view.playerName..(view.sandbox and ' · тестовый профиль Studio' or ' · сохранение прогресса'),UDim2.new(1,-32,0,18),U(16,44),12,true,T.teal)
  nav=T.make('ScrollingFrame',modal,'Sections',{BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y})
  T.list(nav,7);tabButtons={}
  for i,g in view.groups do local b=T.button(nav,g.id,g.label,UDim2.new(1,-4,0,36),nil,function() group=g.id;destroyOverlay();draw() end);b.LayoutOrder=i;b.TextSize=14;tabButtons[g.id]=b end
  search=textbox(modal,'SearchCommands','Поиск команды',UDim2.new(),UDim2.new())
  content=T.scroll(modal,'Commands',UDim2.new(),UDim2.new());T.list(content,12)
  status=T.label(modal,'Status',pending and 'Сервер выполняет команду…' or 'Команды действуют только на ваш профиль.',UDim2.new(1,-32,0,30),UDim2.new(0,16,1,-34),12,false)
  local function layout()
   if not modal then return end
   local w=modal.AbsoluteSize.X;local side=w<600 and 112 or 148
   nav.Position=U(12,68);nav.Size=U(side,math.max(80,modal.AbsoluteSize.Y-112))
   search.Position=U(side+24,68);search.Size=UDim2.new(1,-side-40,0,30)
   content.Position=U(side+24,106);content.Size=UDim2.new(1,-side-36,1,-142)
  end
  modal:GetPropertyChangedSignal('AbsoluteSize'):Connect(layout);layout()
  search:GetPropertyChangedSignal('Text'):Connect(draw);draw();describe()
  if pending then local payload=pending;task.delay(math.max(0,15-(os.clock()-pendingAt)),function() offerRetry(payload) end) end
 end
 local function ensureScreen()
  if screen then return end
  screen=T.make('ScreenGui',pg,'MagnetAdminUI',{ResetOnSpawn=false,DisplayOrder=40,ScreenInsets=Enum.ScreenInsets.CoreUISafeInsets,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
  local toggle=T.button(screen,'Toggle','Админ · F4',U(112,30),U(12,50),open);toggle.TextSize=13
  local connection;connection=RunService.Heartbeat:Connect(function()
   if not toggle.Parent then connection:Disconnect();return end
   toggle.Visible=not active() and (not o.available or o.available())
  end)
 end
 response.OnClientEvent:Connect(function(result)
  if result.kind=='Denied' then close();if screen then screen:Destroy();screen=nil end;view=nil;pending=nil;return end
  if result.kind=='Loading' then task.delay(1,describe);return end
  if result.kind=='Describe' and result.ok then view=result;seq=math.max(seq,result.lastSeq or 0);ensureScreen();if modal and not pending then draw() end;return end
  if result.kind=='Error' then
   setStatus(result.message or 'Панель недоступна.',true)
   if pending then local payload=pending;if result.code=='rate' then task.delay(1,function() if pending==payload then request:FireServer(payload) end end) else pending=nil;pendingControls();describe() end end
   return
  end
  if result.kind~='Result' or not pending or result.seq~=pending.seq then return end
  if result.status=='Pending' then setStatus(result.message);return end
  pending=nil;if modal then local retry=modal:FindFirstChild('Retry');if retry then retry:Destroy() end end
  if result.view then view=result.view end
  if modal then draw();setStatus(result.message,result.status=='Error');if result.status=='Confirm' then showConfirmation(result) end end
  pendingControls()
 end)
 UIS.InputBegan:Connect(function(input,processed)
  if UIS:GetFocusedTextBox() then return end
  if input.KeyCode==Enum.KeyCode.F4 and not processed then open()
  elseif input.KeyCode==Enum.KeyCode.Escape and active() then if selector or confirmation then destroyOverlay() else close() end end
 end)
 player.CharacterAdded:Connect(function() close() end)
 function api.isOpen() return active() end
 function api.close() close() end
 A.instance=api;describe();return api
end
return A
