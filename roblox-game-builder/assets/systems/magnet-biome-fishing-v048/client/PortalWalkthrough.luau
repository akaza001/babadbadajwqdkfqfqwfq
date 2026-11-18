local P={}
function P.start(gui,request,available)
 local screen=Instance.new('Frame') screen.Name='PortalLoading' screen.Size=UDim2.fromScale(1,1) screen.BackgroundColor3=Color3.fromRGB(25,48,55) screen.ZIndex=100 screen.Visible=false screen.Parent=gui
 local text=Instance.new('TextLabel') text.Name='Title' text.Size=UDim2.new(1,-40,0,100) text.Position=UDim2.new(0,20,.5,-50) text.BackgroundTransparency=1 text.Font=Enum.Font.GothamBold text.TextSize=24 text.TextColor3=Color3.fromRGB(242,234,214) text.TextWrapped=true text.ZIndex=101 text.Parent=screen
 local active=nil local entered={} local cooldown=0 local timer=0
 game.ReplicatedStorage.MagnetWorkshop.Remotes.ActionResult.OnClientEvent:Connect(function(result)
  if active and result.actionSeq==active and result.status~='Pending' then
   active=nil task.delay(.35,function() if not active then screen.Visible=false end end)
  end
 end)
 game.Players.LocalPlayer.CharacterAdded:Connect(function() active=nil screen.Visible=false entered={} end)
 game:GetService('RunService').Heartbeat:Connect(function(dt)
  timer+=dt if timer<.1 then return end timer=0
  local char=game.Players.LocalPlayer.Character local root=char and char:FindFirstChild('HumanoidRootPart') local world=workspace:FindFirstChild('MagnetWorld')
  if not root or not world then return end
  local markers={}
  local hub=world:FindFirstChild('PortalHub') local portals=hub and hub:FindFirstChild('Portals')
  if portals then for _,m in portals:GetChildren() do local p=m:FindFirstChild('PortalPoint') if p then table.insert(markers,p) end end end
  local biomes=world:FindFirstChild('Biomes')
  if biomes then for _,m in biomes:GetChildren() do local p=m:FindFirstChild('ReturnPoint') if p then table.insert(markers,p) end end end
  for _,p in markers do
   local v=p.CFrame:PointToObjectSpace(root.Position)
   local returning=p:GetAttribute('PortalId')=='HUB'
   local inside=math.abs(v.X)<(returning and 2.5 or 3.8) and math.abs(v.Z+(returning and 0 or 2.4))<1.5 and math.abs(v.Y)<4
   local was=entered[p] entered[p]=inside
   if inside and not was and not active and os.clock()>cooldown and available() then
    cooldown=os.clock()+3 text.Text='Загрузка озера…' screen.Visible=true
    active=request('EnterPortal',{portalId=p:GetAttribute('PortalId')})
    if not active then screen.Visible=false end
   end
  end
 end)
end
return P
