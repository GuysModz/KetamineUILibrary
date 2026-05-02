# 🌌 Ketamine UI

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-purple.svg)]()
[![Platform: Roblox](https://img.shields.io/badge/Platform-Roblox-red.svg)]()

**Ketamine UI** is a high-performance, premium Luau UI library built for Roblox developers who want their scripts to look and feel state-of-the-art. Featuring a glassmorphism design language, smooth animations, and an intuitive API.

---

## ✨ Features

- 💎 **Modern Aesthetics**: Sleek dark mode with customizable accent colors and glassmorphism effects.
- 🚀 **Performant**: Built from the ground up using optimized `Instance.new` calls and `TweenService`.
- 📱 **Responsive**: Supports various screen sizes and input types (Mouse, Touch).
- 🛠️ **Developer Friendly**: Chainable methods and clean API structure.
- 📦 **Component Rich**:
    - Smooth Tab Switching
    - Animated Toggles & Sliders
    - Expandable Dropdowns
    - Color Pickers
    - Stackable Notifications

---

## 📸 Screenshots

*(Add your screenshots here! Example placeholder below)*

![Main Interface](https://via.placeholder.com/600x350/141419/FFFFFF?text=Antigravity+UI+Interface)

---

## 🚀 Quick Start

To use Ketamine UI in your script, simply use `loadstring`:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuysModz/KetamineUILibrary/refs/heads/main/init.lua"))()

local Window = Library:CreateWindow({
    Title = "Givenchy"
})

local Tab = Window:CreateTab("Main")

Tab:CreateToggle("Enable Feature", false, function(state)
    print("Feature is now:", state)
end)

Library:Notify({
    Title = "Welcome",
    Content = "Antigravity UI has loaded!",
    Duration = 5
})
```

---

## 📑 Documentation

For a full list of components and detailed API usage, check out the [DOCUMENTATION.md](./DOCUMENTATION.md) file.

---

## 🎨 Theming

Customizing the look of your UI is easy. Simply modify the `Library.Theme` table before creating your window:

```lua
Library.Theme.Accent = Color3.fromRGB(115, 80, 255) -- Purple accent
Library.Theme.Main = Color3.fromRGB(20, 20, 25)      -- Background color
```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request or open an issue for any bugs or feature requests.

## ⚖️ License

Distributed under the MIT License. See `LICENSE` for more information.

---

<p align="center">
  Built with ❤️ by Antigravity
</p>
