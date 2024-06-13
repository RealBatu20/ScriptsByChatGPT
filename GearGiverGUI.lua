-- Define the GearGiver class
local GearGiver = {}
GearGiver.__index = GearGiver

function GearGiver.new()
    local self = setmetatable({}, GearGiver)
    
    -- Create the GUI
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "GearGiverGui"
    self.gui.ResetOnSpawn = false
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    -- Create the draggable frame
    local frame = Instance.new("Frame", self.gui)
    frame.Name = "DraggableFrame"
    frame.Size = UDim2.new(0, 200, 0, 150)
    frame.Position = UDim2.new(0.5, -100, 0.5, -75)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.Active = true
    frame.Draggable = true
    
    -- Create the RichTextBox
    local richTextBox = Instance.new("TextBox", frame)
    richTextBox.Name = "RichTextBox"
    richTextBox.Size = UDim2.new(1, -20, 0.8, -10)
    richTextBox.Position = UDim2.new(0, 10, 0, 10)
    richTextBox.Text = ""
    richTextBox.TextWrapped = true
    richTextBox.TextScaled = true
    richTextBox.ClearTextOnFocus = false
    richTextBox.MultiLine = true
    richTextBox.PlaceholderText = "Paste/type Gear ID here"
    
    -- Create the Give button
    local giveButton = Instance.new("TextButton", frame)
    giveButton.Name = "GiveButton"
    giveButton.Size = UDim2.new(1, -20, 0.2, -10)
    giveButton.Position = UDim2.new(0, 10, 0.8, 5)
    giveButton.Text = "Give"
    giveButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    giveButton.MouseButton1Click:Connect(function()
        local gearId = richTextBox.Text
        if gearId ~= "" then
            local success, asset = pcall(function()
                return game:GetService("InsertService"):LoadAsset(tonumber(gearId))
            end)
            if success and asset then
                asset.Parent = game.Workspace
            else
                warn("Failed to load asset with ID:", gearId)
            end
        else
            warn("Gear ID is empty")
        end
    end)
    
    return self
end

-- Example usage:
local gearGiver = GearGiver.new()
gearGiver.gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
