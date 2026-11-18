---
title: "item-lifecycle"
tags: [roblox-knowledge, regression]
---

# item-lifecycle

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Питомец после hatch не попадает в инвентарь; свойства теряются между переноской и установкой.

## Что делать

Один uid и серверные атрибуты результата через все состояния; выдача/подбор/продажа идемпотентны, вместимость проверяется сервером.

## Зависимости

[[roblox-game-builder/knowledge/topics/items|Предметы и каталоги]], [[roblox-game-builder/knowledge/topics/inventory|Инвентарь и экипировка]], [[roblox-game-builder/knowledge/topics/persistence|Сохранения и миграции]], [[roblox-game-builder/knowledge/topics/pets|Питомцы]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `item-lifecycle`.

- `{"thread_id": "01a13b5c-5e44-7522-bbb7-612feed3cbc8", "turn_id": "01a140a8-8913-7e80-a834-f20775146cba", "started_at": 1792086149}`
- `{"thread_id": "01a139e5-47d4-7d12-807c-cebf30ed6af0", "turn_id": "01a13adb-b22d-77f2-9bce-0fdae6834bf0", "started_at": 1791988838}`
- `{"thread_id": "01a17e4e-dfc0-7101-a56f-d3c34569966e", "turn_id": "01a18355-f56a-7cb3-b184-ffb0d3e6952b", "started_at": 1793204811}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Гнездо → перенос → выпадение/подбор → безопасная зона → инвентарь → установка → hatch → питомец → повторный вход; сравнить UID/размер/вид/доход.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
