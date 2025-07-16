-- Llucs Hub v1.3 -- Criado por Llucs com Anti-AFK, novos comandos e melhorias avançadas 🚀

local function g_str(l) local c = "" for i = 1, l do c = c .. string.char(math.random(97, 122)) end return c end

local g_env = getfenv or function() return _G end local g_players = game:GetService("Players") local g_runservice = game:GetService("RunService") local g_uis = game:GetService("UserInputService") local g_teleport = game:GetService("TeleportService") local g_coregui = game:GetService("CoreGui") local g_virtual = game:GetService("VirtualUser")

local function safe_pcall(f, ...) local ok, result = pcall(f, ...) if not ok then warn("Llucs Hub: Erro inesperado") end return ok, result end

local function create_instance(className, props) local inst = Instance.new(className) for prop, val in pairs(props) do inst[prop] = val end return inst end

if not game:IsLoaded() then local msg = create_instance("Message", { Parent = g_coregui, Text = "Llucs Hub aguardando o jogo carregar..." }) game.Loaded:Wait() safe_pcall(function() msg:Destroy() end) end

-- Anti-AFK if not _G.llucs_antiafk then _G.llucs_antiafk = true g_players.LocalPlayer.Idled:Connect(function() g_virtual:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) task.wait(1) g_virtual:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) print("Llucs Hub: Anti-AFK executado 💤") end) end

local parent_gui = g_players.LocalPlayer:WaitForChild("PlayerGui") local gui = Instance.new("ScreenGui") local gui_name = g_str(10)

gui.Name = gui_name

gui.ResetOnSpawn = false

gui.Parent = nil -- invisível até ativar com comando

local frame = create_instance("Frame", { Size = UDim2.new(0, 320, 0, 440), Position = UDim2.new(0.5, -160, 0.5, -220), BackgroundColor3 = Color3.fromRGB(25, 25, 25), BorderSizePixel = 0, Active = true, Draggable = true, Parent = gui })

create_instance("TextLabel", { Text = "Llucs Hub v1.3", Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(15, 15, 15), TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.SourceSansBold, TextSize = 18, Parent = frame })

local cmd_box = create_instance("TextBox", { Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 40), BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.new(1, 1, 1), ClearTextOnFocus = false, PlaceholderText = "Digite um comando...", Parent = frame })

local function get_local_player() return g_players.LocalPlayer end local function get_char(p) return p.Character or p.CharacterAdded:Wait() end local function get_hrp(c) return c:FindFirstChild("HumanoidRootPart") end

local function teleport(p, pos) local c = get_char(p) local hrp = get_hrp(c) if hrp then hrp.CFrame = CFrame.new(pos) end end

local function set_noclip(p, val) local c = get_char(p) for _, part in ipairs(c:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = not val end end end

local fly_on = false local fly_conn = nil

local function toggle_fly(p) local c = get_char(p) local hrp = get_hrp(c) local hum = c:FindFirstChildOfClass("Humanoid") if not hrp or not hum then return end fly_on = not fly_on hum.PlatformStand = fly_on if fly_on then local bv = create_instance("BodyVelocity", { MaxForce = Vector3.new(1e9, 1e9, 1e9), Velocity = Vector3.zero, Parent = hrp }) fly_conn = g_runservice.RenderStepped:Connect(function() local dir = Vector3.zero if g_uis:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end if g_uis:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end if g_uis:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end if g_uis:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end if g_uis:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end if g_uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end bv.Velocity = dir.Unit * 60 end) else for _, v in pairs(hrp:GetChildren()) do if v:IsA("BodyVelocity") then v:Destroy() end end if fly_conn then fly_conn:Disconnect() end end end

-- Comandos principais local function cmd_tp(args) if #args == 3 then teleport(get_local_player(), Vector3.new(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))) end end local function cmd_noclip() set_noclip(get_local_player(), true) end local function cmd_clip() set_noclip(get_local_player(), false) end local function cmd_fly() toggle_fly(get_local_player()) end local function cmd_test() print("Comando funcionando!") end local function cmd_unload() gui:Destroy() end local function cmd_speed(args) local hum = get_char(get_local_player()):FindFirstChildOfClass("Humanoid") if hum and args[1] then hum.WalkSpeed = tonumber(args[1]) end end local function cmd_gravity(args) if args[1] then workspace.Gravity = tonumber(args[1]) end end local function cmd_jump(args) local hum = get_char(get_local_player()):FindFirstChildOfClass("Humanoid") if hum and args[1] then hum.JumpPower = tonumber(args[1]) end end local function cmd_printplayers() for _, p in ipairs(g_players:GetPlayers()) do print(p.Name) end end local function cmd_reset() get_local_player().Character:BreakJoints() end local function cmd_rejoin() g_teleport:TeleportToPlaceInstance(game.PlaceId, game.JobId, get_local_player()) end

local bang_loop = nil local function cmd_bang(args) local target = args[1] if not target then return end local victim = nil for _, p in pairs(g_players:GetPlayers()) do if p.Name:lower():sub(1, #target) == target:lower() then victim = p break end end if victim then if bang_loop then bang_loop:Disconnect() bang_loop = nil print("Parando bang") return end bang_loop = g_runservice.RenderStepped:Connect(function() safe_pcall(function() local me = get_char(get_local_player()) local them = get_hrp(get_char(victim)) local me_hrp = get_hrp(me) if them and me_hrp then me_hrp.CFrame = them.CFrame * CFrame.new(0, 0, 1) end end) end) print("Bang iniciado em", victim.Name) end end

local function cmd_view(args) if args[1] then for _, p in ipairs(g_players:GetPlayers()) do if p.Name:lower():sub(1, #args[1]) == args[1]:lower() then workspace.CurrentCamera.CameraSubject = p.Character:FindFirstChild("Humanoid") print("Visualizando:", p.Name) break end end end end

local commands = { tp = cmd_tp, noclip = cmd_noclip, clip = cmd_clip, fly = cmd_fly, test = cmd_test, unload = cmd_unload, speed = cmd_speed, gravity = cmd_gravity, jump = cmd_jump, printplayers = cmd_printplayers, reset = cmd_reset, rejoin = cmd_rejoin, bang = cmd_bang, view = cmd_view }

local function execute_command(txt) local parts = string.split(txt, " ") local name = table.remove(parts, 1):lower() local cmd = commands[name] if cmd then safe_pcall(cmd, parts) else warn("Comando inválido:", name) end end

cmd_box.FocusLost:Connect(function(enter) if enter then execute_command(cmd_box.Text) cmd_box.Text = "" end end)

-- Ativa GUI com comando local gui_visible = false local function cmd_gui() if not gui_visible then gui.Parent = parent_gui gui_visible = true end end commands["gui"] = cmd_gui

-- Anti-ban: remove scripts suspeitos safe_pcall(function() for _, v in ipairs(game:GetDescendants()) do if v:IsA("LocalScript") and v.Name:lower():find("anti") then v:Destroy() end end game.DescendantAdded:Connect(function(obj) if obj:IsA("LocalScript") and obj.Name:lower():find("ban") then obj:Destroy() end end) end)

print("Llucs Hub v1.3 carregado com sucesso! ✨")

