Here is the **full, updated code** for your `init.lua`. It includes the reinforced draggable logic and the Givenchy-style layout. 

Copy and paste this into your GitHub file to fix the dragging issue:

```lua
-- Ketamine UI Library (Givenchy Edition)
-- Replicated from C++ ImGui External Menu

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

Library.Theme = {
    Main = Color3.fromRGB(20, 20, 24),
    Header = Color3.fromRGB(21, 20, 24),
    SubHeader = Color3.fromRGB(23, 22, 27),
    Child = Color3.fromRGB(27, 26, 33),
    Border = Color3.fromRGB(30, 29, 37),
    Accent = Color3.fromRGB(160, 32, 240),
    Text = Color3.fromRGB(255, 255, 255),
    TextInactive = Color3.fromRGB(114, 113, 138),
    Font = Enum.Font.GothamMedium,
}

local function Tween(obj, info, goal)
    local tween = TweenService:Create(obj, TweenInfo.new(info.Time or 0.2, info.EasingStyle or Enum.EasingStyle.Quart, info.EasingDirection or Enum.EasingDirection.Out), goal)
    tween:Play()
    return tween
end

function Library:MakeDraggable(drag_part, target_part)
	local dragging, dragInput, dragStart, startPos
	drag_part.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			-- Safety Check: Ensure we aren't clicking a button or slider
			local player = game:GetService("Players").LocalPlayer
			if player then
				local gui = player:FindFirstChildOfClass("PlayerGui")
				if gui then
					local objects = gui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
					for _, obj in pairs(objects) do
						if obj:IsA("TextButton") or obj:IsA("ScrollingFrame") or obj:IsA("TextBox") then
							return -- Cancel drag if we clicked an interactive element
						end
					end
				end
			end
			
			dragging = true; dragStart = input.Position; startPos = target_part.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	drag_part.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			target_part.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function Library:CreateWindow(options)
    options = options or {}
    local Title = options.Title or "Givenchy"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GivenchyUI_" .. math.random(100, 999)
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = CoreGui

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = self.Theme.Main
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -275, 0.5, -185)
    Main.Size = UDim2.new(0, 550, 0, 370)
    Main.ClipsDescendants = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Main

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = self.Theme.Border
    UIStroke.Thickness = 1
    UIStroke.Parent = Main

    -- Header (Title Bar)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Main
    Header.BackgroundColor3 = self.Theme.Header
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 45)

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header

    -- Fix bottom corners of header
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Parent = Header
    HeaderFix.BackgroundColor3 = self.Theme.Header
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
    HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)

    local LogoContainer = Instance.new("Frame")
    LogoContainer.Name = "Logo"
    LogoContainer.Parent = Header
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Position = UDim2.new(0, 15, 0, 0)
    LogoContainer.Size = UDim2.new(0, 150, 1, 0)

    local KetaLabel = Instance.new("TextLabel")
    KetaLabel.Parent = LogoContainer
    KetaLabel.BackgroundTransparency = 1
    KetaLabel.Size = UDim2.new(0, 0, 1, 0)
    KetaLabel.Font = self.Theme.Font
    KetaLabel.Text = "Keta"
    KetaLabel.TextColor3 = self.Theme.Text
    KetaLabel.TextSize = 17
    KetaLabel.TextXAlignment = Enum.TextXAlignment.Left
    KetaLabel.AutomaticSize = Enum.AutomaticSize.X

    local MineLabel = Instance.new("TextLabel")
    MineLabel.Parent = LogoContainer
    MineLabel.BackgroundTransparency = 1
    MineLabel.Position = UDim2.new(0, 36, 0, 0)
    MineLabel.Size = UDim2.new(0, 0, 1, 0)
    MineLabel.Font = self.Theme.Font
    MineLabel.Text = "mine"
    MineLabel.TextColor3 = self.Theme.Accent
    MineLabel.TextSize = 17
    MineLabel.TextXAlignment = Enum.TextXAlignment.Left
    MineLabel.AutomaticSize = Enum.AutomaticSize.X

    -- Tab Container in Header (Right side)
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "Tabs"
    TabContainer.Parent = Header
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(1, -350, 0, 0)
    TabContainer.Size = UDim2.new(0, 340, 1, 0)

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabLayout.Padding = UDim.new(0, 15)

    -- SubHeader (Tab Info Area)
    local SubHeader = Instance.new("Frame")
    SubHeader.Name = "SubHeader"
    SubHeader.Parent = Main
    SubHeader.BackgroundColor3 = self.Theme.SubHeader
    SubHeader.BorderSizePixel = 0
    SubHeader.Position = UDim2.new(0, 0, 0, 45)
    SubHeader.Size = UDim2.new(1, 0, 0, 30)

    local BorderLine = Instance.new("Frame")
    BorderLine.Parent = SubHeader
    BorderLine.BackgroundColor3 = self.Theme.Border
    BorderLine.BorderSizePixel = 0
    BorderLine.Size = UDim2.new(1, 0, 0, 1)

    local BorderLine2 = Instance.new("Frame")
    BorderLine2.Parent = SubHeader
    BorderLine2.BackgroundColor3 = self.Theme.Border
    BorderLine2.BorderSizePixel = 0
    BorderLine2.Position = UDim2.new(0, 0, 1, -1)
    BorderLine2.Size = UDim2.new(1, 0, 0, 1)

    -- Content Area
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 0, 0, 75)
    Content.Size = UDim2.new(1, 0, 1, -75)

    self:MakeDraggable(Header, Main)

    local Window = {
        Tabs = {},
        CurrentTab = nil
    }

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name .. "Tab"
        TabBtn.Parent = TabContainer
        TabBtn.BackgroundTransparency = 1
        TabBtn.Font = Library.Theme.Font
        TabBtn.Text = name
        TabBtn.TextColor3 = Library.Theme.TextInactive
        TabBtn.TextSize = 14
        TabBtn.AutomaticSize = Enum.AutomaticSize.X
        TabBtn.Size = UDim2.new(0, 0, 1, 0)

        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "Page"
        Page.Parent = Content
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Library.Theme.Accent
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)

        local PageLayout = Instance.new("UIGridLayout")
        PageLayout.Parent = Page
        PageLayout.CellPadding = UDim2.new(0, 15, 0, 15)
        PageLayout.CellSize = UDim2.new(0, 252, 0, 0)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.FillDirection = Enum.FillDirection.Horizontal

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingLeft = UDim.new(0, 15)
        PagePadding.PaddingRight = UDim.new(0, 15)
        PagePadding.PaddingTop = UDim.new(0, 15)
        PagePadding.Parent = Page

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Library.Theme.TextInactive end end
            Page.Visible = true
            TabBtn.TextColor3 = Library.Theme.Text
        end)

        if #TabContainer:GetChildren() == 2 then
            Page.Visible = true
            TabBtn.TextColor3 = Library.Theme.Text
        end

        local Tab = {}

        function Tab:CreateSection(title)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = title .. "Section"
            SectionFrame.Parent = Page
            SectionFrame.BackgroundColor3 = Library.Theme.Child
            SectionFrame.BorderSizePixel = 0
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)

            local SCorn = Instance.new("UICorner")
            SCorn.CornerRadius = UDim.new(0, 8)
            SCorn.Parent = SectionFrame

            local SStroke = Instance.new("UIStroke")
            SStroke.Color = Library.Theme.Border
            SStroke.Thickness = 1
            SStroke.Parent = SectionFrame

            local STitle = Instance.new("TextLabel")
            STitle.Parent = SectionFrame
            STitle.BackgroundTransparency = 1
            STitle.Position = UDim2.new(0, 12, 0, 8)
            STitle.Size = UDim2.new(1, -24, 0, 20)
            STitle.Font = Library.Theme.Font
            STitle.Text = title
            STitle.TextColor3 = Library.Theme.Text
            STitle.TextSize = 13
            STitle.TextXAlignment = Enum.TextXAlignment.Left

            local Container = Instance.new("Frame")
            Container.Parent = SectionFrame
            Container.BackgroundTransparency = 1
            Container.Position = UDim2.new(0, 0, 0, 32)
            Container.Size = UDim2.new(1, 0, 0, 0)
            Container.AutomaticSize = Enum.AutomaticSize.Y

            local CLayout = Instance.new("UIListLayout")
            CLayout.Parent = Container
            CLayout.Padding = UDim.new(0, 8)
            CLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

            local CPadding = Instance.new("UIPadding")
            CPadding.PaddingBottom = UDim.new(0, 10)
            CPadding.Parent = Container

            local Section = {}

            function Section:CreateToggle(text, default, callback)
                local state = default or false
                local Tgl = Instance.new("TextButton")
                Tgl.Parent = Container
                Tgl.BackgroundTransparency = 1
                Tgl.Size = UDim2.new(0, 230, 0, 20)
                Tgl.Text = ""

                local Box = Instance.new("Frame")
                Box.Parent = Tgl
                Box.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Main
                Box.BorderSizePixel = 0
                Box.Size = UDim2.new(0, 14, 0, 14)
                Box.Position = UDim2.new(0, 0, 0.5, -7)
                
                local BCorn = Instance.new("UICorner")
                BCorn.CornerRadius = UDim.new(0, 3)
                BCorn.Parent = Box

                local Label = Instance.new("TextLabel")
                Label.Parent = Tgl
                Label.BackgroundTransparency = 1
                Label.Position = UDim2.new(0, 22, 0, 0)
                Label.Size = UDim2.new(1, -22, 1, 0)
                Label.Font = Library.Theme.Font
                Label.Text = text
                Label.TextColor3 = state and Library.Theme.Text or Library.Theme.TextInactive
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left

                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    Tween(Box, {Time = 0.1}, {BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Main})
                    Tween(Label, {Time = 0.1}, {TextColor3 = state and Library.Theme.Text or Library.Theme.TextInactive})
                    pcall(callback, state)
                end)
                return Section
            end

            function Section:CreateSlider(text, min, max, default, callback)
                local Sld = Instance.new("Frame")
                Sld.Parent = Container
                Sld.BackgroundTransparency = 1
                Sld.Size = UDim2.new(0, 230, 0, 35)

                local Label = Instance.new("TextLabel")
                Label.Parent = Sld
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 15)
                Label.Font = Library.Theme.Font
                Label.Text = text
                Label.TextColor3 = Library.Theme.TextInactive
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Parent = Sld
                ValLabel.BackgroundTransparency = 1
                ValLabel.Position = UDim2.new(1, -50, 0, 0)
                ValLabel.Size = UDim2.new(0, 50, 0, 15)
                ValLabel.Font = Library.Theme.Font
                ValLabel.Text = tostring(default)
                ValLabel.TextColor3 = Library.Theme.TextInactive
                ValLabel.TextSize = 12
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right

                local Bar = Instance.new("Frame")
                Bar.Parent = Sld
                Bar.BackgroundColor3 = Library.Theme.Main
                Bar.BorderSizePixel = 0
                Bar.Position = UDim2.new(0, 0, 0, 20)
                Bar.Size = UDim2.new(1, 0, 0, 8)
                
                local BCorn = Instance.new("UICorner")
                BCorn.CornerRadius = UDim.new(0, 3)
                BCorn.Parent = Bar

                local Fill = Instance.new("Frame")
                Fill.Parent = Bar
                Fill.BackgroundColor3 = Library.Theme.Accent
                Fill.BorderSizePixel = 0
                Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                
                local FCorn = Instance.new("UICorner")
                FCorn.CornerRadius = UDim.new(0, 3)
                FCorn.Parent = Fill

                local dragging = false
                local function update(input)
                    local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * pos)
                    ValLabel.Text = tostring(val)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    pcall(callback, val)
                end

                Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(input) end end)
                UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
                UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)

                return Section
            end

            return Section
        end

        return Tab
    end

    function Library:Notify(options)
        local Box = Instance.new("Frame")
        Box.Parent = ScreenGui
        Box.BackgroundColor3 = self.Theme.Main
        Box.Size = UDim2.new(0, 200, 0, 50)
    end

    return Window
end

return Library
```
