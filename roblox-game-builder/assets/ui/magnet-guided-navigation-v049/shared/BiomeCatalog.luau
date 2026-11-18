-- Stable art IDs. Ice uses the existing medium pool; other destinations remain art previews.
local B={version='0.4.8',hub=CFrame.new(0,7,53),center=Vector3.new(0,.5,0),radius=42}
local rows={
 {'BIO-01','Лесное озеро','Lakewood','forest',{94,140,86},{66,139,148}},
 {'BIO-02','Ледяное озеро','Frostlake','ice',{224,236,241},{37,106,148}},
 {'BIO-03','Озеро джунглей','Jungle Basin','jungle',{70,118,63},{49,153,139}},
 {'BIO-04','Вулканическое озеро','Ember Lake','volcano',{66,65,72},{43,72,86}},
 {'BIO-05','Туманное болото','Mistmoor','swamp',{102,117,65},{57,81,67}},
 {'BIO-06','Затонувший оазис','Sunken Oasis','oasis',{221,190,129},{49,175,177}},
 {'BIO-07','Грибное озеро','Glowshroom Hollow','mushroom',{94,115,126},{96,84,170}},
 {'BIO-08','Кристальное озеро','Crystal Depths','crystal',{102,118,145},{55,148,182}},
 {'BIO-10','Небесное озеро','Skyfall Lake','sky',{124,172,90},{62,174,193}},
}
B.list={} B.byId={}
for i,row in rows do
 -- Keep stable map slots when a biome is retired. Existing destinations do not move.
 local slot=tonumber(row[1]:match('%d+'))
 local origin=i==1 and Vector3.zero or Vector3.new(600+((slot-2)%3)*420,0,-650-math.floor((slot-2)/3)*420)
 local d={id=row[1],name=row[2],english=row[3],theme=row[4],ground=Color3.fromRGB(table.unpack(row[5])),water=Color3.fromRGB(table.unpack(row[6])),origin=origin,
  arrival=i==1 and CFrame.new(0,4,133) or CFrame.new(origin+Vector3.new(0,4,72)),state=i==1 and 'Open' or 'DesignPending',requiredRebirths=nil}
 if d.id=='BIO-02' then d.state='Released' d.requiredToolLevel=2 d.zoneId='Z-02' end
 B.list[i]=d B.byId[d.id]=d
end
function B.canEnter(d,rebirths,studioPreview,toolLevel)
 if not d then return false end
 if d.state=='Open' then return true end
 if d.state=='Released' then
  if not d.requiredToolLevel and not d.requiredRebirths then return false end
  return (not d.requiredToolLevel or (toolLevel or 1)>=d.requiredToolLevel) and (not d.requiredRebirths or (rebirths or 0)>=d.requiredRebirths)
 end
 return studioPreview==true
end
return B
