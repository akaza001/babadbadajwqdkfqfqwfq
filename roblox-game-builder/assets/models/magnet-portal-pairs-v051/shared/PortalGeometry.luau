-- Marker-relative frames survive XML reloads and models with an automatic pivot.
local G={version='0.5.1',markerHeight=3,markerDepth=2.4,arrivalDistance=8}
function G.base(marker)
 return marker.CFrame*CFrame.new(0,-G.markerHeight,-G.markerDepth)
end
function G.arrival(marker)
 -- The approach side faces the usable island/plaza; leave the arch behind the avatar.
 return G.base(marker)*CFrame.new(0,G.markerHeight,-G.arrivalDistance)
end
function G.contains(marker,position,margin)
 local v=marker.CFrame:PointToObjectSpace(position) local extra=margin or 0
 return math.abs(v.X)<3.8+extra and math.abs(v.Z+G.markerDepth)<1.5+extra and math.abs(v.Y)<4+extra
end
return G
