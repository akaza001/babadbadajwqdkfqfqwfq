---
title: "magnet-vertical-cast-meter-v057"
tags: [roblox-knowledge, asset]
---

# magnet-vertical-cast-meter-v057

## Назначение

Vertical upward looping cast-power meter with shared server timing and bounded bridge targeting

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: saved; actual mouse/animation preview,4container sizes and3669server probes verified; physical devices pending.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

Editable project-dependent Luau; existing server release validation required; example balance is project-specific



Явные зависимости: [[roblox-game-builder/knowledge/assets/magnet-activity-ui-v046|magnet-activity-ui-v046]]

Темы применения: [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/interaction|Взаимодействие с миром]], [[roblox-game-builder/knowledge/topics/network|Сеть и серверные команды]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/ui/magnet-vertical-cast-meter-v057/client/CastMeter.luau|ui/magnet-vertical-cast-meter-v057/client/CastMeter.luau]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: Magnet Workshop Simulator;2026-11-16.
- [[roblox-game-builder/assets/ui/magnet-vertical-cast-meter-v057/README|README.md]]
- [[roblox-game-builder/assets/ui/magnet-vertical-cast-meter-v057/verification.json|verification.json]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/assets/ui/magnet-vertical-cast-meter-v057/client/CastMeter.luau|client/CastMeter.luau]]
- [[roblox-game-builder/assets/ui/magnet-vertical-cast-meter-v057/client/HudIcons.luau|client/HudIcons.luau]]
- [[roblox-game-builder/assets/ui/magnet-vertical-cast-meter-v057/client/WindowTheme.luau|client/WindowTheme.luau]]
- [[roblox-game-builder/assets/ui/magnet-vertical-cast-meter-v057/example/Config.luau|example/Config.luau]]
- [[roblox-game-builder/assets/ui/magnet-vertical-cast-meter-v057/shared/CastRules.luau|shared/CastRules.luau]]
- [[roblox-game-builder/assets/ui/magnet-vertical-cast-meter-v057/shared/StarterLayout.luau|shared/StarterLayout.luau]]
