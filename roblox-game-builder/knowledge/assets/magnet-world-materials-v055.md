---
title: "magnet-world-materials-v055"
tags: [roblox-knowledge, asset]
---

# magnet-world-materials-v055

## Назначение

Six neutral world albedos and tint-preserving material recipes, uniform square relief scale, calm water

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: saved;8 maps loaded in Play;7 real views and water motion reviewed; geometry/repeat/fresh build verified; full scene/device QA pending.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

PNG albedo maps plus project-dependent Luau integration; no standalone RBXM; tint/normal/UV guidance in README



Явные зависимости: [[roblox-game-builder/knowledge/assets/square-relief-normal|square-relief-normal]], [[roblox-game-builder/knowledge/assets/magnet-starter-albedos-v045|magnet-starter-albedos-v045]], [[roblox-game-builder/knowledge/assets/magnet-biome-walls-joints-v054|magnet-biome-walls-joints-v054]]

Темы применения: [[roblox-game-builder/knowledge/topics/art|Художественный стиль и материалы]], [[roblox-game-builder/knowledge/topics/map|Карты и биомы]], [[roblox-game-builder/knowledge/topics/model|Модели и сборка]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/textures/magnet-world-materials-v055/manifest.json|textures/magnet-world-materials-v055/manifest.json]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: Magnet Workshop Simulator; built-in image_gen;2026-11-15.
- [[roblox-game-builder/assets/textures/magnet-world-materials-v055/README|README.md]]
- [[roblox-game-builder/assets/textures/magnet-world-materials-v055/verification|verification.md]]
- [[roblox-game-builder/assets/textures/magnet-world-materials-v055/manifest.json|manifest.json]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/assets/textures/magnet-world-materials-v055/integration/client/LakePresentation.luau|integration/client/LakePresentation.luau]]
- [[roblox-game-builder/assets/textures/magnet-world-materials-v055/integration/client/Main.client.luau|integration/client/Main.client.luau]]
- [[roblox-game-builder/assets/textures/magnet-world-materials-v055/integration/server/WorldBuilder.luau|integration/server/WorldBuilder.luau]]
- [[roblox-game-builder/assets/textures/magnet-world-materials-v055/integration/shared/MaterialRefinement.luau|integration/shared/MaterialRefinement.luau]]
- [[roblox-game-builder/assets/textures/magnet-world-materials-v055/integration/shared/ShoreAppearance.luau|integration/shared/ShoreAppearance.luau]]
- [[roblox-game-builder/assets/textures/magnet-world-materials-v055/integration/shared/SurfaceStyle.luau|integration/shared/SurfaceStyle.luau]]
