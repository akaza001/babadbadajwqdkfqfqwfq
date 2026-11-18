-- One local mixer. Audio never decides rewards, progress or save results.
local Players=game:GetService('Players')
local RunService=game:GetService('RunService')
local SoundService=game:GetService('SoundService')
local ContentProvider=game:GetService('ContentProvider')
local Catalog=require(game.ReplicatedStorage.MagnetWorkshop.Shared.AudioCatalog)
local player=Players.LocalPlayer
local A={}
local old=SoundService:FindFirstChild('MagnetWorkshopAudio') if old then old:Destroy() end
local root=Instance.new('Folder') root.Name='MagnetWorkshopAudio' root.Parent=SoundService
local library=Instance.new('Folder') library.Name='Library' library.Parent=root
local emitters=Instance.new('Folder') emitters.Name='MagnetAudioEmitters' emitters.Parent=workspace
local groups={}
for _,name in {'sfx','ambience','music'} do
    local g=Instance.new('SoundGroup') g.Name=name g.Volume=0 g.Parent=root groups[name]=g
end
local templates={}
for key,cue in Catalog.cues do
    local s=Instance.new('Sound') s.Name=key s.SoundId='rbxassetid://'..cue.id s.Volume=cue.volume
    s.PlaybackSpeed=cue.speed or 1 s.SoundGroup=groups[cue.group or 'sfx'] s.Parent=library templates[key]=s
end
-- Loading runs outside the gameplay path; a missing file cannot block the game.
task.spawn(function()
    local list={} for _,s in templates do table.insert(list,s) end
    local ok=pcall(function() ContentProvider:PreloadAsync(list,function(id,status)
        for _,s in templates do if s.SoundId==id then s:SetAttribute('LoadStatus',status.Name) end end
    end) end)
    root:SetAttribute('PreloadFinished',true) root:SetAttribute('PreloadSucceeded',ok)
end)
local settings=nil
local voices={} local loops={} local fishing={}
local lastBrushAt=-math.huge
local cueCount=0
local function characterRoot()
    return player.Character and player.Character:FindFirstChild('HumanoidRootPart')
end
local function distance(position)
    local r=characterRoot() return r and (position-r.Position).Magnitude or math.huge
end
local function stopVoice(voice)
    if not voice or not voices[voice] then return end
    if voice.ended then voice.ended:Disconnect() end
    voice.sound:Stop() voice.sound:Destroy()
    if voice.emitter then voice.emitter:Destroy() end
    voices[voice]=nil
end
local function capacity(remote)
    local count=0 local oldest=nil
    for v in voices do
        if v.group=='sfx' then count+=1 if not v.looped and (not oldest or (v.remote and not oldest.remote) or v.remote==oldest.remote and v.started<oldest.started) then oldest=v end end
    end
    if count<Catalog.maxVoices then return true end
    if oldest and (oldest.remote or not remote) then stopVoice(oldest) return true end
    return false
end
local function spawnVoice(key,looped,position,remote)
    local cue=Catalog.cues[key] if not cue then return nil end
    local group=cue.group or 'sfx'
    if group=='sfx' and (not settings or not settings.sfx or settings.sfxVolume<=0 or remote and position and distance(position)>Catalog.remoteDistance or not capacity(remote)) then return nil end
    local parent=root local emitter=nil
    if position then
        emitter=Instance.new('Part') emitter.Name=key emitter.Size=Vector3.new(.1,.1,.1) emitter.Transparency=1
        emitter.Anchored=true emitter.CanCollide=false emitter.CanTouch=false emitter.CanQuery=false emitter.Position=position emitter.Parent=emitters parent=emitter
    end
    local sound=templates[key]:Clone() sound.Name='Playing_'..key sound.Looped=looped
    sound.RollOffMinDistance=5 sound.RollOffMaxDistance=Catalog.remoteDistance sound.RollOffMode=Enum.RollOffMode.Linear
    local voice={sound=sound,emitter=emitter,key=key,group=group,remote=remote,looped=looped,started=os.clock(),base=cue.volume*(remote and .3 or 1),gain=looped and 0 or 1}
    sound.Volume=voice.base*voice.gain sound.Parent=parent voices[voice]=true
    if not looped then
        voice.ended=sound.Ended:Connect(function() stopVoice(voice) end)
        task.delay(cue.seconds or 5,function() if voices[voice] then stopVoice(voice) end end)
    end
    sound:Play() root:SetAttribute('Played_'..key,(root:GetAttribute('Played_'..key) or 0)+1) cueCount+=1 root:SetAttribute('CueCount',cueCount) root:SetAttribute('LastCue',key)
    return voice
end
function A.play(key,position,remote)
    return spawnVoice(key,false,position,remote==true)
end
function A.loop(scope,key,active,position,remote)
    local v=loops[scope]
    if v and (v.key~=key or not voices[v]) then stopVoice(v) loops[scope]=nil v=nil end
    if not active then if v then v.fading=true loops[scope]=nil end return end
    if not v then v=spawnVoice(key,true,position,remote==true) loops[scope]=v end
    if v then v.fading=false if position and v.emitter then v.emitter.Position=position end end
end
function A.apply(value)
    settings={}
    for k,default in Catalog.defaults do settings[k]=value and value[k]~=nil and value[k] or default end
    -- Explicit false values must survive merging with defaults.
    for _,k in {'music','sfx','ambience'} do if value and value[k]==false then settings[k]=false end end
    groups.sfx.Volume=settings.sfx and settings.sfxVolume or 0
    groups.ambience.Volume=settings.ambience and settings.ambienceVolume or 0
    groups.music.Volume=settings.music and settings.musicVolume or 0
    for _,key in {'music','water','wind'} do
        local group=Catalog.cues[key].group
        A.loop('background:'..key,key,settings[group] and settings[group..'Volume']>0)
    end
    if not settings.sfx or settings.sfxVolume==0 then
        for v in voices do if v.group=='sfx' then stopVoice(v) end end
        for scope,v in loops do if v.group=='sfx' then loops[scope]=nil end end
    end
end
function A.fishing(effect,phase)
    local id=effect.id local own=effect.userId==player.UserId
    local state=fishing[id]
    if not state then state={phase=nil} fishing[id]=state end
    local position=not own and effect.root.Position or nil
    if state.phase~=phase then
        if phase=='Flight' then A.play('cast',position,not own)
        elseif phase=='CameraReturn' and state.phase=='Flight' then A.play('splash',not own and effect.target or nil,not own)
        elseif phase=='Pulling' then A.play('hook',position,not own)
        elseif phase=='Revealing' and own then A.play('reward') end
        state.phase=phase
    end
    local pulling=phase=='Pulling'
    A.loop('pull:'..id,'pull',pulling,position,not own)
    local danger=own and pulling and effect.tension~=nil and (effect.tension<(effect.greenMin or .25) or effect.tension>(effect.greenMax or .75))
    A.loop('strain:'..id,'strain',danger)
end
function A.stopFishing(id)
    fishing[id]=nil
    A.loop('pull:'..id,'pull',false) A.loop('strain:'..id,'strain',false)
end
function A.brush(id,active)
    if active then lastBrushAt=os.clock() end
    A.loop('brush','brush',active)
    root:SetAttribute('BrushActive',active==true) root:SetAttribute('CleaningId',active and id or nil)
end
function A.resetActions()
    for id in fishing do A.stopFishing(id) end
    A.brush(nil,false)
    for v in voices do if v.group=='sfx' then stopVoice(v) end end
end
RunService.Heartbeat:Connect(function(dt)
    local rootPart=characterRoot()
    local lake=workspace:FindFirstChild('MagnetWorld') and workspace.MagnetWorld:FindFirstChild('Lake')
    local waterGain=0
    if rootPart and lake then
        local p=lake.CFrame:PointToObjectSpace(rootPart.Position)
        local x=math.max(math.abs(p.X)-lake.Size.X/2,0) local z=math.max(math.abs(p.Z)-lake.Size.Z/2,0)
        waterGain=math.clamp(1-math.sqrt(x*x+z*z)/70,0,1)
    end
    for v in voices do
        if not v.sound.Parent then stopVoice(v)
        elseif v.looped then
            local target=v.fading and 0 or v.key=='water' and waterGain or 1
            if v.remote and v.emitter and distance(v.emitter.Position)>Catalog.remoteDistance then target=0 end
            v.gain+=(target-v.gain)*(1-math.exp(-dt*9)) v.sound.Volume=v.base*v.gain
            if v.fading and v.gain<.01 then stopVoice(v) end
        end
    end
    -- A background Studio window can stop rendering; brushing must still stop.
    if loops.brush and os.clock()-lastBrushAt>.25 then A.brush(nil,false) end
    local count=0 for v in voices do if v.group=='sfx' then count+=1 end end root:SetAttribute('EffectVoices',count)
end)
return A
