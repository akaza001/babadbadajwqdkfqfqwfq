local count=0
local function check(value) assert(value) count=count+1 end
local config=Config
local core=Core.new(config,{userIds={[7]=true}})
local p=core.defaults()
check(core.validate(p))
local changed=assert(core.apply(p,1,'collect',{}));check(changed.items.scrap==1 and p.items.scrap==nil)
p=changed
p=assert(core.apply(p,1,'sell',{}));check(p.coins==5 and next(p.items)==nil)
local no,err=core.apply(p,1,'upgrade',{});check(not no and err=='insufficient_coins')
no,err=core.apply(p,1,'coins.set',{value=100});check(not no and err=='forbidden')
p=assert(core.apply(p,7,'coins.set',{value=100}))
p=assert(core.apply(p,1,'upgrade',{}));check(p.coins==80 and p.level==2)
p=assert(core.apply(p,1,'collect',{}));check(p.items.scrap==2)
for _,v in ipairs({-1,1.5,math.huge,-math.huge}) do check(core.apply(p,7,'coins.set',{value=v})==nil) end
check(core.apply(p,7,'coins.set',{value=0/0})==nil)
check(core.apply(p,7,'item.grant',{id='unknown',amount=1})==nil)
check(core.apply(p,7,'item.grant',{id='scrap',amount=24})==nil)
check(core.apply(p,1,'collect',{amount=99})==nil)
check(core.apply(p,7,'progress.reset',{})==nil)
local reset=assert(core.apply(p,7,'progress.reset',{confirm=true}));check(reset.coins==0 and reset.level==1 and next(reset.items)==nil)
check(core.migrate({schema=99})==nil)
check(core.migrate({schema=1,coins=0,level=1,items={fake=1}})==nil)
local cloned=assert(core.migrate(p));cloned.coins=0;check(p.coins==80)
check(#core.describe(1).admin==0 and #core.describe(7).admin==4)
config.items.gem={name='Gem',sell=9}
check(core.describe(7).items.gem.sell==9)
check(core.apply(p,7,'item.grant',{id='gem',amount=1})~=nil)
config.items.gem=nil
local now=0
local sessions=Session.new(core,function() return now end)
sessions.open(1)
local first=sessions.request(1,1,'collect',{})
check(first.ok and first.profile.items.scrap==1)
first.profile.items.scrap=99
check(sessions.request(1,1,'collect',{}).profile.items.scrap==1)
check(sessions.view(1).items.scrap==1)
check(sessions.request(1,2,'collect',{}).error=='rate_limited')
now=1
check(sessions.request(1,2,'sell',{}).profile.coins==5)
for i=3,70 do now=i; sessions.request(1,i*100,'sell',{}) end
check(sessions.request(1,1,'collect',{}).error=='stale_sequence')
check(sessions.request(1,0/0,'collect',{}).error=='invalid_sequence')
sessions.close(1);check(sessions.request(1,8000,'collect',{}).error=='not_loaded')
sessions.open(1);check(sessions.view(1).coins==0) -- explicitly no durable persistence
sessions.open(2);check(sessions.view(2).coins==0)
check(sessions.request(2,1,'coins.set',{value=5}).error=='forbidden')
check(sessions.view(1).coins==0)
return count
