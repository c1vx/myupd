local library = {
    flags = {},
    pointers = {},
    theme = {
        accent = Color3.fromRGB(225, 58, 81),
        background = Color3.fromRGB(20, 20, 20),
        section = Color3.fromRGB(28, 28, 28),
        text = Color3.fromRGB(255, 255, 255)
    }
}

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function library:new(options)
    options = options or {}
    local name = options.name or "UI Library"
    if options.color then
        library.theme.accent = options.color
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomLibrary_" .. math.random(1000, 9999)
    screenGui.ResetOnSpawn = false
    
    pcall(function()
        if gethui then
            screenGui.Parent = gethui()
        elseif syn and syn.protect_gui then
            syn.protect_gui(screenGui)
            screenGui.Parent = CoreGui
        else
            screenGui.Parent = CoreGui
        end
    end)

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 480, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
    mainFrame.BackgroundColor3 = library.theme.background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    -- Перетаскивание окна
    local dragging, dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Верхняя плашка
    local topbar = Instance.new("Frame")
    topbar.Size = UDim2.new(1, 0, 0, 30)
    topbar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    topbar.BorderSizePixel = 0
    topbar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.Text = name
    titleLabel.TextColor3 = library.theme.text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 16
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = topbar

    -- Контейнер вкладок
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 110, 1, -30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2)
    tabLayout.Parent = tabContainer

    local pageContainer = Instance.new("Frame")
    pageContainer.Size = UDim2.new(1, -110, 1, -30)
    pageContainer.Position = UDim2.new(0, 110, 0, 30)
    pageContainer.BackgroundTransparency = 1
    pageContainer.Parent = mainFrame

    local window = { gui = screenGui, pages = {}, library = library }

    function window:page(pageOpts)
        pageOpts = pageOpts or {}
        local pageName = pageOpts.name or "Tab"

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 30)
        tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = pageName
        tabBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
        tabBtn.Font = Enum.Font.SourceSans
        tabBtn.TextSize = 14
        tabBtn.Parent = tabContainer

        local pageFrame = Instance.new("Frame")
        pageFrame.Size = UDim2.new(1, 0, 1, 0)
        pageFrame.BackgroundTransparency = 1
        pageFrame.Visible = false
        pageFrame.Parent = pageContainer

        local leftScroll = Instance.new("ScrollingFrame")
        leftScroll.Size = UDim2.new(0.5, -5, 1, -10)
        leftScroll.Position = UDim2.new(0, 5, 0, 5)
        leftScroll.BackgroundTransparency = 1
        leftScroll.ScrollBarThickness = 2
        leftScroll.Parent = pageFrame

        local leftLayout = Instance.new("UIListLayout")
        leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        leftLayout.Padding = UDim.new(0, 5)
        leftLayout.Parent = leftScroll

        local pageObj = { frame = pageFrame, button = tabBtn }

        tabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(window.pages) do
                p.frame.Visible = false
                p.button.TextColor3 = Color3.fromRGB(160, 160, 160)
            end
            pageFrame.Visible = true
            tabBtn.TextColor3 = library.theme.accent
        end)

        if #window.pages == 0 then
            pageFrame.Visible = true
            tabBtn.TextColor3 = library.theme.accent
        end

        table.insert(window.pages, pageObj)

        function pageObj:section(secOpts)
            secOpts = secOpts or {}
            local secName = secOpts.name or "Section"

            local secFrame = Instance.new("Frame")
            secFrame.Size = UDim2.new(1, 0, 0, 30)
            secFrame.BackgroundColor3 = library.theme.section
            secFrame.BorderSizePixel = 0
            secFrame.Parent = leftScroll

            local secTitle = Instance.new("TextLabel")
            secTitle.Size = UDim2.new(1, -10, 0, 20)
            secTitle.Position = UDim2.new(0, 5, 0, 2)
            secTitle.Text = secName
            secTitle.TextColor3 = library.theme.accent
            secTitle.Font = Enum.Font.SourceSansBold
            secTitle.TextSize = 14
            secTitle.TextXAlignment = Enum.TextXAlignment.Left
            secTitle.BackgroundTransparency = 1
            secTitle.Parent = secFrame

            local contentLayout = Instance.new("UIListLayout")
            contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            contentLayout.Padding = UDim.new(0, 4)
            contentLayout.Parent = secFrame

            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                secFrame.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 8)
            end)

            local sectionObj = {}

            function sectionObj:button(props)
                props = props or {}
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 24)
                btn.Position = UDim2.new(0, 5, 0, 0)
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                btn.BorderSizePixel = 0
                btn.Text = props.name or "Button"
                btn.TextColor3 = library.theme.text
                btn.Font = Enum.Font.SourceSans
                btn.TextSize = 13
                btn.Parent = secFrame

                btn.MouseButton1Click:Connect(function()
                    if props.callback then pcall(props.callback) end
                end)
                return btn
            end

            function sectionObj:toggle(props)
                props = props or {}
                local state = props.def or false

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -10, 0, 24)
                frame.BackgroundTransparency = 1
                frame.Parent = secFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -30, 1, 0)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.Text = props.name or "Toggle"
                label.TextColor3 = library.theme.text
                label.Font = Enum.Font.SourceSans
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame

                local box = Instance.new("TextButton")
                box.Size = UDim2.new(0, 16, 0, 16)
                box.Position = UDim2.new(1, -18, 0.5, -8)
                box.BackgroundColor3 = state and library.theme.accent or Color3.fromRGB(45, 45, 45)
                box.BorderSizePixel = 0
                box.Text = ""
                box.Parent = frame

                box.MouseButton1Click:Connect(function()
                    state = not state
                    box.BackgroundColor3 = state and library.theme.accent or Color3.fromRGB(45, 45, 45)
                    if props.callback then pcall(props.callback, state) end
                end)
                return frame
            end

            return sectionObj
        end

        return pageObj
    end

    return window
end

-- КРИТИЧЕСКИ ВАЖНАЯ СТРОКА В КОНЦЕ:
return library
