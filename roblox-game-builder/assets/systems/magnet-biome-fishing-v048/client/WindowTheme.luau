-- Native, scalable surfaces from the approved window references; no baked text.
local T={version='0.4.5',paper=Color3.fromRGB(247,238,218),card=Color3.fromRGB(249,239,218),ink=Color3.fromRGB(45,70,75),teal=Color3.fromRGB(35,150,156),tan=Color3.fromRGB(195,163,120),green=Color3.fromRGB(192,222,167),muted=Color3.fromRGB(113,116,110),amber=Color3.fromRGB(250,216,145)}
local Icons=require(script.Parent.HudIcons)
function T.make(class,parent,name,props)
 local v=Instance.new(class) v.Name=name for k,x in props or {} do v[k]=x end v.Parent=parent return v
end
function T.surface(v,kind)
 v.BorderSizePixel=0
 T.make('UICorner',v,'Round',{CornerRadius=UDim.new(0,kind=='window' and 18 or 12)})
 T.make('UIStroke',v,'Edge',{Color=T.tan,Thickness=kind=='window' and 2 or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Transparency=.16})
 T.make('UIGradient',v,'Finish',{Rotation=90,Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(239,222,193))})
 T.make('Frame',v,'Sheen',{Size=UDim2.new(1,-20,0,1),Position=UDim2.fromOffset(10,2),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=.38,BorderSizePixel=0})
 return v
end
function T.frame(parent,name,size,pos)
 return T.surface(T.make('Frame',parent,name,{Size=size,Position=pos or UDim2.new(),BackgroundColor3=T.card}))
end
function T.label(parent,name,value,size,pos,fontSize,bold,color)
 return T.make('TextLabel',parent,name,{Text=value,Size=size,Position=pos or UDim2.new(),BackgroundTransparency=1,TextColor3=color or T.ink,Font=bold and Enum.Font.GothamBold or Enum.Font.GothamMedium,TextSize=fontSize or 16,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left})
end
function T.button(parent,name,value,size,pos,callback,available,server)
 local b=T.make('TextButton',parent,name,{Text=value,Size=size,Position=pos or UDim2.new(),BackgroundColor3=available==false and Color3.fromRGB(167,172,169) or T.teal,TextColor3=available==false and T.ink or Color3.fromRGB(255,251,240),Font=Enum.Font.GothamBold,TextSize=15,TextWrapped=true,BorderSizePixel=0,AutoButtonColor=true,Interactable=available~=false})
 T.surface(b,'button') b:SetAttribute('ActionAvailable',available~=false) if server then b:SetAttribute('ServerAction',true) end
 if callback then b.Activated:Connect(function() if b:GetAttribute('ActionAvailable')~=false then callback() end end) end
 return b
end
function T.enabled(b,available)
 b:SetAttribute('ActionAvailable',available) b.Interactable=available b.BackgroundColor3=available and T.teal or Color3.fromRGB(167,172,169)
end
function T.list(parent,gap)
 return T.make('UIListLayout',parent,'Layout',{Padding=UDim.new(0,gap or 8),SortOrder=Enum.SortOrder.LayoutOrder})
end
function T.scroll(parent,name,size,pos)
 return T.make('ScrollingFrame',parent,name,{Size=size,Position=pos or UDim2.new(),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,ScrollBarImageColor3=T.teal,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ClipsDescendants=true})
end
function T.window(parent,title,page,close)
 local shade=T.make('Frame',parent,'WindowShade',{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(32,44,43),BackgroundTransparency=.8,BorderSizePixel=0,ZIndex=4,Active=true})
 local modal=T.surface(T.make('Frame',parent,'Modal',{Size=UDim2.new(1,-28,1,-72),Position=UDim2.fromScale(.5,.52),AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=T.paper,ZIndex=5}),'window')
 T.make('UISizeConstraint',modal,'Bounds',{MaxSize=Vector2.new(1120,740),MinSize=Vector2.new(280,190)}) modal:SetAttribute('Page',page)
 local shadow=T.make('Frame',parent,'WindowShadow',{Size=modal.Size,Position=modal.Position+UDim2.fromOffset(0,4),AnchorPoint=modal.AnchorPoint,BackgroundColor3=Color3.fromRGB(72,54,31),BackgroundTransparency=.6,BorderSizePixel=0,ZIndex=4})
 T.make('UICorner',shadow,'Round',{CornerRadius=UDim.new(0,18)}) T.make('UISizeConstraint',shadow,'Bounds',{MaxSize=Vector2.new(1120,740),MinSize=Vector2.new(280,190)})
 modal.Destroying:Connect(function() if shade.Parent then shade:Destroy() end if shadow.Parent then shadow:Destroy() end end)
 local key=({inventory='inventory',find='inventory',journal='collection',shop='shop',upgrades='upgrades',sell='sell',settings='settings'})[page]
 if key then T.make('ImageLabel',modal,'PageIcon',{Image=Icons[key],BackgroundTransparency=1,Position=UDim2.fromOffset(12,6),Size=UDim2.fromOffset(44,44),ScaleType=Enum.ScaleType.Fit}) end
 T.label(modal,'Heading',title,UDim2.new(1,key and -122 or -88,0,52),UDim2.fromOffset(key and 64 or 16,0),22,true)
 local closeButton=T.button(modal,'Close','×',UDim2.fromOffset(44,44),UDim2.new(1,-54,0,6),close) closeButton.TextSize=28
 local body=T.scroll(modal,'Body',UDim2.new(1,-24,1,-70),UDim2.fromOffset(12,60))
 return modal,body
end
return T
