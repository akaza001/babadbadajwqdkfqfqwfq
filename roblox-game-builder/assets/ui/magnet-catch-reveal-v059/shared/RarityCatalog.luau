-- Presentation metadata only: no drop weights, sale prices or legendary finds.
local R={order={'common','uncommon','rare','epic','mythic','legendary'}}
R.byId={
 common={name='Обычная',color=Color3.fromRGB(155,161,170),hex='#9BA1AA',holdExtra=0},
 uncommon={name='Необычная',color=Color3.fromRGB(76,203,112),hex='#4CCB70',holdExtra=0},
 rare={name='Редкая',color=Color3.fromRGB(74,151,245),hex='#4A97F5',holdExtra=.1},
 epic={name='Эпическая',color=Color3.fromRGB(172,102,232),hex='#AC66E8',holdExtra=.2},
 mythic={name='Мифическая',color=Color3.fromRGB(240,82,82),hex='#F05252',holdExtra=.35},
 legendary={name='Легендарная',color=Color3.fromRGB(243,196,83),hex='#F3C453',holdExtra=.5},
}
function R.get(id) return R.byId[id] or R.byId.common end
return R
