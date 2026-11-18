local Timeline=require('../shared/RevealTimeline')
local Receipts=require('../client/RevealReceipts')
local Catalog=require('../shared/ItemCatalog')
local checks=0
local function check(value,message) assert(value,message) checks+=1 end
check(#Catalog.items==108,'catalog size')
local counts={common=0,uncommon=0,rare=0,epic=0,mythic=0,legendary=0}
for _,item in Catalog.items do counts[item.rarity]+=1 check(Catalog.byId[item.id]==item,'stable IDs') check(item.states[1]=='Dirty' and item.states[2]=='Clean','same species states') end
check(counts.common==36 and counts.uncommon==27 and counts.rare==18 and counts.epic==18 and counts.mythic==9 and counts.legendary==0,'rarity counts')
for _,extra in {0,.1,.2,.35,.5} do
 local last=0
 for i=0,1000 do
  local v=Timeline.sample(Timeline.duration(extra)*i/1000,extra,false)
  check(v.travel>=last and v.travel<=1 and v.travel>=0,'monotonic flight') last=v.travel
  check(v.alpha>=0 and v.alpha<=1 and v.scale>=0 and v.scale<=1.101,'valid presentation envelope')
 end
 check(Timeline.sample(Timeline.duration(extra),extra,false).stage=='done','completion')
end
local a={uid='uid-a',itemId='F-01',committed=true}
local b={uid='uid-b',itemId='F-01',committed=true}
local base={profile={finds={['uid-a']={itemId='F-01'},['uid-b']={itemId='F-01'},old={itemId='F-02'}},coins=120},state='Idle'}
local r=Receipts.new(2)
check(not r:hold({uid='fake',itemId='F-01'}),'uncommitted receipt ignored')
check(r:hold(a,3),'confirmed hold')
check(r:project(base).profile.finds['uid-a']==nil,'held award hidden')
check(base.profile.finds['uid-a']~=nil and base.profile.coins==120,'server snapshot unchanged')
check(r:start(a),'first start') check(not r:start(a),'duplicate start rejected')
check(not r:hold({uid='uid-a',itemId='F-04',committed=true}),'conflicting exact UID ignored')
check(r:hold(b,4),'same species different UID accepted')
check(r:project(base).profile.finds['uid-b']==nil,'second exact UID hidden')
r:finish(a.uid)
check(r:project(base).profile.finds['uid-a']~=nil and r:project(base).profile.finds['uid-b']==nil,'exact UID release')
check(not r:start(a),'finished duplicate ignored')
check(r:expire(20,10),'missing reveal event expires')
check(next(r.pending)==nil and r:project(base).profile.finds['uid-b']~=nil,'timeout releases without deletion')
local c={uid='c',itemId='F-04',committed=true} r:start(c) r:releaseAll()
check(next(r.pending)==nil and not r:start(c),'respawn releases all once')
for i=1,20 do r:finish('new'..i) end
local seen=0 for _ in r.seen do seen+=1 end check(seen==2 and #r.order==2,'bounded dedupe memory')
print('PASS checks='..checks)
