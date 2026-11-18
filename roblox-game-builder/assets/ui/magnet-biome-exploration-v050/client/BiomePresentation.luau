-- Local mood only; no weather/survival rules or changes to server state.
local B=require(game.ReplicatedStorage.MagnetWorkshop.Shared.BiomeCatalog)
local P={} local started=false
function P.start()
 if started then return end started=true
 local lighting=game:GetService('Lighting') local run=game:GetService('RunService')
 local defaultTime=lighting.ClockTime local defaultBrightness=lighting.Brightness
 local atmosphere=lighting:FindFirstChild('MagnetAtmosphere') local defaultDensity=atmosphere and atmosphere.Density
 local effect=lighting:FindFirstChild('BiomeColor') or Instance.new('ColorCorrectionEffect') effect.Name='BiomeColor' effect.Parent=lighting
 local clock=0 local current=nil
 run.Heartbeat:Connect(function(dt)
  clock+=dt if clock<.4 then return end clock=0
  local char=game.Players.LocalPlayer.Character local root=char and char:FindFirstChild('HumanoidRootPart')
  local biome=nil
  if root then for i=2,#B.list do local d=B.list[i] if (root.Position-d.origin).Magnitude<130 then biome=d break end end end
  local theme=biome and biome.theme or 'forest' if theme==current then return end current=theme
  lighting.ClockTime=(theme=='mushroom' or theme=='crystal') and 19 or defaultTime
  lighting.Brightness=(theme=='mushroom' or theme=='crystal') and 1.6 or defaultBrightness
  effect.TintColor=theme=='mushroom' and Color3.fromRGB(220,210,255) or theme=='swamp' and Color3.fromRGB(223,231,201) or theme=='ice' and Color3.fromRGB(224,239,255) or Color3.new(1,1,1)
  effect.Contrast=theme=='crystal' and .08 or 0
  if atmosphere then atmosphere.Density=theme=='swamp' and .3 or defaultDensity end
 end)
end
return P
