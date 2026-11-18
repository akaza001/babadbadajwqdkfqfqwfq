---
title: "magnet-admin-panel-v056"
tags: [roblox-knowledge, asset]
---

# magnet-admin-panel-v056

## Назначение

Personal developer admin UI from a server registry, transactions, confirmations and safe reset

## Статус: исходник и проверка отдельно

- Исходник: есть; файл доступен.
- Запись каталога: saved; protocol/cloud/actual mouse UI and confirmation verified; phone/gamepad pending.
- Новая проверка в игре при этом преобразовании: **не проводилась**. Исторические результаты действуют только в указанной в отчёте среде и объёме; физические устройства и перенос в другую игру не подразумеваются.
- Целостность файлов по имеющимся SHA/размерам: расхождений не найдено.

## Зависимости и совместимость

Project-dependent editable Luau with dependency contracts; not standalone binary; admin permission template empty



Явные зависимости: [[roblox-game-builder/knowledge/assets/magnet-ui-windows-v045|magnet-ui-windows-v045]], [[roblox-game-builder/knowledge/assets/magnet-hud-icons-v01|magnet-hud-icons-v01]]

Темы применения: [[roblox-game-builder/knowledge/topics/admin|Админ-панель]], [[roblox-game-builder/knowledge/topics/network|Сеть и серверные команды]], [[roblox-game-builder/knowledge/topics/persistence|Сохранения и миграции]], [[roblox-game-builder/knowledge/topics/economy|Экономика и прогрессия]].

## Исходники и свидетельства

- Точка входа: [[roblox-game-builder/assets/ui/magnet-admin-panel-v056/client/AdminPanel.luau|ui/magnet-admin-panel-v056/client/AdminPanel.luau]].
- Полный список файлов/контрольных сумм: [[roblox-game-builder/assets/catalog.json|каталог]].
- Происхождение: Magnet Workshop Simulator;2026-11-15.
- [[roblox-game-builder/assets/ui/magnet-admin-panel-v056/README|README.md]]
- [[roblox-game-builder/assets/ui/magnet-admin-panel-v056/verification|verification.md]]

## Ошибки и ограничения

Не подменять адаптацию слепой заменой host-модулей. Проверить внешние IDs, схему профиля, иерархию и очистку. PNG-концепт не является интерактивным экраном; проектный адаптер не является универсальным установщиком.



## Как проверить

Сначала прочитать контракт/отчёт выше, затем подключить копию в отдельной тестовой игре, проверить её зависимости и сценарии связанных тем. Повторная сборка не должна дублировать объекты; новый запуск/respawn должен сохранять корректное поведение. Для UI проверить реальные клики и малый экран, для карт — проходы и коллизии, для транзакций — повтор запроса и повторный вход.

[[roblox-game-builder/knowledge/assets|Все ассеты]] · [[roblox-game-builder/knowledge/gaps|Карта пробелов]]

## Сохранённые Luau-исходники

- [[roblox-game-builder/assets/ui/magnet-admin-panel-v056/client/AdminPanel.luau|client/AdminPanel.luau]]
- [[roblox-game-builder/assets/ui/magnet-admin-panel-v056/client/HudIcons.luau|client/HudIcons.luau]]
- [[roblox-game-builder/assets/ui/magnet-admin-panel-v056/client/WindowTheme.luau|client/WindowTheme.luau]]
- [[roblox-game-builder/assets/ui/magnet-admin-panel-v056/integration/client/Main.client.luau|integration/client/Main.client.luau]]
- [[roblox-game-builder/assets/ui/magnet-admin-panel-v056/integration/server/Bootstrap.server.luau|integration/server/Bootstrap.server.luau]]
- [[roblox-game-builder/assets/ui/magnet-admin-panel-v056/integration/server/GameService.luau|integration/server/GameService.luau]]
- [[roblox-game-builder/assets/ui/magnet-admin-panel-v056/integration/server/ProfileStore.luau|integration/server/ProfileStore.luau]]
- [[roblox-game-builder/assets/ui/magnet-admin-panel-v056/server/AdminConfig.luau|server/AdminConfig.luau]]
- [[roblox-game-builder/assets/ui/magnet-admin-panel-v056/server/AdminRegistry.luau|server/AdminRegistry.luau]]
- [[roblox-game-builder/assets/ui/magnet-admin-panel-v056/server/AdminService.luau|server/AdminService.luau]]
