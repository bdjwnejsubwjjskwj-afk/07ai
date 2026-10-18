
-- 07愛
-- LocalScript en StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local aimEnabled = false
local lockEnabled = false
local espEnabled = false
local speedEnabled = false
local selectedTarget = nil
local aimFOV = 250
local normalSpeed = 16
local espObjects = {}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "07愛"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(300, 445)
main.Position = UDim2.new(0.5, -150, 0.5, -222)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local outline = Instance.new("UIStroke", main)
outline.Color = Color3.fromRGB(225, 20, 45)
outline.Thickness = 2

local function makeButton(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 31)
    b.Position = UDim2.fromOffset(10, y)
    b.BackgroundColor3 = Color3.fromRGB(95, 12, 27)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.Text = text
    b.Parent = main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local function makeBox(placeholder, value, y)
    local t = Instance.new("TextBox")
    t.Size = UDim2.new(1, -20, 0, 29)
    t.Position = UDim2.fromOffset(10, y)
    t.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    t.TextColor3 = Color3.new(1, 1, 1)
    t.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    t.PlaceholderText = placeholder
    t.Text = value or ""
    t.Font = Enum.Font.Gotham
    t.TextSize = 12
    t.ClearTextOnFocus = false
    t.Parent = main
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 5)
    return t
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 28)
title.Position = UDim2.fromOffset(10, 5)
title.BackgroundTransparency = 1
title.Text = "07愛"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = main

local espButton = makeButton("ESP: OFF", 38)
local speedBox = makeBox("Velocidad: 1 - 1000", "50", 74)
local speedButton = makeButton("VELOCIDAD: OFF", 107)
local targetBox = makeBox("Nombre exacto del jugador", "", 143)
local selectButton = makeButton("SELECCIONAR OBJETIVO", 176)
local aimButton = makeButton("AIMBOT: OFF", 212)
local lockButton = makeButton("LOCK TARGET: OFF", 248)
local fovBox = makeBox("FOV: 120 - 650", "250", 284)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 28)
status.Position = UDim2.fromOffset(10, 316)
status.BackgroundTransparency = 1
status.Text = "Objetivo: automático"
status.TextColor3 = Color3.fromRGB(255, 100, 110)
status.Font = Enum.Font.GothamBold
status.TextSize = 11
status.Parent = main

local closeButton = makeButton("CERRAR MENÚ", 350)

-- Botón para volver a abrir el menú
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.fromOffset(95, 35)
openButton.Position = UDim2.new(0, 12, 0.4, 0)
openButton.BackgroundColor3 = Color3.fromRGB(110, 10, 25)
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.Text = "07愛 OPEN"
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 12
openButton.Visible = false
openButton.Parent = gui
Instance.new("UICorner", openButton).CornerRadius = UDim.new(0, 7)

closeButton.MouseButton1Click:Connect(function()
    main.Visible = false
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    main.Visible = true
    openButton.Visible = false
end)

-- Círculo FOV
local circle = Instance.new("Frame")
circle.Name = "FOVCircle"
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.Position = UDim2.fromScale(0.5, 0.5)
circle.Size = UDim2.fromOffset(aimFOV, aimFOV)
circle.BackgroundTransparency = 1
circle.Visible = false
circle.Parent = gui
Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

local circleStroke = Instance.new("UIStroke", circle)
circleStroke.Color = Color3.fromRGB(255, 30, 55)
circleStroke.Thickness = 1.5

-- ESP
local function clearESP(other)
    if espObjects[other] then
        for _, object in ipairs(espObjects[other]) do
            object:Destroy()
        end
        espObjects[other] = nil
    end
end

local function addESP(other)
    clearESP(other)
    if other == player or not other.Character then return end

    local character = other.Character
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(220, 20, 40)
    highlight.OutlineColor = Color3.fromRGB(255, 70, 80)
    highlight.FillTransparency = 0.65
    highlight.Parent = gui

    local objects = {highlight}
    local head = character:FindFirstChild("Head")

    if head then
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = head
        billboard.Size = UDim2.fromOffset(180, 30)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = gui

        local text = Instance.new("TextLabel")
        text.Size = UDim2.fromScale(1, 1)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.fromRGB(255, 50, 65)
        text.TextStrokeTransparency = 0.2
        text.Font = Enum.Font.GothamBold
        text.TextScaled = true
        text.Text = other.DisplayName .. " (@" .. other.Name .. ")"
        text.Parent = billboard

        table.insert(objects, billboard)
    end

    espObjects[other] = objects
end

local function refreshESP()
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player then
            if espEnabled then
                addESP(other)
            else
                clearESP(other)
            end
        end
    end
end

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    refreshESP()
end)

Players.PlayerAdded:Connect(function(other)
    other.CharacterAdded:Connect(function()
        task.wait(1)
        if espEnabled then
            addESP(other)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(other)
    clearESP(other)

    if selectedTarget == other then
        selectedTarget = nil
        lockEnabled = false
        lockButton.Text = "LOCK TARGET: OFF"
        status.Text = "Objetivo desconectado"
    end
end)

-- Velocidad
local function getHumanoid()
    local character = player.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

player.CharacterAdded:Connect(function()
    task.wait(0.3)
    local h = getHumanoid()
    if h and speedEnabled then
        h.WalkSpeed = math.clamp(
            tonumber(speedBox.Text) or 50, 1, 1000
        )
    end
end)

speedButton.MouseButton1Click:Connect(function()
    local h = getHumanoid()

    if not speedEnabled and h then
        normalSpeed = h.WalkSpeed
    end

    speedEnabled = not speedEnabled
    speedButton.Text = "VELOCIDAD: " ..
        (speedEnabled and "ON" or "OFF")

    if h then
        if speedEnabled then
            h.WalkSpeed = math.clamp(
                tonumber(speedBox.Text) or 50, 1, 1000
            )
        else
            h.WalkSpeed = normalSpeed
        end
    end
end)

speedBox.FocusLost:Connect(function()
    local value = tonumber(speedBox.Text)

    if value then
        value = math.clamp(value, 1, 1000)
        speedBox.Text = tostring(value)

        local h = getHumanoid()
        if speedEnabled and h then
            h.WalkSpeed = value
        end
    end
end)

-- Seleccionar un jugador por nombre
selectButton.MouseButton1Click:Connect(function()
    local query = string.lower(targetBox.Text)
    selectedTarget = nil

    if query ~= "" then
        for _, other in ipairs(Players:GetPlayers()) do
            if other ~= player then
                if string.lower(other.Name) == query
                    or string.lower(other.DisplayName) == query then
                    selectedTarget = other
                    break
                end
            end
        end
    end

    if selectedTarget then
        status.Text = "Seleccionado: " .. selectedTarget.Name
    else
        status.Text = "Jugador no encontrado"
    end
end)

lockButton.MouseButton1Click:Connect(function()
    if not selectedTarget then
        status.Text = "Selecciona un jugador primero"
        return
    end

    lockEnabled = not lockEnabled
    lockButton.Text = "LOCK TARGET: " ..
        (lockEnabled and "ON" or "OFF")

    status.Text = lockEnabled
        and ("Fijo: " .. selectedTarget.Name)
        or "Bloqueo desactivado"
end)

-- FOV
fovBox.FocusLost:Connect(function()
    local value = tonumber(fovBox.Text)

    if value then
        aimFOV = math.clamp(value, 120, 650)
        fovBox.Text = tostring(aimFOV)
        circle.Size = UDim2.fromOffset(aimFOV, aimFOV)
    else
        fovBox.Text = tostring(aimFOV)
    end
end)

aimButton.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimButton.Text = "AIMBOT: " ..
        (aimEnabled and "ON" or "OFF")
    circle.Visible = aimEnabled
end)

-- Objetivo más cercano al centro de la pantalla
local function getAimTarget()
    local camera = workspace.CurrentCamera
    if not camera then return nil end

    if lockEnabled and selectedTarget then
        local character = selectedTarget.Character
        local head = character and character:FindFirstChild("Head")
        local humanoid = character
            and character:FindFirstChildOfClass("Humanoid")

        if head and humanoid and humanoid.Health > 0 then
            return head
        end

        return nil
    end

    local center = camera.ViewportSize / 2
    local closestDistance = aimFOV / 2
    local closestHead = nil

    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player then
            local character = other.Character
            local head = character and character:FindFirstChild("Head")
            local humanoid = character
                and character:FindFirstChildOfClass("Humanoid")

            if head and humanoid and humanoid.Health > 0 then
                local point, visible =
                    camera:WorldToViewportPoint(head.Position)

                if visible and point.Z > 0 then
                    local position = Vector2.new(point.X, point.Y)
                    local distance = (position - center).Magnitude

                    if distance < closestDistance then
                        closestDistance = distance
                        closestHead = head
                    end
                end
            end
        end
    end

    return closestHead
end

-- Cámara 07愛
RunService:BindToRenderStep(
    "07AiCamera",
    Enum.RenderPriority.Camera.Value + 1,
    function()
        if not aimEnabled then return end

        local camera = workspace.CurrentCamera
        local targetHead = getAimTarget()

        if camera and targetHead then
            camera.CFrame = CFrame.lookAt(
                camera.CFrame.Position,
                targetHead.Position
            )
        end
    end
)

refreshESP()
