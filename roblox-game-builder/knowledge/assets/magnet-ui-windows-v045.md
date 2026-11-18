---
title: "magnet-ui-windows-v045"
tags: [roblox-knowledge, asset]
---

# magnet-ui-windows-v045

## Назначение

Native scalable inventory, collection, shop, upgrades, sale and audio controls with actual model previews.

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: portable files stored; applied and checked in Studio; see README for scope/limits.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

Originating project schema/dependencies are included; adapter is project-specific. See README.





Темы применения: [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/inventory|Инвентарь и экипировка]], [[roblox-game-builder/knowledge/topics/economy|Экономика и прогрессия]], [[roblox-game-builder/knowledge/topics/customization|Кастомизация]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/WindowTheme.luau|ui/magnet-ui-windows-v045/WindowTheme.luau]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: Magnet Workshop Simulator; user-approved implementation; 2026-11-13.
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/README|README.md]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/AudioPresentation.luau|AudioPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/HudIcons.luau|HudIcons.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/HudNavigation.luau|HudNavigation.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/Main.project-adapter.luau|Main.project-adapter.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/SettingsUI.luau|SettingsUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/WindowTheme.luau|WindowTheme.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/WorkshopWindows.luau|WorkshopWindows.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/ApprovedAssets.luau|shared/ApprovedAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/AudioCatalog.luau|shared/AudioCatalog.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/BiomeAssets.luau|shared/BiomeAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/BiomeCatalog.luau|shared/BiomeCatalog.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/BoardwalkFinish.luau|shared/BoardwalkFinish.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/CastRules.luau|shared/CastRules.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/CleaningGeometry.luau|shared/CleaningGeometry.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/Config.luau|shared/Config.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/EnvironmentAssets.luau|shared/EnvironmentAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/EnvironmentFinish.luau|shared/EnvironmentFinish.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/FindFactory.luau|shared/FindFactory.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/HubAssets.luau|shared/HubAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/MapAssets.luau|shared/MapAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/PierRules.luau|shared/PierRules.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/RadialLayout.luau|shared/RadialLayout.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/SceneKit.luau|shared/SceneKit.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/ShoreAppearance.luau|shared/ShoreAppearance.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/StarterLayout.luau|shared/StarterLayout.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/StarterMaterials.luau|shared/StarterMaterials.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/StarterPolish.luau|shared/StarterPolish.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/Strings.luau|shared/Strings.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/SurfaceStyle.luau|shared/SurfaceStyle.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/WaterfallAssets.luau|shared/WaterfallAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v045/shared/WorldLabels.luau|shared/WorldLabels.luau]]
