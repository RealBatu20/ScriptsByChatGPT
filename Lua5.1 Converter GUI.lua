-- Script for Lua5.1 Converter GUI

-- Load Lua5.1 API
local httpService = game:GetService("HttpService")
local success, lua51API = pcall(function()
    return httpService:GetAsync("https://raw.githubusercontent.com/RealBatu20/lua-compat-5.3/master/compat53/module.lua")
end)

-- Check if API loaded successfully
if not success then
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "Failed to load Lua5.1 API. Converter GUI cannot function.";
        Duration = 10;
    })
    return
end

-- Create Lua5.1 Converter GUI
local GuiEnabled = false

local function CreateConverterGui()
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.Visible = false
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    -- Input TextBox
    local InputTextBox = Instance.new("TextBox")
    InputTextBox.Size = UDim2.new(0.95, 0, 0.45, 0)
    InputTextBox.Position = UDim2.new(0.025, 0, 0.025, 0)
    InputTextBox.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    InputTextBox.BorderSizePixel = 1
    InputTextBox.BorderColor3 = Color3.fromRGB(150, 150, 150)
    InputTextBox.TextWrapped = true
    InputTextBox.Font = Enum.Font.SourceSans
    InputTextBox.TextSize = 18
    InputTextBox.PlaceholderText = "Paste Lua script here"
    InputTextBox.ClearTextOnFocus = false
    InputTextBox.MultiLine = true
    InputTextBox.TextXAlignment = Enum.TextXAlignment.Left
    InputTextBox.TextYAlignment = Enum.TextYAlignment.Top
    InputTextBox.TextEditable = true
    InputTextBox.TextSelectable = true
    InputTextBox.Parent = MainFrame

    -- Output TextBox
    local OutputTextBox = Instance.new("TextBox")
    OutputTextBox.Size = UDim2.new(0.95, 0, 0.45, 0)
    OutputTextBox.Position = UDim2.new(0.025, 0, 0.525, 0)
    OutputTextBox.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    OutputTextBox.BorderSizePixel = 1
    OutputTextBox.BorderColor3 = Color3.fromRGB(150, 150, 150)
    OutputTextBox.TextWrapped = true
    OutputTextBox.Font = Enum.Font.SourceSans
    OutputTextBox.TextSize = 18
    OutputTextBox.PlaceholderText = "Converted Lua5.1 script"
    OutputTextBox.ClearTextOnFocus = false
    OutputTextBox.MultiLine = true
    OutputTextBox.TextXAlignment = Enum.TextXAlignment.Left
    OutputTextBox.TextYAlignment = Enum.TextYAlignment.Top
    OutputTextBox.TextEditable = false
    OutputTextBox.TextSelectable = true
    OutputTextBox.Parent = MainFrame

    -- Convert Button
    local ConvertButton = Instance.new("TextButton")
    ConvertButton.Size = UDim2.new(0.4, 0, 0.1, 0)
    ConvertButton.Position = UDim2.new(0.3, 0, 0.475, 0)
    ConvertButton.BackgroundColor3 = Color3.fromRGB(50, 120, 180)
    ConvertButton.BorderSizePixel = 0
    ConvertButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ConvertButton.Font = Enum.Font.SourceSans
    ConvertButton.TextSize = 18
    ConvertButton.Text = "Convert"
    ConvertButton.Parent = MainFrame

    -- Open/Close Button (outside the MainFrame)
    local OpenCloseButton = Instance.new("TextButton")
    OpenCloseButton.Size = UDim2.new(0.1, 0, 0.05, 0)
    OpenCloseButton.Position = UDim2.new(0.5, -150, 0.5, 100)
    OpenCloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
    OpenCloseButton.BackgroundColor3 = Color3.fromRGB(50, 120, 180)
    OpenCloseButton.BorderSizePixel = 0
    OpenCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenCloseButton.Font = Enum.Font.SourceSans
    OpenCloseButton.TextSize = 14
    OpenCloseButton.Text = "Open Converter"
    OpenCloseButton.Parent = ScreenGui

    -- Convert function
    local function ConvertLuaToLua51(luaScript)
        local lua51Function, err = load(luaScript, "Lua5.1 Converter", "t", _ENV)
        if not lua51Function then
            game.StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "Error in Lua script conversion: " .. tostring(err),
                Duration = 10
            })
            return ""
        end
        setfenv(lua51Function, setmetatable({}, {__index = lua51API}))
        local success, convertedScript = pcall(lua51Function)
        if not success then
            game.StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "Error in Lua script conversion: " .. tostring(convertedScript),
                Duration = 10
            })
            return ""
        end
        return convertedScript or ""
    end

    -- Convert Button functionality
    ConvertButton.MouseButton1Click:Connect(function()
        local inputScript = InputTextBox.Text
        local convertedScript = ConvertLuaToLua51(inputScript)
        OutputTextBox.Text = convertedScript
    end)

    -- Open/Close Button functionality
    OpenCloseButton.MouseButton1Click:Connect(function()
        GuiEnabled = not GuiEnabled
        MainFrame.Visible = GuiEnabled
        if GuiEnabled then
            OpenCloseButton.Text = "Close Converter"
        else
            OpenCloseButton.Text = "Open Converter"
        end
    end)
end

-- Create the converter GUI initially
CreateConverterGui()
