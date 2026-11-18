#!/usr/bin/env python3
"""Build linked Obsidian views of saved sources. Never reads chats or game projects.
Refuses to overwrite manually edited generated notes; enrich authoritative sources instead.
"""
import argparse, hashlib, json, re
from collections import Counter
from pathlib import Path

SKILL = Path(__file__).resolve().parents[1]
VAULT = SKILL.parent
OUT = SKILL / 'knowledge'

def read(path):
    return json.loads(path.read_text())
def digest(data):
    return hashlib.sha256(data).hexdigest()
def link(path, label=None):
    path = Path(path)
    if not path.is_absolute(): path = VAULT / path
    name = path.resolve().relative_to(VAULT.resolve()).as_posix()
    if name.endswith('.md'): name = name[:-3]
    return '[[' + name + ('|' + label if label else '') + ']]'
def note(path, title, body, kind):
    return '---\ntitle: ' + json.dumps(title, ensure_ascii=False) + '\ntags: [roblox-knowledge, ' + kind + ']\n---\n\n# ' + title + '\n\n' + body.rstrip() + '\n'

TITLES = dict(zip(
    ['brief','architecture','map','art','model','rig','animation','network','items','inventory','npc','pets','combat','economy','persistence','ui','vfx-audio','monetization','integration','performance','learning','interaction','round','customization','vehicles','physics','procedural','production','reveal','admin'],
    ['Цель и критерии игры','Архитектура игры','Карты и биомы','Художественный стиль и материалы','Модели и сборка','Риги и суставы','Анимации и переходы','Сеть и серверные команды','Предметы и каталоги','Инвентарь и экипировка','NPC и поведение','Питомцы','Бой','Экономика и прогрессия','Сохранения и миграции','Интерфейсы','Эффекты и звук','Покупки и монетизация','Интеграция игрового цикла','Производительность','Память и улучшения','Взаимодействие с миром','Раунды','Кастомизация','Транспорт','Физические взаимодействия','Процедурная генерация','Производство и крафт','Раскрытие награды','Админ-панель']))
RULES = {
 'brief':'Зафиксировать главный цикл, устройства и критерии готовности. Параметры конкретного проекта не превращать в общие требования.',
 'architecture':'Разделить общие каталоги, серверные сервисы и клиентское представление. Сохранённые Main.project-adapter предназначены для исходной игры, их нельзя считать универсальными установщиками.',
 'map':'Использовать стабильные ID биомов, согласованные входы/прибытия и повторяемую сборку. Декор не должен перекрывать маршруты; коллизии отделяются от внешнего вида.',
 'art':'Светлый дневной блочный мир и сочные чистые цвета — общий ориентир пользователя. Нормаль задаёт рельеф, albedo — цвет; не подменять один слой другим.',
 'model':'До моделирования искать готовое в библиотеке. Сохранять исходники и pivot; адаптировать копии. Набор RBXM с непроверенным составом не равен готовому каталогу деталей.',
 'rig':'Выбрать кости либо Motor6D, задать базовую позу и оси. Совместимость скелета должна быть известна до создания клипа.',
 'animation':'Разделить idle, движение и действие; согласовать скорость цикла и переходы. Процедурная камера/переворот предмета не заменяет библиотеку клипов персонажа.',
 'network':'Клиент передаёт намерение; сервер проверяет состояние, права, частоту и параметры. Повтор запроса не должен повторно выдавать награду.',
 'items':'Отделить вид предмета/typeId от уникального экземпляра/UID и владения. Каталоги питают игровой UI и админ-панель. Используемые предметы исключены из общей normal-map политики.',
 'inventory':'Вместимость, выдача, удаление и экипировка проходят серверный сервис. Удаление предмета очищает его размещение/экипировку; UI отображает подтверждённое состояние.',
 'npc':'Разделить состояния, выбор цели и навигацию. Смерть, потеря цели и респавн требуют явной очистки; универсальная высота корня не подходит всем моделям.',
 'pets':'Каталог видов, владение, инвентарь, следование и способности — разные части системы. Детализация питомцев Fight for eggs является проектным требованием.',
 'combat':'Явно задать подготовку, окно удара, восстановление, дальность и кулдаун. Телеграф соответствует реальному урону; смерть/смена оружия отменяют старое действие.',
 'economy':'Цены и источники ресурсов заданы конфигом, начисление и траты — сервером. Повтор команды не дублирует награду. Универсальная XP/rebirth прогрессия пока не доказана сохранёнными пакетами.',
 'persistence':'Профиль имеет версию, миграции и контроль повторных операций. Сброс и autosave должны быть согласованы; отчёт изолированной cloud-проверки не доказывает переносимость в другую игру.',
 'ui':'Использовать тему и переиспользуемые нативные компоненты, реальные данные и адаптивную компоновку. Макет PNG — референс, не работающий экран. Подсказки компактны и не перекрывают игру.',
 'vfx-audio':'Эффекты имеют лимиты, время жизни и очистку. Сохранены проектные аудио/водные presentation-модули, права внешних IDs проверяются при переносе.',
 'monetization':'Реальная выдача за покупку привязана к серверному receipt с защитой от повтора. Внутриигровой магазин за монеты и выдача через админку не доказывают поддержку Robux.',
 'integration':'Собрать действие → серверный результат → UI → сохранение → повторный вход. Проверять новую пустую игру отдельно от исходной; проектные адаптеры не составляют готовый шаблон автоматически.',
 'performance':'Сначала измерить целевую сцену и устройство. Число деталей, успешная компиляция или несколько кадров Studio не являются доказательством FPS на телефоне.',
 'learning':'Читать только разрешённые источники. Сохранять область, источник и статус; инженерная гипотеза не является подтверждённой причиной бага. Учёт изменений происходит во время запуска скилла.',
 'interaction':'Разделять видимость/коллизии, права и дистанцию. Для порталов важны общий шаблон с двух сторон, безопасное прибытие и отмена загрузки при смерти.',
 'round':'Явно хранить фазу, roundId, дедлайн и участников. Обработать вход посреди раунда, уход роли и повтор результата. Готового переносимого round-service в каталоге не установлено.',
 'customization':'Превью, отмена, подтверждение выбора и сохранение отделены. Сохранённая тема мастерской — пример узкой кастомизации, не универсальный редактор аватара.',
 'vehicles':'Отдельно определить посадку, управление и владельца физики. Сохранённые исследования транспорта — инженерные ориентиры, не готовые исходники транспорта.',
 'physics':'Проверять двойной захват, допустимые силы и очистку при выходе владельца. Не считать обычную экипировку доказательством универсального grab/throw.',
 'procedural':'Использовать seed, совместимые сокеты и проверку связности для случайных уровней. Сохранённые детерминированные biome-рецепты не доказывают готовность генератора случайного подземелья.',
 'production':'Отделить сырьё, состояние станций, вместимость и выдачу заказа. Чистка находки — один проектный цикл, не полная универсальная система крафта/конвейеров.',
 'reveal':'Сервер сначала фиксирует результат, клиент раскрывает его. Skip/закрытие не выдаёт второй экземпляр. Рыболовный результат — пример, не готовая система яиц с питомцами.',
 'admin':'Строить формы по серверному реестру реальных систем. Новые предметы попадают из каталога; новая характеристика требует обработчика. Сохранённый шаблон намеренно deny-all, права пользователя не копируются.'
}

# Deliberate routing of preserved resources; no inferred runtime proof.
ASSET_TOPICS = {
 'simulator-template-v001':['architecture','network','economy','items','inventory','ui','admin','integration'],
 'waterfall':['map','model','vfx-audio'], 'stud-asset-pack':['map','model','art'], 'ui-kit':['ui'], 'offline-money':['economy','persistence'],
 'square-relief-normal':['art','model','map'], 'magnet-shore-assembly':['map','model'], 'magnet-hud-icons':['ui','art'],
 'magnet-hud-navigation':['ui'], 'magnet-ui-window-concepts':['ui','art'], 'magnet-ui-windows':['ui','inventory','economy','customization'],
 'magnet-starter-albedos':['art','map'], 'magnet-activity-ui':['ui','interaction','reveal'], 'magnet-onboarding':['ui','interaction'],
 'magnet-biome-fishing':['architecture','network','persistence','economy','integration','interaction','items','inventory','map','reveal'],
 'magnet-vertical-cast-meter':['ui','interaction','network'], 'magnet-guided-navigation':['ui','interaction'], 'magnet-biome-worlds':['map','model','procedural'], 'magnet-biome-finds':['items','inventory','model'],
 'magnet-biome-exploration':['ui','interaction'], 'magnet-portal-pairs':['map','interaction'], 'magnet-biome-loading':['ui','interaction'],
 'magnet-fullscreen-loading':['ui','interaction'], 'magnet-biome-walls-joints':['map','model'], 'magnet-world-materials':['art','map','model'],
 'magnet-admin-panel':['admin','network','persistence','economy'], 'magnet-cleaning-presentation':['animation','ui','interaction']
}
REFS = {'art':['visual-style','material-policy','model-library'], 'map':['visual-style','material-policy','model-library'],
 'model':['model-library','material-policy','asset-memory'], 'animation':['asset-memory'], 'items':['asset-memory','admin-panel'],
 'ui':['ui-quality','asset-memory'], 'admin':['admin-panel'], 'learning':['learning','regressions','asset-memory']}

def topics_for(asset):
    return next((v for k,v in ASSET_TOPICS.items() if asset['id'].startswith(k)), {'ui':['ui'], 'texture':['art'], 'item':['items'], 'model':['model'], 'animation':['animation'], 'system':['architecture']}.get(asset.get('kind'), []))
def bundle_root(asset):
    p=SKILL/'assets'/asset['file']
    for d in [p.parent,p.parent.parent,p.parent.parent.parent]:
        if d == SKILL/'assets': break
        if (d/'README.md').exists(): return d
    return p.parent

def build():
    graph=read(SKILL/'references/graph.json'); cases=read(SKILL/'references/regression-cases.json')['records']; assets=read(SKILL/'assets/catalog.json')['assets']
    allowed=read(VAULT/'roblox-memory/chat-sources.json')['allowed_chat_folders']
    assert all(x.get('enabled') for x in allowed)
    enabled={x['project_id'] for x in allowed if x.get('enabled')}
    assert {'93989e57-0575-4ca4-8a14-02a1851744cb','81a53000-407c-4308-88b2-cf0ea8aa0f22'} <= enabled
    outputs={}; problems=[]
    def put(rel,title,body,kind): outputs[rel]=note(rel,title,body,kind)
    def topic(k): return link(OUT/'topics'/f'{k}.md',TITLES[k])
    def assetnote(a): return link(OUT/'assets'/f'{a["id"]}.md',a['id'])
    for a in assets:
        entries=a.get('files',[])+[{'file':a['file'], **{k:a[k] for k in ['sha256','size_bytes'] if k in a}}]
        local_issues=[]
        for entry in entries:
            p=SKILL/'assets'/entry['file']
            if not p.exists():local_issues.append('Нет файла: '+entry['file']);continue
            data=p.read_bytes()
            if 'sha256' in entry and digest(data)!=entry['sha256']:local_issues.append('SHA не совпадает: '+entry['file'])
            if 'size_bytes' in entry and len(data)!=entry['size_bytes']:local_issues.append('Размер не совпадает: '+entry['file'])
        problems += [{'asset':a['id'],'issue':x} for x in local_issues]
        d=bundle_root(a); docs=[p for p in [d/'README.md',d/'verification.md',d/'verification.json',d/'manifest.json'] if p.exists()]
        code=[SKILL/'assets'/f['file'] for f in a.get('files',[]) if f['file'].endswith('.luau')]
        evidence='\n'.join('- '+link(p,p.name) for p in docs) or '- Подробный отчёт в пакете не найден; см. запись каталога.'
        body=f'''## Назначение

{a.get('description',a['id'])}

## Статус: исходник и проверка отдельно

- Исходник: {'есть; файл доступен' if (SKILL/'assets'/a['file']).exists() else 'отсутствует'}.
- Запись каталога: {a.get('status','не задан')}.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: {'есть расхождения — см. ниже' if local_issues else 'расхождений не найдено'}.

## Зависимости и совместимость

{a.get('compatibility','Уточнить по исходникам и манифесту перед подключением.')}

{('Производный от: '+link(OUT/'assets'/str(a['derived_from']+'.md'),a['derived_from'])) if isinstance(a.get('derived_from'),str) and any(x['id']==a['derived_from'] for x in assets) else ''}

{'Явные зависимости: '+', '.join(link(OUT/'assets'/f'{key}.md', key) if any(x['id']==key for x in assets) else key for key in a.get('dependencies',[])) if a.get('dependencies') else ''}

Темы применения: {', '.join(topic(k) for k in topics_for(a))}.

## Исходники и свидетельства

- Точка входа: {link(SKILL/'assets'/a['file'],a['file'])}.
- Полный список файлов/контрольных сумм: {link(SKILL/'assets/catalog.json','каталог')}.
- Происхождение: {a.get('source','не указано')}.
{evidence}

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.

{chr(10).join('- '+x for x in local_issues)}

## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

{link(OUT/'assets.md','Все ассеты')} · {link(OUT/'gaps.md','Карта пробелов')}
'''
        if code:body+='\n## Сохранённые Luau-исходники\n\n'+'\n'.join('- '+link(p,p.relative_to(d).as_posix()) for p in code)+'\n'
        put('assets/'+a['id']+'.md',a['id'],body,'asset')
    for r in cases:
        sources='\n'.join('- `'+json.dumps(x,ensure_ascii=False)+'`' for x in r.get('sources',[]))
        body=f'''## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

{r['reported_problem']}

## Что делать

{r['prevention']}

## Зависимости

{', '.join(topic(k) for k in r.get('tags',[]) if k in TITLES)}

## Исходники и происхождение

{link(SKILL/'references/regression-cases.json','Исходный реестр')} — запись `{r['id']}`.

{sources}

## Статус

Готово как правило приёмки. Основание: {r.get('basis','прямое требование/сохранённый реестр')}. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

{r['acceptance_check']}

{link(OUT/'regressions.md','Все ошибки и критерии')}
'''
        put('regressions/'+r['id']+'.md',r['id'],body,'regression')
    for n in graph['nodes']:
        k=n['id']; aa=[a for a in assets if k in topics_for(a)]; rr=[r for r in cases if k in r.get('tags',[])]
        deps=', '.join(topic(x) for x in n['requires']) or 'Начальный узел; обязательных предшественников в графе нет.'
        related=', '.join(topic(x) for x in n.get('related',[])) or 'Связи с другими темами определяются задачей.'
        references=[SKILL/'references/implementation.md',SKILL/'references/graph.json']+[SKILL/'references'/f'{x}.md' for x in REFS.get(k,[])]
        if n.get('reference'):references.append(SKILL/n['reference'])
        body=f'''## Назначение

{n['output']}.

## Сохранённое знание

{RULES[k]}

## Зависимости

До реализации: {deps}

Связанный контекст: {related}

## Исходники

'''+('\n'.join('- '+assetnote(a) for a in aa) if aa else 'Отдельного профильного пакета в каталоге не установлено. Ниже есть инструкции/рецепты; готовый универсальный модуль этим не подтверждён.')+'\n\n'+ '\n'.join('- '+link(p,p.name) for p in dict.fromkeys(references))+f'''

## Ошибки и ограничения

'''+ ('\n'.join('- '+link(OUT/'regressions'/f'{r["id"]}.md',r['reported_problem']) for r in rr) if rr else 'Специального случая в реестре пока нет. Проверять границы подсистемы и интеграцию; отсутствие записи не доказывает отсутствие ошибок.')+f'''

## Как проверить

{n['verify']}.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: {'есть перечисленные пакеты; часть зависит от исходной игры' if aa else 'отдельный переносимый пакет не установлен'}.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по {link(OUT/'gaps.md','карте пробелов')}. Не считать эту заметку готовой реализацией.

{link(OUT/'index.md','База знаний')}
'''
        put('topics/'+k+'.md',TITLES[k],body,'topic')
    put('assets.md','Библиотека исходников и ассетов','''## Назначение и статус

Навигация по реальным записям каталога. Статусы не повышаются при создании заметок. Старые версии оставлены как история, а не как дополнительные независимые системы.

## Зависимости и правила

'''+link(SKILL/'references/asset-memory.md','Поиск и сохранение')+' · '+link(SKILL/'references/model-library.md','Импорт моделей')+'\n\n## Исходники\n\n'+'\n'.join('- '+assetnote(a)+' — '+a['kind']+'; '+a.get('status','unknown') for a in assets)+'\n\n## Ошибки и проверка\n\nОткрывай контракт нужной версии, различай концепты/код/отчёты. Локальные SHA и ссылки проверяет scripts/build_obsidian.py --check; игровой результат требует отдельного Play.\n','index')
    put('regressions.md','Ошибки и критерии приёмки','''## Назначение

Переносить уроки между играми, не перенося их баланс и планировку.

## Зависимости и исходники

'''+link(SKILL/'references/regressions.md','Правила выбора')+' · '+link(SKILL/'scripts/select_regressions.py','Селектор')+'\n\n## Случаи\n\n'+'\n'.join('- '+link(OUT/'regressions'/f'{r["id"]}.md',r['reported_problem']) for r in cases)+'\n\n## Статус и проверка\n\nСохранены требования и предлагаемые инженерные меры, не новые результаты Play. Выбирай случаи до реализации и фиксируй наблюдаемый результат каждого после неё.\n','index')
    cards=sorted((VAULT/'roblox-research/builder-top50/2026-11-06/games').glob('*.json'))
    body='''## Назначение

Навигация по существующим 50 карточкам. Они не дублируются и не дробятся ради числа узлов.

## Статус

Историческая выборка 6 ноября 2026, не текущий рейтинг. Визуальные наблюдения основаны на выборках публичных видео; полных прохождений/всех карт/всех анимаций нет. Рецепты реализации — предложения, не исходный код чужих игр. Идентификация №27 предварительная.

## Зависимости и исходники

'''+link(SKILL/'references/research.md','Правила исследования')+' · '+link(SKILL/'references/visual-patterns.md','Инженерные паттерны')+'\n\n## Карточки\n\n'
    for p in cards:
        g=read(p); body+='- '+link(p.with_suffix('.md'),str(g['rank'])+'. '+g['name'])+' — '+g.get('evidence',{}).get('summary','Описание отсутствует')+'\n'
    body+='\n## Ошибки и проверка\n\nНе выдавать старый обзор за свежий топ и предположение за устройство игры. Перед конкретной реализацией читать ограничения карточки и проверять собственный игровой срез.\n'
    put('research.md','Исследования и игровые ориентиры',body,'research')
    put('projects/fight-for-eggs.md','Fight for eggs — уроки проекта',f'''## Назначение

Использовать подтверждённые пользовательские требования с учётом хронологии. Полный сохранённый разбор имеет приоритет над ранним частичным импортом.

## Зависимости и исходники

- {link(VAULT/'roblox-memory/projects/fight-for-eggs-review.md','Полный сохранённый разбор и последние решения')}.
- {link(VAULT/'roblox-memory/projects/fight-for-eggs-builder.md','Ранняя частичная память — не финальный свод')}.
- {link(VAULT/'roblox-memory/imports/fight-for-eggs-history.json','Сохранённые сообщения и provenance')}.
- {link(OUT/'regressions.md','Переносимые инженерные случаи')}.

## Ошибки

Повторное использование отменённого cap скорости, старых ярлыков UI или авто-hatch возвращает исправленные решения. Не путать 100 шаблонов боссов с количеством активных. Конкретные шансы, размеры, расположения и детализация питомцев остаются проектными. Последующая общая политика материалов уточняет ранние проектные ограничения.

## Статус

Сохранённый импорт: 22 чата, 281 ход, 324 пользовательских сообщения; изображения повторно осмотрены не все. Это исторический охват, не утверждение о свежести на сегодняшний день. В этой задаче новые чаты и Studio не читались.

## Как проверить

Сверить источник/turn и дату требования с полным разбором, затем воспроизвести нужный случай в разрешённой тестовой среде. Текст прежнего ассистента сам по себе не подтверждает текущую реализацию.
''','project')
    put('projects/magnet-workshop.md','Magnet Workshop — исходники и хронология',f'''## Назначение

Источники повторно используемых модулей, исправлений UI/геометрии и отчётов проверок. Это проектная история, а не готовый универсальный симулятор.

## Зависимости и исходники

{link(VAULT/'roblox-memory/projects/magnet-workshop.md','Сохранённая память, включая этапы 0.5.6')} · {link(OUT/'assets.md','Пакеты исходников')}.

## Ошибки и замены решений

- Старый HUD 0.4.1 заменён краевым 0.4.2 и уменьшенным 0.4.3; концепты PNG имеют последующие нативные реализации.
- Ограничение Ice магнитом II из 0.4.8 заменено явным открытием всех активных биомов на 0.5.0. BIO-09 оставался удалённым.
- Pending-визуальные проверки материалов 0.5.5 позже закрыты для выбранных семи ракурсов; это не проверка всех углов/устройств.
- Камера 0.5.6 позже проверена на F13 и 26 позах переворота; не на всех предметах с физическим вводом.
- Админ-шаблон имеет пустые разрешения и требует подключения к сервисам новой игры. Не переносить права исходного проекта.

## Статус

Реальные исходники и отчёты сохранены. Нового чтения чатов/новых Play-проверок в этой задаче нет. Поздние записи проектной памяти и конкретный verification.md уточняют ранние README со статусом pending.

## Как проверить

Выбирать пакет по последнему подходящему контракту, сверять версии зависимостей и сохранять рамки исторической проверки. Отдельно пройти установку в пустой тестовой игре и повторный вход.
''','project')
    return outputs, problems, len(assets), len(cases), len(cards)

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--check',action='store_true'); args=parser.parse_args()
    outputs,problems,asset_count,case_count,research_count=build()
    manifest_path=OUT/'generated.json'; old=read(manifest_path) if manifest_path.exists() else {'files':{}}
    if args.check:
        failures=[]
        for name in outputs:
            p=OUT/name
            if not p.exists() or p.read_text()!=outputs[name]: failures.append('Outdated generated note: '+name)
        for p in OUT.rglob('*.md'):
            for target in re.findall(r'\[\[([^\]|]+)(?:\|[^\]]*)?\]\]',p.read_text()):
                q=VAULT/target.split('#')[0]
                if not q.exists() and not q.with_suffix('.md').exists():failures.append('Broken link: '+str(p)+' -> '+target)
        failures += [x['asset']+': '+x['issue'] for x in problems]
        if failures: raise SystemExit('\n'.join(failures))
        print(f'Validated {len(outputs)} generated notes, local wiki links, {asset_count} catalog assets; {case_count} regression cases, {research_count} existing research cards. No runtime tests performed.')
        return
    for name,body in outputs.items():
        p=OUT/name
        if p.exists() and p.read_text()!=body and digest(p.read_bytes())!=old['files'].get(name):
            raise SystemExit('Refusing to overwrite edited note: '+str(p))
    for name,body in outputs.items():
        p=OUT/name;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(body)
    manifest={'version':1,'source_policy':'saved knowledge only; no fresh chat or game inspection','files':{n:digest(v.encode()) for n,v in outputs.items()},'asset_integrity_issues':problems}
    manifest_path.write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
    print(f'Built {len(outputs)} linked notes; asset integrity issues: {len(problems)}. Run --check after adding curated index/gaps/status notes.')
if __name__=='__main__':main()
