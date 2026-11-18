-- Optional preview adapter for these STATIC raster concepts, not wired into the game.
-- Pass Roblox image content IDs after explicit import; local PNG paths are not Roblox IDs.
local V={version='r01'}
function V.create(host,images)
 local root=Instance.new('Frame') root.Name='BiomeLoadingConcept'
 root.Size=UDim2.fromScale(1,1) root.BackgroundColor3=Color3.fromRGB(247,238,218)
 root.BorderSizePixel=0 root.ZIndex=100 root.Visible=false root.Parent=host
 local art=Instance.new('ImageLabel') art.Name='Illustration' art.Size=UDim2.fromScale(1,1)
 art.BackgroundTransparency=1 art.ScaleType=Enum.ScaleType.Fit art.ZIndex=101 art.Parent=root
 local api={root=root}
 function api.show(id)
  assert(type(images[id])=='string' and images[id]~='','Supply an imported image ID')
  art.Image=images[id] root.Visible=true
 end
 function api.hide() root.Visible=false end
 function api.destroy() root:Destroy() end
 return api
end
return V
