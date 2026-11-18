---
title: "cancel-old-actions"
tags: [roblox-knowledge, regression]
---

# cancel-old-actions

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

После победы/смерти сохраняется удар или агрессия.

## Что делать

Каждой сессии/персонажу/атаке назначать актуальную идентичность; отменять старые отложенные попадания и эффекты при reset/death/replacement. Сброс HP согласован со сбросом агрессии.

## Зависимости

[[roblox-game-builder/knowledge/topics/combat|Бой]], [[roblox-game-builder/knowledge/topics/round|Раунды]], [[roblox-game-builder/knowledge/topics/network|Сеть и серверные команды]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `cancel-old-actions`.

- `{"thread_id": "01a13b5c-5e44-7522-bbb7-612feed3cbc8", "turn_id": "01a13bf8-31b8-7ce3-9bc8-19bc7e3c4f16", "started_at": 1792007483}`
- `{"thread_id": "01a153d2-85cd-7900-b531-a8f7eb0143c6", "turn_id": "01a15a9b-0f79-7671-b407-4950b4f5e0d6", "started_at": 1792521473}`
- `{"thread_id": "01a1a700-df94-72e2-b087-67aaa18f3d9d", "turn_id": "01a1ab45-ad53-7bf0-84cc-10aaf4420b1d", "started_at": 1793874832}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Убить/сбросить цель во время подготовки, возродить персонажа, повторить событие; старый callback не поражает новый экземпляр.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
