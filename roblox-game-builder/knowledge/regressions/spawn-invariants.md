---
title: "spawn-invariants"
tags: [roblox-knowledge, regression]
---

# spawn-invariants

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Нарушается шахматный порядок, яйца разбросаны, повторяется запрещённый босс.

## Что делать

Реестр всех видов, активные слоты и случайный выбор — отдельные сущности; связанный предмет хранит encounter/slot ID, позицию получает от anchor, не от номера глобального массива.

## Зависимости

[[roblox-game-builder/knowledge/topics/npc|NPC и поведение]], [[roblox-game-builder/knowledge/topics/map|Карты и биомы]], [[roblox-game-builder/knowledge/topics/items|Предметы и каталоги]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `spawn-invariants`.

- `{"thread_id": "01a153d2-85cd-7900-b531-a8f7eb0143c6", "turn_id": "01a1559f-f765-7720-9694-384207e3a544", "started_at": 1792437909}`
- `{"thread_id": "01a173e0-0836-7b50-8138-2a0f9e02bfca", "turn_id": "01a1746b-d691-7a50-985d-2ec9b887475e", "started_at": 1792954586}`
- `{"thread_id": "01a179d1-e445-7902-a84b-6eb471cb3657", "turn_id": "01a179d1-e5c1-7f82-a6b2-57b7c3740f2c", "started_at": 1793045161}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Уникальность активных видов, исключение предыдущего при reset, нужное число слотов и привязка яйца после нескольких респавнов/перестройки.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
