---
title: "geometry-contact"
tags: [roblox-knowledge, regression]
---

# geometry-contact

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Модели погружаются в пол, яйцо не сидит в гнезде, наземный босс парит.

## Что делать

Считать контакт от фактической опоры/геометрии и локального pivot, а не одного универсального смещения. Проверять крайние позы и масштабы.

## Зависимости

[[roblox-game-builder/knowledge/topics/map|Карты и биомы]], [[roblox-game-builder/knowledge/topics/model|Модели и сборка]], [[roblox-game-builder/knowledge/topics/pets|Питомцы]], [[roblox-game-builder/knowledge/topics/npc|NPC и поведение]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `geometry-contact`.

- `{"thread_id": "01a13b5c-5e44-7522-bbb7-612feed3cbc8", "turn_id": "01a14609-603f-7982-9c2f-f6968c233691", "started_at": 1792176382}`
- `{"thread_id": "01a153d2-85cd-7900-b531-a8f7eb0143c6", "turn_id": "01a15ac3-9a0d-79a3-be0e-11378e9e0012", "started_at": 1792524130}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Осмотреть контакт с землёй/гнездом с двух ракурсов на минимальном/максимальном размере; повторить после пересоздания.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
