local Players=game:GetService('Players')
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
