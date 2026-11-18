-- Walk through the portal: authoritative request, loading feedback, then confirmed arrival.
local T=require(script.Parent.WindowTheme)
local Biomes=require(game.ReplicatedStorage.MagnetWorkshop.Shared.BiomeCatalog)
local Geometry=require(game.ReplicatedStorage.MagnetWorkshop.Shared.PortalGeometry)
local P={version='0.5.2'}
local Artwork={["BIO-05"]="rbxassetid://90675663316251",["BIO-06"]="rbxassetid://83549839125621",["BIO-04"]="rbxassetid://106912476806299",["BIO-01"]="rbxassetid://119094810829554",["BIO-10"]="rbxassetid://78126862362776",["BIO-02"]="rbxassetid://112514686902340",["BIO-03"]="rbxassetid://97144854834957",["BIO-07"]="rbxassetid://76402960587520",["BIO-08"]="rbxassetid://132260787383852"}
local controllers=setmetatable({},{__mode='k'})
function P.start(gui,request,available)
 if controllers[gui] then return controllers[gui] end
 local connections={} local api={stopped=false} controllers[gui]=api
 local owner=gui:IsA('ScreenGui') and gui or gui:FindFirstAncestorOfClass('ScreenGui')
 local layer=Instance.new('ScreenGui') layer.Name='MagnetPortalLoading' layer.ResetOnSpawn=false layer.IgnoreGuiInset=true layer.ScreenInsets=Enum.ScreenInsets.None layer.DisplayOrder=100 layer.ZIndexBehavior=Enum.ZIndexBehavior.Sibling layer.Parent=owner.Parent
 local screen=T.make('Frame',layer,'PortalLoading',{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(25,48,55),BorderSizePixel=0,ZIndex=100,Visible=false,Active=true})
 local artwork=T.make('ImageLabel',screen,'Artwork',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ImageRectOffset=Vector2.zero,ImageRectSize=Vector2.new(1672,650),ScaleType=Enum.ScaleType.Crop,ZIndex=1})
 task.spawn(function() local images={} for _,id in Artwork do table.insert(images,id) end pcall(function() game:GetService('ContentProvider'):PreloadAsync(images) end) end)
 local card=T.frame(screen,'Card',UDim2.new(1,-32,0,176),UDim2.new(.5,0,1,-20)) card.AnchorPoint=Vector2.new(.5,1) card.ZIndex=2
 T.make('UISizeConstraint',card,'Bounds',{MaxSize=Vector2.new(680,176)})
 T.label(card,'Stage','ПЕРЕХОД',UDim2.new(1,-32,0,22),UDim2.fromOffset(16,14),12,true,T.teal)
 local title=T.label(card,'Title','',UDim2.new(1,-32,0,56),UDim2.fromOffset(16,38),24,true)
 local status=T.label(card,'Status','',UDim2.new(1,-32,0,36),UDim2.fromOffset(16,96),15)
 local line=T.make('Frame',card,'Track',{Size=UDim2.new(1,-32,0,5),Position=UDim2.new(0,16,1,-22),BackgroundColor3=T.tan,BackgroundTransparency=.55,BorderSizePixel=0})
 T.make('UICorner',line,'Round',{CornerRadius=UDim.new(1,0)})
 local progress=T.make('Frame',line,'Motion',{Size=UDim2.new(.24,0,1,0),BackgroundColor3=T.teal,BorderSizePixel=0})
 T.make('UICorner',progress,'Round',{CornerRadius=UDim.new(1,0)})
 local active=nil local entered={} local cooldown=0 local timer=0 local loadingAt=0
 connections.result=game.ReplicatedStorage.MagnetWorkshop.Remotes.ActionResult.OnClientEvent:Connect(function(result)
  if active and result.actionSeq==active and result.status~='Pending' then
   active=nil status.Text=result.status=='Ok' and 'Готово' or 'Переход не выполнен'
   task.delay(.35,function() if screen.Parent and not active then screen.Visible=false end end)
  end
 end)
 connections.character=game.Players.LocalPlayer.CharacterAdded:Connect(function() active=nil screen.Visible=false entered={} end)
 connections.heartbeat=game:GetService('RunService').Heartbeat:Connect(function(dt)
  if screen.Visible and active then
   progress.Position=UDim2.fromScale((.5-.5*math.cos((os.clock()-loadingAt)*3))*.76,0)
  end
  timer+=dt if timer<.1 then return end timer=0
  local char=game.Players.LocalPlayer.Character local root=char and char:FindFirstChild('HumanoidRootPart') local world=workspace:FindFirstChild('MagnetWorld')
  if not root or not world then return end
  local markers={}
  local hub=world:FindFirstChild('PortalHub') local portals=hub and hub:FindFirstChild('Portals')
  if portals then for _,m in portals:GetChildren() do local p=m:FindFirstChild('PortalPoint') if p then table.insert(markers,p) end end end
  local biomes=world:FindFirstChild('Biomes')
  if biomes then for _,m in biomes:GetChildren() do local p=m:FindFirstChild('ReturnPoint') if p then table.insert(markers,p) end end end
  for _,p in markers do
   local returning=p:GetAttribute('PortalId')=='HUB'
   local inside=Geometry.contains(p,root.Position)
   local was=entered[p] if not inside then entered[p]=nil end
   if inside and not was and not active and os.clock()>cooldown and available() then
    entered[p]=true cooldown=os.clock()+3 loadingAt=os.clock()
    local destination=Biomes.byId[returning and 'BIO-01' or p:GetAttribute('PortalId')]
    artwork.Image=destination and Artwork[destination.id] or Artwork['BIO-01']
    title.Text=destination and destination.name or 'Площадь порталов'
    status.Text='Подготавливаем озеро…' screen.Visible=true
    active=request('EnterPortal',{portalId=p:GetAttribute('PortalId')})
    if not active then entered[p]=nil screen.Visible=false end
   end
  end
 end)
 function api.stop()
  if api.stopped then return end api.stopped=true active=nil controllers[gui]=nil
  for _,connection in connections do connection:Disconnect() end
  layer:Destroy()
 end
 connections.destroy=gui.Destroying:Connect(api.stop)
 api.root=screen return api
end
return P
