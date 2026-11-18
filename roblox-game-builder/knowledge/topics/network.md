---
title: "Сеть и серверные команды"
tags: [roblox-knowledge, topic]
---

# Сеть и серверные команды

## Назначение

Контракты событий и серверные проверки.

## Сохранённое знание

Клиент передаёт намерение; сервер проверяет состояние, права, частоту и параметры. Повтор запроса не должен повторно выдавать награду.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/architecture|Архитектура игры]]

Связанный контекст: Связи с другими темами определяются задачей.

## Исходники

- [[roblox-game-builder/knowledge/assets/magnet-biome-fishing-v048|magnet-biome-fishing-v048]]
- [[roblox-game-builder/knowledge/assets/magnet-admin-panel-v056|magnet-admin-panel-v056]]
- [[roblox-game-builder/knowledge/assets/magnet-vertical-cast-meter-v057|magnet-vertical-cast-meter-v057]]
- [[roblox-game-builder/knowledge/assets/simulator-template-v001|simulator-template-v001]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]

## Ошибки и ограничения

- [[roblox-game-builder/knowledge/regressions/combat-contract|Новая модель без hitbox, не атакует или машет без урона.]]
- [[roblox-game-builder/knowledge/regressions/cancel-old-actions|После победы/смерти сохраняется удар или агрессия.]]

## Как проверить

Подать неверные типы, дальность, частоту и недопустимое состояние.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
