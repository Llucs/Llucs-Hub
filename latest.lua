-- Llucs Hub v1.5 -- Update Date: 16/07/2025

-- Services
local TweenService    = game:GetService("TweenService")
local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UserInput       = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local CoreGui         = game:GetService("CoreGui")
local VirtualUser     = game:GetService("VirtualUser")

-- Utilities
local function randomString(length)
    local result = ""
    for _ = 1, length do
        result = result .. string.char(math.random(97, 122))
    end
    return result
end

local function safePcall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("Llucs Hub Error:", err)
    end
    return ok, err
end

local function createInstance(className, props)
    local instance = Instance.new(className)
    for property, value in pairs(props) do
        safePcall(function()
            instance[property] = value
        end)
    end
    return instance
end

-- Wait for game load
if not game:IsLoaded() then
    local loadingMsg = createInstance("Message", {
        Parent = CoreGui,
        Text   = "Llucs Hub v1.5 loading..."
    })
    game.Loaded:Wait()
    safePcall(function() loadingMsg:Destroy() end)
end

-- Anti-AFK
if not _G.llucsAntiAfk then
    _G.llucsAntiAfk = true
    Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
        print("Llucs Hub: Anti-AFK triggered")
    end)
end

-- GUI Setup
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = createInstance("ScreenGui", {
    Name         = randomString(10),
    ResetOnSpawn = false,
    Parent       = playerGui
})

local frame = createInstance("Frame", {
    Size              = UDim2.new(0, 360, 0, 520),
    Position          = UDim2.new(1, -380, 1, -600),
    BackgroundColor3  = Color3.fromRGB(30, 30, 30), -- Default: Dark mode
    BorderSizePixel   = 0,
    Active            = true,
    Draggable         = true,
    Parent            = screenGui
})

createInstance("UICorner", {
    CornerRadius = UDim.new(0, 8),
    Parent       = frame
})

-- Title
local titleLabel = createInstance("TextLabel", {
    Name              = "TitleLabel",
    Text              = "Llucs Hub v1.5",
    Size              = UDim2.new(1, -120, 0, 30),
    BackgroundColor3  = Color3.fromRGB(20, 20, 20),
    Font              = Enum.Font.SourceSansBold,
    TextSize          = 20,
    TextColor3        = Color3.new(1, 1, 1),
    Parent            = frame
})
titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        frame.Size = UDim2.new(0, 360, 0, 520)
    end
end)

-- Command Input Box
local commandBox = createInstance("TextBox", {
    Name              = "CommandBox",
    Size              = UDim2.new(1, -20, 0, 30),
    Position          = UDim2.new(0, 10, 0, 35),
    Text              = "Type command here...",
    BackgroundColor3  = Color3.fromRGB(50, 50, 50),
    TextColor3        = Color3.new(1, 1, 1),
    Font              = Enum.Font.SourceSans,
    TextSize          = 16,
    ClearTextOnFocus  = true,
    Parent            = frame
})

-- Command List Display
local commandList = createInstance("TextLabel", {
    Size               = UDim2.new(1, -20, 0, 120),
    Position           = UDim2.new(0, 10, 0, 70),
    BackgroundTransparency = 1,
    TextColor3         = Color3.new(1, 1, 1),
    TextSize           = 14,
    Font               = Enum.Font.SourceSans,
    TextXAlignment     = Enum.TextXAlignment.Left,
    TextYAlignment     = Enum.TextYAlignment.Top,
    TextWrapped        = true,
    Text               = "Available commands:\nfly - Fly\nunfly - Stop flying\nspeed <number> - Set speed\njump <number> - Set jump power\nnoclip - Pass through walls\nreset - Reset character\nsit - Sit\ninvisible - Make character invisible",
    Parent             = frame
})

-- Output label
local outputLabel = createInstance("TextLabel", {
    Size               = UDim2.new(1, -20, 0, 25),
    Position           = UDim2.new(0, 10, 1, -30),
    BackgroundTransparency = 1,
    Text               = "",
    TextColor3         = Color3.new(1, 1, 1),
    TextSize           = 16,
    Font               = Enum.Font.SourceSans,
    Parent             = frame
})

-- Main Command Handler
local function executeCommand(cmd)
    local args = string.split(string.lower(cmd), " ")
    local plr = Players.LocalPlayer
    local char = plr and plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not (plr and char and hum) then
        outputLabel.Text = "[Llucs Hub] Player or character not ready"
        return
    end

    if args[1] == "fly" then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bp = Instance.new("BodyPosition")
            bp.Name = "FlyBP"
            bp.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bp.Position = hrp.Position + Vector3.new(0, 5, 0)
            bp.Parent = hrp

            RunService.RenderStepped:Connect(function()
                if bp and hrp then
                    bp.Position = hrp.Position + Vector3.new(0, 5, 0)
                end
            end)
            outputLabel.Text = "[Llucs Hub] Fly enabled"
        end

    elseif args[1] == "unfly" then
        local bp = char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("FlyBP")
        if bp then bp:Destroy() end
        outputLabel.Text = "[Llucs Hub] Fly disabled"

    elseif args[1] == "speed" and tonumber(args[2]) then
        hum.WalkSpeed = tonumber(args[2])
        outputLabel.Text = "[Llucs Hub] Speed set to " .. args[2]

    elseif args[1] == "jump" and tonumber(args[2]) then
        hum.JumpPower = tonumber(args[2])
        outputLabel.Text = "[Llucs Hub] JumpPower set to " .. args[2]

    elseif args[1] == "noclip" then
        RunService.Stepped:Connect(function()
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
        outputLabel.Text = "[Llucs Hub] Noclip enabled"

    elseif args[1] == "reset" then
        plr:LoadCharacter()
        outputLabel.Text = "[Llucs Hub] Character reset"

    elseif args[1] == "sit" then
        hum.Sit = true
        outputLabel.Text = "[Llucs Hub] Sitting"

    elseif args[1] == "invisible" then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Transparency = 1
            elseif v:IsA("Decal") then
                v.Transparency = 1
            end
        end
        outputLabel.Text = "[Llucs Hub] You are now invisible"

    else
        outputLabel.Text = "[Llucs Hub] Unknown command: " .. cmd
    end
end

-- Safe binding to FocusLost
if commandBox then
    commandBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and commandBox.Text ~= "" then
            executeCommand(commandBox.Text)
        end
    end)
end