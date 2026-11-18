---
title: "Инвентарь и экипировка"
tags: [roblox-knowledge, topic]
---

# Инвентарь и экипировка

## Назначение

Инвентарь, вместимость, экипировка и UI-модель.

## Сохранённое знание

Вместимость, выдача, удаление и экипировка проходят серверный сервис. Удаление предмета очищает его размещение/экипировку; UI отображает подтверждённое состояние.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/items|Предметы и каталоги]]

Связанный контекст: [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/persistence|Сохранения и миграции]]

## Исходники

- [[roblox-game-builder/knowledge/assets/magnet-ui-windows-v044|magnet-ui-windows-v044]]
- [[roblox-game-builder/knowledge/assets/magnet-ui-windows-v045|magnet-ui-windows-v045]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-fishing-v048|magnet-biome-fishing-v048]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-finds-v050|magnet-biome-finds-v050]]
- [[roblox-game-builder/knowledge/assets/simulator-template-v001|simulator-template-v001]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/item-lifecycle|Питомец после hatch не попадает в инвентарь; свойства теряются между переноской и установкой.]]

## Как проверить

Проверить дубликаты запроса и полную вместимость.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
