---
title: "simulator-template-v001"
tags: [roblox-knowledge, asset]
---

# simulator-template-v001

## Назначение

Отдельное ядро симулятора 0.0.1: сбор, инвентарь, продажа, уровни, deny-all admin и offline Studio installer. Постоянных сохранений/мира пока нет.

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: source saved; 35 pure-Lua assertions, syntax and mock installer checks passed; Roblox Studio not tested; RAM_ONLY.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

Paths ../templates resolve inside this installed skill. Install only in blank Edit test place via Command Bar. Roblox UI/real DataModel testing pending. No production profiles/permissions. See template README.



Явные зависимости: [[roblox-game-builder/knowledge/assets/magnet-ui-windows-v045|magnet-ui-windows-v045]]

Темы применения: [[roblox-game-builder/knowledge/topics/architecture|Архитектура игры]], [[roblox-game-builder/knowledge/topics/network|Сеть и серверные команды]], [[roblox-game-builder/knowledge/topics/economy|Экономика и прогрессия]], [[roblox-game-builder/knowledge/topics/items|Предметы и каталоги]], [[roblox-game-builder/knowledge/topics/inventory|Инвентарь и экипировка]], [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/admin|Админ-панель]], [[roblox-game-builder/knowledge/topics/integration|Интеграция игрового цикла]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/templates/simulator-v001/src/server/Core.luau|../templates/simulator-v001/src/server/Core.luau]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: Explicit current user task, 2026-11-16; new core with unchanged WindowTheme/HudIcons from magnet-ui-windows-v045.
- [[roblox-game-builder/templates/simulator-v001/README|README.md]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/templates/simulator-v001/dist/Install.luau|dist/Install.luau]]
- [[roblox-game-builder/templates/simulator-v001/src/client/Main.client.luau|src/client/Main.client.luau]]
- [[roblox-game-builder/templates/simulator-v001/src/server/AdminConfig.luau|src/server/AdminConfig.luau]]
- [[roblox-game-builder/templates/simulator-v001/src/server/Bootstrap.server.luau|src/server/Bootstrap.server.luau]]
- [[roblox-game-builder/templates/simulator-v001/src/server/Core.luau|src/server/Core.luau]]
- [[roblox-game-builder/templates/simulator-v001/src/server/Session.luau|src/server/Session.luau]]
- [[roblox-game-builder/templates/simulator-v001/src/shared/Config.luau|src/shared/Config.luau]]
- [[roblox-game-builder/templates/simulator-v001/src/shared/HudIcons.luau|src/shared/HudIcons.luau]]
- [[roblox-game-builder/templates/simulator-v001/src/shared/WindowTheme.luau|src/shared/WindowTheme.luau]]
