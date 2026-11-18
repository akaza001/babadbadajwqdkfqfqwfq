---
title: "locomotion"
tags: [roblox-knowledge, regression]
---

# locomotion

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Idle ходит на месте; босс не поворачивается; ходьба дёргается.

## Что делать

Различать реальное перемещение, визуальную походку, направление и неподвижную позу. Проверять единственного владельца transform и временную шкалу; причина дёрганья устанавливается измерением, не угадывается.

## Зависимости

[[roblox-game-builder/knowledge/topics/animation|Анимации и переходы]], [[roblox-game-builder/knowledge/topics/npc|NPC и поведение]], [[roblox-game-builder/knowledge/topics/pets|Питомцы]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `locomotion`.

- `{"thread_id": "01a153d2-85cd-7900-b531-a8f7eb0143c6", "turn_id": "01a153d2-cd44-7ca3-97d5-58522e1d8bcb", "started_at": 1792407686}`
- `{"thread_id": "01a153d2-85cd-7900-b531-a8f7eb0143c6", "turn_id": "01a153e4-5867-7b71-981f-d45288c38b44", "started_at": 1792408836}`
- `{"thread_id": "01a173e0-0836-7b50-8138-2a0f9e02bfca", "turn_id": "01a174a8-a295-7300-9844-c7b2fbb012ba", "started_at": 1792958571}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Idle → движение → поворот → остановка → погоня → респавн; наблюдать непрерывно, не одним снимком.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
