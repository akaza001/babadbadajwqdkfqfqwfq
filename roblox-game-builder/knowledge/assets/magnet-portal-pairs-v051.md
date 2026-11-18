---
title: "magnet-portal-pairs-v051"
tags: [roblox-knowledge, asset]
---

# magnet-portal-pairs-v051

## Назначение

Paired themed portal clones and marker-relative arrivals

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: saved; all8 copies and16 automatic travels verified; physical devices pending.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

Luau with documented dependencies; images are review PNGs, require explicit Roblox import before runtime use



Явные зависимости: [[roblox-game-builder/knowledge/assets/magnet-biome-worlds-v050|magnet-biome-worlds-v050]], [[roblox-game-builder/knowledge/assets/magnet-biome-exploration-v050|magnet-biome-exploration-v050]]

Темы применения: [[roblox-game-builder/knowledge/topics/map|Карты и биомы]], [[roblox-game-builder/knowledge/topics/interaction|Взаимодействие с миром]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/models/magnet-portal-pairs-v051/shared/PortalLayout.luau|models/magnet-portal-pairs-v051/shared/PortalLayout.luau]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: Magnet Workshop Simulator;2026-11-14.
- [[roblox-game-builder/assets/models/magnet-portal-pairs-v051/README|README.md]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/assets/models/magnet-portal-pairs-v051/client/PortalWalkthrough.luau|client/PortalWalkthrough.luau]]
- [[roblox-game-builder/assets/models/magnet-portal-pairs-v051/server/PortalService.luau|server/PortalService.luau]]
- [[roblox-game-builder/assets/models/magnet-portal-pairs-v051/server/WorldBuilder.luau|server/WorldBuilder.luau]]
- [[roblox-game-builder/assets/models/magnet-portal-pairs-v051/server/WorldMetadata.luau|server/WorldMetadata.luau]]
- [[roblox-game-builder/assets/models/magnet-portal-pairs-v051/server/WorldMetadataData01.luau|server/WorldMetadataData01.luau]]
- [[roblox-game-builder/assets/models/magnet-portal-pairs-v051/server/WorldMetadataData02.luau|server/WorldMetadataData02.luau]]
- [[roblox-game-builder/assets/models/magnet-portal-pairs-v051/server/WorldMetadataData03.luau|server/WorldMetadataData03.luau]]
- [[roblox-game-builder/assets/models/magnet-portal-pairs-v051/shared/BiomeAssets.luau|shared/BiomeAssets.luau]]
- [[roblox-game-builder/assets/models/magnet-portal-pairs-v051/shared/BiomeCatalog.luau|shared/BiomeCatalog.luau]]
- [[roblox-game-builder/assets/models/magnet-portal-pairs-v051/shared/PortalGeometry.luau|shared/PortalGeometry.luau]]
- [[roblox-game-builder/assets/models/magnet-portal-pairs-v051/shared/PortalLayout.luau|shared/PortalLayout.luau]]
