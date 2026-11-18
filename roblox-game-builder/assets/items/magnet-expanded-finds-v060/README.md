# 72 переносные находки 0.6.0

Воспроизводимые примитивные модели для Roblox. Entry point ExpandedFindAssets.luau, соседний модуль ItemCatalog обязателен. Поместить оба в одну папку; create(id,dirty) для F-37..F-108. Возвращает неприкреплённый Model с pivot внизу, Anchored/CanQuery=true, CanCollide/CanTouch=false, без world MaterialVariant.

Dirty/Clean используют одинаковую геометрию; загрязнение задано материалами/цветами, без внешних UV-текстур. Максимальная сторона новых предметов 1/1.8/2.7 studs. Это модели предметов; цены, выпадение, профиль, UI и чистку подключает проект отдельно через Config/FindFactory.

Проверки проекта: game/qa/items-060/README.md. Референсы: art/references/biome-finds-expansion-r01, biome-finds-replacements-r01, biome-finds-rust-r01.

Визуально проверены все72вдвухсостояниях/двухракурсах,16кадров Studio. Коррозия:644тонкихучастка на4крупнейшихкомпонентах/максимум24на модель; геометрияодинакова вClean/Dirty. Сундук/сейф показывают кристаллы, номер27не зеркален, складки мехов красные.1008surface/raycast comparisons0mismatch; финальная проверка всех108cleaningmasks.
