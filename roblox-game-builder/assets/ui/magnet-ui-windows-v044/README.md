# Working window components 0.4.4

Derived from approved raster references magnet-ui-window-concepts-v01 and existing small edge HUDv043. Reference pack is not substituted as one noninteractive screen image.

WindowTheme is the native ivory/tan/teal surface kit, with static gradients, thin strokes, upper sheen and separate soft shadow. It requires sibling HudIcons. T.window(host,title,page,close) returns modal Frame and scrolling body; destroying modal removes shade/shadow. T.button creates ActionAvailable/ServerAction attributes understood by the host pending-state controller. Other primitives are frame,label,scroll,list,enabled.

WorkshopWindows implements inventory+sale, collection, shop and upgrades, using live profile fields and actual game models via ViewportFrame. Requires the originating ReplicatedStorage.MagnetWorkshop.Shared hierarchy; matching readonly shared sources provided. W.inventory(body,options,selling), W.collection, W.shop, W.upgrades. options: profile,request(action,payload),pending(),equipped(),toggle(),slots(uid),sell(uid),upgrades(), optional selectUid. Profile uses originating Config item IDs and fields. Host supplies authoritative request protocol; renderer never awards coins/items. Main.project-adapter.luau needs the other originating game modules and server, not standalone.

SettingsUI preserves debounced/atomic audio saves and implements pointer/touch sliders plus +/- buttons; depends on AudioPresentation and existing AudioCatalog/Strings. S.init callbacks open/canSave/save, S.profile,S.result,S.render,S.set. No physical touch test yet.

Verification: all5 renderer types construct from profile data;16 Frame layout cases at1280x720,768x401,568x284,360x640 with24 items construct without errors, reported0 undersized measured buttons/clipped Name labels. Actual generated upgrade callback+server sandbox transaction240->60/level2; sale60->90, fixture removed. Actual audio path persisted musicVolume.55.47 Studio/local/XML sources match. Current Studio viewport stayed1x1, so screenshots, visual comparison and genuine mouse/touch interaction are NOT accepted yet. No claim of complete visual/device QA. See originating game/qa/WINDOWS-2026-11-13.md.

Material policy: UI does not get the world square normal map. Existing item art keeps its item exception. Scene previews reuse saved approved models, and world textures/layout were not modified by this UI task. No new Roblox image IDs; imported icons reused.
