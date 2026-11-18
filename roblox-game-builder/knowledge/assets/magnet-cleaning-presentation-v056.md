---
title: "magnet-cleaning-presentation-v056"
tags: [roblox-knowledge, asset]
---

# magnet-cleaning-presentation-v056

## Назначение

Closer top-down cleaning camera with safe rotating-box fit and cancellation lifecycle

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: saved;180fit cases, F13 before/after/26frame flip/finish reviewed; every item/device visual pending.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

Project-dependent editable Luau with dependency contracts; not standalone binary; admin permission template empty



Явные зависимости: [[roblox-game-builder/knowledge/assets/magnet-activity-ui-v046|magnet-activity-ui-v046]], [[roblox-game-builder/knowledge/assets/magnet-biome-finds-v050|magnet-biome-finds-v050]]

Темы применения: [[roblox-game-builder/knowledge/topics/animation|Анимации и переходы]], [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/interaction|Взаимодействие с миром]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/ui/magnet-cleaning-presentation-v056/client/CleaningPresentation.luau|ui/magnet-cleaning-presentation-v056/client/CleaningPresentation.luau]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: Magnet Workshop Simulator;2026-11-15.
- [[roblox-game-builder/assets/ui/magnet-cleaning-presentation-v056/README|README.md]]
- [[roblox-game-builder/assets/ui/magnet-cleaning-presentation-v056/verification.json|verification.json]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/assets/ui/magnet-cleaning-presentation-v056/client/CleaningPresentation.luau|client/CleaningPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-cleaning-presentation-v056/qa/camera-tests.luau|qa/camera-tests.luau]]
- [[roblox-game-builder/assets/ui/magnet-cleaning-presentation-v056/qa/old-camera.luau|qa/old-camera.luau]]
