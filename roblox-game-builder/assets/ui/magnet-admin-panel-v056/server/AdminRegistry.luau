-- Commands describe their own forms. All catalog choices are rebuilt from live data.
local R={version='0.5.6'}
local function option(value,label) return {value=value,label=label} end
local function enum(id,label,options,default) return {id=id,label=label,type='enum',options=options,default=default} end
local function number(id,label,min,max,default) return {id=id,label=label,type='integer',min=min,max=max,default=default} end
local function count(t) local n=0 for _ in t do n+=1 end return n end
function R.new(d)
 local self={builders={}}
 function self:register(id,builder)
  assert(type(id)=='string' and not self.builders[id],'Duplicate admin command') self.builders[id]=builder
 end
 function self:build(s)
  local out={}
  for id,builder in self.builders do local c=builder(s);c.id=id;table.insert(out,c) end
  table.sort(out,function(a,b) return a.order<b.order end) return out
 end
 local C,B,Store,G=d.config,d.biomes,d.store,d.game
 local function items()
  local out={} for _,v in C.items do table.insert(out,option(v.id,v.id..' · '..v.name)) end return out
 end
 local function instances(s,dirtyOnly)
  local out={} for uid,f in s.data.finds do if not dirtyOnly or f.state=='Dirty' then
   table.insert(out,option(uid,C.itemsById[f.itemId].name..' · '..(f.state=='Clean' and 'чистый' or 'ржавый')..' · '..uid:sub(1,6)))
  end end table.sort(out,function(a,b) return a.label<b.label end) return out
 end
 local function save(s,op,mutate,home) return G.adminApply(s.player,op,mutate,home) end
 self:register('coins.change',function(s) return {group='profile',order=10,title='Монеты',detail='Добавить, установить или вычесть монеты своего профиля.',current=tostring(s.data.coins)..' монет',
  fields={enum('mode','Операция',{option('Add','Добавить'),option('Set','Установить'),option('Subtract','Вычесть')},'Add'),number('amount','Количество',0,C.coinsCap,100)},
  run=function(a,op) return save(s,op,function(p)
   local n=a.mode=='Set' and a.amount or p.coins+(a.mode=='Add' and a.amount or -a.amount)
   if n<0 or n>C.coinsCap then return false,'errCoinsRange' end p.coins=n return true
  end) end} end)
 self:register('tool.set',function(s)
  local options={} for i in C.toolLevels do table.insert(options,option(i,'Магнит '..i)) end
  return {group='profile',order=20,title='Уровень магнита',detail='Обновляет настоящий инструмент и доступные весовые группы.',current='Уровень '..s.data.toolLevel,
   fields={enum('level','Уровень',options,s.data.toolLevel)},run=function(a,op) return save(s,op,function(p) p.toolLevel=a.level return true end) end}
 end)
 self:register('display.set',function(s) return {group='profile',order=30,title='Места в мастерской',detail='При уменьшении полки лишние экспонаты возвращаются в инвентарь.',current=s.data.expandedDisplay and '12 мест' or '6 мест',
  fields={enum('expanded','Размер',{option(false,'6 мест'),option(true,'12 мест')},s.data.expandedDisplay)},
  run=function(a,op) return save(s,op,function(p) p.expandedDisplay=a.expanded;if not a.expanded then for _,f in p.finds do if f.displaySlot and f.displaySlot>6 then f.displaySlot=nil end end end return true end) end} end)
 self:register('theme.set',function(s) return {group='profile',order=40,title='Оформление мастерской',detail='Выдаёт внутриигровое оформление. Покупки Roblox не имитируются.',current=s.data.selectedTheme=='Marine' and 'Морское' or 'Обычное',
  fields={enum('theme','Оформление',{option('Default','Обычное'),option('Marine','Морское')},s.data.selectedTheme)},
  run=function(a,op) return save(s,op,function(p) if a.theme=='Marine' then p.ownedCoinThemes.Marine=true end p.selectedTheme=a.theme return true end) end} end)
 self:register('tutorial.set',function(s) return {group='profile',order=50,title='Обучение',detail='Пропустить обучение или включить подсказки. Сброс этапов находится в разделе «Сброс».',current=s.data.guideEnabled and 'Подсказки включены' or 'Подсказки выключены',
  fields={enum('mode','Действие',{option('Complete','Пропустить обучение'),option('Enable','Включить подсказки'),option('Disable','Выключить подсказки')},'Complete')},
  run=function(a,op) return save(s,op,function(p) if a.mode=='Complete' then p.tutorialStep=5;p.tutorialFindsGranted=2 else p.guideEnabled=a.mode=='Enable' end return true end) end} end)
 self:register('finds.grant',function(s) return {group='finds',order=60,title='Выдать находку',detail='Каждый экземпляр получает отдельный ID. Учитывается вместимость рюкзака.',current=count(s.data.finds)..' / '..C.inventoryCapacity..' предметов',
  fields={enum('itemId','Предмет',items(),C.items[1].id),enum('state','Состояние',{option('Dirty','Ржавый'),option('Clean','Очищенный')},'Dirty'),number('count','Количество',1,C.inventoryCapacity,1)},
  run=function(a,op) return save(s,op,function(p)
   if count(p.finds)+a.count>C.inventoryCapacity then return false,'errInventory' end
   local def=C.itemsById[a.itemId]
   for _=1,a.count do local uid=game.HttpService:GenerateGUID(false);p.finds[uid]={uid=uid,itemId=a.itemId,zoneId=def.zone,biomeId=def.biomeId or 'BIO-01',foundAt=os.time(),finderUserId=s.player.UserId,state=a.state} end
   if a.state=='Clean' then p.discovered[a.itemId]=true end return true
  end) end} end)
 self:register('finds.clean',function(s) local choices=instances(s,true);return {group='finds',order=70,title='Очистить находку',detail='Очищает выбранный экземпляр и открывает его запись в коллекции.',current=#choices..' ржавых предметов',fields={enum('uid','Экземпляр',choices,choices[1] and choices[1].value)},
  run=function(a,op) return save(s,op,function(p) local f=p.finds[a.uid];if not f or f.state~='Dirty' then return false,'errFind' end f.state='Clean';p.discovered[f.itemId]=true return true end) end} end)
 self:register('finds.remove',function(s) local choices=instances(s);return {group='finds',order=80,title='Удалить экземпляр',detail='Удаляет только выбранную находку. Монеты за неё не начисляются.',confirmDetail='Выбранный экземпляр будет удалён из рюкзака или с полки без продажи.',current=count(s.data.finds)..' предметов',confirm=true,fields={enum('uid','Экземпляр',choices,choices[1] and choices[1].value)},
  run=function(a,op) return save(s,op,function(p) if not p.finds[a.uid] then return false,'errFind' end p.finds[a.uid]=nil return true end) end} end)
 self:register('collection.mark',function(s) return {group='finds',order=90,title='Запись в коллекции',detail='Меняет открытие одного вида. Сам предмет не выдаётся и не удаляется.',current=count(s.data.discovered)..' / '..#C.items..' видов',
  fields={enum('itemId','Вид',items(),C.items[1].id),enum('known','Запись',{option(true,'Открыть'),option(false,'Закрыть')},true)},
  run=function(a,op) return save(s,op,function(p) p.discovered[a.itemId]=a.known and true or nil return true end) end} end)
 self:register('biome.travel',function(s) local choices={};for _,b in B.list do table.insert(choices,option(b.id,b.name)) end;return {group='travel',order=100,title='Перейти к озеру',detail='Переносит перед порталом, а в лесу — к своей мастерской. Не выдаёт достижения за посещение.',current=B.byId[s.currentBiomeId or 'BIO-01'].name,
  fields={enum('biomeId','Озеро',choices,s.currentBiomeId or 'BIO-01')},run=function(a) return G.adminTravel(s.player,a.biomeId) end} end)
 self:register('progress.reset',function(s) return {group='reset',order=110,title='Сброс прогресса',detail='Только ваш профиль. Коллекция сохраняется при удалении находок; полный сброс возвращает стартовые значения и домой.',confirm=true,current='Выберите область сброса',
  confirmDetail=function(a) return ({All='Будут сброшены монеты, магнит, улучшения, находки, коллекция, обучение, отметки озёр и настройки. Вы вернётесь к мастерской.',Inventory='Все находки будут удалены из рюкзака и с полок.',Collection='Все записи об открытых видах будут удалены из коллекции.',Upgrades='Вернутся магнит I, шесть мест и обычное оформление. Экспонаты с мест 7–12 вернутся в рюкзак.',Tutorial='Сбросятся этапы обучения и первые гарантированные находки. Подсказки включатся.',Exploration='Удалятся отметки посещений и первых уловов озёр.'})[a.scope] end,
  fields={enum('scope','Область',{option('All','Весь игровой прогресс'),option('Inventory','Только находки и экспонаты'),option('Collection','Только коллекция видов'),option('Upgrades','Магнит и улучшения мастерской'),option('Tutorial','Только обучение'),option('Exploration','Только отметки исследования')},'Tutorial')},
  run=function(a,op) return save(s,op,function(p) return Store.resetProgress(p,a.scope) end,a.scope=='All') end} end)
 return self
end
R.groups={{id='profile',label='Профиль'},{id='finds',label='Находки'},{id='travel',label='Путешествия'},{id='reset',label='Сброс'},{id='audit',label='Журнал'}}
return R
