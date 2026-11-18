---
title: "consistent-layout"
tags: [roblox-knowledge, regression]
---

# consistent-layout

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Таблички перекрывают лидерборды, порядок тренажёров различается, апгрейд поворачивает объект обратно.

## Что делать

Повторяемый комплект располагать в локальных координатах общего anchor, а интерактивные/видимые части — согласованными преобразованиями. Не считать все базы одинаково ориентированными в мире.

## Зависимости

[[roblox-game-builder/knowledge/topics/map|Карты и биомы]], [[roblox-game-builder/knowledge/topics/model|Модели и сборка]], [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `consistent-layout`.

- `{"thread_id": "01a1a700-df94-72e2-b087-67aaa18f3d9d", "turn_id": "01a1a793-02cc-7101-b02e-8f3fa7608ed9", "started_at": 1793812792}`
- `{"thread_id": "01a1a700-df94-72e2-b087-67aaa18f3d9d", "turn_id": "01a1ad39-942b-7c31-9a6e-b4df2795abf3", "started_at": 1793907594}`
- `{"thread_id": "01a17e4e-dfc0-7101-a56f-d3c34569966e", "turn_id": "01a18827-71cf-7960-9dcb-489a9b5fb309", "started_at": 1793285648}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Пройти все копии, обе стороны таблички, самый неудобный угол обзора; апгрейд сохраняет pivot/положение/направление и доступ к проходу.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
