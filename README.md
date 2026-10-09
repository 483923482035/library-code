# UI Library

A modern, responsive pixel-font UI library for Luau.

## Quickstart

```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/483923482035/library-code/main/library.lua"))()

local window = library:window({
    name = "UI Window"
})

local tab = window:tab({name = "main"})
local column = tab:column({})
local section = column:section({name = "controls", size = 1})

section:toggle({name = "Example Toggle", default = false, callback = function(val)
    print("Toggle:", val)
end})

section:slider({name = "Example Slider", min = 1, max = 100, default = 50, interval = 1, callback = function(val)
    print("Slider:", val)
end})
```
