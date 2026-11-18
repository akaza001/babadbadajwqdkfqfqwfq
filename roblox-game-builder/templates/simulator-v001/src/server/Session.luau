-- RAM-only adapter, explicit v0.0.1 scope. No DataStore/rejoin durability claim.
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
