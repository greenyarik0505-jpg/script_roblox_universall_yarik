local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local function getChar() return Player.Character end
local function getHRP() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c = getChar() return c and c:FindFirstChildOfClass("Humanoid") end

local GREEN = Color3.fromRGB(0, 255, 127)
local GREEN2 = Color3.fromRGB(0, 180, 80)
local BG = Color3.fromRGB(10, 10, 16)
local BG2 = Color3.fromRGB(14, 14, 22)
local BG3 = Color3.fromRGB(18, 18, 28)

local State = {
	menuOpen = false,
	flyOn = false,
	noclipOn = false,
	infJumpOn = false,
	doubleJumpOn = false,
	espOn = false,
	fullbrightOn = false,
	rainbowOn = false,
	flySpeed = 60,
	flyUp = false,
	flyDown = false,
	canDoubleJump = false,
	prevJumpState = nil,
	iconDragging = false,
	iconMoved = false,
	iconDragStart = nil,
	iconStartPos = nil,
	menuDragging = false,
	menuDragStart = nil,
	menuStartPos = nil,
	fwDragging = false,
	fwDragStart = nil,
	fwStartPos = nil,
	flyWidgetVisible = false,
}

local BodyVel, BodyGyro
local espObjects = {}
local flyConn, noclipConn, rainbowConn, fullbrightConn

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YarikWorldHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 99999
ScreenGui.IgnoreGuiInset = true
local ok = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ok then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local function mkCorner(p, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r or 10) c.Parent = p return c end
local function mkStroke(p, col, th) local s = Instance.new("UIStroke") s.Color = col or GREEN s.Thickness = th or 1.5 s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border s.Parent = p return s end
local function mkPadding(p, t, b, l, r) local pad = Instance.new("UIPadding") pad.PaddingTop = UDim.new(0, t or 6) pad.PaddingBottom = UDim.new(0, b or 6) pad.PaddingLeft = UDim.new(0, l or 8) pad.PaddingRight = UDim.new(0, r or 8) pad.Parent = p return pad end
local function mkList(p, spacing) local l = Instance.new("UIListLayout") l.SortOrder = Enum.SortOrder.LayoutOrder l.Padding = UDim.new(0, spacing or 6) l.Parent = p return l end

local function notify(txt, col)
	local nf = Instance.new("Frame")
	nf.Size = UDim2.new(0, 260, 0, 44)
	nf.Position = UDim2.new(1, -280, 1, 60)
	nf.BackgroundColor3 = BG
	nf.BorderSizePixel = 0
	nf.ZIndex = 500
	nf.Parent = ScreenGui
	mkCorner(nf, 10)
	mkStroke(nf, col or GREEN, 1.5)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -10, 1, 0)
	lbl.Position = UDim2.new(0, 10, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = txt
	lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
	lbl.TextSize = 13
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 501
	lbl.Parent = nf
	TweenService:Create(nf, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -280, 1, -56)}):Play()
	task.delay(2.2, function()
		TweenService:Create(nf, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, -280, 1, 60)}):Play()
		task.delay(0.3, function() nf:Destroy() end)
	end)
end

-- ICON
local IconFrame = Instance.new("Frame")
IconFrame.Name = "Icon"
IconFrame.Size = UDim2.new(0, 54, 0, 54)
IconFrame.Position = UDim2.new(0, 20, 0.5, -27)
IconFrame.BackgroundColor3 = BG
IconFrame.BorderSizePixel = 0
IconFrame.ZIndex = 200
IconFrame.Active = true
IconFrame.Parent = ScreenGui
mkCorner(IconFrame, 14)
mkStroke(IconFrame, GREEN, 2)

local IconGlow = Instance.new("ImageLabel")
IconGlow.Size = UDim2.new(1, 20, 1, 20)
IconGlow.Position = UDim2.new(0, -10, 0, -10)
IconGlow.BackgroundTransparency = 1
IconGlow.Image = "rbxassetid://5028857084"
IconGlow.ImageColor3 = GREEN
IconGlow.ImageTransparency = 0.6
IconGlow.ZIndex = 199
IconGlow.Parent = IconFrame

local IconLabel = Instance.new("TextButton")
IconLabel.Size = UDim2.new(1, 0, 1, 0)
IconLabel.BackgroundTransparency = 1
IconLabel.Text = "YW"
IconLabel.TextColor3 = GREEN
IconLabel.TextSize = 16
IconLabel.Font = Enum.Font.GothamBold
IconLabel.ZIndex = 201
IconLabel.Parent = IconFrame

-- ICON DRAG & CLICK
IconLabel.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		State.iconDragging = true
		State.iconMoved = false
		State.iconDragStart = inp.Position
		State.iconStartPos = IconFrame.Position
	end
end)

UIS.InputChanged:Connect(function(inp)
	if State.iconDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = inp.Position - State.iconDragStart
		if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
			State.iconMoved = true
		end
		if State.iconMoved then
			local vp = Camera.ViewportSize
			local nx = math.clamp(State.iconStartPos.X.Offset + delta.X, 0, vp.X - 54)
			local ny = math.clamp(State.iconStartPos.Y.Offset + delta.Y, 0, vp.Y - 54)
			IconFrame.Position = UDim2.new(0, nx, 0, ny)
		end
	end
end)

UIS.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		if State.iconDragging then
			if not State.iconMoved then
				State.menuOpen = not State.menuOpen
				local MainFrame = ScreenGui:FindFirstChild("MainFrame")
				if MainFrame then
					MainFrame.Visible = State.menuOpen
					if State.menuOpen then
						TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 560, 0, 420)}):Play()
					end
				end
			end
			State.iconDragging = false
			State.iconMoved = false
		end
	end
end)

-- GLOW PULSE
task.spawn(function()
	while true do
		task.wait(1.2)
		if IconGlow and IconGlow.Parent then
			TweenService:Create(IconGlow, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.3}):Play()
			task.wait(0.8)
			TweenService:Create(IconGlow, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.75}):Play()
		end
	end
end)

-- MAIN MENU
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 420)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -210)
MainFrame.BackgroundColor3 = BG
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ZIndex = 10
MainFrame.Active = true
MainFrame.Parent = ScreenGui
mkCorner(MainFrame, 16)
mkStroke(MainFrame, GREEN, 1.8)

local MenuGrad = Instance.new("UIGradient")
MenuGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 22)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 14))
})
MenuGrad.Rotation = 135
MenuGrad.Parent = MainFrame

-- TITLEBAR
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 46)
TitleBar.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 11
TitleBar.Active = true
TitleBar.Parent = MainFrame
mkCorner(TitleBar, 16)
local TBFix = Instance.new("Frame")
TBFix.Size = UDim2.new(1, 0, 0.5, 0)
TBFix.Position = UDim2.new(0, 0, 0.5, 0)
TBFix.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
TBFix.BorderSizePixel = 0
TBFix.ZIndex = 11
TBFix.Parent = TitleBar

local TitleAccent = Instance.new("Frame")
TitleAccent.Size = UDim2.new(0, 4, 0, 26)
TitleAccent.Position = UDim2.new(0, 14, 0.5, -13)
TitleAccent.BackgroundColor3 = GREEN
TitleAccent.BorderSizePixel = 0
TitleAccent.ZIndex = 12
TitleAccent.Parent = TitleBar
mkCorner(TitleAccent, 4)

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(0, 250, 1, 0)
TitleLbl.Position = UDim2.new(0, 26, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "Yarik World Hub"
TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLbl.TextSize = 17
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.ZIndex = 12
TitleLbl.Parent = TitleBar

local VerLbl = Instance.new("TextLabel")
VerLbl.Size = UDim2.new(0, 120, 1, 0)
VerLbl.Position = UDim2.new(0, 26, 0.38, 0)
VerLbl.BackgroundTransparency = 1
VerLbl.Text = "v3.0 Universal"
VerLbl.TextColor3 = Color3.fromRGB(0, 200, 100)
VerLbl.TextSize = 10
VerLbl.Font = Enum.Font.Gotham
VerLbl.TextXAlignment = Enum.TextXAlignment.Left
VerLbl.ZIndex = 12
VerLbl.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 8, 8)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 13
CloseBtn.Parent = TitleBar
mkCorner(CloseBtn, 8)
mkStroke(CloseBtn, Color3.fromRGB(255, 80, 80), 1)
CloseBtn.MouseButton1Click:Connect(function()
	State.menuOpen = false
	MainFrame.Visible = false
end)

-- MENU DRAG
TitleBar.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		State.menuDragging = true
		State.menuDragStart = inp.Position
		State.menuStartPos = MainFrame.Position
	end
end)
TitleBar.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		State.menuDragging = false
	end
end)
UIS.InputChanged:Connect(function(inp)
	if State.menuDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
		local d = inp.Position - State.menuDragStart
		MainFrame.Position = UDim2.new(
			State.menuStartPos.X.Scale, State.menuStartPos.X.Offset + d.X,
			State.menuStartPos.Y.Scale, State.menuStartPos.Y.Offset + d.Y
		)
	end
end)

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -46)
Sidebar.Position = UDim2.new(0, 0, 0, 46)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 11
Sidebar.Parent = MainFrame
local SBCorner = Instance.new("UICorner")
SBCorner.CornerRadius = UDim.new(0, 16)
SBCorner.Parent = Sidebar
local SBFix = Instance.new("Frame")
SBFix.Size = UDim2.new(0, 16, 1, 0)
SBFix.Position = UDim2.new(1, -16, 0, 0)
SBFix.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
SBFix.BorderSizePixel = 0
SBFix.ZIndex = 11
SBFix.Parent = Sidebar
local SBFix2 = Instance.new("Frame")
SBFix2.Size = UDim2.new(1, 0, 0, 16)
SBFix2.Position = UDim2.new(0, 0, 1, -16)
SBFix2.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
SBFix2.BorderSizePixel = 0
SBFix2.ZIndex = 11
SBFix2.Parent = Sidebar

local SBScroll = Instance.new("ScrollingFrame")
SBScroll.Size = UDim2.new(1, 0, 1, -8)
SBScroll.Position = UDim2.new(0, 0, 0, 6)
SBScroll.BackgroundTransparency = 1
SBScroll.BorderSizePixel = 0
SBScroll.ScrollBarThickness = 0
SBScroll.ZIndex = 12
SBScroll.Parent = Sidebar
mkList(SBScroll, 4)
mkPadding(SBScroll, 6, 6, 8, 8)

-- CONTENT AREA
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -138, 1, -54)
ContentArea.Position = UDim2.new(0, 136, 0, 52)
ContentArea.BackgroundColor3 = Color3.fromRGB(11, 11, 17)
ContentArea.BorderSizePixel = 0
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame
mkCorner(ContentArea, 12)

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, 0, 1, 0)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 3
ContentScroll.ScrollBarImageColor3 = GREEN
ContentScroll.ZIndex = 12
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentScroll.Parent = ContentArea
mkList(ContentScroll, 8)
mkPadding(ContentScroll, 8, 8, 10, 10)

-- SIDEBAR TABS
local tabs = {"⚡ Игрок", "✈ Полёт", "👁 Визуал", "🌍 Мир", "⚔ Бой", "🔍 Поиск", "⚙ Настройки"}
local tabButtons = {}
local currentTab = nil

local function clearContent()
	for _, v in ipairs(ContentScroll:GetChildren()) do
		if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
			v:Destroy()
		end
	end
end

local function makeSectionLabel(text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 22)
	lbl.BackgroundTransparency = 1
	lbl.Text = "  " .. text
	lbl.TextColor3 = GREEN
	lbl.TextSize = 11
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 13
	lbl.Parent = ContentScroll
	return lbl
end

local function makeToggle(parent, labelText, startState, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 38)
	row.BackgroundColor3 = BG2
	row.BorderSizePixel = 0
	row.ZIndex = 13
	row.Parent = parent
	mkCorner(row, 8)
	mkStroke(row, Color3.fromRGB(30, 30, 48), 1)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -56, 1, 0)
	lbl.Position = UDim2.new(0, 12, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextColor3 = Color3.fromRGB(210, 210, 210)
	lbl.TextSize = 13
	lbl.Font = Enum.Font.Gotham
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 14
	lbl.Parent = row

	local toggleBG = Instance.new("Frame")
	toggleBG.Size = UDim2.new(0, 40, 0, 22)
	toggleBG.Position = UDim2.new(1, -50, 0.5, -11)
	toggleBG.BackgroundColor3 = startState and GREEN2 or Color3.fromRGB(40, 40, 60)
	toggleBG.BorderSizePixel = 0
	toggleBG.ZIndex = 14
	toggleBG.Parent = row
	mkCorner(toggleBG, 11)

	local toggleKnob = Instance.new("Frame")
	toggleKnob.Size = UDim2.new(0, 16, 0, 16)
	toggleKnob.Position = startState and UDim2.new(0, 21, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
	toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	toggleKnob.BorderSizePixel = 0
	toggleKnob.ZIndex = 15
	toggleKnob.Parent = toggleBG
	mkCorner(toggleKnob, 8)

	local state = startState
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.ZIndex = 16
	btn.Parent = row
	btn.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(toggleBG, TweenInfo.new(0.2), {BackgroundColor3 = state and GREEN2 or Color3.fromRGB(40, 40, 60)}):Play()
		TweenService:Create(toggleKnob, TweenInfo.new(0.2), {Position = state and UDim2.new(0, 21, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
		callback(state)
	end)
	return row
end

local function makeSlider(parent, labelText, minVal, maxVal, defVal, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 54)
	row.BackgroundColor3 = BG2
	row.BorderSizePixel = 0
	row.ZIndex = 13
	row.Parent = parent
	mkCorner(row, 8)
	mkStroke(row, Color3.fromRGB(30, 30, 48), 1)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -50, 0, 20)
	lbl.Position = UDim2.new(0, 12, 0, 6)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextColor3 = Color3.fromRGB(210, 210, 210)
	lbl.TextSize = 12
	lbl.Font = Enum.Font.Gotham
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 14
	lbl.Parent = row

	local valLbl = Instance.new("TextLabel")
	valLbl.Size = UDim2.new(0, 44, 0, 20)
	valLbl.Position = UDim2.new(1, -50, 0, 6)
	valLbl.BackgroundTransparency = 1
	valLbl.Text = tostring(defVal)
	valLbl.TextColor3 = GREEN
	valLbl.TextSize = 12
	valLbl.Font = Enum.Font.GothamBold
	valLbl.TextXAlignment = Enum.TextXAlignment.Right
	valLbl.ZIndex = 14
	valLbl.Parent = row

	local sliderBG = Instance.new("Frame")
	sliderBG.Size = UDim2.new(1, -20, 0, 6)
	sliderBG.Position = UDim2.new(0, 10, 0, 36)
	sliderBG.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
	sliderBG.BorderSizePixel = 0
	sliderBG.ZIndex = 14
	sliderBG.Parent = row
	mkCorner(sliderBG, 3)

	local pct = (defVal - minVal) / (maxVal - minVal)
	local sliderFill = Instance.new("Frame")
	sliderFill.Size = UDim2.new(pct, 0, 1, 0)
	sliderFill.BackgroundColor3 = GREEN
	sliderFill.BorderSizePixel = 0
	sliderFill.ZIndex = 15
	sliderFill.Parent = sliderBG
	mkCorner(sliderFill, 3)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(pct, -7, 0.5, -7)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.ZIndex = 16
	knob.Parent = sliderBG
	mkCorner(knob, 7)

	local dragging = false
	local inputArea = Instance.new("TextButton")
	inputArea.Size = UDim2.new(1, 0, 0, 24)
	inputArea.Position = UDim2.new(0, 0, 0, -9)
	inputArea.BackgroundTransparency = 1
	inputArea.Text = ""
	inputArea.ZIndex = 17
	inputArea.Parent = sliderBG

	local function updateSlider(mouseX)
		local abs = sliderBG.AbsolutePosition.X
		local wid = sliderBG.AbsoluteSize.X
		local p = math.clamp((mouseX - abs) / wid, 0, 1)
		local val = math.floor(minVal + (maxVal - minVal) * p)
		sliderFill.Size = UDim2.new(p, 0, 1, 0)
		knob.Position = UDim2.new(p, -7, 0.5, -7)
		valLbl.Text = tostring(val)
		callback(val)
	end

	inputArea.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateSlider(inp.Position.X)
		end
	end)
	UIS.InputChanged:Connect(function(inp)
		if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(inp.Position.X)
		end
	end)
	UIS.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	return row
end

local function makeButton(parent, txt, col, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 38)
	btn.BackgroundColor3 = BG2
	btn.BorderSizePixel = 0
	btn.Text = txt
	btn.TextColor3 = col or GREEN
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamBold
	btn.ZIndex = 13
	btn.Parent = parent
	mkCorner(btn, 8)
	mkStroke(btn, col or GREEN, 1.2)
	btn.MouseButton1Click:Connect(callback)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 40, 28)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = BG2}):Play()
	end)
	return btn
end

-- FLY LOGIC
local function startFly()
	if flyConn then flyConn:Disconnect() end
	local hrp = getHRP()
	local hum = getHum()
	if not hrp or not hum then return end
	hum.PlatformStand = true
	if BodyVel then BodyVel:Destroy() end
	if BodyGyro then BodyGyro:Destroy() end
	BodyVel = Instance.new("BodyVelocity")
	BodyVel.Velocity = Vector3.new(0, 0, 0)
	BodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	BodyVel.P = 10000
	BodyVel.Parent = hrp
	BodyGyro = Instance.new("BodyGyro")
	BodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	BodyGyro.P = 5000
	BodyGyro.D = 200
	BodyGyro.CFrame = hrp.CFrame
	BodyGyro.Parent = hrp
	flyConn = RS.Heartbeat:Connect(function()
		local lhrp = getHRP()
		if not lhrp or not State.flyOn then return end
		local cf = Camera.CFrame
		local dir = Vector3.new(0, 0, 0)
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) or State.flyUp then dir = dir + Vector3.new(0, 1, 0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or State.flyDown then dir = dir - Vector3.new(0, 1, 0) end
		if dir.Magnitude > 0 then dir = dir.Unit end
		if BodyVel and BodyVel.Parent then BodyVel.Velocity = dir * State.flySpeed end
		if BodyGyro and BodyGyro.Parent then BodyGyro.CFrame = cf end
	end)
end

local function stopFly()
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if BodyVel then BodyVel:Destroy() BodyVel = nil end
	if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
	local hum = getHum()
	if hum then hum.PlatformStand = false end
end

-- NOCLIP LOGIC
local function startNoclip()
	if noclipConn then noclipConn:Disconnect() end
	noclipConn = RS.Stepped:Connect(function()
		local c = getChar()
		if not c then return end
		for _, p in ipairs(c:GetDescendants()) do
			if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
		end
	end)
end
local function stopNoclip()
	if noclipConn then noclipConn:Disconnect() noclipConn = nil end
	local c = getChar()
	if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
end

-- ESP LOGIC
local function updateESP()
	for _, v in pairs(espObjects) do pcall(function() v:Destroy() end) end
	espObjects = {}
	if not State.espOn then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player and plr.Character then
			local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local box = Instance.new("SelectionBox")
				box.Adornee = plr.Character
				box.Color3 = GREEN
				box.LineThickness = 0.05
				box.SurfaceTransparency = 0.8
				box.SurfaceColor3 = GREEN
				box.Parent = ScreenGui
				table.insert(espObjects, box)
				local billboard = Instance.new("BillboardGui")
				billboard.Adornee = hrp
				billboard.Size = UDim2.new(0, 100, 0, 30)
				billboard.StudsOffset = Vector3.new(0, 3.2, 0)
				billboard.AlwaysOnTop = true
				billboard.Parent = ScreenGui
				local namelbl = Instance.new("TextLabel")
				namelbl.Size = UDim2.new(1, 0, 1, 0)
				namelbl.BackgroundTransparency = 1
				namelbl.Text = plr.DisplayName
				namelbl.TextColor3 = GREEN
				namelbl.TextSize = 13
				namelbl.Font = Enum.Font.GothamBold
				namelbl.TextStrokeTransparency = 0.4
				namelbl.Parent = billboard
				table.insert(espObjects, billboard)
			end
		end
	end
end

-- INF JUMP
UIS.JumpRequest:Connect(function()
	if not State.infJumpOn then return end
	local hum = getHum()
	if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- DOUBLE JUMP
RS.Heartbeat:Connect(function()
	local hum = getHum()
	if not hum or not State.doubleJumpOn then return end
	local cur = hum:GetState()
	if State.prevJumpState == Enum.HumanoidStateType.Jumping and cur == Enum.HumanoidStateType.Freefall then
		State.canDoubleJump = true
	end
	if cur == Enum.HumanoidStateType.Landed then State.canDoubleJump = false end
	State.prevJumpState = cur
end)

UIS.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if inp.KeyCode == Enum.KeyCode.Space and State.doubleJumpOn then
		local hum = getHum()
		if hum and hum:GetState() == Enum.HumanoidStateType.Freefall and State.canDoubleJump then
			State.canDoubleJump = false
			local hrp = getHRP()
			if hrp then
				local bv = Instance.new("BodyVelocity")
				bv.Velocity = Vector3.new(hrp.Velocity.X, 55, hrp.Velocity.Z)
				bv.MaxForce = Vector3.new(0, math.huge, 0)
				bv.P = math.huge
				bv.Parent = hrp
				task.delay(0.12, function() bv:Destroy() end)
			end
		end
	end
	if inp.KeyCode == Enum.KeyCode.V and not gp then
		State.menuOpen = not State.menuOpen
		MainFrame.Visible = State.menuOpen
	end
end)

-- TAB CONTENT BUILDERS
local function buildPlayerTab()
	clearContent()
	makeSectionLabel("ДВИЖЕНИЕ")
	makeSlider(ContentScroll, "Скорость ходьбы", 16, 500, 16, function(v)
		local hum = getHum()
		if hum then hum.WalkSpeed = v end
	end)
	makeSlider(ContentScroll, "Высота прыжка", 50, 400, 50, function(v)
		local hum = getHum()
		if hum then hum.JumpPower = v end
	end)
	makeSectionLabel("СПОСОБНОСТИ")
	makeToggle(ContentScroll, "Ноклип (сквозь стены)", false, function(on)
		State.noclipOn = on
		if on then startNoclip() else stopNoclip() end
		notify(on and "✅ Ноклип включён" or "❌ Ноклип выключен", on and GREEN or Color3.fromRGB(255, 80, 80))
	end)
	makeToggle(ContentScroll, "Бесконечный прыжок", false, function(on)
		State.infJumpOn = on
		notify(on and "✅ Инф. прыжок включён" or "❌ Инф. прыжок выключен", on and GREEN or Color3.fromRGB(255, 80, 80))
	end)
	makeToggle(ContentScroll, "Двойной прыжок", false, function(on)
		State.doubleJumpOn = on
		State.canDoubleJump = false
		notify(on and "✅ Двойной прыжок вкл" or "❌ Двойной прыжок выкл", on and GREEN or Color3.fromRGB(255, 80, 80))
	end)
	makeToggle(ContentScroll, "Спинбот (крутиться)", false, function(on)
		if on then
			_G.spinConn = RS.Heartbeat:Connect(function()
				local hrp = getHRP()
				if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(8), 0) end
			end)
		else
			if _G.spinConn then _G.spinConn:Disconnect() _G.spinConn = nil end
		end
	end)
	makeSectionLabel("ЗДОРОВЬЕ")
	makeButton(ContentScroll, "❤ Восстановить здоровье", GREEN, function()
		local hum = getHum()
		if hum then hum.Health = hum.MaxHealth notify("❤ Здоровье восстановлено", GREEN) end
	end)
	makeToggle(ContentScroll, "Режим бога (MaxHealth)", false, function(on)
		local hum = getHum()
		if hum then hum.MaxHealth = on and math.huge or 100 hum.Health = hum.MaxHealth end
		notify(on and "✅ Бог-мод включён" or "❌ Бог-мод выключен", on and GREEN or Color3.fromRGB(255, 80, 80))
	end)
end

local function buildFlyTab()
	clearContent()
	makeSectionLabel("УПРАВЛЕНИЕ ПОЛЁТОМ")
	local speedVal = State.flySpeed
	makeSlider(ContentScroll, "Скорость полёта", 10, 300, speedVal, function(v)
		State.flySpeed = v
		if BodyVel then BodyVel.P = v * 180 end
	end)
	makeSectionLabel("СТАТУС")
	makeToggle(ContentScroll, "✈ Полёт", State.flyOn, function(on)
		State.flyOn = on
		if on then startFly() else stopFly() end
		notify(on and "✅ Полёт включён" or "❌ Полёт выключен", on and GREEN or Color3.fromRGB(255, 80, 80))
		local fw = ScreenGui:FindFirstChild("FlyWidget")
		if fw then fw.Visible = on end
		State.flyWidgetVisible = on
	end)
	makeSectionLabel("ПОДСКАЗКА")
	local hint = Instance.new("TextLabel")
	hint.Size = UDim2.new(1, 0, 0, 60)
	hint.BackgroundColor3 = Color3.fromRGB(10, 20, 15)
	hint.BackgroundTransparency = 0
	hint.Text = "W/A/S/D — движение\nSpace — вверх  |  Shift — вниз\nИли кнопки ▲▼ в виджете"
	hint.TextColor3 = Color3.fromRGB(150, 255, 180)
	hint.TextSize = 12
	hint.Font = Enum.Font.Gotham
	hint.TextWrapped = true
	hint.ZIndex = 13
	hint.Parent = ContentScroll
	mkCorner(hint, 8)
	mkStroke(hint, GREEN2, 1)
end

local function buildVisualTab()
	clearContent()
	makeSectionLabel("ВИЗУАЛЬНЫЕ ЭФФЕКТЫ")
	makeToggle(ContentScroll, "ESP (видеть игроков)", false, function(on)
		State.espOn = on
		updateESP()
		notify(on and "✅ ESP включён" or "❌ ESP выключен", on and GREEN or Color3.fromRGB(255, 80, 80))
	end)
	makeToggle(ContentScroll, "Fullbright (яркость)", false, function(on)
		State.fullbrightOn = on
		if on then
			game:GetService("Lighting").Brightness = 10
			game:GetService("Lighting").GlobalShadows = false
			game:GetService("Lighting").FogEnd = 999999
			notify("✅ Fullbright включён", GREEN)
		else
			game:GetService("Lighting").Brightness = 2
			game:GetService("Lighting").GlobalShadows = true
			game:GetService("Lighting").FogEnd = 100000
			notify("❌ Fullbright выключен", Color3.fromRGB(255, 80, 80))
		end
	end)
	makeToggle(ContentScroll, "Убрать туман", false, function(on)
		game:GetService("Lighting").FogEnd = on and 999999 or 100000
		game:GetService("Lighting").FogStart = on and 999999 or 0
		notify(on and "✅ Туман убран" or "❌ Туман возвращён", on and GREEN or Color3.fromRGB(255, 80, 80))
	end)
	makeToggle(ContentScroll, "Радужный персонаж", false, function(on)
		State.rainbowOn = on
		if rainbowConn then rainbowConn:Disconnect() rainbowConn = nil end
		if on then
			rainbowConn = RS.Heartbeat:Connect(function()
				local c = getChar()
				if not c then return end
				local t = tick() * 2
				for _, p in ipairs(c:GetDescendants()) do
					if p:IsA("BasePart") then
						p.Color = Color3.fromHSV(t % 1, 1, 1)
					end
				end
			end)
		else
			local c = getChar()
			if c then
				for _, p in ipairs(c:GetDescendants()) do
					if p:IsA("BasePart") then p.Color = Color3.fromRGB(163, 162, 165) end
				end
			end
		end
		notify(on and "✅ Радуга включена" or "❌ Радуга выключена", on and GREEN or Color3.fromRGB(255, 80, 80))
	end)
	makeToggle(ContentScroll, "Невидимость", false, function(on)
		local c = getChar()
		if not c then return end
		for _, p in ipairs(c:GetDescendants()) do
			if p:IsA("BasePart") then p.LocalTransparencyModifier = on and 1 or 0 end
		end
		notify(on and "✅ Невидимость вкл" or "❌ Невидимость выкл", on and GREEN or Color3.fromRGB(255, 80, 80))
	end)
	makeSectionLabel("КАМЕРА")
	makeSlider(ContentScroll, "Поле зрения (FOV)", 70, 120, 70, function(v)
		Camera.FieldOfView = v
	end)
end

local function buildWorldTab()
	clearContent()
	makeSectionLabel("ТЕЛЕПОРТ")
	makeToggle(ContentScroll, "Клик-телепорт (ПКМ)", false, function(on)
		if on then
			_G.clickTPConn = UIS.InputBegan:Connect(function(inp, gp)
				if gp then return end
				if inp.UserInputType == Enum.UserInputType.MouseButton2 then
					local result = workspace:Raycast(Camera.CFrame.Position, Camera:ScreenPointToRay(inp.Position.X, inp.Position.Y).Direction * 500)
					if result then
						local hrp = getHRP()
						if hrp then hrp.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0)) end
					end
				end
			end)
		else
			if _G.clickTPConn then _G.clickTPConn:Disconnect() _G.clickTPConn = nil end
		end
		notify(on and "✅ Клик-ТП включён" or "❌ Клик-ТП выключен", on and GREEN or Color3.fromRGB(255, 80, 80))
	end)
	makeSectionLabel("ТЕЛЕПОРТ К ИГРОКУ")
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player then
			makeButton(ContentScroll, "➤ " .. plr.DisplayName, GREEN, function()
				local hrp = getHRP()
				local tchar = plr.Character
				if hrp and tchar then
					local thrp = tchar:FindFirstChild("HumanoidRootPart")
					if thrp then
						hrp.CFrame = thrp.CFrame + Vector3.new(3, 0, 0)
						notify("✅ ТП к " .. plr.DisplayName, GREEN)
					end
				end
			end)
		end
	end
	makeSectionLabel("ОПТИМИЗАЦИЯ")
	makeButton(ContentScroll, "⚡ Буст FPS (убрать частицы)", GREEN, function()
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
				v.Enabled = false
			end
		end
		notify("⚡ FPS Буст применён", GREEN)
	end)
end

local function buildFightTab()
	clearContent()
	makeSectionLabel("БОЕВЫЕ ФУНКЦИИ")
	makeSlider(ContentScroll, "Хитбокс (размер)", 1, 20, 1, function(v)
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= Player and plr.Character then
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp then hrp.Size = Vector3.new(v, v, v) end
			end
		end
	end)
	makeToggle(ContentScroll, "Аимлок (плавный)", false, function(on)
		if on then
			_G.aimlockConn = RS.Heartbeat:Connect(function()
				local closest, closestDist = nil, math.huge
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= Player and plr.Character then
						local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
						if hrp then
							local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
							if dist < closestDist then closestDist = dist closest = hrp end
						end
					end
				end
				if closest then
					Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closest.Position), 0.1)
				end
			end)
		else
			if _G.aimlockConn then _G.aimlockConn:Disconnect() _G.aimlockConn = nil end
		end
		notify(on and "✅ Аимлок включён" or "❌ Аимлок выключен", on and GREEN or Color3.fromRGB(255, 80, 80))
	end)
	makeToggle(ContentScroll, "Авто-кликер", false, function(on)
		if on then
			_G.autoClickConn = RS.Heartbeat:Connect(function()
				if _G.autoClickOn then
					mouse1click()
				end
			end)
			_G.autoClickOn = true
		else
			_G.autoClickOn = false
			if _G.autoClickConn then _G.autoClickConn:Disconnect() _G.autoClickConn = nil end
		end
	end)
end

local scriptDatabase = {
	{name = "Infinite Yield", desc = "Мощный admin panel", url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
	{name = "Dex Explorer", desc = "Обозреватель инстансов", url = "https://raw.githubusercontent.com/LorekeeperZinnia/Dex/master/dex.lua"},
	{name = "Simple Spy", desc = "Remote события spy", url = "https://raw.githubusercontent.com/exxtremesayan/simple-spy/main/source"},
	{name = "Hydroxide", desc = "Remote spy и дамп", url = "https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/src/init.lua"},
	{name = "Dark Dex", desc = "Dark UI Explorer", url = "https://raw.githubusercontent.com/4x8Matrix/Dex/master/init.lua"},
	{name = "Remote Spy Lite", desc = "Простой remote spy", url = "https://raw.githubusercontent.com/exxtremesayan/simple-spy/main/source"},
	{name = "Fly Script", desc = "Универсальный полёт", url = "https://pastebin.com/raw/fJRRuHnK"},
	{name = "BTools", desc = "Build Tools для workspace", url = "https://pastebin.com/raw/bc5bFNvS"},
	{name = "Namecheap", desc = "Grab RemoteFunction", url = "https://pastebin.com/raw/0B4r2AQM"},
	{name = "ESP Universal", desc = "ESP для любой игры", url = "https://pastebin.com/raw/A2bKhJzp"},
	{name = "Noclip Universal", desc = "Сквозь стены", url = "https://pastebin.com/raw/nNuT5pKe"},
	{name = "WalkSpeed GUI", desc = "Скорость + прыжок GUI", url = "https://pastebin.com/raw/Ld3TRrEn"},
	{name = "God Mode", desc = "Бессмертие", url = "https://pastebin.com/raw/h4CLmePZ"},
	{name = "Anti AFK", desc = "Анти-кик от AFK", url = "https://pastebin.com/raw/8i9jLBRS"},
	{name = "Chat Bypass", desc = "Обход фильтра чата", url = "https://pastebin.com/raw/CmJ5yLBi"},
}

local function buildSearchTab()
	clearContent()
	makeSectionLabel("ПОИСК СКРИПТОВ")
	local searchBox = Instance.new("TextBox")
	searchBox.Size = UDim2.new(1, 0, 0, 36)
	searchBox.BackgroundColor3 = BG3
	searchBox.BorderSizePixel = 0
	searchBox.PlaceholderText = "🔍 Введите название скрипта..."
	searchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 130)
	searchBox.Text = ""
	searchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
	searchBox.TextSize = 13
	searchBox.Font = Enum.Font.Gotham
	searchBox.ClearTextOnFocus = false
	searchBox.ZIndex = 13
	searchBox.Parent = ContentScroll
	mkCorner(searchBox, 8)
	mkStroke(searchBox, GREEN, 1.5)
	mkPadding(searchBox, 0, 0, 10, 0)

	local resultsContainer = Instance.new("Frame")
	resultsContainer.Size = UDim2.new(1, 0, 0, 0)
	resultsContainer.AutomaticSize = Enum.AutomaticSize.Y
	resultsContainer.BackgroundTransparency = 1
	resultsContainer.BorderSizePixel = 0
	resultsContainer.ZIndex = 13
	resultsContainer.Parent = ContentScroll
	mkList(resultsContainer, 5)

	local function showResults(query)
		for _, v in ipairs(resultsContainer:GetChildren()) do
			if not v:IsA("UIListLayout") then v:Destroy() end
		end
		local q = query:lower()
		for _, script in ipairs(scriptDatabase) do
			if q == "" or script.name:lower():find(q) or script.desc:lower():find(q) then
				local card = Instance.new("Frame")
				card.Size = UDim2.new(1, 0, 0, 60)
				card.BackgroundColor3 = BG2
				card.BorderSizePixel = 0
				card.ZIndex = 14
				card.Parent = resultsContainer
				mkCorner(card, 8)
				mkStroke(card, Color3.fromRGB(0, 160, 80), 1)

				local nameL = Instance.new("TextLabel")
				nameL.Size = UDim2.new(1, -90, 0, 22)
				nameL.Position = UDim2.new(0, 10, 0, 6)
				nameL.BackgroundTransparency = 1
				nameL.Text = script.name
				nameL.TextColor3 = GREEN
				nameL.TextSize = 13
				nameL.Font = Enum.Font.GothamBold
				nameL.TextXAlignment = Enum.TextXAlignment.Left
				nameL.ZIndex = 15
				nameL.Parent = card

				local descL = Instance.new("TextLabel")
				descL.Size = UDim2.new(1, -90, 0, 18)
				descL.Position = UDim2.new(0, 10, 0, 30)
				descL.BackgroundTransparency = 1
				descL.Text = script.desc
				descL.TextColor3 = Color3.fromRGB(140, 140, 170)
				descL.TextSize = 11
				descL.Font = Enum.Font.Gotham
				descL.TextXAlignment = Enum.TextXAlignment.Left
				descL.ZIndex = 15
				descL.Parent = card

				local execBtn = Instance.new("TextButton")
				execBtn.Size = UDim2.new(0, 74, 0, 30)
				execBtn.Position = UDim2.new(1, -82, 0.5, -15)
				execBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 30)
				execBtn.BorderSizePixel = 0
				execBtn.Text = "▶ Запуск"
				execBtn.TextColor3 = GREEN
				execBtn.TextSize = 11
				execBtn.Font = Enum.Font.GothamBold
				execBtn.ZIndex = 15
				execBtn.Parent = card
				mkCorner(execBtn, 7)
				mkStroke(execBtn, GREEN, 1)

				local surl = script.url
				local sname = script.name
				execBtn.MouseButton1Click:Connect(function()
					execBtn.Text = "⌛ Загрузка"
					execBtn.TextColor3 = Color3.fromRGB(255, 200, 50)
					task.spawn(function()
						local s, e = pcall(function()
							loadstring(game:HttpGet(surl))()
						end)
						if s then
							execBtn.Text = "✅ Готово"
							execBtn.TextColor3 = GREEN
							notify("✅ " .. sname .. " запущен", GREEN)
						else
							execBtn.Text = "❌ Ошибка"
							execBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
							notify("❌ Ошибка: " .. tostring(e):sub(1, 40), Color3.fromRGB(255, 80, 80))
						end
					end)
				end)
			end
		end
	end

	showResults("")
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		showResults(searchBox.Text)
	end)
end

local function buildSettingsTab()
	clearContent()
	makeSectionLabel("ТЕМА ИНТЕРФЕЙСА")
	local themes = {
		{name = "Зелёный", color = Color3.fromRGB(0, 255, 127)},
		{name = "Синий", color = Color3.fromRGB(0, 150, 255)},
		{name = "Фиолетовый", color = Color3.fromRGB(170, 50, 255)},
		{name = "Красный", color = Color3.fromRGB(255, 60, 60)},
		{name = "Оранжевый", color = Color3.fromRGB(255, 140, 0)},
	}
	for _, th in ipairs(themes) do
		local tbtn = Instance.new("TextButton")
		tbtn.Size = UDim2.new(1, 0, 0, 36)
		tbtn.BackgroundColor3 = BG2
		tbtn.BorderSizePixel = 0
		tbtn.Text = "🎨 " .. th.name
		tbtn.TextColor3 = th.color
		tbtn.TextSize = 13
		tbtn.Font = Enum.Font.GothamBold
		tbtn.ZIndex = 13
		tbtn.Parent = ContentScroll
		mkCorner(tbtn, 8)
		mkStroke(tbtn, th.color, 1.5)
		local tc = th.color
		tbtn.MouseButton1Click:Connect(function()
			GREEN = tc
			mkStroke(MainFrame, GREEN, 1.8)
			TitleAccent.BackgroundColor3 = GREEN
			mkStroke(IconFrame, GREEN, 2)
			IconLabel.TextColor3 = GREEN
			IconGlow.ImageColor3 = GREEN
			notify("🎨 Тема изменена: " .. th.name, GREEN)
		end)
	end
	makeSectionLabel("ПРОЗРАЧНОСТЬ")
	makeSlider(ContentScroll, "Прозрачность фона", 0, 80, 0, function(v)
		MainFrame.BackgroundTransparency = v / 100
	end)
	makeSectionLabel("ГОРЯЧИЕ КЛАВИШИ")
	local keysLabel = Instance.new("TextLabel")
	keysLabel.Size = UDim2.new(1, 0, 0, 70)
	keysLabel.BackgroundColor3 = Color3.fromRGB(8, 18, 12)
	keysLabel.BackgroundTransparency = 0
	keysLabel.Text = "V — открыть/закрыть меню\nDelete — уничтожить GUI\nПКМ — клик-телепорт (при вкл.)"
	keysLabel.TextColor3 = Color3.fromRGB(130, 255, 170)
	keysLabel.TextSize = 12
	keysLabel.Font = Enum.Font.Gotham
	keysLabel.TextWrapped = true
	keysLabel.ZIndex = 13
	keysLabel.Parent = ContentScroll
	mkCorner(keysLabel, 8)
	mkStroke(keysLabel, GREEN2, 1)

	makeSectionLabel("ИНФОРМАЦИЯ")
	local infoLabel = Instance.new("TextLabel")
	infoLabel.Size = UDim2.new(1, 0, 0, 50)
	infoLabel.BackgroundColor3 = Color3.fromRGB(8, 18, 12)
	infoLabel.BackgroundTransparency = 0
	infoLabel.Text = "Yarik World Hub v3.0\nUniversal — все экзекуторы"
	infoLabel.TextColor3 = GREEN
	infoLabel.TextSize = 13
	infoLabel.Font = Enum.Font.GothamBold
	infoLabel.TextWrapped = true
	infoLabel.ZIndex = 13
	infoLabel.Parent = ContentScroll
	mkCorner(infoLabel, 8)
	mkStroke(infoLabel, GREEN, 1.5)

	makeButton(ContentScroll, "🗑 Удалить GUI (Delete)", Color3.fromRGB(255, 80, 80), function()
		ScreenGui:Destroy()
	end)
end

-- SIDEBAR BUTTONS
local tabBuilders = {
	["⚡ Игрок"] = buildPlayerTab,
	["✈ Полёт"] = buildFlyTab,
	["👁 Визуал"] = buildVisualTab,
	["🌍 Мир"] = buildWorldTab,
	["⚔ Бой"] = buildFightTab,
	["🔍 Поиск"] = buildSearchTab,
	["⚙ Настройки"] = buildSettingsTab,
}

local function switchTab(tabName)
	currentTab = tabName
	for name, btn in pairs(tabButtons) do
		if name == tabName then
			TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 50, 28)}):Play()
			btn.TextColor3 = GREEN
		else
			TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = BG2}):Play()
			btn.TextColor3 = Color3.fromRGB(160, 160, 180)
		end
	end
	if tabBuilders[tabName] then tabBuilders[tabName]() end
end

for i, tabName in ipairs(tabs) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 34)
	btn.BackgroundColor3 = BG2
	btn.BorderSizePixel = 0
	btn.Text = tabName
	btn.TextColor3 = Color3.fromRGB(160, 160, 180)
	btn.TextSize = 11
	btn.Font = Enum.Font.GothamBold
	btn.TextWrapped = true
	btn.ZIndex = 13
	btn.LayoutOrder = i
	btn.Parent = SBScroll
	mkCorner(btn, 8)
	tabButtons[tabName] = btn
	btn.MouseButton1Click:Connect(function()
		switchTab(tabName)
	end)
end
SBScroll.CanvasSize = UDim2.new(0, 0, 0, #tabs * 40)

-- FLY WIDGET (hidden until fly enabled)
local FlyWidget = Instance.new("Frame")
FlyWidget.Name = "FlyWidget"
FlyWidget.Size = UDim2.new(0, 170, 0, 240)
FlyWidget.Position = UDim2.new(1, -190, 0.5, -120)
FlyWidget.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
FlyWidget.BackgroundTransparency = 0
FlyWidget.BorderSizePixel = 0
FlyWidget.ZIndex = 100
FlyWidget.Active = true
FlyWidget.Visible = false
FlyWidget.Parent = ScreenGui
mkCorner(FlyWidget, 14)
mkStroke(FlyWidget, GREEN, 2)

local FWGrad = Instance.new("UIGradient")
FWGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 20)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 12))
})
FWGrad.Rotation = 135
FWGrad.Parent = FlyWidget

-- FLY WIDGET TITLE BAR
local FWTitle = Instance.new("Frame")
FWTitle.Size = UDim2.new(1, 0, 0, 38)
FWTitle.BackgroundColor3 = Color3.fromRGB(6, 6, 12)
FWTitle.BorderSizePixel = 0
FWTitle.ZIndex = 101
FWTitle.Active = true
FWTitle.Parent = FlyWidget
mkCorner(FWTitle, 14)
local FWTitleFix = Instance.new("Frame")
FWTitleFix.Size = UDim2.new(1, 0, 0.5, 0)
FWTitleFix.Position = UDim2.new(0, 0, 0.5, 0)
FWTitleFix.BackgroundColor3 = Color3.fromRGB(6, 6, 12)
FWTitleFix.BorderSizePixel = 0
FWTitleFix.ZIndex = 101
FWTitleFix.Parent = FWTitle

local FWTitleIcon = Instance.new("TextLabel")
FWTitleIcon.Size = UDim2.new(0, 24, 1, 0)
FWTitleIcon.Position = UDim2.new(0, 8, 0, 0)
FWTitleIcon.BackgroundTransparency = 1
FWTitleIcon.Text = "✈"
FWTitleIcon.TextColor3 = GREEN
FWTitleIcon.TextSize = 16
FWTitleIcon.Font = Enum.Font.GothamBold
FWTitleIcon.ZIndex = 102
FWTitleIcon.Parent = FWTitle

local FWTitleLbl = Instance.new("TextLabel")
FWTitleLbl.Size = UDim2.new(1, -60, 1, 0)
FWTitleLbl.Position = UDim2.new(0, 32, 0, 0)
FWTitleLbl.BackgroundTransparency = 1
FWTitleLbl.Text = "ПОЛЁТ"
FWTitleLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
FWTitleLbl.TextSize = 13
FWTitleLbl.Font = Enum.Font.GothamBold
FWTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
FWTitleLbl.ZIndex = 102
FWTitleLbl.Parent = FWTitle

local FWClose = Instance.new("TextButton")
FWClose.Size = UDim2.new(0, 24, 0, 24)
FWClose.Position = UDim2.new(1, -30, 0.5, -12)
FWClose.BackgroundColor3 = Color3.fromRGB(40, 8, 8)
FWClose.BorderSizePixel = 0
FWClose.Text = "✕"
FWClose.TextColor3 = Color3.fromRGB(255, 80, 80)
FWClose.TextSize = 11
FWClose.Font = Enum.Font.GothamBold
FWClose.ZIndex = 102
FWClose.Parent = FWTitle
mkCorner(FWClose, 6)
FWClose.MouseButton1Click:Connect(function()
	State.flyWidgetVisible = false
	FlyWidget.Visible = false
	if State.flyOn then
		State.flyOn = false
		stopFly()
		notify("❌ Полёт выключен", Color3.fromRGB(255, 80, 80))
	end
end)

-- FLY WIDGET DRAG
FWTitle.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		State.fwDragging = true
		State.fwDragStart = inp.Position
		State.fwStartPos = FlyWidget.Position
	end
end)
FWTitle.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		State.fwDragging = false
	end
end)
UIS.InputChanged:Connect(function(inp)
	if State.fwDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
		local d = inp.Position - State.fwDragStart
		local vp = Camera.ViewportSize
		local nx = math.clamp(State.fwStartPos.X.Offset + d.X, 0, vp.X - 170)
		local ny = math.clamp(State.fwStartPos.Y.Offset + d.Y, 0, vp.Y - 240)
		FlyWidget.Position = UDim2.new(0, nx, 0, ny)
	end
end)

-- FLY STATUS
local FWStatusLbl = Instance.new("TextLabel")
FWStatusLbl.Size = UDim2.new(1, 0, 0, 20)
FWStatusLbl.Position = UDim2.new(0, 0, 0, 42)
FWStatusLbl.BackgroundTransparency = 1
FWStatusLbl.Text = "● ВЫКЛ"
FWStatusLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
FWStatusLbl.TextSize = 11
FWStatusLbl.Font = Enum.Font.GothamBold
FWStatusLbl.ZIndex = 101
FWStatusLbl.Parent = FlyWidget

local FWSpeedLbl = Instance.new("TextLabel")
FWSpeedLbl.Size = UDim2.new(1, 0, 0, 16)
FWSpeedLbl.Position = UDim2.new(0, 0, 0, 62)
FWSpeedLbl.BackgroundTransparency = 1
FWSpeedLbl.Text = "Скорость: " .. State.flySpeed
FWSpeedLbl.TextColor3 = Color3.fromRGB(130, 130, 160)
FWSpeedLbl.TextSize = 10
FWSpeedLbl.Font = Enum.Font.Gotham
FWSpeedLbl.ZIndex = 101
FWSpeedLbl.Parent = FlyWidget

-- FLY WIDGET BUTTONS
local function makeFWBtn(txt, col, bgCol, px, py, pw, ph)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0, pw, 0, ph)
	f.Position = UDim2.new(0, px, 0, py)
	f.BackgroundColor3 = bgCol or BG2
	f.BorderSizePixel = 0
	f.ZIndex = 101
	f.Parent = FlyWidget
	mkCorner(f, 9)
	mkStroke(f, col or GREEN, 1.5)
	local FWGlow2 = Instance.new("UIGradient")
	FWGlow2.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 25, 20)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 10))
	})
	FWGlow2.Rotation = 135
	FWGlow2.Parent = f
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = txt
	btn.TextColor3 = col or GREEN
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamBold
	btn.ZIndex = 102
	btn.Parent = f
	btn.MouseEnter:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 40, 22)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = bgCol or BG2}):Play()
	end)
	return btn, f
end

local FWFlyBtn, FWFlyFrame = makeFWBtn("✈  ПОЛЁТ", GREEN, Color3.fromRGB(0, 25, 14), 10, 84, 150, 38)
local FWUpBtn, FWUpFrame = makeFWBtn("▲  ВВЕРХ", Color3.fromRGB(100, 255, 160), Color3.fromRGB(10, 30, 18), 10, 130, 150, 34)
local FWDownBtn, FWDownFrame = makeFWBtn("▼  ВНИЗ", Color3.fromRGB(255, 100, 100), Color3.fromRGB(30, 10, 10), 10, 172, 150, 34)
local FWMinusBtn, FWMinusFrame = makeFWBtn("−", Color3.fromRGB(255, 160, 60), Color3.fromRGB(30, 18, 6), 10, 216, 66, 30)
local FWPlusBtn, FWPlusFrame = makeFWBtn("+", Color3.fromRGB(100, 255, 160), Color3.fromRGB(6, 30, 18), 94, 216, 66, 30)

FWFlyBtn.MouseButton1Click:Connect(function()
	State.flyOn = not State.flyOn
	if State.flyOn then
		startFly()
		FWStatusLbl.Text = "● ВКЛ"
		FWStatusLbl.TextColor3 = GREEN
		TweenService:Create(FWFlyFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 50, 28)}):Play()
		notify("✅ Полёт включён", GREEN)
	else
		stopFly()
		FWStatusLbl.Text = "● ВЫКЛ"
		FWStatusLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
		TweenService:Create(FWFlyFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 25, 14)}):Play()
		notify("❌ Полёт выключен", Color3.fromRGB(255, 80, 80))
	end
end)

FWUpBtn.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then State.flyUp = true end
end)
FWUpBtn.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then State.flyUp = false end
end)
FWDownBtn.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then State.flyDown = true end
end)
FWDownBtn.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then State.flyDown = false end
end)

FWMinusBtn.MouseButton1Click:Connect(function()
	State.flySpeed = math.max(10, State.flySpeed - 10)
	FWSpeedLbl.Text = "Скорость: " .. State.flySpeed
end)
FWPlusBtn.MouseButton1Click:Connect(function()
	State.flySpeed = math.min(500, State.flySpeed + 10)
	FWSpeedLbl.Text = "Скорость: " .. State.flySpeed
end)

-- RESPAWN HANDLER
Player.CharacterAdded:Connect(function(c)
	Character = c
	task.wait(1)
	local hum = c:FindFirstChildOfClass("Humanoid")
	if hum then
		if State.flyOn then
			stopFly()
			State.flyOn = false
			FWStatusLbl.Text = "● ВЫКЛ"
			FWStatusLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
		end
		if State.noclipOn then task.wait(0.5) startNoclip() end
	end
end)

-- DELETE KEY
UIS.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if inp.KeyCode == Enum.KeyCode.Delete then
		ScreenGui:Destroy()
	end
end)

-- START
switchTab("⚡ Игрок")
notify("✅ Yarik World Hub v3.0 загружен!", GREEN)
