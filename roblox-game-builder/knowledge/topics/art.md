---
title: "Художественный стиль и материалы"
tags: [roblox-knowledge, topic]
---

# Художественный стиль и материалы

## Назначение

Палитра, формы, материалы и оригинальные ассеты.

## Сохранённое знание

Светлый дневной блочный мир и сочные чистые цвета — общий ориентир пользователя. Нормаль задаёт рельеф, albedo — цвет; не подменять один слой другим.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/brief|Цель и критерии игры]]

Связанный контекст: Связи с другими темами определяются задачей.

## Исходники

- [[roblox-game-builder/knowledge/assets/stud-asset-pack|stud-asset-pack]]
- [[roblox-game-builder/knowledge/assets/square-relief-normal|square-relief-normal]]
- [[roblox-game-builder/knowledge/assets/magnet-hud-icons-v01|magnet-hud-icons-v01]]
- [[roblox-game-builder/knowledge/assets/magnet-ui-window-concepts-v01|magnet-ui-window-concepts-v01]]
- [[roblox-game-builder/knowledge/assets/magnet-starter-albedos-v045|magnet-starter-albedos-v045]]
- [[roblox-game-builder/knowledge/assets/magnet-world-materials-v055|magnet-world-materials-v055]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]
- [[roblox-game-builder/references/visual-style|visual-style.md]]
- [[roblox-game-builder/references/material-policy|material-policy.md]]
- [[roblox-game-builder/references/model-library|model-library.md]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/texture-phase|Шахматный рисунок ломается на стыке, остаются полосы и второй рельеф.]]
- [[roblox-game-builder/knowledge/regressions/reference-fidelity|После генерации приходится заново просить сходство и детали.]]
- [[roblox-game-builder/knowledge/regressions/required-world-material|Пропуск заданной пользователем текстуры при создании объекта или её применение к используемому предмету.]]

## Как проверить

Сравнить с референсом с нескольких ракурсов.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
