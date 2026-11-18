---
title: "Карты и биомы"
tags: [roblox-knowledge, topic]
---

# Карты и биомы

## Назначение

Блокаут, маршруты, спавны, зоны и масштаб.

## Сохранённое знание

Использовать стабильные ID биомов, согласованные входы/прибытия и повторяемую сборку. Декор не должен перекрывать маршруты; коллизии отделяются от внешнего вида.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/brief|Цель и критерии игры]]

Связанный контекст: [[roblox-game-builder/knowledge/topics/npc|NPC и поведение]], [[roblox-game-builder/knowledge/topics/combat|Бой]], [[roblox-game-builder/knowledge/topics/performance|Производительность]]

## Исходники

- [[roblox-game-builder/knowledge/assets/waterfall|waterfall]]
- [[roblox-game-builder/knowledge/assets/stud-asset-pack|stud-asset-pack]]
- [[roblox-game-builder/knowledge/assets/square-relief-normal|square-relief-normal]]
- [[roblox-game-builder/knowledge/assets/magnet-shore-assembly-v038|magnet-shore-assembly-v038]]
- [[roblox-game-builder/knowledge/assets/magnet-shore-assembly-v039|magnet-shore-assembly-v039]]
- [[roblox-game-builder/knowledge/assets/magnet-shore-assembly-v040|magnet-shore-assembly-v040]]
- [[roblox-game-builder/knowledge/assets/magnet-starter-albedos-v045|magnet-starter-albedos-v045]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-fishing-v048|magnet-biome-fishing-v048]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-worlds-v050|magnet-biome-worlds-v050]]
- [[roblox-game-builder/knowledge/assets/magnet-portal-pairs-v051|magnet-portal-pairs-v051]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-walls-joints-v054|magnet-biome-walls-joints-v054]]
- [[roblox-game-builder/knowledge/assets/magnet-world-materials-v055|magnet-world-materials-v055]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]
- [[roblox-game-builder/references/visual-style|visual-style.md]]
- [[roblox-game-builder/references/material-policy|material-policy.md]]
- [[roblox-game-builder/references/model-library|model-library.md]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/geometry-contact|Модели погружаются в пол, яйцо не сидит в гнезде, наземный босс парит.]]
- [[roblox-game-builder/knowledge/regressions/texture-phase|Шахматный рисунок ломается на стыке, остаются полосы и второй рельеф.]]
- [[roblox-game-builder/knowledge/regressions/idempotent-rebuild|После замены остались старые стены/объекты или не все модели обновились.]]
- [[roblox-game-builder/knowledge/regressions/consistent-layout|Таблички перекрывают лидерборды, порядок тренажёров различается, апгрейд поворачивает объект обратно.]]
- [[roblox-game-builder/knowledge/regressions/visibility-vs-collision|Под «прозрачным» имелось в виду проходимое, но видимое.]]
- [[roblox-game-builder/knowledge/regressions/spawn-invariants|Нарушается шахматный порядок, яйца разбросаны, повторяется запрещённый босс.]]
- [[roblox-game-builder/knowledge/regressions/measured-performance|Камера лагает после обновления, существа дёргаются; оптимизация портит внешний вид.]]
- [[roblox-game-builder/knowledge/regressions/required-world-material|Пропуск заданной пользователем текстуры при создании объекта или её применение к используемому предмету.]]

## Как проверить

Пройти маршруты в Play; проверить респавн и недоступные зоны.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
