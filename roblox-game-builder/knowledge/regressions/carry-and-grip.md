---
title: "carry-and-grip"
tags: [roblox-knowledge, regression]
---

# carry-and-grip

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Руки качаются с переносимым яйцом; персонаж лежит лицом вниз; оружие ориентировано неестественно.

## Что делать

Проверять оси крепления/хвата и позу персонажа, разделять ноги locomotion и руки carry/action; после снятия очищать слой. Для нестандартной модели нужен свой grip.

## Зависимости

[[roblox-game-builder/knowledge/topics/animation|Анимации и переходы]], [[roblox-game-builder/knowledge/topics/items|Предметы и каталоги]], [[roblox-game-builder/knowledge/topics/rig|Риги и суставы]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `carry-and-grip`.

- `{"thread_id": "01a13b5c-5e44-7522-bbb7-612feed3cbc8", "turn_id": "01a1458f-1020-7680-9049-c8ecfccab845", "started_at": 1792168366}`
- `{"thread_id": "01a1a700-df94-72e2-b087-67aaa18f3d9d", "turn_id": "01a1ab2d-b67c-7961-ab43-ac4aada782b5", "started_at": 1793873262}`
- `{"thread_id": "01a1a700-df94-72e2-b087-67aaa18f3d9d", "turn_id": "01a1ad96-eedb-7f43-ab76-d736f9699bdf", "started_at": 1793913712}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Спереди/сбоку: idle, бег, обе стороны атаки, переноска, выход из тренировки, снятие предмета, смерть и смена оружия.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
