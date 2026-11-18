---
title: "magnet-biome-worlds-v050"
tags: [roblox-knowledge, asset]
---

# magnet-biome-worlds-v050

## Назначение

Nine open biome scene recipes with saved-pack art, water, docks and themed materials

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: saved; server gameplay, cloud schema and responsive layout verified; final full visual tour and physical devices pending.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

Luau generators/native UI; install supplied dependencies into the documented hierarchy; external Roblox content access required



Явные зависимости: [[roblox-game-builder/knowledge/assets/magnet-starter-albedos-v045|magnet-starter-albedos-v045]], [[roblox-game-builder/knowledge/assets/magnet-shore-assembly-v040|magnet-shore-assembly-v040]]

Темы применения: [[roblox-game-builder/knowledge/topics/map|Карты и биомы]], [[roblox-game-builder/knowledge/topics/model|Модели и сборка]], [[roblox-game-builder/knowledge/topics/procedural|Процедурная генерация]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/BiomeAssets.luau|models/magnet-biome-worlds-v050/shared/BiomeAssets.luau]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: Magnet Workshop Simulator;2026-11-14.
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/README|README.md]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/server/WorldBuilder.luau|server/WorldBuilder.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/server/WorldMetadata.luau|server/WorldMetadata.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/server/WorldMetadataData01.luau|server/WorldMetadataData01.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/server/WorldMetadataData02.luau|server/WorldMetadataData02.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/server/WorldMetadataData03.luau|server/WorldMetadataData03.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/ApprovedAssets.luau|shared/ApprovedAssets.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/AudioCatalog.luau|shared/AudioCatalog.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/BiomeAssets.luau|shared/BiomeAssets.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/BiomeCatalog.luau|shared/BiomeCatalog.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/BiomeFinish.luau|shared/BiomeFinish.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/BiomeFishing.luau|shared/BiomeFishing.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/BoardwalkFinish.luau|shared/BoardwalkFinish.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/CastRules.luau|shared/CastRules.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/Config.luau|shared/Config.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/EnvironmentAssets.luau|shared/EnvironmentAssets.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/EnvironmentFinish.luau|shared/EnvironmentFinish.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/HubAssets.luau|shared/HubAssets.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/MapAssets.luau|shared/MapAssets.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/PierRules.luau|shared/PierRules.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/RadialLayout.luau|shared/RadialLayout.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/SceneKit.luau|shared/SceneKit.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/ShoreAppearance.luau|shared/ShoreAppearance.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/StarterLayout.luau|shared/StarterLayout.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/StarterMaterials.luau|shared/StarterMaterials.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/StarterPolish.luau|shared/StarterPolish.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/Strings.luau|shared/Strings.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/SurfaceStyle.luau|shared/SurfaceStyle.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/WaterfallAssets.luau|shared/WaterfallAssets.luau]]
- [[roblox-game-builder/assets/models/magnet-biome-worlds-v050/shared/WorldLabels.luau|shared/WorldLabels.luau]]
