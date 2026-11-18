---
title: "magnet-onboarding-ui-v047"
tags: [roblox-knowledge, asset]
---

# magnet-onboarding-ui-v047

## Назначение

Optional native guide HUD/manual help/settings integration with read-only progression goals; first4steps plus economy goals.

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: implemented and saved; validation scope in verification.md.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

See supplied README and verification; original schema/remotes/layout required.





Темы применения: [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/interaction|Взаимодействие с миром]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/OnboardingUI.luau|ui/magnet-onboarding-ui-v047/client/OnboardingUI.luau]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: Magnet Workshop Simulator;2026-11-14.
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/README|README.md]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/verification|verification.md]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/manifest.json|manifest.json]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/ActivityUI.luau|client/ActivityUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/AudioPresentation.luau|client/AudioPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/BiomePresentation.luau|client/BiomePresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/CastMeter.luau|client/CastMeter.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/CleaningPresentation.luau|client/CleaningPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/EquipmentUI.luau|client/EquipmentUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/FishingPresentation.luau|client/FishingPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/HudIcons.luau|client/HudIcons.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/HudNavigation.luau|client/HudNavigation.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/LakePresentation.luau|client/LakePresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/Main.project-adapter.luau|client/Main.project-adapter.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/OnboardingUI.luau|client/OnboardingUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/PortalWalkthrough.luau|client/PortalWalkthrough.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/SettingsUI.luau|client/SettingsUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/WindowTheme.luau|client/WindowTheme.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/client/WorkshopWindows.luau|client/WorkshopWindows.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/ApprovedAssets.luau|shared/ApprovedAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/AudioCatalog.luau|shared/AudioCatalog.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/BiomeAssets.luau|shared/BiomeAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/BiomeCatalog.luau|shared/BiomeCatalog.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/BoardwalkFinish.luau|shared/BoardwalkFinish.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/CastRules.luau|shared/CastRules.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/CleaningGeometry.luau|shared/CleaningGeometry.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/Config.luau|shared/Config.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/EnvironmentAssets.luau|shared/EnvironmentAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/EnvironmentFinish.luau|shared/EnvironmentFinish.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/FindFactory.luau|shared/FindFactory.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/GuideRules.luau|shared/GuideRules.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/HubAssets.luau|shared/HubAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/MapAssets.luau|shared/MapAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/PierRules.luau|shared/PierRules.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/RadialLayout.luau|shared/RadialLayout.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/SceneKit.luau|shared/SceneKit.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/ShoreAppearance.luau|shared/ShoreAppearance.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/StarterLayout.luau|shared/StarterLayout.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/StarterMaterials.luau|shared/StarterMaterials.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/StarterPolish.luau|shared/StarterPolish.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/Strings.luau|shared/Strings.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/SurfaceStyle.luau|shared/SurfaceStyle.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/WaterfallAssets.luau|shared/WaterfallAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-onboarding-ui-v047/shared/WorldLabels.luau|shared/WorldLabels.luau]]
