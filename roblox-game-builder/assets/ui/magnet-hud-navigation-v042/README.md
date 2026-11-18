# Edge HUD navigation 0.4.2

Explicit user correction: remove the full-width title/status banner and place buttons along screen edges. Supersedes v041 layout.

N.create(parentFrame,{activate=function(id) ... end}) requires sibling HudIcons.luau; originals/PNG prompts are ../magnet-hud-icons-v01. api.root spans parent transparently, api.refresh(page,available) controls selection/disabled state, api.layout(Vector2) reapplies layout. Host uses CoreUISafeInsets and manages modal/activity visibility. N.header(window,page) inserts the approved icon.

Left: Inventory, Journal, Sell, Home. Right: Shop, Upgrades, Settings, Workshops. Tall layouts use one column on each edge. Landscape height≤440 and width≥520 uses2×2 per edge above lower touch-control region. Main.project-adapter.luau contains originating integration and154×36 currency pill; project adapter requires its other modules and protocol. No title, debug/sandbox status or multi-resource bar is rendered. No economy changes.

Verified: six actual mouse open/close cycles, real Studio capture; simulated parent sizes1280×720,768×401,640×324,360×640,568×284 have0 overlaps/outside/central-band intrusion/targets under44. Full physical touch/gamepad input and respawn not repeated this version. Icons reused without regeneration. External IDs require permissions in another experience.
