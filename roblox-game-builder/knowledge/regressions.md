---
title: "Ошибки и критерии приёмки"
tags: [roblox-knowledge, index]
---

# Ошибки и критерии приёмки

## Назначение

Переносить уроки между играми, не перенося их баланс и планировку.

## Зависимости и исходники

[[roblox-game-builder/references/regressions|Правила выбора]] · [[roblox-game-builder/scripts/select_regressions.py|Селектор]]

## Случаи

- [[roblox-game-builder/knowledge/regressions/geometry-contact|Модели погружаются в пол, яйцо не сидит в гнезде, наземный босс парит.]]
- [[roblox-game-builder/knowledge/regressions/texture-phase|Шахматный рисунок ломается на стыке, остаются полосы и второй рельеф.]]
- [[roblox-game-builder/knowledge/regressions/idempotent-rebuild|После замены остались старые стены/объекты или не все модели обновились.]]
- [[roblox-game-builder/knowledge/regressions/locomotion|Idle ходит на месте; босс не поворачивается; ходьба дёргается.]]
- [[roblox-game-builder/knowledge/regressions/species-animation|Змея стоит, маг не поднимает посох, существо без крыльев летает.]]
- [[roblox-game-builder/knowledge/regressions/carry-and-grip|Руки качаются с переносимым яйцом; персонаж лежит лицом вниз; оружие ориентировано неестественно.]]
- [[roblox-game-builder/knowledge/regressions/combat-contract|Новая модель без hitbox, не атакует или машет без урона.]]
- [[roblox-game-builder/knowledge/regressions/cancel-old-actions|После победы/смерти сохраняется удар или агрессия.]]
- [[roblox-game-builder/knowledge/regressions/consistent-layout|Таблички перекрывают лидерборды, порядок тренажёров различается, апгрейд поворачивает объект обратно.]]
- [[roblox-game-builder/knowledge/regressions/visibility-vs-collision|Под «прозрачным» имелось в виду проходимое, но видимое.]]
- [[roblox-game-builder/knowledge/regressions/ui-lifecycle|Магазин не соответствует зоне/экипировке, подписи лишние, значения перекрываются.]]
- [[roblox-game-builder/knowledge/regressions/display-not-state|Формат целых чисел может менять начисления; очки и реальная скорость смешиваются.]]
- [[roblox-game-builder/knowledge/regressions/item-lifecycle|Питомец после hatch не попадает в инвентарь; свойства теряются между переноской и установкой.]]
- [[roblox-game-builder/knowledge/regressions/spawn-invariants|Нарушается шахматный порядок, яйца разбросаны, повторяется запрещённый босс.]]
- [[roblox-game-builder/knowledge/regressions/reference-fidelity|После генерации приходится заново просить сходство и детали.]]
- [[roblox-game-builder/knowledge/regressions/measured-performance|Камера лагает после обновления, существа дёргаются; оптимизация портит внешний вид.]]
- [[roblox-game-builder/knowledge/regressions/latest-decision|В старой переписке есть отменённые ограничения и противоречащие UI-решения.]]
- [[roblox-game-builder/knowledge/regressions/unobtrusive-hints|Всплывающие подсказки занимают почти весь экран и мешают тестировать игру.]]
- [[roblox-game-builder/knowledge/regressions/required-world-material|Пропуск заданной пользователем текстуры при создании объекта или её применение к используемому предмету.]]

## Статус и проверка

Сохранены требования и предлагаемые инженерные меры, не новые результаты Play. Выбирай случаи до реализации и фиксируй наблюдаемый результат каждого после неё.
