---
title: "measured-performance"
tags: [roblox-knowledge, regression]
---

# measured-performance

## Назначение

Предотвращать повтор ранее замеченной ошибки в связанных системах.

## Ошибка

Камера лагает после обновления, существа дёргаются; оптимизация портит внешний вид.

## Что делать

Сначала измерить узкое место и нагрузку репрезентативной сцены; различать client rendering, скрипты, сеть и streaming. Уменьшать измеренную нагрузку, сохраняя узнаваемость.

## Зависимости

[[roblox-game-builder/knowledge/topics/performance|Производительность]], [[roblox-game-builder/knowledge/topics/map|Карты и биомы]], [[roblox-game-builder/knowledge/topics/animation|Анимации и переходы]]

## Исходники и происхождение

[[roblox-game-builder/references/regression-cases.json|Исходный реестр]] — запись `measured-performance`.

- `{"thread_id": "01a153d2-85cd-7900-b531-a8f7eb0143c6", "turn_id": "01a15a32-b4f2-77e0-8966-34c476e49c9a", "started_at": 1792514635}`
- `{"thread_id": "01a173e0-0836-7b50-8138-2a0f9e02bfca", "turn_id": "01a173ff-50dc-7610-8169-b536a644a4ea", "started_at": 1792947474}`
- `{"thread_id": "01a173e0-0836-7b50-8138-2a0f9e02bfca", "turn_id": "01a177eb-3331-7e31-a028-3e77fb6647db", "started_at": 1793013265}`

## Статус

Готово как правило приёмки. Основание: user corrections in Fight for eggs; prevention is engineering inference, not a verified runtime root cause. Правило и инженерная причина не являются доказательством исправления текущего проекта. Повторная runtime-проверка здесь не проводилась.

## Как проверить

Сравнить до/после камеру и движение при ожидаемом количестве существ/частиц; дальняя/ближняя видимость и загрузка ассетов. Не отключать streaming глобально без проверки.

[[roblox-game-builder/knowledge/regressions|Все ошибки и критерии]]
