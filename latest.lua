-- Llucs Hub v1.7 -- Updated on: 17/07/2025

-- Services local TweenService = game:GetService("TweenService") local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UIS = game:GetService("UserInputService") local CoreGui = game:GetService("CoreGui")

-- Variables local LocalPlayer = Players.LocalPlayer local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart") local GUI_Minimized = false local AutoMinimize = true local Theme = "Dark" local Commands = {}

-- GUI local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = "LlucsHub" ScreenGui.Parent = CoreGui ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame") MainFrame.Name = "MainFrame" MainFrame.Size = UDim2.new(0, 400, 0, 300) MainFrame.Position = UDim2.new(1, -420, 1, -300) MainFrame.AnchorPoint = Vector2.new(1, 1) MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) MainFrame.BorderSizePixel = 0 MainFrame.ClipsDescendants = true MainFrame.Parent = ScreenGui MainFrame.BackgroundTransparency = 0.05 MainFrame.Visible = true MainFrame.Active = true MainFrame.Draggable = true MainFrame.AutomaticSize = Enum.AutomaticSize.Y MainFrame.UICorner = Instance.new("UICorner", MainFrame) MainFrame.UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel") Title.Size = UDim2.new(1, 0, 0, 30) Title.BackgroundTransparency = 1 Title.Text = "Llucs Hub v1.7" Title.TextSize = 20 Title.TextColor3 = Color3.fromRGB(255, 255, 255) Title.Font = Enum.Font.GothamBold Title.Parent = MainFrame

-- Buttons local CloseButton = Instance.new("TextButton") CloseButton.Size = UDim2.new(0, 30, 0, 30) CloseButton.Position = UDim2.new(1, -30, 0, 0) CloseButton.Text = "X" CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100) CloseButton.BackgroundTransparency = 1 CloseButton.Font = Enum.Font.GothamBold CloseButton.TextSize = 18 CloseButton.Parent = MainFrame CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MinimizeButton = Instance.new("TextButton") MinimizeButton.Size = UDim2.new(0, 30, 0, 30) MinimizeButton.Position = UDim2.new(1, -60, 0, 0) MinimizeButton.Text = "-" MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255) MinimizeButton.BackgroundTransparency = 1 MinimizeButton.Font = Enum.Font.GothamBold MinimizeButton.TextSize = 18 MinimizeButton.Parent = MainFrame MinimizeButton.MouseButton1Click:Connect(function() GUI_Minimized = not GUI_Minimized local goal = {Size = GUI_Minimized and UDim2.new(0, 400, 0, 30) or UDim2.new(0, 400, 0, 300)} TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), goal):Play() end)

local SettingsButton = Instance.new("TextButton") SettingsButton.Size = UDim2.new(0, 30, 0, 30) SettingsButton.Position = UDim2.new(0, 0, 0, 0) SettingsButton.Text = "⚙" SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255) SettingsButton.BackgroundTransparency = 1 SettingsButton.Font = Enum.Font.GothamBold SettingsButton.TextSize = 18 SettingsButton.Parent = MainFrame

local SettingsFrame = Instance.new("Frame") SettingsFrame.Size = UDim2.new(1, -10, 0, 80) SettingsFrame.Position = UDim2.new(0, 5, 0, 40) SettingsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) SettingsFrame.Visible = false SettingsFrame.Parent = MainFrame SettingsFrame.UICorner = Instance.new("UICorner", SettingsFrame) SettingsFrame.UICorner.CornerRadius = UDim.new(0, 10)

local ThemeToggle = Instance.new("TextButton") ThemeToggle.Size = UDim2.new(1, -10, 0, 30) ThemeToggle.Position = UDim2.new(0, 5, 0, 5) ThemeToggle.Text = "Toggle Theme" ThemeToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60) ThemeToggle.TextColor3 = Color3.fromRGB(255, 255, 255) ThemeToggle.Font = Enum.Font.Gotham ThemeToggle.TextSize = 16 ThemeToggle.Parent = SettingsFrame ThemeToggle.UICorner = Instance.new("UICorner", ThemeToggle) ThemeToggle.UICorner.CornerRadius = UDim.new(0, 8) ThemeToggle.MouseButton1Click:Connect(function() Theme = (Theme == "Dark") and "Light" or "Dark" MainFrame.BackgroundColor3 = (Theme == "Dark") and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(220, 220, 220) end)

local AutoCloseToggle = Instance.new("TextButton") AutoCloseToggle.Size = UDim2.new(1, -10, 0, 30) AutoCloseToggle.Position = UDim2.new(0, 5, 0, 40) AutoCloseToggle.Text = "Toggle Auto-Close" AutoCloseToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60) AutoCloseToggle.TextColor3 = Color3.fromRGB(255, 255, 255) AutoCloseToggle.Font = Enum.Font.Gotham AutoCloseToggle.TextSize = 16 AutoCloseToggle.Parent = SettingsFrame AutoCloseToggle.UICorner = Instance.new("UICorner", AutoCloseToggle) AutoCloseToggle.UICorner.CornerRadius = UDim.new(0, 8) AutoCloseToggle.MouseButton1Click:Connect(function() AutoMinimize = not AutoMinimize end)

SettingsButton.MouseButton1Click:Connect(function() SettingsFrame.Visible = not SettingsFrame.Visible end)

Title.MouseButton1Click:Connect(function() if GUI_Minimized then GUI_Minimized = false TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 300)}):Play() end end)

-- Command input local CommandBox = Instance.new("TextBox") CommandBox.Size = UDim2.new(1, -20, 0, 30) CommandBox.Position = UDim2.new(0, 10, 0, 140) CommandBox.PlaceholderText = "Enter command..." CommandBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50) CommandBox.TextColor3 = Color3.fromRGB(255, 255, 255) CommandBox.Font = Enum.Font.Gotham CommandBox.TextSize = 16 CommandBox.Parent = MainFrame CommandBox.UICorner = Instance.new("UICorner", CommandBox) CommandBox.UICorner.CornerRadius = UDim.new(0, 8)

-- Command list display local CommandList = Instance.new("TextLabel") CommandList.Size = UDim2.new(1, -20, 0, 100) CommandList.Position = UDim2.new(0, 10, 0, 180) CommandList.Text = "fly\njumpboost\nnoclip\nspeed\ntp" CommandList.TextWrapped = true CommandList.TextYAlignment = Enum.TextYAlignment.Top CommandList.TextColor3 = Color3.fromRGB(200, 200, 200) CommandList.BackgroundTransparency = 1 CommandList.Font = Enum.Font.Code CommandList.TextSize = 14 CommandList.Parent = MainFrame

-- Commands Commands.fly = function() local flying = true local speed = 50 local bodyGyro = Instance.new("BodyGyro") local bodyVelocity = Instance.new("BodyVelocity")

bodyGyro.P = 9e4
bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
bodyGyro.CFrame = HumanoidRootPart.CFrame
bodyGyro.Parent = HumanoidRootPart

bodyVelocity.Velocity = Vector3.new(0, 0, 0)
bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
bodyVelocity.Parent = HumanoidRootPart

RunService.RenderStepped:Connect(function()
    if flying then
        local direction = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + HumanoidRootPart.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction - HumanoidRootPart.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction - HumanoidRootPart.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + HumanoidRootPart.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then direction = direction + HumanoidRootPart.CFrame.UpVector end
        bodyVelocity.Velocity = direction.Unit * speed
    end
end)

end

Commands.jumpboost = function() local humanoid = Character:FindFirstChildOfClass("Humanoid") if humanoid then humanoid.JumpPower = 150 end end

-- More commands can be added here...

CommandBox.FocusLost:Connect(function(enterPressed) if enterPressed then local input = CommandBox.Text:lower() CommandBox.Text = "" if Commands[input] then Commandsinput end end end)

-- Auto minimize spawn(function() while true do task.wait(10) if AutoMinimize and not GUI_Minimized then GUI_Minimized = true TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 30)}):Play() end end end)

