---
title: "Анимации и переходы"
tags: [roblox-knowledge, topic]
---

# Анимации и переходы

## Назначение

Клипы и переходы idle/move/action, согласованные с ригом.

## Сохранённое знание

Разделить idle, движение и действие; согласовать скорость цикла и переходы. Процедурная камера/переворот предмета не заменяет библиотеку клипов персонажа.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/rig|Риги и суставы]]

Связанный контекст: [[roblox-game-builder/knowledge/topics/combat|Бой]], [[roblox-game-builder/knowledge/topics/pets|Питомцы]], [[roblox-game-builder/knowledge/topics/vfx-audio|Эффекты и звук]]

## Исходники

- [[roblox-game-builder/knowledge/assets/magnet-cleaning-presentation-v056|magnet-cleaning-presentation-v056]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]
- [[roblox-game-builder/references/asset-memory|asset-memory.md]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/locomotion|Idle ходит на месте; босс не поворачивается; ходьба дёргается.]]
- [[roblox-game-builder/knowledge/regressions/species-animation|Змея стоит, маг не поднимает посох, существо без крыльев летает.]]
- [[roblox-game-builder/knowledge/regressions/carry-and-grip|Руки качаются с переносимым яйцом; персонаж лежит лицом вниз; оружие ориентировано неестественно.]]
- [[roblox-game-builder/knowledge/regressions/measured-performance|Камера лагает после обновления, существа дёргаются; оптимизация портит внешний вид.]]

## Как проверить

Наблюдать idle, движение, остановку, атаку и повторное появление.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
