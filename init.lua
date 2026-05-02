-- Antigravity UI Library (v1.0.0)
-- A premium, modern Roblox UI library built from scratch.

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

Library.Theme = {
    Main = Color3.fromRGB(20, 20, 25),
    Secondary = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(115, 80, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(45, 45, 50),
    Font = Enum.Font.GothamMedium,
}

local function Tween(obj, info, goal)
    local tween = TweenService:Create(obj, TweenInfo.new(info.Time or 0.3, info.EasingStyle or Enum.EasingStyle.Quart, info.EasingDirection or Enum.EasingDirection.Out), goal)
    tween:Play()
    return tween
end

function Library:Notify(options)
    options = options or {}
    local Title = options.Title or "Notification"
    local Content = options.Content or "Success!"
    local Duration = options.Duration or 5

    local NotifyGui = CoreGui:FindFirstChild("AntigravityNotify")
    if not NotifyGui then
        NotifyGui = Instance.new("ScreenGui")
        NotifyGui.Name = "AntigravityNotify"
        NotifyGui.Parent = CoreGui
        
        local Holder = Instance.new("Frame")
        Holder.Name = "Holder"
        Holder.Parent = NotifyGui
        Holder.BackgroundTransparency = 1
        Holder.Position = UDim2.new(1, -260, 1, -20)
        Holder.Size = UDim2.new(0, 250, 1, -20)
        
        local HLayout = Instance.new("UIListLayout")
        HLayout.Parent = Holder
        HLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        HLayout.Padding = UDim.new(0, 10)
    end

    local Holder = NotifyGui.Holder
    local Box = Instance.new("Frame")
    Box.Name = "NotifyBox"
    Box.Parent = Holder
    Box.BackgroundColor3 = self.Theme.Main
    Box.BorderSizePixel = 0
    Box.Size = UDim2.new(1, 0, 0, 0) -- Start small
    Box.ClipsDescendants = true

    local BCorn = Instance.new("UICorner")
    BCorn.CornerRadius = UDim.new(0, 8)
    BCorn.Parent = Box

    local BStroke = Instance.new("UIStroke")
    BStroke.Color = self.Theme.Accent
    BStroke.Thickness = 1
    BStroke.Parent = Box

    local NTitle = Instance.new("TextLabel")
    NTitle.Parent = Box
    NTitle.BackgroundTransparency = 1
    NTitle.Position = UDim2.new(0, 10, 0, 8)
    NTitle.Size = UDim2.new(1, -20, 0, 15)
    NTitle.Font = self.Theme.Font
    NTitle.Text = Title
    NTitle.TextColor3 = self.Theme.Accent
    NTitle.TextSize = 14
    NTitle.TextXAlignment = Enum.TextXAlignment.Left

    local NText = Instance.new("TextLabel")
    NText.Parent = Box
    NText.BackgroundTransparency = 1
    NText.Position = UDim2.new(0, 10, 0, 25)
    NText.Size = UDim2.new(1, -20, 0, 30)
    NText.Font = self.Theme.Font
    NText.Text = Content
    NText.TextColor3 = self.Theme.Text
    NText.TextSize = 12
    NText.TextWrapped = true
    NText.TextXAlignment = Enum.TextXAlignment.Left

    Tween(Box, {Time = 0.4}, {Size = UDim2.new(1, 0, 0, 65)})
    
    task.delay(Duration, function()
        Tween(Box, {Time = 0.4}, {Size = UDim2.new(1, 0, 0, 0)})
        task.wait(0.4)
        Box:Destroy()
    end)
end

function Library:MakeDraggable(gui)
	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function Library:CreateWindow(options)
    options = options or {}
    local Title = options.Title or "Antigravity UI"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AntigravityUI_" .. math.random(100, 999)
    -- Protect GUI from being detected by basic scripts
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
    ScreenGui.Parent = CoreGui

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = self.Theme.Main
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.ClipsDescendants = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Main

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = self.Theme.Border
    UIStroke.Thickness = 1
    UIStroke.Parent = Main

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Main
    Header.BackgroundColor3 = self.Theme.Secondary
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 40)

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = Header

    -- Fix bottom corners of header
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Name = "HeaderFix"
    HeaderFix.Parent = Header
    HeaderFix.BackgroundColor3 = self.Theme.Secondary
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Position = UDim2.new(0, 0, 0.7, 0)
    HeaderFix.Size = UDim2.new(1, 0, 0.3, 0)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = Header
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Font = self.Theme.Font
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Parent = Header
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.Size = UDim2.new(0, 35, 1, 0)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = self.Theme.Text
    CloseBtn.TextSize = 20

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {Time = 0.3}, {Size = UDim2.new(0, 500, 0, 0), Position = Main.Position + UDim2.new(0, 0, 0, 175)})
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    -- Container
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = Main
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 0, 0, 40)
    Container.Size = UDim2.new(1, 0, 1, -40)

    -- Sidebar (Tabs)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Container
    Sidebar.BackgroundColor3 = self.Theme.Secondary
    Sidebar.BorderSizePixel = 0
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.ScrollBarThickness = 0
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.Parent = Sidebar

    -- Pages
    local Pages = Instance.new("Frame")
    Pages.Name = "Pages"
    Pages.Parent = Container
    Pages.BackgroundTransparency = 1
    Pages.Position = UDim2.new(0, 140, 0, 0)
    Pages.Size = UDim2.new(1, -140, 1, 0)

    self:MakeDraggable(Main)

    local Window = {
        CurrentTab = nil,
        Tabs = {}
    }

    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Parent = Sidebar
        TabButton.BackgroundColor3 = Library.Theme.Main
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(0, 120, 0, 32)
        TabButton.AutoButtonColor = false
        TabButton.Font = Library.Theme.Font
        TabButton.Text = name
        TabButton.TextColor3 = Library.Theme.TextDark
        TabButton.TextSize = 14

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "Page"
        Page.Parent = Pages
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Library.Theme.Accent
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.Parent = Page

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    Tween(v, {Time = 0.2}, {TextColor3 = Library.Theme.TextDark, BackgroundColor3 = Library.Theme.Main})
                end
            end
            Page.Visible = true
            Tween(TabButton, {Time = 0.2}, {TextColor3 = Library.Theme.Text, BackgroundColor3 = Library.Theme.Accent})
        end)

        -- Default selection
        if #Sidebar:GetChildren() == 3 then -- 1 layout + 1 padding + this button
            Page.Visible = true
            TabButton.TextColor3 = Library.Theme.Text
            TabButton.BackgroundColor3 = Library.Theme.Accent
        end

        local Tab = {}

        function Tab:CreateButton(text, callback)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = text .. "Button"
            ButtonFrame.Parent = Page
            ButtonFrame.BackgroundColor3 = Library.Theme.Secondary
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Size = UDim2.new(0, 330, 0, 35)

            local BCorn = Instance.new("UICorner")
            BCorn.CornerRadius = UDim.new(0, 6)
            BCorn.Parent = ButtonFrame

            local TextBtn = Instance.new("TextButton")
            TextBtn.Parent = ButtonFrame
            TextBtn.BackgroundTransparency = 1
            TextBtn.Size = UDim2.new(1, 0, 1, 0)
            TextBtn.Font = Library.Theme.Font
            TextBtn.Text = text
            TextBtn.TextColor3 = Library.Theme.Text
            TextBtn.TextSize = 14

            TextBtn.MouseEnter:Connect(function()
                Tween(ButtonFrame, {Time = 0.2}, {BackgroundColor3 = Library.Theme.Accent})
            end)
            TextBtn.MouseLeave:Connect(function()
                Tween(ButtonFrame, {Time = 0.2}, {BackgroundColor3 = Library.Theme.Secondary})
            end)
            TextBtn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            
            return Tab
        end

        function Tab:CreateToggle(text, default, callback)
            local state = default or false
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = text .. "Toggle"
            ToggleFrame.Parent = Page
            ToggleFrame.BackgroundColor3 = Library.Theme.Secondary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Size = UDim2.new(0, 330, 0, 35)

            local TCorn = Instance.new("UICorner")
            TCorn.CornerRadius = UDim.new(0, 6)
            TCorn.Parent = ToggleFrame

            local TTitle = Instance.new("TextLabel")
            TTitle.Parent = ToggleFrame
            TTitle.BackgroundTransparency = 1
            TTitle.Position = UDim2.new(0, 12, 0, 0)
            TTitle.Size = UDim2.new(1, -60, 1, 0)
            TTitle.Font = Library.Theme.Font
            TTitle.Text = text
            TTitle.TextColor3 = Library.Theme.Text
            TTitle.TextSize = 14
            TTitle.TextXAlignment = Enum.TextXAlignment.Left

            local TBtn = Instance.new("TextButton")
            TBtn.Parent = ToggleFrame
            TBtn.BackgroundTransparency = 1
            TBtn.Size = UDim2.new(1, 0, 1, 0)
            TBtn.Text = ""

            local Outer = Instance.new("Frame")
            Outer.Parent = ToggleFrame
            Outer.AnchorPoint = Vector2.new(1, 0.5)
            Outer.BackgroundColor3 = Library.Theme.Main
            Outer.Position = UDim2.new(1, -10, 0.5, 0)
            Outer.Size = UDim2.new(0, 40, 0, 20)
            
            local OCorn = Instance.new("UICorner")
            OCorn.CornerRadius = UDim.new(1, 0)
            OCorn.Parent = Outer

            local Inner = Instance.new("Frame")
            Inner.Parent = Outer
            Inner.BackgroundColor3 = state and Library.Theme.Accent or Color3.fromRGB(100, 100, 100)
            Inner.Position = state and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
            Inner.Size = UDim2.new(0, 16, 0, 16)

            local ICorn = Instance.new("UICorner")
            ICorn.CornerRadius = UDim.new(1, 0)
            ICorn.Parent = Inner

            local function Update()
                Tween(Inner, {Time = 0.2}, {
                    Position = state and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2),
                    BackgroundColor3 = state and Library.Theme.Accent or Color3.fromRGB(100, 100, 100)
                })
                pcall(callback, state)
            end

            TBtn.MouseButton1Click:Connect(function()
                state = not state
                Update()
            end)

            return Tab
        end

        function Tab:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = text .. "Slider"
            SliderFrame.Parent = Page
            SliderFrame.BackgroundColor3 = Library.Theme.Secondary
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Size = UDim2.new(0, 330, 0, 50)

            local SCorn = Instance.new("UICorner")
            SCorn.CornerRadius = UDim.new(0, 6)
            SCorn.Parent = SliderFrame

            local STitle = Instance.new("TextLabel")
            STitle.Parent = SliderFrame
            STitle.BackgroundTransparency = 1
            STitle.Position = UDim2.new(0, 12, 0, 8)
            STitle.Size = UDim2.new(1, -60, 0, 15)
            STitle.Font = Library.Theme.Font
            STitle.Text = text
            STitle.TextColor3 = Library.Theme.Text
            STitle.TextSize = 14
            STitle.TextXAlignment = Enum.TextXAlignment.Left

            local SValue = Instance.new("TextLabel")
            SValue.Parent = SliderFrame
            SValue.BackgroundTransparency = 1
            SValue.Position = UDim2.new(1, -62, 0, 8)
            SValue.Size = UDim2.new(0, 50, 0, 15)
            SValue.Font = Library.Theme.Font
            SValue.Text = tostring(default)
            SValue.TextColor3 = Library.Theme.TextDark
            SValue.TextSize = 14
            SValue.TextXAlignment = Enum.TextXAlignment.Right

            local Bar = Instance.new("Frame")
            Bar.Parent = SliderFrame
            Bar.BackgroundColor3 = Library.Theme.Main
            Bar.Position = UDim2.new(0, 12, 0, 32)
            Bar.Size = UDim2.new(1, -24, 0, 6)
            
            local BCorn = Instance.new("UICorner")
            BCorn.CornerRadius = UDim.new(1, 0)
            BCorn.Parent = Bar

            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.BackgroundColor3 = Library.Theme.Accent
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            
            local FCorn = Instance.new("UICorner")
            FCorn.CornerRadius = UDim.new(1, 0)
            FCorn.Parent = Fill

            local Dragging = false
            local function Update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                SValue.Text = tostring(val)
                Tween(Fill, {Time = 0.1}, {Size = UDim2.new(pos, 0, 1, 0)})
                pcall(callback, val)
            end

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    Update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)

            return Tab
        end

        function Tab:CreateDropdown(text, list, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = text .. "Dropdown"
            DropdownFrame.Parent = Page
            DropdownFrame.BackgroundColor3 = Library.Theme.Secondary
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Size = UDim2.new(0, 330, 0, 35)
            DropdownFrame.ClipsDescendants = true

            local DCorn = Instance.new("UICorner")
            DCorn.CornerRadius = UDim.new(0, 6)
            DCorn.Parent = DropdownFrame

            local DTitle = Instance.new("TextLabel")
            DTitle.Parent = DropdownFrame
            DTitle.BackgroundTransparency = 1
            DTitle.Position = UDim2.new(0, 12, 0, 0)
            DTitle.Size = UDim2.new(1, -40, 0, 35)
            DTitle.Font = Library.Theme.Font
            DTitle.Text = text
            DTitle.TextColor3 = Library.Theme.Text
            DTitle.TextSize = 14
            DTitle.TextXAlignment = Enum.TextXAlignment.Left

            local Arrow = Instance.new("TextLabel")
            Arrow.Parent = DropdownFrame
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -35, 0, 0)
            Arrow.Size = UDim2.new(0, 35, 0, 35)
            Arrow.Font = Enum.Font.GothamBold
            Arrow.Text = "v"
            Arrow.TextColor3 = Library.Theme.TextDark
            Arrow.TextSize = 12

            local DBtn = Instance.new("TextButton")
            DBtn.Parent = DropdownFrame
            DBtn.BackgroundTransparency = 1
            DBtn.Size = UDim2.new(1, 0, 0, 35)
            DBtn.Text = ""

            local OptionList = Instance.new("Frame")
            OptionList.Parent = DropdownFrame
            OptionList.BackgroundTransparency = 1
            OptionList.Position = UDim2.new(0, 0, 0, 35)
            OptionList.Size = UDim2.new(1, 0, 0, 0)

            local OLayout = Instance.new("UIListLayout")
            OLayout.Parent = OptionList
            OLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local Open = false
            DBtn.MouseButton1Click:Connect(function()
                Open = not Open
                local targetSize = Open and (35 + (#list * 25)) or 35
                Tween(DropdownFrame, {Time = 0.3}, {Size = UDim2.new(0, 330, 0, targetSize)})
                Tween(Arrow, {Time = 0.3}, {Rotation = Open and 180 or 0})
            end)

            for _, opt in pairs(list) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Parent = OptionList
                OptBtn.BackgroundColor3 = Library.Theme.Main
                OptBtn.BorderSizePixel = 0
                OptBtn.Size = UDim2.new(1, 0, 0, 25)
                OptBtn.Font = Library.Theme.Font
                OptBtn.Text = opt
                OptBtn.TextColor3 = Library.Theme.TextDark
                OptBtn.TextSize = 12

                OptBtn.MouseEnter:Connect(function() Tween(OptBtn, {Time = 0.1}, {TextColor3 = Library.Theme.Text, BackgroundColor3 = Library.Theme.Secondary}) end)
                OptBtn.MouseLeave:Connect(function() Tween(OptBtn, {Time = 0.1}, {TextColor3 = Library.Theme.TextDark, BackgroundColor3 = Library.Theme.Main}) end)

                OptBtn.MouseButton1Click:Connect(function()
                    DTitle.Text = text .. ": " .. opt
                    Open = false
                    Tween(DropdownFrame, {Time = 0.3}, {Size = UDim2.new(0, 330, 0, 35)})
                    Tween(Arrow, {Time = 0.3}, {Rotation = 0})
                    pcall(callback, opt)
                end)
            end

            return Tab
        end

        function Tab:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Parent = Page
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(0, 330, 0, 20)
            Label.Font = Library.Theme.Font
            Label.Text = text
            Label.TextColor3 = Library.Theme.TextDark
            Label.TextSize = 12
            return Tab
        end

        function Tab:CreateColorPicker(text, default, callback)
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Name = text .. "ColorPicker"
            ColorFrame.Parent = Page
            ColorFrame.BackgroundColor3 = Library.Theme.Secondary
            ColorFrame.BorderSizePixel = 0
            ColorFrame.Size = UDim2.new(0, 330, 0, 35)

            local CCorn = Instance.new("UICorner")
            CCorn.CornerRadius = UDim.new(0, 6)
            CCorn.Parent = ColorFrame

            local CTitle = Instance.new("TextLabel")
            CTitle.Parent = ColorFrame
            CTitle.BackgroundTransparency = 1
            CTitle.Position = UDim2.new(0, 12, 0, 0)
            CTitle.Size = UDim2.new(1, -60, 1, 0)
            CTitle.Font = Library.Theme.Font
            CTitle.Text = text
            CTitle.TextColor3 = Library.Theme.Text
            CTitle.TextSize = 14
            CTitle.TextXAlignment = Enum.TextXAlignment.Left

            local ColorShow = Instance.new("Frame")
            ColorShow.Parent = ColorFrame
            ColorShow.AnchorPoint = Vector2.new(1, 0.5)
            ColorShow.BackgroundColor3 = default
            ColorShow.Position = UDim2.new(1, -10, 0.5, 0)
            ColorShow.Size = UDim2.new(0, 40, 0, 20)
            
            local CSCorn = Instance.new("UICorner")
            CSCorn.CornerRadius = UDim.new(0, 4)
            CSCorn.Parent = ColorShow

            local CBtn = Instance.new("TextButton")
            CBtn.Parent = ColorFrame
            CBtn.BackgroundTransparency = 1
            CBtn.Size = UDim2.new(1, 0, 1, 0)
            CBtn.Text = ""

            -- Simple cycle for demo/basic use
            local colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 255)}
            local index = 1
            
            CBtn.MouseButton1Click:Connect(function()
                index = (index % #colors) + 1
                local newColor = colors[index]
                Tween(ColorShow, {Time = 0.2}, {BackgroundColor3 = newColor})
                pcall(callback, newColor)
            end)

            return Tab
        end

        return Tab
    end

    return Window
end

return Library
