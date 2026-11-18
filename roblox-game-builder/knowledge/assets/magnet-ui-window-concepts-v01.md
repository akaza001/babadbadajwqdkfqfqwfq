---
title: "magnet-ui-window-concepts-v01"
tags: [roblox-knowledge, asset]
---

# magnet-ui-window-concepts-v01

## Назначение

Six raster window design references using approved icons: inventory, collection, shop, upgrades, sale, settings. Not working UI components.

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: user approved; native implementation stored in magnet-ui-windows-v045 with actual Studio screenshots.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

Reference art only. Actual UI needs native adaptive components; preview illustrations do not replace approved world models.





Темы применения: [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/art|Художественный стиль и материалы]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/ui/magnet-ui-window-concepts-v01/manifest.json|ui/magnet-ui-window-concepts-v01/manifest.json]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: User request, Magnet Workshop Simulator, 2026-11-13; built-in image_gen.
- [[roblox-game-builder/assets/ui/magnet-ui-window-concepts-v01/README|README.md]]
- [[roblox-game-builder/assets/ui/magnet-ui-window-concepts-v01/manifest.json|manifest.json]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]
