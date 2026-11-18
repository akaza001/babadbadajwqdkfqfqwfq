---
title: "magnet-activity-ui-v046"
tags: [roblox-knowledge, asset]
---

# magnet-activity-ui-v046

## Назначение

Responsive cast/pull/cleaning/result surfaces, original model/camera presentations and originating project adapter.

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: implemented; Studio input and full cycle checked; physical devices pending.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

Originating shared schema and server/remotes required; all client/shared sources supplied, see README.





Темы применения: [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/interaction|Взаимодействие с миром]], [[roblox-game-builder/knowledge/topics/reveal|Раскрытие награды]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/ActivityUI.luau|ui/magnet-activity-ui-v046/client/ActivityUI.luau]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: Magnet Workshop Simulator; user requested first two next steps; 2026-11-13.
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/README|README.md]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/manifest.json|manifest.json]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/ActivityUI.luau|client/ActivityUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/AudioPresentation.luau|client/AudioPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/BiomePresentation.luau|client/BiomePresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/CastMeter.luau|client/CastMeter.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/CleaningPresentation.luau|client/CleaningPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/EquipmentUI.luau|client/EquipmentUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/FishingPresentation.luau|client/FishingPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/HudIcons.luau|client/HudIcons.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/HudNavigation.luau|client/HudNavigation.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/LakePresentation.luau|client/LakePresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/Main.project-adapter.luau|client/Main.project-adapter.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/PortalWalkthrough.luau|client/PortalWalkthrough.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/SettingsUI.luau|client/SettingsUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/WindowTheme.luau|client/WindowTheme.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/client/WorkshopWindows.luau|client/WorkshopWindows.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/ApprovedAssets.luau|shared/ApprovedAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/AudioCatalog.luau|shared/AudioCatalog.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/BiomeAssets.luau|shared/BiomeAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/BiomeCatalog.luau|shared/BiomeCatalog.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/BoardwalkFinish.luau|shared/BoardwalkFinish.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/CastRules.luau|shared/CastRules.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/CleaningGeometry.luau|shared/CleaningGeometry.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/Config.luau|shared/Config.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/EnvironmentAssets.luau|shared/EnvironmentAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/EnvironmentFinish.luau|shared/EnvironmentFinish.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/FindFactory.luau|shared/FindFactory.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/HubAssets.luau|shared/HubAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/MapAssets.luau|shared/MapAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/PierRules.luau|shared/PierRules.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/RadialLayout.luau|shared/RadialLayout.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/SceneKit.luau|shared/SceneKit.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/ShoreAppearance.luau|shared/ShoreAppearance.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/StarterLayout.luau|shared/StarterLayout.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/StarterMaterials.luau|shared/StarterMaterials.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/StarterPolish.luau|shared/StarterPolish.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/Strings.luau|shared/Strings.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/SurfaceStyle.luau|shared/SurfaceStyle.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/WaterfallAssets.luau|shared/WaterfallAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-activity-ui-v046/shared/WorldLabels.luau|shared/WorldLabels.luau]]
