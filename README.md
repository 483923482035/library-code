# priv9 UI Library

A modern, responsive pixel-font UI library for Luau with 4x text shadow outline rendering, customizable themes, draggable HUDs, multi-subpage selection lists, and a clean watermark & notification system.

## Quickstart

Run this directly in your executor:

```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/483923482035/library-code/main/library.lua"))()

-- 1. Draggable Watermark (with live FPS & Ping display)
local watermark = library:watermark({
	name = "priv9 library showcase",
	auto_update = true,
})

-- 2. Create Window
local window = library:window({
	name = "priv9 UI Library | Full Feature Showcase",
	size = UDim2.new(0, 490, 0, 360),
})

-- Tab 1: General Widgets
local general_tab = window:tab({name = "general"})
local col_left = general_tab:column({})
local col_center = general_tab:column({})
local col_right = general_tab:column({})

-- Column 1: Toggles, Folding Elements, Buttons, Textbox
local section_controls = col_left:section({name = "controls", size = 1, default = true})
section_controls:toggle({
	name = "simple toggle",
	flag = "demo_toggle",
	default = true,
})

-- Folding toggle (expands nested controls when enabled)
local fold = section_controls:toggle({
	name = "folding toggle",
	flag = "demo_fold",
	folding = true,
	default = false,
})
fold:slider({
	name = "nested slider",
	min = 1,
	max = 10,
	default = 5,
})

section_controls:button({
	name = "trigger notification",
	callback = function()
		library:create_notification({
			name = "priv9: Action executed successfully!",
		})
	end,
})

section_controls:textbox({
	name = "text input:",
	placeholder = "Enter custom text...",
	flag = "demo_textbox",
	default = "Sample Text",
})

-- Column 2: Sliders & Bipolar Sliders
local section_sliders = col_center:section({name = "sliders", size = 1, default = true})
section_sliders:slider({
	name = "percentage slider",
	flag = "demo_pct_slider",
	min = 0,
	max = 100,
	default = 50,
	suffix = "%",
})
section_sliders:slider({
	name = "decimal slider",
	flag = "demo_dec_slider",
	min = 0,
	max = 5,
	default = 1.5,
	interval = 0.1,
	suffix = "s",
})
section_sliders:bipolar_slider({
	name = "bipolar offset",
	flag = "demo_bipolar_slider",
	min = -50,
	max = 50,
	default = 0,
	suffix = "px",
})

-- Column 3: Selectors, Colors, Keybinds
local section_inputs = col_right:section({name = "selectors", size = 1, default = true})
section_inputs:dropdown({
	name = "single selection",
	flag = "demo_single_drop",
	items = {"Option A", "Option B", "Option C"},
	default = "Option A",
})
section_inputs:dropdown({
	name = "multi selection",
	flag = "demo_multi_drop",
	items = {"Choice 1", "Choice 2", "Choice 3"},
	default = {"Choice 1"},
	multi = true,
})
section_inputs:colorpicker({
	name = "accent color",
	flag = "demo_accent_color",
	color = Color3.fromRGB(88, 101, 242),
	alpha = 0.8,
})
section_inputs:keybind({
	name = "action keybind",
	flag = "demo_keybind",
	key = Enum.KeyCode.F,
	mode = "toggle",
	callback = function()
		library:update_keybind_visualizer()
	end,
})

-- Tab 2: Visuals Selection List (Multi-Subpage System) & Item List
local selection_tab = window:tab({name = "selection list"})
local sel_col_left = selection_tab:column({})
local sel_col_center = selection_tab:column({})
local sel_col_right = selection_tab:column({})

local selection_section = sel_col_left:section({name = "subpages", size = 0.5, default = true})
library:create_visuals_selection(selection_section)

local list_section = sel_col_left:section({name = "items", size = 0.5, default = true})
list_section:list({
	name = "players",
	flag = "selected_player",
	items = {"Target 1", "Target 2", "Target 3"},
	size = 75,
})

local pages = {
	{id = "page_players", label = "players", center_label = "player esp", right_label = "player chams"},
	{id = "page_world", label = "world", center_label = "world settings", right_label = "environmental options"},
	{id = "page_misc", label = "misc", center_label = "crosshair", right_label = "fov circle"},
}

for _, page in ipairs(pages) do
	local page_data = library:create_visuals_page(sel_col_center, sel_col_right, page)
	page_data.center:toggle({name = "enable " .. page.label, default = false})
	page_data.right:slider({name = page.label .. " radius", min = 10, max = 500, default = 100, suffix = "m"})
	library:register_visuals_page(page.id, page.label, page_data.center, page_data.right)
end
library:set_visuals_page("page_players")

-- Initialize Built-In Config & Theme Manager
library:init_config(window)

-- Open Menu
window.toggle_menu(true)
```

## Features

- **Draggable Watermark**: Single clean rendering, dynamic width auto-sizing, optional `auto_update` loop for real-time FPS & Ping, and manual `update_text(text)`, `set_visible(bool)`, and `destroy()` methods.
- **Teardown & Re-Execution**: Automatic cleanup of previous instances, connections, and ScreenGuis on re-execution or `library:unload_menu()`.
- **4-Way Text Shadow Outline**: Native rendering of pixel fonts with high readability outlines.
- **Folding Toggles**: Toggles with collapsible sub-element containers for nested sliders, colorpickers, and options.
- **Comprehensive Controls**: Regular and Bipolar sliders, single and multi-selection dropdowns, colorpicker with alpha transparency, keybinds with toggle/hold modes, text inputs, and item lists.
- **Visuals Subpage Engine**: Flexible 3-column subpage switcher layout for visual setups.
- **Theme & Config Management**: Integrated config system with theme color gradients (Morytania, Ancient, New, Dark, and Custom).
