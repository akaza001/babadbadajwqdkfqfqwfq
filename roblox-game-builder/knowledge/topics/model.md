---
title: "Модели и сборка"
tags: [roblox-knowledge, topic]
---

# Модели и сборка

## Назначение

Модель с pivot, масштабом и разделёнными физикой/визуалом.

## Сохранённое знание

До моделирования искать готовое в библиотеке. Сохранять исходники и pivot; адаптировать копии. Набор RBXM с непроверенным составом не равен готовому каталогу деталей.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/art|Художественный стиль и материалы]]

Связанный контекст: Связи с другими темами определяются задачей.

## Исходники

- [[roblox-game-builder/knowledge/assets/waterfall|waterfall]]
- [[roblox-game-builder/knowledge/assets/stud-asset-pack|stud-asset-pack]]
- [[roblox-game-builder/knowledge/assets/square-relief-normal|square-relief-normal]]
- [[roblox-game-builder/knowledge/assets/magnet-shore-assembly-v038|magnet-shore-assembly-v038]]
- [[roblox-game-builder/knowledge/assets/magnet-shore-assembly-v039|magnet-shore-assembly-v039]]
- [[roblox-game-builder/knowledge/assets/magnet-shore-assembly-v040|magnet-shore-assembly-v040]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-worlds-v050|magnet-biome-worlds-v050]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-finds-v050|magnet-biome-finds-v050]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-walls-joints-v054|magnet-biome-walls-joints-v054]]
- [[roblox-game-builder/knowledge/assets/magnet-world-materials-v055|magnet-world-materials-v055]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]
- [[roblox-game-builder/references/model-library|model-library.md]]
- [[roblox-game-builder/references/material-policy|material-policy.md]]
- [[roblox-game-builder/references/asset-memory|asset-memory.md]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/geometry-contact|Модели погружаются в пол, яйцо не сидит в гнезде, наземный босс парит.]]
- [[roblox-game-builder/knowledge/regressions/texture-phase|Шахматный рисунок ломается на стыке, остаются полосы и второй рельеф.]]
- [[roblox-game-builder/knowledge/regressions/idempotent-rebuild|После замены остались старые стены/объекты или не все модели обновились.]]
- [[roblox-game-builder/knowledge/regressions/consistent-layout|Таблички перекрывают лидерборды, порядок тренажёров различается, апгрейд поворачивает объект обратно.]]
- [[roblox-game-builder/knowledge/regressions/visibility-vs-collision|Под «прозрачным» имелось в виду проходимое, но видимое.]]
- [[roblox-game-builder/knowledge/regressions/reference-fidelity|После генерации приходится заново просить сходство и детали.]]
- [[roblox-game-builder/knowledge/regressions/required-world-material|Пропуск заданной пользователем текстуры при создании объекта или её применение к используемому предмету.]]

## Как проверить

Проверить bounding box, pivot, коллизии и переиспользование.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
