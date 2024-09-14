-- Compiled with roblox-ts v2.3.0
-- AFTERMATH INVENTORY VIEWER v1.1
local Inventory_UI = loadstring(request({
	Url = "https://raw.githubusercontent.com/RelkzzRebranded/Aftermath/main/InvViewerOMENUI.lua",
	Method = "GET",
}).Body)()
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Workspace = cloneref(game:GetService("Workspace"))
local Players = cloneref(game:GetService("Players"))
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local InventoryDisplay = {}
do
	local _container = InventoryDisplay
	local toggle
	local item_list = Inventory_UI.Main.Lists
	local getTarget = function()
		local weight = math.huge
		local chosen
		for _, child in Players:GetPlayers() do
			local Character = child.Character
			if Character and child ~= LocalPlayer then
				local WorldCharacter = Character:FindFirstChild("WorldCharacter")
				if WorldCharacter then
					local rootPart = Character:FindFirstChild("HumanoidRootPart")
					if rootPart then
						local part_position, onscreen = CurrentCamera:WorldToViewportPoint(rootPart.Position)
						if onscreen then
							local _vector2 = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
							local _vector2_1 = Vector2.new(part_position.X, part_position.Y)
							local magnitude = (_vector2 - _vector2_1).Magnitude
							if magnitude < weight and magnitude < 500 then
								weight = magnitude
								chosen = child
							end
						end
					end
				end
			end
		end
		return chosen
	end
	local onRender = function()
		local target = getTarget()
		if target and toggle then
			Inventory_UI.Enabled = true
			Inventory_UI.Main.PlayerName.Text = `{target.Name}'s Inventory`
			local gunInventory = target:WaitForChild("GunInventory")
			for _, slotItems in gunInventory:GetChildren() do
				if slotItems.Name ~= "Slot0" and slotItems.Name ~= "Slot50" and slotItems:IsA("ObjectValue") then
					local currentSlot = slotItems
					local itemLists = item_list[slotItems.Name]
					itemLists.Text = `{currentSlot.Slot.Value} -> <font color="rgb(150,150,150)">{if currentSlot.Value then currentSlot.Value else "Empty"}</font> [<font color="rgb(97,41,255)">{if currentSlot.BulletsInMagazine then currentSlot.BulletsInMagazine.Value else "--"}/{if currentSlot.BulletsInReserve then currentSlot.BulletsInReserve.Value else "--"}</font>] [<font color="rgb(97,41,255)">{if currentSlot:FindFirstChild("AttachmentMuzzle") and currentSlot.AttachmentMuzzle.Value ~= nil then currentSlot.AttachmentMuzzle.Value else "--"}/{if currentSlot:FindFirstChild("AttachmentReticle") and currentSlot.AttachmentReticle then currentSlot.AttachmentReticle.Value else "--"}</font>]`
				end
			end
		else
			Inventory_UI.Enabled = false
		end
	end
	local function __init()
		Inventory_UI.Parent = CoreGui
		toggle = false
		UserInputService.InputBegan:Connect(function(input, processedEvent)
			if processedEvent then
				return nil
			end
			if input.KeyCode == Enum.KeyCode.KeypadMinus then
				toggle = not toggle
			end
		end)
		RunService.RenderStepped:Connect(function()
			return onRender()
		end)
	end
	_container.__init = __init
end
InventoryDisplay.__init()
return 0
