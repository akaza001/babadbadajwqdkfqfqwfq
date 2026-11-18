# Magnet shore assembly 0.4.0

Derivative of v039. Project-specific Edit-only source; not standalone RBXM. Requires existing MagnetWorld/BoardwalkFinish, Plots/Floor, StarterPolish, RadialShore, FinishDecor/MainLakeShore, PortalHub, Plaza, Lake, ZonePoints and Biomes. Existing scene construction remains in the originating project.

Entry: BoardwalkFinish.apply(world). Scoped updates: BoardwalkFinish.replaceFences(world), HubAssets.relayoutPortals(world). Joined fence paths use circle/bridge intersection endpoints, common height and deduplicated posts. StarterLayout.portalAngles defines three portal groups outside the three radial approach corridors. BiomeCatalog has nine active stable IDs, BIO-09 retired; other biome origins remain stable.

Assets reused: saved stepped Rock93990255748897, existing portal models and normal119928944196293. No new texture generation. Source stored and visual integration verified in originating project. 744 joined-fence parts, 0 unattached rail endpoints, 45 clear horizontal approach probes, full fresh build9 biomes/9 portals. No cross-game or phone/FPS validation.
