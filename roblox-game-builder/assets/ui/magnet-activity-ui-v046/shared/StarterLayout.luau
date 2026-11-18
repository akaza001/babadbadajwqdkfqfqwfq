-- Coordinates shared by the map, shoreline dressing and water presentation.
local L={version='0.4.0',lakeRadius=110,platformRadius=58,outerRadius=185,plotRadius=145,workshopFloorY=.5,deckTop=1.4,
 portalAngles={67.5,90,112.5,168.75,202.5,236.25,303.75,337.5,11.25},
 bridgeAngles={270,135,45},plotAngles={259,281,124,146,34,56}}
function L.direction(degrees)
 local a=math.rad(degrees) return Vector3.new(math.sin(a),0,math.cos(a))
end
function L.bridgeClear(x,z,halfWidth)
 local point=Vector3.new(x,0,z)
 for _,degrees in L.bridgeAngles do
  local d=L.direction(degrees) local along=point:Dot(d)
  if along>L.platformRadius-5 and along<L.outerRadius and (point-d*along).Magnitude<(halfWidth or 13) then return false end
 end
 return true
end
function L.clearOfAccess(x,z,margin)
 if not L.bridgeClear(x,z,margin or 14) then return false end
 local point=Vector3.new(x,0,z)
 for _,degrees in L.plotAngles do if (point-L.direction(degrees)*L.plotRadius).Magnitude<34 then return false end end
 return true
end
return L
