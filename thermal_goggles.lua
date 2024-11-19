-- Compiled with roblox-ts v2.3.0
local Thermal_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/RelkzzRebranded/SharedRoblox_UI/main/THERMALVISION_GUI.lua"))()
local repo = "https://raw.githubusercontent.com/RelkzzRebranded/LinoriaLib-Cloneref/main/"
local initLib = loadstring(game:HttpGet(repo .. "Library.lua"))()
-- task.defer() my beloved for 20+ above player count in each servers
local CoreGui = cloneref(game:GetService("CoreGui"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local Players = cloneref(game:GetService("Players"))
local Lighting = cloneref(game:GetService("Lighting"))
local RunService = cloneref(game:GetService("RunService"))
local LocalPlayer = Players.LocalPlayer
local Toggle = Instance.new("BoolValue")
-- PRELOADED SOUND
writefile("BEEPINGSOUNDTHERMAL.mp3", request({
	Url = "https://github.com/BongCloudMaster/meetthegrahams/raw/refs/heads/main/beepingsoundthermal.mp3",
	Method = "GET",
}).Body)
local beepSound = Instance.new("Sound")
beepSound.SoundId = getcustomasset("BEEPINGSOUNDTHERMAL.mp3", false)
beepSound.Volume = 0.5
beepSound.Looped = false
beepSound.Parent = CoreGui
--[[
	***********************************************************
	 * UTILITIES
	 * Description: Helper functions and classes
	 ***********************************************************
]]
local Bin
do
	Bin = setmetatable({}, {
		__tostring = function()
			return "Bin"
		end,
	})
	Bin.__index = Bin
	function Bin.new(...)
		local self = setmetatable({}, Bin)
		return self:constructor(...) or self
	end
	function Bin:constructor()
	end
	function Bin:add(item)
		local node = {
			item = item,
		}
		if self.head == nil then
			self.head = node
		end
		if self.tail then
			self.tail.next = node
		end
		self.tail = node
		return item
	end
	function Bin:batch(...)
		local args = { ... }
		for _, item in args do
			local node = {
				item = item,
			}
			if self.head == nil then
				self.head = node
			end
			if self.tail then
				self.tail.next = node
			end
			self.tail = node
		end
		return args
	end
	function Bin:destroy()
		while self.head do
			local item = self.head.item
			if type(item) == "function" then
				item()
			elseif typeof(item) == "RBXScriptConnection" then
				item:Disconnect()
			elseif type(item) == "thread" then
				task.cancel(item)
			elseif item.destroy ~= nil then
				item:destroy()
			elseif item.Destroy ~= nil then
				item:Destroy()
			end
			self.head = self.head.next
		end
	end
	function Bin:isEmpty()
		return self.head == nil
	end
end
--[[
	***********************************************************
	 * MAIN COMPONENTS
	 * Description: Classes for specific entities/objects
	 ***********************************************************
]]
local BaseComponent
do
	BaseComponent = setmetatable({}, {
		__tostring = function()
			return "BaseComponent"
		end,
	})
	BaseComponent.__index = BaseComponent
	function BaseComponent.new(...)
		local self = setmetatable({}, BaseComponent)
		return self:constructor(...) or self
	end
	function BaseComponent:constructor(instance)
		self.instance = instance
		self.bin = Bin.new()
	end
	function BaseComponent:destroy()
		self.bin:destroy()
	end
end
--[[
	***********************************************************
	 * COMPONENTS
	 * Description: Classes for specific entities/objects
	 ***********************************************************
]]
local ThermalComponent
do
	local super = BaseComponent
	ThermalComponent = setmetatable({}, {
		__tostring = function()
			return "ThermalComponent"
		end,
		__index = super,
	})
	ThermalComponent.__index = ThermalComponent
	function ThermalComponent.new(...)
		local self = setmetatable({}, ThermalComponent)
		return self:constructor(...) or self
	end
	function ThermalComponent:constructor(instance)
		super.constructor(self, instance)
		self.lastBeepTime = 0
		local character = instance.Character or (instance.CharacterAdded:Wait())
		if character == nil then
			error("Character not found")
		end
		local humanoid = character:WaitForChild("Humanoid")
		if humanoid == nil then
			error("Humanoid not found")
		end
		self.character = character
		self.humanoid = humanoid
		-- Init
		local bin = self.bin
		self:createHighlight()
		bin:batch(humanoid.Died:Connect(function()
			return self:destroy()
		end), character.Destroying:Connect(function()
			return self:destroy()
		end), instance.CharacterRemoving:Connect(function()
			return self:destroy()
		end), RunService.Heartbeat:Connect(function()
			return self:checkProximity()
		end))
	end
	function ThermalComponent:createHighlight()
		local _binding = self
		local character = _binding.character
		local bin = _binding.bin
		-- Instances:
		local Highlight = Instance.new("Highlight")
		Highlight.Adornee = character
		Highlight.Enabled = Toggle.Value
		Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight.FillColor = Color3.fromRGB(0, 255, 255)
		Highlight.FillTransparency = 0.4
		Highlight.OutlineTransparency = 1
		Highlight.Parent = CoreGui
		-- Initializing:
		bin:batch(Highlight, Toggle.Changed:Connect(function()
			Highlight.Enabled = Toggle.Value
		end))
	end
	function ThermalComponent:playBeepSound()
		local newSound = beepSound:Clone()
		newSound.Parent = self.character.PrimaryPart
		newSound:Play()
		newSound.Ended:Wait()
		newSound:Destroy()
	end
	function ThermalComponent:checkProximity()
		local _localPlayerPosition = LocalPlayer.Character.PrimaryPart
		if _localPlayerPosition ~= nil then
			_localPlayerPosition = _localPlayerPosition.Position
		end
		local localPlayerPosition = _localPlayerPosition
		local _targetPlayerPosition = self.character.PrimaryPart
		if _targetPlayerPosition ~= nil then
			_targetPlayerPosition = _targetPlayerPosition.Position
		end
		local targetPlayerPosition = _targetPlayerPosition
		if localPlayerPosition and targetPlayerPosition then
			local distance = (localPlayerPosition - targetPlayerPosition).Magnitude
			local minDistance = 5
			local maxDistance = 100
			local maxBeepInterval = 1.0
			local minBeepInterval = 0.7
			if distance <= maxDistance then
				local interval = math.clamp(((distance - minDistance) / (maxDistance - minDistance)) * maxBeepInterval, minBeepInterval, maxBeepInterval)
				local currentTime = tick()
				if currentTime - self.lastBeepTime >= interval then
					task.defer(function()
						return self:playBeepSound()
					end)
					self.lastBeepTime = currentTime
				end
			end
		end
	end
end
local ThermalController = {}
do
	local _container = ThermalController
	local thermalVision = Instance.new("ColorCorrectionEffect")
	thermalVision.Saturation = -1
	thermalVision.Brightness = -0.02
	thermalVision.Name = " TVG.7% "
	thermalVision.Parent = Lighting
	--* @hidden 
	local applyHighlight = function(player)
		task.defer(function()
			player.CharacterAdded:Connect(function()
				return ThermalComponent.new(player)
			end)
			if player.Character then
				ThermalComponent.new(player)
			end
		end)
	end
	--* @hidden 
	local onToggle = function()
		thermalVision.Enabled = Toggle.Value
		Thermal_UI.Enabled = Toggle.Value
	end
	local function __init()
		local _exp = Players:GetPlayers()
		-- ▼ ReadonlyArray.forEach ▼
		local _callback = function(instance)
			return instance ~= Players.LocalPlayer and task.spawn(applyHighlight, instance)
		end
		for _k, _v in _exp do
			_callback(_v, _k - 1, _exp)
		end
		-- ▲ ReadonlyArray.forEach ▲
		Players.PlayerAdded:Connect(applyHighlight)
		Toggle.Changed:Connect(onToggle)
		UserInputService.InputBegan:Connect(function(input, process)
			if not process then
				if input.KeyCode == Enum.KeyCode.KeypadMinus then
					Toggle.Value = not Toggle.Value
				end
			end
		end)
	end
	_container.__init = __init
end
ThermalController.__init()
initLib:Notify("Thermal Toggles Loaded! Updated!", 10)
return 0
