# magnet-biome-fishing-v048

Two existing Ice pier fishing markers, equipment-gated portal, centered-lake cast math, optional visitedBiomes migration and next-goal integration.

Entry: shared/BiomeFishing.luau. This is a portable source bundle from Magnet Workshop Simulator, not a standalone game. Reuses the approved WindowTheme/ActivityUI/FindFactory/SceneKit/BiomeAssets and original remotes/profile schema. Main.project-adapter.luau is the host game's LocalScript adapter. Server and generated metadata in0.4.8 depend on the originating captured scene; run the host WorldBuilder or apply BiomeFishing to an equivalent authored layout. Missing textures/mesh ownership must be resolved when porting universes. No QA fixtures are placed in runtime folders. No new raster assets/asset uploads or economy prices.

UI0.4.7 API: OnboardingUI.create(parent,callbacks)->root,update,mark,clearMarker. GuideRules.describe(profile,context) is read-only. Host owns requests; UI grants no rewards.44px+ actions, max340x84HUD, compact landscape placement, user-opened manual, guideEnabled stored through strict SetGuide. Final waypoint rendering after physical-anchor revision remains unconfirmed; do not claim visual approval.

BiomeFishing.apply(world) is idempotent for its two owned ZonePoints. Existing Ice piers and medium item poolZ-02 are reused. BIO-02 requires toolLevel2; gates are authoritative even with Studio art preview. ProfileStore optional visitedBiomes migration preserves older schema1. CastRules translates circular targets relative to lake.Position. World markers receive square normal119928944196293; GUI and used items keep their exemptions. Full scope and measured validation are in verification.md. Physical phones/full gamepad/6real clients/FPS and unique Ice finds remain pending.
