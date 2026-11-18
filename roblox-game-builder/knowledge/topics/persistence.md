---
title: "Сохранения и миграции"
tags: [roblox-knowledge, topic]
---

# Сохранения и миграции

## Назначение

Версия профиля, миграция и сериализация состояния.

## Сохранённое знание

Профиль имеет версию, миграции и контроль повторных операций. Сброс и autosave должны быть согласованы; отчёт изолированной cloud-проверки не доказывает переносимость в другую игру.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/economy|Экономика и прогрессия]], [[roblox-game-builder/knowledge/topics/inventory|Инвентарь и экипировка]]

Связанный контекст: Связи с другими темами определяются задачей.

## Исходники

- [[roblox-game-builder/knowledge/assets/offline-money|offline-money]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-fishing-v048|magnet-biome-fishing-v048]]
- [[roblox-game-builder/knowledge/assets/magnet-admin-panel-v056|magnet-admin-panel-v056]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/display-not-state|Формат целых чисел может менять начисления; очки и реальная скорость смешиваются.]]
- [[roblox-game-builder/knowledge/regressions/item-lifecycle|Питомец после hatch не попадает в инвентарь; свойства теряются между переноской и установкой.]]

## Как проверить

Тестовый профиль: выход/вход, ошибка записи, старый формат.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
