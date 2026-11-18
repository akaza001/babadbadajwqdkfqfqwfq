# Граф разработки

Сплошная стрелка — зависимость, пунктир — связанный контекст. Реализация выбирает нужный подграф; полная игра не обязана иметь бой, питомцев или монетизацию.

```mermaid
graph TD
  brief["brief"]
  architecture["architecture"]
  brief --> architecture
  map["map"]
  brief --> map
  map -.-> npc
  map -.-> combat
  map -.-> performance
  art["art"]
  brief --> art
  model["model"]
  art --> model
  rig["rig"]
  model --> rig
  animation["animation"]
  rig --> animation
  animation -.-> combat
  animation -.-> pets
  animation -.-> vfx_audio
  network["network"]
  architecture --> network
  items["items"]
  model --> items
  network --> items
  inventory["inventory"]
  items --> inventory
  inventory -.-> ui
  inventory -.-> persistence
  npc["npc"]
  animation --> npc
  network --> npc
  map --> npc
  pets["pets"]
  npc --> pets
  inventory --> pets
  pets -.-> economy
  pets -.-> persistence
  pets -.-> ui
  combat["combat"]
  npc --> combat
  items --> combat
  combat -.-> ui
  combat -.-> vfx_audio
  economy["economy"]
  network --> economy
  persistence["persistence"]
  economy --> persistence
  inventory --> persistence
  ui["ui"]
  architecture --> ui
  brief --> ui
  vfx_audio["vfx-audio"]
  art --> vfx_audio
  architecture --> vfx_audio
  monetization["monetization"]
  economy --> monetization
  persistence --> monetization
  ui --> monetization
  integration["integration"]
  map --> integration
  network --> integration
  ui --> integration
  integration -.-> pets
  integration -.-> combat
  integration -.-> persistence
  integration -.-> monetization
  performance["performance"]
  integration --> performance
  learning["learning"]
  learning -.-> brief
  learning -.-> art
  learning -.-> integration
```

| Узел | Результат | Проверка |
|---|---|---|
| brief | Цель, стиль, ограничения и критерии готовности | Сопоставить результат с явным запросом и решениями проекта |
| architecture | Размещение модулей, серверное состояние, клиентские представления | Проверить владение состоянием и зависимости модулей |
| map | Блокаут, маршруты, спавны, зоны и масштаб | Пройти маршруты в Play; проверить респавн и недоступные зоны |
| art | Палитра, формы, материалы и оригинальные ассеты | Сравнить с референсом с нескольких ракурсов |
| model | Модель с pivot, масштабом и разделёнными физикой/визуалом | Проверить bounding box, pivot, коллизии и переиспользование |
| rig | Скелет или Motor6D-иерархия с корректными осями | Повернуть суставы и проверить отсутствие отрыва деталей |
| animation | Клипы и переходы idle/move/action, согласованные с ригом | Наблюдать idle, движение, остановку, атаку и повторное появление |
| network | Контракты событий и серверные проверки | Подать неверные типы, дальность, частоту и недопустимое состояние |
| items | Реестр типов и уникальные экземпляры предметов | Проверить экипировку, снятие, повторную выдачу и неизвестный ID |
| inventory | Инвентарь, вместимость, экипировка и UI-модель | Проверить дубликаты запроса и полную вместимость |
| npc | Состояния NPC, цели, навигация и восстановление | Проверить потерю цели, препятствие, смерть и респавн |
| pets | Виды животных, следование, способности, ownership | Проверить несколько питомцев, исчезновение владельца и повторный вход |
| combat | Урон, хитбоксы, тайминги атак и телеграфы | Проверить попадания/промахи, дистанцию, кулдаун, смерть и награду |
| economy | Источники и траты ресурсов, цены, прогрессия | Проверить невозможность отрицательного баланса и двойной награды |
| persistence | Версия профиля, миграция и сериализация состояния | Тестовый профиль: выход/вход, ошибка записи, старый формат |
| ui | Экраны, HUD, состояния loading/empty/error и управление | Проверить мобильный/настольный экран, фокус геймпада и длинный текст |
| vfx-audio | События эффектов, звук и лимиты одновременности | Проверить своевременность, слышимость и очистку объектов |
| monetization | Точные продукты и идемпотентная серверная выдача | Проверить правила Roblox и повторный тестовый receipt |
| integration | Работающий игровой цикл с выбранными подсистемами | Плейтест от входа до результата и повторения цикла |
| performance | Профиль нагрузки и оптимизация узких мест | Измерить CPU/память/сеть на целевом устройстве до/после |
| learning | Записи правок, источников и проверенных улучшений | Проверить область, источник, отсутствие дублей и противоречий |
