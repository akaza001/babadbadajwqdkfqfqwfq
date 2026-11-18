# Magnet HUD navigation 0.4.1

Reusable component entry: HudNavigation.luau, requires sibling HudIcons.luau. Icons reuse ../magnet-hud-icons-v01 (original PNGs and prompts). Roblox IDs refer to originating imports; check permissions in another experience.

Host: a Frame filling a CoreUISafeInsets ScreenGui. N.create(frame,{activate=function(id) ... end}) returns api.root, api.refresh(page,available), api.layout(Vector2). Eight IDs: Inventory, Journal, Shop, Upgrades, Sell, Settings, Home, Workshops. Caller owns actions and visibility during gameplay/modal windows. Selected pages inventory/journal/shop/upgrades/sell/settings. N.header(window,page) adds a matching 42px icon and returns whether it did so.

Theme: ivory247/238/218, teal45/153/157, ink45/70/75, tan199/177/141. Desktop two columns×three tiles; low landscape six columns, narrower portrait two columns. Hover/focus, pressed, selected, disabled; labels remain visible if PNGs load slowly. Main.project-adapter.luau records integration in originating project; requires its other modules/protocol and is not standalone. No economy or player data included.

Verified:45 source matches Studio/local/XML; six actual mouse click open/close cycles, loaded images, sandbox sale12coins, distant purchase rejection, respawn one HUD; five simulated Frame sizes1280×720,768×401,640×324,360×640,568×284 without overlapping/out-of-bounds buttons, all hit targets≥44. Actual Play capture768×437. Physical phone/touch input and full gamepad workflow not validated.
