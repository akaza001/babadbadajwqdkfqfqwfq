#!/usr/bin/env python3
"""Build offline Studio Command Bar installer; no network or Studio mutation."""
import hashlib,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def lua(s):
    # Long strings must not discard a first newline, sources begin with code/comments.
    for n in range(20):
        eq='='*n
        if ']'+eq+']' not in s:return '['+eq+'['+s+']'+eq+']'
    raise ValueError('long bracket delimiter exhausted')
def build():
    files=[]
    for p in sorted((ROOT/'src').rglob('*.luau')):
        data=p.read_bytes();files.append({'path':p.relative_to(ROOT).as_posix(),'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data)})
    package=hashlib.sha256(json.dumps(files,sort_keys=True).encode()).hexdigest()
    specs=[]
    for f in files:
        p=ROOT/f['path']; area=p.parent.name
        name=p.name.removesuffix('.luau');kind='ModuleScript'
        if name.endswith('.server'):name=name[:-7];kind='Script'
        if name.endswith('.client'):name=name[:-7];kind='LocalScript'
        specs.append('{area='+lua(area)+',name='+lua(name)+',class='+lua(kind)+',source='+lua(p.read_text())+'}')
    code='''-- Generated offline installer. Run in Studio Command Bar in EDIT, on a blank test place.
assert(not game:GetService('RunService'):IsRunning(),'Stop Play before installing')
local packageId=PACKAGE
local specs={SPECS}
local roots={shared=game:GetService('ReplicatedStorage'),server=game:GetService('ServerScriptService'),client=game:GetService('StarterPlayer'):WaitForChild('StarterPlayerScripts')}
local existing=0
for _,parent in pairs(roots) do if parent:FindFirstChild('SimulatorTemplate') then existing=existing+1 end end
if existing>0 then
 assert(existing==3,'Partial/existing installation: refusing to overwrite')
 for _,spec in ipairs(specs) do
  local root=roots[spec.area]:FindFirstChild('SimulatorTemplate')
  assert(root:GetAttribute('PackageId')==packageId,'Existing template differs; install in another test place')
  local obj=root:FindFirstChild(spec.name)
  assert(obj and obj.ClassName==spec.class and obj.Source==spec.source,'Existing source changed; refusing to overwrite')
 end
 print('Simulator template already installed; no changes') return
end
local staged={}
local ok,err=pcall(function()
 for area in pairs(roots) do
  local folder=Instance.new('Folder') folder.Name='SimulatorTemplate' folder:SetAttribute('PackageId',packageId) staged[area]=folder
 end
 for _,spec in ipairs(specs) do
  local obj=Instance.new(spec.class)
  if spec.class~='ModuleScript' then obj.Disabled=true end
  obj.Name=spec.name obj.Source=spec.source obj.Parent=staged[spec.area]
 end
 local remote=Instance.new('RemoteFunction') remote.Name='Request' remote.Parent=staged.shared
 -- All code is staged before any root is attached; runtime scripts remain disabled until commit.
 for area,parent in pairs(roots) do staged[area].Parent=parent end
 for _,folder in pairs(staged) do for _,obj in ipairs(folder:GetChildren()) do
  if obj:IsA('Script') or obj:IsA('LocalScript') then obj.Disabled=false end
 end end
end)
if not ok then for _,folder in pairs(staged) do folder:Destroy() end error('Install rolled back: '..tostring(err)) end
print('Simulator template installed. RAM ONLY. Configure server AdminConfig; press Play for the UI prototype.')
'''.replace('PACKAGE',lua(package)).replace('SPECS',',\n'.join(specs))
    (ROOT/'dist').mkdir(exist_ok=True)
    (ROOT/'dist/Install.luau').write_text(code)
    (ROOT/'dist/manifest.json').write_text(json.dumps({'version':'0.0.1','packageId':package,'files':files,'storage':'RAM_ONLY','externalRuntimeAssetsRequired':False,'worldGeneration':False},indent=2)+'\n')
    return package
if __name__=='__main__':print(build())
