-- Server authority, a schema-driven registry, monotonic request IDs and durable profile writes.
local Http=game:GetService('HttpService')
local Players=game:GetService('Players')
local Registry=require(script.Parent.AdminRegistry)
local Store=require(script.Parent.ProfileStore)
local Access=require(script.Parent.AdminConfig)
local Shared=game.ReplicatedStorage.MagnetWorkshop.Shared
local A={version='0.5.6'}
local messages={errBusy='Профиль занят. Дождитесь завершения сохранения или перехода.',errProfile='Сохранение не подтвердилось. Проверьте соединение и повторите запрос.',errInventory='В рюкзаке недостаточно свободных мест.',errCoinsRange='Количество выходит за допустимый баланс монет.',errFind='Эта находка уже недоступна.',errStale='Данные изменились. Обновите панель.',errTarget='Проверьте выбранные значения.',errCharacter='Персонаж пока недоступен.'}
local function finite(n) return type(n)=='number' and n==n and math.abs(n)<math.huge end
local function integer(n,min,max) return finite(n) and n%1==0 and n>=min and n<=max end
local function count(t) local n=0 for _ in t do n+=1 end return n end
function A.new(G,options)
 options=options or {}
 local store=options.store or Store
 local self={states={},rates={},audit={},access=options.userIds or Access.userIds,game=G,store=store}
 self.registry=options.registry or Registry.new({config=require(Shared.Config),biomes=require(Shared.BiomeCatalog),store=store,game=G})
 self.emit=options.emit or function() end
 function self:allowed(player) return self.access[player.UserId]==true end
 function self:limited(player)
  local now=os.clock();local bucket=self.rates[player] or {tokens=8,time=now};self.rates[player]=bucket
  bucket.tokens=math.min(8,bucket.tokens+(now-bucket.time)*3);bucket.time=now
  if bucket.tokens<1 then return true end bucket.tokens-=1 return false
 end
 function self:state(player,s)
  local a=self.states[player]
  if not a or a.session~=s then a={session=s,nonce=Http:GenerateGUID(false),lastSeq=0,results={},order={}};self.states[player]=a end return a
 end
 function self:describe(player,s,a)
  local commands={}
  for _,c in self.registry:build(s) do table.insert(commands,{id=c.id,group=c.group,title=c.title,detail=c.detail,current=c.current,fields=c.fields,confirm=c.confirm==true}) end
  local recent={} for i=math.max(1,#self.audit-19),#self.audit do table.insert(recent,store.clone(self.audit[i])) end
  return {kind='Describe',ok=true,nonce=a.nonce,lastSeq=a.lastSeq,groups=Registry.groups,commands=commands,audit=recent,
   playerName=player.DisplayName or player.Name,sandbox=store.sandbox,revision=s.data.revision,
   summary={coins=s.data.coins,toolLevel=s.data.toolLevel,inventory=count(s.data.finds),discovered=count(s.data.discovered)}}
 end
 function self:record(player,c,args,success,code)
  table.insert(self.audit,{time=os.time(),actor=player.UserId,target=player.UserId,command=c.id,title=c.title,args=store.clone(args),ok=success,code=code})
  while #self.audit>60 do table.remove(self.audit,1) end
 end
 local function validate(c,args,shapeOnly)
  if type(args)~='table' then return nil end
  local fields={};for _,f in c.fields do fields[f.id]=f end
  local n=0;for key in args do n+=1;if not fields[key] or n>8 then return nil end end
  local normalized,signature,summary={},{},{}
  for _,f in c.fields do
   local v=args[f.id];if v==nil then return nil end
   local label
   if f.type=='integer' then if not integer(v,f.min,f.max) then return nil end label=tostring(v)
   elseif f.type=='enum' then
    if type(v)~='string' and type(v)~='boolean' and not finite(v) or type(v)=='string' and #v>64 then return nil end
    if shapeOnly then label=tostring(v) else for _,o in f.options do if v==o.value then label=o.label break end end end
    if not label then return nil end
   else return nil end
   normalized[f.id]=v;table.insert(signature,{f.id,v});table.insert(summary,f.label..': '..label)
  end
  return normalized,c.id..':'..Http:JSONEncode(signature),table.concat(summary,'\n')
 end
 function self:handle(player,payload)
  if self:limited(player) then return {kind='Error',ok=false,code='rate',message='Слишком часто. Подождите секунду.'} end
  if not self:allowed(player) then return {kind='Denied',ok=false} end
  if type(payload)~='table' then return {kind='Error',ok=false,code='invalid'} end
  local keys={mode=true,nonce=true,seq=true,commandId=true,args=true,confirmation=true}
  local fields=0;for key in payload do fields+=1;if not keys[key] or fields>6 then return {kind='Error',ok=false,code='invalid',message='Неверный запрос.'} end end
  local s=store.sessions[player]
  if not s or not s.data or s.closing or s.lost then return {kind='Loading',ok=false} end
  local a=self:state(player,s)
  if payload.mode=='Describe' then return self:describe(player,s,a) end
  if payload.mode~='Execute' or payload.nonce~=a.nonce or not integer(payload.seq,1,2^31) or type(payload.commandId)~='string' or #payload.commandId>64 then return {kind='Error',ok=false,code='invalid',message='Запрос устарел. Обновите панель.'} end
  local seq=payload.seq
  local c;for _,v in self.registry:build(s) do if v.id==payload.commandId then c=v break end end
  if not c then return {kind='Result',seq=seq,status='Error',message='Команда недоступна.'} end
  local args,signature,summary=validate(c,payload.args,a.results[seq]~=nil or a.inflight==seq)
  if not args then return {kind='Result',seq=seq,status='Error',message='Неверный ID, число или выбранный вариант.'} end
  local cached=a.results[seq]
  if cached then
   if cached.signature~=signature then return {kind='Result',seq=seq,status='Error',message='Этот номер запроса уже использован.'} end
   return store.clone(cached.response)
  end
  if a.inflight then return {kind='Result',seq=seq,status=seq==a.inflight and signature==a.inflightSignature and 'Pending' or 'Error',message='Сервер сохраняет предыдущую команду.'} end
  if seq<=a.lastSeq then return {kind='Result',seq=seq,status='Error',message='Повтор устаревшего запроса отклонён.'} end
  a.lastSeq=seq
  local function finish(response)
   a.results[seq]={signature=signature,response=store.clone(response)};table.insert(a.order,seq)
   while #a.order>128 do a.results[table.remove(a.order,1)]=nil end
   return response
  end
  if c.confirm then
   local token=a.confirmation
   if payload.confirmation==nil then
    local value=Http:GenerateGUID(false);a.confirmation={value=value,signature=signature,expires=os.clock()+30}
    local detail=type(c.confirmDetail)=='function' and c.confirmDetail(args) or c.confirmDetail
    return finish({kind='Result',seq=seq,status='Confirm',token=value,title=c.title,summary=summary,detail=detail,commandId=c.id,args=args,message='Подтвердите действие для своего профиля.'})
   end
   if type(payload.confirmation)~='string' or not token or token.value~=payload.confirmation or token.signature~=signature or os.clock()>token.expires then
    return finish({kind='Result',seq=seq,status='Error',message='Подтверждение истекло. Выберите действие ещё раз.'})
   end
   a.confirmation=nil
  elseif payload.confirmation~=nil then return finish({kind='Result',seq=seq,status='Error',message='Лишний параметр подтверждения.'}) end
  a.inflight=seq;a.inflightSignature=signature
  self.emit(player,{kind='Result',seq=seq,status='Pending',message='Сервер выполняет команду…'})
  local called,ok,problem=pcall(c.run,args,'admin:'..a.nonce..':'..seq)
  a.inflight=nil;a.inflightSignature=nil
  if not called then warn('[MagnetWorkshop] Admin command failed: '..c.id..' '..tostring(ok));ok=false;problem='errProfile' end
  self:record(player,c,args,ok==true,ok and 'ok' or problem or 'error')
  local response={kind='Result',seq=seq,status=ok and 'Ok' or 'Error',message=ok and (c.id=='biome.travel' and 'Перемещение завершено.' or store.sandbox and 'Применено в тестовом профиле Studio.' or 'Изменения сохранены.') or messages[problem] or 'Команда не выполнена.'}
  if s.data and not s.closing and not s.lost then response.view=self:describe(player,s,a) end
  return finish(response)
 end
 return self
end
function A.start(G)
 if A.instance then return A.instance end
 local remotes=game.ReplicatedStorage.MagnetWorkshop.Remotes
 local function remote(name)
  local r=remotes:FindFirstChild(name);if not r then r=Instance.new('RemoteEvent');r.Name=name;r.Parent=remotes end
  assert(r:IsA('RemoteEvent'),'Wrong admin remote type') return r
 end
 local request,response=remote('AdminRequest'),remote('AdminResponse')
 local service=A.new(G,{emit=function(player,result) if player.Parent then response:FireClient(player,result) end end})
 request.OnServerEvent:Connect(function(player,payload)
  local result=service:handle(player,payload);if player.Parent then response:FireClient(player,result) end
 end)
 Players.PlayerRemoving:Connect(function(player) service.states[player]=nil;service.rates[player]=nil end)
 A.instance=service;return service
end
return A
