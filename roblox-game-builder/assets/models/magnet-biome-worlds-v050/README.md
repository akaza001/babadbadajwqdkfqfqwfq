# Magnet biome worlds 0.5.0

Editable Luau world recipes, not a standalone binary RBXM. Install all shared modules into ReplicatedStorage.MagnetWorkshop.Shared and server modules into ServerScriptService.MagnetWorkshop. Combine with magnet-biome-finds-v050 and magnet-biome-exploration-v050 for the full game; only world generation needs this bundle. WorldBuilder.build() requires an absent workspace.MagnetWorld and runs in Edit. Preserve existing work before calling it.

For far-biome art alone, use BiomeAssets.apply(world), BiomeFinish.apply(world), then BiomeFishing.apply(world); create world.ZonePoints first. BiomeAssets builds BIO-01 marker plus eight lakes; BIO-09 is intentionally absent. BiomeFinish reuses existing models, and far FinishDecor if present. Reapplying finish/fishing is idempotent. The exact starter layout remains game-specific.

Saved Stud Asset Pack mesh recipes and waterfall layers are reused through SceneKit/EnvironmentAssets/WaterfallAssets. Required Roblox content IDs are in these modules; availability in another experience is not guaranteed. New Biome material variants reuse starter-albedos-v045, tile2 and normal119928944196293. Original PNGs/normal remain in their existing library entries; no textures were regenerated here. World surfaces carry relief, carried items and native GUI are exempt. Biome water alpha must be preserved by ShoreAppearance.

data/balance.sample.json is project sample economy, not a recommended generic default. Config embeds this exact catalog. WorldMetadata modules restore attribute ordinals for the current project export; regenerate them when changing baked hierarchy, do not use them with arbitrary scenes.

Verified fresh biome recipe:9 biomes,8 lakes,16 markers,2115 parts. Full current scene export12224 nodes/31 materials; starter geometry unchanged. Full WorldBuilder fresh rebuild was not repeated for0.5.0. Jungle/Sky previews are actual Edit captures; a full final visual tour and device performance remain pending.
