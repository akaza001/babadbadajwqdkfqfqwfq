-- Pure Lua subset: independent of Roblox services and any originating game's hierarchy.
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
