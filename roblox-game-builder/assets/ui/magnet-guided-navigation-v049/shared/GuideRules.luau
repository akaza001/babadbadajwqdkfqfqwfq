-- Read-only presentation goals. Never grants finds, coins or tutorial progress.
local C=require(script.Parent.Config)
local G={version='0.4.8'}
G.steps={'Возьми магнит','Поймай первую находку','Очисти обе стороны','Выставь находку или продай её'}
local function number(n)
 if n>=1000000000 then return string.format('%.1f млрд',n/1000000000):gsub('%.',',') end
 if n>=1000000 then return string.format('%.1f млн',n/1000000):gsub('%.',',') end
 return tostring(n)
end
local function newest(profile,state)
 local best
 for _,f in profile.finds do if f.state==state and not f.displaySlot and (not best or f.foundAt>best.foundAt or f.foundAt==best.foundAt and f.uid<best.uid) then best=f end end
 return best
end
function G.describe(p,context)
 if not p or p.guideEnabled==false then return nil end
 local ctx=context or {} local dirty,clean=newest(p,'Dirty'),newest(p,'Clean') local done=(p.tutorialStep or 0)>=5
 for _,f in p.finds do if f.displaySlot then done=true break end end
 local view={kind='tutorial',total=4,progress=0}
 if not done then
  if dirty then
   view.index=3 view.key='clean' view.title='Очисти находку' view.detail='Две стороны у своего стола' view.uid=dirty.uid
   view.help='Вернись к столу в своей мастерской. Открой ржавую находку и води щёткой по поверхности. Предмет перевернётся автоматически.'
   view.action=ctx.atBench and 'Dirty' or ctx.atHome and 'BenchMarker' or 'Home' view.button=ctx.atBench and 'Открыть' or ctx.atHome and 'Показать' or 'Домой'
  elseif clean then
   view.index=4 view.key='display' view.title='Выставь или продай' view.detail='Первый экспонат в мастерской' view.uid=clean.uid
   view.help='Оставь очищенную находку на полке: другие игроки смогут её осмотреть. Либо отнеси её приёмщику и подтверди продажу.'
   view.action=ctx.atHome and 'Clean' or 'Home' view.button=ctx.atHome and 'На полку' or 'Домой'
  elseif ctx.equipped then
   view.index=2 view.key='catch' view.title='Сделай первый заброс' view.detail='Лови с края помоста у воды'
   view.help='Встань у воды на внутреннем краю кольцевого помоста. Останови шкалу броска у вершины. Во время подъёма тап или пробел подтягивает трос, пауза ослабляет его.'
   view.action=ctx.away and 'Home' or ctx.onPier and 'Cast' or 'Water' view.button=ctx.away and 'Домой' or ctx.onPier and 'Забросить' or 'Показать'
  else
   view.index=1 view.key='equip' view.title='Возьми магнит' view.detail='Начни коллекцию находок'
   view.help='Возьми магнит кнопкой «Взять» или выбери его в слоте 1. Затем выйди из мастерской к воде по лестнице на общий помост.'
   view.action='Equip' view.button='Взять'
  end
  view.eyebrow='Первые шаги · '..view.index..' / 4' view.progress=(view.index-1)/4 return view
 end
 view.kind='goal' view.index=5 view.progress=1 view.eyebrow='Следующая цель'
 if p.toolLevel>=2 and not (p.visitedBiomes and p.visitedBiomes['BIO-02']) then
  view.key='visitIce' view.title='Ледяное озеро' view.detail='Магнит II открывает средние находки'
  view.help='Пройди в голубой портал на площади у статуи. На Ледяном озере подойди к одному из двух деревянных причалов и забрось магнит. Домой можно вернуться через арку или кнопку.'
  view.action=ctx.away and 'Home' or 'PortalMarker' view.button=ctx.away and 'Домой' or 'Показать' return view
 elseif p.toolLevel<#C.toolLevels then
  local level=C.toolLevels[p.toolLevel+1]
  view.key='tool'..level.level view.title='Магнит '..(level.level==2 and 'II' or 'III') view.cost=level.cost
  view.detail=number(p.coins)..' / '..number(level.cost)..' монет · до '..level.maxWeightKg..' кг'
  view.help='Продавай очищенные находки у приёмщика. Следующий магнит позволяет поднимать '..(level.level==2 and 'средние' or 'тяжёлые')..' предметы. Улучшение покупается за монеты у стойки оборудования.'
 elseif not p.expandedDisplay then
  view.key='displayUpgrade' view.title='Расширь экспозицию' view.cost=C.upgrades[1].cost
  view.detail=number(p.coins)..' / '..number(view.cost)..' монет · 12 мест'
  view.help='Расширение открывает ещё шесть мест в твоей мастерской. Сохрани любимые находки и покажи коллекцию другим игрокам.'
 elseif not p.ownedCoinThemes.Marine then
  view.key='theme' view.title='Морская мастерская' view.cost=C.upgrades[2].cost
  view.detail=number(p.coins)..' / '..number(view.cost)..' монет'
  view.help='Морская окраска меняет внешний вид мастерской. Она не увеличивает доход или шанс находок.'
 else
  local found=0 for _,v in p.discovered do if v then found+=1 end end
  view.key='collection' view.title=found==#C.items and 'Коллекция собрана!' or 'Собери всю коллекцию'
  view.detail=found..' / '..#C.items..' видов' view.help='Новый вид открывается в коллекции после очистки. Продажа предмета не удаляет запись. Гости могут осматривать экспонаты в мастерской.'
  view.action=found==#C.items and 'Workshops' or 'Collection' view.button=found==#C.items and 'В гости' or 'Открыть' return view
 end
 view.progress=math.clamp(p.coins/view.cost,0,1)
 view.action=ctx.away and 'Home' or ctx.atShop and (view.key=='theme' and 'Shop' or 'Upgrades') or 'ShopMarker'
 view.button=ctx.away and 'Домой' or ctx.atShop and 'Магазин' or 'Показать'
 return view
end
return G
