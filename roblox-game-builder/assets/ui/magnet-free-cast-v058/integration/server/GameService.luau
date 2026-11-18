local Players=game:GetService("Players")
local Http=game:GetService("HttpService")
local RunService=game:GetService("RunService")
local R=game.ReplicatedStorage.MagnetWorkshop
local C=require(R.Shared.Config)
local text=require(R.Shared.Strings)
local Factory=require(R.Shared.FindFactory)
local WaterCast=require(R.Shared.WaterCastRules)
local CastRules=require(R.Shared.CastRules)
local CleaningGeometry=require(R.Shared.CleaningGeometry)
local WorldLabels=require(R.Shared.WorldLabels)
local Equipment=require(script.Parent.MagnetEquipment)
local MapAssets=require(R.Shared.MapAssets)
local Store=require(script.Parent.ProfileStore)
local Portals=require(script.Parent.PortalService)
local Biomes=require(R.Shared.BiomeCatalog)
local Remotes=R.Remotes
local G={Sessions=Store.sessions}
local rng=Random.new()
local function count(t) local n=0 for _ in t do n+=1 end return n end
local function id() return Http:GenerateGUID(false) end
local function finite(n) return type(n)=="number" and n==n and math.abs(n)<1e8 end
local function short(s) return type(s)=="string" and #s<=64 end
local function root(player)
    local char=player.Character
    local humanoid=char and char:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health>0 and char:FindFirstChild("HumanoidRootPart")
end
local function near(player,position,distance)
    local r=root(player) return r and (r.Position-position).Magnitude<=distance
end
local function message(player,key,...)
    if player.Parent then Remotes.Notice:FireClient(player,text(key,...)) end
end
local function cleaningView(a)
    if not a or not a.cleaning then return nil end
    local one=CleaningGeometry.count(a.geometry,1,a.coverage[1])
    local two=CleaningGeometry.count(a.geometry,2,a.coverage[2])
    return {id=a.id,itemId=a.itemId,slotCFrame=a.slotCFrame,plotName=a.bench.Parent.Name,side=a.side,coverage1=CleaningGeometry.pack(a.geometry,a.coverage[1]),coverage2=CleaningGeometry.pack(a.geometry,a.coverage[2]),
        progress1=one/a.geometry.total[1],progress2=two/a.geometry.total[2],
        readyAt=a.readyAt,flipAt=a.flipAt}
end
function G.snapshot(s)
    if not s.data or s.closing or not s.player.Parent then return end
    local p=Store.clone(s.data) p.lock=nil p.recentOperations=nil
    local a=s.activity
    local fishing=a and a.point and not a.aiming and {id=a.id,castStartedAt=a.castStartedAt,point=a.point.Position,target=a.target,retrieveTo=a.retrieveTo,castDistance=a.castDistance,pullDuration=a.pullDuration,userId=s.player.UserId,stage=s.state,progress=a.progress}
    local aiming=a and a.aiming and {id=a.id,started=a.aimStarted,timeoutAt=a.aimStarted+C.cast.timeoutSeconds}
    Remotes.ProfileSnapshot:FireClient(s.player,{profile=p,nonce=s.nonce,lastActionSeq=s.lastSeq or 0,plotId=s.plotId,currentBiomeId=s.currentBiomeId,state=s.state,activityId=a and a.id,aiming=aiming,fishing=fishing,cleaning=cleaningView(a),sandbox=Store.sandbox})
end
local function reply(s,seq,status,code)
    local response={actionSeq=seq,status=status,code=code,message=s.errorMessage,revision=s.data and s.data.revision or 0}
    s.errorMessage=nil
    if not s.results[seq] then
        table.insert(s.resultOrder,seq)
        if #s.resultOrder>128 then s.results[table.remove(s.resultOrder,1)]=nil end
    end
    s.results[seq]=response
    if s.player.Parent then Remotes.ActionResult:FireClient(s.player,response) end
end
local function limited(s,key,rate,burst)
    local now=os.clock() local bucket=s.buckets[key] or {tokens=burst,time=now}
    bucket.tokens=math.min(burst,bucket.tokens+(now-bucket.time)*rate) bucket.time=now
    s.buckets[key]=bucket
    if bucket.tokens<1 then return true end
    bucket.tokens-=1 return false
end
local function publicList()
    local list={}
    for player,s in Store.sessions do
        if s.data and s.plotId and not s.closing then
            table.insert(list,{userId=player.UserId,name=player.Name,displayName=player.DisplayName,plotId=s.plotId,discovered=count(s.data.discovered)})
        end
    end
    table.sort(list,function(a,b) return a.plotId<b.plotId end)
    return list
end
local function broadcastList() Remotes.Workshops:FireAllClients(publicList()) end
local function refreshPlot(s)
    if not s.plotId then return end
    Equipment.update(s)
    local plot=workspace.MagnetWorld.Plots[string.format("Plot%02d",s.plotId)]
    plot:SetAttribute("OwnerUserId",s.player.UserId)
    plot.OwnerBoard.Label.Text.Text=text("ownerBoard",s.player.DisplayName,count(s.data.discovered))
    MapAssets.setTheme(plot,s.data.selectedTheme=="Marine" and Color3.fromRGB(63,112,175) or MapAssets.defaultTheme)
    plot.Exhibits:ClearAllChildren()
    for _,base in plot.Slots:GetChildren() do
        local slot=base:GetAttribute("Slot")
        base:SetAttribute("ItemId",nil) base:SetAttribute("FoundAt",nil) base:SetAttribute("OwnerUserId",s.player.UserId)
        base.Color=slot<=(s.data.expandedDisplay and 12 or 6) and C.palette.metal or C.palette.ink
        MapAssets.setPedestalState(base,slot<=(s.data.expandedDisplay and 12 or 6))
        base.Label.Text.Text=tostring(slot)
        base.Label.Size=UDim2.fromOffset(70,25) base.Label.MaxDistance=18 WorldLabels.apply(base.Label)
        base.ProximityPrompt.ObjectText=text("slot",slot)
    end
    for _,f in s.data.finds do
        if f.displaySlot then
            local base=plot.Slots[tostring(f.displaySlot)] local definition=C.itemsById[f.itemId]
            local model=Factory.create(f.itemId,false)
            model:PivotTo(base.CFrame*CFrame.new(0,.5,0)) model.Parent=plot.Exhibits
            base:SetAttribute("ItemId",f.itemId) base:SetAttribute("FoundAt",f.foundAt)
            base.ProximityPrompt.ObjectText=definition.name
            local box,size=model:GetBoundingBox() WorldLabels.apply(base.Label,box.Y+size.Y/2)
        end
    end
    for zone=1,3 do
        local collected,total=0,0 for _,item in C.items do if item.zone==C.zones[zone].id then total+=1 if s.data.discovered[item.id] then collected+=1 end end end
        local plaque=plot["Collection"..zone]
        plaque.Label.Text.Text=C.zones[zone].name.." "..collected.."/"..total
        plaque.Color=collected==total and C.palette.gold or C.palette.ink
    end
    broadcastList()
end
local function cleanFX(s)
    if s.activity then Remotes.FX:FireAllClients({kind="End",userId=s.player.UserId,id=s.activity.id}) end
end
local function unlockCharacter(s)
    Equipment.visible(s,true)
    local lock=s.movementLock if not lock then return end
    s.movementLock=nil
    if lock.root.Parent then lock.root.Anchored=lock.anchored end
    if lock.humanoid.Parent then
        lock.humanoid.WalkSpeed=lock.speed lock.humanoid.JumpPower=lock.jumpPower lock.humanoid.JumpHeight=lock.jumpHeight lock.humanoid.AutoRotate=lock.autoRotate
    end
end
local function lockCharacter(s,target)
    local char=s.player.Character local r=root(s.player) local h=char:FindFirstChildOfClass("Humanoid")
    if not s.movementLock then s.movementLock={char=char,root=r,humanoid=h,anchored=r.Anchored,speed=h.WalkSpeed,jumpPower=h.JumpPower,jumpHeight=h.JumpHeight,autoRotate=h.AutoRotate} end
    h.WalkSpeed=0 h.JumpPower=0 h.JumpHeight=0 h.AutoRotate=false
    r.AssemblyLinearVelocity=Vector3.zero r.AssemblyAngularVelocity=Vector3.zero
    if target and Vector3.new(target.X-r.Position.X,0,target.Z-r.Position.Z).Magnitude>.01 then r.CFrame=CFrame.lookAt(r.Position,Vector3.new(target.X,r.Position.Y,target.Z)) end
    r.Anchored=true
end
local function idle(s)
    cleanFX(s) unlockCharacter(s) s.activity=nil s.state="Idle" G.snapshot(s)
end
local function cancel(s,notify)
    if s.busy then return end
    local cleaning=s.state=="Cleaning"
    if s.activity then idle(s) if notify then message(s.player,cleaning and "cleanInterrupted" or "canceled") end end
end
local function commit(s,seq,operation,mutate,successKey,successState)
    s.state="CommitPending" if seq then reply(s,seq,"Pending","pending") end G.snapshot(s)
    local success,err=Store.commit(s,operation,mutate,function() message(s.player,"failedSave") end)
    if s.lost then s.player:Kick(text("errProfile")) return end
    if success and successState then s.state=successState else unlockCharacter(s) s.state="Idle" s.activity=nil end
    if success and not s.closing and s.player.Parent then refreshPlot(s) if successKey then
        message(s.player,successKey)
        local cue=({bought='upgrade',sold='sale',cleaned='reward'})[successKey]
        if cue then Remotes.FX:FireClient(s.player,{kind='Sound',cue=cue}) end
    end end
    G.snapshot(s)
    if seq then reply(s,seq,success and "Ok" or "Error",success and "saved" or err) end
    return success,err
end
local function chooseFind(s,zone,biomeId)
    if s.data.tutorialFindsGranted<2 then return C.itemsById[C.tutorialRewards[s.data.tutorialFindsGranted+1]] end
    local roll=rng:NextNumber(0,100) local total=0
    local pool=biomeId and biomeId~='BIO-01' and C.biomeItems or C.baseItems
    for _,item in pool do if item.zone==zone and (not item.biomeId or item.biomeId==biomeId) then total+=item.chancePercent if roll<=total then return item end end end
    error("Missing zone pool")
end
local function equipmentPool(level)
    local weights=C.catchPoolWeights[level]
    local roll=rng:NextNumber(0,100) local total=0
    for index,weight in weights do
        total+=weight
        if roll<=total then return C.zones[index] end
    end
    return C.zones[level]
end
local function fishingLake(s)
    local biome=s.currentBiomeId or 'BIO-01'
    if biome=='BIO-01' then return workspace.MagnetWorld.Lake end
    local d=Biomes.byId[biome]
    if not d or not Biomes.canEnter(d,s.data.rebirthCount,false,s.data.toolLevel) then return nil end
    return WaterCast.lake(workspace.MagnetWorld,biome)
end
local function cast(s,payload,seq)
    if not Equipment.equipped(s) then return "errEquipMagnet" end
    if os.clock()<(s.nextCast or 0) then return "errRate" end
    if not fishingLake(s) then return 'errBiomeClosed' end
    local view,err=WaterCast.resolve(s.player.Character,workspace.MagnetWorld,s.currentBiomeId or 'BIO-01')
    if not view then return err end
    if count(s.data.finds)>=C.inventoryCapacity then return "errInventory" end
    local a={id=id(),point=view.lake,castView=view,biomeId=view.biomeId,aiming=true,aimStarted=workspace:GetServerTimeNow()}
    s.activity=a s.state='Aiming'
    lockCharacter(s,nil)
    G.snapshot(s) reply(s,seq,'Ok','aiming')
    return nil,true
end
local function releaseCast(s,payload,seq)
    local aim=s.activity
    if not aim or not aim.aiming or payload.activityId~=aim.id then return 'errStale' end
    if not Equipment.equipped(s) then cancel(s,false) return 'errEquipMagnet' end
    if not WaterCast.stillValid(s.player.Character,aim.castView) then cancel(s,false) return 'errWaterNear' end
    local elapsed=workspace:GetServerTimeNow()-aim.aimStarted
    if elapsed>C.cast.timeoutSeconds then cancel(s,false) return 'errStale' end
    if not finite(payload.elapsed) or payload.elapsed<0 or payload.elapsed>elapsed+C.cast.maxInputFuture or payload.elapsed<elapsed-C.cast.maxInputBackdate then return 'errTarget' end
    if count(s.data.finds)>=C.inventoryCapacity then return 'errInventory' end
    local power=CastRules.power(math.min(payload.elapsed,elapsed))
    local lake=fishingLake(s) if lake~=aim.point then cancel(s,false) return 'errBiomeClosed' end
    local target,retrieveTo=WaterCast.target(aim.castView,power,workspace.MagnetWorld)
    if not target then return retrieveTo end
    local castDistance=((target-root(s.player).Position)*Vector3.new(1,0,1)).Magnitude
    local pullDuration=CastRules.pullDuration(s.data.toolLevel,castDistance)
    local zone=equipmentPool(s.data.toolLevel)
    local item=chooseFind(s,zone.id,aim.biomeId)
    local a={id=aim.id,point=lake,castView=aim.castView,biomeId=aim.biomeId,target=target,retrieveTo=retrieveTo,castDistance=castDistance,pullDuration=pullDuration,pullTimeout=math.max(C.pull.timeoutSeconds,pullDuration*2.5),itemId=item.id,zoneId=zone.id,power=power,stage="Casting",started=os.clock(),castStartedAt=workspace:GetServerTimeNow(),
        tension=C.pull.tensionStart,progress=0,high=0,low=0,lastTap=-math.huge,lastInput=0,inputSeq=0,greenMin=C.pull.greenMin,greenMax=C.pull.greenMax}
    if s.data.tutorialFindsGranted==0 then a.greenMin=C.pull.tutorialGreenMin a.greenMax=C.pull.tutorialGreenMax end
    s.activity=a s.state="Casting"
    Equipment.visible(s,false)
    lockCharacter(s,nil)
    Remotes.FX:FireAllClients({kind="Cast",id=a.id,castStartedAt=a.castStartedAt,userId=s.player.UserId,point=aim.castView.origin,target=target,retrieveTo=retrieveTo,castDistance=castDistance,pullDuration=pullDuration})
    G.snapshot(s) reply(s,seq,"Ok","casting")
    return nil,true
end
function G.handle(player,payload)
    local s=Store.sessions[player]
    if not s or not s.data then return end
    if type(payload)~="table" then return end
    local fields=0 for _,v in payload do fields+=1 if type(v)=="table" or typeof(v)=="Instance" then return end end
    if fields>(payload.action=="SetSettings" and 9 or 8) or not short(payload.action) then return end
    if payload.action=="Sync" then
        if limited(s,"sync",1,3) then return end
        G.snapshot(s) Remotes.Workshops:FireClient(player,publicList()) return
    end
    local seq=payload.actionSeq
    if payload.nonce~=s.nonce or not finite(seq) or seq%1~=0 or seq<1 or seq>2^31 then return end
    if s.results[seq] then Remotes.ActionResult:FireClient(player,s.results[seq]) return end
    if seq<=s.lastSeq then reply(s,seq,"Error","errStale") return end
    s.lastSeq=seq
    if limited(s,"action",4,8) then reply(s,seq,"Error","errRate") return end
    if s.adminBusy then reply(s,seq,'Error','errBusy') return end
    if payload.action=="Cancel" then
        if s.busy then reply(s,seq,"Pending","pending") return end
        if s.activity and payload.activityId~=s.activity.id then reply(s,seq,"Error","errStale") return end
        cancel(s,true) reply(s,seq,"Ok","canceled") return
    end
    if payload.action=='ReleaseCast' then
        if s.busy or s.closing or s.lost or s.state~='Aiming' or not root(player) then reply(s,seq,'Error','errBusy') return end
        local err=releaseCast(s,payload,seq)
        if err then reply(s,seq,'Error',err) end
        return
    end
    if payload.action=='SetGuide' then
        if s.busy or s.portalPending or s.closing or s.lost or s.state~='Idle' then reply(s,seq,'Error','errBusy') return end
        local allowed={action=true,nonce=true,actionSeq=true,enabled=true}
        for key in payload do if not allowed[key] then reply(s,seq,'Error','errTarget') return end end
        if type(payload.enabled)~='boolean' then reply(s,seq,'Error','errTarget') return end
        if limited(s,'guide',1,3) then reply(s,seq,'Error','errRate') return end
        reply(s,seq,'Pending','pending')
        local success,err=Store.commit(s,s.nonce..':'..seq,function(p) p.guideEnabled=payload.enabled return true end,function() message(s.player,'failedSave') end)
        if s.lost then player:Kick(text('errProfile')) return end
        G.snapshot(s) reply(s,seq,success and 'Ok' or 'Error',success and 'settingsSaved' or err) return
    end
    if payload.action=='SetSettings' then
        if s.busy or s.portalPending or s.closing or s.lost or s.state~='Idle' then reply(s,seq,'Error','errBusy') return end
        local allowed={action=true,nonce=true,actionSeq=true,music=true,sfx=true,ambience=true,musicVolume=true,sfxVolume=true,ambienceVolume=true}
        for key in payload do if not allowed[key] then reply(s,seq,'Error','errTarget') return end end
        for _,key in {'music','sfx','ambience'} do if type(payload[key])~='boolean' then reply(s,seq,'Error','errTarget') return end end
        for _,key in {'musicVolume','sfxVolume','ambienceVolume'} do
            if not finite(payload[key]) or payload[key]<0 or payload[key]>1 then reply(s,seq,'Error','errTarget') return end
        end
        if limited(s,'settings',1,3) then reply(s,seq,'Error','errRate') return end
        local operation=s.nonce..':'..seq
        reply(s,seq,'Pending','pending')
        local success,err=Store.commit(s,operation,function(p)
            for _,key in {'music','sfx','ambience','musicVolume','sfxVolume','ambienceVolume'} do p.settings[key]=payload[key] end return true
        end,function() message(s.player,'failedSave') end)
        if s.lost then player:Kick(text('errProfile')) return end
        G.snapshot(s) reply(s,seq,success and 'Ok' or 'Error',success and 'settingsSaved' or err)
        return
    end
    if s.busy or s.portalPending or s.closing or s.lost or s.state~="Idle" then reply(s,seq,"Error","errBusy") return end
    if not root(player) then reply(s,seq,"Error","errBusy") return end
    local action=payload.action local errorKey
    local operation=s.nonce..":"..seq
    if action=="ToggleMagnet" then
        local ok=Equipment.toggle(s) reply(s,seq,ok and "Ok" or "Error",ok and "saved" or "errEquipMagnet") G.snapshot(s) return
    elseif action=="Cast" then
        local err,handled=cast(s,payload,seq) if handled then return end errorKey=err
    elseif action=="StartClean" then
        local f=short(payload.findUid) and s.data.finds[payload.findUid]
        local plot=workspace.MagnetWorld.Plots[string.format("Plot%02d",s.plotId)]
        if not f then errorKey="errFind"
        elseif f.state~="Dirty" then errorKey="errDirty"
        elseif not near(player,plot.Bench.Position,10) then errorKey="errDistance"
        else
            local slot=plot:FindFirstChild("CleaningSlot")
            if not slot then reply(s,seq,"Error","errLoading") return end
            local started=workspace:GetServerTimeNow()
            s.activity={id=id(),uid=f.uid,itemId=f.itemId,cleaning=true,geometry=CleaningGeometry.describe(f.itemId),coverage={{},{}},side=1,brushSeconds={0,0},
                brush=nil,lastInput=0,inputSeq=0,bench=plot.Bench,slotCFrame=slot.CFrame*CFrame.new(0,slot.Size.Y/2+.02,0),readyAt=started+C.cleaning.cameraSeconds}
            lockCharacter(s,plot.Bench.Position)
            s.state="Cleaning" G.snapshot(s) reply(s,seq,"Ok","cleaning") return
        end
    elseif action=="Sell" then
        local f=short(payload.findUid) and s.data.finds[payload.findUid]
        if not f then errorKey="errFind"
        elseif f.state~="Clean" then errorKey="errDirty"
        elseif f.displaySlot then errorKey="errDisplay"
        elseif not near(player,workspace.MagnetWorld.Plaza.Buyer.Position,10) then errorKey="errDistance"
        else
            local copies=0 for _,v in s.data.finds do if v.itemId==f.itemId then copies+=1 end end
            if copies==1 and payload.confirmLast~=true then errorKey="lastCopy"
            elseif s.data.coins+C.itemsById[f.itemId].sellCoins>C.coinsCap then errorKey="errCap"
            else commit(s,seq,operation,function(p) p.finds[f.uid]=nil p.coins+=C.itemsById[f.itemId].sellCoins p.tutorialStep=math.max(p.tutorialStep,5) return true end,"sold") return end
        end
    elseif action=="Place" or action=="Remove" then
        local f=short(payload.findUid) and s.data.finds[payload.findUid]
        local plot=workspace.MagnetWorld.Plots[string.format("Plot%02d",s.plotId)]
        if not f then errorKey="errFind"
        elseif f.state~="Clean" then errorKey="errDirty"
        elseif not near(player,plot:GetPivot().Position,60) then errorKey="errDistance"
        elseif action=="Place" and (not finite(payload.slot) or payload.slot%1~=0 or payload.slot<1 or payload.slot>(s.data.expandedDisplay and 12 or 6)) then errorKey="errSlot"
        else commit(s,seq,operation,function(p)
            if action=="Place" then for _,other in p.finds do if other.displaySlot==payload.slot then other.displaySlot=nil end end end
            p.finds[f.uid].displaySlot=action=="Place" and payload.slot or nil p.tutorialStep=math.max(p.tutorialStep,5) return true
        end,"saved") return end
    elseif action=="BuyUpgrade" then
        if not near(player,workspace.MagnetWorld.Plaza.Shop.Position,10) then errorKey="errDistance"
        else
            local upgrade=payload.upgradeId local cost
            if upgrade=="Tool" and s.data.toolLevel<3 then cost=C.toolLevels[s.data.toolLevel+1].cost
            elseif upgrade=="Display" and not s.data.expandedDisplay then cost=C.upgrades[1].cost
            elseif upgrade=="Marine" and not s.data.ownedCoinThemes.Marine then cost=C.upgrades[2].cost end
            if not cost then errorKey="errStale"
            elseif s.data.coins<cost then s.errorMessage=text("errCoins",cost-s.data.coins) errorKey="errCoins"
            else commit(s,seq,operation,function(p)
                p.coins-=cost
                if upgrade=="Tool" then p.toolLevel+=1 elseif upgrade=="Display" then p.expandedDisplay=true
                else p.ownedCoinThemes.Marine=true p.selectedTheme="Marine" end return true
            end,"bought") return end
        end
    elseif action=="SelectTheme" then
        if payload.themeId~="Default" and (payload.themeId~="Marine" or not s.data.ownedCoinThemes.Marine) then errorKey="errStale"
        else commit(s,seq,operation,function(p) p.selectedTheme=payload.themeId return true end,"saved") return end
    elseif action=='EnterPortal' then
        reply(s,seq,'Pending','pending')
        local err=Portals.enter(s,payload.portalId)
        local d=not err and Biomes.byId[s.currentBiomeId]
        if d and (d.state=='Open' or d.state=='Released') and not s.data.visitedBiomes[d.id] then
            local ok,problem=Store.commit(s,operation,function(p) p.visitedBiomes[d.id]=true return true end)
            if not ok then err=problem if s.lost then player:Kick(text('errProfile')) end end
        end
        G.snapshot(s) reply(s,seq,err and 'Error' or 'Ok',err or 'portalEntered') return
    elseif action=="Home" or action=="Visit" then
        local target=s
        if action=="Visit" then
            target=nil if finite(payload.targetUserId) then for who,other in Store.sessions do if who.UserId==payload.targetUserId then target=other break end end end
        end
        if not target or not target.plotId or target.closing then errorKey="errStale"
        elseif os.clock()<(s.nextVisit or 0) then errorKey="errRate"
        else
            s.nextVisit=os.clock()+C.timings.visitCooldownSeconds
            local plot=workspace.MagnetWorld.Plots[string.format("Plot%02d",target.plotId)]
            player.Character:PivotTo(plot.Entrance.CFrame*CFrame.new(0,2,0))
            s.currentBiomeId='BIO-01'
            G.snapshot(s) reply(s,seq,"Ok","saved") return
        end
    else errorKey="errStale" end
    reply(s,seq,"Error",errorKey or "errStale")
end
function G.pullInput(player,payload)
    local s=Store.sessions[player] if not s or s.state~="Pulling" or not s.activity or type(payload)~="table" then return end
    local a=s.activity
    if payload.attemptId~=a.id or not finite(payload.inputSeq) or payload.inputSeq%1~=0 or payload.inputSeq<=a.inputSeq or payload.tap~=true then return end
    if limited(s,"pull",8,8) then return end
    a.inputSeq=payload.inputSeq
    local now=os.clock()
    if now-a.lastTap<C.pull.tapMinInterval then return end
    a.lastTap=now a.lastInput=now
    a.tension=math.clamp(a.tension+C.pull.tapImpulse,0,1)
end
function G.cleanInput(player,payload)
    local s=Store.sessions[player] if not s or s.state~="Cleaning" or not s.activity or type(payload)~="table" then return end
    local a=s.activity
    if limited(s,"clean",20,30) or payload.cleanId~=a.id or not finite(payload.inputSeq) or payload.inputSeq%1~=0 or payload.inputSeq<=a.inputSeq or type(payload.held)~="boolean" then return end
    a.inputSeq=payload.inputSeq a.lastInput=os.clock()
    if not payload.held then a.brush=nil return end
    if payload.side~=a.side or workspace:GetServerTimeNow()<a.readyAt or not finite(payload.x) or not finite(payload.z) then a.brush=nil return end
    if not CleaningGeometry.surface(a.geometry,a.side,payload.x,payload.z) then a.brush=nil return end
    a.brush={x=payload.x,z=payload.z}
end
local function activityState(s)
    local a=s.activity if not a or not s.player.Parent then return end
    Remotes.AttemptState:FireClient(s.player,{id=a.id,stage=s.state,tension=a.tension,progress=a.progress,greenMin=a.greenMin,greenMax=a.greenMax,
        itemId=s.state=="Cleaning" and a.itemId or nil,weightClass=a.itemId and C.itemsById[a.itemId].weightKg>5 and "heavy" or "light",
        cleaning=cleaningView(a),serverTime=workspace:GetServerTimeNow()})
    if a.point and not a.aiming then Remotes.FX:FireAllClients({kind="Update",id=a.id,stage=s.state,progress=a.progress}) end
end
local function step(s,dt)
    if not s.data or s.closing or s.adminBusy then return end
    local a=s.activity
    if not a or s.busy then return end
    local now=os.clock()
    if s.state=='Aiming' then
        if not Equipment.equipped(s) or not WaterCast.stillValid(s.player.Character,a.castView) or (s.currentBiomeId or 'BIO-01')~=a.biomeId or workspace:GetServerTimeNow()-a.aimStarted>C.cast.timeoutSeconds then cancel(s,true) end
    elseif s.state=="Cleaning" then
        if not near(s.player,a.bench.Position,10) then cancel(s,true) return end
        if a.brush and now-a.lastInput<=.5 and workspace:GetServerTimeNow()>=a.readyAt then
            if CleaningGeometry.paint(a.geometry,a.side,a.coverage[a.side],a.brush.x,a.brush.z,dt) then a.brushSeconds[a.side]+=dt end
        end
        if a.side==1 and CleaningGeometry.count(a.geometry,1,a.coverage[1])==a.geometry.total[1] and a.brushSeconds[1]>=C.cleaning.minTotalSeconds/2 then
            a.side=2 a.brush=nil a.flipAt=workspace:GetServerTimeNow() a.readyAt=a.flipAt+C.cleaning.flipSeconds
            G.snapshot(s)
        end
        local done=a.side==2 and CleaningGeometry.count(a.geometry,2,a.coverage[2])==a.geometry.total[2] and a.brushSeconds[2]>=C.cleaning.minTotalSeconds/2
        if done then
            s.state="CommitPending"
            task.spawn(function() commit(s,nil,a.id,function(p)
                local f=p.finds[a.uid] if not f or f.state~="Dirty" then return false,"errFind" end
                f.state="Clean" p.discovered[f.itemId]=true p.tutorialStep=math.max(p.tutorialStep,4) return true
            end,"cleaned") end)
        end
    elseif s.state=="Casting" or s.state=="Searching" or s.state=="Pulling" then
        if not Equipment.equipped(s) then cancel(s,true) return end
        if not WaterCast.stillValid(s.player.Character,a.castView) or (s.currentBiomeId or 'BIO-01')~=a.biomeId then cancel(s,true) return end
        if s.state=="Casting" and now-a.started>=C.timings.castSeconds then s.state="Searching" a.searchStarted=now
        elseif s.state=="Searching" and now-a.searchStarted>=C.timings.searchSeconds then s.state="Pulling" a.pullStarted=now a.tension=C.pull.tensionStart
        elseif s.state=="Pulling" then
            a.tension=math.clamp(a.tension-C.pull.driftRate*dt,0,1)
            local safe=a.tension>=a.greenMin and a.tension<=a.greenMax
            a.progress=math.clamp(a.progress+(safe and 1/a.pullDuration or C.pull.outsideProgressRate)*dt,0,1)
            a.high=a.tension>C.pull.highDangerThreshold and a.high+dt or 0
            a.low=a.tension<C.pull.lowDangerThreshold and a.low+dt or 0
            if a.high>=C.pull.highDangerSeconds or a.low>=C.pull.lowDangerSeconds or now-a.pullStarted>a.pullTimeout then
                s.nextCast=now+C.timings.failedCastCooldownSeconds idle(s) Remotes.FX:FireClient(s.player,{kind="Sound",cue="lost"}) message(s.player,"lost") return
            end
            if a.progress>=1 then
                s.state="RewardPending"
                local uid=id() local f={uid=uid,itemId=a.itemId,biomeId=a.biomeId or 'BIO-01',zoneId=C.itemsById[a.itemId].zone,foundAt=os.time(),finderUserId=s.player.UserId,state="Dirty"}
                task.spawn(function()
                    local success=commit(s,nil,a.id,function(p)
                        if count(p.finds)>=C.inventoryCapacity then return false,"errInventory" end
                        p.finds[uid]=f p.biomeCatches[f.biomeId]=true p.visitedBiomes[f.biomeId]=true p.tutorialFindsGranted=math.min(2,p.tutorialFindsGranted+1) p.tutorialStep=math.max(p.tutorialStep,3) return true
                    end,nil,"Revealing")
                    if success and not s.closing and s.player.Parent then
                        if a.presentationCanceled then idle(s) Remotes.Reveal:FireClient(s.player,f.itemId) return end
                        Remotes.FX:FireAllClients({kind="Caught",id=a.id,itemId=f.itemId,duration=C.timings.revealSeconds})
                        task.delay(C.timings.revealSeconds+.2,function()
                            if s.activity==a and s.state=="Revealing" and not s.closing then idle(s) Remotes.Reveal:FireClient(s.player,f.itemId) end
                        end)
                    end
                end)
            end
        end
    end
end
local function teleportHome(s)
    s.currentBiomeId='BIO-01'
    local plot=workspace.MagnetWorld.Plots[string.format("Plot%02d",s.plotId)]
    if s.player.Character then s.player.Character:PivotTo(plot.Entrance.CFrame*CFrame.new(0,2,0)) end
end
local function adminReady(player)
    local s=Store.sessions[player]
    if not s or not s.data or s.busy or s.adminBusy or s.closing or s.lost or s.portalPending or s.state=='CommitPending' or s.state=='RewardPending' then return nil end
    return s
end
function G.adminApply(player,operation,mutate,resetHome)
    local s=adminReady(player) if not s then return false,'errBusy' end
    cancel(s,false) s.adminBusy=true
    local called,success,err=pcall(commit,s,nil,operation,mutate)
    s.adminBusy=nil
    if not called then warn('[MagnetWorkshop] Admin save failed: '..tostring(success));idle(s);return false,'errProfile' end
    if success and resetHome then teleportHome(s);G.snapshot(s) end
    return success==true,err
end
function G.adminTravel(player,biomeId)
    local s=adminReady(player) if not s then return false,'errBusy' end
    local r=root(player) if not r then return false,'errCharacter' end
    local d=Biomes.byId[biomeId] if not d then return false,'errTarget' end
    local destination
    if biomeId=='BIO-01' then
        local plot=workspace.MagnetWorld.Plots[string.format('Plot%02d',s.plotId)]
        destination=plot.Entrance.CFrame*CFrame.new(0,2,0)
    else
        local biome=workspace.MagnetWorld.Biomes:FindFirstChild(biomeId)
        local marker=biome and biome:FindFirstChild('ReturnPoint')
        if not marker then return false,'errTarget' end
        destination=require(R.Shared.PortalGeometry).arrival(marker)
    end
    cancel(s,false) s.adminBusy=true;s.portalPending=true
    local char=player.Character
    if workspace.StreamingEnabled then
        local ok=pcall(function() player:RequestStreamAroundAsync(destination.Position,2) end)
        if not ok then s.adminBusy=nil;s.portalPending=nil;return false,'errBusy' end
    end
    if s.closing or s.lost or player.Character~=char or not root(player) then s.adminBusy=nil;s.portalPending=nil;return false,'errCharacter' end
    r.AssemblyLinearVelocity=Vector3.zero;r.AssemblyAngularVelocity=Vector3.zero
    char:PivotTo(destination);s.currentBiomeId=biomeId;s.nextPortal=os.clock()+1.5
    s.adminBusy=nil;s.portalPending=nil;G.snapshot(s);return true
end
function G.addPlayer(player)
    local s,err=Store.load(player)
    if not s then player:Kick(text(err)) return end
    if not player.Parent then Store.release(s) return end
    s.results={} s.resultOrder={} s.buckets={} s.lastSeq=0
    for i=1,6 do
        local plot=workspace.MagnetWorld.Plots[string.format("Plot%02d",i)]
        if plot:GetAttribute("OwnerUserId")==0 then s.plotId=i plot:SetAttribute("OwnerUserId",player.UserId) break end
    end
    if not s.plotId then Store.release(s) player:Kick(text("noPlayers")) return end
    local function characterAdded(char)
        if s.closing or player.Character~=char then return end
        if s.activity then s.activity.presentationCanceled=true end
        unlockCharacter(s) cleanFX(s)
        cancel(s,false)
        local characterRoot=char:WaitForChild("HumanoidRootPart",10)
        if not characterRoot or s.closing or player.Character~=char then return end
        for _,v in char:GetDescendants() do if v:IsA("BasePart") then v.CollisionGroup="MagnetPlayers" end end
        char.DescendantAdded:Connect(function(v) if v:IsA("BasePart") then v.CollisionGroup="MagnetPlayers" end end)
        local h=char:FindFirstChildOfClass("Humanoid")
        if h then h.Died:Connect(function() if player.Character==char then
            if s.activity then s.activity.presentationCanceled=true end
            unlockCharacter(s) cleanFX(s) cancel(s,false)
        end end) end
        Equipment.give(s,function()
            if s.activity and s.activity.point then s.activity.presentationCanceled=true cancel(s,true) end
        end)
        teleportHome(s) G.snapshot(s)
    end
    player.CharacterAdded:Connect(characterAdded)
    if player.Character then task.spawn(characterAdded,player.Character) end
    refreshPlot(s) G.snapshot(s)
end
function G.removePlayer(player)
    local s=Store.sessions[player] if not s or s.removing then return end
    s.removing=true s.closing=true
    cleanFX(s) unlockCharacter(s)
    local plot=s.plotId and workspace.MagnetWorld.Plots[string.format("Plot%02d",s.plotId)]
    if plot and plot:GetAttribute("OwnerUserId")==player.UserId then
        plot.Exhibits:ClearAllChildren() plot:SetAttribute("OwnerUserId",0) plot.OwnerBoard.Label.Text.Text=text("freePlot")
        for _,base in plot.Slots:GetChildren() do
            local slot=base:GetAttribute("Slot")
            for _,key in {"OwnerUserId","ItemId","FoundAt"} do base:SetAttribute(key,nil) end
            base.Label.Text.Text=tostring(slot) base.Label.Size=UDim2.fromOffset(70,25) WorldLabels.apply(base.Label)
            base.ProximityPrompt.ObjectText=text("slot",slot)
            base.Color=slot<=6 and C.palette.metal or C.palette.ink
            MapAssets.setPedestalState(base,slot<=6)
        end
        MapAssets.setTheme(plot,MapAssets.defaultTheme)
        for zone=1,3 do local total=0 for _,item in C.items do if item.zone==C.zones[zone].id then total+=1 end end plot["Collection"..zone].Label.Text.Text=C.zones[zone].name.." 0/"..total plot["Collection"..zone].Color=C.palette.ink end
    end
    broadcastList() Store.release(s)
end
function G.start()
    Remotes.ActionRequest.OnServerEvent:Connect(G.handle)
    Remotes.PullInput.OnServerEvent:Connect(G.pullInput)
    Remotes.CleanInput.OnServerEvent:Connect(G.cleanInput)
    Remotes.InspectRequest.OnServerEvent:Connect(function(player,ownerId,slot)
        local viewer=Store.sessions[player] if not viewer or limited(viewer,"inspect",4,6) or not finite(ownerId) or not finite(slot) then return end
        for owner,s in Store.sessions do if owner.UserId==ownerId and s.plotId then
            local base=workspace.MagnetWorld.Plots[string.format("Plot%02d",s.plotId)].Slots:FindFirstChild(tostring(slot))
            if not base or not near(player,base.Position,20) then return end
            for _,f in s.data.finds do if f.displaySlot==slot then
                Remotes.ExhibitCard:FireClient(player,{itemId=f.itemId,displayName=owner.DisplayName,name=owner.Name,ownerUserId=ownerId,
                    zoneId=f.zoneId,biomeId=f.biomeId,foundAt=f.foundAt,discovered=count(s.data.discovered),slot=slot}) return
            end end
        end end
    end)
    Players.PlayerAdded:Connect(function(p) task.spawn(G.addPlayer,p) end)
    Players.PlayerRemoving:Connect(G.removePlayer)
    for _,p in Players:GetPlayers() do task.spawn(G.addPlayer,p) end
    local accumulator,broadcast,rescue=0,0,0
    RunService.Heartbeat:Connect(function(dt)
        accumulator+=math.min(dt,.3) broadcast+=dt rescue+=dt
        while accumulator>=C.pull.tickSeconds do
            accumulator-=C.pull.tickSeconds
            for _,s in Store.sessions do step(s,C.pull.tickSeconds) end
        end
        if broadcast>=.2 then broadcast=0 for _,s in Store.sessions do activityState(s) end end
        if rescue>=1 then
            rescue=0
            for player,s in Store.sessions do if s.data and s.plotId and not s.closing then
                local r=root(player)
                if r and r.Position.Y < -1 then cancel(s,false) teleportHome(s) message(player,"returned") end
                if os.clock()-s.lastRenew>=30 then task.spawn(Store.renew,s) end
                if s.lost then player:Kick(text("errProfile")) end
            end end
        end
    end)
    game:BindToClose(function()
        for player in Store.sessions do task.spawn(G.removePlayer,player) end
        local deadline=os.clock()+25
        while next(Store.sessions) and os.clock()<deadline do task.wait(.1) end
    end)
    print("[MagnetWorkshop] Server ready · "..(Store.sandbox and "Studio sandbox" or "persistent profiles"))
end
return G
