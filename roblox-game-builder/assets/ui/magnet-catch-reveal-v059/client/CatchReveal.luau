-- Center reveal -> rarity glow -> flight to the real inventory button.
-- Presentation only; the server has already committed this exact UID.
local RunService=game:GetService('RunService')
local S=game.ReplicatedStorage.MagnetWorkshop.Shared
local C=require(S.Config) local Catalog=require(S.ItemCatalog) local Rarities=require(S.RarityCatalog)
local Timeline=require(S.RevealTimeline) local Factory=require(S.FindFactory)
local T=require(script.Parent.WindowTheme) local Icons=require(script.Parent.HudIcons)
local A={} A.__index=A
function A.new(parent,options)
 return setmetatable({parent=parent,options=options or {},queue={},queued={},current=nil,generation=0},A)
end
function A:isBusy() return self.current~=nil or #self.queue>0 end
function A:_complete(canceled)
 local current=self.current if not current then return end
 self.current=nil self.generation+=1 self.queued[current.receipt.uid]=nil
 if self.connection then self.connection:Disconnect() self.connection=nil end
 if current.root then current.root:Destroy() end self.root=nil
 if self.options.finished then self.options.finished(current.receipt,canceled==true) end
 self:_next()
end
function A:reset()
 local receipts={} if self.current then table.insert(receipts,self.current.receipt) end
 for _,receipt in self.queue do table.insert(receipts,receipt) end
 self.current=nil self.queue={} self.queued={} self.generation+=1
 if self.connection then self.connection:Disconnect() self.connection=nil end
 if self.root then self.root:Destroy() self.root=nil end
 for _,receipt in receipts do if self.options.finished then self.options.finished(receipt,true) end end
end
function A:play(receipt)
 if type(receipt)~='table' or receipt.committed~=true or type(receipt.uid)~='string' or self.queued[receipt.uid] then return false end
 if #self.queue>=4 then if self.options.finished then self.options.finished(receipt,true) end return false end
 self.queued[receipt.uid]=true table.insert(self.queue,receipt) self:_next() return true
end
function A:_next()
 if self.current or #self.queue==0 then return end
 local receipt=table.remove(self.queue,1) local definition=Catalog.byId[receipt.itemId]
 if not definition or not C.itemsById[receipt.itemId] then
  self.queued[receipt.uid]=nil if self.options.finished then self.options.finished(receipt,true) end self:_next() return
 end
 local ok,model=pcall(Factory.create,receipt.itemId,receipt.state~='Clean')
 if not ok or not model then
  warn('[CatchReveal] Model unavailable: '..tostring(receipt.itemId))
  self.queued[receipt.uid]=nil if self.options.finished then self.options.finished(receipt,true) end self:_next() return
 end
 local rarity=Rarities.get(definition.rarity)
 local root=T.make('Frame',self.parent,'CatchReveal',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=20})
 self.root=root self.current={receipt=receipt,root=root} self.generation+=1 local token=self.generation
 local shade=T.make('Frame',root,'Shade',{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(15,31,38),BackgroundTransparency=1,BorderSizePixel=0})
 local glow=T.make('Frame',root,'Glow',{AnchorPoint=Vector2.new(.5,.5),BackgroundTransparency=1}) local rings={}
 for i=1,14 do
  local f=T.make('Frame',glow,'Halo'..i,{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromScale(1.55-i*.045,1.55-i*.045),BackgroundColor3=rarity.color,BackgroundTransparency=1,BorderSizePixel=0})
  T.make('UICorner',f,'Round',{CornerRadius=UDim.new(.5,0)}) rings[i]=f
 end
 local viewport=T.make('ViewportFrame',root,'Find',{BackgroundTransparency=1,AnchorPoint=Vector2.new(.5,.5),Ambient=Color3.fromRGB(205,211,211),LightColor=Color3.fromRGB(255,247,229),LightDirection=Vector3.new(-1,-1,-2)})
 local world=T.make('WorldModel',viewport,'World',{}) model.Parent=world
 local box,size=model:GetBoundingBox() local base=CFrame.new(-box.Position)*model:GetPivot() model:PivotTo(base)
 local camera=T.make('Camera',viewport,'Camera',{FieldOfView=35}) viewport.CurrentCamera=camera
 local radius=math.max(size.Magnitude/2,.2) local distance=radius/math.sin(math.rad(17.5))*1.12
 camera.CFrame=CFrame.lookAt(Vector3.new(0,radius*.15,-distance),Vector3.zero)
 local name=T.label(root,'ItemName',definition.name,UDim2.fromOffset(500,54),nil,25,true,T.paper) name.AnchorPoint=Vector2.new(.5,0) name.TextXAlignment=Enum.TextXAlignment.Center
 local badge=T.label(root,'Rarity',rarity.name,UDim2.fromOffset(250,24),nil,16,true,rarity.color) badge.AnchorPoint=Vector2.new(.5,0) badge.TextXAlignment=Enum.TextXAlignment.Center
 local stateLabel=T.label(root,'State',receipt.state=='Clean' and 'Очищенная находка' or 'Ржавая находка',UDim2.fromOffset(250,22),nil,12,false,T.paper) stateLabel.AnchorPoint=Vector2.new(.5,0) stateLabel.TextXAlignment=Enum.TextXAlignment.Center
 local dock=T.make('ImageLabel',root,'InventoryDock',{Image=Icons.inventory,BackgroundTransparency=1,AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(50,50),ImageTransparency=1})
 local start=os.clock() if self.options.started then self.options.started(receipt) end
 local function draw()
  if token~=self.generation then return end
  if not root.Parent then self:_complete(true) return end
  local q=Timeline.sample(os.clock()-start,rarity.holdExtra,self.options.reducedMotion)
  if q.stage=='done' then self:_complete(false) return end
  local screen=self.parent.AbsoluteSize local small=screen.Y<400
  local diameter=math.max(60,math.min(screen.X*.58,screen.Y*.48,(screen.Y-126)/1.32,small and 210 or 340))
  local center=Vector2.new(screen.X*.5,math.min(screen.Y*.42,screen.Y-(diameter*.49+114)))
  local destination=Vector2.new(42,screen.Y*.5)
  local target=self.options.inventoryTarget and self.options.inventoryTarget()
  if target and target.Parent then destination=target.AbsolutePosition-self.parent.AbsolutePosition+target.AbsoluteSize/2 end
  local u=q.travel local control=(center+destination)/2+Vector2.new(0,-math.min(100,screen.Y*.18))
  local pos=center*(1-u)^2+control*(2*(1-u)*u)+destination*u*u
  viewport.Position=UDim2.fromOffset(pos.X,pos.Y) viewport.Size=UDim2.fromOffset(diameter*q.scale,diameter*q.scale) viewport.ImageTransparency=1-q.alpha
  model:PivotTo(CFrame.Angles(0,math.rad(q.spin),0)*base)
  glow.Position=viewport.Position glow.Size=UDim2.fromOffset(diameter*q.scale,diameter*q.scale)
  for i,f in rings do f.BackgroundTransparency=1-(.012+i*.0025)*q.glow end
  shade.BackgroundTransparency=1-.42*q.glow
  local textAlpha=(q.stage=='fly' or q.stage=='settle') and 0 or q.alpha
  name.Size=UDim2.fromOffset(math.min(520,screen.X-28),54) name.TextSize=small and 18 or 25
  name.Position=UDim2.fromOffset(center.X,center.Y+diameter*.49)
  badge.Position=UDim2.fromOffset(center.X,name.Position.Y.Offset+name.Size.Y.Offset+2)
  stateLabel.Position=UDim2.fromOffset(center.X,badge.Position.Y.Offset+24)
  name.TextTransparency=1-textAlpha badge.TextTransparency=1-textAlpha stateLabel.TextTransparency=1-textAlpha
  dock.Position=UDim2.fromOffset(destination.X,destination.Y) dock.ImageTransparency=(q.stage=='fly' or q.stage=='settle') and .15 or 1
  local pulse=q.pulse or 0 dock.Size=UDim2.fromOffset(50+8*pulse,50+8*pulse)
 end
 draw() if self.current then self.connection=RunService.RenderStepped:Connect(draw) end
 -- Also release the UI hold when rendering is paused or the window is hidden.
 task.delay(Timeline.duration(rarity.holdExtra)+.8,function() if token==self.generation and self.current then self:_complete(false) end end)
end
return A
