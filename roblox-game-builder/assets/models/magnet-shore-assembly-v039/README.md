# Magnet shore assembly 0.3.9

Derivative of magnet-shore-assembly-v038, 2026-11-13. User explicitly selected the saved stepped Rock mesh in place of round primitive foundation rocks.

Project-specific Edit-only generator, not standalone RBXM. Requires existing MagnetWorld with BoardwalkFinish, Plots/Floor, StarterPolish, RadialShore, FinishDecor/MainLakeShore, PortalHub, Plaza, Lake and ZonePoints. Files include dependencies. Entry: BoardwalkFinish.apply(world); foundation-only refresh: BoardwalkFinish.replaceFoundation(world). Other required world assembly remains in the originating project.

Stepped Rock mesh: rbxassetid://93990255748897 from original Stud Asset Pack. Size6.2,3.1,6.2; four overlapping layers; solid annular core. Mandatory normal map119928944196293, StarterSlate scale2. Meshes decorative; core handles collision. Clear stair corridors preserved.

Verified in originating Studio: 1056 meshes, no spheres, same count after repeat, 540 solid-core probes, server/client material parity, visual comparison before/after in same camera. External mesh IDs require availability in target experience; no cross-game standalone test or FPS benchmark.
