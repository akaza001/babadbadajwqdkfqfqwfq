---
title: "visibility-vs-collision"
tags: [roblox-knowledge, regression]
---

# visibility-vs-collision

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Под «прозрачным» имелось в виду проходимое, но видимое.

## Что делать

Не смешивать Transparency, collision, query и взаимодействие. Смысл спорного слова восстанавливать по явному уточнению в истории; не делать объект невидимым.

## Зависимости

[[roblox-game-builder/knowledge/topics/map|Карты и биомы]], [[roblox-game-builder/knowledge/topics/model|Модели и сборка]], [[roblox-game-builder/knowledge/topics/interaction|Взаимодействие с миром]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `visibility-vs-collision`.

- `{"thread_id": "01a13b5c-5e44-7522-bbb7-612feed3cbc8", "turn_id": "01a1417e-17c8-7f73-9c87-d5d85db0f91e", "started_at": 1792100145}`
- `{"thread_id": "01a13b5c-5e44-7522-bbb7-612feed3cbc8", "turn_id": "01a14bd0-6cfd-7663-b25a-d62925dd5334", "started_at": 1792273313}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Проверить внешний вид, проход персонажа, raycast/клик и взаимодействие отдельно; защитные стены остаются препятствиями.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
