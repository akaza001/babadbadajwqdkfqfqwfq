-- Presentation receipts hide a committed UID until its reveal finishes.
-- This never grants/removes server finds. Every cancel releases held UIDs.
local B={} B.__index=B
local function valid(r) return type(r)=='table' and r.committed==true and type(r.uid)=='string' and #r.uid>0 and #r.uid<=128 and type(r.itemId)=='string' end
function B.new(limit) return setmetatable({pending={},seen={},order={},limit=limit or 128},B) end
function B:hold(r,now)
 if not valid(r) or self.seen[r.uid] then return false end
 if self.pending[r.uid] and self.pending[r.uid].receipt.itemId~=r.itemId then return false end
 if not self.pending[r.uid] then self.pending[r.uid]={receipt=r,started=false,heldAt=now or 0} end
 return true
end
function B:start(r)
 if not self:hold(r) then return false end
 local p=self.pending[r.uid] if p.started then return false end p.started=true return true
end
function B:finish(uid)
 if not uid then return end
 self.pending[uid]=nil
 if not self.seen[uid] then
  self.seen[uid]=true table.insert(self.order,uid)
  if #self.order>self.limit then self.seen[table.remove(self.order,1)]=nil end
 end
end
function B:releaseAll()
 local ids={} for uid in self.pending do table.insert(ids,uid) end
 for _,uid in ids do self:finish(uid) end
end
function B:expire(now,timeout)
 local ids={} for uid,p in self.pending do if not p.started and now-p.heldAt>(timeout or 10) then table.insert(ids,uid) end end
 for _,uid in ids do self:finish(uid) end return #ids>0
end
function B:project(snapshot)
 if not snapshot or not snapshot.profile then return snapshot end
 local copy=table.clone(snapshot) copy.profile=table.clone(snapshot.profile) copy.profile.finds={}
 for uid,f in snapshot.profile.finds do if not self.pending[uid] then copy.profile.finds[uid]=f end end
 return copy
end
return B
