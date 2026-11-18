---
title: "magnet-hud-navigation-v042"
tags: [roblox-knowledge, asset]
---

# magnet-hud-navigation-v042

## Назначение

Two edge navigation groups and compact currency-only host adapter; no full-width banner.

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: source stored; originating-project mouse and layout checks passed.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

HudNavigation requires HudIcons; host supplies actions and visibility; adapter needs originating project modules.

Производный от: [[roblox-game-builder/knowledge/assets/magnet-hud-navigation-v041|magnet-hud-navigation-v041]]



Темы применения: [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/ui/magnet-hud-navigation-v042/HudNavigation.luau|ui/magnet-hud-navigation-v042/HudNavigation.luau]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: Explicit user screenshot correction, Magnet Workshop Simulator, 2026-11-13.
- [[roblox-game-builder/assets/ui/magnet-hud-navigation-v042/README|README.md]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/assets/ui/magnet-hud-navigation-v042/HudIcons.luau|HudIcons.luau]]
- [[roblox-game-builder/assets/ui/magnet-hud-navigation-v042/HudNavigation.luau|HudNavigation.luau]]
- [[roblox-game-builder/assets/ui/magnet-hud-navigation-v042/Main.project-adapter.luau|Main.project-adapter.luau]]
