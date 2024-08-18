-- Compiled with roblox-ts v2.3.0
--[[
	************************************************************
	 * These UTILITIES arent mine they are from TerminalVibes
	 ************************************************************
]]
local CoreGui = cloneref(game:GetService("CoreGui"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Workspace = cloneref(game:GetService("Workspace"))
local Terrain = cloneref(Workspace.Terrain)
--[[
	***********************************************************
	 * VARIABLES
	 * Description: Variables referenced globally in the script
	 ***********************************************************
]]
local world_Assets = Workspace:WaitForChild("world_assets")
local static_Objects = world_Assets:WaitForChild("StaticObjects")
local sharedLibrary = ReplicatedStorage:WaitForChild("EmberSharedLibrary")
local gameShared = sharedLibrary:WaitForChild("GameShared")
local Items = gameShared:WaitForChild("Item")
-- eslint-disable-next-line prettier/prettier
local item_colors = {
	Ammo = Color3.new(0.964705, 1, 0.462745),
	Backpack = Color3.new(0.4, 0.8, 1),
	Eyewear = Color3.new(0.4, 0.8, 1),
	Helmet = Color3.new(0.4, 0.8, 1),
	Vest = Color3.new(0.4, 0.8, 1),
	Medical = Color3.new(0.6, 1, 0.25),
	Usables = Color3.new(0.6, 1, 0.25),
	Muzzle = Color3.new(0.6, 0.2, 1),
	Optic = Color3.new(0.6, 0.2, 1),
	Underbarrel = Color3.new(0.6, 0.2, 1),
	Primary = Color3.new(1, 0.4, 0.4),
	Melee = Color3.new(1, 0.4, 0.4),
	Sidearm = Color3.new(1, 0.4, 0.4),
	Throwable = Color3.new(1, 0.4, 0.4),
}
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
local LootComponent
do
	local super = BaseComponent
	LootComponent = setmetatable({}, {
		__tostring = function()
			return "LootComponent"
		end,
		__index = super,
	})
	LootComponent.__index = LootComponent
	function LootComponent.new(...)
		local self = setmetatable({}, LootComponent)
		return self:constructor(...) or self
	end
	function LootComponent:constructor(configuration)
		super.constructor(self, configuration)
		self.data = configuration:GetAttributes()
		self.attachment = self:attachmentPoints()
		-- Initialize:
		self:createVisual()
		configuration.AncestryChanged:Connect(function(_, parent)
			return parent == nil and self:destroy()
		end)
	end
	function LootComponent:attachmentPoints()
		local _binding = self
		local data = _binding.data
		local bin = _binding.bin
		local instance = _binding.instance
		local Attachment = Instance.new("Attachment")
		-- really funny on how typescript handles if statements
		-- (speaking from a dude who has experience in luau)
		if data.CFrame ~= nil then
			Attachment.WorldCFrame = data.CFrame
		end
		if data.ItemId ~= nil then
			Attachment.Name = data.ItemId
		end
		Attachment.Parent = Terrain
		bin:add(Attachment)
		return Attachment
	end
	function LootComponent:createVisual()
		local _binding = self
		local data = _binding.data
		local attachment = _binding.attachment
		local bin = _binding.bin
		local _result
		if data.ClassName ~= nil then
			local _result_1 = Items:FindFirstChild(data.ClassName, true)
			if _result_1 ~= nil then
				_result_1 = _result_1.Parent
			end
			_result = _result_1
		else
			_result = nil
		end
		local _Item = _result
		-- Instances:
		local BillboardGui = Instance.new("BillboardGui")
		local TextLabel = Instance.new("TextLabel")
		-- Properties:
		BillboardGui.Adornee = attachment
		BillboardGui.AlwaysOnTop = true
		BillboardGui.ResetOnSpawn = false
		BillboardGui.Size = UDim2.new(0, 100, 0, 100)
		BillboardGui.MaxDistance = 500
		BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		TextLabel.BackgroundTransparency = 1
		TextLabel.Font = Enum.Font.Nunito
		TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextLabel.Size = UDim2.new(1, 0, 0, 12)
		local _result_1 = data.ClassName
		if _result_1 ~= nil then
			_result_1 = string.gsub(_result_1, ".item", "")
		end
		TextLabel.Text = `[{_result_1}] ({data.Quantity}x)`
		--if (_Item !== undefined) {
		local _result_2 = _Item
		if _result_2 ~= nil then
			_result_2 = _result_2.Name
		end
		local _condition = _result_2
		if _condition == nil then
			_condition = "Default"
		end
		local _condition_1 = item_colors[_condition]
		if _condition_1 == nil then
			_condition_1 = Color3.new(0.5, 0.5, 0)
		end
		TextLabel.TextColor3 = _condition_1
		--} else {
		--TextLabel.TextColor3 = new Color3(0.5, 0.5, 0);
		--}
		TextLabel.TextSize = 12
		TextLabel.TextStrokeTransparency = 0.3
		-- Initialize:
		TextLabel.Parent = BillboardGui
		BillboardGui.Parent = CoreGui
		bin:add(BillboardGui)
	end
end
--[[
	***********************************************************
	 * CONTROLLERS
	 * Description: Singletons that are used once
	 ***********************************************************
]]
local LootController = {}
do
	local _container = LootController
	local onLoot = function(configuration)
		if configuration:IsA("Configuration") then
			LootComponent.new(configuration)
		end
	end
	local function __init()
		for _, child in static_Objects:GetDescendants() do
			task.spawn(onLoot, child)
		end
		static_Objects.DescendantAdded:Connect(function(descendant)
			if descendant:IsA("Configuration") then
				onLoot(descendant)
			end
		end)
	end
	_container.__init = __init
end
--[[
	***********************************************************
	 * INITIALIZATION
	 * Description: Initializes and starts the runtime
	 ***********************************************************
]]
LootController.__init()
return "Initialized Succesfully"
