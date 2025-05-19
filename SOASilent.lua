local a=game:GetService'Players'local b=game:GetService'ReplicatedStorage'local
c=game:GetService'RunService'local d=game:GetService'UserInputService'local e=
game:GetService'Workspace'local f=false local g=true local h=false local i=500
local j={'Head','UpperTorso','LowerTorso'}local k=os local l=k.clock local m=
task local n=m.cancel local o=m.defer local p=m.delay local q=m.spawn local r=
math local s=r.abs local t=r.atan2 local u=r.cos local v=r.clamp local w=r.max
local x=r.pi local y=r.rad local z=r.sin local A=r.sqrt local B=5e-3 local C,D,E
,F=2*x,x/2,x/3,x/4 local G,H=Vector3.new(1,0,1),Vector3.zero do Vector3.new(0,1,
0)Vector3.new(1,0,0)Vector3.new(0,0,1)end local I do I=setmetatable({},{
__tostring=function()return'Connection'end})I.__index=I function I.new(...)local
J=setmetatable({},I)return J:constructor(...)or J end function I.constructor(J,K
,L)if L==nil then L=true end J.disconnect=K J.Connected=L end function I.
Disconnect(J)J.disconnect()J.Connected=false end end local J do J=setmetatable({
},{__tostring=function()return'Bin'end})J.__index=J function J.new(...)local K=
setmetatable({},J)return K:constructor(...)or K end function J.constructor(K)end
function J.add(K,L)local M={item=L}if K.head==nil then K.head=M end if K.tail
then K.tail.next=M end K.tail=M return L end function J.destroy(K)while K.head
do local L=K.head.item if type(L)=='function'then L()elseif typeof(L)==
'RBXScriptConnection'then L:Disconnect()elseif type(L)=='thread'then task.
cancel(L)elseif isrenderobj(L)then L:Destroy()elseif L.destroy~=nil then L:
destroy()elseif L.Destroy~=nil then L:Destroy()elseif L.disconnect~=nil then L:
disconnect()elseif L.Disconnect~=nil then L:Disconnect()elseif L.cancel~=nil
then L:cancel()end K.head=K.head.next end K.tail=nil end function J.isEmpty(K)
return K.head==nil end end local function expectChild(K,L,M)if M==nil then M=1e4
end local N=L local O=N[1]local P=N[2]local Q=if P==nil then function(Q)return Q
:IsA(O)end else function(Q)return Q.Name==P and Q:IsA(O)end for R,S in K:
GetChildren()do if Q(S)then return S end end local T local U=coroutine.running()
local V,W=K.ChildAdded:Connect(function(V)if Q(V)then T=V q(U)end end),p(M,
function()return q(U)end)coroutine.yield()if T then n(W)end if V.Connected then
V:Disconnect()end return T end local K=a.LocalPlayer local L=b.SettingModules
local M do M=setmetatable({},{__tostring=function()return'BaseComponent'end})M.
__index=M function M.new(...)local N=setmetatable({},M)return N:constructor(...)
or N end function M.constructor(N,O)N.instance=O N.bin=J.new()N.bin:add(O.
Destroying:Connect(function()return N:destroy()end))end function M.destroy(N)N.
bin:destroy()end end local N do local O=M N=setmetatable({},{__tostring=function
()return'CharacterRig'end,__index=O})N.__index=N function N.new(...)local P=
setmetatable({},N)return P:constructor(...)or P end function N.constructor(P,Q)O
.constructor(P,Q)P.health=100 P._subHealth={}local R=expectChild(Q,{'BasePart',
'HumanoidRootPart'},30)if not R then error(`[CharacterRig]: {Q} is missing HumanoidRootPart`
)end local T=expectChild(Q,{'BasePart','Head'},30)if not T then error(`[CharacterRig]: {
Q} is missing Head`)end local U=expectChild(Q,{'Humanoid','Humanoid'},30)if not
U then error(`[CharacterRig]: {Q} is missing Humanoid`)end P.root=R P.head=T P.
humanoid=U P.health=U.Health local V=P local W=V.bin W:add(U:
GetPropertyChangedSignal'Health':Connect(function()return P:
onHumanoidHealthChanged()end))q(function()return P:onHumanoidHealthChanged()end)
end function N.onHumanoidHealthChanged(P)local Q=P.humanoid.Health if Q==0 then
return P:destroy()end P.health=Q local R=P._subHealth local T=function(T)return
q(T,Q)end for U,V in R do T(V,U,R)end end function N.subscribeHealth(P,Q)local R
={}local T=P local U=T._subHealth local V=T.bin local W=T.health local X=Q U[R]=
X q(Q,W)return V:add(I.new(function()local Y=U[R]~=nil U[R]=nil return Y end))
end function N.getRoot(P)return P.root end function N.getHead(P)return P.head
end function N.getHumanoid(P)return P.humanoid end function N.getHealth(P)return
P.health end function N.getPivot(P)return P.instance:GetPivot()end function N.
getPosition(P)return P.root.Position end end local O do local P=M O=
setmetatable({},{__tostring=function()return'PlayerComponent'end,__index=P})O.
__index=O function O.new(...)local Q=setmetatable({},O)return Q:constructor(...)
or Q end function O.constructor(Q,R)P.constructor(Q,R)local T=O.players local U=
R local V=Q T[U]=V local W=R.Character if W then o(function()return Q:
onCharacter(W)end)end local X=Q local Y=X.bin Y:add(R.CharacterAdded:Connect(
function(Z)return Q:onCharacter(Z)end))Y:add(R.CharacterRemoving:Connect(
function()local Z=Q.character if Z~=nil then Z=Z:destroy()end return Z end))Y:
add(a.PlayerRemoving:Connect(function(Z)return R==Z and Q:destroy()end))Y:add(
function()local Z=O.players local _=R local aa=Z[_]~=nil Z[_]=nil return aa end)
end function O.onCharacter(aa,Q)aa.character=N.new(Q)end O.players={}end local
aa local P={}do local Q=P local R local T=function(T)local U=R if U~=nil then U:
destroy()end R=N.new(T)Q.framework=expectChild(T,{'LocalScript',
'ClientFramework'},30)Q.bulletmod=if Q.framework then expectChild(Q.framework,{
'ModuleScript','BulletModule'},30)else nil aa.update()end local U=function()
local U=R if U~=nil then U:destroy()end R=nil Q.framework=nil Q.bulletmod=nil
end local function __init__()K.CharacterAdded:Connect(T)K.CharacterRemoving:
Connect(U)local V=K.Character if V then q(T,V)end end Q.__init__=__init__
local function getRoot()local V=R if V~=nil then V=V:getRoot()end return V end Q
.getRoot=getRoot local function getHumanoid()local V=R if V~=nil then V=V:
getHumanoid()end return V end Q.getHumanoid=getHumanoid local function getHealth
()local V=R if V~=nil then V=V:getHealth()end return V end Q.getHealth=getHealth
local function getPosition()local V=R if V~=nil then V=V:getPosition()end local
W=V if W==nil then W=H end return W end Q.getPosition=getPosition local function
getPivot()local V=R if V~=nil then V=V:getPivot()end local W=V if W==nil then W=
CFrame.new()end return W end Q.getPivot=getPivot end local Q={}do local R=Q
local T=function(T)return O.new(T)end local function __init()for U,V in a:
GetPlayers()do local W=V~=K and T(V)end a.PlayerAdded:Connect(T)end R.__init=
__init end local R aa={}do local T=aa local U local V,W local function update()
local X=P.bulletmod if X then local Y=require(X)local Z=Y.new Y.new=function(...
)local _={...}local ab=V()if ab then local ac=W(ab)if not ac then return Z(
unpack(_))end if g then _[3]=Vector3.new(0,0,0)end if h then local ad=ac.
Position local ae=_[1]local af=(ad-ae).Unit*10000*1e3 _[2]=af else local ad=ac.
Position local ae=_[1]local af=(ad-ae).Unit*10000 _[2]=af end warn('direction: '
,_[2])end return Z(unpack(_))end end end T.update=update W=function(ab)local ac=
table.create(#j)local ad=function(ad)return ab.instance:FindFirstChild(ad)end
for ae,af in j do ac[ae]=ad(af,ae-1,j)end local X={}local Y=function(Y)return Y
~=nil end local Z=0 for _,ag in ac do if Y(ag,_-1,ac)==true then Z+=1 X[Z]=ag
end end local ah=X if#ah==0 then return nil end local ai=Random.new():
NextInteger(0,#ah-1)return ah[ai+1]end V=function()local ab=O.players local ac=d
:GetMouseLocation()local ad local ag=-math.huge local ah=function(ah)local ai=ah
.character if ai==nil then return nil end local X=ai if X==nil then return nil
end local Y=ai:getPosition()local Z=R.worldToViewportPoint(Y)if Z.Z<0 then
return nil end if f then local _=R.getPivot().Position U.
FilterDescendantsInstances={ai.instance,K.Character}local aj=e:Raycast(_,Y-_,U)
if aj then return nil end end local aj=(Vector2.new(Z.X,Z.Y)-ac).Magnitude if aj
>i then return nil end local _=1e3-aj if _>ag then ad=ai ag=_ end end for ai,aj
in ab do ah(aj,ai,ab)end return ad end local function __init()U=RaycastParams.
new()U.FilterType=Enum.RaycastFilterType.Exclude U.IgnoreWater=true update()end
T.__init=__init end local ab={}do local ac=ab local ad=Drawing.new'Circle'ad.
Filled=false ad.NumSides=32 ad.Thickness=2 ad.Visible=true ad.Color=Color3.new(
0.84,0.38,0.38)local function __init()c.RenderStepped:Connect(function()if ad
then local ag=d:GetMouseLocation()ad.Radius=i ad.Position=Vector2.new(ag.X,ag.Y)
end end)end ac.__init=__init end R={}do local ac=R local ad local ag local ah
local function worldToViewportPoint(ai)return ad:WorldToViewportPoint(ai)end ac.
worldToViewportPoint=worldToViewportPoint local function
safeWorldToViewportPoint(ai)local aj=ad.CFrame local T=aj:PointToObjectSpace(ai)
local U=t(T.Y,T.X)+x local V=CFrame.new(0,0,0)local W=CFrame.Angles(0,0,U)local
X=CFrame.Angles(0,D-B,0)local Y=(V*W*X).LookVector local Z=aj:PointToWorldSpace(
Y)local _=worldToViewportPoint(Z)local ak=Vector2.new(_.X,_.Y)local al=ah local
am=(ak-al).Unit local an=ah local ao=am*1e5 return an+ao end ac.
safeWorldToViewportPoint=safeWorldToViewportPoint local function getPivot()
return ad.CFrame end ac.getPivot=getPivot local function getScreenSize()return
ag end ac.getScreenSize=getScreenSize local function getCamera()return ad end ac
.getCamera=getCamera local ai=function()ag=ad.ViewportSize ah=ag/2 end local aj=
function()local aj=e.CurrentCamera ad=aj ad:GetPropertyChangedSignal
'ViewportSize':Connect(ai)ai()end local function __init()e:
GetPropertyChangedSignal'CurrentCamera':Connect(aj)aj()end ac.__init=__init end
P.__init__()Q.__init()aa.__init()ab.__init()R.__init()
