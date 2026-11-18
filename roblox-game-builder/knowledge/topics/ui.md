---
title: "Интерфейсы"
tags: [roblox-knowledge, topic]
---

# Интерфейсы

## Назначение

Согласованная визуальная система, адаптивный HUD/экраны, общие компоненты и состояния действий.

## Сохранённое знание

Использовать тему и переиспользуемые нативные компоненты, реальные данные и адаптивную компоновку. Макет PNG — референс, не работающий экран. Подсказки компактны и не перекрывают игру.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/architecture|Архитектура игры]], [[roblox-game-builder/knowledge/topics/brief|Цель и критерии игры]]

Связанный контекст: Связи с другими темами определяются задачей.

## Исходники

- [[roblox-game-builder/knowledge/assets/ui-kit|ui-kit]]
- [[roblox-game-builder/knowledge/assets/magnet-hud-icons-v01|magnet-hud-icons-v01]]
- [[roblox-game-builder/knowledge/assets/magnet-hud-navigation-v041|magnet-hud-navigation-v041]]
- [[roblox-game-builder/knowledge/assets/magnet-hud-navigation-v042|magnet-hud-navigation-v042]]
- [[roblox-game-builder/knowledge/assets/magnet-hud-navigation-v043|magnet-hud-navigation-v043]]
- [[roblox-game-builder/knowledge/assets/magnet-ui-window-concepts-v01|magnet-ui-window-concepts-v01]]
- [[roblox-game-builder/knowledge/assets/magnet-ui-windows-v044|magnet-ui-windows-v044]]
- [[roblox-game-builder/knowledge/assets/magnet-ui-windows-v045|magnet-ui-windows-v045]]
- [[roblox-game-builder/knowledge/assets/magnet-activity-ui-v046|magnet-activity-ui-v046]]
- [[roblox-game-builder/knowledge/assets/magnet-onboarding-ui-v047|magnet-onboarding-ui-v047]]
- [[roblox-game-builder/knowledge/assets/magnet-guided-navigation-v049|magnet-guided-navigation-v049]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-exploration-v050|magnet-biome-exploration-v050]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-loading-r01|magnet-biome-loading-r01]]
- [[roblox-game-builder/knowledge/assets/magnet-fullscreen-loading-v052|magnet-fullscreen-loading-v052]]
- [[roblox-game-builder/knowledge/assets/magnet-cleaning-presentation-v056|magnet-cleaning-presentation-v056]]
- [[roblox-game-builder/knowledge/assets/magnet-vertical-cast-meter-v057|magnet-vertical-cast-meter-v057]]
- [[roblox-game-builder/knowledge/assets/magnet-free-cast-v058|magnet-free-cast-v058]]
- [[roblox-game-builder/knowledge/assets/simulator-template-v001|simulator-template-v001]]
- [[roblox-game-builder/knowledge/assets/magnet-catch-reveal-v059|magnet-catch-reveal-v059]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]
- [[roblox-game-builder/references/ui-quality|ui-quality.md]]
- [[roblox-game-builder/references/asset-memory|asset-memory.md]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/consistent-layout|Таблички перекрывают лидерборды, порядок тренажёров различается, апгрейд поворачивает объект обратно.]]
- [[roblox-game-builder/knowledge/regressions/ui-lifecycle|Магазин не соответствует зоне/экипировке, подписи лишние, значения перекрываются.]]
- [[roblox-game-builder/knowledge/regressions/display-not-state|Формат целых чисел может менять начисления; очки и реальная скорость смешиваются.]]
- [[roblox-game-builder/knowledge/regressions/unobtrusive-hints|Всплывающие подсказки занимают почти весь экран и мешают тестировать игру.]]

## Как проверить

Сравнить с выбранными референсами; проверить читаемость, иерархию, реальные данные/состояния, телефон/ПК и повторное открытие в Play.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
