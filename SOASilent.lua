local Players=game:GetService('Players')local ReplicatedStorage=game:GetService(
'ReplicatedStorage')local RunService=game:GetService('RunService')local
UserInputService=game:GetService('UserInputService')local Workspace=game:
GetService('Workspace')local wallcheck=false local nogravity=true local
instanthit=false local radius=500 local TargetParts={'Head','UpperTorso',
'LowerTorso'}local _binding=os local clock=_binding.clock local _binding_1=task
local cancel=_binding_1.cancel local defer=_binding_1.defer local delay=
_binding_1.delay local spawn=_binding_1.spawn local _binding_2=math local abs=
_binding_2.abs local atan2=_binding_2.atan2 local cos=_binding_2.cos local clamp
=_binding_2.clamp local max=_binding_2.max local pi=_binding_2.pi local rad=
_binding_2.rad local sin=_binding_2.sin local sqrt=_binding_2.sqrt local EPSILON
=5e-3 local PI,TAU,SEMI,DEG60,DEG45=pi,2*pi,pi/2,pi/3,pi/4 local VECTOR3_2D,
VECTOR3_ZERO=Vector3.new(1,0,1),Vector3.zero local WORLD_UP,WORLD_RIGHT,
WORLD_FORWARD=Vector3.new(0,1,0),Vector3.new(1,0,0),Vector3.new(0,0,1)local
wrapRad=function(angle)return((angle%TAU)+TAU)%TAU end local Connection do
Connection=setmetatable({},{__tostring=function()return'Connection'end})
Connection.__index=Connection function Connection.new(...)local self=
setmetatable({},Connection)return self:constructor(...)or self end function
Connection:constructor(disconnect,Connected)if Connected==nil then Connected=
true end self.disconnect=disconnect self.Connected=Connected end function
Connection:Disconnect()self.disconnect()self.Connected=false end end local Bin
do Bin=setmetatable({},{__tostring=function()return'Bin'end})Bin.__index=Bin
function Bin.new(...)local self=setmetatable({},Bin)return self:constructor(...)
or self end function Bin:constructor()end function Bin:add(item)local node={item
=item}if self.head==nil then self.head=node end if self.tail then self.tail.next
=node end self.tail=node return item end function Bin:destroy()while self.head
do local item=self.head.item if type(item)=='function'then item()elseif typeof(
item)=='RBXScriptConnection'then item:Disconnect()elseif type(item)=='thread'
then task.cancel(item)elseif isrenderobj(item)then item:Destroy()elseif item.
destroy~=nil then item:destroy()elseif item.Destroy~=nil then item:Destroy()
elseif item.disconnect~=nil then item:disconnect()elseif item.Disconnect~=nil
then item:Disconnect()elseif item.cancel~=nil then item:cancel()end self.head=
self.head.next end self.tail=nil end function Bin:isEmpty()return self.head==nil
end end local function expectChild(obj,criteria,timeout)if timeout==nil then
timeout=1e4 end local _binding_3=criteria local kind=_binding_3[1]local name=
_binding_3[2]local isValid=if name==nil then function(obj)return obj:IsA(kind)
end else function(obj)return obj.Name==name and obj:IsA(kind)end for _,v in obj:
GetChildren()do if isValid(v)then return v end end local v local thread=
coroutine.running()local c,d=obj.ChildAdded:Connect(function(i)if isValid(i)then
v=i spawn(thread)end end),delay(timeout,function()return spawn(thread)end)
coroutine.yield()if v then cancel(d)end if c.Connected then c:Disconnect()end
return v end local function forChildThen(obj,criteria,callback,n)if n==nil then
n=9e9 end local _binding_3=criteria local kind=_binding_3[1]local name=
_binding_3[2]local isValid=if name==nil then function(obj)return obj:IsA(kind)
end else function(obj)return obj.Name==name and obj:IsA(kind)end for _,v in obj:
GetChildren()do if isValid(v)then spawn(callback,v)n-=1 if n==0 then return
Connection.new(function()end)end end end local connection connection=obj.
ChildAdded:Connect(function(v)if isValid(v)then spawn(callback,v)n-=1 if n==0
then connection:Disconnect()end end end)return Connection.new(function()if
connection.Connected then connection:Disconnect()end end)end local function
forDescendantThen(parent,criteria,callback,n)if n==nil then n=9e9 end local
_binding_3=criteria local kind=_binding_3[1]local name=_binding_3[2]local
isValid=if name==nil then function(obj)return obj:IsA(kind)end else function(obj
)return obj.Name==name and obj:IsA(kind)end local checkExistingDescendants=
function(obj)for _,child in obj:GetDescendants()do if isValid(child)then spawn(
callback,child)n-=1 if n==0 then return nil end end end end
checkExistingDescendants(parent)local connection connection=parent.
DescendantAdded:Connect(function(descendant)if isValid(descendant)then spawn(
callback,descendant)n-=1 if n==0 then connection:Disconnect()end end end)return
Connection.new(function()if connection.Connected then connection:Disconnect()end
end)end local function whenChildThen(obj,criteria,callback,timeout)if timeout==
nil then timeout=1e4 end local connection local thread=delay(timeout,function()
if connection.Connected then connection:Disconnect()end end)connection=
forChildThen(obj,criteria,function(child)cancel(thread)callback(child)end,1)
return connection end local LocalPlayer=Players.LocalPlayer local settingMods=
ReplicatedStorage.SettingModules local BaseComponent do BaseComponent=
setmetatable({},{__tostring=function()return'BaseComponent'end})BaseComponent.
__index=BaseComponent function BaseComponent.new(...)local self=setmetatable({},
BaseComponent)return self:constructor(...)or self end function BaseComponent:
constructor(instance)self.instance=instance self.bin=Bin.new()self.bin:add(
instance.Destroying:Connect(function()return self:destroy()end))end function
BaseComponent:destroy()self.bin:destroy()end end local CharacterRig do local
super=BaseComponent CharacterRig=setmetatable({},{__tostring=function()return
'CharacterRig'end,__index=super})CharacterRig.__index=CharacterRig function
CharacterRig.new(...)local self=setmetatable({},CharacterRig)return self:
constructor(...)or self end function CharacterRig:constructor(instance)super.
constructor(self,instance)self.health=100 self._subHealth={}local root=
expectChild(instance,{'BasePart','HumanoidRootPart'},30)if not root then error(`[CharacterRig]: {
instance} is missing HumanoidRootPart`)end local head=expectChild(instance,{
'BasePart','Head'},30)if not head then error(`[CharacterRig]: {instance} is missing Head`
)end local humanoid=expectChild(instance,{'Humanoid','Humanoid'},30)if not
humanoid then error(`[CharacterRig]: {instance} is missing Humanoid`)end self.
root=root self.head=head self.humanoid=humanoid self.health=humanoid.Health
local _binding_3=self local bin=_binding_3.bin bin:add(humanoid:
GetPropertyChangedSignal('Health'):Connect(function()return self:
onHumanoidHealthChanged()end))spawn(function()return self:
onHumanoidHealthChanged()end)end function CharacterRig:onHumanoidHealthChanged()
local health=self.humanoid.Health if health==0 then return self:destroy()end
self.health=health local _exp=self._subHealth local _callback=function(callback)
return spawn(callback,health)end for _k,_v in _exp do _callback(_v,_k,_exp)end
end function CharacterRig:subscribeHealth(callback)local id={}local _binding_3=
self local _subHealth=_binding_3._subHealth local bin=_binding_3.bin local
health=_binding_3.health local _callback=callback _subHealth[id]=_callback
spawn(callback,health)return bin:add(Connection.new(function()local
_valueExisted=_subHealth[id]~=nil _subHealth[id]=nil return _valueExisted end))
end function CharacterRig:getRoot()return self.root end function CharacterRig:
getHead()return self.head end function CharacterRig:getHumanoid()return self.
humanoid end function CharacterRig:getHealth()return self.health end function
CharacterRig:getPivot()return self.instance:GetPivot()end function CharacterRig:
getPosition()return self.root.Position end end local PlayerComponent do local
super=BaseComponent PlayerComponent=setmetatable({},{__tostring=function()return
'PlayerComponent'end,__index=super})PlayerComponent.__index=PlayerComponent
function PlayerComponent.new(...)local self=setmetatable({},PlayerComponent)
return self:constructor(...)or self end function PlayerComponent:constructor(
player)super.constructor(self,player)local _players=PlayerComponent.players
local _player=player local _self=self _players[_player]=_self local character=
player.Character if character then defer(function()return self:onCharacter(
character)end)end local _binding_3=self local bin=_binding_3.bin bin:add(player.
CharacterAdded:Connect(function(char)return self:onCharacter(char)end))bin:add(
player.CharacterRemoving:Connect(function()local _result=self.character if
_result~=nil then _result=_result:destroy()end return _result end))bin:add(
Players.PlayerRemoving:Connect(function(plr)return player==plr and self:destroy(
)end))bin:add(function()local _players_1=PlayerComponent.players local _player_1
=player local _valueExisted=_players_1[_player_1]~=nil _players_1[_player_1]=nil
return _valueExisted end)end function PlayerComponent:onCharacter(character)self
.character=CharacterRig.new(character)end PlayerComponent.players={}end local
RangedController local AgentController={}do local _container=AgentController
local component local onCharacterAdded=function(character)local _result=
component if _result~=nil then _result:destroy()end component=CharacterRig.new(
character)_container.framework=expectChild(character,{'LocalScript',
'ClientFramework'},30)_container.bulletmod=if _container.framework then
expectChild(_container.framework,{'ModuleScript','BulletModule'},30)else nil
RangedController.update()end local onCharacterRemoved=function()local _result=
component if _result~=nil then _result:destroy()end component=nil _container.
framework=nil _container.bulletmod=nil end local function __init__()LocalPlayer.
CharacterAdded:Connect(onCharacterAdded)LocalPlayer.CharacterRemoving:Connect(
onCharacterRemoved)local character=LocalPlayer.Character if character then
spawn(onCharacterAdded,character)end end _container.__init__=__init__
local function getRoot()local _result=component if _result~=nil then _result=
_result:getRoot()end return _result end _container.getRoot=getRoot
local function getHumanoid()local _result=component if _result~=nil then _result
=_result:getHumanoid()end return _result end _container.getHumanoid=getHumanoid
local function getHealth()local _result=component if _result~=nil then _result=
_result:getHealth()end return _result end _container.getHealth=getHealth
local function getPosition()local _result=component if _result~=nil then _result
=_result:getPosition()end local _condition=_result if _condition==nil then
_condition=VECTOR3_ZERO end return _condition end _container.getPosition=
getPosition local function getPivot()local _result=component if _result~=nil
then _result=_result:getPivot()end local _condition=_result if _condition==nil
then _condition=CFrame.new()end return _condition end _container.getPivot=
getPivot end local PlayerController={}do local _container=PlayerController local
onPlayer=function(player)return PlayerComponent.new(player)end local function
__init()for _,player in Players:GetPlayers()do local _1=player~=LocalPlayer and
onPlayer(player)end Players.PlayerAdded:Connect(onPlayer)end _container.__init=
__init end local CameraController RangedController={}do local _container=
RangedController local rayParams local getTarget,getRandomPart local function
update()local newBulletModule=AgentController.bulletmod if newBulletModule then
local bulletMod=require(newBulletModule)local oldFire=bulletMod.new bulletMod.
new=function(...)local args={...}local target=getTarget()if target then local
targetpart=getRandomPart(target)if not targetpart then return oldFire(unpack(
args))end if nogravity then args[3]=Vector3.new(0,0,0)end if instanthit then
local _position=targetpart.Position local _arg0=args[1]local direction=(
_position-_arg0).Unit*10000*1e3 args[2]=direction else local _position=
targetpart.Position local _arg0=args[1]local direction=(_position-_arg0).Unit*
10000 args[2]=direction end warn('direction: ',args[2])end return oldFire(
unpack(args))end end end _container.update=update getRandomPart=function(
character)local _newValue=table.create(#TargetParts)local _callback=function(
partName)return character.instance:FindFirstChild(partName)end for _k,_v in
TargetParts do _newValue[_k]=_callback(_v,_k-1,TargetParts)end local _newValue_1
={}local _callback_1=function(part)return part~=nil end local _length=0 for _k,
_v in _newValue do if _callback_1(_v,_k-1,_newValue)==true then _length+=1
_newValue_1[_length]=_v end end local availableParts=_newValue_1 if#
availableParts==0 then return nil end local randomIndex=Random.new():
NextInteger(0,#availableParts-1)return availableParts[randomIndex+1]end
getTarget=function()local list=PlayerComponent.players local mousePosition=
UserInputService:GetMouseLocation()local bestTarget local weight=-math.huge
local _callback=function(component)local character=component.character if
character==nil then return nil end local targetPart=character if targetPart==nil
then return nil end local position=character:getPosition()local viewportPoint=
CameraController.worldToViewportPoint(position)if viewportPoint.Z<0 then return
nil end if wallcheck then local origin=CameraController.getPivot().Position
rayParams.FilterDescendantsInstances={character.instance,LocalPlayer.Character}
local result=Workspace:Raycast(origin,position-origin,rayParams)if result then
return nil end end local screenDistance=(Vector2.new(viewportPoint.X,
viewportPoint.Y)-mousePosition).Magnitude if screenDistance>radius then return
nil end local prio=1e3-screenDistance if prio>weight then bestTarget=character
weight=prio end end for _k,_v in list do _callback(_v,_k,list)end return
bestTarget end local function __init()rayParams=RaycastParams.new()rayParams.
FilterType=Enum.RaycastFilterType.Exclude rayParams.IgnoreWater=true update()end
_container.__init=__init end local VisualsController={}do local _container=
VisualsController local circle=Drawing.new('Circle')circle.Filled=false circle.
NumSides=32 circle.Thickness=2 circle.Visible=true circle.Color=Color3.new(0.84,
0.38,0.38)local function __init()RunService.RenderStepped:Connect(function()if
circle then local mousePosition=UserInputService:GetMouseLocation()circle.Radius
=radius circle.Position=Vector2.new(mousePosition.X,mousePosition.Y)end end)end
_container.__init=__init end CameraController={}do local _container=
CameraController local camera local screen_size local screen_center
local function worldToViewportPoint(position)return camera:WorldToViewportPoint(
position)end _container.worldToViewportPoint=worldToViewportPoint local function
safeWorldToViewportPoint(position)local eye=camera.CFrame local relative=eye:
PointToObjectSpace(position)local angle=atan2(relative.Y,relative.X)+pi local
_cFrame=CFrame.new(0,0,0)local _arg0=CFrame.Angles(0,0,angle)local _arg0_1=
CFrame.Angles(0,SEMI-EPSILON,0)local oriented=(_cFrame*_arg0*_arg0_1).LookVector
local worldPosition=eye:PointToWorldSpace(oriented)local viewportPoint=
worldToViewportPoint(worldPosition)local _vector2=Vector2.new(viewportPoint.X,
viewportPoint.Y)local _screen_center=screen_center local direction=(_vector2-
_screen_center).Unit local _screen_center_1=screen_center local _arg0_2=
direction*1e5 return _screen_center_1+_arg0_2 end _container.
safeWorldToViewportPoint=safeWorldToViewportPoint local function getPivot()
return camera.CFrame end _container.getPivot=getPivot local function
getScreenSize()return screen_size end _container.getScreenSize=getScreenSize
local function getCamera()return camera end _container.getCamera=getCamera local
updateScreen=function()screen_size=camera.ViewportSize screen_center=screen_size
/2 end local updateCamera=function()local current=Workspace.CurrentCamera camera
=current camera:GetPropertyChangedSignal('ViewportSize'):Connect(updateScreen)
updateScreen()end local function __init()Workspace:GetPropertyChangedSignal(
'CurrentCamera'):Connect(updateCamera)updateCamera()end _container.__init=__init
end AgentController.__init__()PlayerController.__init()RangedController.__init()
VisualsController.__init()CameraController.__init()