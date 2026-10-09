local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/483923482035/library-code/main/library.lua"))()

-- Create Window
local window = library:window({
	name = "Library Showcase - Full Feature Demo",
})

-- Draggable Watermark with Ping / FPS
local watermark = library:watermark({name = "Showcase Demo | FPS: 60"})

-- Tab 1: General Widgets
local general_tab = window:tab({name = "general"})
local col_left = general_tab:column({})
local col_center = general_tab:column({})
local col_right = general_tab:column({})

-- Column 1: Toggles, Buttons, Textbox
local section_controls = col_left:section({name = "controls", size = 1})

section_controls:toggle({
	name = "enable feature",
	flag = "demo_toggle",
	default = true,
	callback = function(state)
		print("Toggle state:", state)
	end,
})

section_controls:toggle({
	name = "folding toggle",
	flag = "demo_folding_toggle",
	default = false,
	folding = true,
	callback = function(state)
		print("Folding toggle:", state)
	end,
})

section_controls:button({
	name = "trigger notification",
	callback = function()
		notifications:create_notification({
			name = "Hello! Notification system working perfectly.",
		})
	end,
})

section_controls:textbox({
	name = "text input:",
	flag = "demo_textbox",
	callback = function(text)
		print("Textbox text:", text)
	end,
})

-- Column 2: Sliders & Bipolar Sliders
local section_sliders = col_center:section({name = "sliders", size = 1})

section_sliders:slider({
	name = "percentage slider",
	flag = "demo_slider",
	min = 0,
	max = 100,
	default = 50,
	interval = 1,
	suffix = "%",
	callback = function(value)
		print("Slider value:", value)
	end,
})

section_sliders:slider({
	name = "precise decimal slider",
	flag = "demo_slider_dec",
	min = 0,
	max = 5,
	default = 1.5,
	interval = 0.1,
	suffix = "s",
	callback = function(value)
		print("Decimal slider:", value)
	end,
})

section_sliders:bipolar_slider({
	name = "bipolar offset slider",
	flag = "demo_bipolar_slider",
	min = -100,
	max = 100,
	default = 0,
	interval = 1,
	suffix = "px",
	callback = function(value)
		print("Bipolar offset:", value)
	end,
})

-- Column 3: Dropdowns, Colorpickers, Keybinds
local section_inputs = col_right:section({name = "selectors", size = 1})

section_inputs:dropdown({
	name = "single selection",
	flag = "demo_single_drop",
	items = {"Option A", "Option B", "Option C"},
	default = "Option A",
	callback = function(selected)
		print("Selected:", selected)
	end,
})

section_inputs:dropdown({
	name = "multi selection",
	flag = "demo_multi_drop",
	items = {"Choice 1", "Choice 2", "Choice 3"},
	default = {"Choice 1"},
	multi = true,
	callback = function(selected)
		print("Multi selected:", selected)
	end,
})

section_inputs:colorpicker({
	name = "accent color",
	flag = "demo_accent_color",
	color = Color3.fromRGB(88, 101, 242),
	alpha = 0,
	callback = function(col, alpha)
		print("Color updated:", col, "Alpha:", alpha)
	end,
})

section_inputs:keybind({
	name = "action keybind",
	flag = "demo_keybind",
	key = Enum.KeyCode.F,
	mode = "toggle",
	callback = function(active)
		print("Keybind active:", active)
		library:update_keybind_visualizer()
	end,
})

-- Tab 2: Visuals Selection List (Multi-Subpage System)
local selection_tab = window:tab({name = "selection list"})
local sel_col_left = selection_tab:column({})
local sel_col_center = selection_tab:column({})
local sel_col_right = selection_tab:column({})

local selection_section = sel_col_left:section({name = "selection", size = 1, default = true})
local selection_box = library:create_visuals_selection(selection_section)

local pages = {
	{id = "page_players", label = "players", center_label = "player filters", right_label = "player options"},
	{id = "page_world", label = "world", center_label = "world settings", right_label = "environmental options"},
	{id = "page_misc", label = "misc", center_label = "miscellaneous", right_label = "extra options"},
}

for _, page in ipairs(pages) do
	local page_data = library:create_visuals_page(sel_col_center, sel_col_right, page)

	-- Populate subpage center section
	page_data.center:toggle({
		name = "enable " .. page.label,
		default = false,
	})
	page_data.center:slider({
		name = page.label .. " radius",
		min = 10,
		max = 500,
		default = 100,
		suffix = "m",
	})

	-- Populate subpage right section
	page_data.right:colorpicker({
		name = page.label .. " color",
		color = Color3.fromRGB(255, 255, 255),
	})
	page_data.right:keybind({
		name = page.label .. " key",
		key = Enum.KeyCode.None,
		mode = "toggle",
	})

	library:register_visuals_page(page.id, page.label, page_data.center, page_data.right)
end

-- Default to first page
library:set_visuals_page("page_players")

-- Tab 3: Keybinds HUD Controller
local hud_tab = window:tab({name = "hud"})
local hud_col = hud_tab:column({})
local hud_section = hud_col:section({name = "keybind visualizer", size = 1})

hud_section:toggle({
	name = "draggable hud",
	flag = "keybind_draggable",
	default = false,
	callback = function(bool)
		if not bool and library.reset_keybind_position then
			library:reset_keybind_position()
		end
		library:update_keybind_visualizer()
	end,
})

-- Initialize Built-In Config & Theme Manager
library:init_config(window)

-- Open Menu
window.toggle_menu(true)
