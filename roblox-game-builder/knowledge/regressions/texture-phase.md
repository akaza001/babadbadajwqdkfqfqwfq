---
title: "texture-phase"
tags: [roblox-knowledge, regression]
---

# texture-phase

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Шахматный рисунок ломается на стыке, остаются полосы и второй рельеф.

## Что делать

Разделять геометрию, фазу/масштаб рисунка, цвет и normal map; искать конкретный слой дефекта. Для повторяющегося рисунка согласовывать мировое/локальное начало и ориентацию.

## Зависимости

[[roblox-game-builder/knowledge/topics/map|Карты и биомы]], [[roblox-game-builder/knowledge/topics/art|Художественный стиль и материалы]], [[roblox-game-builder/knowledge/topics/model|Модели и сборка]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `texture-phase`.

- `{"thread_id": "01a150ea-4229-71e1-aa30-99ad879747e9", "turn_id": "01a150ec-0c56-7dd0-9691-e105d700ec2f", "started_at": 1792359009}`
- `{"thread_id": "01a179d1-e445-7902-a84b-6eb471cb3657", "turn_id": "01a17e2e-5415-79e3-a7d5-e16eacffcd7c", "started_at": 1793118327}`
- `{"thread_id": "01a153d2-85cd-7900-b531-a8f7eb0143c6", "turn_id": "01a15b4e-0b8b-79d3-a99a-44968a3b8871", "started_at": 1792533203}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Сравнить один стык и углы со всех сторон; затем соседние сегменты и повторный запуск; не считать отсутствие щели правильным рисунком.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
