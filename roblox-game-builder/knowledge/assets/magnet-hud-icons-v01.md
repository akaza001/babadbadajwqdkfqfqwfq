---
title: "magnet-hud-icons-v01"
tags: [roblox-knowledge, asset]
---

# magnet-hud-icons-v01

## Назначение

Six teal/ivory/honey wood 3D HUD icons: inventory, collection, shop, upgrades, sell, settings.

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: imported; all six images loaded in originating Studio; see navigation v041 verification.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

RGBA PNG; no scripts or UI layout. Prompts in manifest.





Темы применения: [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/art|Художественный стиль и материалы]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/ui/magnet-hud-icons-v01/manifest.json|ui/magnet-hud-icons-v01/manifest.json]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: User request, Magnet Workshop Simulator, 2026-11-13; built-in image_gen.
- [[roblox-game-builder/assets/ui/magnet-hud-icons-v01/README|README.md]]
- [[roblox-game-builder/assets/ui/magnet-hud-icons-v01/manifest.json|manifest.json]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]
