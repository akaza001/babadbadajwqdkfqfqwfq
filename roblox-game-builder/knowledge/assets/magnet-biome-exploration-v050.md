---
title: "magnet-biome-exploration-v050"
tags: [roblox-knowledge, asset]
---

# magnet-biome-exploration-v050

## Назначение

Native biome checklist, origins, previews and authoritative gameplay integration

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: saved; server gameplay, cloud schema and responsive layout verified; final full visual tour and physical devices pending.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

Luau generators/native UI; install supplied dependencies into the documented hierarchy; external Roblox content access required



Явные зависимости: [[roblox-game-builder/knowledge/assets/magnet-biome-worlds-v050|magnet-biome-worlds-v050]], [[roblox-game-builder/knowledge/assets/magnet-biome-finds-v050|magnet-biome-finds-v050]], [[roblox-game-builder/knowledge/assets/magnet-hud-icons-v01|magnet-hud-icons-v01]]

Темы применения: [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/interaction|Взаимодействие с миром]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/OnboardingUI.luau|ui/magnet-biome-exploration-v050/client/OnboardingUI.luau]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: Magnet Workshop Simulator;2026-11-14.
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/README|README.md]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/ActivityUI.luau|client/ActivityUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/AudioPresentation.luau|client/AudioPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/BiomePresentation.luau|client/BiomePresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/CastMeter.luau|client/CastMeter.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/CleaningPresentation.luau|client/CleaningPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/EquipmentUI.luau|client/EquipmentUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/FishingPresentation.luau|client/FishingPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/HudIcons.luau|client/HudIcons.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/HudNavigation.luau|client/HudNavigation.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/LakePresentation.luau|client/LakePresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/Main.client.luau|client/Main.client.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/OnboardingUI.luau|client/OnboardingUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/PortalWalkthrough.luau|client/PortalWalkthrough.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/SettingsUI.luau|client/SettingsUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/WindowTheme.luau|client/WindowTheme.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/client/WorkshopWindows.luau|client/WorkshopWindows.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/server/Bootstrap.server.luau|server/Bootstrap.server.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/server/GameService.luau|server/GameService.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/server/MagnetEquipment.luau|server/MagnetEquipment.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/server/PortalService.luau|server/PortalService.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/server/ProfileStore.luau|server/ProfileStore.luau]]
- [[roblox-game-builder/assets/ui/magnet-biome-exploration-v050/shared/GuideRules.luau|shared/GuideRules.luau]]
