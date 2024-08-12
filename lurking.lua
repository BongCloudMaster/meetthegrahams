--[[
    
    * Code is now stable, less laggy. Thx to TerminalVibes helping me finding ways for optimization :D
    * I'm not gonna gatekeep/obfuscate this code anymore since you can still do it without OOP.

]]
local Players : Players = cloneref(game:GetService("Players"))
local RunService : RunService = cloneref(game:GetService("RunService"))
local UserInputService : UserInputService = cloneref(game:GetService("UserInputService"))
local ReplicatedStorage : ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Workspace : Workspace = cloneref(game:GetService("Workspace"))
--[[
	* The libraries isnt mine, like Bin
	* It tracks connections, instances, functions, threads, and objects to be later destroyed.
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
		return self
	end
	function Bin:destroy()
		local head = self.head
		while head do
			local _binding = head
			local item = _binding.item
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
			head = head.next
			self.head = head
		end
	end
	function Bin:isEmpty()
		return self.head == nil
	end
end
--[[
    ----------------------
    Variables & References
    ----------------------
]]
local Terrain : Terrain = cloneref(Workspace.Terrain)
local LocalPlayer = Players.LocalPlayer
local SharedLibrary = ReplicatedStorage.EmberSharedLibrary
local GameShared = SharedLibrary.GameShared
local _Items : Folder = GameShared.Item
local world_assets = Workspace:WaitForChild('world_assets')
local static_objects : Folder = world_assets.StaticObjects
local CurrentCamera = Workspace.CurrentCamera
local color_codes = {
    -- Ammunition:
    ['Ammo'] = Color3.new(0.964705, 1, 0.462745),
    -- Wearables:
    ['Backpack'] = Color3.new(0.4, 0.8, 1),
    ['Eyewear'] = Color3.new(0.4, 0.8, 1),
    ['Helmet'] = Color3.new(0.4, 0.8, 1),
    ['Vest'] = Color3.new(0.4, 0.8, 1),
    -- Consumables:
    ['Medical'] = Color3.new(0.6, 1, 0.25),
    ['Usables'] = Color3.new(0.6, 1, 0.25),
    -- Attachments:
    ['Muzzle'] = Color3.new(0.6, 0.2, 1),
    ['Optic'] = Color3.new(0.6, 0.2, 1),
    ['Underbarrel'] = Color3.new(0.6, 0.2, 1),
    -- Weapons:
    ['Primary'] = Color3.new(1, 0.4, 0.4),
    ['Melee'] = Color3.new(1, 0.4, 0.4),
    ['Sidearm'] = Color3.new(1, 0.4, 0.4),
    ['Throwable'] = Color3.new(1, 0.4, 0.4),
}
--[[
    ---------------------
    Component Declaration
    ---------------------
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
	function BaseComponent:constructor(item)
		self.bin = Bin.new()
		self.object = item
	end
	function BaseComponent:destroy()
		self.bin:destroy()
	end
end
local LootableComponent
do
    local super = BaseComponent
    LootableComponent = setmetatable({},{
        __tostring = function()
            return "LootableComponent"
        end,
        __index = super,
    })
    LootableComponent.__index = LootableComponent
    function LootableComponent.new(...)
        local self =  setmetatable({}, LootableComponent)
        return self:constructor(...) or self
    end
    function LootableComponent:constructor(item : Configuration)
        -- Setup:
        super.constructor(self, item)
        self.attributes = item:GetAttributes()
        local instance = item
        -- Interface:
        self.interface = {
            BillboardGui = Instance.new("BillboardGui"),
            container = Instance.new("Frame"),
            data = Instance.new("TextLabel"),
            UITextSizeConstraint = Instance.new("UITextSizeConstraint")
        }
        -- Attachments
        self.points = self:constructPoints()
        -- User Interface:
        self:setUpInterface()
        -- Initialization:
        local bin = self.bin
        local instances = LootableComponent.instances
        local _instance = instance
        local _self = self
        instances[_instance] = _self
        bin:add(function()
            local _instance_1 = instance
            -- Delete v
            local _valueExisted = instances[_instance_1] ~= nil
            instances[_instance_1] = nil
            -- Delete ^
            return _valueExisted
        end)
        instance.AncestryChanged:Connect(function(_, parent)
            return parent == nil and self:destroy()
        end)
    end
    function LootableComponent:constructPoints()
        local attachment = Instance.new("Attachment")
        local _attributes = self.attributes
        local pivotPos = _attributes.CFrame
        attachment.WorldCFrame = pivotPos
        attachment.Parent = Terrain
        return attachment
    end
    function LootableComponent:setUpInterface()
        local _binding = self
        local bin = _binding.bin
        local _attributes = self.attributes
        local instance : Configuration = _binding.object
        local interface = _binding.interface
        local point = self.points
        -- Attributes:
        local _name = instance:GetAttribute('ClassName')
        local amount = instance:GetAttribute('Quantity')
        -- Instances:
        local BillboardGui = interface.BillboardGui
        local container = interface.container
        local data = interface.name
        local UITextSizeConstraint = interface.UITextSizeConstraint
        -- Properties:
        BillboardGui.Size = UDim2.new(8, 0 ,2, 0)
        BillboardGui.ResetOnSpawn = false
        BillboardGui.LightInfluence = 0
        BillboardGui.Brightness = 1.5
        container.Visible = false
        container.AnchorPoint = Vector2.new(0.5, 0)
        container.BackgroundTransparency = 1
        data.BackgroundTransparency = 1
        data.Font = Enum.Font.Nunito
		data.Text = `{_name:gsub('%.item', '')} {amount}x`
		data.TextColor3 = color_codes[_Items:FindFirstChild(instance:GetAttribute('ClassName'), true).Parent.Name] or Color3.new(1, 0.8, 0.3)
		data.TextSize = 16
		data.TextStrokeTransparency = 0.3
		data.Size = UDim2.new(1, 0, 1, 0)
        UITextSizeConstraint.MaxTextSize = data.TextSize
        container.Position = UDim2(0.5, 0, 0, 0)
		container.Size = UDim2.new(1, 0, 1, 0)
        -- Initialization:
        UITextSizeConstraint.Parent = data
        data.Parent = container
        container.Parent = BillboardGui
        BillboardGui.Adornee = point
    end
    function LootableComponent:render()
        -- Variables & References
        local camera = CurrentCamera
        local _binding = self
        local instance : Configuration = _binding.object
        local interface = _binding.interface 
        local BillboardGui = interface.BillboardGui
        local data = interface.data
        -- Properties:
        local pivotPos = instance:GetAttribute('CFrame')
        -- Initialization:
        local positionDiff = pivotPos.Position - camera.CFrame.Position

        if positionDiff.Magnitude <= 500 then
            local _valueExisted = BillboardGui.Visible == false
			BillboardGui.Enabled = true
        else
            local _valueExisted_1 = BillboardGui.Visible == true
            BillboardGui.Enabled = false
        end
    end
    LootableComponent.instances = {}
    LootableComponent.connections = Bin.new()
end
--[[
    ---------------
    Event Listeners
    ---------------
    All the event listeners that are used throughout the code.
]]
LootableComponent.connections:add(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    CurrentCamera = Workspace.CurrentCamera
    return CurrentCamera
end))
LootableComponent.connections:add(static_objects.DescendantAdded:Connect(function(instance)
    if instance:FindFirstChild('Configuration') then
        local configuration = instance.Configuration
        LootableComponent.new(configuration)
    end
end))
LootableComponent.connections:add(RunService.RenderStepped:Connect(function()
    for _, esp in pairs(LootableComponent.instances) do
        esp:render()
    end
end))
for _, v in ipairs(static_objects:GetDescendants()) do
    if v:FindFirstChild('Configuration') then
        local configuration = v.Configuration
        LootableComponent.new(configuration)
    end
end
--[[
	----------------------
	Initiation & Execution
	----------------------
	All the code that is executed on startup is placed here.
]]
return 0
