-- Generated offline installer. Run in Studio Command Bar in EDIT, on a blank test place.
assert(not game:GetService('RunService'):IsRunning(),'Stop Play before installing')
local packageId=[[6e149dbc94713b9dbf6cbe13ebd598fee46b29a9900a770450b16302fdf51dad]]
local specs={{area=[[client]],name=[[Main]],class=[[LocalScript]],source=[[local Players=game:GetService('Players')
local shared=game:GetService('ReplicatedStorage'):WaitForChild('SimulatorTemplate')
local T=require(shared.WindowTheme)
local remote=shared.Request
local gui=Instance.new('ScreenGui') gui.Name='SimulatorTemplate' gui.ResetOnSpawn=false gui.Parent=Players.LocalPlayer:WaitForChild('PlayerGui')
local root=T.make('ScrollingFrame',gui,'Root',{Size=UDim2.new(1,-24,0.65,0),Position=UDim2.new(0,12,0.1,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),BackgroundColor3=T.paper,BorderSizePixel=0,ScrollBarThickness=4})
T.make('UISizeConstraint',root,'Bounds',{MaxSize=Vector2.new(420,700)}) T.list(root,8)
local function label(text) return T.label(root,'Status',text,UDim2.new(1,-12,0,56),nil,15) end
label('Шаблон 0.0.1 · данные только до выхода!')
local status=label('Подключение…')
local seq=0 local pending=false local profile local description
local function show()
 if not profile then return end
 local n=0 for _,amount in pairs(profile.items) do n=n+amount end
 status.Text=description.currency..': '..profile.coins..' · уровень '..profile.level..' · предметов '..n..'/'..description.capacity
end
local function request(action,args)
 if pending then return end pending=true seq=seq+1
 local ok,result=pcall(function() return remote:InvokeServer({seq=seq,action=action,args=args or {}}) end)
 pending=false
 if ok and result then
  if result.profile then profile=result.profile end show()
  if not result.ok then status.Text=status.Text..'\n'..tostring(result.error) end
 else status.Text='Нет ответа. Обновите состояние перед следующим действием.' end
end
local function button(text,callback) T.button(root,'Action',text,UDim2.new(1,-12,0,48),nil,callback,true,true) end
local ok,result=pcall(function() return remote:InvokeServer({action='describe'}) end)
if not ok or not result or not result.ok then status.Text='Сервер недоступен' return end
profile=result.profile description=result.description show()
button('Собрать находку',function() request('collect') end)
button('Продать всё',function() request('sell') end)
button('Купить следующий уровень',function() request('upgrade') end)
-- Dynamic admin forms from server-authorized command and item catalogs.
local function input(default)
 return T.make('TextBox',root,'Value',{Text=default,Size=UDim2.new(1,-12,0,48),ClearTextOnFocus=false,TextSize=16,BackgroundColor3=T.card,TextColor3=T.ink})
end
local resetArmed=false
for _,action in ipairs(description.admin) do
 label('Админ · '..action)
 if action=='item.grant' then
  for id,item in pairs(description.items) do
   local amount=input('1')
   button('Выдать '..item.name,function() request(action,{id=id,amount=tonumber(amount.Text)}) end)
  end
 elseif action=='progress.reset' then
  button('Сбросить мой прогресс',function() resetArmed=true status.Text='Для сброса нажмите Подтвердить.' end)
  button('Подтвердить сброс',function() if resetArmed then resetArmed=false request(action,{confirm=true}) end end)
 else
  local value=input('0')
  button('Применить '..action,function() request(action,{value=tonumber(value.Text)}) end)
 end
end
]]},
{area=[[server]],name=[[AdminConfig]],class=[[ModuleScript]],source=[[return {userIds={}} -- Server-only, deny all until verified developer UserIds are configured.
]]},
{area=[[server]],name=[[Bootstrap]],class=[[Script]],source=[[local Players=game:GetService('Players')
local shared=game:GetService('ReplicatedStorage'):WaitForChild('SimulatorTemplate')
local config=require(shared.Config)
local core=require(script.Parent.Core).new(config,require(script.Parent.AdminConfig))
local sessions=require(script.Parent.Session).new(core,os.clock)
local remote=shared:WaitForChild('Request')
local initialized={}
local function join(p) if not initialized[p.UserId] then initialized[p.UserId]=true sessions.open(p.UserId) end end
Players.PlayerAdded:Connect(join)
Players.PlayerRemoving:Connect(function(p) initialized[p.UserId]=nil sessions.close(p.UserId) end)
for _,p in ipairs(Players:GetPlayers()) do join(p) end
remote.OnServerInvoke=function(player,payload)
 if type(payload)~='table' then return {ok=false,error='invalid_request'} end
 for k in pairs(payload) do if k~='seq' and k~='action' and k~='args' then return {ok=false,error='unknown_field'} end end
 if payload.action=='describe' then return {ok=true,description=core.describe(player.UserId),profile=sessions.view(player.UserId),storage='RAM_ONLY'} end
 if type(payload.action)~='string' or #payload.action>64 or type(payload.args)~='table' then return {ok=false,error='invalid_request'} end
 local count=0
 for k,v in pairs(payload.args) do
  count=count+1
  if count>4 or type(k)~='string' or #k>32 or (type(v)~='string' and type(v)~='number' and type(v)~='boolean') or (type(v)=='string' and #v>64) then return {ok=false,error='invalid_args'} end
 end
 return sessions.request(player.UserId,payload.seq,payload.action,payload.args)
end
]]},
{area=[[server]],name=[[Core]],class=[[ModuleScript]],source=[[-- Pure Lua subset: independent of Roblox services and any originating game's hierarchy.
local Core={}
local function integer(n,lo,hi)
 return type(n)=='number' and n==n and n~=math.huge and n~=-math.huge and n%1==0 and n>=lo and n<=hi
end
local function copy(v)
 if type(v)~='table' then return v end
 local t={} for k,x in pairs(v) do t[k]=copy(x) end return t
end
function Core.new(config,admin)
 assert(type(config.items)=='table' and config.items[config.collectItem],'collect item missing')
 assert(integer(config.capacity,1,10000) and integer(config.coinsCap,1,1000000000),'invalid limits')
 assert(config.schema==1 and config.upgrades[1] and config.upgrades[1].cost==0,'unsupported schema or upgrades')
 for id,item in pairs(config.items) do assert(type(id)=='string' and type(item.name)=='string' and integer(item.sell,0,config.coinsCap),'invalid item') end
 for _,u in ipairs(config.upgrades) do assert(integer(u.cost,0,config.coinsCap) and integer(u.yield,1,config.capacity),'invalid upgrade') end
 local api={}
 function api.defaults() return {schema=config.schema,coins=0,level=1,items={}} end
 function api.validate(p)
  if type(p)~='table' or p.schema~=config.schema or not integer(p.coins,0,config.coinsCap) or not integer(p.level,1,#config.upgrades) or type(p.items)~='table' then return false end
  local total=0
  for id,n in pairs(p.items) do if not config.items[id] or not integer(n,1,config.capacity) then return false end total=total+n end
  return total<=config.capacity
 end
 function api.migrate(p)
  if p==nil then return api.defaults() end
  if not api.validate(p) then return nil,'invalid_or_unsupported_profile' end
  return copy(p)
 end
 function api.describe(userId)
  local result={currency=config.currencyName,items=copy(config.items),upgrades=copy(config.upgrades),capacity=config.capacity,admin={}}
  if admin.userIds[userId]==true then result.admin={'coins.set','level.set','item.grant','progress.reset'} end
  return result
 end
 -- No arbitrary field setter: new editable systems must register a bounded handler.
 function api.apply(profile,userId,action,args)
  if not api.validate(profile) then return nil,'invalid_profile' end
  if type(args)~='table' or type(action)~='string' then return nil,'invalid_request' end
  local allowed={}
  if action=='item.grant' then allowed={id=true,amount=true}
  elseif action=='coins.set' or action=='level.set' then allowed={value=true}
  elseif action=='progress.reset' then allowed={confirm=true} end
  for k in pairs(args) do if not allowed[k] then return nil,'unknown_field' end end
  local p=copy(profile)
  if action=='collect' then
   local total=0 for _,n in pairs(p.items) do total=total+n end
   local count=config.upgrades[p.level].yield
   if total+count>config.capacity then return nil,'capacity' end
   p.items[config.collectItem]=(p.items[config.collectItem] or 0)+count
  elseif action=='sell' then
   local amount=0 for id,n in pairs(p.items) do amount=amount+config.items[id].sell*n end
   if p.coins+amount>config.coinsCap then return nil,'coins_cap' end
   p.coins=p.coins+amount p.items={}
  elseif action=='upgrade' then
   local upgrade=config.upgrades[p.level+1]
   if not upgrade then return nil,'max_level' end
   if p.coins<upgrade.cost then return nil,'insufficient_coins' end
   p.coins=p.coins-upgrade.cost p.level=p.level+1
  elseif action=='coins.set' or action=='level.set' or action=='item.grant' or action=='progress.reset' then
   if admin.userIds[userId]~=true then return nil,'forbidden' end
   if action=='coins.set' then
    if not integer(args.value,0,config.coinsCap) then return nil,'invalid_value' end p.coins=args.value
   elseif action=='level.set' then
    if not integer(args.value,1,#config.upgrades) then return nil,'invalid_value' end p.level=args.value
   elseif action=='item.grant' then
    if not config.items[args.id] or not integer(args.amount,1,config.capacity) then return nil,'invalid_item' end
    p.items[args.id]=(p.items[args.id] or 0)+args.amount
   else
    if args.confirm~=true then return nil,'confirmation_required' end p=api.defaults()
   end
  else return nil,'unknown_action' end
  if not api.validate(p) then return nil,'invalid_result' end
  return p
 end
 api.copy=copy
 return api
end
return Core
]]},
{area=[[server]],name=[[Session]],class=[[ModuleScript]],source=[[-- RAM-only adapter, explicit v0.0.1 scope. No DataStore/rejoin durability claim.
local Session={}
function Session.new(core,clock)
 local sessions={};local api={}
 function api.open(id) sessions[id]={profile=core.defaults(),last=0,cache={},order={},lastAt=-math.huge} end
 function api.close(id) sessions[id]=nil end
 function api.view(id) local s=sessions[id] return s and core.copy(s.profile) end
 function api.request(id,seq,action,args)
  local s=sessions[id]
  if not s then return {ok=false,error='not_loaded'} end
  if type(seq)~='number' or seq~=seq or seq%1~=0 or seq<1 or seq>2147483647 then return {ok=false,error='invalid_sequence'} end
  if s.cache[seq] then return core.copy(s.cache[seq]) end
  if seq<=s.last then return {ok=false,error='stale_sequence'} end
  -- Bounded payload is checked by transport; core validates fields.
  local now=clock()
  if now-s.lastAt<0.25 then return {ok=false,error='rate_limited'} end
  s.lastAt=now;s.last=seq
  local nextProfile,err=core.apply(s.profile,id,action,args)
  if nextProfile then s.profile=nextProfile end
  local result={ok=nextProfile~=nil,error=err,profile=core.copy(s.profile)}
  s.cache[seq]=result;table.insert(s.order,seq)
  if #s.order>32 then s.cache[table.remove(s.order,1)]=nil end
  return core.copy(result)
 end
 return api
end
return Session
]]},
{area=[[shared]],name=[[Config]],class=[[ModuleScript]],source=[[-- Example balance only; replace for each game. No player data or production permissions.
return {
 version=1, schema=1, capacity=24, coinsCap=1000000,
 currencyName='Монеты', items={scrap={name='Находка',sell=5}},
 collectItem='scrap', upgrades={{cost=0,yield=1},{cost=20,yield=2},{cost=60,yield=3}},
}
]]},
{area=[[shared]],name=[[HudIcons]],class=[[ModuleScript]],source=[[-- User-approved PNGs, imported through Studio. Original files: art/ui/icons-v01.
return {
 inventory='rbxassetid://137153344479149',
 collection='rbxassetid://101727583476324',
 shop='rbxassetid://129619445443782',
 upgrades='rbxassetid://83057198886926',
 sell='rbxassetid://75111299025637',
 settings='rbxassetid://112448704970803',
}
]]},
{area=[[shared]],name=[[WindowTheme]],class=[[ModuleScript]],source=[[-- Native, scalable surfaces from the approved window references; no baked text.
local T={version='0.4.5',paper=Color3.fromRGB(247,238,218),card=Color3.fromRGB(249,239,218),ink=Color3.fromRGB(45,70,75),teal=Color3.fromRGB(35,150,156),tan=Color3.fromRGB(195,163,120),green=Color3.fromRGB(192,222,167),muted=Color3.fromRGB(113,116,110),amber=Color3.fromRGB(250,216,145)}
local Icons=require(script.Parent.HudIcons)
function T.make(class,parent,name,props)
 local v=Instance.new(class) v.Name=name for k,x in props or {} do v[k]=x end v.Parent=parent return v
end
function T.surface(v,kind)
 v.BorderSizePixel=0
 T.make('UICorner',v,'Round',{CornerRadius=UDim.new(0,kind=='window' and 18 or 12)})
 T.make('UIStroke',v,'Edge',{Color=T.tan,Thickness=kind=='window' and 2 or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Transparency=.16})
 T.make('UIGradient',v,'Finish',{Rotation=90,Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(239,222,193))})
 T.make('Frame',v,'Sheen',{Size=UDim2.new(1,-20,0,1),Position=UDim2.fromOffset(10,2),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=.38,BorderSizePixel=0})
 return v
end
function T.frame(parent,name,size,pos)
 return T.surface(T.make('Frame',parent,name,{Size=size,Position=pos or UDim2.new(),BackgroundColor3=T.card}))
end
function T.label(parent,name,value,size,pos,fontSize,bold,color)
 return T.make('TextLabel',parent,name,{Text=value,Size=size,Position=pos or UDim2.new(),BackgroundTransparency=1,TextColor3=color or T.ink,Font=bold and Enum.Font.GothamBold or Enum.Font.GothamMedium,TextSize=fontSize or 16,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left})
end
function T.button(parent,name,value,size,pos,callback,available,server)
 local b=T.make('TextButton',parent,name,{Text=value,Size=size,Position=pos or UDim2.new(),BackgroundColor3=available==false and Color3.fromRGB(167,172,169) or T.teal,TextColor3=available==false and T.ink or Color3.fromRGB(255,251,240),Font=Enum.Font.GothamBold,TextSize=15,TextWrapped=true,BorderSizePixel=0,AutoButtonColor=true,Interactable=available~=false})
 T.surface(b,'button') b:SetAttribute('ActionAvailable',available~=false) if server then b:SetAttribute('ServerAction',true) end
 if callback then b.Activated:Connect(function() if b:GetAttribute('ActionAvailable')~=false then callback() end end) end
 return b
end
function T.enabled(b,available)
 b:SetAttribute('ActionAvailable',available) b.Interactable=available b.BackgroundColor3=available and T.teal or Color3.fromRGB(167,172,169)
end
function T.list(parent,gap)
 return T.make('UIListLayout',parent,'Layout',{Padding=UDim.new(0,gap or 8),SortOrder=Enum.SortOrder.LayoutOrder})
end
function T.scroll(parent,name,size,pos)
 return T.make('ScrollingFrame',parent,name,{Size=size,Position=pos or UDim2.new(),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,ScrollBarImageColor3=T.teal,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ClipsDescendants=true})
end
function T.window(parent,title,page,close)
 local shade=T.make('Frame',parent,'WindowShade',{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(32,44,43),BackgroundTransparency=.8,BorderSizePixel=0,ZIndex=4,Active=true})
 local modal=T.surface(T.make('Frame',parent,'Modal',{Size=UDim2.new(1,-28,1,-72),Position=UDim2.fromScale(.5,.52),AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=T.paper,ZIndex=5}),'window')
 T.make('UISizeConstraint',modal,'Bounds',{MaxSize=Vector2.new(1120,740),MinSize=Vector2.new(280,190)}) modal:SetAttribute('Page',page)
 local shadow=T.make('Frame',parent,'WindowShadow',{Size=modal.Size,Position=modal.Position+UDim2.fromOffset(0,4),AnchorPoint=modal.AnchorPoint,BackgroundColor3=Color3.fromRGB(72,54,31),BackgroundTransparency=.6,BorderSizePixel=0,ZIndex=4})
 T.make('UICorner',shadow,'Round',{CornerRadius=UDim.new(0,18)}) T.make('UISizeConstraint',shadow,'Bounds',{MaxSize=Vector2.new(1120,740),MinSize=Vector2.new(280,190)})
 modal.Destroying:Connect(function() if shade.Parent then shade:Destroy() end if shadow.Parent then shadow:Destroy() end end)
 local key=({inventory='inventory',find='inventory',journal='collection',shop='shop',upgrades='upgrades',sell='sell',settings='settings'})[page]
 if key then T.make('ImageLabel',modal,'PageIcon',{Image=Icons[key],BackgroundTransparency=1,Position=UDim2.fromOffset(12,6),Size=UDim2.fromOffset(44,44),ScaleType=Enum.ScaleType.Fit}) end
 T.label(modal,'Heading',title,UDim2.new(1,key and -122 or -88,0,52),UDim2.fromOffset(key and 64 or 16,0),22,true)
 local closeButton=T.button(modal,'Close','×',UDim2.fromOffset(44,44),UDim2.new(1,-54,0,6),close) closeButton.TextSize=28
 local body=T.scroll(modal,'Body',UDim2.new(1,-24,1,-70),UDim2.fromOffset(12,60))
 return modal,body
end
return T
]]}}
local roots={shared=game:GetService('ReplicatedStorage'),server=game:GetService('ServerScriptService'),client=game:GetService('StarterPlayer'):WaitForChild('StarterPlayerScripts')}
local existing=0
for _,parent in pairs(roots) do if parent:FindFirstChild('SimulatorTemplate') then existing=existing+1 end end
if existing>0 then
 assert(existing==3,'Partial/existing installation: refusing to overwrite')
 for _,spec in ipairs(specs) do
  local root=roots[spec.area]:FindFirstChild('SimulatorTemplate')
  assert(root:GetAttribute('PackageId')==packageId,'Existing template differs; install in another test place')
  local obj=root:FindFirstChild(spec.name)
  assert(obj and obj.ClassName==spec.class and obj.Source==spec.source,'Existing source changed; refusing to overwrite')
 end
 print('Simulator template already installed; no changes') return
end
local staged={}
local ok,err=pcall(function()
 for area in pairs(roots) do
  local folder=Instance.new('Folder') folder.Name='SimulatorTemplate' folder:SetAttribute('PackageId',packageId) staged[area]=folder
 end
 for _,spec in ipairs(specs) do
  local obj=Instance.new(spec.class)
  if spec.class~='ModuleScript' then obj.Disabled=true end
  obj.Name=spec.name obj.Source=spec.source obj.Parent=staged[spec.area]
 end
 local remote=Instance.new('RemoteFunction') remote.Name='Request' remote.Parent=staged.shared
 -- All code is staged before any root is attached; runtime scripts remain disabled until commit.
 for area,parent in pairs(roots) do staged[area].Parent=parent end
 for _,folder in pairs(staged) do for _,obj in ipairs(folder:GetChildren()) do
  if obj:IsA('Script') or obj:IsA('LocalScript') then obj.Disabled=false end
 end end
end)
if not ok then for _,folder in pairs(staged) do folder:Destroy() end error('Install rolled back: '..tostring(err)) end
print('Simulator template installed. RAM ONLY. Configure server AdminConfig; press Play for the UI prototype.')
