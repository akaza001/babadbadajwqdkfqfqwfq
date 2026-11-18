---
title: База знаний Roblox Game Builder
tags: [roblox-knowledge, index]
---

# База знаний Roblox Game Builder

Это навигация по сохранённым инструкциям, исходникам и истории. Заметки не превращают рецепты в работающие модули. Встроенный граф действий содержит 30 крупных тем; здесь каждая стала отдельной заметкой с зависимостями, исходниками, ошибками и критериями проверки.

## Стартовый шаблон

[[roblox-game-builder/templates/simulator-v001/README|Ядро и установщик 0.0.1]] — отдельные исходники; RAM_ONLY прототип, Studio-проверка впереди.

## Начать здесь

- [[roblox-game-builder/knowledge/status|Что готово, что проверено и что запланировано]].
- [[roblox-game-builder/knowledge/gaps|Карта пробелов для полноценного шаблона симулятора]].
- [[roblox-game-builder/knowledge/coverage|Источники, охват и правила обновления]].
- [[roblox-game-builder/knowledge/assets|Библиотека реальных исходников и ассетов]].
- [[roblox-game-builder/knowledge/regressions|Ошибки и критерии приёмки]].
- [[roblox-game-builder/knowledge/research|Исследования 50 игр и ограничения обзора]].

## От идеи до сборки

[[roblox-game-builder/knowledge/topics/brief|Цель]] → [[roblox-game-builder/knowledge/topics/architecture|Архитектура]] → [[roblox-game-builder/knowledge/topics/integration|Интеграция]] → [[roblox-game-builder/knowledge/topics/performance|Производительность]].

Полный обязательный порядок и связи: [[roblox-game-builder/references/graph|Граф действий]]. Связь между заметками в Obsidian показывает также контекст и источник, а не только обязательную зависимость requires.

## Мир и визуал

- [[roblox-game-builder/knowledge/topics/map|Карты и биомы]], [[roblox-game-builder/knowledge/topics/art|Стиль и материалы]], [[roblox-game-builder/knowledge/topics/model|Модели]].
- [[roblox-game-builder/knowledge/topics/rig|Риги]], [[roblox-game-builder/knowledge/topics/animation|Анимации]], [[roblox-game-builder/knowledge/topics/vfx-audio|Эффекты и звук]].
- [[roblox-game-builder/references/visual-style|Яркий светлый стиль]], [[roblox-game-builder/references/material-policy|Обязательный рельеф и исключения]].

## Прогресс и данные

- [[roblox-game-builder/knowledge/topics/network|Сеть]], [[roblox-game-builder/knowledge/topics/economy|Экономика]], [[roblox-game-builder/knowledge/topics/persistence|Сохранения]].
- [[roblox-game-builder/knowledge/topics/items|Предметы]], [[roblox-game-builder/knowledge/topics/inventory|Инвентарь]], [[roblox-game-builder/knowledge/topics/admin|Админ-панель]].
- [[roblox-game-builder/knowledge/topics/monetization|Покупки]], [[roblox-game-builder/knowledge/topics/customization|Кастомизация]].

## Интерфейс и игровые механики

- [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/interaction|Взаимодействия]], [[roblox-game-builder/knowledge/topics/reveal|Раскрытие награды]].
- [[roblox-game-builder/knowledge/topics/npc|NPC]], [[roblox-game-builder/knowledge/topics/pets|Питомцы]], [[roblox-game-builder/knowledge/topics/combat|Бой]].
- [[roblox-game-builder/knowledge/topics/round|Раунды]], [[roblox-game-builder/knowledge/topics/production|Производство и крафт]].
- [[roblox-game-builder/knowledge/topics/vehicles|Транспорт]], [[roblox-game-builder/knowledge/topics/physics|Физические взаимодействия]], [[roblox-game-builder/knowledge/topics/procedural|Процедурная генерация]].

## История и накопление

- [[roblox-game-builder/knowledge/projects/fight-for-eggs|Fight for eggs — уроки и финальные решения]].
- [[roblox-game-builder/knowledge/projects/magnet-workshop|Magnet Workshop — версии и рабочие исходники]].
- [[roblox-game-builder/knowledge/topics/learning|Память и улучшения]], [[roblox-game-builder/references/asset-memory|Поиск и накопление ассетов]], [[roblox-game-builder/references/learning|Доступ к истории]].

## Проверка и просмотр

В Obsidian открой эту заметку; локальный граф покажет её связи. Общий Graph view покажет также связанные существующие карточки и исходные документы. Для фокуса на новой базе можно задать поиск `path:roblox-game-builder/knowledge`; если он скрывает внешние источники, убери фильтр. Интерфейс Obsidian в этой задаче не настраивался.

Целостность новых ссылок и ассетов проверяется файловым скриптом; игры и Studio здесь не изменялись. Подробности — в [[roblox-game-builder/knowledge/coverage|охвате]].
