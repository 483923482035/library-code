-- Load Library (Standalone Repository)
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/483923482035/library-code/main/library.lua"))()

-- =====================================================================
-- 1. Draggable Watermark (with live FPS & Ping display)
-- =====================================================================
local watermark = library:watermark({
	name = "priv9 library showcase",
	auto_update = true,
})

-- =====================================================================
-- 2. Create Window
-- =====================================================================
local window = library:window({
	name = "priv9 UI Library | Full Feature Showcase",
	size = UDim2.new(0, 490, 0, 360),
})

-- =====================================================================
-- TAB 1: General Widgets & Controls
-- =====================================================================
local general_tab = window:tab({name = "general"})
local col_left = general_tab:column({})
local col_center = general_tab:column({})
local col_right = general_tab:column({})

-- --- Column 1: Toggles, Folding Elements, Buttons, Textbox ---
local sec_toggles = col_left:section({name = "toggles & buttons", size = 1, default = true})

sec_toggles:toggle({
	name = "simple toggle",
	flag = "demo_simple_toggle",
	default = true,
	callback = function(state)
		print("[Toggle] Simple toggle set to:", state)
	end,
})

-- Folding toggle (expands nested controls when turned ON)
local folding_toggle = sec_toggles:toggle({
	name = "folding toggle",
	flag = "demo_folding_toggle",
	default = false,
	folding = true,
	callback = function(state)
		print("[Toggle] Folding toggle set to:", state)
	end,
})

folding_toggle:slider({
	name = "nested slider",
	flag = "demo_nested_slider",
	min = 1,
	max = 10,
	default = 5,
	suffix = "x",
	callback = function(val)
		print("[Folding] Nested slider value:", val)
	end,
})

folding_toggle:colorpicker({
	name = "nested color",
	flag = "demo_nested_color",
	color = Color3.fromRGB(255, 80, 80),
	callback = function(c)
		print("[Folding] Nested color updated:", c)
	end,
})

sec_toggles:button({
	name = "push notification",
	callback = function()
		-- Both library:create_notification and notifications:create_notification work seamlessly
		library:create_notification({
			name = "priv9: Action executed successfully!",
		})
	end,
})

sec_toggles:textbox({
	name = "text field:",
	placeholder = "Enter custom text...",
	flag = "demo_textbox",
	default = "Sample Text",
	callback = function(text)
		print("[Textbox] Current text:", text)
	end,
})

-- --- Column 2: Sliders & Bipolar Sliders ---
local sec_sliders = col_center:section({name = "numeric sliders", size = 1, default = true})

sec_sliders:slider({
	name = "percentage slider",
	flag = "demo_pct_slider",
	min = 0,
	max = 100,
	default = 65,
	interval = 1,
	suffix = "%",
	callback = function(val)
		print("[Slider] Percentage:", val)
	end,
})

sec_sliders:slider({
	name = "decimal delay",
	flag = "demo_dec_slider",
	min = 0,
	max = 5,
	default = 0.75,
	interval = 0.05,
	suffix = "s",
	callback = function(val)
		print("[Slider] Decimal delay:", val)
	end,
})

sec_sliders:bipolar_slider({
	name = "bipolar offset",
	flag = "demo_bipolar_slider",
	min = -50,
	max = 50,
	default = 0,
	interval = 1,
	suffix = "px",
	callback = function(val)
		print("[Slider] Bipolar offset:", val)
	end,
})

-- --- Column 3: Selectors, Colorpickers & Keybinds ---
local sec_selectors = col_right:section({name = "selectors & colors", size = 1, default = true})

sec_selectors:dropdown({
	name = "single dropdown",
	flag = "demo_single_dropdown",
	items = {"Mode 1 (Legit)", "Mode 2 (Rage)", "Mode 3 (Silent)"},
	default = "Mode 1 (Legit)",
	callback = function(choice)
		print("[Dropdown] Single selected:", choice)
	end,
})

sec_selectors:dropdown({
	name = "multi dropdown",
	flag = "demo_multi_dropdown",
	items = {"Head", "Torso", "Left Arm", "Right Arm", "Legs"},
	default = {"Head", "Torso"},
	multi = true,
	callback = function(selected_list)
		print("[Dropdown] Multi selected:", table.concat(selected_list or {}, ", "))
	end,
})

sec_selectors:colorpicker({
	name = "accent color",
	flag = "demo_accent_color",
	color = Color3.fromRGB(110, 140, 255),
	alpha = 0.8,
	callback = function(col, alpha)
		print("[Colorpicker] Color:", col, "Alpha:", alpha)
	end,
})

sec_selectors:keybind({
	name = "action keybind",
	flag = "demo_action_key",
	key = Enum.KeyCode.F,
	mode = "toggle",
	callback = function(active)
		print("[Keybind] Action active:", active)
		library:update_keybind_visualizer()
	end,
})

-- =====================================================================
-- TAB 2: Visuals Selection & List System
-- =====================================================================
local selection_tab = window:tab({name = "selection & lists"})
local sel_col_left = selection_tab:column({})
local sel_col_center = selection_tab:column({})
local sel_col_right = selection_tab:column({})

-- Left: Subpage navigation & Selectable Item List
local selection_section = sel_col_left:section({name = "pages", size = 0.5, default = true})
library:create_visuals_selection(selection_section)

local list_section = sel_col_left:section({name = "item list", size = 0.5, default = true})
local item_list = list_section:list({
	name = "entities",
	flag = "demo_selected_item",
	items = {"Local Player", "Team Member", "Enemy Target", "VIP Bot"},
	size = 75,
	callback = function(chosen)
		print("[List] Chosen item:", chosen)
	end,
})

-- Register Multi-Subpages
local pages = {
	{id = "page_players", label = "players", center_label = "player esp", right_label = "player chams"},
	{id = "page_world", label = "world", center_label = "lighting & sky", right_label = "world objects"},
	{id = "page_misc", label = "misc", center_label = "crosshair", right_label = "fov circle"},
}

for _, page in ipairs(pages) do
	local page_data = library:create_visuals_page(sel_col_center, sel_col_right, page)

	page_data.center:toggle({
		name = "enable " .. page.label,
		default = page.id == "page_players",
	})
	page_data.center:slider({
		name = page.label .. " distance",
		min = 50,
		max = 1000,
		default = 250,
		suffix = "m",
	})

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

-- Default to first subpage
library:set_visuals_page("page_players")

-- =====================================================================
-- TAB 3: Keybind HUD Visualizer Controller
-- =====================================================================
local hud_tab = window:tab({name = "hud & binds"})
local hud_col_left = hud_tab:column({})
local hud_col_right = hud_tab:column({})

local hud_sec = hud_col_left:section({name = "keybind visualizer", size = 1, default = true})

hud_sec:toggle({
	name = "draggable keybind hud",
	flag = "keybind_draggable",
	default = false,
	callback = function(bool)
		if not bool and library.reset_keybind_position then
			library:reset_keybind_position()
		end
		library:update_keybind_visualizer()
	end,
})

local bind_sec = hud_col_right:section({name = "extra keybinds", size = 1, default = true})

bind_sec:keybind({
	name = "aimbot toggle",
	flag = "aimbot_key",
	key = Enum.KeyCode.LeftShift,
	mode = "hold",
	callback = function(active)
		print("[Keybind] Aimbot key:", active)
		library:update_keybind_visualizer()
	end,
})

bind_sec:keybind({
	name = "speedboost",
	flag = "speed_key",
	key = Enum.KeyCode.Z,
	mode = "toggle",
	callback = function(active)
		print("[Keybind] Speed key:", active)
		library:update_keybind_visualizer()
	end,
})

-- =====================================================================
-- 4. Initialize Built-In Config & Theme Manager
-- =====================================================================
library:init_config(window)

-- =====================================================================
-- 5. Open Window
-- =====================================================================
window.toggle_menu(true)

print("[priv9 Showcase] Example loaded and initialized successfully!")
