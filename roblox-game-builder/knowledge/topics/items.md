---
title: "Предметы и каталоги"
tags: [roblox-knowledge, topic]
---

# Предметы и каталоги

## Назначение

Реестр типов и уникальные экземпляры предметов.

## Сохранённое знание

Отделить вид предмета/typeId от уникального экземпляра/UID и владения. Каталоги питают игровой UI и админ-панель. Используемые предметы исключены из общей normal-map политики.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/model|Модели и сборка]], [[roblox-game-builder/knowledge/topics/network|Сеть и серверные команды]]

Связанный контекст: Связи с другими темами определяются задачей.

## Исходники

- [[roblox-game-builder/knowledge/assets/magnet-biome-fishing-v048|magnet-biome-fishing-v048]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-finds-v050|magnet-biome-finds-v050]]
- [[roblox-game-builder/knowledge/assets/simulator-template-v001|simulator-template-v001]]
- [[roblox-game-builder/knowledge/assets/magnet-expanded-finds-v060|magnet-expanded-finds-v060]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]
- [[roblox-game-builder/references/asset-memory|asset-memory.md]]
- [[roblox-game-builder/references/admin-panel|admin-panel.md]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/carry-and-grip|Руки качаются с переносимым яйцом; персонаж лежит лицом вниз; оружие ориентировано неестественно.]]
- [[roblox-game-builder/knowledge/regressions/combat-contract|Новая модель без hitbox, не атакует или машет без урона.]]
- [[roblox-game-builder/knowledge/regressions/item-lifecycle|Питомец после hatch не попадает в инвентарь; свойства теряются между переноской и установкой.]]
- [[roblox-game-builder/knowledge/regressions/spawn-invariants|Нарушается шахматный порядок, яйца разбросаны, повторяется запрещённый босс.]]
- [[roblox-game-builder/knowledge/regressions/required-world-material|Пропуск заданной пользователем текстуры при создании объекта или её применение к используемому предмету.]]

## Как проверить

Проверить экипировку, снятие, повторную выдачу и неизвестный ID.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
