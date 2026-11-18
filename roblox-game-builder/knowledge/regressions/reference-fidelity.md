---
title: "reference-fidelity"
tags: [roblox-knowledge, regression]
---

# reference-fidelity

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

После генерации приходится заново просить сходство и детали.

## Что делать

До массовой замены сверить силуэт, пропорции, ключевые детали и два ракурса одного представителя; повторные ракурсы не являются разными моделями. Количество деталей не является качеством.

## Зависимости

[[roblox-game-builder/knowledge/topics/art|Художественный стиль и материалы]], [[roblox-game-builder/knowledge/topics/model|Модели и сборка]], [[roblox-game-builder/knowledge/topics/rig|Риги и суставы]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `reference-fidelity`.

- `{"thread_id": "01a153d2-85cd-7900-b531-a8f7eb0143c6", "turn_id": "01a15a0c-0367-7e42-a443-f808f2f9b023", "started_at": 1792512099}`
- `{"thread_id": "01a17e62-dba4-79a1-9ded-3c526cffcf3d", "turn_id": "01a18d8e-7399-7832-a7f8-cfb6f3b5662d", "started_at": 1793376285}`
- `{"thread_id": "01a150ea-4229-71e1-aa30-99ad879747e9", "turn_id": "01a153b0-7c12-7200-9c13-e002bcf2c518", "started_at": 1792405437}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Сопоставить с доступным референсом спереди/сбоку/сзади; проверить глаза, соединения и положение декора в движении; затем масштабировать на набор.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
