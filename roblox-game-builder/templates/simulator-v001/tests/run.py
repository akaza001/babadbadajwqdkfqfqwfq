#!/usr/bin/env python3
import json,hashlib,sys
from pathlib import Path
from lupa import LuaRuntime
ROOT=Path(__file__).resolve().parents[1]
lua=LuaRuntime(unpack_returned_tuples=True)
for name,path in [('Config','shared/Config.luau'),('Core','server/Core.luau'),('Session','server/Session.luau')]:
    lua.globals()[name]=lua.execute((ROOT/'src'/path).read_text())
count=lua.execute((ROOT/'tests/core.lua').read_text())
# Syntax check every shipped source and installer using Lua-compatible subset.
for p in list((ROOT/'src').rglob('*.luau'))+[ROOT/'dist/Install.luau']:
    result=lua.eval('function(s) local fn,err=load(s); assert(fn,err); return true end')(p.read_text())
# Execute installer against a fake object tree: meaningful non-destructive/idempotence checks.
lua.execute('''
local methods={}
function methods:FindFirstChild(n) for _,x in ipairs(self.children) do if x.Name==n then return x end end end
function methods:WaitForChild(n) return assert(self:FindFirstChild(n)) end
function methods:GetChildren() return self.children end
function methods:SetAttribute(k,v) self.attrs[k]=v end
function methods:GetAttribute(k) return self.attrs[k] end
function methods:IsA(k) return self.ClassName==k end
function methods:Destroy() self.Parent=nil self.destroyed=true end
function methods:IsRunning() return mockRunning==true end
Instance={}
function Instance.new(kind)
 local data={ClassName=kind,children={},attrs={}}
 return setmetatable({}, {__index=function(_,k) return methods[k] or data[k] end,
 __newindex=function(self,k,v)
 if k=='Parent' then
  if data.Parent then for i,x in ipairs(data.Parent.children) do if x==self then table.remove(data.Parent.children,i);break end end end
  if v then table.insert(v.children,self) end
 end data[k]=v end})
end
services={}
for _,name in ipairs({'RunService','ReplicatedStorage','ServerScriptService','StarterPlayer'}) do services[name]=Instance.new('Folder') end
local scripts=Instance.new('Folder');scripts.Name='StarterPlayerScripts';scripts.Parent=services.StarterPlayer
game={GetService=function(_,name) return assert(services[name]) end}
''')
installer=(ROOT/'dist/Install.luau').read_text()
lua.execute(installer)
shared=lua.eval("services.ReplicatedStorage:FindFirstChild('SimulatorTemplate')")
lua.execute(installer)
lua.globals().installedShared=shared
lua.execute("assert(services.ReplicatedStorage:FindFirstChild('SimulatorTemplate')==installedShared)")
lua.execute("assert(#services.ReplicatedStorage:GetChildren()==1); assert(#services.ServerScriptService:GetChildren()==1)")
lua.execute("services.ReplicatedStorage:FindFirstChild('SimulatorTemplate'):FindFirstChild('Config').Source='-- custom change'")
try:lua.execute(installer)
except Exception as e: assert 'refusing to overwrite' in str(e)
else:raise AssertionError('changed installation was overwritten')
lua.execute("assert(services.ReplicatedStorage:FindFirstChild('SimulatorTemplate'):FindFirstChild('Config').Source=='-- custom change')")
# Refuse a partial installation, refuse Play mode, clean staged objects on failure.
lua.execute("services.ServerScriptService:FindFirstChild('SimulatorTemplate'):Destroy()")
try: lua.execute(installer)
except Exception as e: assert 'Partial/existing installation' in str(e)
else: raise AssertionError('partial installation was overwritten')
lua.execute("mockRunning=true")
try: lua.execute(installer)
except Exception as e: assert 'Stop Play' in str(e)
else: raise AssertionError('installed while running')
lua.execute("mockRunning=false")
lua.execute("""
for _,parent in ipairs({services.ReplicatedStorage,services.ServerScriptService,services.StarterPlayer:WaitForChild('StarterPlayerScripts')}) do
 local root=parent:FindFirstChild('SimulatorTemplate'); if root then root:Destroy() end
end
originalNew=Instance.new
Instance.new=function(class) if class=='LocalScript' then error('injected source creation failure') end return originalNew(class) end
""")
try: lua.execute(installer)
except Exception as e: assert 'Install rolled back' in str(e)
else: raise AssertionError('injected failure did not fail')
lua.execute("""
assert(#services.ReplicatedStorage:GetChildren()==0)
assert(#services.ServerScriptService:GetChildren()==0)
assert(#services.StarterPlayer:WaitForChild('StarterPlayerScripts'):GetChildren()==0)
Instance.new=originalNew
""")
m=json.loads((ROOT/'dist/manifest.json').read_text())
for f in m['files']:assert hashlib.sha256((ROOT/f['path']).read_bytes()).hexdigest()==f['sha256']
report={'luaRuntime':lua.eval('_VERSION'),'coreAssertions':count,'sourceSyntax':'all sources and installer compile under Lua 5.4/5.5 compatible subset','installer':'fresh install, repeat no duplicates, edited source preserved, partial install and Play refused, injected failure rollback (mock DataModel)','manifest':'all source hashes match','notTested':['Roblox Studio execution','real UI rendering/input','physical devices','persistent storage/rejoin','real DataModel permission errors'],'storage':'RAM_ONLY'}
(ROOT/'tests/results.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print(json.dumps(report,ensure_ascii=False,indent=2))
