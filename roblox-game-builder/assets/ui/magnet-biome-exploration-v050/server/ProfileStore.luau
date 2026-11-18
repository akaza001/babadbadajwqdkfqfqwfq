-- One serialized writer per player. Studio never touches a live DataStore.
local RunService=game:GetService("RunService")
local Http=game:GetService("HttpService")
local Config=require(game.ReplicatedStorage.MagnetWorkshop.Shared.Config)
local Biomes=require(game.ReplicatedStorage.MagnetWorkshop.Shared.BiomeCatalog)
local Store={sessions={}, sandbox=RunService:IsStudio()}
local dataStore
local function clone(t)
    if type(t)~="table" then return t end
    local c={} for k,v in t do c[k]=clone(v) end return c
end
Store.clone=clone
local function default()
    return {schemaVersion=1,revision=0,coins=0,toolLevel=1,expandedDisplay=false,ownedCoinThemes={},selectedTheme="Default",
        finds={},discovered={},tutorialFindsGranted=0,tutorialStep=0,guideEnabled=true,visitedBiomes={['BIO-01']=true},biomeCatches={},settings={music=true,sfx=true,ambience=true,musicVolume=.35,sfxVolume=.85,ambienceVolume=.5},
        firstSeenAt=os.time(),lastSeenAt=os.time(),recentOperations={}}
end
local function integer(n,min,max) return type(n)=="number" and n==n and n%1==0 and n>=min and n<=max end
function Store.validate(p)
    if type(p)~="table" or p.schemaVersion~=1 or not integer(p.revision,0,2^52) or not integer(p.coins,0,Config.coinsCap)
        or not integer(p.toolLevel,1,3) or type(p.finds)~="table" or type(p.discovered)~="table"
        or not integer(p.tutorialFindsGranted,0,2) or type(p.expandedDisplay)~="boolean" then return false end
    local count,slots=0,{}
    for uid,f in p.finds do
        if type(uid)~="string" or #uid>64 or type(f)~="table" or f.uid~=uid or not Config.itemsById[f.itemId]
            or (f.state~="Dirty" and f.state~="Clean") or not integer(f.foundAt,0,2^52)
            or not integer(f.finderUserId,-2^52,2^52) or f.zoneId~=Config.itemsById[f.itemId].zone then return false end
        if f.displaySlot then
            if f.state~="Clean" or not integer(f.displaySlot,1,p.expandedDisplay and 12 or 6) or slots[f.displaySlot] then return false end
            slots[f.displaySlot]=true
        end
        count+=1
    end
    for _,find in p.finds do
        if find.biomeId==nil then find.biomeId='BIO-01' end
        if not Biomes.byId[find.biomeId] then return false end
        local definition=Config.itemsById[find.itemId] if definition.biomeId and definition.biomeId~=find.biomeId then return false end
    end
    if count>Config.inventoryCapacity then return false end
    for id,value in p.discovered do if not Config.itemsById[id] or value~=true then return false end end
    if p.ownedCoinThemes==nil then p.ownedCoinThemes={} end
    if type(p.ownedCoinThemes)~="table" or (p.selectedTheme~="Default" and p.selectedTheme~="Marine") then return false end
    if p.selectedTheme=="Marine" and not p.ownedCoinThemes.Marine then return false end
    if p.settings==nil then p.settings={music=true,sfx=true} end
    if type(p.settings)~="table" or type(p.settings.music)~="boolean" or type(p.settings.sfx)~="boolean" then return false end
    local audioDefaults={ambience=true,musicVolume=.35,sfxVolume=.85,ambienceVolume=.5}
    for key,value in audioDefaults do if p.settings[key]==nil then p.settings[key]=value end end
    if type(p.settings.ambience)~='boolean' then return false end
    for _,key in {'musicVolume','sfxVolume','ambienceVolume'} do
        local value=p.settings[key]
        if type(value)~='number' or value~=value or value<0 or value>1 then return false end
    end
    if p.recentOperations==nil then p.recentOperations={} end
    if type(p.recentOperations)~="table" or #p.recentOperations>128 then return false end
    local operations=0
    for k,v in p.recentOperations do
        if not integer(k,1,#p.recentOperations) or type(v)~="string" or #v>128 then return false end
        operations+=1
    end
    if operations~=#p.recentOperations then return false end
    if p.visitedBiomes==nil then p.visitedBiomes={['BIO-01']=true} end
    if type(p.visitedBiomes)~='table' then return false end
    for biome,value in p.visitedBiomes do if not require(game.ReplicatedStorage.MagnetWorkshop.Shared.BiomeCatalog).byId[biome] or value~=true then return false end end
    if p.biomeCatches==nil then p.biomeCatches={} end
    if type(p.biomeCatches)~='table' then return false end
    for biome,value in p.biomeCatches do if not Biomes.byId[biome] or value~=true then return false end end
    if p.guideEnabled==nil then p.guideEnabled=true end
    if type(p.guideEnabled)~="boolean" then return false end
    if p.tutorialStep==nil then p.tutorialStep=0 end
    if not integer(p.tutorialStep,0,5) then return false end
    if p.lock~=nil and (type(p.lock)~="table" or type(p.lock.sessionId)~="string" or #p.lock.sessionId>64 or not integer(p.lock.leaseUntil,0,2^52)) then return false end
    for key,value in p.ownedCoinThemes do if key~="Marine" or value~=true then return false end end
    return true
end
local function hasOperation(p,id) return table.find(p.recentOperations,id)~=nil end
local function write(session,callback)
    if Store.sandbox then
        -- A separate durable-like memory record exercises revision/idempotency in Studio.
        if session.faultBefore and session.faultBefore>0 then session.faultBefore-=1 error("Studio QA: injected write failure") end
        local updated=callback(clone(session.record))
        if updated then session.record=clone(updated) end
        if session.faultAfter and session.faultAfter>0 then session.faultAfter-=1 error("Studio QA: injected ambiguous response") end
        return clone(updated)
    end
    return dataStore:UpdateAsync("u:"..session.player.UserId,callback)
end
function Store.load(player)
    local session={player=player,sessionId=Http:GenerateGUID(false),busy=true,closing=false,nonce=Http:GenerateGUID(false)}
    Store.sessions[player]=session
    if not Store.sandbox and not dataStore then dataStore=game:GetService("DataStoreService"):GetDataStore("MagnetWorkshopProfiles_v1") end
    local problem="errProfile"
    for attempt=1,4 do
        local ok,result=pcall(function()
            return write(session,function(old)
                local checkedAt=os.time()
                local p=old==nil and default() or old
                if not Store.validate(p) then problem="errCorrupt" return nil end
                if p.lock and p.lock.sessionId~=session.sessionId and p.lock.leaseUntil>checkedAt then problem="errLock" return nil end
                p=clone(p) p.lock={sessionId=session.sessionId,leaseUntil=checkedAt+120} p.lastSeenAt=checkedAt
                return p
            end)
        end)
        if ok and result and result.lock and result.lock.sessionId==session.sessionId then
            session.data=result session.busy=false session.state="Idle" session.lastRenew=os.clock()
            return session
        end
        if problem=="errCorrupt" or problem=="errLock" then break end
        if attempt<4 then task.wait(2^(attempt-1)) end
    end
    Store.sessions[player]=nil
    return nil,problem
end
function Store.commit(session,operationId,mutate,onPending)
    if session.busy or session.closing or session.lost then return false,"errBusy" end
    if type(operationId)~="string" or #operationId<1 or #operationId>128 then return false,"errProfile" end
    -- A durable result is also the result of a repeated command; do not rerun
    -- a mutation whose item may already have been sold or removed.
    if hasOperation(session.data,operationId) then return true end
    session.busy=true
    local candidate=clone(session.data)
    local applied,ok,problem=pcall(mutate,candidate)
    if not applied then session.busy=false warn("[MagnetWorkshop] Transaction rejected: "..tostring(ok)) return false,"errProfile" end
    if not ok then session.busy=false return false,problem end
    candidate.revision+=1 candidate.lastSeenAt=os.time()
    table.insert(candidate.recentOperations,operationId)
    while #candidate.recentOperations>128 do table.remove(candidate.recentOperations,1) end
    if not Store.validate(candidate) then session.busy=false warn("[MagnetWorkshop] Invalid transaction candidate") return false,"errProfile" end
    local expected=session.data.revision
    local tries=0
    while not session.lost do
        tries+=1
        local now=os.time()
        if now>=session.data.lock.leaseUntil-15 then session.lost=true break end
        local conflict=false
        local success,result=pcall(function()
            return write(session,function(current)
                local checkedAt=os.time()
                if session.lost or not Store.validate(current) or not current.lock or current.lock.sessionId~=session.sessionId or current.lock.leaseUntil<=checkedAt then conflict=true return nil end
                if hasOperation(current,operationId) then return current end
                if current.revision~=expected then conflict=true return nil end
                local nextData=clone(candidate)
                nextData.lock={sessionId=session.sessionId,leaseUntil=checkedAt+120} nextData.lastSeenAt=checkedAt
                return nextData
            end)
        end)
        if success and result and hasOperation(result,operationId) then
            session.data=result session.busy=false session.lastRenew=os.clock()
            return true
        end
        if conflict then session.lost=true break end
        if onPending then
            local notified,err=pcall(onPending,tries)
            if not notified then warn("[MagnetWorkshop] Pending notification failed: "..tostring(err)) end
        end
        task.wait(math.min(2^(tries-1),8))
    end
    session.busy=false
    return false,"errProfile"
end
function Store.renew(session)
    if session.busy or session.closing or session.lost then return end
    session.busy=true
    local now=os.time()
    local conflict=false
    local ok,result=pcall(function()
        return write(session,function(current)
            local checkedAt=os.time()
            if session.lost or not Store.validate(current) or not current.lock or current.lock.sessionId~=session.sessionId or current.lock.leaseUntil<=checkedAt then conflict=true return nil end
            current=clone(current) current.lock.leaseUntil=checkedAt+120 return current
        end)
    end)
    if ok and result then session.data=result session.lastRenew=os.clock() end
    if conflict or now>=session.data.lock.leaseUntil-30 then session.lost=true end
    session.busy=false
end
function Store.release(session)
    session.closing=true
    local deadline=os.clock()+20
    while session.busy and os.clock()<deadline do task.wait(.1) end
    local function detach()
        if Store.sessions[session.player]==session then Store.sessions[session.player]=nil end
    end
    if session.busy then
        -- Fence a delayed callback before dropping the local session. The lease
        -- remains in the store until it expires if release cannot be confirmed.
        session.lost=true detach() return false,"errProfile"
    end
    session.busy=true
    local released=session.lost==true
    if not session.lost then
        local tries=0
        repeat
            tries+=1
            local ok=pcall(function()
                write(session,function(p)
                    if not p or not p.lock or p.lock.sessionId~=session.sessionId then return nil end
                    p=clone(p) p.lock=nil p.lastSeenAt=os.time() return p
                end)
            end)
            if ok then released=true break end
            local remaining=deadline-os.clock()
            if remaining<=0 then break end
            task.wait(math.min(2^(tries-1),4,remaining))
        until os.clock()>=deadline
    end
    session.busy=false detach()
    if not released then return false,"errProfile" end
    return true
end
return Store
