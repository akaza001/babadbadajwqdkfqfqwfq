---
title: "Взаимодействие с миром"
tags: [roblox-knowledge, topic]
---

# Взаимодействие с миром

## Назначение

Контекстные действия с объектами, права/дистанция и состояние запроса.

## Сохранённое знание

Разделять видимость/коллизии, права и дистанцию. Для порталов важны общий шаблон с двух сторон, безопасное прибытие и отмена загрузки при смерти.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/network|Сеть и серверные команды]], [[roblox-game-builder/knowledge/topics/map|Карты и биомы]]

Связанный контекст: [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/integration|Интеграция игрового цикла]]

## Исходники

- [[roblox-game-builder/knowledge/assets/magnet-activity-ui-v046|magnet-activity-ui-v046]]
- [[roblox-game-builder/knowledge/assets/magnet-onboarding-ui-v047|magnet-onboarding-ui-v047]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-fishing-v048|magnet-biome-fishing-v048]]
- [[roblox-game-builder/knowledge/assets/magnet-guided-navigation-v049|magnet-guided-navigation-v049]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-exploration-v050|magnet-biome-exploration-v050]]
- [[roblox-game-builder/knowledge/assets/magnet-portal-pairs-v051|magnet-portal-pairs-v051]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-loading-r01|magnet-biome-loading-r01]]
- [[roblox-game-builder/knowledge/assets/magnet-fullscreen-loading-v052|magnet-fullscreen-loading-v052]]
- [[roblox-game-builder/knowledge/assets/magnet-cleaning-presentation-v056|magnet-cleaning-presentation-v056]]
- [[roblox-game-builder/knowledge/assets/magnet-vertical-cast-meter-v057|magnet-vertical-cast-meter-v057]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/visibility-vs-collision|Под «прозрачным» имелось в виду проходимое, но видимое.]]
- [[roblox-game-builder/knowledge/regressions/ui-lifecycle|Магазин не соответствует зоне/экипировке, подписи лишние, значения перекрываются.]]
- [[roblox-game-builder/knowledge/regressions/unobtrusive-hints|Всплывающие подсказки занимают почти весь экран и мешают тестировать игру.]]

## Как проверить

Два игрока у объекта, исчезновение цели, повторное нажатие, неверная дальность.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
