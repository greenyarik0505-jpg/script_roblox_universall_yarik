local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local function getGui()
    if gethui then return gethui() end
    if syn and syn.protect_gui then return game:GetService("CoreGui") end
    return game:GetService("CoreGui")
end

local function notify(title, text, duration)
    duration = duration or 3
    local ng = getGui()
    local nf = Instance.new("ScreenGui")
    nf.Name = "YWNotify"
    nf.ResetOnSpawn = false
    nf.Parent = ng
    local nb = Instance.new("Frame")
    nb.Size = UDim2.new(0, 280, 0, 60)
    nb.Position = UDim2.new(1, -300, 1, -80)
    nb.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    nb.BackgroundTransparency = 0.1
    nb.BorderSizePixel = 0
    nb.Parent = nf
    local nc = Instance.new("UICorner")
    nc.CornerRadius = UDim.new(0, 10)
    nc.Parent = nb
    local ns = Instance.new("UIStroke")
    ns.Color = Color3.fromRGB(0, 255, 127)
    ns.Thickness = 1.5
    ns.Parent = nb
    local nt = Instance.new("TextLabel")
    nt.Size = UDim2.new(1, -10, 0.5, 0)
    nt.Position = UDim2.new(0, 10, 0, 0)
    nt.BackgroundTransparency = 1
    nt.Text = title
    nt.TextColor3 = Color3.fromRGB(0, 255, 127)
    nt.TextXAlignment = Enum.TextXAlignment.Left
    nt.Font = Enum.Font.GothamBold
    nt.TextSize = 13
    nt.Parent = nb
    local nd = Instance.new("TextLabel")
    nd.Size = UDim2.new(1, -10, 0.5, 0)
    nd.Position = UDim2.new(0, 10, 0.5, 0)
    nd.BackgroundTransparency = 1
    nd.Text = text
    nd.TextColor3 = Color3.fromRGB(200, 255, 220)
    nd.TextXAlignment = Enum.TextXAlignment.Left
    nd.Font = Enum.Font.Gotham
    nd.TextSize = 11
    nd.Parent = nb
    task.delay(duration, function()
        if nf and nf.Parent then nf:Destroy() end
    end)
end

local States = {
    MenuOpen = false,
    NoclipOn = false,
    InfJumpOn = false,
    FlyOn = false,
    ESPOn = false,
    FullbrightOn = false,
    AimlockOn = false,
    HitboxOn = false,
    SpinBotOn = false,
    GodModeOn = false,
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    HitboxSize = 10,
    FOV = 70,
    AimlockTarget = nil,
    FlyBodyVel = nil,
    FlyBodyGyro = nil,
    ESPConnections = {},
    ESPBoxes = {},
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YarikWorldHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
end
ScreenGui.Parent = getGui()

local IconButton = Instance.new("ImageButton")
IconButton.Size = UDim2.new(0, 55, 0, 55)
IconButton.Position = UDim2.new(0, 20, 0.5, -27)
IconButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
IconButton.BackgroundTransparency = 0.1
IconButton.BorderSizePixel = 0
IconButton.ZIndex = 100
IconButton.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 14)
IconCorner.Parent = IconButton

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 255, 127)
IconStroke.Thickness = 2
IconStroke.Parent = IconButton

local IconLabel = Instance.new("TextLabel")
IconLabel.Size = UDim2.new(1, 0, 1, 0)
IconLabel.BackgroundTransparency = 1
IconLabel.Text = "YW"
IconLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
IconLabel.Font = Enum.Font.GothamBold
IconLabel.TextSize = 16
IconLabel.ZIndex = 101
IconLabel.Parent = IconButton

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 127)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
TitleBar.BackgroundTransparency = 0.2
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 11
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0.5, 0)
TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleFix.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
TitleFix.BackgroundTransparency = 0.2
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 11
TitleFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Yarik World Hub"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 12
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BackgroundTransparency = 0.2
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.ZIndex = 13
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Sidebar.BackgroundTransparency = 0.1
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 11
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 16)
SidebarCorner.Parent = Sidebar

local SidebarFix = Instance.new("Frame")
SidebarFix.Size = UDim2.new(0.5, 0, 1, 0)
SidebarFix.Position = UDim2.new(0.5, 0, 0, 0)
SidebarFix.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
SidebarFix.BackgroundTransparency = 0.1
SidebarFix.BorderSizePixel = 0
SidebarFix.ZIndex = 11
SidebarFix.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 4)
SidebarList.Parent = Sidebar

local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop = UDim.new(0, 8)
SidePad.PaddingLeft = UDim.new(0, 6)
SidePad.PaddingRight = UDim.new(0, 6)
SidePad.Parent = Sidebar

local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Size = UDim2.new(1, -148, 1, -53)
ContentArea.Position = UDim2.new(0, 144, 0, 49)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.ScrollBarThickness = 4
ContentArea.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 127)
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

local ContentList = Instance.new("UIListLayout")
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Padding = UDim.new(0, 8)
ContentList.Parent = ContentArea

local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingTop = UDim.new(0, 10)
ContentPad.PaddingLeft = UDim.new(0, 10)
ContentPad.PaddingRight = UDim.new(0, 14)
ContentPad.PaddingBottom = UDim.new(0, 10)
ContentPad.Parent = ContentArea

local Categories = {"Игрок", "Визуал", "Бой", "Мир", "Поиск"}
local ActiveCategory = "Игрок"
local CategoryButtons = {}
local ContentSections = {}

local function makeSideBtn(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(0, 140, 60)
    btn.BackgroundTransparency = 0.6
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 255, 220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.LayoutOrder = order
    btn.ZIndex = 12
    btn.Parent = Sidebar
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = btn
    return btn
end

local function setActiveCategory(name)
    ActiveCategory = name
    for catName, section in pairs(ContentSections) do
        section.Visible = (catName == name)
    end
    for catName, btn in pairs(CategoryButtons) do
        if catName == name then
            btn.BackgroundTransparency = 0.1
            btn.TextColor3 = Color3.fromRGB(0, 255, 127)
        else
            btn.BackgroundTransparency = 0.6
            btn.TextColor3 = Color3.fromRGB(200, 255, 220)
        end
    end
end

for i, cat in ipairs(Categories) do
    local btn = makeSideBtn(cat, i)
    CategoryButtons[cat] = btn
    btn.MouseButton1Click:Connect(function()
        setActiveCategory(cat)
    end)
end

local function makeSection(categoryName)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.ZIndex = 12
    frame.Parent = ContentArea
    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)
    list.Parent = frame
    ContentSections[categoryName] = frame
    return frame
end

local function makeToggleBtn(parent, labelText, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    row.BackgroundTransparency = 0.2
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 13
    row.Parent = parent
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 8)
    rc.Parent = row
    local rs = Instance.new("UIStroke")
    rs.Color = Color3.fromRGB(0, 180, 80)
    rs.Thickness = 1
    rs.Parent = row
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(220, 255, 230)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 14
    lbl.Parent = row
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 52, 0, 24)
    toggleBtn.Position = UDim2.new(1, -60, 0.5, -12)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "ВЫКЛ"
    toggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 10
    toggleBtn.ZIndex = 14
    toggleBtn.Parent = row
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 6)
    tc.Parent = toggleBtn
    local active = false
    local function update()
        if active then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 90)
            toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleBtn.Text = "ВКЛ"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            toggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            toggleBtn.Text = "ВЫКЛ"
        end
    end
    return toggleBtn, function() return active end, function(v) active = v update() end, update
end

local function makeSlider(parent, labelText, minVal, maxVal, defaultVal, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    row.BackgroundTransparency = 0.2
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 13
    row.Parent = parent
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 8)
    rc.Parent = row
    local rs = Instance.new("UIStroke")
    rs.Color = Color3.fromRGB(0, 180, 80)
    rs.Thickness = 1
    rs.Parent = row
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 0, 22)
    lbl.Position = UDim2.new(0, 10, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText .. ": " .. tostring(defaultVal)
    lbl.TextColor3 = Color3.fromRGB(220, 255, 230)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 14
    lbl.Parent = row
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 8)
    track.Position = UDim2.new(0, 10, 0, 32)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    track.BorderSizePixel = 0
    track.ZIndex = 14
    track.Parent = row
    local tc2 = Instance.new("UICorner")
    tc2.CornerRadius = UDim.new(0, 4)
    tc2.Parent = track
    local fill = Instance.new("Frame")
    local pct = (defaultVal - minVal) / (maxVal - minVal)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    fill.BorderSizePixel = 0
    fill.ZIndex = 15
    fill.Parent = track
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 4)
    fc.Parent = fill
    local currentVal = defaultVal
    local dragging = false
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local trackPos = track.AbsolutePosition.X
            local trackSize = track.AbsoluteSize.X
            local mouseX = input.Position.X
            local ratio = math.clamp((mouseX - trackPos) / trackSize, 0, 1)
            currentVal = math.floor(minVal + ratio * (maxVal - minVal))
            fill.Size = UDim2.new(ratio, 0, 1, 0)
            lbl.Text = labelText .. ": " .. tostring(currentVal)
        end
    end)
    return function() return currentVal end
end

local SecPlayer = makeSection("Игрок")
local SecVisual = makeSection("Визуал")
local SecFight = makeSection("Бой")
local SecWorld = makeSection("Мир")
local SecSearch = makeSection("Поиск")

local getWalkSpeed = makeSlider(SecPlayer, "Скорость ходьбы", 16, 500, 16, 1)
local getJumpPower = makeSlider(SecPlayer, "Высота прыжка", 50, 500, 50, 2)

local noclipBtn, getNoclip, setNoclip = makeToggleBtn(SecPlayer, "Ноклип (сквозь стены)", 3)
noclipBtn.MouseButton1Click:Connect(function()
    setNoclip(not getNoclip())
    States.NoclipOn = getNoclip()
    notify("Ноклип", getNoclip() and "Включён" or "Выключен", 2)
end)

local infJumpBtn, getInfJump, setInfJump = makeToggleBtn(SecPlayer, "Бесконечный прыжок", 4)
infJumpBtn.MouseButton1Click:Connect(function()
    setInfJump(not getInfJump())
    States.InfJumpOn = getInfJump()
    notify("Инф. прыжок", getInfJump() and "Включён" or "Выключен", 2)
end)

local flyBtn, getFly, setFly = makeToggleBtn(SecPlayer, "Полёт (WASD + Q/E)", 5)

local spinBtn, getSpin, setSpin = makeToggleBtn(SecPlayer, "СпинБот (вращение)", 6)
spinBtn.MouseButton1Click:Connect(function()
    setSpin(not getSpin())
    States.SpinBotOn = getSpin()
    notify("СпинБот", getSpin() and "Включён" or "Выключен", 2)
end)

local espBtn, getESP, setESP = makeToggleBtn(SecVisual, "ESP (видеть игроков)", 1)
local fullbrightBtn, getFullbright, setFullbright = makeToggleBtn(SecVisual, "Полный свет (Fullbright)", 2)
local getFOV = makeSlider(SecVisual, "FOV камеры", 50, 120, 70, 3)

local rainbowBtn, getRainbow, setRainbow = makeToggleBtn(SecVisual, "Радужный персонаж", 4)

local aimlockBtn, getAimlock, setAimlock = makeToggleBtn(SecFight, "Аимлок (автоприцел)", 1)
local getHitbox = makeSlider(SecFight, "Хитбокс размер", 5, 30, 10, 2)
local hitboxBtn, getHitboxOn, setHitboxOn = makeToggleBtn(SecFight, "Хитбокс (большой)", 3)
local godBtn, getGod, setGod = makeToggleBtn(SecFight, "Бог мод (невидимость к урону)", 4)

local clickTpBtn, getClickTp, setClickTp = makeToggleBtn(SecWorld, "Клик ТП (ЛКМ телепорт)", 1)
local nofogBtn, getNofog, setNofog = makeToggleBtn(SecWorld, "Убрать туман", 2)
local fpsBtn, getFPS, setFPS = makeToggleBtn(SecWorld, "FPS Буст (60 FPS лок)", 3)

local searchFrame = Instance.new("Frame")
searchFrame.Size = UDim2.new(1, 0, 0, 0)
searchFrame.AutomaticSize = Enum.AutomaticSize.Y
searchFrame.BackgroundTransparency = 1
searchFrame.LayoutOrder = 1
searchFrame.ZIndex = 13
searchFrame.Parent = SecSearch

local searchList = Instance.new("UIListLayout")
searchList.SortOrder = Enum.SortOrder.LayoutOrder
searchList.Padding = UDim.new(0, 6)
searchList.Parent = searchFrame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, 0, 0, 36)
searchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
searchBox.BackgroundTransparency = 0.1
searchBox.BorderSizePixel = 0
searchBox.PlaceholderText = "Поиск скриптов..."
searchBox.PlaceholderColor3 = Color3.fromRGB(100, 180, 120)
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(0, 255, 127)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 13
searchBox.ClearTextOnFocus = false
searchBox.LayoutOrder = 1
searchBox.ZIndex = 14
searchBox.Parent = searchFrame

local sbc = Instance.new("UICorner")
sbc.CornerRadius = UDim.new(0, 8)
sbc.Parent = searchBox

local sbs = Instance.new("UIStroke")
sbs.Color = Color3.fromRGB(0, 255, 127)
sbs.Thickness = 1.5
sbs.Parent = searchBox

local searchResultsFrame = Instance.new("Frame")
searchResultsFrame.Size = UDim2.new(1, 0, 0, 0)
searchResultsFrame.AutomaticSize = Enum.AutomaticSize.Y
searchResultsFrame.BackgroundTransparency = 1
searchResultsFrame.LayoutOrder = 2
searchResultsFrame.ZIndex = 13
searchResultsFrame.Parent = searchFrame

local searchResultsList = Instance.new("UIListLayout")
searchResultsList.SortOrder = Enum.SortOrder.LayoutOrder
searchResultsList.Padding = UDim.new(0, 4)
searchResultsList.Parent = searchResultsFrame

local ScriptDatabase = {
    {name = "Infinite Yield (Команды админа)", keywords = {"admin", "команды", "infinite", "yield", "чит"}, code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infinite-yield/master/infinite-yield.lua"))()'},
    {name = "Dex Explorer (Просмотр игры)", keywords = {"dex", "explorer", "просмотр", "обозреватель"}, code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()'},
    {name = "Hydroxide (Remote Spy)", keywords = {"hydroxide", "remote", "spy", "шпион", "ремоут"}, code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/unified-naming-convention/Hydroxide/main/run.lua"))()'},
    {name = "Dark Hub (Универсальный хаб)", keywords = {"dark", "hub", "хаб", "универсальный"}, code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/RandomNameHere/DarkHub/main/loader.lua"))()'},
    {name = "Simple Spy (Spy ремоутов)", keywords = {"simple", "spy", "ремоут", "шпион"}, code = 'loadstring(game:HttpGet("https://x.synapse.to/scripts/simpleSpy.lua"))()'},
    {name = "Скорость x100 (WalkSpeed)", keywords = {"скорость", "speed", "ходьба", "быстро"}, code = 'game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100'},
    {name = "Прыжок x5 (JumpPower)", keywords = {"прыжок", "jump", "высоко", "power"}, code = 'game.Players.LocalPlayer.Character.Humanoid.JumpPower = 250'},
    {name = "Gravity Zero (Антигравитация)", keywords = {"гравитация", "gravity", "летать", "float", "невесомость"}, code = 'workspace.Gravity = 5'},
    {name = "Anti AFK (Без кика)", keywords = {"afk", "кик", "антикик", "kick", "afk", "idle"}, code = 'local vu = game:GetService("VirtualUser") game:GetService("Players").LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end)'},
    {name = "Fullbright (Полный свет)", keywords = {"свет", "fullbright", "темнота", "bright", "яркость"}, code = 'local l = game:GetService("Lighting") l.Brightness = 10 l.ClockTime = 14 l.FogEnd = 1e9 l.GlobalShadows = false l.Ambient = Color3.new(1,1,1)'},
    {name = "ESP Коробки (Видеть игроков)", keywords = {"esp", "коробки", "игроки", "видеть", "wallhack"}, code = 'for _, p in ipairs(game.Players:GetPlayers()) do if p ~= game.Players.LocalPlayer and p.Character then local b = Instance.new("SelectionBox") b.Adornee = p.Character b.Color3 = Color3.fromRGB(0,255,127) b.LineThickness = 0.05 b.Parent = workspace end end'},
    {name = "Нет тумана (No Fog)", keywords = {"туман", "fog", "видимость", "no fog"}, code = 'game:GetService("Lighting").FogEnd = 1e9 game:GetService("Lighting").FogStart = 1e9'},
    {name = "Click Teleport (ТП кликом)", keywords = {"телепорт", "tp", "клик", "click", "мышь"}, code = 'local p = game.Players.LocalPlayer local m = p:GetMouse() m.Button1Down:Connect(function() if p.Character then p.Character.HumanoidRootPart.CFrame = CFrame.new(m.Hit.p + Vector3.new(0,3,0)) end end)'},
    {name = "God Mode (Бог мод)", keywords = {"бог", "god", "хп", "hp", "бессмертие", "здоровье"}, code = 'local p = game.Players.LocalPlayer local h = p.Character.Humanoid h.MaxHealth = math.huge h.Health = math.huge'},
    {name = "Aimlock (Автоприцел)", keywords = {"аим", "aimlock", "прицел", "aim", "автоприцел", "lock"}, code = 'local cam = workspace.CurrentCamera game:GetService("RunService").RenderStepped:Connect(function() for _, p in ipairs(game.Players:GetPlayers()) do if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then cam.CFrame = CFrame.new(cam.CFrame.Position, p.Character.Head.Position) break end end end)'},
}

local function clearResults()
    for _, child in ipairs(searchResultsFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

local function makeScriptButton(scriptData, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 44)
    btn.BackgroundColor3 = Color3.fromRGB(15, 40, 20)
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixel = 0
    btn.Text = "▶  " .. scriptData.name
    btn.TextColor3 = Color3.fromRGB(0, 255, 127)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    btn.ZIndex = 15
    btn.Parent = searchResultsFrame
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.Parent = btn
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = btn
    local bs = Instance.new("UIStroke")
    bs.Color = Color3.fromRGB(0, 180, 80)
    bs.Thickness = 1
    bs.Parent = btn
    btn.MouseButton1Click:Connect(function()
        local ok, err = pcall(function()
            loadstring(scriptData.code)()
        end)
        if ok then
            notify("Скрипт запущен", scriptData.name, 3)
        else
            notify("Ошибка скрипта", tostring(err):sub(1, 60), 4)
        end
    end)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 80, 30)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(15, 40, 20)
    end)
end

local function doSearch(query)
    clearResults()
    query = query:lower():gsub("%s+", "")
    if query == "" then
        for i, s in ipairs(ScriptDatabase) do
            makeScriptButton(s, i)
        end
        return
    end
    local results = {}
    for _, s in ipairs(ScriptDatabase) do
        local nameMatch = s.name:lower():find(query, 1, true)
        local keyMatch = false
        for _, kw in ipairs(s.keywords) do
            if kw:lower():find(query, 1, true) then
                keyMatch = true
                break
            end
        end
        if nameMatch or keyMatch then
            table.insert(results, s)
        end
    end
    if #results == 0 then
        local noResult = Instance.new("TextLabel")
        noResult.Size = UDim2.new(1, 0, 0, 36)
        noResult.BackgroundTransparency = 1
        noResult.Text = "Ничего не найдено по запросу: " .. query
        noResult.TextColor3 = Color3.fromRGB(180, 100, 100)
        noResult.Font = Enum.Font.Gotham
        noResult.TextSize = 12
        noResult.ZIndex = 14
        noResult.Parent = searchResultsFrame
    else
        for i, s in ipairs(results) do
            makeScriptButton(s, i)
        end
    end
end

doSearch("")

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    doSearch(searchBox.Text)
end)

local isDragging = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

local iconDragging = false
local iconDragStart = nil
local iconStartPos = nil
local iconMoved = false

IconButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        iconDragging = true
        iconDragStart = input.Position
        iconStartPos = IconButton.Position
        iconMoved = false
    end
end)

IconButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        iconDragging = false
        if not iconMoved then
            States.MenuOpen = not States.MenuOpen
            MainFrame.Visible = States.MenuOpen
            if States.MenuOpen then
                setActiveCategory(ActiveCategory)
            end
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if iconDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - iconDragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            iconMoved = true
        end
        if iconMoved then
            IconButton.Position = UDim2.new(
                iconStartPos.X.Scale,
                iconStartPos.X.Offset + delta.X,
                iconStartPos.Y.Scale,
                iconStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    States.MenuOpen = false
    MainFrame.Visible = false
end)

local function startFly()
    local char = Player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if States.FlyBodyVel then States.FlyBodyVel:Destroy() end
    if States.FlyBodyGyro then States.FlyBodyGyro:Destroy() end
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Parent = hrp
    States.FlyBodyVel = bv
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.D = 50
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp
    States.FlyBodyGyro = bg
    States.FlyOn = true
end

local function stopFly()
    if States.FlyBodyVel then States.FlyBodyVel:Destroy() States.FlyBodyVel = nil end
    if States.FlyBodyGyro then States.FlyBodyGyro:Destroy() States.FlyBodyGyro = nil end
    States.FlyOn = false
end

flyBtn.MouseButton1Click:Connect(function()
    setFly(not getFly())
    States.FlyOn = getFly()
    if States.FlyOn then
        startFly()
        notify("Полёт", "Включён (WASD + Q вверх / E вниз)", 3)
    else
        stopFly()
        notify("Полёт", "Выключен", 2)
    end
end)

local originalFog = {Start = Lighting.FogStart, End = Lighting.FogEnd}

fullbrightBtn.MouseButton1Click:Connect(function()
    setFullbright(not getFullbright())
    if getFullbright() then
        Lighting.Brightness = 10
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1e9
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        notify("Fullbright", "Включён", 2)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = originalFog.End
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        notify("Fullbright", "Выключен", 2)
    end
end)

espBtn.MouseButton1Click:Connect(function()
    setESP(not getESP())
    States.ESPOn = getESP()
    if States.ESPOn then
        notify("ESP", "Включён", 2)
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local box = Instance.new("SelectionBox")
                box.Adornee = p.Character
                box.Color3 = Color3.fromRGB(0, 255, 127)
                box.LineThickness = 0.06
                box.SurfaceTransparency = 0.8
                box.SurfaceColor3 = Color3.fromRGB(0, 255, 127)
                box.Parent = workspace
                States.ESPBoxes[p.Name] = box
            end
        end
    else
        notify("ESP", "Выключен", 2)
        for _, box in pairs(States.ESPBoxes) do
            box:Destroy()
        end
        States.ESPBoxes = {}
    end
end)

nofogBtn.MouseButton1Click:Connect(function()
    setNofog(not getNofog())
    if getNofog() then
        Lighting.FogEnd = 1e9
        Lighting.FogStart = 1e9
        notify("Без тумана", "Включён", 2)
    else
        Lighting.FogEnd = originalFog.End
        Lighting.FogStart = originalFog.Start
        notify("Без тумана", "Выключен", 2)
    end
end)

fpsBtn.MouseButton1Click:Connect(function()
    setFPS(not getFPS())
    if getFPS() then
        setfpscap(60)
        notify("FPS Буст", "Лок 60 FPS включён", 2)
    else
        setfpscap(0)
        notify("FPS Буст", "Выключен", 2)
    end
end)

godBtn.MouseButton1Click:Connect(function()
    setGod(not getGod())
    States.GodModeOn = getGod()
    notify("Бог мод", getGod() and "Включён" or "Выключен", 2)
end)

hitboxBtn.MouseButton1Click:Connect(function()
    setHitboxOn(not getHitboxOn())
    States.HitboxOn = getHitboxOn()
    notify("Хитбокс", getHitboxOn() and "Увеличен" or "Нормальный", 2)
end)

aimlockBtn.MouseButton1Click:Connect(function()
    setAimlock(not getAimlock())
    States.AimlockOn = getAimlock()
    notify("Аимлок", getAimlock() and "Включён" or "Выключен", 2)
end)

local function getClosestPlayer()
    local closest = nil
    local minDist = math.huge
    local camPos = Camera.CFrame.Position
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("Head") then
            local headPos = p.Character.Head.Position
            local screenPos, onScreen = Camera:WorldToScreenPoint(headPos)
            if onScreen then
                local cx = Camera.ViewportSize.X / 2
                local cy = Camera.ViewportSize.Y / 2
                local dist = math.sqrt((screenPos.X - cx)^2 + (screenPos.Y - cy)^2)
                if dist < minDist then
                    minDist = dist
                    closest = p
                end
            end
        end
    end
    return closest
end

clickTpBtn.MouseButton1Click:Connect(function()
    setClickTp(not getClickTp())
    States.ClickTpOn = getClickTp()
    notify("Клик ТП", getClickTp() and "Включён (ЛКМ = телепорт)" or "Выключен", 2)
end)

local ClickTpConn = nil
States.ClickTpOn = false

RunService.RenderStepped:Connect(function(dt)
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hrp and hum then
        hum.WalkSpeed = getWalkSpeed()
        hum.JumpPower = getJumpPower()
        Camera.FieldOfView = getFOV()
    end

    if States.GodModeOn and hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end

    if States.HitboxOn and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = Vector3.new(getHitbox(), getHitbox(), getHitbox())
            end
        end
    end

    if States.FlyOn and hrp and States.FlyBodyVel and States.FlyBodyGyro then
        local flyDir = Vector3.zero
        local camCF = Camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then flyDir = flyDir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then flyDir = flyDir - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then flyDir = flyDir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then flyDir = flyDir + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then flyDir = flyDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then flyDir = flyDir - Vector3.new(0, 1, 0) end
        if flyDir.Magnitude > 0 then
            States.FlyBodyVel.Velocity = flyDir.Unit * States.FlySpeed
        else
            States.FlyBodyVel.Velocity = Vector3.zero
        end
        States.FlyBodyGyro.CFrame = camCF
    end

    if States.AimlockOn then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, target.Character.Head.Position),
                0.15
            )
        end
    end

    if States.SpinBotOn and hrp then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
    end

    if getRainbow() and char then
        local hue = (tick() % 5) / 5
        local color = Color3.fromHSV(hue, 1, 1)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Color = color
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    local char = Player.Character
    if States.NoclipOn and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local jumpConn = nil
local function setupInfJump()
    if jumpConn then jumpConn:Disconnect() end
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        jumpConn = hum.StateChanged:Connect(function(old, new)
            if States.InfJumpOn and new == Enum.HumanoidStateType.Landed then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

setupInfJump()
Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    setupInfJump()
    if States.FlyOn then
        stopFly()
        task.wait(0.5)
        startFly()
    end
    if States.GodModeOn then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
    end
end)

Mouse.Button1Down:Connect(function()
    if States.ClickTpOn then
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.V then
        States.MenuOpen = not States.MenuOpen
        MainFrame.Visible = States.MenuOpen
        if States.MenuOpen then setActiveCategory(ActiveCategory) end
    end
end)

setActiveCategory("Игрок")
notify("Yarik World Hub", "Загружен! Нажми иконку YW или V для меню", 4)
