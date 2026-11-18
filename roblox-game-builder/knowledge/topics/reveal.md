---
title: "Раскрытие награды"
tags: [roblox-knowledge, topic]
---

# Раскрытие награды

## Назначение

Подтверждённый результат, operationId и отдельное раскрытие.

## Сохранённое знание

Сервер сначала фиксирует результат, клиент раскрывает его. Skip/закрытие не выдаёт второй экземпляр. Рыболовный результат — пример, не готовая система яиц с питомцами.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/economy|Экономика и прогрессия]], [[roblox-game-builder/knowledge/topics/inventory|Инвентарь и экипировка]]

Связанный контекст: [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]], [[roblox-game-builder/knowledge/topics/integration|Интеграция игрового цикла]]

## Исходники

- [[roblox-game-builder/knowledge/assets/magnet-activity-ui-v046|magnet-activity-ui-v046]]
- [[roblox-game-builder/knowledge/assets/magnet-biome-fishing-v048|magnet-biome-fishing-v048]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]

## Ошибки и ограничения

Специального случая в реестре пока нет. Проверять границы подсистемы и интеграцию; отсутствие записи не доказывает отсутствие ошибок.

## Как проверить

Закрытие/skip не дублируют награду; полная вместимость и параллельные запросы.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
