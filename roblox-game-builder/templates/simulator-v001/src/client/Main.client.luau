local Players=game:GetService('Players')
local shared=game:GetService('ReplicatedStorage'):WaitForChild('SimulatorTemplate')
local T=require(shared.WindowTheme)
local remote=shared.Request
local gui=Instance.new('ScreenGui') gui.Name='SimulatorTemplate' gui.ResetOnSpawn=false gui.Parent=Players.LocalPlayer:WaitForChild('PlayerGui')
local root=T.make('ScrollingFrame',gui,'Root',{Size=UDim2.new(1,-24,0.65,0),Position=UDim2.new(0,12,0.1,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),BackgroundColor3=T.paper,BorderSizePixel=0,ScrollBarThickness=4})
T.make('UISizeConstraint',root,'Bounds',{MaxSize=Vector2.new(420,700)}) T.list(root,8)
local function label(text) return T.label(root,'Status',text,UDim2.new(1,-12,0,56),nil,15) end
label('Шаблон 0.0.1 · данные только до выхода!')
local status=label('Подключение…')
local seq=0 local pending=false local profile local description
local function show()
 if not profile then return end
 local n=0 for _,amount in pairs(profile.items) do n=n+amount end
 status.Text=description.currency..': '..profile.coins..' · уровень '..profile.level..' · предметов '..n..'/'..description.capacity
end
local function request(action,args)
 if pending then return end pending=true seq=seq+1
 local ok,result=pcall(function() return remote:InvokeServer({seq=seq,action=action,args=args or {}}) end)
 pending=false
 if ok and result then
  if result.profile then profile=result.profile end show()
  if not result.ok then status.Text=status.Text..'\n'..tostring(result.error) end
 else status.Text='Нет ответа. Обновите состояние перед следующим действием.' end
end
local function button(text,callback) T.button(root,'Action',text,UDim2.new(1,-12,0,48),nil,callback,true,true) end
local ok,result=pcall(function() return remote:InvokeServer({action='describe'}) end)
if not ok or not result or not result.ok then status.Text='Сервер недоступен' return end
profile=result.profile description=result.description show()
button('Собрать находку',function() request('collect') end)
button('Продать всё',function() request('sell') end)
button('Купить следующий уровень',function() request('upgrade') end)
-- Dynamic admin forms from server-authorized command and item catalogs.
local function input(default)
 return T.make('TextBox',root,'Value',{Text=default,Size=UDim2.new(1,-12,0,48),ClearTextOnFocus=false,TextSize=16,BackgroundColor3=T.card,TextColor3=T.ink})
end
local resetArmed=false
for _,action in ipairs(description.admin) do
 label('Админ · '..action)
 if action=='item.grant' then
  for id,item in pairs(description.items) do
   local amount=input('1')
   button('Выдать '..item.name,function() request(action,{id=id,amount=tonumber(amount.Text)}) end)
  end
 elseif action=='progress.reset' then
  button('Сбросить мой прогресс',function() resetArmed=true status.Text='Для сброса нажмите Подтвердить.' end)
  button('Подтвердить сброс',function() if resetArmed then resetArmed=false request(action,{confirm=true}) end end)
 else
  local value=input('0')
  button('Применить '..action,function() request(action,{value=tonumber(value.Text)}) end)
 end
end
