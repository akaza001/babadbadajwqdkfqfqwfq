---
title: "Интеграция игрового цикла"
tags: [roblox-knowledge, topic]
---

# Интеграция игрового цикла

## Назначение

Работающий игровой цикл с выбранными подсистемами.

## Сохранённое знание

Собрать действие → серверный результат → UI → сохранение → повторный вход. Проверять новую пустую игру отдельно от исходной; проектные адаптеры не составляют готовый шаблон автоматически.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/map|Карты и биомы]], [[roblox-game-builder/knowledge/topics/network|Сеть и серверные команды]], [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/admin|Админ-панель]]

Связанный контекст: [[roblox-game-builder/knowledge/topics/pets|Питомцы]], [[roblox-game-builder/knowledge/topics/combat|Бой]], [[roblox-game-builder/knowledge/topics/persistence|Сохранения и миграции]], [[roblox-game-builder/knowledge/topics/monetization|Покупки и монетизация]]

## Исходники

- [[roblox-game-builder/knowledge/assets/magnet-biome-fishing-v048|magnet-biome-fishing-v048]]
- [[roblox-game-builder/knowledge/assets/simulator-template-v001|simulator-template-v001]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/idempotent-rebuild|После замены остались старые стены/объекты или не все модели обновились.]]
- [[roblox-game-builder/knowledge/regressions/unobtrusive-hints|Всплывающие подсказки занимают почти весь экран и мешают тестировать игру.]]

## Как проверить

Плейтест от входа до результата и повторения цикла.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
