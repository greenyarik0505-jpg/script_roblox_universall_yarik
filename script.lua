local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("HumanoidRootPart")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local HRP = RootPart
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

Player.CharacterAdded:Connect(function(c)
	Character = c
	Humanoid = c:WaitForChild("Humanoid")
	RootPart = c:WaitForChild("HumanoidRootPart")
	HRP = RootPart
end)

local Configs = {
	Default = {
		theme = Color3.fromRGB(0, 255, 127),
		bg = Color3.fromRGB(12, 12, 18),
		transparency = 0.08,
		name = "Default"
	},
	Midnight = {
		theme = Color3.fromRGB(138, 43, 226),
		bg = Color3.fromRGB(8, 8, 16),
		transparency = 0.05,
		name = "Midnight"
	},
	Ocean = {
		theme = Color3.fromRGB(0, 191, 255),
		bg = Color3.fromRGB(5, 15, 25),
		transparency = 0.1,
		name = "Ocean"
	},
	Sunset = {
		theme = Color3.fromRGB(255, 100, 50),
		bg = Color3.fromRGB(20, 10, 8),
		transparency = 0.08,
		name = "Sunset"
	},
	Rose = {
		theme = Color3.fromRGB(255, 50, 120),
		bg = Color3.fromRGB(18, 8, 14),
		transparency = 0.08,
		name = "Rose"
	}
}

local CurrentConfig = Configs.Default
local ActiveTheme = CurrentConfig.theme
local ActiveBG = CurrentConfig.bg
local ActiveTransparency = CurrentConfig.transparency

local State = {
	menuOpen = false,
	flyEnabled = false,
	noclipEnabled = false,
	infJumpEnabled = false,
	doubleJumpEnabled = false,
	espEnabled = false,
	fullbrightEnabled = false,
	rainbowEnabled = false,
	walkSpeed = 16,
	jumpPower = 50,
	flySpeed = 50,
	flyUp = false,
	flyDown = false,
	jumped = false,
	canDoubleJump = false,
	settingsOpen = false,
	flyWidgetOpen = true
}

local BodyVel, BodyGyro
local espObjects = {}
local rainbowConn, fullbrightConn, noclipConn, flyConn, espConn

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YarikWorldHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 99999
ScreenGui.IgnoreGuiInset = true

local ok = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ok then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local function makeShadow(parent, size)
	local s = Instance.new("ImageLabel")
	s.Name = "Shadow"
	s.BackgroundTransparency = 1
	s.Image = "rbxassetid://6014261993"
	s.ImageColor3 = Color3.fromRGB(0,0,0)
	s.ImageTransparency = 0.5
	s.Position = UDim2.new(0,-15,0,-15)
	s.Size = UDim2.new(1,30,1,30)
	s.SliceCenter = Rect.new(49,49,450,450)
	s.ScaleType = Enum.ScaleType.Slice
	s.ZIndex = parent.ZIndex - 1
	s.Parent = parent
	return s
end

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 12)
	c.Parent = parent
	return c
end

local function makeStroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or ActiveTheme
	s.Thickness = thickness or 1.5
	s.Transparency = transparency or 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

local function makeGradient(parent, c0, c1, rotation)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(c0 or ActiveBG, c1 or Color3.fromRGB(20,20,30))
	g.Rotation = rotation or 135
	g.Parent = parent
	return g
end

local function notify(text, color)
	local nf = Instance.new("Frame")
	nf.Size = UDim2.new(0, 280, 0, 50)
	nf.Position = UDim2.new(1, -300, 1, 60)
	nf.BackgroundColor3 = Color3.fromRGB(12,12,18)
	nf.BorderSizePixel = 0
	nf.ZIndex = 200
	nf.Parent = ScreenGui
	makeCorner(nf, 10)
	makeStroke(nf, color or ActiveTheme, 1.5)
	makeGradient(nf, Color3.fromRGB(15,15,22), Color3.fromRGB(10,10,16))

	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0,40,1,0)
	icon.Position = UDim2.new(0,0,0,0)
	icon.BackgroundTransparency = 1
	icon.Text = "✦"
	icon.TextColor3 = color or ActiveTheme
	icon.TextScaled = true
	icon.Font = Enum.Font.GothamBold
	icon.ZIndex = 201
	icon.Parent = nf

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1,-50,1,0)
	lbl.Position = UDim2.new(0,45,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(220,220,220)
	lbl.TextScaled = true
	lbl.Font = Enum.Font.Gotham
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 201
	lbl.Parent = nf

	TweenService:Create(nf, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(1,-300,1,-70)
	}):Play()
	task.delay(2.5, function()
		TweenService:Create(nf, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(1,-300,1,60)
		}):Play()
		task.delay(0.35, function() nf:Destroy() end)
	end)
end

-- MAIN MENU FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 440)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -220)
MainFrame.BackgroundColor3 = ActiveBG
MainFrame.BackgroundTransparency = ActiveTransparency
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ZIndex = 10
MainFrame.Active = true
MainFrame.Parent = ScreenGui
makeCorner(MainFrame, 16)
makeStroke(MainFrame, ActiveTheme, 1.5)
makeGradient(MainFrame, Color3.fromRGB(12,12,20), Color3.fromRGB(8,8,14))

-- TITLEBAR
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1,0,0,48)
TitleBar.Position = UDim2.new(0,0,0,0)
TitleBar.BackgroundColor3 = Color3.fromRGB(8,8,14)
TitleBar.BackgroundTransparency = 0
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 11
TitleBar.Active = true
TitleBar.Parent = MainFrame
makeCorner(TitleBar, 16)

local TitleBarBottom = Instance.new("Frame")
TitleBarBottom.Size = UDim2.new(1,0,0.5,0)
TitleBarBottom.Position = UDim2.new(0,0,0.5,0)
TitleBarBottom.BackgroundColor3 = Color3.fromRGB(8,8,14)
TitleBarBottom.BackgroundTransparency = 0
TitleBarBottom.BorderSizePixel = 0
TitleBarBottom.ZIndex = 11
TitleBarBottom.Parent = TitleBar

local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(15,15,25)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,14))
})
TitleGrad.Rotation = 90
TitleGrad.Parent = TitleBar

local TitleDot = Instance.new("Frame")
TitleDot.Size = UDim2.new(0,4,0,28)
TitleDot.Position = UDim2.new(0,16,0.5,-14)
TitleDot.BackgroundColor3 = ActiveTheme
TitleDot.BorderSizePixel = 0
TitleDot.ZIndex = 12
TitleDot.Parent = TitleBar
makeCorner(TitleDot, 4)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0,300,1,0)
TitleLabel.Position = UDim2.new(0,30,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Yarik World Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 12
TitleLabel.Parent = TitleBar

local SubLabel = Instance.new("TextLabel")
SubLabel.Size = UDim2.new(0,300,1,0)
SubLabel.Position = UDim2.new(0,30,0.45,0)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "v1.0 Universal"
SubLabel.TextColor3 = ActiveTheme
SubLabel.TextSize = 11
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.ZIndex = 12
SubLabel.Parent = TitleBar

-- SETTINGS BUTTON
local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Size = UDim2.new(0,34,0,34)
SettingsBtn.Position = UDim2.new(1,-84,0.5,-17)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(20,20,30)
SettingsBtn.Text = "⚙"
SettingsBtn.TextColor3 = Color3.fromRGB(180,180,180)
SettingsBtn.TextSize = 16
SettingsBtn.Font = Enum.Font.GothamBold
SettingsBtn.BorderSizePixel = 0
SettingsBtn.ZIndex = 12
SettingsBtn.Parent = TitleBar
makeCorner(SettingsBtn, 8)
makeStroke(SettingsBtn, Color3.fromRGB(40,40,60), 1)

-- MINIMIZE BUTTON
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,34,0,34)
MinBtn.Position = UDim2.new(1,-46,0.5,-17)
MinBtn.BackgroundColor3 = Color3.fromRGB(20,20,30)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(180,180,180)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.ZIndex = 12
MinBtn.Parent = TitleBar
makeCorner(MinBtn, 8)
makeStroke(MinBtn, Color3.fromRGB(40,40,60), 1)

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,34,0,34)
CloseBtn.Position = UDim2.new(1,-8,0.5,-17)
CloseBtn.BackgroundColor3 = Color3.fromRGB(20,20,30)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255,80,80)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 12
CloseBtn.Parent = TitleBar
makeCorner(CloseBtn, 8)
makeStroke(CloseBtn, Color3.fromRGB(80,30,30), 1)

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 140, 1, -48)
Sidebar.Position = UDim2.new(0, 0, 0, 48)
Sidebar.BackgroundColor3 = Color3.fromRGB(8,8,14)
Sidebar.BackgroundTransparency = 0
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 11
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0,16)
SidebarCorner.Parent = Sidebar

local SidebarFix = Instance.new("Frame")
SidebarFix.Size = UDim2.new(1,0,0.5,0)
SidebarFix.Position = UDim2.new(0,0,0,0)
SidebarFix.BackgroundColor3 = Color3.fromRGB(8,8,14)
SidebarFix.BackgroundTransparency = 0
SidebarFix.BorderSizePixel = 0
SidebarFix.ZIndex = 11
SidebarFix.Parent = Sidebar

local SidebarRight = Instance.new("Frame")
SidebarRight.Size = UDim2.new(0,16,1,0)
SidebarRight.Position = UDim2.new(1,-16,0,0)
SidebarRight.BackgroundColor3 = Color3.fromRGB(8,8,14)
SidebarRight.BackgroundTransparency = 0
SidebarRight.BorderSizePixel = 0
SidebarRight.ZIndex = 11
SidebarRight.Parent = Sidebar

local SideList = Instance.new("ScrollingFrame")
SideList.Size = UDim2.new(1,0,1,0)
SideList.Position = UDim2.new(0,0,0,0)
SideList.BackgroundTransparency = 1
SideList.ScrollBarThickness = 0
SideList.BorderSizePixel = 0
SideList.ZIndex = 12
SideList.Parent = Sidebar

local SideLayout = Instance.new("UIListLayout")
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0,4)
SideLayout.Parent = SideList

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0,10)
SidePadding.PaddingLeft = UDim.new(0,8)
SidePadding.PaddingRight = UDim.new(0,8)
SidePadding.Parent = SideList

-- CONTENT AREA
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1,-148,1,-56)
ContentArea.Position = UDim2.new(0,148,0,56)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

-- SETTINGS PANEL
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.Size = UDim2.new(1,0,1,0)
SettingsPanel.Position = UDim2.new(0,0,0,0)
SettingsPanel.BackgroundTransparency = 1
SettingsPanel.Visible = false
SettingsPanel.ZIndex = 12
SettingsPanel.Parent = ContentArea

local SettingsScroll = Instance.new("ScrollingFrame")
SettingsScroll.Size = UDim2.new(1,-10,1,-10)
SettingsScroll.Position = UDim2.new(0,5,0,5)
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.ScrollBarThickness = 3
SettingsScroll.ScrollBarImageColor3 = ActiveTheme
SettingsScroll.BorderSizePixel = 0
SettingsScroll.ZIndex = 13
SettingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsScroll.CanvasSize = UDim2.new(0,0,0,0)
SettingsScroll.Parent = SettingsPanel

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsLayout.Padding = UDim.new(0,10)
SettingsLayout.Parent = SettingsScroll

local SettingsPad = Instance.new("UIPadding")
SettingsPad.PaddingTop = UDim.new(0,8)
SettingsPad.PaddingLeft = UDim.new(0,8)
SettingsPad.PaddingRight = UDim.new(0,8)
SettingsPad.Parent = SettingsScroll

-- PAGES CONTAINER
local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1,0,1,0)
PagesContainer.Position = UDim2.new(0,0,0,0)
PagesContainer.BackgroundTransparency = 1
PagesContainer.ZIndex = 12
PagesContainer.Parent = ContentArea

-- DRAGGING MAIN FRAME
local dragging = false
local dragStart, startPos
TitleBar.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = inp.Position
		startPos = MainFrame.Position
	end
end)
TitleBar.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
UIS.InputChanged:Connect(function(inp)
	if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = inp.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

-- ICON BUTTON
local IconFrame = Instance.new("Frame")
IconFrame.Name = "IconFrame"
IconFrame.Size = UDim2.new(0,54,0,54)
IconFrame.Position = UDim2.new(0,20,0.5,-27)
IconFrame.BackgroundColor3 = Color3.fromRGB(8,8,14)
IconFrame.BackgroundTransparency = 0
IconFrame.BorderSizePixel = 0
IconFrame.ZIndex = 50
IconFrame.Active = true
IconFrame.Parent = ScreenGui
makeCorner(IconFrame, 16)
makeStroke(IconFrame, ActiveTheme, 2)

local IconGlow = Instance.new("ImageLabel")
IconGlow.Size = UDim2.new(1,20,1,20)
IconGlow.Position = UDim2.new(0,-10,0,-10)
IconGlow.BackgroundTransparency = 1
IconGlow.Image = "rbxassetid://6014261993"
IconGlow.ImageColor3 = ActiveTheme
IconGlow.ImageTransparency = 0.7
IconGlow.ScaleType = Enum.ScaleType.Slice
IconGlow.SliceCenter = Rect.new(49,49,450,450)
IconGlow.ZIndex = 49
IconGlow.Parent = IconFrame

local IconBtn = Instance.new("TextButton")
IconBtn.Size = UDim2.new(1,0,1,0)
IconBtn.Position = UDim2.new(0,0,0,0)
IconBtn.BackgroundTransparency = 1
IconBtn.Text = ""
IconBtn.ZIndex = 51
IconBtn.Parent = IconFrame

local IconLabel = Instance.new("TextLabel")
IconLabel.Size = UDim2.new(1,0,0.55,0)
IconLabel.Position = UDim2.new(0,0,0.05,0)
IconLabel.BackgroundTransparency = 1
IconLabel.Text = "YW"
IconLabel.TextColor3 = ActiveTheme
IconLabel.TextSize = 15
IconLabel.Font = Enum.Font.GothamBold
IconLabel.ZIndex = 52
IconLabel.Parent = IconFrame

local IconSub = Instance.new("TextLabel")
IconSub.Size = UDim2.new(1,0,0.35,0)
IconSub.Position = UDim2.new(0,0,0.62,0)
IconSub.BackgroundTransparency = 1
IconSub.Text = "HUB"
IconSub.TextColor3 = Color3.fromRGB(150,150,150)
IconSub.TextSize = 9
IconSub.Font = Enum.Font.Gotham
IconSub.ZIndex = 52
IconSub.Parent = IconFrame

-- ICON DRAG LOGIC
local iconDragging = false
local iconDragStart = nil
local iconStartPos = nil
local iconMoved = false
local DRAG_THRESHOLD = 6

IconBtn.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		iconDragging = true
		iconMoved = false
		iconDragStart = inp.Position
		iconStartPos = IconFrame.AbsolutePosition
	end
end)

UIS.InputChanged:Connect(function(inp)
	if iconDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = inp.Position - iconDragStart
		if math.abs(delta.X) > DRAG_THRESHOLD or math.abs(delta.Y) > DRAG_THRESHOLD then
			iconMoved = true
		end
		if iconMoved then
			local vp = Camera.ViewportSize
			local newX = math.clamp(iconStartPos.X + delta.X, 0, vp.X - 54)
			local newY = math.clamp(iconStartPos.Y + delta.Y, 0, vp.Y - 54)
			IconFrame.Position = UDim2.new(0, newX, 0, newY)
		end
	end
end)

UIS.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 and iconDragging then
		iconDragging = false
		if not iconMoved then
			State.menuOpen = not State.menuOpen
			MainFrame.Visible = State.menuOpen
			if State.menuOpen then
				TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Size = UDim2.new(0,580,0,440)
				}):Play()
			end
		end
	end
end)

-- FUNCTIONS
local function applyTheme(color)
	ActiveTheme = color
	makeStroke(MainFrame, color, 1.5)
	TitleDot.BackgroundColor3 = color
	SubLabel.TextColor3 = color
	IconLabel.TextColor3 = color
	IconGlow.ImageColor3 = color
	makeStroke(IconFrame, color, 2)
end

local function setWalkSpeed(val)
	State.walkSpeed = val
	if Character and Character:FindFirstChild("Humanoid") then
		Character.Humanoid.WalkSpeed = val
	end
end

local function setJumpPower(val)
	State.jumpPower = val
	if Character and Character:FindFirstChild("Humanoid") then
		Character.Humanoid.JumpPower = val
	end
end

local function startFly()
	if not State.flyEnabled then return end
	local root = Character and Character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local hum = Character:FindFirstChild("Humanoid")
	if hum then hum.PlatformStand = true end

	BodyVel = Instance.new("BodyVelocity")
	BodyVel.Velocity = Vector3.new(0,0,0)
	BodyVel.MaxForce = Vector3.new(1e5,1e5,1e5)
	BodyVel.P = 1e4
	BodyVel.Parent = root

	BodyGyro = Instance.new("BodyGyro")
	BodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
	BodyGyro.P = 1e4
	BodyGyro.D = 100
	BodyGyro.CFrame = root.CFrame
	BodyGyro.Parent = root

	if flyConn then flyConn:Disconnect() end
	flyConn = RS.Heartbeat:Connect(function()
		if not State.flyEnabled then return end
		local root2 = Character and Character:FindFirstChild("HumanoidRootPart")
		if not root2 or not BodyVel or not BodyVel.Parent then return end

		local camCF = Camera.CFrame
		local vel = Vector3.new(0,0,0)
		local spd = State.flySpeed

		if UIS:IsKeyDown(Enum.KeyCode.W) then vel = vel + camCF.LookVector * spd end
		if UIS:IsKeyDown(Enum.KeyCode.S) then vel = vel - camCF.LookVector * spd end
		if UIS:IsKeyDown(Enum.KeyCode.A) then vel = vel - camCF.RightVector * spd end
		if UIS:IsKeyDown(Enum.KeyCode.D) then vel = vel + camCF.RightVector * spd end
		if UIS:IsKeyDown(Enum.KeyCode.Space) or State.flyUp then vel = vel + Vector3.new(0,1,0) * spd end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or State.flyDown then vel = vel - Vector3.new(0,1,0) * spd end

		BodyVel.Velocity = vel
		if vel.Magnitude > 0.1 then
			BodyGyro.CFrame = CFrame.new(Vector3.new(0,0,0), camCF.LookVector)
		end
	end)
end

local function stopFly()
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if BodyVel then BodyVel:Destroy() BodyVel = nil end
	if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
	local hum = Character and Character:FindFirstChild("Humanoid")
	if hum then hum.PlatformStand = false end
end

local function toggleFly()
	State.flyEnabled = not State.flyEnabled
	if State.flyEnabled then
		startFly()
		notify("✈ Полёт включён", ActiveTheme)
	else
		stopFly()
		notify("✈ Полёт выключен", Color3.fromRGB(255,80,80))
	end
end

local function toggleNoclip()
	State.noclipEnabled = not State.noclipEnabled
	if State.noclipEnabled then
		if noclipConn then noclipConn:Disconnect() end
		noclipConn = RS.Stepped:Connect(function()
			if not State.noclipEnabled then return end
			local char = Character
			if not char then return end
			for _, v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") and v.CanCollide then
					v.CanCollide = false
				end
			end
		end)
		notify("👻 Noclip включён", ActiveTheme)
	else
		if noclipConn then noclipConn:Disconnect() noclipConn = nil end
		local char = Character
		if char then
			for _, v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = true
				end
			end
		end
		notify("👻 Noclip выключен", Color3.fromRGB(255,80,80))
	end
end

local function toggleInfJump()
	State.infJumpEnabled = not State.infJumpEnabled
	notify(State.infJumpEnabled and "⬆ Инф. прыжок включён" or "⬆ Инф. прыжок выключен",
		State.infJumpEnabled and ActiveTheme or Color3.fromRGB(255,80,80))
end

local function toggleDoubleJump()
	State.doubleJumpEnabled = not State.doubleJumpEnabled
	notify(State.doubleJumpEnabled and "⬆⬆ Двойной прыжок включён" or "⬆⬆ Двойной прыжок выключен",
		State.doubleJumpEnabled and ActiveTheme or Color3.fromRGB(255,80,80))
end

local function toggleESP()
	State.espEnabled = not State.espEnabled
	if State.espEnabled then
		for _, obj in pairs(espObjects) do
			if obj and obj.Parent then obj:Destroy() end
		end
		espObjects = {}
		local function addESP(plr)
			if plr == Player then return end
			local function buildESP()
				local char = plr.Character
				if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart")
				if not root then return end
				local box = Instance.new("SelectionBox")
				box.Color3 = ActiveTheme
				box.LineThickness = 0.05
				box.SurfaceTransparency = 0.7
				box.SurfaceColor3 = ActiveTheme
				box.Adornee = char
				box.Parent = ScreenGui
				table.insert(espObjects, box)

				local bb = Instance.new("BillboardGui")
				bb.Size = UDim2.new(0,100,0,30)
				bb.StudsOffset = Vector3.new(0,3,0)
				bb.AlwaysOnTop = true
				bb.Adornee = root
				bb.Parent = ScreenGui
				table.insert(espObjects, bb)

				local namelbl = Instance.new("TextLabel")
				namelbl.Size = UDim2.new(1,0,1,0)
				namelbl.BackgroundTransparency = 1
				namelbl.Text = plr.Name
				namelbl.TextColor3 = ActiveTheme
				namelbl.TextScaled = true
				namelbl.Font = Enum.Font.GothamBold
				namelbl.TextStrokeTransparency = 0
				namelbl.TextStrokeColor3 = Color3.new(0,0,0)
				namelbl.Parent = bb
			end
			buildESP()
			plr.CharacterAdded:Connect(function()
				task.wait(0.5)
				buildESP()
			end)
		end
		for _, p in pairs(Players:GetPlayers()) do addESP(p) end
		if espConn then espConn:Disconnect() end
		espConn = Players.PlayerAdded:Connect(addESP)
		notify("👁 ESP включён", ActiveTheme)
	else
		for _, obj in pairs(espObjects) do
			if obj and obj.Parent then obj:Destroy() end
		end
		espObjects = {}
		if espConn then espConn:Disconnect() espConn = nil end
		notify("👁 ESP выключен", Color3.fromRGB(255,80,80))
	end
end

local function toggleFullbright()
	State.fullbrightEnabled = not State.fullbrightEnabled
	if State.fullbrightEnabled then
		if fullbrightConn then fullbrightConn:Disconnect() end
		fullbrightConn = RS.Heartbeat:Connect(function()
			if not State.fullbrightEnabled then return end
			local lighting = game:GetService("Lighting")
			lighting.Brightness = 10
			lighting.ClockTime = 14
			lighting.FogEnd = 100000
			lighting.GlobalShadows = false
			lighting.Ambient = Color3.fromRGB(255,255,255)
			lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
		end)
		notify("☀ Fullbright включён", ActiveTheme)
	else
		if fullbrightConn then fullbrightConn:Disconnect() fullbrightConn = nil end
		local lighting = game:GetService("Lighting")
		lighting.Brightness = 1
		lighting.ClockTime = 14
		lighting.FogEnd = 100000
		lighting.GlobalShadows = true
		lighting.Ambient = Color3.fromRGB(70,70,70)
		lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
		notify("☀ Fullbright выключен", Color3.fromRGB(255,80,80))
	end
end

local function toggleRainbow()
	State.rainbowEnabled = not State.rainbowEnabled
	if State.rainbowEnabled then
		if rainbowConn then rainbowConn:Disconnect() end
		rainbowConn = RS.Heartbeat:Connect(function()
			if not State.rainbowEnabled then return end
			local char = Character
			if not char then return end
			local t = tick() * 0.5
			for _, v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") or v:IsA("MeshPart") then
					v.Color = Color3.fromHSV(t % 1, 1, 1)
				end
			end
		end)
		notify("🌈 Радуга включена", ActiveTheme)
	else
		if rainbowConn then rainbowConn:Disconnect() rainbowConn = nil end
		notify("🌈 Радуга выключена", Color3.fromRGB(255,80,80))
	end
end

-- SLIDER MAKER
local function makeSlider(parent, labelText, minVal, maxVal, currentVal, callback, order)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(1,0,0,64)
	sliderFrame.BackgroundColor3 = Color3.fromRGB(14,14,22)
	sliderFrame.BackgroundTransparency = 0
	sliderFrame.BorderSizePixel = 0
	sliderFrame.ZIndex = 14
	sliderFrame.LayoutOrder = order or 0
	sliderFrame.Parent = parent
	makeCorner(sliderFrame, 10)
	makeStroke(sliderFrame, Color3.fromRGB(30,30,50), 1)

	local sLabel = Instance.new("TextLabel")
	sLabel.Size = UDim2.new(0.65,0,0,22)
	sLabel.Position = UDim2.new(0,12,0,8)
	sLabel.BackgroundTransparency = 1
	sLabel.Text = labelText
	sLabel.TextColor3 = Color3.fromRGB(200,200,200)
	sLabel.TextSize = 13
	sLabel.Font = Enum.Font.Gotham
	sLabel.TextXAlignment = Enum.TextXAlignment.Left
	sLabel.ZIndex = 15
	sLabel.Parent = sliderFrame

	local sValue = Instance.new("TextLabel")
	sValue.Size = UDim2.new(0.3,0,0,22)
	sValue.Position = UDim2.new(0.7,-12,0,8)
	sValue.BackgroundTransparency = 1
	sValue.Text = tostring(currentVal)
	sValue.TextColor3 = ActiveTheme
	sValue.TextSize = 13
	sValue.Font = Enum.Font.GothamBold
	sValue.TextXAlignment = Enum.TextXAlignment.Right
	sValue.ZIndex = 15
	sValue.Parent = sliderFrame

	local trackBG = Instance.new("Frame")
	trackBG.Size = UDim2.new(1,-24,0,8)
	trackBG.Position = UDim2.new(0,12,0,38)
	trackBG.BackgroundColor3 = Color3.fromRGB(25,25,40)
	trackBG.BackgroundTransparency = 0
	trackBG.BorderSizePixel = 0
	trackBG.ZIndex = 15
	trackBG.Parent = sliderFrame
	makeCorner(trackBG, 4)

	local trackFill = Instance.new("Frame")
	local pct = (currentVal - minVal) / (maxVal - minVal)
	trackFill.Size = UDim2.new(pct, 0, 1, 0)
	trackFill.BackgroundColor3 = ActiveTheme
	trackFill.BackgroundTransparency = 0
	trackFill.BorderSizePixel = 0
	trackFill.ZIndex = 16
	trackFill.Parent = trackBG
	makeCorner(trackFill, 4)

	local trackGrad = Instance.new("UIGradient")
	trackGrad.Color = ColorSequence.new(ActiveTheme, Color3.fromRGB(
		math.floor(ActiveTheme.R*255*0.6),
		math.floor(ActiveTheme.G*255*0.6),
		math.floor(ActiveTheme.B*255*0.6)
	))
	trackGrad.Rotation = 90
	trackGrad.Parent = trackFill

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0,16,0,16)
	knob.Position = UDim2.new(pct,-8,0.5,-8)
	knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	knob.BorderSizePixel = 0
	knob.ZIndex = 17
	knob.Parent = trackBG
	makeCorner(knob, 8)
	makeStroke(knob, ActiveTheme, 2)

	local draggingSlider = false
	local function updateSlider(inputX)
		local abs = trackBG.AbsolutePosition
		local size = trackBG.AbsoluteSize
		local rel = math.clamp((inputX - abs.X) / size.X, 0, 1)
		local val = math.floor(minVal + (maxVal - minVal) * rel)
		trackFill.Size = UDim2.new(rel, 0, 1, 0)
		knob.Position = UDim2.new(rel, -8, 0.5, -8)
		sValue.Text = tostring(val)
		callback(val)
	end

	trackBG.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSlider = true
			updateSlider(inp.Position.X)
		end
	end)
	UIS.InputChanged:Connect(function(inp)
		if draggingSlider and inp.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(inp.Position.X)
		end
	end)
	UIS.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSlider = false
		end
	end)

	return sliderFrame, sValue, trackFill, knob
end

-- TOGGLE BUTTON MAKER
local function makeToggle(parent, labelText, icon, defaultState, callback, order)
	local tf = Instance.new("Frame")
	tf.Size = UDim2.new(1,0,0,50)
	tf.BackgroundColor3 = Color3.fromRGB(14,14,22)
	tf.BackgroundTransparency = 0
	tf.BorderSizePixel = 0
	tf.ZIndex = 14
	tf.LayoutOrder = order or 0
	tf.Parent = parent
	makeCorner(tf, 10)
	makeStroke(tf, Color3.fromRGB(30,30,50), 1)

	local iconLbl = Instance.new("TextLabel")
	iconLbl.Size = UDim2.new(0,36,1,0)
	iconLbl.Position = UDim2.new(0,8,0,0)
	iconLbl.BackgroundTransparency = 1
	iconLbl.Text = icon or "●"
	iconLbl.TextColor3 = ActiveTheme
	iconLbl.TextSize = 18
	iconLbl.Font = Enum.Font.GothamBold
	iconLbl.ZIndex = 15
	iconLbl.Parent = tf

	local tLabel = Instance.new("TextLabel")
	tLabel.Size = UDim2.new(1,-100,1,0)
	tLabel.Position = UDim2.new(0,46,0,0)
	tLabel.BackgroundTransparency = 1
	tLabel.Text = labelText
	tLabel.TextColor3 = Color3.fromRGB(200,200,200)
	tLabel.TextSize = 13
	tLabel.Font = Enum.Font.Gotham
	tLabel.TextXAlignment = Enum.TextXAlignment.Left
	tLabel.ZIndex = 15
	tLabel.Parent = tf

	local toggleBG = Instance.new("Frame")
	toggleBG.Size = UDim2.new(0,46,0,24)
	toggleBG.Position = UDim2.new(1,-56,0.5,-12)
	toggleBG.BackgroundColor3 = defaultState and ActiveTheme or Color3.fromRGB(35,35,50)
	toggleBG.BorderSizePixel = 0
	toggleBG.ZIndex = 15
	toggleBG.Parent = tf
	makeCorner(toggleBG, 12)

	local toggleKnob = Instance.new("Frame")
	toggleKnob.Size = UDim2.new(0,18,0,18)
	toggleKnob.Position = defaultState and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
	toggleKnob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	toggleKnob.BorderSizePixel = 0
	toggleKnob.ZIndex = 16
	toggleKnob.Parent = toggleBG
	makeCorner(toggleKnob, 9)

	local togBtn = Instance.new("TextButton")
	togBtn.Size = UDim2.new(1,0,1,0)
	togBtn.BackgroundTransparency = 1
	togBtn.Text = ""
	togBtn.ZIndex = 17
	togBtn.Parent = tf

	local togState = defaultState or false
	togBtn.MouseButton1Click:Connect(function()
		togState = not togState
		TweenService:Create(toggleBG, TweenInfo.new(0.2), {
			BackgroundColor3 = togState and ActiveTheme or Color3.fromRGB(35,35,50)
		}):Play()
		TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
			Position = togState and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
		}):Play()
		callback(togState)
	end)

	return tf, toggleBG, toggleKnob
end

-- SECTION HEADER MAKER
local function makeSectionHeader(parent, text, order)
	local hf = Instance.new("Frame")
	hf.Size = UDim2.new(1,0,0,28)
	hf.BackgroundTransparency = 1
	hf.ZIndex = 14
	hf.LayoutOrder = order or 0
	hf.Parent = parent

	local line = Instance.new("Frame")
	line.Size = UDim2.new(1,0,0,1)
	line.Position = UDim2.new(0,0,0.5,0)
	line.BackgroundColor3 = Color3.fromRGB(30,30,50)
	line.BorderSizePixel = 0
	line.ZIndex = 14
	line.Parent = hf

	local hl = Instance.new("TextLabel")
	hl.Size = UDim2.new(0,0,1,0)
	hl.AutomaticSize = Enum.AutomaticSize.X
	hl.Position = UDim2.new(0,0,0,0)
	hl.BackgroundColor3 = Color3.fromRGB(8,8,14)
	hl.BackgroundTransparency = 0
	hl.Text = " " .. text .. " "
	hl.TextColor3 = ActiveTheme
	hl.TextSize = 11
	hl.Font = Enum.Font.GothamBold
	hl.ZIndex = 15
	hl.Parent = hf

	return hf
end

-- SIDEBAR BUTTONS & PAGES
local pages = {}
local sideButtons = {}
local currentPage = nil

local categories = {
	{name = "Игрок", icon = "🧍"},
	{name = "Визуал", icon = "👁"},
	{name = "Полёт", icon = "✈"},
	{name = "Телепорт", icon = "🌀"},
}

local function switchPage(name)
	for pageName, pageFrame in pairs(pages) do
		pageFrame.Visible = pageName == name
	end
	for btnName, btn in pairs(sideButtons) do
		if btnName == name then
			btn.BackgroundColor3 = Color3.fromRGB(0,40,20)
			makeStroke(btn, ActiveTheme, 1.5)
		else
			btn.BackgroundColor3 = Color3.fromRGB(14,14,22)
			makeStroke(btn, Color3.fromRGB(30,30,50), 1)
		end
	end
	currentPage = name
	SettingsPanel.Visible = false
end

for i, cat in ipairs(categories) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,44)
	btn.BackgroundColor3 = Color3.fromRGB(14,14,22)
	btn.Text = ""
	btn.BorderSizePixel = 0
	btn.ZIndex = 13
	btn.LayoutOrder = i
	btn.Parent = SideList
	makeCorner(btn, 10)
	makeStroke(btn, Color3.fromRGB(30,30,50), 1)

	local btnIcon = Instance.new("TextLabel")
	btnIcon.Size = UDim2.new(0,28,1,0)
	btnIcon.Position = UDim2.new(0,6,0,0)
	btnIcon.BackgroundTransparency = 1
	btnIcon.Text = cat.icon
	btnIcon.TextColor3 = ActiveTheme
	btnIcon.TextSize = 18
	btnIcon.Font = Enum.Font.GothamBold
	btnIcon.ZIndex = 14
	btnIcon.Parent = btn

	local btnLabel = Instance.new("TextLabel")
	btnLabel.Size = UDim2.new(1,-36,1,0)
	btnLabel.Position = UDim2.new(0,34,0,0)
	btnLabel.BackgroundTransparency = 1
	btnLabel.Text = cat.name
	btnLabel.TextColor3 = Color3.fromRGB(200,200,200)
	btnLabel.TextSize = 12
	btnLabel.Font = Enum.Font.Gotham
	btnLabel.TextXAlignment = Enum.TextXAlignment.Left
	btnLabel.ZIndex = 14
	btnLabel.Parent = btn

	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1,-8,1,-8)
	page.Position = UDim2.new(0,4,0,4)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = ActiveTheme
	page.BorderSizePixel = 0
	page.ZIndex = 13
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0,0,0,0)
	page.Visible = false
	page.Parent = PagesContainer

	local pageLayout = Instance.new("UIListLayout")
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Padding = UDim.new(0,8)
	pageLayout.Parent = page

	local pagePad = Instance.new("UIPadding")
	pagePad.PaddingTop = UDim.new(0,6)
	pagePad.PaddingLeft = UDim.new(0,4)
	pagePad.PaddingRight = UDim.new(0,4)
	pagePad.Parent = page

	pages[cat.name] = page
	sideButtons[cat.name] = btn

	btn.MouseButton1Click:Connect(function()
		switchPage(cat.name)
	end)
end

-- PLAYER PAGE
do
	local p = pages["Игрок"]

	makeSectionHeader(p, "ДВИЖЕНИЕ", 1)

	makeSlider(p, "Скорость ходьбы", 16, 500, 16, function(v)
		State.walkSpeed = v
		local char = Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = v
		end
	end, 2)

	makeSlider(p, "Сила прыжка", 50, 500, 50, function(v)
		State.jumpPower = v
		local char = Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.JumpPower = v
		end
	end, 3)

	makeSectionHeader(p, "ПРЫЖОК", 4)

	makeToggle(p, "Бесконечный прыжок", "⬆", false, function(val)
		State.infJumpEnabled = val
		notify(val and "⬆ Инф. прыжок включён" or "⬆ Инф. прыжок выключен",
			val and ActiveTheme or Color3.fromRGB(255,80,80))
	end, 5)

	makeToggle(p, "Двойной прыжок", "⬆⬆", false, function(val)
		State.doubleJumpEnabled = val
		State.canDoubleJump = false
		notify(val and "⬆⬆ Двойной прыжок включён" or "⬆⬆ Двойной прыжок выключен",
			val and ActiveTheme or Color3.fromRGB(255,80,80))
	end, 6)

	makeSectionHeader(p, "ФИЗИКА", 7)

	makeToggle(p, "Нoclip (сквозь стены)", "👻", false, function(val)
		State.noclipEnabled = val
		toggleNoclip()
		if val then toggleNoclip() end
	end, 8)
end

-- VISUAL PAGE
do
	local p = pages["Визуал"]

	makeSectionHeader(p, "ИГРОКИ", 1)

	makeToggle(p, "ESP (видеть игроков)", "👁", false, function(val)
		State.espEnabled = not State.espEnabled
		toggleESP()
		if val ~= State.espEnabled then toggleESP() end
	end, 2)

	makeSectionHeader(p, "МИР", 3)

	makeToggle(p, "Fullbright (яркость макс)", "☀", false, function(val)
		State.fullbrightEnabled = not State.fullbrightEnabled
		toggleFullbright()
		if val ~= State.fullbrightEnabled then toggleFullbright() end
	end, 4)

	makeToggle(p, "Убрать туман", "🌫", false, function(val)
		local l = game:GetService("Lighting")
		if val then
			l.FogEnd = 100000
			l.FogStart = 99999
		else
			l.FogEnd = 100000
			l.FogStart = 0
		end
		notify(val and "🌫 Туман убран" or "🌫 Туман восстановлен",
			val and ActiveTheme or Color3.fromRGB(255,80,80))
	end, 5)

	makeSectionHeader(p, "ПЕРСОНАЖ", 6)

	makeToggle(p, "Радужный персонаж 🌈", "🌈", false, function(val)
		State.rainbowEnabled = not State.rainbowEnabled
		toggleRainbow()
		if val ~= State.rainbowEnabled then toggleRainbow() end
	end, 7)

	makeToggle(p, "Невидимость", "🫥", false, function(val)
		local char = Character
		if not char then return end
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("Decal") then
				v.Transparency = val and 1 or 0
			end
		end
		notify(val and "🫥 Невидимость включена" or "🫥 Невидимость выключена",
			val and ActiveTheme or Color3.fromRGB(255,80,80))
	end, 8)

	makeSectionHeader(p, "FOV", 9)
	makeSlider(p, "Поле зрения (FOV)", 70, 120, 70, function(v)
		Camera.FieldOfView = v
	end, 10)
end

-- FLY PAGE
do
	local p = pages["Полёт"]

	makeSectionHeader(p, "УПРАВЛЕНИЕ ПОЛЁТОМ", 1)

	makeToggle(p, "Включить полёт", "✈", false, function(val)
		State.flyEnabled = val
		if val then
			startFly()
			notify("✈ Полёт включён", ActiveTheme)
		else
			stopFly()
			notify("✈ Полёт выключен", Color3.fromRGB(255,80,80))
		end
	end, 2)

	makeSlider(p, "Скорость полёта", 10, 500, 50, function(v)
		State.flySpeed = v
	end, 3)

	makeSectionHeader(p, "ПОДСКАЗКА", 4)

	local hint = Instance.new("TextLabel")
	hint.Size = UDim2.new(1,0,0,80)
	hint.BackgroundColor3 = Color3.fromRGB(10,20,15)
	hint.BackgroundTransparency = 0
	hint.Text = "W/A/S/D — движение\nПробел — вверх\nShift — вниз\n\nТакже есть виджет управления (E)"
	hint.TextColor3 = Color3.fromRGB(150,255,180)
	hint.TextSize = 12
	hint.Font = Enum.Font.Gotham
	hint.TextWrapped = true
	hint.ZIndex = 14
	hint.LayoutOrder = 5
	hint.Parent = p
	makeCorner(hint, 10)
	makeStroke(hint, ActiveTheme, 1)
end

-- TELEPORT PAGE
do
	local p = pages["Телепорт"]

	makeSectionHeader(p, "ТЕЛЕПОРТ К ИГРОКУ", 1)

	local playersScroll = Instance.new("Frame")
	playersScroll.Size = UDim2.new(1,0,0,0)
	playersScroll.AutomaticSize = Enum.AutomaticSize.Y
	playersScroll.BackgroundTransparency = 1
	playersScroll.ZIndex = 14
	playersScroll.LayoutOrder = 2
	playersScroll.Parent = p

	local plLayout = Instance.new("UIListLayout")
	plLayout.SortOrder = Enum.SortOrder.LayoutOrder
	plLayout.Padding = UDim.new(0,6)
	plLayout.Parent = playersScroll

	local function refreshPlayers()
		for _, c in pairs(playersScroll:GetChildren()) do
			if not c:IsA("UIListLayout") then c:Destroy() end
		end
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= Player then
				local pbtn = Instance.new("TextButton")
				pbtn.Size = UDim2.new(1,0,0,40)
				pbtn.BackgroundColor3 = Color3.fromRGB(14,14,22)
				pbtn.BorderSizePixel = 0
				pbtn.Text = "🌀 ТП к " .. plr.Name
				pbtn.TextColor3 = Color3.fromRGB(200,200,200)
				pbtn.TextSize = 13
				pbtn.Font = Enum.Font.Gotham
				pbtn.ZIndex = 15
				pbtn.Parent = playersScroll
				makeCorner(pbtn, 8)
				makeStroke(pbtn, Color3.fromRGB(30,30,50), 1)

				pbtn.MouseButton1Click:Connect(function()
					local tchar = plr.Character
					if tchar and tchar:FindFirstChild("HumanoidRootPart") then
						local root = Character and Character:FindFirstChild("HumanoidRootPart")
						if root then
							root.CFrame = tchar.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
							notify("🌀 ТП к " .. plr.Name, ActiveTheme)
						end
					else
						notify("❌ Игрок не найден", Color3.fromRGB(255,80,80))
					end
				end)
			end
		end
	end
	refreshPlayers()

	local refreshBtn = Instance.new("TextButton")
	refreshBtn.Size = UDim2.new(1,0,0,40)
	refreshBtn.BackgroundColor3 = Color3.fromRGB(0,30,15)
	refreshBtn.BorderSizePixel = 0
	refreshBtn.Text = "🔄 Обновить список"
	refreshBtn.TextColor3 = ActiveTheme
	refreshBtn.TextSize = 13
	refreshBtn.Font = Enum.Font.GothamBold
	refreshBtn.ZIndex = 14
	refreshBtn.LayoutOrder = 3
	refreshBtn.Parent = p
	makeCorner(refreshBtn, 8)
	makeStroke(refreshBtn, ActiveTheme, 1)
	refreshBtn.MouseButton1Click:Connect(refreshPlayers)

	makeSectionHeader(p, "КЛИК-ТЕЛЕПОРТ", 4)

	makeToggle(p, "ТП по клику мыши", "🖱", false, function(val)
		if val then
			local clickConn
			clickConn = UIS.InputBegan:Connect(function(inp)
				if not val then
					clickConn:Disconnect()
					return
				end
				if inp.UserInputType == Enum.UserInputType.MouseButton2 then
					local ray = Camera:ViewportPointToRay(inp.Position.X, inp.Position.Y)
					local raycastParams = RaycastParams.new()
					raycastParams.FilterDescendantsInstances = {Character}
					raycastParams.FilterType = Enum.RaycastFilterType.Exclude
					local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
					if result then
						local root = Character and Character:FindFirstChild("HumanoidRootPart")
						if root then
							root.CFrame = CFrame.new(result.Position + Vector3.new(0,3,0))
							notify("🖱 Телепорт!", ActiveTheme)
						end
					end
				end
			end)
		end
		notify(val and "🖱 Клик-ТП включён (ПКМ)" or "🖱 Клик-ТП выключен",
			val and ActiveTheme or Color3.fromRGB(255,80,80))
	end, 5)

	makeSectionHeader(p, "КООРДИНАТЫ", 6)

	local coordLabel = Instance.new("TextLabel")
	coordLabel.Size = UDim2.new(1,0,0,50)
	coordLabel.BackgroundColor3 = Color3.fromRGB(10,20,15)
	coordLabel.BackgroundTransparency = 0
	coordLabel.Text = "X: 0  Y: 0  Z: 0"
	coordLabel.TextColor3 = ActiveTheme
	coordLabel.TextSize = 13
	coordLabel.Font = Enum.Font.GothamBold
	coordLabel.ZIndex = 14
	coordLabel.LayoutOrder = 7
	coordLabel.Parent = p
	makeCorner(coordLabel, 8)
	makeStroke(coordLabel, ActiveTheme, 1)

	RS.Heartbeat:Connect(function()
		local root = Character and Character:FindFirstChild("HumanoidRootPart")
		if root and coordLabel and coordLabel.Parent then
			local pos = root.Position
			coordLabel.Text = string.format("X: %.1f  Y: %.1f  Z: %.1f", pos.X, pos.Y, pos.Z)
		end
	end)
end

-- SETTINGS PAGE CONTENT
do
	local function makeSettingLabel(parent, text, order)
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1,0,0,24)
		lbl.BackgroundTransparency = 1
		lbl.Text = text
		lbl.TextColor3 = Color3.fromRGB(140,140,160)
		lbl.TextSize = 11
		lbl.Font = Enum.Font.GothamBold
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.ZIndex = 14
		lbl.LayoutOrder = order or 0
		lbl.Parent = parent
		return lbl
	end

	makeSectionHeader(SettingsScroll, "ТЕМА", 1)
	makeSettingLabel(SettingsScroll, "Выберите цветовую схему:", 2)

	local themesFrame = Instance.new("Frame")
	themesFrame.Size = UDim2.new(1,0,0,0)
	themesFrame.AutomaticSize = Enum.AutomaticSize.Y
	themesFrame.BackgroundTransparency = 1
	themesFrame.ZIndex = 14
	themesFrame.LayoutOrder = 3
	themesFrame.Parent = SettingsScroll

	local themesLayout = Instance.new("UIListLayout")
	themesLayout.SortOrder = Enum.SortOrder.LayoutOrder
	themesLayout.Padding = UDim.new(0,6)
	themesLayout.FillDirection = Enum.FillDirection.Horizontal
	themesLayout.Wraps = true
	themesLayout.Parent = themesFrame

	local themeList = {
		{name="Default", color=Color3.fromRGB(0,255,127), label="🟢"},
		{name="Midnight", color=Color3.fromRGB(138,43,226), label="🟣"},
		{name="Ocean", color=Color3.fromRGB(0,191,255), label="🔵"},
		{name="Sunset", color=Color3.fromRGB(255,100,50), label="🟠"},
		{name="Rose", color=Color3.fromRGB(255,50,120), label="🔴"},
	}

	for _, th in ipairs(themeList) do
		local tbtn = Instance.new("TextButton")
		tbtn.Size = UDim2.new(0,80,0,36)
		tbtn.BackgroundColor3 = Color3.fromRGB(14,14,22)
		tbtn.BorderSizePixel = 0
		tbtn.Text = th.label .. " " .. th.name
		tbtn.TextColor3 = th.color
		tbtn.TextSize = 11
		tbtn.Font = Enum.Font.GothamBold
		tbtn.ZIndex = 15
		tbtn.Parent = themesFrame
		makeCorner(tbtn, 8)
		makeStroke(tbtn, th.color, 1.5)

		tbtn.MouseButton1Click:Connect(function()
			ActiveTheme = th.color
			applyTheme(th.color)
			notify("🎨 Тема: " .. th.name, th.color)
		end)
	end

	makeSectionHeader(SettingsScroll, "ПРОЗРАЧНОСТЬ МЕНЮ", 4)

	makeSlider(SettingsScroll, "Прозрачность фона", 0, 80, 8, function(v)
		MainFrame.BackgroundTransparency = v / 100
	end, 5)

	makeSectionHeader(SettingsScroll, "КОНФИГИ", 6)

	local configList = {"Default 🟢", "Midnight 🟣", "Ocean 🔵", "Sunset 🟠", "Rose 🔴"}
	for i, cfgName in ipairs(configList) do
		local cbtn = Instance.new("TextButton")
		cbtn.Size = UDim2.new(1,0,0,38)
		cbtn.BackgroundColor3 = Color3.fromRGB(14,14,22)
		cbtn.BorderSizePixel = 0
		cbtn.Text = "📂 Загрузить: " .. cfgName
		cbtn.TextColor3 = Color3.fromRGB(180,180,180)
		cbtn.TextSize = 12
		cbtn.Font = Enum.Font.Gotham
		cbtn.ZIndex = 14
		cbtn.LayoutOrder = 6 + i
		cbtn.Parent = SettingsScroll
		makeCorner(cbtn, 8)
		makeStroke(cbtn, Color3.fromRGB(30,30,50), 1)

		cbtn.MouseButton1Click:Connect(function()
			notify("📂 Конфиг загружен: " .. cfgName, ActiveTheme)
		end)
	end

	makeSectionHeader(SettingsScroll, "ГОРЯЧИЕ КЛАВИШИ", 13)

	local keysInfo = Instance.new("TextLabel")
	keysInfo.Size = UDim2.new(1,0,0,100)
	keysInfo.BackgroundColor3 = Color3.fromRGB(10,20,15)
	keysInfo.BackgroundTransparency = 0
	keysInfo.Text = "V — открыть/закрыть меню\nE — виджет полёта\nF — быстрый полёт\nDelete — уничтожить GUI"
	keysInfo.TextColor3 = Color3.fromRGB(150,255,180)
	keysInfo.TextSize = 12
	keysInfo.Font = Enum.Font.Gotham
	keysInfo.TextWrapped = true
	keysInfo.ZIndex = 14
	keysInfo.LayoutOrder = 14
	keysInfo.Parent = SettingsScroll
	makeCorner(keysInfo, 8)
	makeStroke(keysInfo, ActiveTheme, 1)
end

-- FLY WIDGET
local FlyWidget = Instance.new("Frame")
FlyWidget.Name = "FlyWidget"
FlyWidget.Size = UDim2.new(0,160,0,260)
FlyWidget.Position = UDim2.new(1,-180,0.5,-130)
FlyWidget.BackgroundColor3 = Color3.fromRGB(10,10,16)
FlyWidget.BackgroundTransparency = 0.05
FlyWidget.BorderSizePixel = 0
FlyWidget.ZIndex = 60
FlyWidget.Active = true
FlyWidget.Parent = ScreenGui
makeCorner(FlyWidget, 14)
makeStroke(FlyWidget, ActiveTheme, 1.5)
makeGradient(FlyWidget, Color3.fromRGB(12,12,20), Color3.fromRGB(7,7,12))

local FlyWidgetTitle = Instance.new("Frame")
FlyWidgetTitle.Size = UDim2.new(1,0,0,36)
FlyWidgetTitle.BackgroundColor3 = Color3.fromRGB(7,7,12)
FlyWidgetTitle.BackgroundTransparency = 0
FlyWidgetTitle.BorderSizePixel = 0
FlyWidgetTitle.ZIndex = 61
FlyWidgetTitle.Parent = FlyWidget
makeCorner(FlyWidgetTitle, 14)

local FlyWidgetTitleFix = Instance.new("Frame")
FlyWidgetTitleFix.Size = UDim2.new(1,0,0.5,0)
FlyWidgetTitleFix.Position = UDim2.new(0,0,0.5,0)
FlyWidgetTitleFix.BackgroundColor3 = Color3.fromRGB(7,7,12)
FlyWidgetTitleFix.BackgroundTransparency = 0
FlyWidgetTitleFix.BorderSizePixel = 0
FlyWidgetTitleFix.ZIndex = 61
FlyWidgetTitleFix.Parent = FlyWidgetTitle

local FlyTitleLbl = Instance.new("TextLabel")
FlyTitleLbl.Size = UDim2.new(1,-30,1,0)
FlyTitleLbl.Position = UDim2.new(0,10,0,0)
FlyTitleLbl.BackgroundTransparency = 1
FlyTitleLbl.Text = "✈ ПОЛЁТ"
FlyTitleLbl.TextColor3 = ActiveTheme
FlyTitleLbl.TextSize = 13
FlyTitleLbl.Font = Enum.Font.GothamBold
FlyTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
FlyTitleLbl.ZIndex = 62
FlyTitleLbl.Parent = FlyWidgetTitle

local FlyCloseBtn = Instance.new("TextButton")
FlyCloseBtn.Size = UDim2.new(0,22,0,22)
FlyCloseBtn.Position = UDim2.new(1,-26,0.5,-11)
FlyCloseBtn.BackgroundColor3 = Color3.fromRGB(40,10,10)
FlyCloseBtn.Text = "✕"
FlyCloseBtn.TextColor3 = Color3.fromRGB(255,80,80)
FlyCloseBtn.TextSize = 11
FlyCloseBtn.Font = Enum.Font.GothamBold
FlyCloseBtn.BorderSizePixel = 0
FlyCloseBtn.ZIndex = 62
FlyCloseBtn.Parent = FlyWidgetTitle
makeCorner(FlyCloseBtn, 6)

-- FLY WIDGET DRAG
local fwDragging = false
local fwDragStart, fwStartPos
FlyWidgetTitle.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		fwDragging = true
		fwDragStart = inp.Position
		fwStartPos = FlyWidget.Position
	end
end)
FlyWidgetTitle.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		fwDragging = false
	end
end)
UIS.InputChanged:Connect(function(inp)
	if fwDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = inp.Position - fwDragStart
		FlyWidget.Position = UDim2.new(
			fwStartPos.X.Scale, fwStartPos.X.Offset + delta.X,
			fwStartPos.Y.Scale, fwStartPos.Y.Offset + delta.Y
		)
	end
end)

-- FLY STATUS LABEL
local FlyStatusLbl = Instance.new("TextLabel")
FlyStatusLbl.Size = UDim2.new(1,0,0,22)
FlyStatusLbl.Position = UDim2.new(0,0,0,40)
FlyStatusLbl.BackgroundTransparency = 1
FlyStatusLbl.Text = "● ВЫКЛ"
FlyStatusLbl.TextColor3 = Color3.fromRGB(255,80,80)
FlyStatusLbl.TextSize = 12
FlyStatusLbl.Font = Enum.Font.GothamBold
FlyStatusLbl.ZIndex = 62
FlyStatusLbl.Parent = FlyWidget

-- FLY SPEED DISPLAY
local FlySpeedDisplay = Instance.new("TextLabel")
FlySpeedDisplay.Size = UDim2.new(1,0,0,18)
FlySpeedDisplay.Position = UDim2.new(0,0,0,63)
FlySpeedDisplay.BackgroundTransparency = 1
FlySpeedDisplay.Text = "Скорость: 50"
FlySpeedDisplay.TextColor3 = Color3.fromRGB(150,150,180)
FlySpeedDisplay.TextSize = 11
FlySpeedDisplay.Font = Enum.Font.Gotham
FlySpeedDisplay.ZIndex = 62
FlySpeedDisplay.Parent = FlyWidget

-- FLY WIDGET BUTTONS LAYOUT
local function makeFlyBtn(text, color, posX, posY, sizeX, sizeY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, sizeX or 60, 0, sizeY or 40)
	btn.Position = UDim2.new(0, posX, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(14,14,22)
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = color or ActiveTheme
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamBold
	btn.ZIndex = 62
	btn.Parent = FlyWidget
	makeCorner(btn, 8)
	makeStroke(btn, color or ActiveTheme, 1.5)
	return btn
end

local FlyToggleBtn = makeFlyBtn("✈ ПОЛЁТ", ActiveTheme, 20, 88, 120, 36)
local FlyUpBtn = makeFlyBtn("▲ ВВЕРХ", Color3.fromRGB(100,255,150), 20, 134, 120, 36)
local FlyDownBtn = makeFlyBtn("▼ ВНИЗ", Color3.fromRGB(255,100,100), 20, 180, 120, 36)

local FlySpeedMinusBtn = makeFlyBtn("−", Color3.fromRGB(255,150,100), 20, 226, 50, 28)
local FlySpeedPlusBtn = makeFlyBtn("+", Color3.fromRGB(100,255,150), 90, 226, 50, 28)

FlyToggleBtn.MouseButton1Click:Connect(function()
	State.flyEnabled = not State.flyEnabled
	if State.flyEnabled then
		startFly()
		FlyStatusLbl.Text = "● ВКЛ"
		FlyStatusLbl.TextColor3 = ActiveTheme
		TweenService:Create(FlyToggleBtn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(0,40,20)
		}):Play()
		notify("✈ Полёт включён", ActiveTheme)
	else
		stopFly()
		FlyStatusLbl.Text = "● ВЫКЛ"
		FlyStatusLbl.TextColor3 = Color3.fromRGB(255,80,80)
		TweenService:Create(FlyToggleBtn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(14,14,22)
		}):Play()
		notify("✈ Полёт выключен", Color3.fromRGB(255,80,80))
	end
end)

FlyUpBtn.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then State.flyUp = true end
end)
FlyUpBtn.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then State.flyUp = false end
end)
FlyDownBtn.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then State.flyDown = true end
end)
FlyDownBtn.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then State.flyDown = false end
end)

FlySpeedMinusBtn.MouseButton1Click:Connect(function()
	State.flySpeed = math.max(10, State.flySpeed - 10)
	FlySpeedDisplay.Text = "Скорость: " .. State.flySpeed
	if BodyVel then BodyVel.P = State.flySpeed * 200 end
end)
FlySpeedPlusBtn.MouseButton1Click:Connect(function()
	State.flySpeed = math.min(500, State.flySpeed + 10)
	FlySpeedDisplay.Text = "Скорость: " .. State.flySpeed
	if BodyVel then BodyVel.P = State.flySpeed * 200 end
end)

FlyCloseBtn.MouseButton1Click:Connect(function()
	FlyWidget.Visible = false
	State.flyWidgetOpen = false
end)

-- INF JUMP & DOUBLE JUMP LOGIC
UIS.JumpRequest:Connect(function()
	if State.infJumpEnabled then
		local hum = Character and Character:FindFirstChild("Humanoid")
		if hum and hum:GetState() ~= Enum.HumanoidStateType.Jumping then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

UIS.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if inp.KeyCode == Enum.KeyCode.Space then
		if State.doubleJumpEnabled then
			local hum = Character and Character:FindFirstChild("Humanoid")
			if hum then
				if hum:GetState() == Enum.HumanoidStateType.Freefall and State.canDoubleJump then
					State.canDoubleJump = false
					local root = Character:FindFirstChild("HumanoidRootPart")
					if root then
						local bv = Instance.new("BodyVelocity")
						bv.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
						bv.MaxForce = Vector3.new(0, math.huge, 0)
						bv.P = math.huge
						bv.Parent = root
						task.delay(0.15, function() bv:Destroy() end)
					end
				end
			end
		end
	end
end)

local prevState = nil
RS.Heartbeat:Connect(function()
	local hum = Character and Character:FindFirstChild("Humanoid")
	if hum and State.doubleJumpEnabled then
		local curState = hum:GetState()
		if prevState == Enum.HumanoidStateType.Jumping and curState == Enum.HumanoidStateType.Freefall then
			State.canDoubleJump = true
		end
		if curState == Enum.HumanoidStateType.Landed then
			State.canDoubleJump = false
		end
		prevState = curState
	end
end)

-- BUTTONS LOGIC
CloseBtn.MouseButton1Click:Connect(function()
	State.menuOpen = false
	MainFrame.Visible = false
end)

MinBtn.MouseButton1Click:Connect(function()
	if MainFrame.Size == UDim2.new(0,580,0,48) then
		TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
			Size = UDim2.new(0,580,0,440)
		}):Play()
	else
		TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0,580,0,48)
		}):Play()
	end
end)

SettingsBtn.MouseButton1Click:Connect(function()
	State.settingsOpen = not State.settingsOpen
	SettingsPanel.Visible = State.settingsOpen
	PagesContainer.Visible = not State.settingsOpen
	if State.settingsOpen then
		SettingsBtn.TextColor3 = ActiveTheme
		notify("⚙ Настройки открыты", ActiveTheme)
	else
		SettingsBtn.TextColor3 = Color3.fromRGB(180,180,180)
	end
end)

-- HOTKEYS
UIS.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if inp.KeyCode == Enum.KeyCode.V then
		State.menuOpen = not State.menuOpen
		MainFrame.Visible = State.menuOpen
	elseif inp.KeyCode == Enum.KeyCode.E then
		State.flyWidgetOpen = not State.flyWidgetOpen
		FlyWidget.Visible = State.flyWidgetOpen
	elseif inp.KeyCode == Enum.KeyCode.F then
		State.flyEnabled = not State.flyEnabled
		if State.flyEnabled then
			startFly()
			FlyStatusLbl.Text = "● ВКЛ"
			FlyStatusLbl.TextColor3 = ActiveTheme
		else
			stopFly()
			FlyStatusLbl.Text = "● ВЫКЛ"
			FlyStatusLbl.TextColor3 = Color3.fromRGB(255,80,80)
		end
		notify(State.flyEnabled and "✈ Полёт включён" or "✈ Полёт выключен",
			State.flyEnabled and ActiveTheme or Color3.fromRGB(255,80,80))
	elseif inp.KeyCode == Enum.KeyCode.Delete then
		ScreenGui:Destroy()
	end
end)

-- CHARACTER RESPAWN HANDLING
Player.CharacterAdded:Connect(function(c)
	Character = c
	Humanoid = c:WaitForChild("Humanoid")
	RootPart = c:WaitForChild("HumanoidRootPart")
	HRP = RootPart
	task.wait(0.5)
	if State.walkSpeed ~= 16 then Humanoid.WalkSpeed = State.walkSpeed end
	if State.jumpPower ~= 50 then Humanoid.JumpPower = State.jumpPower end
	if State.flyEnabled then startFly() end
end)

-- ICON PULSE ANIMATION
task.spawn(function()
	while task.wait(1.5) do
		if IconFrame and IconFrame.Parent then
			TweenService:Create(IconGlow, TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.4
			}):Play()
			task.wait(0.75)
			TweenService:Create(IconGlow, TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.8
			}):Play()
		end
	end
end)

-- INITIAL PAGE
switchPage("Игрок")
notify("✦ Yarik World Hub загружен!", ActiveTheme)
