---
title: "idempotent-rebuild"
tags: [roblox-knowledge, regression]
---

# idempotent-rebuild

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

После замены остались старые стены/объекты или не все модели обновились.

## Что делать

Найти фактические источники: live instance, шаблон, генератор, респавн. Обновить необходимые источники, чистить только принадлежащую изменению старую группу; повторная сборка не создаёт дубли.

## Зависимости

[[roblox-game-builder/knowledge/topics/map|Карты и биомы]], [[roblox-game-builder/knowledge/topics/model|Модели и сборка]], [[roblox-game-builder/knowledge/topics/integration|Интеграция игрового цикла]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `idempotent-rebuild`.

- `{"thread_id": "01a153d2-85cd-7900-b531-a8f7eb0143c6", "turn_id": "01a155eb-2b43-7c22-9e93-2cf62cd0330a", "started_at": 1792442837}`
- `{"thread_id": "01a13b5c-5e44-7522-bbb7-612feed3cbc8", "turn_id": "01a14609-603f-7982-9c2f-f6968c233691", "started_at": 1792176382}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Посчитать управляемые экземпляры до/после, пересобрать дважды и вызвать респавн/повторный Play; версия и количество должны сохраняться.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
