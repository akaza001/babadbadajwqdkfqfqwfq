---
title: "Экономика и прогрессия"
tags: [roblox-knowledge, topic]
---

# Экономика и прогрессия

## Назначение

Источники и траты ресурсов, цены, прогрессия.

## Сохранённое знание

Цены и источники ресурсов заданы конфигом, начисление и траты — сервером. Повтор команды не дублирует награду. Универсальная XP/rebirth прогрессия пока не доказана сохранёнными пакетами.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/network|Сеть и серверные команды]]

Связанный контекст: Связи с другими темами определяются задачей.

## Исходники

- [[roblox-game-builder/knowledge/assets/offline-money|offline-money]]
- [[roblox-game-builder/knowledge/assets/magnet-ui-windows-v044|magnet-ui-windows-v044]]
- [[roblox-game-builder/knowledge/assets/magnet-ui-windows-v045|magnet-ui-windows-v045]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-fishing-v048|magnet-biome-fishing-v048]]
- [[roblox-game-builder/knowledge/assets/magnet-admin-panel-v056|magnet-admin-panel-v056]]
- [[roblox-game-builder/knowledge/assets/simulator-template-v001|simulator-template-v001]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/display-not-state|Формат целых чисел может менять начисления; очки и реальная скорость смешиваются.]]
- [[roblox-game-builder/knowledge/regressions/latest-decision|В старой переписке есть отменённые ограничения и противоречащие UI-решения.]]

## Как проверить

Проверить невозможность отрицательного баланса и двойной награды.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
