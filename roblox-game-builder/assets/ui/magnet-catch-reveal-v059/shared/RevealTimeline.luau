-- Pure time sampling shared with offline previews; no grants or Roblox state.
local T={enter=.38,hold=1.45,fly=.62,settle=.20}
local function clamp(x) return math.clamp(x,0,1) end
local function out(x) return 1-(1-clamp(x))^3 end
function T.duration(extra) return T.enter+T.hold+(extra or 0)+T.fly+T.settle end
function T.sample(elapsed,extra,reducedMotion)
 local holdEnd=T.enter+T.hold+(extra or 0) local flyEnd=holdEnd+T.fly
 if elapsed<T.enter then
  local u=clamp(elapsed/T.enter) local q=u-1 local scale=1+2.70158*q^3+1.70158*q^2
  return {stage='enter',scale=reducedMotion and 1 or scale,alpha=out(u),travel=0,spin=reducedMotion and 0 or -18*(1-out(u)),glow=out(u)}
 elseif elapsed<holdEnd then
  local u=clamp((elapsed-T.enter)/(holdEnd-T.enter))
  return {stage='hold',scale=1,alpha=1,travel=0,spin=reducedMotion and 0 or 18*math.sin(u*math.pi*.8),glow=1}
 elseif elapsed<flyEnd then
  local u=out((elapsed-holdEnd)/T.fly)
  return {stage='fly',scale=1-.88*u,alpha=1-.25*u,travel=u,spin=reducedMotion and 0 or 10*(1-u),glow=1-u}
 elseif elapsed<T.duration(extra) then
  local u=clamp((elapsed-flyEnd)/T.settle)
  return {stage='settle',scale=.12,alpha=1-u,travel=1,spin=0,glow=0,pulse=math.sin(u*math.pi)}
 end
 return {stage='done',scale=.12,alpha=0,travel=1,spin=0,glow=0,pulse=0}
end
return T
