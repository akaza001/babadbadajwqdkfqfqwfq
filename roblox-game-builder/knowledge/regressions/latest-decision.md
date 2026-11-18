---
title: "latest-decision"
tags: [roblox-knowledge, regression]
---

# latest-decision

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

В старой переписке есть отменённые ограничения и противоречащие UI-решения.

## Что делать

Сопоставлять дату и область, помечать старое superseded; явный новый запрос важнее старого промпта. Проектный баланс/стиль не становятся требованиями всех будущих игр.

## Зависимости

[[roblox-game-builder/knowledge/topics/brief|Цель и критерии игры]], [[roblox-game-builder/knowledge/topics/learning|Память и улучшения]], [[roblox-game-builder/knowledge/topics/economy|Экономика и прогрессия]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `latest-decision`.

- `{"thread_id": "01a18467-8da2-7a31-af08-e2980cc68f8f", "turn_id": "01a187f7-8e24-7921-b296-0a68d33d06e1", "started_at": 1793282510}`
- `{"thread_id": "01a1a700-df94-72e2-b087-67aaa18f3d9d", "turn_id": "01a1ad96-eedb-7f43-ab76-d736f9699bdf", "started_at": 1793913712}`
- `{"thread_id": "01a1882e-1345-7460-b158-5ef90b99fd06", "turn_id": "01a188b4-4432-7193-8105-537ff1eb5987", "started_at": 1793294877}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Перед изменением проверить журнал решений и не вернуть отменённые cap/ярлыки/авто-hatch; при неразрешённом конфликте не угадывать.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
