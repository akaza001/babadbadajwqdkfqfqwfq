local world=workspace:WaitForChild("MagnetWorld",15)
assert(world,"Build the world with the supplied installer before Play")
-- Exported XML includes a metadata adapter for attributes not stored as XML properties.
local metadata=script.Parent:FindFirstChild("WorldMetadata")
if metadata then require(metadata).restore() end
local polish=world:FindFirstChild('StarterPolish')
local clouds=polish and polish:FindFirstChild('Clouds')
if clouds then clouds.ModelStreamingMode=Enum.ModelStreamingMode.Persistent end
require(game.ReplicatedStorage.MagnetWorkshop.Shared.ShoreAppearance).apply(world)
require(game.ReplicatedStorage.MagnetWorkshop.Shared.SurfaceStyle).apply(world)
require(game.ReplicatedStorage.MagnetWorkshop.Shared.WorldLabels).applyWorld(world)
local physics=game:GetService("PhysicsService")
if not physics:IsCollisionGroupRegistered("MagnetPlayers") then physics:RegisterCollisionGroup("MagnetPlayers") end
physics:CollisionGroupSetCollidable("MagnetPlayers","MagnetPlayers",false)
game.StarterPlayer.CameraMinZoomDistance=8
game.StarterPlayer.CameraMaxZoomDistance=24
game.StarterGui.ScreenOrientation=Enum.ScreenOrientation.LandscapeSensor
local gameService=require(script.Parent.GameService)
require(game.ReplicatedStorage.MagnetWorkshop.Shared.WaterfallAssets).apply(world)
require(script.Parent.PortalService).applyLabels(world)
gameService.start()
require(script.Parent.AdminService).start(gameService)
