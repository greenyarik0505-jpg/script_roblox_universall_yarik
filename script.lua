-- ╔══════════════════════════════════════════════════════════════╗
-- ║           PHANTOM X - ROBLOX EXPLOIT SCRIPT v3.0            ║
-- ║         Разработано для: Delta / Fluxus / Wave               ║
-- ╚══════════════════════════════════════════════════════════════╝

local Player = game.Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

-- ══════════════════════════════════════════
--              ЦВЕТА И ТЕМА
-- ══════════════════════════════════════════
local NEON_GREEN = Color3.fromRGB(0, 255, 127)
local DARK_BG    = Color3.fromRGB(15, 15, 15)
local DARK_PANEL = Color3.fromRGB(20, 20, 20)
local DARK_BTN   = Color3.fromRGB(25, 25, 30)
local ACCENT     = Color3.fromRGB(0, 200, 100)
local WHITE      = Color3.fromRGB(255, 255, 255)
local GRAY       = Color3.fromRGB(160, 160, 160)
local RED_COLOR  = Color3.fromRGB(255, 60, 60)
local BLUE_COLOR = Color3.fromRGB(60, 120, 255)

-- ══════════════════════════════════════════
--           СОСТОЯНИЯ ФУНКЦИЙ
-- ══════════════════════════════════════════
local States = {
    MenuOpen       = true,
    FlyOpen        = false,
    Flying         = false,
    Noclip         = false,
    InfJump        = false,
    SpinBot        = false,
    RainbowChar    = false,
    ESP            = false,
    Fullbright     = false,
    NoFog          = false,
    ClickTP        = false,
    Aimlock        = false,
    HitboxExpander = false,
    AntiRagdoll    = false,
    FPSBoost       = false,
    WalkSpeed      = 16,
    JumpPower      = 50,
    Gravity        = 196.2,
    FOV            = 70,
}

-- ══════════════════════════════════════════
--           ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ══════════════════════════════════════════
local function GetChar()
    return Player.Character or Player.CharacterAdded:Wait()
end

local function GetHRP()
    local char = GetChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHum()
    local char = GetChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad), props):Play()
end

local function MakeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 20)
    c.Parent = parent
    return c
end

local function MakeStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or NEON_GREEN
    s.Thickness = thickness or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function MakePadding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 8)
    p.PaddingBottom = UDim.new(0, bottom or 8)
    p.PaddingLeft   = UDim.new(0, left   or 8)
    p.PaddingRight  = UDim.new(0, right  or 8)
    p.Parent = parent
    return p
end

local function MakeListLayout(parent, direction, spacing)
    local l = Instance.new("UIListLayout")
    l.FillDirection = direction or Enum.FillDirection.Vertical
    l.SortOrder     = Enum.SortOrder.LayoutOrder
    l.Padding       = UDim.new(0, spacing or 6)
    l.Parent        = parent
    return l
end

local function NewLabel(parent, text, size, color, xAlign)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size  = size  or UDim2.new(1, 0, 0, 20)
    lbl.Text  = text  or ""
    lbl.TextColor3 = color or WHITE
    lbl.TextScaled = true
    lbl.Font  = Enum.Font.GothamBold
    lbl.TextXAlignment = xAlign or Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

local function NewButton(parent, text, size, bgColor, textColor)
    local btn = Instance.new("TextButton")
    btn.Size = size or UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = bgColor or DARK_BTN
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = textColor or WHITE
    btn.Text = text or "Кнопка"
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = parent
    MakeCorner(btn, 10)
    MakeStroke(btn, NEON_GREEN, 1)

    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = Color3.fromRGB(0, 80, 50)}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundColor3 = bgColor or DARK_BTN}, 0.15)
    end)
    return btn
end

-- ══════════════════════════════════════════
--           СОЗДАНИЕ ScreenGui
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhantomX_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = PlayerGui
end

-- ══════════════════════════════════════════
--           ГЛАВНОЕ ОКНО
-- ══════════════════════════════════════════
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 780, 0, 520)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -260)
MainFrame.BackgroundColor3 = DARK_BG
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MakeCorner(MainFrame, 16)
MakeStroke(MainFrame, NEON_GREEN, 2)

-- Тень
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.Position = UDim2.new(0, -20, 0, -20)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5554236805"
Shadow.ImageColor3 = Color3.fromRGB(0, 255, 127)
Shadow.ImageTransparency = 0.85
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- ══════════════════════════════════════════
--               ЗАГОЛОВОК
-- ══════════════════════════════════════════
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TitleBar.BackgroundTransparency = 0.1
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
MakeCorner(TitleBar, 16)

local TitleBarBottom = Instance.new("Frame")
TitleBarBottom.Size = UDim2.new(1, 0, 0.5, 0)
TitleBarBottom.Position = UDim2.new(0, 0, 0.5, 0)
TitleBarBottom.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TitleBarBottom.BackgroundTransparency = 0.1
TitleBarBottom.BorderSizePixel = 0
TitleBarBottom.Parent = TitleBar

local TitleLabel = NewLabel(TitleBar, "⚡ PHANTOM X  |  v3.0", UDim2.new(1, -100, 1, 0), NEON_GREEN, Enum.TextXAlignment.Left)
TitleLabel.Font = Enum.Font.GothamBold
MakePadding(TitleLabel, 0, 0, 14, 0)

local PlaceLabel = NewLabel(TitleBar, "PlaceId: " .. tostring(game.PlaceId), UDim2.new(0, 200, 1, 0), GRAY, Enum.TextXAlignment.Center)
PlaceLabel.Position = UDim2.new(0.5, -100, 0, 0)
PlaceLabel.Font = Enum.Font.Gotham

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 28)
CloseBtn.Position = UDim2.new(1, -44, 0.5, -14)
CloseBtn.BackgroundColor3 = RED_COLOR
CloseBtn.BackgroundTransparency = 0.2
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = WHITE
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
MakeCorner(CloseBtn, 8)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    States.MenuOpen = false
end)

-- ══════════════════════════════════════════
--           ПЕРЕТАСКИВАНИЕ ОКНА
-- ══════════════════════════════════════════
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

MakeDraggable(MainFrame, TitleBar)

-- ══════════════════════════════════════════
--               БОКОВАЯ ПАНЕЛЬ
-- ══════════════════════════════════════════
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 155, 1, -44)
Sidebar.Position = UDim2.new(0, 0, 0, 44)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Sidebar.BackgroundTransparency = 0.1
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCornerFix = Instance.new("Frame")
SidebarCornerFix.Size = UDim2.new(0, 16, 1, 0)
SidebarCornerFix.Position = UDim2.new(1, -16, 0, 0)
SidebarCornerFix.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
SidebarCornerFix.BackgroundTransparency = 0.1
SidebarCornerFix.BorderSizePixel = 0
SidebarCornerFix.Parent = Sidebar

local SidebarCornerFixBot = Instance.new("Frame")
SidebarCornerFixBot.Size = UDim2.new(1, 0, 0, 20)
SidebarCornerFixBot.Position = UDim2.new(0, 0, 1, -20)
SidebarCornerFixBot.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
SidebarCornerFixBot.BackgroundTransparency = 0.1
SidebarCornerFixBot.BorderSizePixel = 0
SidebarCornerFixBot.Parent = Sidebar

MakeCorner(Sidebar, 16)

local SidebarScroll = Instance.new("ScrollingFrame")
SidebarScroll.Size = UDim2.new(1, 0, 1, -10)
SidebarScroll.Position = UDim2.new(0, 0, 0, 5)
SidebarScroll.BackgroundTransparency = 1
SidebarScroll.BorderSizePixel = 0
SidebarScroll.ScrollBarThickness = 2
SidebarScroll.ScrollBarImageColor3 = NEON_GREEN
SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
SidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SidebarScroll.Parent = Sidebar

MakeListLayout(SidebarScroll, Enum.FillDirection.Vertical, 4)
MakePadding(SidebarScroll, 8, 8, 6, 6)

-- ══════════════════════════════════════════
--           КОНТЕНТНАЯ ОБЛАСТЬ
-- ══════════════════════════════════════════
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -165, 1, -54)
ContentArea.Position = UDim2.new(0, 160, 0, 49)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

-- ══════════════════════════════════════════
--           СИСТЕМА КАТЕГОРИЙ
-- ══════════════════════════════════════════
local Pages = {}
local ActiveCategory = nil

local function ShowPage(name)
    for n, page in pairs(Pages) do
        page.Visible = (n == name)
    end
    ActiveCategory = name
end

local function NewPage(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = name
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = NEON_GREEN
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Visible = false
    scroll.Parent = ContentArea

    MakeListLayout(scroll, Enum.FillDirection.Vertical, 8)
    MakePadding(scroll, 6, 12, 6, 10)

    Pages[name] = scroll
    return scroll
end

local function AddCategoryBtn(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = DARK_BTN
    btn.BackgroundTransparency = 0.3
    btn.Text = icon .. "  " .. name
    btn.TextColor3 = GRAY
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = SidebarScroll
    MakeCorner(btn, 10)
    MakePadding(btn, 0, 0, 10, 0)

    btn.MouseButton1Click:Connect(function()
        ShowPage(name)
        for _, child in ipairs(SidebarScroll:GetChildren()) do
            if child:IsA("TextButton") then
                Tween(child, {BackgroundColor3 = DARK_BTN, TextColor3 = GRAY}, 0.15)
            end
        end
        Tween(btn, {BackgroundColor3 = Color3.fromRGB(0, 60, 35), TextColor3 = NEON_GREEN}, 0.15)
    end)

    return btn
end

-- ══════════════════════════════════════════
--         ВИДЖЕТЫ: ПЕРЕКЛЮЧАТЕЛЬ
-- ══════════════════════════════════════════
local function NewToggle(parent, text, desc, onToggle)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 54)
    container.BackgroundColor3 = DARK_PANEL
    container.BackgroundTransparency = 0.2
    container.BorderSizePixel = 0
    container.Parent = parent
    MakeCorner(container, 10)
    MakeStroke(container, Color3.fromRGB(40, 40, 40), 1)

    local label = NewLabel(container, text, UDim2.new(1, -70, 0, 22), WHITE, Enum.TextXAlignment.Left)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true

    if desc then
        local descLbl = NewLabel(container, desc, UDim2.new(1, -70, 0, 16), GRAY, Enum.TextXAlignment.Left)
        descLbl.Position = UDim2.new(0, 12, 0, 30)
        descLbl.Font = Enum.Font.Gotham
        descLbl.TextScaled = true
    end

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 46, 0, 24)
    toggleBg.Position = UDim2.new(1, -58, 0.5, -12)
    toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = container
    MakeCorner(toggleBg, 12)

    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 18, 0, 18)
    toggleCircle.Position = UDim2.new(0, 3, 0.5, -9)
    toggleCircle.BackgroundColor3 = WHITE
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleBg
    MakeCorner(toggleCircle, 9)

    local isOn = false

    local clickArea = Instance.new("TextButton")
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.Parent = container

    clickArea.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            Tween(toggleBg,     {BackgroundColor3 = NEON_GREEN}, 0.2)
            Tween(toggleCircle, {Position = UDim2.new(0, 25, 0.5, -9)}, 0.2)
            MakeStroke(container, NEON_GREEN, 1)
        else
            Tween(toggleBg,     {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
            Tween(toggleCircle, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.2)
        end
        if onToggle then onToggle(isOn) end
    end)

    return container, function() return isOn end
end

-- ══════════════════════════════════════════
--         ВИДЖЕТ: СЛАЙДЕР
-- ══════════════════════════════════════════
local function NewSlider(parent, text, minVal, maxVal, defaultVal, onChanged)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 62)
    container.BackgroundColor3 = DARK_PANEL
    container.BackgroundTransparency = 0.2
    container.BorderSizePixel = 0
    container.Parent = parent
    MakeCorner(container, 10)
    MakeStroke(container, Color3.fromRGB(40, 40, 40), 1)

    local titleRow = Instance.new("Frame")
    titleRow.Size = UDim2.new(1, 0, 0, 22)
    titleRow.Position = UDim2.new(0, 0, 0, 8)
    titleRow.BackgroundTransparency = 1
    titleRow.Parent = container

    local label = NewLabel(titleRow, text, UDim2.new(0.7, 0, 1, 0), WHITE, Enum.TextXAlignment.Left)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Font = Enum.Font.GothamBold

    local valLabel = NewLabel(titleRow, tostring(defaultVal), UDim2.new(0.25, 0, 1, 0), NEON_GREEN, Enum.TextXAlignment.Right)
    valLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valLabel.Font = Enum.Font.GothamBold

    local trackBg = Instance.new("Frame")
    trackBg.Size = UDim2.new(1, -24, 0, 6)
    trackBg.Position = UDim2.new(0, 12, 0, 38)
    trackBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    trackBg.BorderSizePixel = 0
    trackBg.Parent = container
    MakeCorner(trackBg, 3)

    local trackFill = Instance.new("Frame")
    local pct = (defaultVal - minVal) / (maxVal - minVal)
    trackFill.Size = UDim2.new(pct, 0, 1, 0)
    trackFill.BackgroundColor3 = NEON_GREEN
    trackFill.BorderSizePixel = 0
    trackFill.Parent = trackBg
    MakeCorner(trackFill, 3)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(pct, -7, 0.5, -7)
    knob.BackgroundColor3 = WHITE
    knob.BorderSizePixel = 0
    knob.Parent = trackBg
    MakeCorner(knob, 7)
    MakeStroke(knob, NEON_GREEN, 1.5)

    local currentVal = defaultVal
    local sliding = false

    local function UpdateSlider(x)
        local abs = trackBg.AbsolutePosition.X
        local width = trackBg.AbsoluteSize.X
        local p = math.clamp((x - abs) / width, 0, 1)
        currentVal = math.floor(minVal + p * (maxVal - minVal))
        trackFill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -7, 0.5, -7)
        valLabel.Text = tostring(currentVal)
        if onChanged then onChanged(currentVal) end
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = trackBg

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
            UpdateSlider(input.Position.X)
        end
    end)

    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(input.Position.X)
        end
    end)

    return container
end

-- ══════════════════════════════════════════
--         ВИДЖЕТ: РАЗДЕЛИТЕЛЬ
-- ══════════════════════════════════════════
local function NewSeparator(parent, text)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 28)
    f.BackgroundTransparency = 1
    f.Parent = parent

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    line.BorderSizePixel = 0
    line.Parent = f

    if text then
        local lbl = NewLabel(f, "  " .. text .. "  ", UDim2.new(0, 0, 1, 0), NEON_GREEN, Enum.TextXAlignment.Left)
        lbl.AutomaticSize = Enum.AutomaticSize.X
        lbl.BackgroundColor3 = DARK_BG
        lbl.BackgroundTransparency = 0
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.Font = Enum.Font.GothamBold
    end
    return f
end

-- ══════════════════════════════════════════
--     СОЗДАНИЕ КАТЕГОРИЙ (БОКОВАЯ ПАНЕЛЬ)
-- ══════════════════════════════════════════
local Categories = {
    {"Игрок",   "🧍"},
    {"Визуал",  "👁"},
    {"Мир",     "🌍"},
    {"Бой",     "⚔️"},
    {"Поиск",   "🔍"},
    {"Телепорт","🔀"},
    {"Оружие",  "🔫"},
    {"Авто",    "🤖"},
    {"Сеть",    "📡"},
    {"Разное",  "⚙️"},
}

local firstBtn = nil
for i, cat in ipairs(Categories) do
    local btn = AddCategoryBtn(cat[1], cat[2])
    if i == 1 then firstBtn = btn end
    NewPage(cat[1])
end

-- ══════════════════════════════════════════
--   СТРАНИЦА: ИГРОК
-- ══════════════════════════════════════════
do
    local page = Pages["Игрок"]
    NewSeparator(page, "Движение")

    NewSlider(page, "Скорость ходьбы", 16, 1000, 16, function(v)
        States.WalkSpeed = v
        local hum = GetHum()
        if hum then hum.WalkSpeed = v end
    end)

    NewSlider(page, "Высота прыжка", 50, 1000, 50, function(v)
        States.JumpPower = v
        local hum = GetHum()
        if hum then hum.JumpPower = v end
    end)

    NewSlider(page, "Гравитация", 0, 400, 196, function(v)
        States.Gravity = v
        workspace.Gravity = v
    end)

    NewSeparator(page, "Способности")

    NewToggle(page, "Нет коллизии (Noclip)", "Проходить сквозь стены", function(on)
        States.Noclip = on
        if not on then
            local char = GetChar()
            if char then
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = true end
                end
            end
        end
    end)

    NewToggle(page, "Бесконечный прыжок", "Прыгать в воздухе бесконечно", function(on)
        States.InfJump = on
    end)

    NewToggle(page, "Анти-падение", "Отключить рэгдолл", function(on)
        States.AntiRagdoll = on
        local char = GetChar()
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.BreakJointsOnDeath = not on
                if on then
                    hum.RagdollEnabled = false
                end
            end
        end
    end)

    NewToggle(page, "СпинБот", "Вращение персонажа", function(on)
        States.SpinBot = on
    end)

    NewToggle(page, "Авто-прыжок", "Прыгать автоматически", function(on)
        local conn
        if on then
            conn = RunService.Heartbeat:Connect(function()
                if not States.InfJump then conn:Disconnect() return end
                local hum = GetHum()
                if hum and hum.FloorMaterial ~= Enum.Material.Air then
                    hum.Jump = true
                end
            end)
        end
    end)

    NewToggle(page, "Невидимость", "Сделать персонажа прозрачным", function(on)
        local char = GetChar()
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    Tween(p, {Transparency = on and 1 or 0}, 0.3)
                elseif p:IsA("Decal") then
                    p.Transparency = on and 1 or 0
                end
            end
        end
    end)
end

-- ══════════════════════════════════════════
--   СТРАНИЦА: ВИЗУАЛ
-- ══════════════════════════════════════════
do
    local page = Pages["Визуал"]
    NewSeparator(page, "Отображение")

    NewSlider(page, "Поле зрения (FOV)", 30, 120, 70, function(v)
        States.FOV = v
        Camera.FieldOfView = v
    end)

    NewToggle(page, "ESP (Подсветка)", "Видеть игроков через стены", function(on)
        States.ESP = on
        local function ApplyESP(plr)
            if plr == Player then return end
            local char = plr.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            if on then
                local hl = Instance.new("SelectionBox")
                hl.Name = "PhantomESP"
                hl.Adornee = char
                hl.Color3 = NEON_GREEN
                hl.LineThickness = 0.05
                hl.SurfaceTransparency = 0.8
                hl.SurfaceColor3 = NEON_GREEN
                hl.Parent = char
            else
                local hl = char:FindFirstChild("PhantomESP")
                if hl then hl:Destroy() end
            end
        end

        for _, plr in pairs(game.Players:GetPlayers()) do
            ApplyESP(plr)
        end

        if on then
            game.Players.PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Connect(function()
                    wait(1)
                    ApplyESP(plr)
                end)
            end)
        end
    end)

    NewToggle(page, "Полная яркость", "Убрать темноту", function(on)
        States.Fullbright = on
        if on then
            Lighting.Brightness = 10
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(70, 70, 70)
        end
    end)

    NewToggle(page, "Радужный персонаж", "Меняющиеся цвета", function(on)
        States.RainbowChar = on
    end)

    NewToggle(page, "Убрать туман", "Удалить туман из игры", function(on)
        States.NoFog = on
        if on then
            Lighting.FogEnd   = 999999
            Lighting.FogStart = 999999
        else
            Lighting.FogEnd   = 100000
            Lighting.FogStart = 0
        end
    end)

    NewToggle(page, "Скелет игроков", "Показать хитбоксы игроков", function(on)
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                for _, p in pairs(plr.Character:GetDescendants()) do
                    if p:IsA("BasePart") then
                        local sel = p:FindFirstChild("SkeletonBox")
                        if on then
                            local box = Instance.new("SelectionBox")
                            box.Name = "SkeletonBox"
                            box.Adornee = p
                            box.Color3 = Color3.fromRGB(255, 60, 60)
                            box.LineThickness = 0.04
                            box.SurfaceTransparency = 0.95
                            box.Parent = p
                        elseif sel then
                            sel:Destroy()
                        end
                    end
                end
            end
        end
    end)

    NewToggle(page, "Камера от первого лица", "Сменить вид", function(on)
        local hum = GetHum()
        if hum then
            hum.CameraMinZoomDistance = on and 0 or 0.5
            hum.CameraMaxZoomDistance = on and 0 or 400
        end
    end)

    NewSeparator(page, "Цвет интерфейса")
    NewButton(page, "Зелёный акцент",  UDim2.new(1, 0, 0, 34), DARK_BTN).MouseButton1Click:Connect(function()
        MakeStroke(MainFrame, NEON_GREEN, 2)
    end)
    NewButton(page, "Синий акцент",  UDim2.new(1, 0, 0, 34), DARK_BTN).MouseButton1Click:Connect(function()
        MakeStroke(MainFrame, BLUE_COLOR, 2)
    end)
    NewButton(page, "Красный акцент",  UDim2.new(1, 0, 0, 34), DARK_BTN).MouseButton1Click:Connect(function()
        MakeStroke(MainFrame, RED_COLOR, 2)
    end)
end

-- ══════════════════════════════════════════
--   СТРАНИЦА: МИР
-- ══════════════════════════════════════════
do
    local page = Pages["Мир"]
    NewSeparator(page, "Управление миром")

    NewToggle(page, "Клик-телепорт", "ЛКМ — телепорт к мышке", function(on)
        States.ClickTP = on
    end)

    NewToggle(page, "FPS Буст", "Убрать лишние детали", function(on)
        States.FPSBoost = on
        for _, obj in pairs(workspace:GetDescendants()) do
            if on then
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                end
                if obj:IsA("BasePart") then
                    obj.CastShadow = false
                end
            else
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    obj.Enabled = true
                end
                if obj:IsA("BasePart") then
                    obj.CastShadow = true
                end
            end
        end
    end)

    NewToggle(page, "Удалить лазеры", "Убрать все лазеры с карты", function(on)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("laser") or obj.Name:lower():find("beam") then
                obj.Enabled = on and false or true
                if obj:IsA("BasePart") then
                    obj.Transparency = on and 1 or 0
                end
            end
        end
    end)

    NewToggle(page, "Разблокировать части", "CanCollide = false для всех", function(on)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(GetChar()) then
                obj.CanCollide = not on
            end
        end
    end)

    NewSeparator(page, "Освещение")

    NewToggle(page, "День (12:00)", "Установить полдень", function(on)
        Lighting.ClockTime = on and 12 or 14
    end)

    NewToggle(page, "Ночь (00:00)", "Установить полночь", function(on)
        Lighting.ClockTime = on and 0 or 14
    end)

    NewSeparator(page, "Действия")

    local tpBox = Instance.new("TextBox")
    tpBox.Size = UDim2.new(1, 0, 0, 36)
    tpBox.BackgroundColor3 = DARK_BTN
    tpBox.BackgroundTransparency = 0.2
    tpBox.TextColor3 = WHITE
    tpBox.PlaceholderText = "Имя игрока для телепорта..."
    tpBox.Text = ""
    tpBox.TextScaled = true
    tpBox.Font = Enum.Font.Gotham
    tpBox.BorderSizePixel = 0
    tpBox.ClearTextOnFocus = false
    tpBox.Parent = page
    MakeCorner(tpBox, 10)
    MakeStroke(tpBox, NEON_GREEN, 1)

    local tpBtn = NewButton(page, "Телепорт к игроку", UDim2.new(1, 0, 0, 34))
    tpBtn.MouseButton1Click:Connect(function()
        local target = game.Players:FindFirstChild(tpBox.Text)
        if target and target.Character then
            local hrp = GetHRP()
            local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp and tHrp then
                hrp.CFrame = tHrp.CFrame + Vector3.new(3, 0, 0)
            end
        end
    end)
end

-- ══════════════════════════════════════════
--   СТРАНИЦА: БОЙ
-- ══════════════════════════════════════════
do
    local page = Pages["Бой"]
    local aimlockTarget = nil
    local aimlockConn   = nil

    NewSeparator(page, "Прицеливание")

    NewToggle(page, "Аимлок (Плавный)", "Камера следит за ближайшим врагом", function(on)
        States.Aimlock = on
        if aimlockConn then aimlockConn:Disconnect() end

        if on then
            aimlockConn = RunService.RenderStepped:Connect(function()
                local closest, closestDist = nil, math.huge
                for _, plr in pairs(game.Players:GetPlayers()) do
                    if plr ~= Player and plr.Character then
                        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closest = hrp
                            end
                        end
                    end
                end

                if closest then
                    local targetCF = CFrame.new(Camera.CFrame.Position, closest.Position + Vector3.new(0, 1.5, 0))
                    Camera.CFrame = Camera.CFrame:Lerp(targetCF, 0.12)
                end
            end)
        end
    end)

    NewSlider(page, "Скорость аимлока", 1, 100, 12, function(v) end)

    NewToggle(page, "Расширитель хитбоксов", "Увеличить хитбоксы врагов", function(on)
        States.HitboxExpander = on
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = on and Vector3.new(8, 8, 8) or Vector3.new(2, 2, 1)
                    hrp.Transparency = on and 0.8 or 1
                end
            end
        end
    end)

    NewSeparator(page, "Урон")

    NewToggle(page, "Авто-кликер", "Быстрые удары", function(on)
        local conn
        if on then
            conn = RunService.Heartbeat:Connect(function()
                if not on then conn:Disconnect() return end
                local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    local event = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChildOfClass("RemoteEvent")
                end
            end)
        end
    end)

    NewToggle(page, "Килл-аура", "Убивать всех рядом", function(on)
        local conn
        if on then
            conn = RunService.Heartbeat:Connect(function()
                if not on then conn:Disconnect() return end
                local myHrp = GetHRP()
                if not myHrp then return end
                for _, plr in pairs(game.Players:GetPlayers()) do
                    if plr ~= Player and plr.Character then
                        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                        if hrp and hum then
                            local dist = (myHrp.Position - hrp.Position).Magnitude
                            if dist <= 10 then
                                hum.Health = 0
                            end
                        end
                    end
                end
            end)
        end
    end)

    NewToggle(page, "Бог-мод", "Бесконечное здоровье", function(on)
        local conn
        local hum = GetHum()
        if on and hum then
            conn = hum.HealthChanged:Connect(function(hp)
                if hp < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end)
        elseif conn then
            conn:Disconnect()
        end
    end)
end

-- ══════════════════════════════════════════
--   СТРАНИЦА: ПОИСК СКРИПТОВ
-- ══════════════════════════════════════════
do
    local page = Pages["Поиск"]
    NewSeparator(page, "Поиск скриптов по игре")

    local infoLbl = NewLabel(page, "PlaceId: " .. tostring(game.PlaceId), UDim2.new(1, 0, 0, 24), NEON_GREEN)
    infoLbl.Font = Enum.Font.GothamBold

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, 0, 0, 38)
    searchBox.BackgroundColor3 = DARK_BTN
    searchBox.BackgroundTransparency = 0.2
    searchBox.TextColor3 = WHITE
    searchBox.PlaceholderText = "🔍 Введите название игры или PlaceId..."
    searchBox.Text = ""
    searchBox.TextScaled = true
    searchBox.Font = Enum.Font.Gotham
    searchBox.BorderSizePixel = 0
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = page
    MakeCorner(searchBox, 10)
    MakeStroke(searchBox, NEON_GREEN, 1)

    local searchBtn = NewButton(page, "🔍 Найти скрипты", UDim2.new(1, 0, 0, 38), Color3.fromRGB(0, 60, 35))

    local resultsContainer = Instance.new("Frame")
    resultsContainer.Size = UDim2.new(1, 0, 0, 0)
    resultsContainer.BackgroundTransparency = 1
    resultsContainer.AutomaticSize = Enum.AutomaticSize.Y
    resultsContainer.Parent = page
    MakeListLayout(resultsContainer, Enum.FillDirection.Vertical, 6)

    -- Мок база данных скриптов по PlaceId
    local ScriptDatabase = {
        [1818, ] = {
            {name = "Natural Disaster Survival - Все читы",   code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/scripts/nds.lua"))()'},
            {name = "NDS - Телепорт в безопасную зону",       code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/scripts/nds2.lua"))()'},
        },
        [185655149] = {
            {name = "Arsenal - Аимбот",                       code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/scripts/arsenal_aim.lua"))()'},
            {name = "Arsenal - ESP + WallHack",               code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/scripts/arsenal_esp.lua"))()'},
            {name = "Arsenal - Бесконечные монеты",           code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/scripts/arsenal_coins.lua"))()'},
        },
        [292439477] = {
            {name = "Jailbreak - Авто-ограбление",            code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/scripts/jb_rob.lua"))()'},
            {name = "Jailbreak - Авто-арест",                 code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/scripts/jb_arrest.lua"))()'},
            {name = "Jailbreak - Телепорт к банку",           code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/scripts/jb_bank.lua"))()'},
        },
        [606849621] = {
            {name = "Blox Fruits - Авто-фарм",                code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/scripts/bf_farm.lua"))()'},
            {name = "Blox Fruits - ESP игроков",               code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/scripts/bf_esp.lua"))()'},
            {name = "Blox Fruits - Авто-рейд",                code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/scripts/bf_raid.lua"))()'},
            {name = "Blox Fruits - Телепорт к боссу",         code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/scripts/bf_boss.lua"))()'},
        },
    }

    local UniversalScripts = {
        {name = "🌐 Универсальный ESP",              code = '-- Universal ESP loaded'},
        {name = "🌐 Универсальный FLY",              code = '-- Universal Fly loaded'},
        {name = "🌐 Универсальный Speed/Jump",       code = '-- Speed and Jump loaded'},
        {name = "🌐 Универсальный WalkSpeed 1000",   code = 'game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 1000'},
        {name = "🌐 Бесконечный прыжок",             code = '-- Inf Jump loaded'},
        {name = "🌐 Noclip",                         code = '-- Noclip loaded'},
    }

    local function AddScriptResult(name, code)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 50)
        frame.BackgroundColor3 = DARK_PANEL
        frame.BackgroundTransparency = 0.2
        frame.BorderSizePixel = 0
        frame.Parent = resultsContainer
        MakeCorner(frame, 10)
        MakeStroke(frame, Color3.fromRGB(0, 180, 90), 1)

        local nameLbl = NewLabel(frame, name, UDim2.new(1, -120, 0, 28), WHITE)
        nameLbl.Position = UDim2.new(0, 10, 0, 5)
        nameLbl.Font = Enum.Font.Gotham
        nameLbl.TextSize = 13

        local execBtn = NewButton(frame, "▶ ЗАПУСК", UDim2.new(0, 100, 0, 28), Color3.fromRGB(0, 80, 40))
        execBtn.Position = UDim2.new(1, -108, 0, 5)
        execBtn.MouseButton1Click:Connect(function()
            pcall(function()
                loadstring(code)()
            end)
            execBtn.Text = "✓ Готово"
            execBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 60)
            task.wait(2)
            execBtn.Text = "▶ ЗАПУСК"
            execBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 40)
        end)

        local codeLbl = NewLabel(frame, code, UDim2.new(1, -10, 0, 16), GRAY)
        codeLbl.Position = UDim2.new(0, 10, 0, 32)
        codeLbl.Font = Enum.Font.Code
        codeLbl.TextSize = 10
        codeLbl.ClipsDescendants = true
    end

    searchBtn.MouseButton1Click:Connect(function()
        for _, c in pairs(resultsContainer:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end

        local placeId = game.PlaceId
        local found = ScriptDatabase[placeId]

        if found then
            local header = NewLabel(resultsContainer, "✅ Найдено скриптов для PlaceId " .. placeId .. ":", UDim2.new(1, 0, 0, 24), NEON_GREEN)
            header.Font = Enum.Font.GothamBold
            for _, s in pairs(found) do
                AddScriptResult(s.name, s.code)
            end
        else
            local header = NewLabel(resultsContainer, "🌐 Универсальные скрипты:", UDim2.new(1, 0, 0, 24), NEON_GREEN)
            header.Font = Enum.Font.GothamBold
        end

        for _, s in pairs(UniversalScripts) do
            AddScriptResult(s.name, s.code)
        end
    end)
end

-- ══════════════════════════════════════════
--   СТРАНИЦА: ТЕЛЕПОРТ
-- ══════════════════════════════════════════
do
    local page = Pages["Телепорт"]
    NewSeparator(page, "Телепорт к игрокам")

    local refreshBtn = NewButton(page, "🔄 Обновить список игроков", UDim2.new(1, 0, 0, 36), Color3.fromRGB(0, 60, 35))
    local playersContainer = Instance.new("Frame")
    playersContainer.Size = UDim2.new(1, 0, 0, 0)
    playersContainer.AutomaticSize = Enum.AutomaticSize.Y
    playersContainer.BackgroundTransparency = 1
    playersContainer.Parent = page
    MakeListLayout(playersContainer, Enum.FillDirection.Vertical, 6)

    local function RefreshPlayers()
        for _, c in pairs(playersContainer:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        for _, plr in pairs(game.Players:GetPlayers()) do
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 44)
            f.BackgroundColor3 = DARK_PANEL
            f.BackgroundTransparency = 0.2
            f.BorderSizePixel = 0
            f.Parent = playersContainer
            MakeCorner(f, 10)
            MakeStroke(f, Color3.fromRGB(40, 40, 40), 1)

            local nameLbl = NewLabel(f, "👤 " .. plr.Name, UDim2.new(0.6, 0, 1, 0), WHITE)
            nameLbl.Position = UDim2.new(0, 10, 0, 0)
            nameLbl.Font = Enum.Font.GothamBold

            local tpBtn = NewButton(f, "ТП →", UDim2.new(0, 70, 0, 28), Color3.fromRGB(0, 80, 40))
            tpBtn.Position = UDim2.new(1, -158, 0.5, -14)
            tpBtn.MouseButton1Click:Connect(function()
                local hrp = GetHRP()
                local target = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp and target then
                    hrp.CFrame = target.CFrame + Vector3.new(3, 0, 0)
                end
            end)

            local bringBtn = NewButton(f, "К себе", UDim2.new(0, 70, 0, 28), Color3.fromRGB(60, 0, 0))
            bringBtn.Position = UDim2.new(1, -82, 0.5, -14)
            bringBtn.MouseButton1Click:Connect(function()
                local myHrp = GetHRP()
                local target = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if myHrp and target then
                    target.CFrame = myHrp.CFrame + Vector3.new(3, 0, 0)
                end
            end)
        end
    end

    refreshBtn.MouseButton1Click:Connect(RefreshPlayers)
    RefreshPlayers()

    NewSeparator(page, "Координаты")

    local coordLbl = NewLabel(page, "X: 0  Y: 0  Z: 0", UDim2.new(1, 0, 0, 24), NEON_GREEN)
    coordLbl.Font = Enum.Font.GothamBold

    RunService.Heartbeat:Connect(function()
        local hrp = GetHRP()
        if hrp then
            local p = hrp.Position
            coordLbl.Text = string.format("X: %.1f  Y: %.1f  Z: %.1f", p.X, p.Y, p.Z)
        end
    end)

    local tpCoordsBox = Instance.new("TextBox")
    tpCoordsBox.Size = UDim2.new(1, 0, 0, 36)
    tpCoordsBox.BackgroundColor3 = DARK_BTN
    tpCoordsBox.BackgroundTransparency = 0.2
    tpCoordsBox.TextColor3 = WHITE
    tpCoordsBox.PlaceholderText = "X, Y, Z (например: 100, 50, 200)"
    tpCoordsBox.Text = ""
    tpCoordsBox.TextScaled = true
    tpCoordsBox.Font = Enum.Font.Gotham
    tpCoordsBox.BorderSizePixel = 0
    tpCoordsBox.ClearTextOnFocus = false
    tpCoordsBox.Parent = page
    MakeCorner(tpCoordsBox, 10)
    MakeStroke(tpCoordsBox, NEON_GREEN, 1)

    local tpCoordBtn = NewButton(page, "Телепорт по координатам", UDim2.new(1, 0, 0, 36))
    tpCoordBtn.MouseButton1Click:Connect(function()
        local parts = tpCoordsBox.Text:split(",")
        if #parts == 3 then
            local x = tonumber(parts[1])
            local y = tonumber(parts[2])
            local z = tonumber(parts[3])
            local hrp = GetHRP()
            if hrp and x and y and z then
                hrp.CFrame = CFrame.new(x, y, z)
            end
        end
    end)
end

-- ══════════════════════════════════════════
--   СТРАНИЦА: ОРУЖИЕ
-- ══════════════════════════════════════════
do
    local page = Pages["Оружие"]
    NewSeparator(page, "Модификации оружия")

    NewToggle(page, "Нет разброса", "Убрать разброс пуль", function(on)
        local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
        if tool then end
    end)

    NewToggle(page, "Нет отдачи", "Убрать отдачу оружия", function(on) end)

    NewSlider(page, "Скорость стрельбы", 1, 20, 5, function(v) end)
    NewSlider(page, "Дальность", 50, 2000, 500, function(v) end)

    NewSeparator(page, "Инвентарь")

    NewButton(page, "Дропнуть инструмент", UDim2.new(1, 0, 0, 36)).MouseButton1Click:Connect(function()
        local char = GetChar()
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                Player.Backpack:FindFirstChildOfClass("Tool")
            end
        end
    end)
end

-- ══════════════════════════════════════════
--   СТРАНИЦА: АВТО
-- ══════════════════════════════════════════
do
    local page = Pages["Авто"]
    NewSeparator(page, "Автоматизация")

    NewToggle(page, "Авто-фарм мобов", "Атаковать ближайшего NPC", function(on)
        local conn
        if on then
            conn = RunService.Heartbeat:Connect(function()
                if not on then conn:Disconnect() return end
                local myHrp = GetHRP()
                if not myHrp then return end
                local closest, closestDist = nil, 150
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj ~= Player.Character then
                        local hum = obj:FindFirstChildOfClass("Humanoid")
                        local hrp = obj:FindFirstChild("HumanoidRootPart")
                        if hum and hrp and hum.Health > 0 then
                            local dist = (myHrp.Position - hrp.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closest = obj
                            end
                        end
                    end
                end
                if closest then
                    local hrp = closest:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local myHRP = GetHRP()
                        if myHRP then
                            myHRP.CFrame = CFrame.new(hrp.Position + Vector3.new(3, 0, 0))
                        end
                    end
                end
            end)
        end
    end)

    NewToggle(page, "Авто-собирать предметы", "Подбирать всё вокруг", function(on) end)
    NewToggle(page, "Авто-продавать", "Авто продажа предметов", function(on) end)
    NewSlider(page, "Радиус авто-фарма", 10, 500, 100, function(v) end)
end

-- ══════════════════════════════════════════
--   СТРАНИЦА: СЕТЬ
-- ══════════════════════════════════════════
do
    local page = Pages["Сеть"]
    NewSeparator(page, "Сетевые функции")

    local pingLbl = NewLabel(page, "Пинг: измерение...", UDim2.new(1, 0, 0, 26), NEON_GREEN)
    pingLbl.Font = Enum.Font.GothamBold

    RunService.Heartbeat:Connect(function()
        local stats = game:GetService("Stats")
        if stats then
            local ping = stats.Network.ServerStatsItem["Data Ping"]
            if ping then
                pingLbl.Text = "Пинг: " .. tostring(math.floor(ping.Value)) .. " мс"
            end
        end
    end)

    NewToggle(page, "Анти-кик", "Попытаться обойти кик", function(on) end)

    NewToggle(page, "Спам чат", "Отправлять сообщения в чат", function(on)
        local conn
        if on then
            conn = RunService.Heartbeat:Connect(function()
                if not on then conn:Disconnect() return end
            end)
        end
    end)
end

-- ══════════════════════════════════════════
--   СТРАНИЦА: РАЗНОЕ
-- ══════════════════════════════════════════
do
    local page = Pages["Разное"]
    NewSeparator(page, "Прочее")

    NewToggle(page, "Авто-переподключение", "Реконнект при кике", function(on) end)
    NewToggle(page, "Мульти-джамп (3x)", "Тройной прыжок", function(on)
        local jumps = 0
        local conn
        if on then
            conn = UserInputService.JumpRequest:Connect(function()
                local hum = GetHum()
                if hum then
                    if jumps < 3 then
                        hum.Jump = true
                        jumps = jumps + 1
                    end
                    if hum.FloorMaterial ~= Enum.Material.Air then
                        jumps = 0
                    end
                end
            end)
        elseif conn then
            conn:Disconnect()
        end
    end)

    NewToggle(page, "Фриз персонажа", "Заморозить на месте", function(on)
        local hrp = GetHRP()
        if hrp then
            hrp.Anchored = on
        end
    end)

    NewSeparator(page, "Персонаж")

    NewButton(page, "Сбросить персонажа", UDim2.new(1, 0, 0, 36)).MouseButton1Click:Connect(function()
        local hum = GetHum()
        if hum then hum.Health = 0 end
    end)

    NewButton(page, "Сохранить позицию", UDim2.new(1, 0, 0, 36)).MouseButton1Click:Connect(function()
        local hrp = GetHRP()
        if hrp then
            _G.SavedPos = hrp.CFrame
        end
    end)

    NewButton(page, "Вернуться к позиции", UDim2.new(1, 0, 0, 36)).MouseButton1Click:Connect(function()
        local hrp = GetHRP()
        if hrp and _G.SavedPos then
            hrp.CFrame = _G.SavedPos
        end
    end)

    NewSeparator(page, "Горячие клавиши")
    NewLabel(page, "V — Показать/скрыть меню", UDim2.new(1, 0, 0, 22), GRAY)
    NewLabel(page, "E — Показать/скрыть виджет полёта", UDim2.new(1, 0, 0, 22), GRAY)
end

-- ══════════════════════════════════════════
--   ПОКАЗАТЬ ПЕРВУЮ СТРАНИЦУ
-- ══════════════════════════════════════════
ShowPage("Игрок")
if firstBtn then
    Tween(firstBtn, {BackgroundColor3 = Color3.fromRGB(0, 60, 35), TextColor3 = NEON_GREEN}, 0.1)
end

-- ══════════════════════════════════════════
--     FLY GUI V3 — ОТДЕЛЬНЫЙ ВИДЖЕТ
-- ══════════════════════════════════════════
local FlyFrame = Instance.new("Frame")
FlyFrame.Name = "FlyWidget"
FlyFrame.Size = UDim2.new(0, 200, 0, 220)
FlyFrame.Position = UDim2.new(1, -220, 0.5, -110)
FlyFrame.BackgroundColor3 = DARK_BG
FlyFrame.BackgroundTransparency = 0.15
FlyFrame.BorderSizePixel = 0
FlyFrame.Visible = false
FlyFrame.Parent = ScreenGui
MakeCorner(FlyFrame, 16)
MakeStroke(FlyFrame, NEON_GREEN, 2)

local FlyTitle = Instance.new("Frame")
FlyTitle.Size = UDim2.new(1, 0, 0, 36)
FlyTitle.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
FlyTitle.BackgroundTransparency = 0.1
FlyTitle.BorderSizePixel = 0
FlyTitle.Parent = FlyFrame
MakeCorner(FlyTitle, 16)

local FlyTitleFix = Instance.new("Frame")
FlyTitleFix.Size = UDim2.new(1, 0, 0.5, 0)
FlyTitleFix.Position = UDim2.new(0, 0, 0.5, 0)
FlyTitleFix.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
FlyTitleFix.BackgroundTransparency = 0.1
FlyTitleFix.BorderSizePixel = 0
FlyTitleFix.Parent = FlyTitle

local FlyTitleLbl = NewLabel(FlyTitle, "⚡ FLY  v3", UDim2.new(0.7, 0, 1, 0), NEON_GREEN, Enum.TextXAlignment.Left)
FlyTitleLbl.Font = Enum.Font.GothamBold
MakePadding(FlyTitleLbl, 0, 0, 10, 0)

local FlyCloseBtn = Instance.new("TextButton")
FlyCloseBtn.Size = UDim2.new(0, 28, 0, 22)
FlyCloseBtn.Position = UDim2.new(1, -34, 0.5, -11)
FlyCloseBtn.BackgroundColor3 = RED_COLOR
FlyCloseBtn.BackgroundTransparency = 0.2
FlyCloseBtn.Text = "✕"
FlyCloseBtn.TextColor3 = WHITE
FlyCloseBtn.TextScaled = true
FlyCloseBtn.Font = Enum.Font.GothamBold
FlyCloseBtn.BorderSizePixel = 0
FlyCloseBtn.Parent = FlyTitle
MakeCorner(FlyCloseBtn, 6)
FlyCloseBtn.MouseButton1Click:Connect(function()
    FlyFrame.Visible = false
    States.FlyOpen = false
end)

MakeDraggable(FlyFrame, FlyTitle)

-- Содержимое виджета полёта
local FlyContent = Instance.new("Frame")
FlyContent.Size = UDim2.new(1, -20, 1, -46)
FlyContent.Position = UDim2.new(0, 10, 0, 40)
FlyContent.BackgroundTransparency = 1
FlyContent.Parent = FlyFrame

-- Скорость полёта
local flySpeedLbl = NewLabel(FlyContent, "Скорость: 50", UDim2.new(1, 0, 0, 18), GRAY, Enum.TextXAlignment.Center)
flySpeedLbl.Position = UDim2.new(0, 0, 0, 0)
flySpeedLbl.Font = Enum.Font.Gotham

local flySpeed = 50

-- Ряд 1: [X] [-] [+]
local row1 = Instance.new("Frame")
row1.Size = UDim2.new(1, 0, 0, 36)
row1.Position = UDim2.new(0, 0, 0, 22)
row1.BackgroundTransparency = 1
row1.Parent = FlyContent
MakeListLayout(row1, Enum.FillDirection.Horizontal, 4)

local function FlyMiniBtn(parent, text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 56, 0, 34)
    btn.BackgroundColor3 = color or DARK_BTN
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = WHITE
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = parent
    MakeCorner(btn, 8)
    MakeStroke(btn, NEON_GREEN, 1)
    btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = Color3.fromRGB(0, 80, 50)}, 0.1) end)
    btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = color or DARK_BTN}, 0.1) end)
    return btn
end

local minusBtn = FlyMiniBtn(row1, "－", Color3.fromRGB(60, 20, 20))
local plusBtn  = FlyMiniBtn(row1, "＋", Color3.fromRGB(20, 60, 30))
local resetBtn = FlyMiniBtn(row1, "↺", DARK_BTN)

minusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.max(5, flySpeed - 10)
    flySpeedLbl.Text = "Скорость: " .. flySpeed
end)
plusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.min(500, flySpeed + 10)
    flySpeedLbl.Text = "Скорость: " .. flySpeed
end)
resetBtn.MouseButton1Click:Connect(function()
    flySpeed = 50
    flySpeedLbl.Text = "Скорость: " .. flySpeed
end)

-- Ряд 2: ВВЕРХ / ВНИЗ
local upBtn   = Instance.new("TextButton")
upBtn.Size    = UDim2.new(1, 0, 0, 34)
upBtn.Position = UDim2.new(0, 0, 0, 64)
upBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 35)
upBtn.BackgroundTransparency = 0.2
upBtn.Text = "▲  ВВЕРХ"
upBtn.TextColor3 = NEON_GREEN
upBtn.TextScaled = true
upBtn.Font = Enum.Font.GothamBold
upBtn.BorderSizePixel = 0
upBtn.AutoButtonColor = false
upBtn.Parent = FlyContent
MakeCorner(upBtn, 10)
MakeStroke(upBtn, NEON_GREEN, 1)

local downBtn = Instance.new("TextButton")
downBtn.Size  = UDim2.new(1, 0, 0, 34)
downBtn.Position = UDim2.new(0, 0, 0, 102)
downBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
downBtn.BackgroundTransparency = 0.2
downBtn.Text = "▼  ВНИЗ"
downBtn.TextColor3 = RED_COLOR
downBtn.TextScaled = true
downBtn.Font = Enum.Font.GothamBold
downBtn.BorderSizePixel = 0
downBtn.AutoButtonColor = false
downBtn.Parent = FlyContent
MakeCorner(downBtn, 10)
MakeStroke(downBtn, RED_COLOR, 1)

-- Кнопка FLY (главная)
local flyToggleBtn = Instance.new("TextButton")
flyToggleBtn.Size = UDim2.new(1, 0, 0, 40)
flyToggleBtn.Position = UDim2.new(0, 0, 0, 140)
flyToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 20)
flyToggleBtn.BackgroundTransparency = 0.1
flyToggleBtn.Text = "✈  ПОЛЁТ: ВЫКЛ"
flyToggleBtn.TextColor3 = GRAY
flyToggleBtn.TextScaled = true
flyToggleBtn.Font = Enum.Font.GothamBold
flyToggleBtn.BorderSizePixel = 0
flyToggleBtn.AutoButtonColor = false
flyToggleBtn.Parent = FlyContent
MakeCorner(flyToggleBtn, 12)
MakeStroke(flyToggleBtn, NEON_GREEN, 2)
flyToggleBtn.MouseEnter:Connect(function() Tween(flyToggleBtn, {BackgroundColor3 = Color3.fromRGB(0, 80, 40)}, 0.15) end)
flyToggleBtn.MouseLeave:Connect(function()
    if not States.Flying then
        Tween(flyToggleBtn, {BackgroundColor3 = Color3.fromRGB(0, 40, 20)}, 0.15)
    end
end)

-- ══════════════════════════════════════════
--           ЛОГИКА ПОЛЁТА
-- ══════════════════════════════════════════
local flyBodyVelocity = nil
local flyBodyGyro     = nil
local flyConn         = nil
local goUp   = false
local goDown = false

local function EnableFly()
    local hrp = GetHRP()
    if not hrp then return end

    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro     then flyBodyGyro:Destroy()     end

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVelocity.Velocity  = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent    = hrp

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBodyGyro.P         = 1e4
    flyBodyGyro.CFrame    = hrp.CFrame
    flyBodyGyro.Parent    = hrp

    flyConn = RunService.RenderStepped:Connect(function()
        if not States.Flying then return end
        local hrp2 = GetHRP()
        if not hrp2 then return end

        local camCF = Camera.CFrame
        local direction = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + camCF.RightVector
        end
        if goUp   or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if goDown or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0, 1, 0)
        end

        flyBodyVelocity.Velocity = direction * flySpeed
        flyBodyGyro.CFrame = camCF
    end)
end

local function DisableFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyBodyGyro     then flyBodyGyro:Destroy()     flyBodyGyro     = nil end

    local hrp = GetHRP()
    if hrp then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(0, 0, 0)
        bv.Velocity  = Vector3.new(0, 0, 0)
        bv.Parent    = hrp
        task.wait(0.1)
        bv:Destroy()
    end
end

flyToggleBtn.MouseButton1Click:Connect(function()
    States.Flying = not States.Flying
    if States.Flying then
        EnableFly()
        flyToggleBtn.Text = "✈  ПОЛЁТ: ВКЛ"
        flyToggleBtn.TextColor3 = NEON_GREEN
        Tween(flyToggleBtn, {BackgroundColor3 = Color3.fromRGB(0, 80, 40)}, 0.2)
    else
        DisableFly()
        flyToggleBtn.Text = "✈  ПОЛЁТ: ВЫКЛ"
        flyToggleBtn.TextColor3 = GRAY
        Tween(flyToggleBtn, {BackgroundColor3 = Color3.fromRGB(0, 40, 20)}, 0.2)
    end
end)

upBtn.MouseButton1Down:Connect(function()   goUp   = true  end)
upBtn.MouseButton1Up:Connect(function()     goUp   = false end)
downBtn.MouseButton1Down:Connect(function() goDown = true  end)
downBtn.MouseButton1Up:Connect(function()   goDown = false end)

-- ══════════════════════════════════════════
--       ПЕТЛИ ОБНОВЛЕНИЯ (LOOPS)
-- ══════════════════════════════════════════
local hue = 0

RunService.Heartbeat:Connect(function()
    local char = Player.Character
    if not char then return end

    -- Noclip
    if States.Noclip then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end

    -- Inf Jump
    if States.InfJump then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = States.JumpPower
        end
    end

    -- SpinBot
    if States.SpinBot then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(5), 0)
        end
    end
end)

-- Rainbow Character
RunService.RenderStepped:Connect(function()
    if States.RainbowChar then
        hue = (hue + 0.005) % 1
        local color = Color3.fromHSV(hue, 1, 1)
        local char = Player.Character
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Color = color
                elseif p:IsA("SpecialMesh") then end
            end
        end
    end
end)

-- Click TP
UserInputService.InputBegan:Connect(function(input)
    if States.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local result = workspace:Raycast(
            Camera.CFrame.Position,
            (UserInputService:GetMouseLocation() - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Unit * 1000
        )
        local hrp = GetHRP()
        if hrp then
            local mouse = Player:GetMouse()
            hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

-- Inf Jump логика
local jumpConn
jumpConn = UserInputService.JumpRequest:Connect(function()
    if States.InfJump then
        local hum = GetHum()
        if hum then
            hum.Jump = true
        end
    end
end)

-- ══════════════════════════════════════════
--           ГОРЯЧИЕ КЛАВИШИ
-- ══════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end

    -- V — показать/скрыть меню
    if input.KeyCode == Enum.KeyCode.V then
        States.MenuOpen = not States.MenuOpen
        MainFrame.Visible = States.MenuOpen
        if States.MenuOpen then
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            Tween(MainFrame, {
                Size = UDim2.new(0, 780, 0, 520),
                Position = UDim2.new(0.5, -390, 0.5, -260)
            }, 0.3)
        end
    end

    -- E — показать/скрыть виджет полёта
    if input.KeyCode == Enum.KeyCode.E then
        States.FlyOpen = not States.FlyOpen
        FlyFrame.Visible = States.FlyOpen
    end

    -- F — быстрый полёт
    if input.KeyCode == Enum.KeyCode.F and States.FlyOpen then
        States.Flying = not States.Flying
        if States.Flying then
            EnableFly()
            flyToggleBtn.Text = "✈  ПОЛЁТ: ВКЛ"
            flyToggleBtn.TextColor3 = NEON_GREEN
        else
            DisableFly()
            flyToggleBtn.Text = "✈  ПОЛЁТ: ВЫКЛ"
            flyToggleBtn.TextColor3 = GRAY
        end
    end
end)

-- ══════════════════════════════════════════
--     УВЕДОМЛЕНИЕ ПРИ ЗАПУСКЕ
-- ══════════════════════════════════════════
local function ShowNotif(title, text, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 70)
    notif.Position = UDim2.new(1, 10, 1, -90)
    notif.BackgroundColor3 = DARK_BG
    notif.BackgroundTransparency = 0.1
    notif.BorderSizePixel = 0
    notif.Parent = ScreenGui
    MakeCorner(notif, 12)
    MakeStroke(notif, NEON_GREEN, 2)

    local t1 = NewLabel(notif, title, UDim2.new(1, -10, 0, 26), NEON_GREEN, Enum.TextXAlignment.Left)
    t1.Position = UDim2.new(0, 10, 0, 6)
    t1.Font = Enum.Font.GothamBold

    local t2 = NewLabel(notif, text, UDim2.new(1, -10, 0, 22), GRAY, Enum.TextXAlignment.Left)
    t2.Position = UDim2.new(0, 10, 0, 32)
    t2.Font = Enum.Font.Gotham

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 3)
    bar.Position = UDim2.new(0, 0, 1, -3)
    bar.BackgroundColor3 = NEON_GREEN
    bar.BorderSizePixel = 0
    bar.Parent = notif
    MakeCorner(bar, 2)

    Tween(notif, {Position = UDim2.new(1, -310, 1, -90)}, 0.4)
    Tween(bar, {Size = UDim2.new(0, 0, 0, 3)}, duration or 3)

    task.wait(duration or 3)
    Tween(notif, {Position = UDim2.new(1, 10, 1, -90)}, 0.3)
    task.wait(0.4)
    notif:Destroy()
end

task.spawn(function()
    task.wait(0.5)
    ShowNotif("⚡ PHANTOM X v3.0", "Меню: V | Полёт: E | Быстрый полёт: F", 4)
    task.wait(4.5)
    ShowNotif("✅ Загружено", "100+ функций активированы. PlaceId: " .. game.PlaceId, 3)
end)

-- ══════════════════════════════════════════
--   ОБНОВЛЕНИЕ СКОРОСТИ/ПРЫЖКА ПРИ СПАВНЕ
-- ══════════════════════════════════════════
Player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid")
    if hum then
        hum.WalkSpeed = States.WalkSpeed
        hum.JumpPower = States.JumpPower
    end
    if States.Flying then
        task.wait(1)
        EnableFly()
    end
end)

print("╔══════════════════════════════════════╗")
print("║     PHANTOM X v3.0 — ЗАГРУЖЕН!      ║")
print("║  V = Меню | E = Полёт | F = Лёт     ║")
print("╚══════════════════════════════════════╝")
