---
title: "Питомцы"
tags: [roblox-knowledge, topic]
---

# Питомцы

## Назначение

Виды животных, следование, способности, ownership.

## Сохранённое знание

Каталог видов, владение, инвентарь, следование и способности — разные части системы. Детализация питомцев Fight for eggs является проектным требованием.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/npc|NPC и поведение]], [[roblox-game-builder/knowledge/topics/inventory|Инвентарь и экипировка]]

Связанный контекст: [[roblox-game-builder/knowledge/topics/economy|Экономика и прогрессия]], [[roblox-game-builder/knowledge/topics/persistence|Сохранения и миграции]], [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]]

## Исходники

Отдельного профильного пакета в каталоге не установлено. Ниже есть инструкции/рецепты; готовый универсальный модуль этим не подтверждён.

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/geometry-contact|Модели погружаются в пол, яйцо не сидит в гнезде, наземный босс парит.]]
- [[roblox-game-builder/knowledge/regressions/locomotion|Idle ходит на месте; босс не поворачивается; ходьба дёргается.]]
- [[roblox-game-builder/knowledge/regressions/item-lifecycle|Питомец после hatch не попадает в инвентарь; свойства теряются между переноской и установкой.]]

## Как проверить

Проверить несколько питомцев, исчезновение владельца и повторный вход.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: отдельный переносимый пакет не установлен.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
