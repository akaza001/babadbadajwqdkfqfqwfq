---
title: "magnet-guided-navigation-v049"
tags: [roblox-knowledge, asset]
---

# magnet-guided-navigation-v049

## Назначение

Projected native target arrows and idempotent walk-through loading controller, in approved light theme.

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: saved; Studio visual/input and responsive cases verified; physical devices pending.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

Host full-screen safe-inset Frame, originating HUD bounds and authoritative remotes/schema; supplied client/shared sources, server protocol in biome-fishing-v048.





Темы применения: [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/interaction|Взаимодействие с миром]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/OnboardingUI.luau|ui/magnet-guided-navigation-v049/client/OnboardingUI.luau]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: Magnet Workshop Simulator;2026-11-14.
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/README|README.md]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/verification|verification.md]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/manifest.json|manifest.json]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/ActivityUI.luau|client/ActivityUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/AudioPresentation.luau|client/AudioPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/BiomePresentation.luau|client/BiomePresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/CastMeter.luau|client/CastMeter.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/CleaningPresentation.luau|client/CleaningPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/EquipmentUI.luau|client/EquipmentUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/FishingPresentation.luau|client/FishingPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/HudIcons.luau|client/HudIcons.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/HudNavigation.luau|client/HudNavigation.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/LakePresentation.luau|client/LakePresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/Main.project-adapter.luau|client/Main.project-adapter.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/OnboardingUI.luau|client/OnboardingUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/PortalWalkthrough.luau|client/PortalWalkthrough.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/SettingsUI.luau|client/SettingsUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/WindowTheme.luau|client/WindowTheme.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/client/WorkshopWindows.luau|client/WorkshopWindows.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/ApprovedAssets.luau|shared/ApprovedAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/AudioCatalog.luau|shared/AudioCatalog.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/BiomeAssets.luau|shared/BiomeAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/BiomeCatalog.luau|shared/BiomeCatalog.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/BiomeFishing.luau|shared/BiomeFishing.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/BoardwalkFinish.luau|shared/BoardwalkFinish.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/CastRules.luau|shared/CastRules.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/CleaningGeometry.luau|shared/CleaningGeometry.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/Config.luau|shared/Config.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/EnvironmentAssets.luau|shared/EnvironmentAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/EnvironmentFinish.luau|shared/EnvironmentFinish.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/FindFactory.luau|shared/FindFactory.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/GuideRules.luau|shared/GuideRules.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/HubAssets.luau|shared/HubAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/MapAssets.luau|shared/MapAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/PierRules.luau|shared/PierRules.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/RadialLayout.luau|shared/RadialLayout.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/SceneKit.luau|shared/SceneKit.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/ShoreAppearance.luau|shared/ShoreAppearance.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/StarterLayout.luau|shared/StarterLayout.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/StarterMaterials.luau|shared/StarterMaterials.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/StarterPolish.luau|shared/StarterPolish.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/Strings.luau|shared/Strings.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/SurfaceStyle.luau|shared/SurfaceStyle.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/WaterfallAssets.luau|shared/WaterfallAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-guided-navigation-v049/shared/WorldLabels.luau|shared/WorldLabels.luau]]
