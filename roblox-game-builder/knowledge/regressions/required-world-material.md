---
title: "required-world-material"
tags: [roblox-knowledge, regression]
---

# required-world-material

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Пропуск заданной пользователем текстуры при создании объекта или её применение к используемому предмету.

## Что делать

До создания классифицировать объект, применить сохранённую square-relief-normal.png как рельеф к объекту мира; используемые предметы исключить целиком. Сохранять цвета и правила в генераторе/шаблоне.

## Зависимости

[[roblox-game-builder/knowledge/topics/art|Художественный стиль и материалы]], [[roblox-game-builder/knowledge/topics/model|Модели и сборка]], [[roblox-game-builder/knowledge/topics/map|Карты и биомы]], [[roblox-game-builder/knowledge/topics/items|Предметы и каталоги]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `required-world-material`.

- `{"thread_id": "01a1b1eb-33f2-7d31-a3f9-99f6588480f6", "date_local": "2026-11-11", "user_message": "Перед созданием любого объекта использовать приложенную текстуру для всех объектов кроме предметов, которые игрок может использовать."}`

## Статус

Готово как правило приёмки. Основание: Explicit general instruction; interpretation as normal map is visual inference. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Проверить объект мира, используемый предмет со всеми частями, повторную сборку/респавн; реальный доступ к ассету и видимость рельефа.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
