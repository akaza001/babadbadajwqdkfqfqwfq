-- Adapted layer recipe extracted from the user's exact waterfall.rbxm.
-- Original files/recipe: art/environment/waterfall.rbxm and waterfall-recipe.json.
local W={textures={'rbxassetid://13655259992','rbxassetid://13655346185','rbxassetid://13655496159'}}
function W.apply(world)
 for _,m in world:GetDescendants() do if m:IsA('Model') and m:GetAttribute('SourcePack')=='waterfall.rbxm' then
  local top=m:FindFirstChild('Top') local bottom=m:FindFirstChild('Bottom')
  if top and bottom then
   for _,p in {top,bottom} do for _,v in p:GetChildren() do if v:GetAttribute('RuntimeDerived') then v:Destroy() end end end
   local a=Instance.new('Attachment') a.Name='WaterfallStart' a:SetAttribute('RuntimeDerived',true) a.Parent=top
   local b=Instance.new('Attachment') b.Name='WaterfallEnd' b:SetAttribute('RuntimeDerived',true) b.Parent=bottom
   for i,texture in W.textures do
    local beam=Instance.new('Beam') beam.Name='SavedWaterfallLayer'..i beam:SetAttribute('RuntimeDerived',true)
    beam.Attachment0=a beam.Attachment1=b beam.Width0=(m:GetAttribute('Width') or 8)*(i==1 and 1 or .8)
    beam.Width1=beam.Width0*1.08 beam.Texture=texture beam.TextureMode=Enum.TextureMode.Wrap
    beam.TextureLength=({.1,.75,.77})[i] beam.TextureSpeed=({1,1.5,2})[i] beam.FaceCamera=true
    beam.Transparency=NumberSequence.new(i==1 and .45 or .35) beam.Color=ColorSequence.new(Color3.fromRGB(186,235,238))
    beam.LightInfluence=.6 beam.Segments=6 beam.Parent=top
   end
  end
 end end
end
return W
