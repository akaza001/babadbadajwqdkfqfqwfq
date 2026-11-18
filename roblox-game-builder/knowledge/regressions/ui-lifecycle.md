---
title: "ui-lifecycle"
tags: [roblox-knowledge, regression]
---

# ui-lifecycle

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Магазин не соответствует зоне/экипировке, подписи лишние, значения перекрываются.

## Что делать

Использовать актуальные иконки/ограничения проекта и единую модель состояния UI. Вход/выход, выбор/экипировка, pending/ошибка закрывают полный цикл; размеры проверять на реальном экране.

## Зависимости

[[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/interaction|Взаимодействие с миром]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `ui-lifecycle`.

- `{"thread_id": "01a13b5c-5e44-7522-bbb7-612feed3cbc8", "turn_id": "01a140a8-8913-7e80-a834-f20775146cba", "started_at": 1792086149}`
- `{"thread_id": "01a1a700-df94-72e2-b087-67aaa18f3d9d", "turn_id": "01a1a7ff-a5ad-7471-89d4-65f94bd9e224", "started_at": 1793819911}`
- `{"thread_id": "01a1882e-1345-7460-b158-5ef90b99fd06", "turn_id": "01a189b0-1e22-7080-8295-7c69c9e4c3c7", "started_at": 1793311383}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Открыть с экипированным предметом, выйти из зоны, купить/экипировать/вернуть старый; проверить длинное число, разные экраны, повторное открытие без дубликатов.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
