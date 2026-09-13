local library = {
    flags = {},
    pointers = {},
    theme = {
        accent = Color3.fromRGB(225, 58, 81),
        background = Color3.fromRGB(20, 20, 20),
        section = Color3.fromRGB(28, 28, 28),
        text = Color3.fromRGB(255, 255, 255),
        subtext = Color3.fromRGB(160, 160, 160)
    }
}

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local notifGui
function library:notify(opts)
    opts = opts or {}
    local title = opts.title or "Notification"
    local text = opts.text or ""
    local duration = opts.duration or 4

    if not notifGui then
        notifGui = Instance.new("ScreenGui")
        notifGui.Name = "LibNotifs"
        pcall(function()
            if gethui then
                notifGui.Parent = gethui()
            else
                notifGui.Parent = CoreGui
            end
        end)
        
        local holder = Instance.new("Frame")
        holder.Name = "Holder"
        holder.Size = UDim2.new(0, 220, 1, -20)
        holder.Position = UDim2.new(0, 15, 0, 10)
        holder.BackgroundTransparency = 1
        holder.Parent = notifGui

        local layout = Instance.new("UIListLayout")
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Padding = UDim.new(0, 6)
        layout.Parent = holder
    end

    local holder = notifGui:FindFirstChild("Holder")
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 42)
    card.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    card.BorderSizePixel = 0
    card.Parent = holder

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 1, 0)
    bar.BackgroundColor3 = library.theme.accent
    bar.BorderSizePixel = 0
    bar.Parent = card

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -12, 0, 18)
    tLabel.Position = UDim2.new(0, 8, 0, 3)
    tLabel.Text = title
    tLabel.TextColor3 = library.theme.text
    tLabel.Font = Enum.Font.SourceSansBold
    tLabel.TextSize = 14
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.BackgroundTransparency = 1
    tLabel.Parent = card

    local bLabel = Instance.new("TextLabel")
    bLabel.Size = UDim2.new(1, -12, 0, 16)
    bLabel.Position = UDim2.new(0, 8, 0, 21)
    bLabel.Text = text
    bLabel.TextColor3 = library.theme.subtext
    bLabel.Font = Enum.Font.SourceSans
    bLabel.TextSize = 12
    bLabel.TextXAlignment = Enum.TextXAlignment.Left
    bLabel.BackgroundTransparency = 1
    bLabel.Parent = card

    task.delay(duration, function()
        if card and card.Parent then card:Destroy() end
    end)
end

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
    mainFrame.Size = UDim2.new(0, 520, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
    mainFrame.BackgroundColor3 = library.theme.background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

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
    titleLabel.TextSize = 15
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = topbar

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 110, 1, -30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
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
        tabBtn.Size = UDim2.new(1, 0, 0, 28)
        tabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = pageName
        tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        tabBtn.Font = Enum.Font.SourceSans
        tabBtn.TextSize = 14
        tabBtn.Parent = tabContainer

        local pageFrame = Instance.new("Frame")
        pageFrame.Size = UDim2.new(1, 0, 1, 0)
        pageFrame.BackgroundTransparency = 1
        pageFrame.Visible = false
        pageFrame.Parent = pageContainer

        local leftScroll = Instance.new("ScrollingFrame")
        leftScroll.Size = UDim2.new(0.5, -6, 1, -10)
        leftScroll.Position = UDim2.new(0, 4, 0, 5)
        leftScroll.BackgroundTransparency = 1
        leftScroll.ScrollBarThickness = 2
        leftScroll.Parent = pageFrame

        local leftLayout = Instance.new("UIListLayout")
        leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        leftLayout.Padding = UDim.new(0, 6)
        leftLayout.Parent = leftScroll

        local rightScroll = Instance.new("ScrollingFrame")
        rightScroll.Size = UDim2.new(0.5, -6, 1, -10)
        rightScroll.Position = UDim2.new(0.5, 2, 0, 5)
        rightScroll.BackgroundTransparency = 1
        rightScroll.ScrollBarThickness = 2
        rightScroll.Parent = pageFrame

        local rightLayout = Instance.new("UIListLayout")
        rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        rightLayout.Padding = UDim.new(0, 6)
        rightLayout.Parent = rightScroll

        local pageObj = { frame = pageFrame, button = tabBtn, left = leftScroll, right = rightScroll }

        tabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(window.pages) do
                p.frame.Visible = false
                p.button.TextColor3 = Color3.fromRGB(150, 150, 150)
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
            local side = secOpts.side or "left"
            local parentScroll = (side == "right") and rightScroll or leftScroll

            local secFrame = Instance.new("Frame")
            secFrame.Size = UDim2.new(1, 0, 0, 26)
            secFrame.BackgroundColor3 = library.theme.section
            secFrame.BorderSizePixel = 0
            secFrame.Parent = parentScroll

            local secTitle = Instance.new("TextLabel")
            secTitle.Size = UDim2.new(1, -10, 0, 22)
            secTitle.Position = UDim2.new(0, 5, 0, 2)
            secTitle.Text = secName
            secTitle.TextColor3 = library.theme.accent
            secTitle.Font = Enum.Font.SourceSansBold
            secTitle.TextSize = 13
            secTitle.TextXAlignment = Enum.TextXAlignment.Left
            secTitle.BackgroundTransparency = 1
            secTitle.Parent = secFrame

            local contentLayout = Instance.new("UIListLayout")
            contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            contentLayout.Padding = UDim.new(0, 4)
            contentLayout.Parent = secFrame

            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                secFrame.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 6)
            end)

            local sectionObj = {}

            function sectionObj:button(props)
                props = props or {}
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 22)
                btn.Position = UDim2.new(0, 5, 0, 0)
                btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                btn.BorderSizePixel = 0
                btn.Text = props.name or "Button"
                btn.TextColor3 = library.theme.text
                btn.Font = Enum.Font.SourceSans
                btn.TextSize = 12
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
                frame.Size = UDim2.new(1, -10, 0, 22)
                frame.BackgroundTransparency = 1
                frame.Parent = secFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -25, 1, 0)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.Text = props.name or "Toggle"
                label.TextColor3 = library.theme.text
                label.Font = Enum.Font.SourceSans
                label.TextSize = 12
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame

                local box = Instance.new("TextButton")
                box.Size = UDim2.new(0, 14, 0, 14)
                box.Position = UDim2.new(1, -16, 0.5, -7)
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

            function sectionObj:slider(props)
                props = props or {}
                local min = props.min or 0
                local max = props.max or 100
                local val = props.def or min

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -10, 0, 32)
                frame.BackgroundTransparency = 1
                frame.Parent = secFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -10, 0, 16)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.Text = (props.name or "Slider") .. ": " .. tostring(val)
                label.TextColor3 = library.theme.text
                label.Font = Enum.Font.SourceSans
                label.TextSize = 12
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame

                local track = Instance.new("Frame")
                track.Size = UDim2.new(1, -10, 0, 8)
                track.Position = UDim2.new(0, 5, 0, 18)
                track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                track.BorderSizePixel = 0
                track.Parent = frame

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new((val - min)/(max - min), 0, 1, 0)
                fill.BackgroundColor3 = library.theme.accent
                fill.BorderSizePixel = 0
                fill.Parent = track

                local sliding = false
                local function update(input)
                    local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    val = math.floor(min + ((max - min) * pos))
                    fill.Size = UDim2.new(pos, 0, 1, 0)
                    label.Text = (props.name or "Slider") .. ": " .. tostring(val)
                    if props.callback then pcall(props.callback, val) end
                end

                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        update(input)
                    end
                end)
                track.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        update(input)
                    end
                end)
                return frame
            end

            function sectionObj:keybind(props)
                props = props or {}
                local key = props.def or Enum.KeyCode.E

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -10, 0, 22)
                frame.BackgroundTransparency = 1
                frame.Parent = secFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -60, 1, 0)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.Text = props.name or "Keybind"
                label.TextColor3 = library.theme.text
                label.Font = Enum.Font.SourceSans
                label.TextSize = 12
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0, 50, 0, 16)
                btn.Position = UDim2.new(1, -52, 0.5, -8)
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                btn.BorderSizePixel = 0
                btn.Text = key.Name
                btn.TextColor3 = library.theme.text
                btn.Font = Enum.Font.SourceSans
                btn.TextSize = 11
                btn.Parent = frame

                local binding = false
                btn.MouseButton1Click:Connect(function()
                    binding = true
                    btn.Text = "..."
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        binding = false
                        key = input.KeyCode
                        btn.Text = key.Name
                        if props.callback then pcall(props.callback, key) end
                    end
                end)
                return frame
            end

            function sectionObj:textbox(props)
                props = props or {}

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -10, 0, 24)
                frame.BackgroundTransparency = 1
                frame.Parent = secFrame

                local box = Instance.new("TextBox")
                box.Size = UDim2.new(1, -10, 0, 20)
                box.Position = UDim2.new(0, 5, 0, 2)
                box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                box.BorderSizePixel = 0
                box.PlaceholderText = props.placeholder or props.name or "Type here..."
                box.Text = props.def or ""
                box.TextColor3 = library.theme.text
                box.Font = Enum.Font.SourceSans
                box.TextSize = 12
                box.Parent = frame

                box.FocusLost:Connect(function(enter)
                    if props.callback then pcall(props.callback, box.Text) end
                end)
                return frame
            end

            return sectionObj
        end

        return pageObj
    end

    return window
end

return library
