-- Ketamine UI Library (Givenchy Edition)
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

Library.Theme = {
    Main = Color3.fromRGB(20, 20, 24),
    Header = Color3.fromRGB(21, 20, 24),
    SubHeader = Color3.fromRGB(23, 22, 27),
    Child = Color3.fromRGB(27, 26, 33),
    Border = Color3.fromRGB(35, 34, 42),
    Accent = Color3.fromRGB(160, 32, 240),
    Text = Color3.fromRGB(255, 255, 255),
    TextInactive = Color3.fromRGB(160, 160, 180),
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
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "GivenchyUI_" .. math.random(100, 999)

    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Library.Theme.Main; Main.BorderSizePixel = 0; Main.Position = UDim2.new(0.5, -275, 0.5, -185); Main.Size = UDim2.new(0, 550, 0, 370); Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Main).Color = Library.Theme.Border

    -- 1. Content Area (Created FIRST so it's behind headers)
    local Content = Instance.new("Frame", Main)
    Content.Name = "Content"
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 0, 0, 86) -- Start exactly after the subheader
    Content.Size = UDim2.new(1, 0, 1, -86)
    Content.ClipsDescendants = true -- THIS IS KEY: No more overlapping

    -- 2. SubHeader Bar
    local SubHeader = Instance.new("Frame", Main)
    SubHeader.BackgroundColor3 = Library.Theme.SubHeader; SubHeader.BorderSizePixel = 0; SubHeader.Position = UDim2.new(0, 0, 0, 50); SubHeader.Size = UDim2.new(1, 0, 0, 36)
    local B1 = Instance.new("Frame", SubHeader); B1.BackgroundColor3 = Library.Theme.Border; B1.BorderSizePixel = 0; B1.Size = UDim2.new(1, 0, 0, 1)
    local B2 = Instance.new("Frame", SubHeader); B2.BackgroundColor3 = Library.Theme.Border; B2.BorderSizePixel = 0; B2.Position = UDim2.new(0, 0, 1, -1); B2.Size = UDim2.new(1, 0, 0, 1)

    -- 3. Title Bar (Header)
    local Header = Instance.new("Frame", Main)
    Header.BackgroundColor3 = Library.Theme.Header; Header.BorderSizePixel = 0; Header.Size = UDim2.new(1, 0, 0, 50)
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)
    local HeaderFix = Instance.new("Frame", Header); HeaderFix.BackgroundColor3 = Library.Theme.Header; HeaderFix.BorderSizePixel = 0; HeaderFix.Position = UDim2.new(0, 0, 0.5, 0); HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)

    -- Logo
    local Logo = Instance.new("Frame", Header); Logo.BackgroundTransparency = 1; Logo.Position = UDim2.new(0, 20, 0, 0); Logo.Size = UDim2.new(0, 150, 1, 0)
    local L1 = Instance.new("TextLabel", Logo); L1.BackgroundTransparency = 1; L1.Size = UDim2.new(0, 0, 1, 0); L1.Font = Library.Theme.Font; L1.Text = "Keta"; L1.TextColor3 = Library.Theme.Text; L1.TextSize = 18; L1.TextXAlignment = Enum.TextXAlignment.Left; L1.AutomaticSize = Enum.AutomaticSize.X
    local L2 = Instance.new("TextLabel", Logo); L2.BackgroundTransparency = 1; L2.Position = UDim2.new(0, 42, 0, 0); L2.Size = UDim2.new(0, 0, 1, 0); L2.Font = Library.Theme.Font; L2.Text = "mine"; L2.TextColor3 = Library.Theme.Accent; L2.TextSize = 18; L2.TextXAlignment = Enum.TextXAlignment.Left; L2.AutomaticSize = Enum.AutomaticSize.X

    -- Tabs
    local TabContainer = Instance.new("Frame", Header); TabContainer.BackgroundTransparency = 1; TabContainer.Position = UDim2.new(1, -360, 0, 0); TabContainer.Size = UDim2.new(0, 340, 1, 0)
    local TabLayout = Instance.new("UIListLayout", TabContainer); TabLayout.FillDirection = Enum.FillDirection.Horizontal; TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right; TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center; TabLayout.Padding = UDim.new(0, 20)

    Library:MakeDraggable(Header, Main)

    local Window = {}
    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabContainer); TabBtn.BackgroundTransparency = 1; TabBtn.Font = Library.Theme.Font; TabBtn.Text = name; TabBtn.TextColor3 = Library.Theme.TextInactive; TabBtn.TextSize = 14; TabBtn.AutomaticSize = Enum.AutomaticSize.X; TabBtn.Size = UDim2.new(0, 0, 1, 0)
        local Page = Instance.new("ScrollingFrame", Content); Page.Visible = false; Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0; Page.Size = UDim2.new(1, 0, 1, 0); Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Library.Theme.Accent; Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        local PageLayout = Instance.new("UIGridLayout", Page); PageLayout.CellPadding = UDim2.new(0, 15, 0, 15); PageLayout.CellSize = UDim2.new(0, 252, 0, 0); PageLayout.SortOrder = Enum.SortOrder.LayoutOrder; PageLayout.FillDirection = Enum.FillDirection.Horizontal
        local Padding = Instance.new("UIPadding", Page); Padding.PaddingLeft = UDim.new(0, 15); Padding.PaddingRight = UDim.new(0, 15); Padding.PaddingTop = UDim.new(0, 15)
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30) end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Library.Theme.TextInactive end end
            Page.Visible = true; TabBtn.TextColor3 = Library.Theme.Text
        end)
        if #TabContainer:GetChildren() == 2 then Page.Visible = true; TabBtn.TextColor3 = Library.Theme.Text end

        local Tab = {}
        function Tab:CreateSection(title)
            local SectionFrame = Instance.new("Frame", Page); SectionFrame.BackgroundColor3 = Library.Theme.Child; SectionFrame.BorderSizePixel = 0; SectionFrame.AutomaticSize = Enum.AutomaticSize.Y; SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", SectionFrame).Color = Library.Theme.Border
            
            local STitle = Instance.new("TextLabel", SectionFrame); STitle.BackgroundTransparency = 1; STitle.Position = UDim2.new(0, 12, 0, 12); STitle.Size = UDim2.new(1, -24, 0, 20); STitle.Font = Library.Theme.Font; STitle.Text = title; STitle.TextColor3 = Library.Theme.Text; STitle.TextSize = 13; STitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local Container = Instance.new("Frame", SectionFrame); Container.BackgroundTransparency = 1; Container.Position = UDim2.new(0, 0, 0, 40); Container.Size = UDim2.new(1, 0, 0, 0); Container.AutomaticSize = Enum.AutomaticSize.Y
            local CLayout = Instance.new("UIListLayout", Container); CLayout.Padding = UDim.new(0, 12); CLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            Instance.new("UIPadding", Container).PaddingBottom = UDim.new(0, 15)

            local Section = {}
            function Section:CreateToggle(text, default, callback)
                local state = default or false
                local Tgl = Instance.new("TextButton", Container); Tgl.BackgroundTransparency = 1; Tgl.Size = UDim2.new(0, 230, 0, 22); Tgl.Text = ""
                local Box = Instance.new("Frame", Tgl); Box.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Main; Box.BorderSizePixel = 0; Box.Size = UDim2.new(0, 16, 0, 16); Box.Position = UDim2.new(0, 0, 0.5, -8)
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
                local Label = Instance.new("TextLabel", Tgl); Label.BackgroundTransparency = 1; Label.Position = UDim2.new(0, 28, 0, 0); Label.Size = UDim2.new(1, -28, 1, 0); Label.Font = Library.Theme.Font; Label.Text = text; Label.TextColor3 = state and Library.Theme.Text or Library.Theme.TextInactive; Label.TextSize = 14; Label.TextXAlignment = Enum.TextXAlignment.Left
                Tgl.MouseButton1Click:Connect(function()
                    state = not state; Tween(Box, {Time = 0.15}, {BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Main}); Tween(Label, {Time = 0.15}, {TextColor3 = state and Library.Theme.Text or Library.Theme.TextInactive}); pcall(callback, state)
                end)
                return Section
            end
            function Section:CreateSlider(text, min, max, default, callback)
                local Sld = Instance.new("Frame", Container); Sld.BackgroundTransparency = 1; Sld.Size = UDim2.new(0, 230, 0, 45)
                local Label = Instance.new("TextLabel", Sld); Label.BackgroundTransparency = 1; Label.Size = UDim2.new(1, 0, 0, 20); Label.Font = Library.Theme.Font; Label.Text = text; Label.TextColor3 = Library.Theme.TextInactive; Label.TextSize = 13; Label.TextXAlignment = Enum.TextXAlignment.Left
                local ValLabel = Instance.new("TextLabel", Sld); ValLabel.BackgroundTransparency = 1; ValLabel.Position = UDim2.new(1, -50, 0, 0); ValLabel.Size = UDim2.new(0, 50, 0, 20); ValLabel.Font = Library.Theme.Font; ValLabel.Text = tostring(default); ValLabel.TextColor3 = Library.Theme.TextInactive; ValLabel.TextSize = 13; ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                local Bar = Instance.new("Frame", Sld); Bar.BackgroundColor3 = Library.Theme.Main; Bar.BorderSizePixel = 0; Bar.Position = UDim2.new(0, 0, 0, 28); Bar.Size = UDim2.new(1, 0, 0, 8)
                Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 4)
                local Fill = Instance.new("Frame", Bar); Fill.BackgroundColor3 = Library.Theme.Accent; Fill.BorderSizePixel = 0; Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 4)
                local dragging = false
                local function update(input)
                    local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1); local val = math.floor(min + (max - min) * pos); ValLabel.Text = tostring(val); Fill.Size = UDim2.new(pos, 0, 1, 0); pcall(callback, val)
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
    return Window
end

return Library
