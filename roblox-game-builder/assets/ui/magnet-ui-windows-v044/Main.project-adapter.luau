local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local CAS=game:GetService("ContextActionService")
local RunService=game:GetService("RunService")
local PromptService=game:GetService("ProximityPromptService")
local player=Players.LocalPlayer
local R=game.ReplicatedStorage:WaitForChild("MagnetWorkshop")
local C=require(R.Shared.Config)
local text=require(R.Shared.Strings)
local Factory=require(R.Shared.FindFactory)
local PierRules=require(R.Shared.PierRules)
local Presentation=require(script.Parent:WaitForChild("FishingPresentation"))
local Cleaner=require(script.Parent:WaitForChild("CleaningPresentation"))
local EquipmentUI=require(script.Parent.EquipmentUI)
local CastMeter=require(script.Parent.CastMeter)
local Audio=require(script.Parent.AudioPresentation)
local SettingsUI=require(script.Parent.SettingsUI)
local Biomes=require(R.Shared.BiomeCatalog)
local HudNavigation=require(script.Parent.HudNavigation)
local WindowTheme=require(script.Parent.WindowTheme)
local Windows=require(script.Parent.WorkshopWindows)
task.spawn(function() require(script.Parent.BiomePresentation).start() end)
task.spawn(function() require(script.Parent.LakePresentation).start() end)
local E=R.Remotes local P=C.palette
local gui=Instance.new("ScreenGui") gui.Name="MagnetWorkshopUI" gui.ResetOnSpawn=false
local previousGui=player:WaitForChild("PlayerGui"):FindFirstChild(gui.Name)
if previousGui then previousGui:Destroy() end
gui.ScreenInsets=Enum.ScreenInsets.CoreUISafeInsets gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling gui.DisplayOrder=10 gui.Parent=player:WaitForChild("PlayerGui")
local screen=gui
gui=Instance.new("Frame") gui.Name="Content" gui.Size=UDim2.fromScale(1,1) gui.BackgroundTransparency=1 gui.Parent=screen
local snapshot,activity,neighbors=nil,nil,{}
local state="Loading" local seq=0 local inputSeq=0 local page=nil local selectedUid=nil
local spaceDown=false local lastTap=-math.huge
local pendingRequest=nil local canceledActivity=nil local activeActivityId=nil
local inspectedExhibit=nil
local modal=nil local body=nil local tensionFill,progressFill,tensionMarker,activityTitle,activityHint,tapButton=nil,nil,nil,nil,nil,nil
local previews={}
local cleaningInfo=nil
local activityControls=nil local presentationId=nil local nearestContext=nil
local displayedTension=.5 local displayedProgress=0 local desiredTension=.5 local desiredProgress=0
local openInventory,openJournal,openShop,openWorkshops,openFind,showCleaning,showActivity,openSlots,openSettings
local function count(t) local n=0 for _ in t do n+=1 end return n end
local function make(class,parent,name,props)
    local v=Instance.new(class) v.Name=name
    for k,val in props or {} do v[k]=val end
    v.Parent=parent return v
end
local function round(obj,r) make("UICorner",obj,"Corner",{CornerRadius=UDim.new(0,r or 12)}) end
local function label(parent,name,value,size,pos,fontSize,color)
    return make("TextLabel",parent,name,{Text=value,Size=size,Position=pos or UDim2.new(),BackgroundTransparency=1,
        TextColor3=color or P.ink,Font=Enum.Font.GothamMedium,TextSize=fontSize or 17,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left})
end
local function button(parent,name,value,size,pos,callback,color)
    local b=make("TextButton",parent,name,{Text=value,Size=size,Position=pos or UDim2.new(),BackgroundColor3=color or P.ink,
        TextColor3=P.paper,Font=Enum.Font.GothamBold,TextSize=16,TextWrapped=true,AutoButtonColor=true,BorderSizePixel=0})
    local serverActions={Clean=true,Place=true,Remove=true,ConfirmSell=true,ToolUpgrade=true,Expand=true,Marine=true,ConfirmCast=true,Visit=true,Home=true,EnterPortal=true}
    if serverActions[name] or string.match(name,"^Slot%d+$") then b:SetAttribute("ServerAction",true) end
    round(b,9) if callback then b.Activated:Connect(callback) end return b
end
local function updatePending()
    for _,b in gui:GetDescendants() do if b:IsA("TextButton") and b:GetAttribute("ServerAction") then
        local available=pendingRequest==nil and b:GetAttribute("ActionAvailable")~=false
        b.Interactable=available b.AutoButtonColor=available b.TextTransparency=available and 0 or .45
    end end
end
local notice=label(gui,"Notice","",UDim2.new(1,-24,0,48),UDim2.new(.5,0,0,8),15,P.paper)
notice.AnchorPoint=Vector2.new(.5,0)
make("UISizeConstraint",notice,"Bounds",{MaxSize=Vector2.new(340,48)})
notice.BackgroundColor3=P.ink notice.BackgroundTransparency=.08 notice.TextXAlignment=Enum.TextXAlignment.Center notice.Visible=false round(notice)
local noticeToken=0 local lastNotice=nil local lastNoticeAt=0
local function notify(value)
    if value==lastNotice and os.clock()-lastNoticeAt<1 then return end
    lastNotice=value lastNoticeAt=os.clock()
    noticeToken+=1 local token=noticeToken notice.Text=value notice.Visible=true notice.ZIndex=30
    task.delay(2.8,function() if token==noticeToken then notice.Visible=false end end)
end
local function request(action,extra)
    if not snapshot then notify(text("errLoading")) return end
    if pendingRequest and action~="Cancel" then return end
    seq+=1 local payload=extra or {} payload.action=action payload.nonce=snapshot.nonce payload.actionSeq=seq
    pendingRequest=seq updatePending()
    E.ActionRequest:FireServer(payload) return seq
end
require(script.Parent.PortalWalkthrough).start(gui,request,function() return state=='Idle' and not pendingRequest and not modal end)
local function tapPull()
    if state~="Pulling" or not activity or activity.id==canceledActivity then return end
    local now=os.clock()
    if now-lastTap<C.pull.tapMinInterval+.02 then return end
    lastTap=now inputSeq+=1
    desiredTension=math.clamp(desiredTension+C.pull.tapImpulse,0,1)
    displayedTension=math.clamp(displayedTension+C.pull.tapImpulse,0,1)
    if tensionMarker then tensionMarker.Position=UDim2.new(displayedTension,-2,0,-4) end
    E.PullInput:FireServer({attemptId=activity.id,inputSeq=inputSeq,tap=true})
end
-- Compact currency only; the previous full-width title/status banner is removed.
local hud=make("Frame",gui,"HUD",{Size=UDim2.fromOffset(154,36),Position=UDim2.fromOffset(12,8),BackgroundColor3=Color3.fromRGB(247,238,218),BorderSizePixel=0}) round(hud,10)
local stats=label(hud,"Stats","…",UDim2.new(1,-20,1,0),UDim2.fromOffset(10,0),16,P.ink)
stats.TextXAlignment=Enum.TextXAlignment.Center
local navigation=nil local nav=nil
local context=button(gui,"Context",text("cast"),UDim2.fromOffset(240,52),UDim2.new(.5,-120,1,-134),function() end,P.water)
context.Visible=false
local function close(cancelActivity)
    if cancelActivity and activeActivityId and (state=="Aiming" or state=="Cleaning" or state=="Pulling" or state=="Casting" or state=="Searching" or state=="Revealing") then
        canceledActivity=activeActivityId request("Cancel",{activityId=activeActivityId})
    end
    spaceDown=false
    CastMeter.stop()
    if modal then modal:Destroy() end modal=nil body=nil page=nil inspectedExhibit=nil
    hud.Position=UDim2.fromOffset(12,8) hud.ZIndex=1
    if activityControls then activityControls:Destroy() activityControls=nil end
    tensionFill=nil progressFill=nil tensionMarker=nil activityTitle=nil activityHint=nil tapButton=nil cleaningInfo=nil
    for _,v in previews do v:Destroy() end previews={}
    Cleaner.stop()
end
local function panel(title,pageName)
    close(false) page=pageName
    modal,body=WindowTheme.window(gui,title,pageName,function() close(true) end)
    hud.Position=UDim2.new(1,-166,0,4) hud.ZIndex=8
    return body
end
local function list(parent,padding)
    make("UIListLayout",parent,"Layout",{Padding=UDim.new(0,padding or 10),SortOrder=Enum.SortOrder.LayoutOrder})
end
local function row(parent,height)
    local f=make("Frame",parent,"Row",{Size=UDim2.new(1,-8,0,height or 88),BackgroundColor3=Color3.fromRGB(229,221,207),BorderSizePixel=0}) round(f,10) return f
end
local function preview(parent,itemId,dirty,size,pos)
    local frame=make("ViewportFrame",parent,"Preview",{Size=size,Position=pos or UDim2.new(),BackgroundColor3=Color3.fromRGB(219,213,199),BorderSizePixel=0,
        Ambient=Color3.fromRGB(190,190,190),LightColor=Color3.new(1,1,1),LightDirection=Vector3.new(-1,-1,-1)}) round(frame)
    local world=make("WorldModel",frame,"World",{}) local model=Factory.create(itemId,dirty) model.Parent=world
    local camera=make("Camera",frame,"Camera",{}) camera.CFrame=CFrame.lookAt(Vector3.new(4,3.2,5.5),Vector3.new(0,1.2,0)) frame.CurrentCamera=camera
    table.insert(previews,frame) return frame
end
local function itemLabel(f)
    local def=C.itemsById[f.itemId]
    return def.name.."\n"..text(f.state=="Dirty" and "dirty" or "clean")..(f.displaySlot and (" · "..text("displayed",f.displaySlot)) or "")
end
local function windowOptions()
    return {profile=snapshot.profile,request=request,pending=updatePending,equipped=EquipmentUI.equipped,
        toggle=function() request('ToggleMagnet') end,
        slots=function(uid) selectedUid=uid openSlots(uid) end,
        sell=function(uid) openInventory(true,uid) end,
        upgrades=function() openShop(true) end}
end
openInventory=function(selling,uid)
    selling=selling==true
    if not snapshot then return end
    local b=panel((selling and 'Продажа' or 'Инвентарь')..' · '..count(snapshot.profile.finds)..' / '..C.inventoryCapacity,selling and 'sell' or 'inventory')
    local options=windowOptions() options.selectUid=uid
    Windows.inventory(b,options,selling) updatePending()
end
openFind=function(uid,confirmSell)
    selectedUid=uid openInventory(confirmSell==true,uid)
end
openSlots=function(uid)
    local b=panel(text("chooseSlot"),"slots") list(b)
    for slot=1,(snapshot.profile.expandedDisplay and 12 or 6) do
        local name=text("emptySlot") for _,f in snapshot.profile.finds do if f.displaySlot==slot then name=C.itemsById[f.itemId].name end end
        button(b,"Slot"..slot,text("slot",slot).." · "..name,UDim2.new(1,-8,0,52),nil,function() request("Place",{findUid=uid,slot=slot}) end,P.water)
    end
end
openJournal=function()
    if not snapshot then return end
    local b=panel('Коллекция · '..count(snapshot.profile.discovered)..' / '..#C.items..' видов','journal')
    Windows.collection(b,windowOptions())
end
openShop=function(upgrades)
    if not snapshot then return end
    local b=panel(upgrades and 'Улучшения' or 'Магазин',upgrades and 'upgrades' or 'shop')
    if upgrades then Windows.upgrades(b,windowOptions()) else Windows.shop(b,windowOptions()) end
    updatePending()
end
openWorkshops=function()
    local b=panel(text("workshops"),"workshops") list(b)
    for _,other in neighbors do
        local r=row(b,94)
        label(r,"Owner",text("owner",other.displayName,other.name).."\n"..text("discoveries",other.discovered),UDim2.new(1,-146,1,-8),UDim2.fromOffset(12,4),17)
        button(r,"Visit",text(other.userId==player.UserId and "home" or "visit"),UDim2.fromOffset(120,50),UDim2.new(1,-130,.5,-25),function()
            request(other.userId==player.UserId and "Home" or "Visit",{targetUserId=other.userId}) close(false)
        end,P.water)
    end
    if #neighbors<=1 then label(b,"Empty",text("noNeighbors"),UDim2.new(1,-8,0,66),nil,17) end
end
openSettings=function()
    if not snapshot then return end
    local b=panel('Настройки · Звук','settings')
    SettingsUI.render(b)
end
SettingsUI.init({open=openSettings,canSave=function() return snapshot~=nil and state=='Idle' and pendingRequest==nil end,
    save=function(value) return request('SetSettings',value) end})
local function startFishing(point)
    if state~="Idle" or not snapshot or pendingRequest then return end
    if not EquipmentUI.equipped() then notify(text("errEquipMagnet")) return end
    if not PierRules.contains(player.Character,point) then notify(text("errPier")) return end
    local required=C.zonesById[point:GetAttribute("ZoneId")].toolLevelRequired
    if snapshot.profile.toolLevel<required then notify(text("errLocked",required)) return end
    request("Cast",{pointId=point.Name})
end
local function showAim(view)
    close(false) page='aiming'
    context.Visible=false nearestContext=nil nav.Visible=false hud.Visible=false
    modal=CastMeter.show(gui,view,function(activityId,elapsed)
        if state=='Aiming' and not pendingRequest then request('ReleaseCast',{activityId=activityId,elapsed=elapsed}) else CastMeter.resume() end
    end,function() close(true) end)
end
showActivity=function()
    close(false) page="activity"
    modal=make("Frame",gui,"Modal",{Size=UDim2.new(.78,0,0,140),Position=UDim2.fromScale(.5,.32),AnchorPoint=Vector2.new(.5,.5),
        BackgroundColor3=P.ink,BackgroundTransparency=.62,BorderSizePixel=0,ZIndex=5}) round(modal,12)
    make("UISizeConstraint",modal,"Bounds",{MaxSize=Vector2.new(560,140)})
    activityTitle=label(modal,"Stage",text("casting"),UDim2.new(1,-114,0,42),UDim2.fromOffset(14,6),18,P.paper)
    local cancelButton=button(modal,"Close",text("cancel"),UDim2.fromOffset(90,48),UDim2.new(1,-100,0,6),function() close(true) end)
    cancelButton.BackgroundTransparency=.4
    local tbar=make("Frame",modal,"TensionBar",{Size=UDim2.new(1,-28,0,16),Position=UDim2.fromOffset(14,60),BackgroundColor3=P.red,BackgroundTransparency=.55,BorderSizePixel=0}) round(tbar,6)
    tensionFill=make("Frame",tbar,"Safe",{Size=UDim2.fromScale(.5,1),Position=UDim2.fromScale(.25,0),BackgroundColor3=P.green,BackgroundTransparency=.45,BorderSizePixel=0})
    tensionMarker=make("Frame",tbar,"Marker",{Size=UDim2.fromOffset(4,24),Position=UDim2.new(.5,-2,0,-4),BackgroundColor3=P.paper,BackgroundTransparency=.1,BorderSizePixel=0})
    local pbar=make("Frame",modal,"ProgressBar",{Size=UDim2.new(1,-28,0,12),Position=UDim2.fromOffset(14,88),BackgroundColor3=P.metal,BackgroundTransparency=.6,BorderSizePixel=0}) round(pbar,5)
    progressFill=make("Frame",pbar,"Fill",{Size=UDim2.fromScale(0,1),BackgroundColor3=P.water,BackgroundTransparency=.35,BorderSizePixel=0}) round(progressFill,5)
    activityHint=label(modal,"Hint",text("pullHelp"),UDim2.new(1,-28,0,30),UDim2.fromOffset(14,105),14,P.paper)
    activityControls=make("Frame",gui,"FishingControls",{Size=UDim2.fromOffset(240,56),Position=UDim2.new(.5,-120,1,-76),BackgroundTransparency=1})
    tapButton=button(activityControls,"Tap",text("tap"),UDim2.fromScale(1,1),nil,nil,P.water)
    tapButton.BackgroundTransparency=.25
    tapButton.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then tapPull() end end)
end
local function updateCleaning(view)
    Cleaner.update(view)
    if cleaningInfo then cleaningInfo.Text=text("cleanSide",view.side,math.floor((view.side==1 and view.progress1 or view.progress2)*100+.5)) end

end
showCleaning=function(view)
    close(false) page="cleaning"
    context.Visible=false nearestContext=nil nav.Visible=false hud.Visible=false
    modal=make("Frame",gui,"Modal",{Size=UDim2.new(.88,0,0,58),Position=UDim2.new(.5,0,0,4),AnchorPoint=Vector2.new(.5,0),BackgroundColor3=P.ink,BackgroundTransparency=.2,BorderSizePixel=0,ZIndex=5}) round(modal,12)
    make("UISizeConstraint",modal,"Bounds",{MaxSize=Vector2.new(660,58)})
    label(modal,"Heading",C.itemsById[view.itemId].name,UDim2.new(1,-116,0,24),UDim2.fromOffset(12,3),16,P.paper)
    cleaningInfo=label(modal,"CleaningProgress","",UDim2.new(1,-116,0,24),UDim2.fromOffset(12,29),14,P.gold)
    button(modal,"Close",text("cancel"),UDim2.fromOffset(90,48),UDim2.new(1,-98,0,5),function() close(true) end)
    activityControls=make("Frame",gui,"CleaningControls",{Size=UDim2.new(1,-24,0,34),Position=UDim2.new(0,12,1,-48),BackgroundTransparency=1})
    local hint=label(activityControls,"CleanHint",text("cleanSurfaceHint"),UDim2.new(1,0,0,28),nil,14,P.paper)
    hint.TextXAlignment=Enum.TextXAlignment.Center
    Cleaner.start(view) updateCleaning(view)
end
navigation=HudNavigation.create(gui,{activate=function(id)
    if state~="Idle" or not snapshot or pendingRequest then return end
    if id=="Inventory" then openInventory()
    elseif id=="Journal" then openJournal()
    elseif id=="Shop" then openShop()
    elseif id=="Upgrades" then openShop(true)
    elseif id=="Sell" then openInventory(true)
    elseif id=="Settings" then openSettings()
    elseif id=="Workshops" then openWorkshops()
    elseif id=="Home" then request("Home") close(false) end
end})
nav=navigation.root
context.Activated:Connect(function()
    if not nearestContext then return end
    local obj=nearestContext
    if obj:GetAttribute('PortalId') then return
    elseif obj.Parent.Name=="ZonePoints" then startFishing(obj)
    elseif obj.Name=="Bench" or obj.Name=="Buyer" then openInventory()
    elseif obj.Name=="Shop" then openShop()
    elseif obj.Name=="Visitors" then openWorkshops() end
end)
PromptService.PromptTriggered:Connect(function(prompt,who)
    if who and who~=player then return end
    if state~="Idle" then return end
    local obj=prompt.Parent
    if obj:GetAttribute('PortalId') then return
    elseif obj.Parent.Name=="ZonePoints" then startFishing(obj)
    elseif obj.Name=="Bench" then
        if obj.Parent:GetAttribute("OwnerUserId")~=player.UserId then notify(text("errGuest")) return end openInventory()
    elseif obj.Name=="Buyer" then openInventory()
    elseif obj.Name=="Shop" then openShop()
    elseif obj.Name=="Visitors" then openWorkshops()
    elseif obj:GetAttribute("Slot") then
        if obj:GetAttribute("ItemId") then E.InspectRequest:FireServer(obj:GetAttribute("OwnerUserId"),obj:GetAttribute("Slot"))
        elseif obj:GetAttribute("OwnerUserId")==player.UserId then openInventory() end
    end
end)
CAS:BindActionAtPriority("MagnetCast",function(_,inputState)
    if state=="Idle" and nearestContext and nearestContext.Parent.Name=="ZonePoints" and PierRules.contains(player.Character,nearestContext) then
        if inputState==Enum.UserInputState.Begin then startFishing(nearestContext) end
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end,false,3000,Enum.KeyCode.E)
CAS:BindActionAtPriority("MagnetPull",function(_,inputState)
    if inputState==Enum.UserInputState.End or inputState==Enum.UserInputState.Cancel then spaceDown=false end
    if state=="Pulling" and not UIS:GetFocusedTextBox() then
        if inputState==Enum.UserInputState.Begin and not spaceDown then spaceDown=true tapPull() end
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end,false,3000,Enum.KeyCode.Space)
CAS:BindActionAtPriority('MagnetRelease',function(_,inputState)
    if state=='Aiming' and page=='aiming' and not UIS:GetFocusedTextBox() then
        if inputState==Enum.UserInputState.Begin and not pendingRequest then CastMeter.confirm() end
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end,false,3100,Enum.KeyCode.Space,Enum.KeyCode.E)
UIS.InputBegan:Connect(function(input,processed)
    if input.KeyCode==Enum.KeyCode.Escape and modal then close(true) return end
    if input.KeyCode==Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
        if state=='Aiming' then CastMeter.confirm()
        elseif state=="Pulling" and not spaceDown then spaceDown=true tapPull() end
        return
    end
    if not processed and (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then
        if state=='Aiming' then CastMeter.confirm() else tapPull() end
    end

end)
UIS.InputEnded:Connect(function(input) if input.KeyCode==Enum.KeyCode.Space then spaceDown=false end end)
UIS.WindowFocusReleased:Connect(function() spaceDown=false end)
E.ProfileSnapshot.OnClientEvent:Connect(function(value)
    local old=state snapshot=value state=value.state seq=math.max(seq,value.lastActionSeq or 0)
    SettingsUI.profile(value.profile.settings)
    if state=="Idle" and pendingRequest and (value.lastActionSeq or 0)>=pendingRequest then pendingRequest=nil end
    activeActivityId=value.activityId
    if not activeActivityId then
        activity=nil canceledActivity=nil
        if presentationId then Presentation.finish(presentationId) presentationId=nil end
    end
    if value.cleaning then
        if page~="cleaning" then Presentation.releaseCamera() presentationId=nil showCleaning(value.cleaning) else updateCleaning(value.cleaning) end
    end
    if value.aiming and page~='aiming' then showAim(value.aiming) end
    if value.fishing then
        if page=='aiming' then close(false) end
        if presentationId~=value.fishing.id then Cleaner.stop(true) end
        presentationId=value.fishing.id Presentation.start(value.fishing) Presentation.update(value.fishing)
    end
    stats.Text=text("coins",value.profile.coins)
    if state=="Idle" and old~="Idle" then close(false)
    elseif state=="Idle" then
        if page=="journal" then openJournal() elseif page=="inventory" then openInventory() elseif page=="sell" then openInventory(true) elseif page=="upgrades" then openShop(true) elseif page=="find" then openFind(selectedUid) elseif page=="shop" then openShop() elseif page=="slots" then openInventory() end
    end
    updatePending()
end)
E.AttemptState.OnClientEvent:Connect(function(value)
    if value.id~=activeActivityId or value.id==canceledActivity then return end
    local previous=activity activity=value state=value.stage
    Presentation.update(value)
    if not previous or previous.id~=value.id then inputSeq=0 displayedTension=value.tension or .5 displayedProgress=0 desiredTension=displayedTension desiredProgress=0 end
    if value.cleaning then
        if page~="cleaning" then Presentation.releaseCamera() presentationId=nil showCleaning(value.cleaning) else updateCleaning(value.cleaning) end
    end
    if state=="Cleaning" then
        -- Surface painting runs on the physical item through Cleaner.
    elseif state=="Casting" or state=="Searching" or state=="Pulling" or state=="Revealing" then
        if page~="activity" then showActivity() end
        if activityTitle then
            activityTitle.Text=text(state=="Casting" and "casting" or state=="Searching" and "search" or state=="Revealing" and "caught" or state=="Pulling" and "pulling" or value.weightClass or "light")
            tapButton.Visible=state=="Pulling"
            if state=="Revealing" then desiredProgress=1 activityHint.Text=text("caught") end
            if state=="Pulling" then
                tensionFill.Position=UDim2.fromScale(value.greenMin,0) tensionFill.Size=UDim2.fromScale(value.greenMax-value.greenMin,1)
                desiredTension=value.tension desiredProgress=value.progress
                local safe=value.tension>=value.greenMin and value.tension<=value.greenMax
                activityHint.Text=text(safe and "safe" or "danger")
                tapButton.Text=text("tap") tapButton.BackgroundColor3=safe and P.water or P.red
            elseif state=="Searching" then
                desiredTension=.5 activityHint.Text=text("searching")
            end
        end
    end
end)
E.ActionResult.OnClientEvent:Connect(function(result)
    SettingsUI.result(result)
    if result.actionSeq==pendingRequest and result.status~="Pending" then pendingRequest=nil updatePending() end
    if result.code=="canceled" then canceledActivity=nil end
    if result.status=="Error" then
        if state=='Aiming' then CastMeter.resume() end
        notify(result.message or text(result.code or "errStale"))
    end
end)
E.Notice.OnClientEvent:Connect(notify)
E.Workshops.OnClientEvent:Connect(function(value)
    neighbors=value
    if inspectedExhibit then
        local ownerPresent=false for _,owner in value do if owner.userId==inspectedExhibit.ownerUserId then ownerPresent=true end end
        if not ownerPresent then close(false) end
    end
    if page=="workshops" then openWorkshops() end
end)
E.ExhibitCard.OnClientEvent:Connect(function(card)
    local def=C.itemsById[card.itemId] if not def then return end
    local b=panel(def.name,"exhibit")
    inspectedExhibit=card
    preview(b,card.itemId,false,UDim2.new(.4,-10,0,230))
    label(b,"Card",text("exhibitCard",def.name,card.displayName,card.name,C.zonesById[card.zoneId].name,def.weightKg,os.date("!%d.%m.%Y %H:%M",card.foundAt),card.discovered),UDim2.new(.58,-10,0,230),UDim2.new(.42,0,0,0),17)
    if card.ownerUserId==player.UserId then
        for _,f in snapshot.profile.finds do if f.displaySlot==card.slot then button(b,"Remove",text("remove"),UDim2.new(1,-8,0,52),UDim2.fromOffset(0,244),function() request("Remove",{findUid=f.uid}) close(false) end) break end end
    end
end)
E.Reveal.OnClientEvent:Connect(function(itemId)
    activity=nil
    notify(text("caught").."\n"..C.itemsById[itemId].name)
end)
E.FX.OnClientEvent:Connect(function(event)
    if event.kind=="Cast" then
        if event.userId==player.UserId then Cleaner.stop(true) end
        Presentation.start(event)
    elseif event.kind=="Update" then Presentation.update(event)
    elseif event.kind=="Caught" then Presentation.caught(event)
    elseif event.kind=="End" then Presentation.finish(event.id)
    elseif event.kind=="Sound" then Audio.play(event.cue) end
end)
EquipmentUI.init(gui,{
    canToggle=function() return state=="Idle" and pendingRequest==nil end,
    showHotbar=function() return state=="Idle" and pendingRequest==nil and modal==nil end,
    toggle=function() request("ToggleMagnet") end,
})
local contextClock=0
RunService.RenderStepped:Connect(function(dt)
    contextClock+=dt
    if tensionMarker and progressFill then
        if state=="Pulling" then desiredTension=math.clamp(desiredTension-C.pull.driftRate*dt,0,1) end
        local alpha=1-math.exp(-dt*24)
        displayedTension+=(desiredTension-displayedTension)*alpha displayedProgress+=(desiredProgress-displayedProgress)*alpha
        tensionMarker.Position=UDim2.new(displayedTension,-2,0,-4) progressFill.Size=UDim2.fromScale(displayedProgress,1)
    end
    if contextClock>=.1 then
        contextClock=0
        if state=="Idle" and not modal and snapshot and not pendingRequest then
            local char=player.Character local r=char and char:FindFirstChild("HumanoidRootPart")
            local nearest,distance=nil,10
            local world=workspace:FindFirstChild("MagnetWorld")
            local points=world and world:FindFirstChild("ZonePoints")
            local plots=world and world:FindFirstChild("Plots")
            local plaza=world and world:FindFirstChild("Plaza")
            if r and points then
                for _,p in points:GetChildren() do if p:IsA("BasePart") and p:GetAttribute("ZoneId") then local d=p:GetAttribute('FishArea') and 1 or (r.Position-p.Position).Magnitude if EquipmentUI.equipped() and PierRules.contains(char,p) and (not nearest or d<distance) then nearest=p distance=d end end end
                local own=plots and plots:FindFirstChild(string.format("Plot%02d",snapshot.plotId))
                local candidates={}
                if own and own:FindFirstChild("Bench") then table.insert(candidates,own.Bench) end
                if plaza then for _,name in {"Buyer","Shop","Visitors"} do local p=plaza:FindFirstChild(name) if p then table.insert(candidates,p) end end end
                local hub=world:FindFirstChild('PortalHub')
                if hub and hub:FindFirstChild('Portals') then for _,m in hub.Portals:GetChildren() do  end end
                local biomes=world:FindFirstChild('Biomes')
                if biomes then for _,m in biomes:GetChildren() do  end end
                for _,p in candidates do local d=(r.Position-p.Position).Magnitude if d<distance then nearest=p distance=d end end
            end
            nearestContext=nearest context.Visible=nearest~=nil
            if nearest then context.Text=text(nearest:GetAttribute('PortalId') and 'portalChoose' or nearest.Parent.Name=="ZonePoints" and "cast" or nearest.Name=="Bench" and "cleanAction" or nearest.Name=="Buyer" and "sellAction" or nearest.Name=="Shop" and "shop" or "workshops") end
        else context.Visible=false end
        nav.Visible=(state=="Idle" or state=="Loading") and modal==nil
        navigation.refresh(page,state=="Idle" and snapshot~=nil and pendingRequest==nil)
        hud.Visible=state=="Idle" or state=="Loading"
        if inspectedExhibit then
            local world=workspace:FindFirstChild("MagnetWorld") local plots=world and world:FindFirstChild("Plots")
            local valid=false
            if plots then for _,plot in plots:GetChildren() do
                if plot:GetAttribute("OwnerUserId")==inspectedExhibit.ownerUserId then
                    local slots=plot:FindFirstChild("Slots") local base=slots and slots:FindFirstChild(tostring(inspectedExhibit.slot))
                    valid=base and base:GetAttribute("ItemId")==inspectedExhibit.itemId
                end
            end end
            if not valid then close(false) end
        end
    end
end)
player.CharacterAdded:Connect(function() Presentation.reset() Cleaner.stop(true) Audio.resetActions() close(false) activity=nil spaceDown=false presentationId=nil end)
-- Retry handshake protects against the initial snapshot arriving before the LocalScript subscribes.
task.spawn(function() for _=1,12 do if snapshot then break end E.ActionRequest:FireServer({action="Sync"}) task.wait(1) end end)
print("[MagnetWorkshop] Client ready")
