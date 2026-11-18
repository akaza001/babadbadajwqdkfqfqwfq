---
title: "combat-contract"
tags: [roblox-knowledge, regression]
---

# combat-contract

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Новая модель без hitbox, не атакует или машет без урона.

## Что делать

Модель подключать целиком: ID/реестр → сборка → rig/profile → queryable hitbox → атака/дальность/урон → респавн. Визуальная готовность не доказывает боевую.

## Зависимости

[[roblox-game-builder/knowledge/topics/combat|Бой]], [[roblox-game-builder/knowledge/topics/npc|NPC и поведение]], [[roblox-game-builder/knowledge/topics/items|Предметы и каталоги]], [[roblox-game-builder/knowledge/topics/network|Сеть и серверные команды]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `combat-contract`.

- `{"thread_id": "01a153d2-85cd-7900-b531-a8f7eb0143c6", "turn_id": "01a1541c-4db4-7093-b75e-541a3c9323a6", "started_at": 1792412503}`
- `{"thread_id": "01a153d2-85cd-7900-b531-a8f7eb0143c6", "turn_id": "01a154c3-849b-7af3-a0c9-de74da251cf3", "started_at": 1792423462}`
- `{"thread_id": "01a153d2-85cd-7900-b531-a8f7eb0143c6", "turn_id": "01a154d0-3258-7522-850b-c0d6c94ca1d2", "started_at": 1792424292}`
- `{"thread_id": "01a13b5c-5e44-7522-bbb7-612feed3cbc8", "turn_id": "01a13bf8-31b8-7ce3-9bc8-19bc7e3c4f16", "started_at": 1792007483}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Игрок попадает и промахивается; босс атакует на своей дистанции; урон ровно один раз; та же проверка после респавна.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
