-- Generated from the captured Edit scene. Does not replace existing scene objects.
local chunks={}
for _,name in {"WorldMetadataData01","WorldMetadataData02","WorldMetadataData03","WorldMetadataData04"} do table.insert(chunks,require(script.Parent:WaitForChild(name))) end
local data=game.HttpService:JSONDecode(table.concat(chunks))
return {restore=function()
    local objects={[0]=workspace}
    for index,entry in data[2] do
        local parent=objects[entry[2]]
        local obj=parent and parent:FindFirstChild(entry[1])
        if parent and entry[4] then
            local ordinal=0 obj=nil
            for _,child in parent:GetChildren() do if child.Name==entry[1] then
                ordinal+=1 if ordinal==entry[4] then obj=child break end
            end end
        end
        objects[index]=obj
        if obj then for key,value in data[1][entry[3]] do if obj:GetAttribute(key)==nil then obj:SetAttribute(key,value) end end end
    end
end}
