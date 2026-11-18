local P={}
function P.framing(view,desc,size,insetTop,insetBottom)
    if size.X<=1 or size.Y<=1 then size=Vector2.new(768,437) end
    local short=size.Y-insetTop-insetBottom<300
    local topSpace,bottomSpace=short and 72 or 112,short and 48 or 60
    local tangent=math.tan(math.rad(25))
    local top,bottom=insetTop+topSpace,size.Y-insetBottom-bottomSpace
    local margin=(bottom-top)*.07 top+=margin bottom-=margin
    local slope=(top+bottom-size.Y)/size.Y*tangent
    local upper=(1-2*top/size.Y)*tangent local lower=(1-2*bottom/size.Y)*tangent
    local flipRadius=math.sqrt((desc.height/2)^2+(desc.depth/2)^2)
    local highest=desc.height/2+desc.depth/2+.2+flipRadius
    local distance=4+highest
    -- Fit the entire flip envelope to the actual free rectangle, including depth.
    for _,height in {0,highest} do for _,up in {-flipRadius,flipRadius} do
        distance=math.max(distance,height+desc.width/2/(tangent*(size.X-32)/size.Y*.86),
            (up+upper*height)/(slope+upper),(up+lower*height)/(slope+lower))
    end end
    local focus=view.slotCFrame.Position+view.slotCFrame.LookVector*slope*distance
    return CFrame.lookAt(focus+Vector3.new(0,distance,0),focus,view.slotCFrame.LookVector),focus,50
end

return P
