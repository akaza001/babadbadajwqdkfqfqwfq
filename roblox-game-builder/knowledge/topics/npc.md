---
title: "NPC и поведение"
tags: [roblox-knowledge, topic]
---

# NPC и поведение

## Назначение

Состояния NPC, цели, навигация и восстановление.

## Сохранённое знание

Разделить состояния, выбор цели и навигацию. Смерть, потеря цели и респавн требуют явной очистки; универсальная высота корня не подходит всем моделям.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/animation|Анимации и переходы]], [[roblox-game-builder/knowledge/topics/network|Сеть и серверные команды]], [[roblox-game-builder/knowledge/topics/map|Карты и биомы]]

Связанный контекст: Связи с другими темами определяются задачей.

## Исходники

Отдельного профильного пакета в каталоге не установлено. Ниже есть инструкции/рецепты; готовый универсальный модуль этим не подтверждён.

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/geometry-contact|Модели погружаются в пол, яйцо не сидит в гнезде, наземный босс парит.]]
- [[roblox-game-builder/knowledge/regressions/locomotion|Idle ходит на месте; босс не поворачивается; ходьба дёргается.]]
- [[roblox-game-builder/knowledge/regressions/species-animation|Змея стоит, маг не поднимает посох, существо без крыльев летает.]]
- [[roblox-game-builder/knowledge/regressions/combat-contract|Новая модель без hitbox, не атакует или машет без урона.]]
- [[roblox-game-builder/knowledge/regressions/spawn-invariants|Нарушается шахматный порядок, яйца разбросаны, повторяется запрещённый босс.]]

## Как проверить

Проверить потерю цели, препятствие, смерть и респавн.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: отдельный переносимый пакет не установлен.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
