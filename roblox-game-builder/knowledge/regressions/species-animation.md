---
title: "species-animation"
tags: [roblox-knowledge, regression]
---

# species-animation

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Змея стоит, маг не поднимает посох, существо без крыльев летает.

## Что делать

Выбирать locomotion/action profile по анатомии и типу атаки, не назначать всем одинаковую стойку. Полёт — явная способность; парение из-за неверной опоры — дефект.

## Зависимости

[[roblox-game-builder/knowledge/topics/animation|Анимации и переходы]], [[roblox-game-builder/knowledge/topics/npc|NPC и поведение]], [[roblox-game-builder/knowledge/topics/rig|Риги и суставы]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `species-animation`.

- `{"thread_id": "01a173e0-0836-7b50-8138-2a0f9e02bfca", "turn_id": "01a17817-d9d0-7862-9bc2-fdfbf836f02b", "started_at": 1793016191}`
- `{"thread_id": "01a18361-6703-74f3-b7b9-aa1022b56ef4", "turn_id": "01a18449-c3fc-7a80-94d8-7a232590860b", "started_at": 1793220789}`
- `{"thread_id": "01a16a5b-a290-7752-aadf-a14ce237d4ac", "turn_id": "01a16abd-133f-7ca1-a388-568e83ed73a7", "started_at": 1792792138}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Проверить по представителю каждого профиля и все исключения: ползущий/четвероногий/маг/крылатый/прыгающий; наземная опора и достижимость цели.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
