---
title: "magnet-ui-windows-v044"
tags: [roblox-knowledge, asset]
---

# magnet-ui-windows-v044

## Назначение

Native scalable window skin, live grid/detail screens, shop/upgrades/sale and audio sliders; originating game adapter and readonly preview dependencies.

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: source stored; structural layouts and sandbox transactions passed; visual/mouse acceptance pending because viewport1x1.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

Theme requires HudIcons. Screen renderer needs originating shared hierarchy/profile schema and host callbacks; main adapter requires originating game. See README.





Темы применения: [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/inventory|Инвентарь и экипировка]], [[roblox-game-builder/knowledge/topics/economy|Экономика и прогрессия]], [[roblox-game-builder/knowledge/topics/customization|Кастомизация]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/WindowTheme.luau|ui/magnet-ui-windows-v044/WindowTheme.luau]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: User approved implementation, Magnet Workshop Simulator, 2026-11-13.
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/README|README.md]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/HudIcons.luau|HudIcons.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/AudioPresentation.luau|AudioPresentation.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/WindowTheme.luau|WindowTheme.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/WorkshopWindows.luau|WorkshopWindows.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/SettingsUI.luau|SettingsUI.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/Main.project-adapter.luau|Main.project-adapter.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/shared/FindFactory.luau|shared/FindFactory.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/shared/MapAssets.luau|shared/MapAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/shared/ApprovedAssets.luau|shared/ApprovedAssets.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/shared/AudioCatalog.luau|shared/AudioCatalog.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/shared/Config.luau|shared/Config.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/shared/SurfaceStyle.luau|shared/SurfaceStyle.luau]]
- [[roblox-game-builder/assets/ui/magnet-ui-windows-v044/shared/Strings.luau|shared/Strings.luau]]
