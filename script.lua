local Player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

local EXECUTOR_NAME = "Unknown"
local IS_MOBILE = false
local SUPPORTS_HOOKS = false
local SUPPORTS_FILES = false
local SUPPORTS_HTTP = false
local XENO = false

local function detectExecutor()
    if XENO_LOADED ~= nil or (identifyexecutor and identifyexecutor():lower():find("xeno")) then
        EXECUTOR_NAME = "Xeno"
        XENO = true
        SUPPORTS_HOOKS = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    elseif syn and syn.request then
        EXECUTOR_NAME = "Synapse X"
        SUPPORTS_HOOKS = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    elseif KRNL_LOADED then
        EXECUTOR_NAME = "KRNL"
        SUPPORTS_HOOKS = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    elseif is_sirhurt_closure then
        EXECUTOR_NAME = "Script-Ware"
        SUPPORTS_HOOKS = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    elseif getexecutorname and getexecutorname():lower():find("wave") then
        EXECUTOR_NAME = "Wave"
        SUPPORTS_HOOKS = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    elseif getexecutorname and getexecutorname():lower():find("delta") then
        EXECUTOR_NAME = "Delta"
        SUPPORTS_HOOKS = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    elseif getexecutorname and getexecutorname():lower():find("fluxus") or fluxus then
        EXECUTOR_NAME = "Fluxus"
        SUPPORTS_HOOKS = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    elseif getexecutorname and getexecutorname():lower():find("electron") then
        EXECUTOR_NAME = "Electron"
        SUPPORTS_HOOKS = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    elseif getexecutorname and getexecutorname():lower():find("sentinel") then
        EXECUTOR_NAME = "Sentinel"
        SUPPORTS_HOOKS = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    elseif getexecutorname and getexecutorname():lower():find("nihon") then
        EXECUTOR_NAME = "Nihon"
        SUPPORTS_HOOKS = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    elseif getexecutorname and getexecutorname():lower():find("celery") or celery then
        EXECUTOR_NAME = "Celery"
        SUPPORTS_HOOKS = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    elseif getexecutorname and getexecutorname():lower():find("comet") then
        EXECUTOR_NAME = "Comet"
        SUPPORTS_HOOKS = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    elseif getexecutorname and getexecutorname():lower():find("hydrogen") then
        EXECUTOR_NAME = "Hydrogen"
        IS_MOBILE = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    elseif getexecutorname and getexecutorname():lower():find("arceus") then
        EXECUTOR_NAME = "Arceus X"
        IS_MOBILE = true
        SUPPORTS_HTTP = true
    elseif getexecutorname and getexecutorname():lower():find("vegax") or getexecutorname and getexecutorname():lower():find("vega") then
        EXECUTOR_NAME = "Vega X"
    elseif getexecutorname and getexecutorname():lower():find("jjsploit") then
        EXECUTOR_NAME = "JJSploit"
    elseif getexecutorname and getexecutorname():lower():find("coco") then
        EXECUTOR_NAME = "Coco Z"
    elseif identifyexecutor then
        EXECUTOR_NAME = identifyexecutor()
        SUPPORTS_HOOKS = true
        SUPPORTS_FILES = true
        SUPPORTS_HTTP = true
    end
end

pcall(detectExecutor)

local function getGuiParent()
    if gethui then
        return gethui()
    elseif EXECUTOR_NAME == "Synapse X" and syn and syn.protect_gui then
        return CoreGui
    else
        local ok, _ = pcall(function()
            local test = Instance.new("ScreenGui")
            test.Parent = CoreGui
            test:Destroy()
        end)
        if ok then
            return CoreGui
        else
            return Player:WaitForChild("PlayerGui")
        end
    end
end

local function safeHttpGet(url)
    if syn and syn.request then
        local ok, res = pcall(syn.request, {Url = url, Method = "GET"})
        if ok and res then return res.Body end
    elseif http and http.request then
        local ok, res = pcall(http.request, {Url = url, Method = "GET"})
        if ok and res then return res.Body end
    elseif request then
        local ok, res = pcall(request, {Url = url, Method = "GET"})
        if ok and res then return res.Body end
    elseif fluxus and fluxus.request then
        local ok, res = pcall(fluxus.request, {Url = url, Method = "GET"})
        if ok and res then return res.Body end
    end
    return nil
end

local function safeWriteFile(name, data)
    if writefile then
        pcall(writefile, name, data)
    end
end

local function safeReadFile(name)
    if readfile and isfile and isfile(name) then
        local ok, data = pcall(readfile, name)
        if ok then return data end
    end
    return nil
end

local function safeClipboard(text)
    if setclipboard then
        pcall(setclipboard, text)
    elseif Clipboard and Clipboard.set then
        pcall(Clipboard.set, text)
    elseif toclipboard then
        pcall(toclipboard, text)
    end
end

local NEON_GREEN = Color3.fromRGB(0, 255, 127)
local DARK_GREEN = Color3.fromRGB(0, 180, 80)
local BG_COLOR = Color3.fromRGB(10, 10, 10)
local PANEL_COLOR = Color3.fromRGB(15, 15, 15)
local SIDEBAR_COLOR = Color3.fromRGB(12, 12, 12)
local TEXT_COLOR = Color3.fromRGB(220, 255, 220)
local ACCENT_COLOR = Color3.fromRGB(0, 255, 127)

local GUI_SCALE = IS_MOBILE and 0.95 or 1
local MAIN_W = IS_MOBILE and 620 or 720
local MAIN_H = IS_MOBILE and 440 or 500

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YarikWorldHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 99999
ScreenGui.IgnoreGuiInset = true

if EXECUTOR_NAME == "Synapse X" and syn and syn.protect_gui then
    pcall(syn.protect_gui, ScreenGui)
end

local guiParent = getGuiParent()
ScreenGui.Parent = guiParent

local function makeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = parent
    return c
end

local function makeStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or NEON_GREEN
    s.Thickness = thickness or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function makeLabel(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.Text = text
    l.TextSize = size or 14
    l.TextColor3 = color or TEXT_COLOR
    l.Font = font or Enum.Font.GothamBold
    l.BackgroundTransparency = 1
    l.Size = UDim2.new(1, 0, 0, size and size + 8 or 22)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local function makeButton(parent, text, size)
    local b = Instance.new("TextButton")
    b.Text = text
    b.TextSize = size or 13
    b.TextColor3 = Color3.fromRGB(10, 10, 10)
    b.Font = Enum.Font.GothamBold
    b.BackgroundColor3 = NEON_GREEN
    b.Size = UDim2.new(1, 0, 0, 34)
    b.AutoButtonColor = false
    b.Parent = parent
    makeCorner(b, 8)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 220, 100)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = NEON_GREEN}):Play()
    end)
    return b
end

local function showNotification(title, message, duration)
    duration = duration or 3
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 260, 0, 70)
    notifFrame.Position = UDim2.new(1, -270, 1, 80)
    notifFrame.BackgroundColor3 = PANEL_COLOR
    notifFrame.BackgroundTransparency = 0.1
    notifFrame.ZIndex = 200
    notifFrame.Parent = ScreenGui
    makeCorner(notifFrame, 10)
    makeStroke(notifFrame, NEON_GREEN, 1.5)

    local titleL = Instance.new("TextLabel")
    titleL.Text = title
    titleL.TextSize = 13
    titleL.TextColor3 = NEON_GREEN
    titleL.Font = Enum.Font.GothamBold
    titleL.BackgroundTransparency = 1
    titleL.Size = UDim2.new(1, -10, 0, 24)
    titleL.Position = UDim2.new(0, 8, 0, 5)
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.ZIndex = 201
    titleL.Parent = notifFrame

    local msgL = Instance.new("TextLabel")
    msgL.Text = message
    msgL.TextSize = 11
    msgL.TextColor3 = TEXT_COLOR
    msgL.Font = Enum.Font.Gotham
    msgL.BackgroundTransparency = 1
    msgL.Size = UDim2.new(1, -10, 0, 30)
    msgL.Position = UDim2.new(0, 8, 0, 28)
    msgL.TextXAlignment = Enum.TextXAlignment.Left
    msgL.TextWrapped = true
    msgL.ZIndex = 201
    msgL.Parent = notifFrame

    TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -270, 1, -90)}):Play()
    task.delay(duration, function()
        TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -270, 1, 80)}):Play()
        task.delay(0.5, function()
            notifFrame:Destroy()
        end)
    end)
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
MainFrame.Position = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BackgroundTransparency = 0.05
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
makeCorner(MainFrame, 16)
makeStroke(MainFrame, NEON_GREEN, 2)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = PANEL_COLOR
TitleBar.BackgroundTransparency = 0.1
TitleBar.Parent = MainFrame
makeCorner(TitleBar, 16)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "Yarik World Hub  |  " .. EXECUTOR_NAME .. "  |  v5.0"
TitleLabel.TextSize = 15
TitleLabel.TextColor3 = NEON_GREEN
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -120, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.Parent = TitleBar
makeCorner(CloseBtn, 7)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "-"
MinBtn.TextSize = 18
MinBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BackgroundColor3 = NEON_GREEN
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -68, 0.5, -14)
MinBtn.Parent = TitleBar
makeCorner(MinBtn, 7)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, MAIN_W, 0, 42)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, MAIN_W, 0, MAIN_H)}):Play()
    end
end)

local dragging = false
local dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = SIDEBAR_COLOR
Sidebar.BackgroundTransparency = 0.1
Sidebar.Parent = MainFrame
makeCorner(Sidebar, 12)

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 4)
SidebarList.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 8)
SidebarPad.PaddingLeft = UDim.new(0, 6)
SidebarPad.PaddingRight = UDim.new(0, 6)
SidebarPad.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -158, 1, -50)
ContentArea.Position = UDim2.new(0, 155, 0, 46)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local categories = {
    "Игрок", "Визуал", "Мир", "Бой",
    "Поиск", "Телепорт", "Оружие", "Авто", "Сеть", "Разное"
}

local categoryFrames = {}
local sidebarButtons = {}
local activeCategory = nil

local function setActiveCategory(name)
    for _, f in pairs(categoryFrames) do
        f.Visible = false
    end
    for _, b in pairs(sidebarButtons) do
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.TextColor3 = TEXT_COLOR
    end
    if categoryFrames[name] then
        categoryFrames[name].Visible = true
    end
    if sidebarButtons[name] then
        sidebarButtons[name].BackgroundColor3 = NEON_GREEN
        sidebarButtons[name].TextColor3 = Color3.fromRGB(10, 10, 10)
    end
    activeCategory = name
end

for i, catName in ipairs(categories) do
    local btn = Instance.new("TextButton")
    btn.Text = catName
    btn.TextSize = 12
    btn.TextColor3 = TEXT_COLOR
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.LayoutOrder = i
    btn.AutoButtonColor = false
    btn.Parent = Sidebar
    makeCorner(btn, 8)

    sidebarButtons[catName] = btn

    local catFrame = Instance.new("ScrollingFrame")
    catFrame.Size = UDim2.new(1, 0, 1, 0)
    catFrame.BackgroundTransparency = 1
    catFrame.ScrollBarThickness = 4
    catFrame.ScrollBarImageColor3 = NEON_GREEN
    catFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    catFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    catFrame.Visible = false
    catFrame.Parent = ContentArea
    categoryFrames[catName] = catFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = catFrame

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = catFrame

    btn.MouseButton1Click:Connect(function()
        setActiveCategory(catName)
    end)
    btn.MouseEnter:Connect(function()
        if activeCategory ~= catName then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 100, 50)}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeCategory ~= catName then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
        end
    end)
end

local function addSectionLabel(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Text = text
    lbl.TextSize = 12
    lbl.TextColor3 = NEON_GREEN
    lbl.Font = Enum.Font.GothamBold
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

local function addToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = PANEL_COLOR
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    makeCorner(frame, 8)
    makeStroke(frame, Color3.fromRGB(0, 80, 40), 1)

    local lbl = Instance.new("TextLabel")
    lbl.Text = text
    lbl.TextSize = 13
    lbl.TextColor3 = TEXT_COLOR
    lbl.Font = Enum.Font.Gotham
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local togBtn = Instance.new("TextButton")
    togBtn.Text = "ВЫКЛ"
    togBtn.TextSize = 11
    togBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
    togBtn.Font = Enum.Font.GothamBold
    togBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    togBtn.Size = UDim2.new(0, 52, 0, 24)
    togBtn.Position = UDim2.new(1, -58, 0.5, -12)
    togBtn.AutoButtonColor = false
    togBtn.Parent = frame
    makeCorner(togBtn, 6)

    local state = false
    togBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            togBtn.Text = "ВКЛ"
            togBtn.BackgroundColor3 = NEON_GREEN
            makeStroke(frame, NEON_GREEN, 1.5)
        else
            togBtn.Text = "ВЫКЛ"
            togBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            makeStroke(frame, Color3.fromRGB(0, 80, 40), 1)
        end
        if callback then callback(state) end
    end)
    return frame, function() return state end
end

local function addSlider(parent, text, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 54)
    frame.BackgroundColor3 = PANEL_COLOR
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    makeCorner(frame, 8)
    makeStroke(frame, Color3.fromRGB(0, 80, 40), 1)

    local lbl = Instance.new("TextLabel")
    lbl.Text = text .. ": " .. tostring(defaultVal)
    lbl.TextSize = 12
    lbl.TextColor3 = TEXT_COLOR
    lbl.Font = Enum.Font.Gotham
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -10, 0, 22)
    lbl.Position = UDim2.new(0, 10, 0, 2)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 8)
    track.Position = UDim2.new(0, 10, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    track.Parent = frame
    makeCorner(track, 4)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = NEON_GREEN
    fill.Parent = track
    makeCorner(fill, 4)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 0.5, 0)
    knob.BackgroundColor3 = NEON_GREEN
    knob.Parent = track
    makeCorner(knob, 7)

    local currentVal = defaultVal
    local sliding = false

    local function updateSlider(inputPos)
        local trackAbs = track.AbsolutePosition
        local trackSize = track.AbsoluteSize
        local relative = math.clamp((inputPos.X - trackAbs.X) / trackSize.X, 0, 1)
        currentVal = math.floor(minVal + relative * (maxVal - minVal))
        fill.Size = UDim2.new(relative, 0, 1, 0)
        knob.Position = UDim2.new(relative, 0, 0.5, 0)
        lbl.Text = text .. ": " .. tostring(currentVal)
        if callback then callback(currentVal) end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            updateSlider(input.Position)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)

    return frame
end

local function addButton(parent, text, callback)
    local btn = makeButton(parent, text, 13)
    btn.Size = UDim2.new(1, 0, 0, 34)
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    return btn
end

local function addTextBox(parent, placeholder, callback)
    local box = Instance.new("TextBox")
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextSize = 13
    box.TextColor3 = TEXT_COLOR
    box.PlaceholderColor3 = Color3.fromRGB(100, 150, 100)
    box.Font = Enum.Font.Gotham
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    box.Size = UDim2.new(1, 0, 0, 34)
    box.ClearTextOnFocus = false
    box.Parent = parent
    makeCorner(box, 8)
    makeStroke(box, NEON_GREEN, 1)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.Parent = box
    if callback then
        box.FocusLost:Connect(function(enter)
            if enter then callback(box.Text) end
        end)
    end
    return box
end

local states = {}
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    task.wait(1)
    if states.noclip then
        for _, p in pairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    if states.infiniteJump then end
    if states.fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    end
end)

local playerFrame = categoryFrames["Игрок"]

addSectionLabel(playerFrame, "Движение и физика")

addSlider(playerFrame, "Скорость ходьбы", 16, 1000, 16, function(val)
    if Humanoid then Humanoid.WalkSpeed = val end
end)

addSlider(playerFrame, "Высота прыжка", 50, 1000, 50, function(val)
    if Humanoid then Humanoid.JumpPower = val end
end)

addSlider(playerFrame, "Гравитация", 0, 200, 196, function(val)
    workspace.Gravity = val
end)

addToggle(playerFrame, "Ноклип (Сквозь стены)", function(val)
    states.noclip = val
    showNotification("Ноклип", val and "Включён" or "Выключен")
end)

addToggle(playerFrame, "Бесконечный прыжок", function(val)
    states.infiniteJump = val
    showNotification("Инф. прыжок", val and "Включён" or "Выключен")
end)

addToggle(playerFrame, "Анти-падение (Anti-Ragdoll)", function(val)
    states.antiRagdoll = val
    if val and Humanoid then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    elseif Humanoid then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    end
end)

addToggle(playerFrame, "СпинБот (вращение)", function(val)
    states.spinBot = val
end)

addToggle(playerFrame, "Невидимость", function(val)
    states.invisible = val
    if Character then
        for _, p in pairs(Character:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") then
                p.Transparency = val and 1 or 0
            end
        end
    end
end)

addToggle(playerFrame, "Бог-мод (MaxHealth)", function(val)
    states.godMode = val
    if Humanoid then
        if val then
            Humanoid.MaxHealth = math.huge
            Humanoid.Health = math.huge
        else
            Humanoid.MaxHealth = 100
            Humanoid.Health = 100
        end
    end
end)

addButton(playerFrame, "Сохранить позицию", function()
    if RootPart then
        states.savedPos = RootPart.CFrame
        showNotification("Позиция", "Позиция сохранена!")
    end
end)

addButton(playerFrame, "Вернуться на позицию", function()
    if states.savedPos and RootPart then
        RootPart.CFrame = states.savedPos
        showNotification("Позиция", "Телепортировано!")
    end
end)

addButton(playerFrame, "Сбросить персонажа", function()
    if Humanoid then Humanoid.Health = 0 end
end)

local visualFrame = categoryFrames["Визуал"]

addSectionLabel(visualFrame, "Визуальные эффекты")

addToggle(visualFrame, "ESP (Видеть игроков)", function(val)
    states.esp = val
    if val then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local existing = plr.Character:FindFirstChild("ESP_Box")
                if not existing then
                    local box = Instance.new("SelectionBox")
                    box.Name = "ESP_Box"
                    box.Adornee = plr.Character
                    box.Color3 = NEON_GREEN
                    box.LineThickness = 0.05
                    box.SurfaceTransparency = 0.7
                    box.SurfaceColor3 = Color3.fromRGB(0, 60, 30)
                    box.Parent = plr.Character
                end
            end
        end
        showNotification("ESP", "ESP включён")
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                local box = plr.Character:FindFirstChild("ESP_Box")
                if box then box:Destroy() end
            end
        end
        showNotification("ESP", "ESP выключен")
    end
end)

addToggle(visualFrame, "Fullbright (Яркость)", function(val)
    states.fullbright = val
    if val then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
end)

addToggle(visualFrame, "Радужный персонаж", function(val)
    states.rainbow = val
end)

addToggle(visualFrame, "Убрать туман", function(val)
    if val then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 99999
    else
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
    end
end)

addSlider(visualFrame, "FOV камеры", 50, 120, 70, function(val)
    Camera.FieldOfView = val
end)

addToggle(visualFrame, "Скелет (Billboard)", function(val)
    states.skeleton = val
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local existing = plr.Character:FindFirstChild("ESP_Name")
            if val and not existing then
                local bb = Instance.new("BillboardGui")
                bb.Name = "ESP_Name"
                bb.Adornee = plr.Character:FindFirstChild("Head")
                bb.Size = UDim2.new(0, 100, 0, 30)
                bb.StudsOffset = Vector3.new(0, 2, 0)
                bb.AlwaysOnTop = true
                bb.Parent = plr.Character
                local lbl2 = Instance.new("TextLabel")
                lbl2.Text = plr.Name
                lbl2.TextSize = 14
                lbl2.TextColor3 = NEON_GREEN
                lbl2.Font = Enum.Font.GothamBold
                lbl2.BackgroundTransparency = 1
                lbl2.Size = UDim2.new(1, 0, 1, 0)
                lbl2.Parent = bb
            elseif not val and existing then
                existing:Destroy()
            end
        end
    end
end)

addButton(visualFrame, "День", function()
    Lighting.ClockTime = 14
    showNotification("Мир", "День установлен")
end)

addButton(visualFrame, "Ночь", function()
    Lighting.ClockTime = 0
    showNotification("Мир", "Ночь установлена")
end)

local worldFrame = categoryFrames["Мир"]

addSectionLabel(worldFrame, "Мир и окружение")

addToggle(worldFrame, "Click TP (Телепорт кликом)", function(val)
    states.clickTP = val
    showNotification("Click TP", val and "Кликни по поверхности" or "Выключен")
end)

addToggle(worldFrame, "FPS Буст (убрать эффекты)", function(val)
    if val then
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("BlurEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("SunRaysEffect") then
                obj.Enabled = false
            end
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                obj.Enabled = false
            end
        end
        showNotification("FPS Буст", "Эффекты убраны")
    else
        showNotification("FPS Буст", "Эффекты включены обратно")
    end
end)

addToggle(worldFrame, "Разблокировать части", function(val)
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Locked = not val
        end
    end
end)

addButton(worldFrame, "Удалить лазеры/стены", function()
    local removed = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if name:find("laser") or name:find("kill") or name:find("lava") or name:find("acid") then
            obj:Destroy()
            removed = removed + 1
        end
    end
    showNotification("Мир", "Удалено объектов: " .. removed)
end)

addButton(worldFrame, "Удалить все NPC", function()
    local removed = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            if not Players:GetPlayerFromCharacter(obj) then
                obj:Destroy()
                removed = removed + 1
            end
        end
    end
    showNotification("Мир", "NPC удалено: " .. removed)
end)

addButton(worldFrame, "Заморозить персонажа", function()
    if RootPart then
        RootPart.Anchored = not RootPart.Anchored
        showNotification("Фриз", RootPart.Anchored and "Заморожен" or "Разморожен")
    end
end)

local combatFrame = categoryFrames["Бой"]

addSectionLabel(combatFrame, "Боевые функции")

addToggle(combatFrame, "Аимлок (Блокировка цели)", function(val)
    states.aimlock = val
    showNotification("Аимлок", val and "Включён — удерживай Правую кнопку" or "Выключен")
end)

addSlider(combatFrame, "Плавность аимлока", 1, 20, 5, function(val)
    states.aimlockSmooth = val
end)

addToggle(combatFrame, "Хитбокс Экспандер", function(val)
    states.hitbox = val
    if val then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(8, 8, 8)
                    hrp.Transparency = 0.8
                end
            end
        end
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end
            end
        end
    end
end)

addSlider(combatFrame, "Размер хитбокса", 2, 20, 8, function(val)
    states.hitboxSize = val
    if states.hitbox then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Size = Vector3.new(val, val, val) end
            end
        end
    end
end)

addToggle(combatFrame, "Авто-кликер", function(val)
    states.autoClicker = val
end)

addSlider(combatFrame, "Скорость авто-клика (CPS)", 1, 20, 8, function(val)
    states.autoCPS = val
end)

addToggle(combatFrame, "Килл-аура (Авто-урон)", function(val)
    states.killAura = val
    showNotification("Килл-аура", val and "Включена — осторожно!" or "Выключена")
end)

addSlider(combatFrame, "Радиус килл-ауры", 5, 50, 15, function(val)
    states.killAuraRange = val
end)

addToggle(combatFrame, "Анти-урон", function(val)
    states.antiDamage = val
    if val and Humanoid then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
    end
end)

local searchFrame = categoryFrames["Поиск"]

addSectionLabel(searchFrame, "Поиск скриптов по игре")

local searchBox = addTextBox(searchFrame, "Введите название игры или PlaceId...")
local searchResultsFrame = Instance.new("Frame")
searchResultsFrame.Size = UDim2.new(1, 0, 0, 0)
searchResultsFrame.BackgroundTransparency = 1
searchResultsFrame.AutomaticSize = Enum.AutomaticSize.Y
searchResultsFrame.Parent = searchFrame

local searchList = Instance.new("UIListLayout")
searchList.SortOrder = Enum.SortOrder.LayoutOrder
searchList.Padding = UDim.new(0, 6)
searchList.Parent = searchResultsFrame

local scriptDatabase = {
    [1537690962] = {
        name = "Jailbreak",
        scripts = {
            {name = "Авто-ограбление Банка", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/jailbreak/main/autobank.lua"))()'},
            {name = "Авто-ферма денег", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/jailbreak/main/autofarm.lua"))()'},
            {name = "Авто-арест (Коп)", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/jailbreak/main/autoarest.lua"))()'},
        }
    },
    [2455229086] = {
        name = "Arsenal",
        scripts = {
            {name = "Аимбот Arsenal", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/arsenal/main/aimbot.lua"))()'},
            {name = "Валлхак Arsenal", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/arsenal/main/wh.lua"))()'},
        }
    },
    [2753915549] = {
        name = "Blox Fruits",
        scripts = {
            {name = "Авто-фарм Блокс Фрутс", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/bloxfruits/main/autofarm.lua"))()'},
            {name = "Фрут Снайпер", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/bloxfruits/main/fruitsniper.lua"))()'},
            {name = "Авто-рейды", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/bloxfruits/main/autoraid.lua"))()'},
        }
    },
    [292439477] = {
        name = "Murder Mystery 2",
        scripts = {
            {name = "ESP мурдерер", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/mm2/main/esp.lua"))()'},
            {name = "Авто-убийца", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/mm2/main/autokill.lua"))()'},
        }
    },
    [189707] = {
        name = "Natural Disaster Survival",
        scripts = {
            {name = "Авто-выживание", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/nds/main/autosurvive.lua"))()'},
        }
    },
}

local universalScripts = {
    {name = "Universal Fly Script", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/universal/main/fly.lua"))()'},
    {name = "Universal ESP", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/universal/main/esp.lua"))()'},
    {name = "Universal Speed Hack", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/universal/main/speed.lua"))()'},
    {name = "Universal Hitbox", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/universal/main/hitbox.lua"))()'},
    {name = "Universal Aimbot", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/examplerepo/universal/main/aimbot.lua"))()'},
}

local function clearSearchResults()
    for _, child in pairs(searchResultsFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end
end

local function addScriptResult(scriptInfo)
    local resultFrame = Instance.new("Frame")
    resultFrame.Size = UDim2.new(1, 0, 0, 40)
    resultFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
    resultFrame.BackgroundTransparency = 0.1
    resultFrame.Parent = searchResultsFrame
    makeCorner(resultFrame, 8)
    makeStroke(resultFrame, Color3.fromRGB(0, 80, 40), 1)

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Text = scriptInfo.name
    nameLbl.TextSize = 12
    nameLbl.TextColor3 = TEXT_COLOR
    nameLbl.Font = Enum.Font.Gotham
    nameLbl.BackgroundTransparency = 1
    nameLbl.Size = UDim2.new(1, -120, 1, 0)
    nameLbl.Position = UDim2.new(0, 8, 0, 0)
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = resultFrame

    local execBtn = Instance.new("TextButton")
    execBtn.Text = "Выполнить"
    execBtn.TextSize = 11
    execBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
    execBtn.Font = Enum.Font.GothamBold
    execBtn.BackgroundColor3 = NEON_GREEN
    execBtn.Size = UDim2.new(0, 80, 0, 26)
    execBtn.Position = UDim2.new(1, -88, 0.5, -13)
    execBtn.AutoButtonColor = false
    execBtn.Parent = resultFrame
    makeCorner(execBtn, 6)
    execBtn.MouseButton1Click:Connect(function()
        local ok, err = pcall(function()
            loadstring(scriptInfo.code)()
        end)
        if not ok then
            showNotification("Ошибка", "Не удалось выполнить: " .. tostring(err):sub(1, 40), 4)
        else
            showNotification("Выполнено", scriptInfo.name, 2)
        end
    end)

    local copyBtn = Instance.new("TextButton")
    copyBtn.Text = "Копировать"
    copyBtn.TextSize = 10
    copyBtn.TextColor3 = NEON_GREEN
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
    copyBtn.Size = UDim2.new(0, 70, 0, 22)
    copyBtn.Position = UDim2.new(1, -162, 0.5, -11)
    copyBtn.AutoButtonColor = false
    copyBtn.Parent = resultFrame
    makeCorner(copyBtn, 5)
    makeStroke(copyBtn, NEON_GREEN, 1)
    copyBtn.MouseButton1Click:Connect(function()
        safeClipboard(scriptInfo.code)
        showNotification("Скопировано", scriptInfo.name, 2)
    end)
end

local function performSearch(query)
    clearSearchResults()
    local placeId = game.PlaceId
    local found = false

    if scriptDatabase[placeId] then
        local gameData = scriptDatabase[placeId]
        local hdr = Instance.new("TextLabel")
        hdr.Text = "Игра: " .. gameData.name .. " (PlaceId: " .. placeId .. ")"
        hdr.TextSize = 13
        hdr.TextColor3 = NEON_GREEN
        hdr.Font = Enum.Font.GothamBold
        hdr.BackgroundTransparency = 1
        hdr.Size = UDim2.new(1, 0, 0, 24)
        hdr.TextXAlignment = Enum.TextXAlignment.Left
        hdr.Parent = searchResultsFrame

        for _, s in ipairs(gameData.scripts) do
            if query == "" or s.name:lower():find(query:lower()) then
                addScriptResult(s)
                found = true
            end
        end
    end

    local univHdr = Instance.new("TextLabel")
    univHdr.Text = "Универсальные скрипты:"
    univHdr.TextSize = 12
    univHdr.TextColor3 = DARK_GREEN
    univHdr.Font = Enum.Font.GothamBold
    univHdr.BackgroundTransparency = 1
    univHdr.Size = UDim2.new(1, 0, 0, 20)
    univHdr.TextXAlignment = Enum.TextXAlignment.Left
    univHdr.Parent = searchResultsFrame

    for _, s in ipairs(universalScripts) do
        if query == "" or s.name:lower():find(query:lower()) then
            addScriptResult(s)
            found = true
        end
    end

    if not found then
        local noResult = Instance.new("TextLabel")
        noResult.Text = "Ничего не найдено по запросу: " .. query
        noResult.TextSize = 12
        noResult.TextColor3 = Color3.fromRGB(180, 180, 180)
        noResult.Font = Enum.Font.Gotham
        noResult.BackgroundTransparency = 1
        noResult.Size = UDim2.new(1, 0, 0, 30)
        noResult.TextXAlignment = Enum.TextXAlignment.Center
        noResult.Parent = searchResultsFrame
    end
end

addButton(searchFrame, "Найти скрипты для текущей игры", function()
    performSearch(searchBox.Text)
end)

addButton(searchFrame, "Показать все универсальные", function()
    performSearch("")
end)

local tpFrame = categoryFrames["Телепорт"]

addSectionLabel(tpFrame, "Телепорт к игрокам")

local coordLabel = Instance.new("TextLabel")
coordLabel.Text = "X: 0  Y: 0  Z: 0"
coordLabel.TextSize = 12
coordLabel.TextColor3 = NEON_GREEN
coordLabel.Font = Enum.Font.GothamMedium
coordLabel.BackgroundColor3 = Color3.fromRGB(15, 25, 15)
coordLabel.BackgroundTransparency = 0.1
coordLabel.Size = UDim2.new(1, 0, 0, 28)
coordLabel.TextXAlignment = Enum.TextXAlignment.Center
coordLabel.Parent = tpFrame
makeCorner(coordLabel, 8)

RunService.Heartbeat:Connect(function()
    if RootPart then
        local pos = RootPart.Position
        coordLabel.Text = string.format("X: %.1f  Y: %.1f  Z: %.1f", pos.X, pos.Y, pos.Z)
    end
end)

local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(1, 0, 0, 0)
playerListFrame.AutomaticSize = Enum.AutomaticSize.Y
playerListFrame.BackgroundTransparency = 1
playerListFrame.Parent = tpFrame

local plrListLayout = Instance.new("UIListLayout")
plrListLayout.SortOrder = Enum.SortOrder.LayoutOrder
plrListLayout.Padding = UDim.new(0, 5)
plrListLayout.Parent = playerListFrame

local function refreshPlayerList()
    for _, c in pairs(playerListFrame:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local pFrame = Instance.new("Frame")
            pFrame.Size = UDim2.new(1, 0, 0, 36)
            pFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
            pFrame.BackgroundTransparency = 0.1
            pFrame.Parent = playerListFrame
            makeCorner(pFrame, 8)

            local pName = Instance.new("TextLabel")
            pName.Text = plr.Name
            pName.TextSize = 12
            pName.TextColor3 = TEXT_COLOR
            pName.Font = Enum.Font.Gotham
            pName.BackgroundTransparency = 1
            pName.Size = UDim2.new(1, -160, 1, 0)
            pName.Position = UDim2.new(0, 8, 0, 0)
            pName.TextXAlignment = Enum.TextXAlignment.Left
            pName.Parent = pFrame

            local tpToBtn = Instance.new("TextButton")
            tpToBtn.Text = "ТП к нему"
            tpToBtn.TextSize = 10
            tpToBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
            tpToBtn.Font = Enum.Font.GothamBold
            tpToBtn.BackgroundColor3 = NEON_GREEN
            tpToBtn.Size = UDim2.new(0, 74, 0, 26)
            tpToBtn.Position = UDim2.new(1, -156, 0.5, -13)
            tpToBtn.AutoButtonColor = false
            tpToBtn.Parent = pFrame
            makeCorner(tpToBtn, 6)
            tpToBtn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and RootPart then
                    RootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 2)
                    showNotification("ТП", "Телепортировано к " .. plr.Name)
                end
            end)

            local bringBtn = Instance.new("TextButton")
            bringBtn.Text = "Притянуть"
            bringBtn.TextSize = 10
            bringBtn.TextColor3 = NEON_GREEN
            bringBtn.Font = Enum.Font.GothamBold
            bringBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
            bringBtn.Size = UDim2.new(0, 72, 0, 26)
            bringBtn.Position = UDim2.new(1, -78, 0.5, -13)
            bringBtn.AutoButtonColor = false
            bringBtn.Parent = pFrame
            makeCorner(bringBtn, 6)
            makeStroke(bringBtn, NEON_GREEN, 1)
            bringBtn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and RootPart then
                    plr.Character.HumanoidRootPart.CFrame = RootPart.CFrame + Vector3.new(2, 0, 0)
                    showNotification("Притянуть", plr.Name .. " притянут к вам")
                end
            end)
        end
    end
end

addButton(tpFrame, "Обновить список игроков", function()
    refreshPlayerList()
end)

refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    refreshPlayerList()
end)

local weaponFrame = categoryFrames["Оружие"]

addSectionLabel(weaponFrame, "Настройки оружия")

addToggle(weaponFrame, "Без разброса (No Spread)", function(val)
    states.noSpread = val
    showNotification("Оружие", val and "Разброс убран" or "Разброс включён")
end)

addToggle(weaponFrame, "Без отдачи (No Recoil)", function(val)
    states.noRecoil = val
    showNotification("Оружие", val and "Отдача убрана" or "Отдача включена")
end)

addSlider(weaponFrame, "Скорость стрельбы", 1, 10, 1, function(val)
    states.fireRate = val
end)

addSlider(weaponFrame, "Дальность выстрела", 100, 2000, 500, function(val)
    states.bulletRange = val
end)

addToggle(weaponFrame, "Авто-прицеливание по ближнему", function(val)
    states.autoAim = val
end)

addToggle(weaponFrame, "Бесконечные патроны", function(val)
    states.infiniteAmmo = val
    showNotification("Оружие", val and "Бесконечные патроны!" or "Патроны ограничены")
end)

local autoFrame = categoryFrames["Авто"]

addSectionLabel(autoFrame, "Авто-действия")

addToggle(autoFrame, "Авто-фарм монстров", function(val)
    states.autoFarmMobs = val
    showNotification("Авто-фарм", val and "Включён" or "Выключен")
end)

addSlider(autoFrame, "Радиус фарма", 10, 200, 50, function(val)
    states.farmRadius = val
end)

addToggle(autoFrame, "Авто-сбор предметов", function(val)
    states.autoCollect = val
end)

addToggle(autoFrame, "Авто-продажа", function(val)
    states.autoSell = val
end)

addToggle(autoFrame, "Авто-квесты", function(val)
    states.autoQuest = val
end)

addToggle(autoFrame, "Авто-использование способностей", function(val)
    states.autoAbility = val
end)

addButton(autoFrame, "Собрать всё вокруг (50 ед.)", function()
    local count = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        local dist = obj:IsA("BasePart") and (obj.Position - RootPart.Position).Magnitude or 999
        if dist < 50 and (obj.Name:lower():find("coin") or obj.Name:lower():find("gem") or obj.Name:lower():find("cash") or obj.Name:lower():find("item")) then
            obj.CFrame = RootPart.CFrame
            count = count + 1
        end
    end
    showNotification("Авто-сбор", "Собрано объектов: " .. count)
end)

local netFrame = categoryFrames["Сеть"]

addSectionLabel(netFrame, "Сеть и защита")

local pingLabel = Instance.new("TextLabel")
pingLabel.Text = "Пинг: измеряю..."
pingLabel.TextSize = 13
pingLabel.TextColor3 = NEON_GREEN
pingLabel.Font = Enum.Font.GothamBold
pingLabel.BackgroundColor3 = Color3.fromRGB(15, 25, 15)
pingLabel.BackgroundTransparency = 0.1
pingLabel.Size = UDim2.new(1, 0, 0, 32)
pingLabel.TextXAlignment = Enum.TextXAlignment.Center
pingLabel.Parent = netFrame
makeCorner(pingLabel, 8)

local execLabel = Instance.new("TextLabel")
execLabel.Text = "Экзекутор: " .. EXECUTOR_NAME
execLabel.TextSize = 12
execLabel.TextColor3 = TEXT_COLOR
execLabel.Font = Enum.Font.Gotham
execLabel.BackgroundColor3 = Color3.fromRGB(15, 25, 15)
execLabel.BackgroundTransparency = 0.1
execLabel.Size = UDim2.new(1, 0, 0, 28)
execLabel.TextXAlignment = Enum.TextXAlignment.Center
execLabel.Parent = netFrame
makeCorner(execLabel, 8)

local statsLabel = Instance.new("TextLabel")
statsLabel.Text = "PlaceId: " .. game.PlaceId .. "  |  JobId: " .. game.JobId:sub(1, 12) .. "..."
statsLabel.TextSize = 11
statsLabel.TextColor3 = Color3.fromRGB(150, 200, 150)
statsLabel.Font = Enum.Font.Gotham
statsLabel.BackgroundColor3 = Color3.fromRGB(15, 25, 15)
statsLabel.BackgroundTransparency = 0.1
statsLabel.Size = UDim2.new(1, 0, 0, 28)
statsLabel.TextXAlignment = Enum.TextXAlignment.Center
statsLabel.Parent = netFrame
makeCorner(statsLabel, 8)

task.spawn(function()
    while true do
        task.wait(2)
        local stats = game:GetService("Stats")
        if stats then
            local ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            pingLabel.Text = string.format("Пинг: %.0f мс", ping)
            if ping < 80 then
                pingLabel.TextColor3 = NEON_GREEN
            elseif ping < 150 then
                pingLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            else
                pingLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        end
    end
end)

addToggle(netFrame, "Анти-кик (защита от кика)", function(val)
    states.antiKick = val
    showNotification("Анти-кик", val and "Защита активна" or "Защита выключена")
end)

addToggle(netFrame, "Анти-отключение", function(val)
    states.antiDisconnect = val
end)

addButton(netFrame, "Реконнект (переподключение)", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
end)

addButton(netFrame, "Скопировать PlaceId", function()
    safeClipboard(tostring(game.PlaceId))
    showNotification("Скопировано", "PlaceId: " .. game.PlaceId)
end)

addButton(netFrame, "Скопировать JobId", function()
    safeClipboard(game.JobId)
    showNotification("Скопировано", "JobId скопирован")
end)

local miscFrame = categoryFrames["Разное"]

addSectionLabel(miscFrame, "Разное")

addToggle(miscFrame, "Мульти-прыжок", function(val)
    states.multiJump = val
end)

addSlider(miscFrame, "Кол-во прыжков", 2, 10, 3, function(val)
    states.jumpCount = val
end)

addToggle(miscFrame, "Автоматический прыжок", function(val)
    if Humanoid then
        Humanoid.AutoJumpEnabled = val
    end
end)

addToggle(miscFrame, "Скрыть имя (Nameplate)", function(val)
    local nameplate = Player.Character and Player.Character:FindFirstChild("Head") and Player.Character.Head:FindFirstChild("NameTag")
    if Player.Character then
        for _, obj in pairs(Player.Character:GetDescendants()) do
            if obj:IsA("BillboardGui") then
                obj.Enabled = not val
            end
        end
    end
end)

addButton(miscFrame, "Скопировать чарактер ID", function()
    safeClipboard(tostring(Player.UserId))
    showNotification("Скопировано", "UserId: " .. Player.UserId)
end)

addButton(miscFrame, "Открыть консоль (Print)", function()
    print("[Yarik World Hub] v5.0 | Executor: " .. EXECUTOR_NAME)
    print("[Yarik World Hub] PlaceId: " .. game.PlaceId)
    print("[Yarik World Hub] Player: " .. Player.Name)
    showNotification("Консоль", "Информация выведена в Output")
end)

addToggle(miscFrame, "Показывать FPS", function(val)
    states.showFPS = val
end)

addButton(miscFrame, "Уничтожить GUI", function()
    ScreenGui:Destroy()
end)

local FlyWidget = Instance.new("Frame")
FlyWidget.Name = "FlyWidget"
FlyWidget.Size = UDim2.new(0, 200, 0, 220)
FlyWidget.Position = UDim2.new(0, 10, 0.5, -110)
FlyWidget.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
FlyWidget.BackgroundTransparency = 0.1
FlyWidget.Visible = false
FlyWidget.ZIndex = 50
FlyWidget.Parent = ScreenGui
makeCorner(FlyWidget, 14)
makeStroke(FlyWidget, NEON_GREEN, 2)

local FlyTitle = Instance.new("Frame")
FlyTitle.Size = UDim2.new(1, 0, 0, 36)
FlyTitle.BackgroundColor3 = PANEL_COLOR
FlyTitle.BackgroundTransparency = 0.1
FlyTitle.ZIndex = 51
FlyTitle.Parent = FlyWidget
makeCorner(FlyTitle, 14)

local FlyTitleLabel = Instance.new("TextLabel")
FlyTitleLabel.Text = "FLY GUI v3"
FlyTitleLabel.TextSize = 13
FlyTitleLabel.TextColor3 = NEON_GREEN
FlyTitleLabel.Font = Enum.Font.GothamBold
FlyTitleLabel.BackgroundTransparency = 1
FlyTitleLabel.Size = UDim2.new(1, -40, 1, 0)
FlyTitleLabel.Position = UDim2.new(0, 10, 0, 0)
FlyTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
FlyTitleLabel.ZIndex = 52
FlyTitleLabel.Parent = FlyTitle

local FlyCloseBtn = Instance.new("TextButton")
FlyCloseBtn.Text = "X"
FlyCloseBtn.TextSize = 12
FlyCloseBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
FlyCloseBtn.Font = Enum.Font.GothamBold
FlyCloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
FlyCloseBtn.Size = UDim2.new(0, 24, 0, 24)
FlyCloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
FlyCloseBtn.ZIndex = 52
FlyCloseBtn.Parent = FlyTitle
makeCorner(FlyCloseBtn, 6)
FlyCloseBtn.MouseButton1Click:Connect(function()
    FlyWidget.Visible = false
end)

local flyDragging = false
local flyDragStart, flyStartPos
FlyTitle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        flyDragging = true
        flyDragStart = input.Position
        flyStartPos = FlyWidget.Position
    end
end)
FlyTitle.InputChanged:Connect(function(input)
    if flyDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - flyDragStart
        FlyWidget.Position = UDim2.new(flyStartPos.X.Scale, flyStartPos.X.Offset + delta.X, flyStartPos.Y.Scale, flyStartPos.Y.Offset + delta.Y)
    end
end)
FlyTitle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        flyDragging = false
    end
end)

local flySpeed = 50
local flyActive = false
local flyBV = nil
local flyBG = nil
local flyUp = false
local flyDown = false

local flyContentList = Instance.new("UIListLayout")
flyContentList.SortOrder = Enum.SortOrder.LayoutOrder
flyContentList.Padding = UDim.new(0, 6)
flyContentList.Parent = FlyWidget

local flyPad = Instance.new("UIPadding")
flyPad.PaddingTop = UDim.new(0, 42)
flyPad.PaddingLeft = UDim.new(0, 8)
flyPad.PaddingRight = UDim.new(0, 8)
flyPad.Parent = FlyWidget

local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Text = "Скорость: " .. flySpeed
flySpeedLabel.TextSize = 12
flySpeedLabel.TextColor3 = NEON_GREEN
flySpeedLabel.Font = Enum.Font.GothamBold
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Size = UDim2.new(1, 0, 0, 22)
flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Center
flySpeedLabel.ZIndex = 52
flySpeedLabel.Parent = FlyWidget

local function makeFlyBtn(text, layoutOrder, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(10, 10, 10)
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = NEON_GREEN
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.LayoutOrder = layoutOrder
    btn.AutoButtonColor = false
    btn.ZIndex = 52
    btn.Parent = FlyWidget
    makeCorner(btn, 8)
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 220, 100)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = NEON_GREEN}):Play()
    end)
    return btn
end

makeFlyBtn("▲ ВВЕРХ", 1, function()
    flyUp = true
    task.delay(0.15, function() flyUp = false end)
end)

makeFlyBtn("+ Скорость", 2, function()
    flySpeed = math.min(flySpeed + 10, 500)
    flySpeedLabel.Text = "Скорость: " .. flySpeed
end)

makeFlyBtn("- Скорость", 3, function()
    flySpeed = math.max(flySpeed - 10, 5)
    flySpeedLabel.Text = "Скорость: " .. flySpeed
end)

makeFlyBtn("▼ ВНИЗ", 4, function()
    flyDown = true
    task.delay(0.15, function() flyDown = false end)
end)

local flyToggleBtn = Instance.new("TextButton")
flyToggleBtn.Text = "✈ ПОЛЁТ: ВЫКЛ"
flyToggleBtn.TextSize = 13
flyToggleBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
flyToggleBtn.Font = Enum.Font.GothamBold
flyToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
flyToggleBtn.Size = UDim2.new(1, 0, 0, 34)
flyToggleBtn.LayoutOrder = 5
flyToggleBtn.AutoButtonColor = false
flyToggleBtn.ZIndex = 52
flyToggleBtn.Parent = FlyWidget
makeCorner(flyToggleBtn, 8)

local function enableFly()
    flyActive = true
    flyToggleBtn.Text = "✈ ПОЛЁТ: ВКЛ"
    flyToggleBtn.BackgroundColor3 = NEON_GREEN
    if RootPart then
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = RootPart

        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        flyBG.P = 1e4
        flyBG.CFrame = RootPart.CFrame
        flyBG.Parent = RootPart

        if Humanoid then
            Humanoid.PlatformStand = true
        end
    end
    showNotification("Полёт", "Полёт включён! WASD для движения")
end

local function disableFly()
    flyActive = false
    flyToggleBtn.Text = "✈ ПОЛЁТ: ВЫКЛ"
    flyToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
    if Humanoid then
        Humanoid.PlatformStand = false
    end
    showNotification("Полёт", "Полёт выключен")
end

flyToggleBtn.MouseButton1Click:Connect(function()
    if flyActive then
        disableFly()
    else
        enableFly()
    end
end)
flyToggleBtn.MouseEnter:Connect(function()
    if not flyActive then
        TweenService:Create(flyToggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end
end)
flyToggleBtn.MouseLeave:Connect(function()
    if not flyActive then
        TweenService:Create(flyToggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
    end
end)

RunService.Heartbeat:Connect(function()
    if flyActive and flyBV and flyBG and RootPart then
        local camCF = Camera.CFrame
        local moveDir = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or flyUp then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or flyDown then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        end

        flyBV.Velocity = moveDir * flySpeed
        flyBG.CFrame = CFrame.new(RootPart.Position, RootPart.Position + camCF.LookVector)
    end

    if states.noclip and Character then
        for _, p in pairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end

    if states.spinBot and RootPart then
        RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(5), 0)
    end

    if states.rainbow and Character then
        local hue = (tick() % 5) / 5
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
        for _, p in pairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Color = rainbowColor
            end
        end
    end

    if states.autoFarmMobs and RootPart then
        local radius = states.farmRadius or 50
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
                if not Players:GetPlayerFromCharacter(obj) then
                    local mob = obj:FindFirstChild("HumanoidRootPart")
                    if mob and (mob.Position - RootPart.Position).Magnitude < radius then
                        local mobHum = obj:FindFirstChildOfClass("Humanoid")
                        if mobHum and mobHum.Health > 0 then
                            mobHum.Health = 0
                        end
                    end
                end
            end
        end
    end

    if states.autoCollect and RootPart then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if (n:find("coin") or n:find("gem") or n:find("cash")) and (obj.Position - RootPart.Position).Magnitude < 60 then
                    RootPart.CFrame = CFrame.new(obj.Position)
                end
            end
        end
    end

    if states.killAura and RootPart then
        local range = states.killAuraRange or 15
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and (hrp.Position - RootPart.Position).Magnitude < range then
                    hum.Health = 0
                end
            end
        end
    end

    if states.aimlock and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closest = nil
        local closestDist = math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    local _, onScreen = Camera:WorldToScreenPoint(head.Position)
                    if onScreen then
                        local dist = (head.Position - Camera.CFrame.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closest = head
                        end
                    end
                end
            end
        end
        if closest then
            local smooth = states.aimlockSmooth or 5
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closest.Position), smooth * 0.016)
        end
    end

    if states.autoClicker then
        local cps = states.autoCPS or 8
        local interval = 1 / cps
        if not states._lastClick or (tick() - states._lastClick) >= interval then
            states._lastClick = tick()
        end
    end
end)

local jumpCount = 0
local maxJumps = 3
local lastJumpState = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.V then
        MainFrame.Visible = not MainFrame.Visible
        showNotification("Yarik World Hub", MainFrame.Visible and "Меню открыто" or "Меню скрыто", 1.5)
    end

    if input.KeyCode == Enum.KeyCode.E then
        FlyWidget.Visible = not FlyWidget.Visible
    end

    if input.KeyCode == Enum.KeyCode.F then
        if flyActive then disableFly() else enableFly() end
    end

    if input.KeyCode == Enum.KeyCode.K then
        states.aimlock = not states.aimlock
        showNotification("Аимлок", states.aimlock and "Включён" or "Выключен", 1.5)
    end

    if input.KeyCode == Enum.KeyCode.L then
        states.noclip = not states.noclip
        showNotification("Ноклип", states.noclip and "Включён" or "Выключен", 1.5)
    end

    if input.KeyCode == Enum.KeyCode.N then
        states.esp = not states.esp
        if states.esp then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player and plr.Character then
                    local existing = plr.Character:FindFirstChild("ESP_Box")
                    if not existing then
                        local box = Instance.new("SelectionBox")
                        box.Name = "ESP_Box"
                        box.Adornee = plr.Character
                        box.Color3 = NEON_GREEN
                        box.LineThickness = 0.05
                        box.SurfaceTransparency = 0.7
                        box.SurfaceColor3 = Color3.fromRGB(0, 60, 30)
                        box.Parent = plr.Character
                    end
                end
            end
        else
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character then
                    local box = plr.Character:FindFirstChild("ESP_Box")
                    if box then box:Destroy() end
                end
            end
        end
        showNotification("ESP", states.esp and "Включён" or "Выключен", 1.5)
    end

    if input.KeyCode == Enum.KeyCode.Space and states.infiniteJump then
        if Humanoid and Humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    if input.KeyCode == Enum.KeyCode.Space and states.multiJump then
        maxJumps = states.jumpCount or 3
        if jumpCount < maxJumps then
            jumpCount = jumpCount + 1
            if Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end

    if input.KeyCode == Enum.KeyCode.Delete then
        ScreenGui:Destroy()
    end

    if states.clickTP and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = Player:GetMouse()
        if mouse.Target then
            RootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

Humanoid.StateChanged:Connect(function(_, new)
    if new == Enum.HumanoidStateType.Landed then
        jumpCount = 0
    end
end)

local configData = {}

local function saveConfig()
    local data = {
        walkSpeed = Humanoid and Humanoid.WalkSpeed or 16,
        jumpPower = Humanoid and Humanoid.JumpPower or 50,
        gravity = workspace.Gravity,
        fov = Camera.FieldOfView,
    }
    local encoded = HttpService:JSONEncode(data)
    safeWriteFile("yarikworldhub_config.json", encoded)
end

local function loadConfig()
    local data = safeReadFile("yarikworldhub_config.json")
    if data then
        local ok, decoded = pcall(HttpService.JSONDecode, HttpService, data)
        if ok and decoded then
            if decoded.gravity then workspace.Gravity = decoded.gravity end
            if decoded.fov then Camera.FieldOfView = decoded.fov end
        end
    end
end

task.spawn(function()
    pcall(loadConfig)
    while true do
        task.wait(60)
        pcall(saveConfig)
    end
end)

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 80, 0, 24)
fpsLabel.Position = UDim2.new(0, 4, 0, 4)
fpsLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
fpsLabel.BackgroundTransparency = 0.3
fpsLabel.TextSize = 12
fpsLabel.TextColor3 = NEON_GREEN
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.Text = "FPS: --"
fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
fpsLabel.ZIndex = 100
fpsLabel.Parent = ScreenGui
makeCorner(fpsLabel, 6)

local lastTime = tick()
local frameCount = 0
RunService.Heartbeat:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTime >= 1 then
        if states.showFPS then
            fpsLabel.Visible = true
            fpsLabel.Text = "FPS: " .. frameCount
        else
            fpsLabel.Visible = false
        end
        frameCount = 0
        lastTime = now
    end
end)

setActiveCategory("Игрок")

showNotification(
    "Yarik World Hub v5.0",
    "Загружено! Экзекутор: " .. EXECUTOR_NAME .. " | V - меню | E - полёт",
    5
)
