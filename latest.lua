-- Llucs Hub v1.5 -- Update Date: 16/07/2025

local TweenService = game:GetService("TweenService") local g_players = game:GetService("Players") local g_runservice = game:GetService("RunService") local g_uis = game:GetService("UserInputService") local g_teleport = game:GetService("TeleportService") local g_coregui = game:GetService("CoreGui") local g_virtual = game:GetService("VirtualUser")

local function g_str(len) local c = "" for _ = 1, len do c = c .. string.char(math.random(97, 122)) end return c end

local function safe_pcall(func, ...) local ok, result = pcall(func, ...) if not ok then warn("Llucs Hub: Error -", result) end return ok, result end

local function create_instance(className, props) local inst = Instance.new(className) for prop, val in pairs(props) do safe_pcall(function() inst[prop] = val end) end return inst end

if not game:IsLoaded() then local msg = create_instance("Message", { Parent = g_coregui, Text = "Llucs Hub v1.5 loading game..." }) game.Loaded:Wait() safe_pcall(function() msg:Destroy() end) end

-- Anti-AFK if not _G.llucs_antiafk then _G.llucs_antiafk = true g_players.LocalPlayer.Idled:Connect(function() g_virtual:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) task.wait(1) g_virtual:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) print("Llucs Hub: Anti-AFK triggered 💤") end) end

-- GUI Setup local parent_gui = g_players.LocalPlayer:WaitForChild("PlayerGui") local gui = create_instance("ScreenGui", { Name = g_str(10), ResetOnSpawn = false, Parent = nil })

local frame = create_instance("Frame", { Size = UDim2.new(0, 360, 0, 520), Position = UDim2.new(0.5, -180, 0.5, -260), BackgroundColor3 = Color3.fromRGB(30, 30, 30), BorderSizePixel = 0, Active = true, Draggable = true, Parent = gui, Transparency = 1 })

local tween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0 }) tween:Play()

create_instance("TextLabel", { Text = "Llucs Hub v1.5", Size = UDim2.new(1, -40, 0, 30), BackgroundColor3 = Color3.fromRGB(20, 20, 20), TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.SourceSansBold, TextSize = 20, Parent = frame })

create_instance("TextButton", { Text = "✖", Size = UDim2.new(0, 40, 0, 30), Position = UDim2.new(1, -40, 0, 0), BackgroundColor3 = Color3.fromRGB(180, 0, 0), TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.SourceSansBold, TextSize = 18, Parent = frame, MouseButton1Click = function() gui:Destroy() end })

local cmd_box = create_instance("TextBox", { Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 40), BackgroundColor3 = Color3.fromRGB(40, 40, 40), TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.SourceSans, TextSize = 16, ClearTextOnFocus = false, PlaceholderText = "Type a command...", Parent = frame })

local scroll = create_instance("ScrollingFrame", { Size = UDim2.new(1, -20, 1, -80), Position = UDim2.new(0, 10, 0, 80), BackgroundColor3 = Color3.fromRGB(35, 35, 35), BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 6, Parent = frame })

local cmd_list = create_instance("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = scroll })

-- Player helpers local function get_local_player() return g_players.LocalPlayer end local function get_character(player) return player.Character or player.CharacterAdded:Wait() end local function get_hrp(char) return char and char:FindFirstChild("HumanoidRootPart") end

-- Fly and noclip controls local function teleport(player, pos) local hrp = get_hrp(get_character(player)) if hrp then hrp.CFrame = CFrame.new(pos) end end

local function set_noclip(player, enable) local char = get_character(player) for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = not enable end end end

local fly_on, fly_conn = false, nil local function toggle_fly(player) local char = get_character(player) local hrp = get_hrp(char) local hum = char:FindFirstChildOfClass("Humanoid") if not char or not hrp or not hum then return end

fly_on = not fly_on
hum.PlatformStand = fly_on

if fly_on then
    local bv = create_instance("BodyVelocity", {
        MaxForce = Vector3.new(1e9, 1e9, 1e9),
        Velocity = Vector3.zero,
        Parent = hrp
    })
    fly_conn = g_runservice.RenderStepped:Connect(function()
        local dir = Vector3.zero
        if g_uis:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
        if g_uis:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
        if g_uis:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
        if g_uis:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
        if g_uis:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
        if g_uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end
        bv.Velocity = dir.Magnitude > 0 and dir.Unit * 60 or Vector3.zero
    end)
else
    for _, v in ipairs(hrp:GetChildren()) do
        if v:IsA("BodyVelocity") then v:Destroy() end
    end
    if fly_conn then fly_conn:Disconnect(); fly_conn = nil end
end

end

-- Command system local commands = {} local function register_command(name, func, desc) commands[name:lower()] = func local label = create_instance("TextLabel", { Text = "> " .. name .. " - " .. (desc or "No description"), Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.SourceSans, TextSize = 16, Parent = scroll }) end

register_command("gui", function() if gui.Parent == nil then gui.Parent = parent_gui tween:Play() end end, "Opens the Llucs Hub GUI")

register_command("tp", function(args) local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3]) if x and y and z then teleport(get_local_player(), Vector3.new(x, y, z)) end end, "Teleport to X Y Z")

register_command("noclip", function() set_noclip(get_local_player(), true) end, "Enable noclip") register_command("clip", function() set_noclip(get_local_player(), false) end, "Disable noclip") register_command("fly", function() toggle_fly(get_local_player()) end, "Toggle fly mode") register_command("reset", function() get_local_player().Character:BreakJoints() end, "Reset character") register_command("rejoin", function() g_teleport:TeleportToPlaceInstance(game.PlaceId, game.JobId, get_local_player()) end, "Rejoin current server") register_command("speed", function(args) local val = tonumber(args[1]) if val then local hum = get_character(get_local_player()):FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed = val end end end, "Set walk speed") register_command("jump", function(args) local val = tonumber(args[1]) if val then local hum = get_character(get_local_player()):FindFirstChildOfClass("Humanoid") if hum then hum.JumpPower = val end end end, "Set jump power") register_command("gravity", function(args) local val = tonumber(args[1]) if val then workspace.Gravity = val end end, "Set gravity") register_command("printplayers", function() for _, p in ipairs(g_players:GetPlayers()) do print(p.Name) end end, "Print all player names") register_command("unload", function() gui:Destroy() end, "Unload Llucs Hub") register_command("help", function() print("Available commands:") for name, _ in pairs(commands) do print(" -", name) end end, "List all commands")

-- Executor local function execute_command(txt) local parts = string.split(txt, " ") local name = table.remove(parts, 1):lower() local cmd = commands[name] if cmd then safe_pcall(cmd, parts) else warn("Unknown command:", name) end end

cmd_box.FocusLost:Connect(function(enter) if enter then execute_command(cmd_box.Text) cmd_box.Text = "" end end)

print("Llucs Hub v1.5 fully loaded ✨")

