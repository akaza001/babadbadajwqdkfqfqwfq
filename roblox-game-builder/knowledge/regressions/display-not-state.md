---
title: "display-not-state"
tags: [roblox-knowledge, regression]
---

# display-not-state

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Формат целых чисел может менять начисления; очки и реальная скорость смешиваются.

## Что делать

Хранить базовое значение без округления для UI; форматирование/масштаб представления вынести отдельно. Один владелец итогового движения; множители применять один раз.

## Зависимости

[[roblox-game-builder/knowledge/topics/economy|Экономика и прогрессия]], [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/persistence|Сохранения и миграции]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `display-not-state`.

- `{"thread_id": "01a17e4e-dfc0-7101-a56f-d3c34569966e", "turn_id": "01a1ab33-0bfb-7750-ac68-fedb29912027", "started_at": 1793873611}`
- `{"thread_id": "01a1a700-df94-72e2-b087-67aaa18f3d9d", "turn_id": "01a1ab45-ad53-7bf0-84cc-10aaf4420b1d", "started_at": 1793874832}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Сверить исходные данные до/после форматирования, начисления в режимах, death/rejoin и миграцию; отсутствие +0 и двойного бонуса.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
