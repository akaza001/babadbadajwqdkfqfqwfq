---
title: "Админ-панель"
tags: [roblox-knowledge, topic]
---

# Админ-панель

## Назначение

Индивидуальная админ-панель из серверного реестра систем игры, с разрешениями и синхронизацией новых характеристик/предметов.

## Сохранённое знание

Строить формы по серверному реестру реальных систем. Новые предметы попадают из каталога; новая характеристика требует обработчика. Сохранённый шаблон намеренно deny-all, права пользователя не копируются.

## Зависимости

До реализации: [[roblox-game-builder/knowledge/topics/network|Сеть и серверные команды]], [[roblox-game-builder/knowledge/topics/ui|Интерфейсы]]

Связанный контекст: [[roblox-game-builder/knowledge/topics/economy|Экономика и прогрессия]], [[roblox-game-builder/knowledge/topics/inventory|Инвентарь и экипировка]], [[roblox-game-builder/knowledge/topics/persistence|Сохранения и миграции]], [[roblox-game-builder/knowledge/topics/learning|Память и улучшения]]

## Исходники

- [[roblox-game-builder/knowledge/assets/magnet-admin-panel-v056|magnet-admin-panel-v056]]
- [[roblox-game-builder/knowledge/assets/simulator-template-v001|simulator-template-v001]]

- [[roblox-game-builder/references/implementation|implementation.md]]
- [[roblox-game-builder/references/graph.json|graph.json]]
- [[roblox-game-builder/references/admin-panel|admin-panel.md]]

## Ошибки и ограничения

Специального случая в реестре пока нет. Проверять границы подсистемы и интеграцию; отсутствие записи не доказывает отсутствие ошибок.

## Как проверить

Проверить запрет обычному игроку, добавление нового ID без отдельной кнопки, выдачу/изменение и сброс тестового профиля с повторным входом.

## Статус готовности

- Знание/критерии: сохранены.
- Исходники: есть перечисленные пакеты; часть зависит от исходной игры.
- Проверено: только конкретные исторические случаи из отчётов пакетов; новые проверки в игре здесь не проводились.
- Запланировано: закрыть переносимость и недостающие проверки по [[roblox-game-builder/knowledge/gaps|карте пробелов]]. Не считать эту заметку готовой реализацией.

[[roblox-game-builder/knowledge/index|База знаний]]
