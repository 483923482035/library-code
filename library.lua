local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local ws = game:GetService("Workspace")
local rs = game:GetService("ReplicatedStorage")
local http_service = game:GetService("HttpService")
local gui_service = game:GetService("GuiService")
local run = game:GetService("RunService")
local stats = game:GetService("Stats")
local coregui = game:GetService("CoreGui")
local debris = game:GetService("Debris")
local tween_service = game:GetService("TweenService")

local vec2 = Vector2.new
local vec3 = Vector3.new
local dim2 = UDim2.new
local dim = UDim.new
local rect = Rect.new
local cfr = CFrame.new
local dim_offset = UDim2.fromOffset

local color = Color3.new
local rgb = Color3.fromRGB
local hex = Color3.fromHex
local hsv = Color3.fromHSV
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new
local numseq = NumberSequence.new
local numkey = NumberSequenceKeypoint.new

local clamp = math.clamp
local floor = math.floor
local insert = table.insert
local find = table.find
local remove = table.remove
local concat = table.concat

-- Tear down previous run of the UI library if already active
do
	local prev = getgenv().__ui_library
	if prev then
		prev.running = false
		for _, connection in next, (prev.connections or {}) do
			pcall(function() connection:Disconnect() end)
		end
		for _, instance in next, (prev.instances or {}) do
			pcall(function() instance:Destroy() end)
		end
		getgenv().__ui_library = nil
	end
end

local __ui_library = { connections = {}, instances = {}, running = true }
getgenv().__ui_library = __ui_library

local function track(connection)
	table.insert(__ui_library.connections, connection)
	return connection
end

local function track_instance(instance)
	table.insert(__ui_library.instances, instance)
	return instance
end

local camera = ws.CurrentCamera or ws:FindFirstChildOfClass("Camera")
if ws:GetPropertyChangedSignal("CurrentCamera") then
	ws:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		local new_camera = ws.CurrentCamera
		if new_camera then
			camera = new_camera
		end
	end)
end

local lp = players.LocalPlayer
local mouse = lp:GetMouse()
local gui_offset = gui_service:GetGuiInset().Y

local function mouse_in_frame(uiobject)
	local x_cond = uiobject.AbsolutePosition.X <= mouse.X and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X
	local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
	return (x_cond and y_cond)
end

getgenv().library = {
directory = "library_configs",
folders = {
"/fonts",
"/configs",
},
flags = {},
config_flags = {},

connections = {},
notifications = {},
playerlist_data = {
players = {},
player = {},
},
colorpicker_open = false;
gui;
}

local themes = {
preset = {
outline = rgb(10, 10, 10),
inline = rgb(35, 35, 35),
text = rgb(180, 180, 180),
text_outline = rgb(0, 0, 0),
background = rgb(20, 20, 20),
["1"] = hex("#245771"),
["2"] = hex("#215D63"),
["3"] = hex("#1E6453"),
},

utility = {
inline = {
BackgroundColor3 = {}
},
text = {
TextColor3 = {}
},
text_outline = {
Color = {},
TextStrokeColor3 = {},
TextColor3 = {}
},
["1"] = {
BackgroundColor3 = {},
TextColor3 = {},
ImageColor3 = {},
ScrollBarImageColor3 = {},
BorderColor3 = {},
},
["2"] = {
BackgroundColor3 = {},
TextColor3 = {},
ImageColor3 = {},
ScrollBarImageColor3 = {},
BorderColor3 = {},
},
["3"] = {
BackgroundColor3 = {},
TextColor3 = {},
ImageColor3 = {},
ScrollBarImageColor3 = {},
BorderColor3 = {},
},
}
}

local keys = {
[Enum.KeyCode.LeftShift] = "left shift",
[Enum.KeyCode.RightShift] = "right shift",
[Enum.KeyCode.LeftControl] = "left control",
[Enum.KeyCode.RightControl] = "right control",
[Enum.KeyCode.Insert] = "insert",
[Enum.KeyCode.Backspace] = "backspace",
[Enum.KeyCode.Return] = "enter",
[Enum.KeyCode.LeftAlt] = "left alt",
[Enum.KeyCode.RightAlt] = "right alt",
[Enum.KeyCode.CapsLock] = "caps lock",
[Enum.KeyCode.One] = "1",
[Enum.KeyCode.Two] = "2",
[Enum.KeyCode.Three] = "3",
[Enum.KeyCode.Four] = "4",
[Enum.KeyCode.Five] = "5",
[Enum.KeyCode.Six] = "6",
[Enum.KeyCode.Seven] = "7",
[Enum.KeyCode.Eight] = "8",
[Enum.KeyCode.Nine] = "9",
[Enum.KeyCode.Zero] = "0",
[Enum.KeyCode.KeypadOne] = "num1",
[Enum.KeyCode.KeypadTwo] = "num2",
[Enum.KeyCode.KeypadThree] = "num3",
[Enum.KeyCode.KeypadFour] = "num4",
[Enum.KeyCode.KeypadFive] = "num5",
[Enum.KeyCode.KeypadSix] = "num6",
[Enum.KeyCode.KeypadSeven] = "num7",
[Enum.KeyCode.KeypadEight] = "num8",
[Enum.KeyCode.KeypadNine] = "num9",
[Enum.KeyCode.KeypadZero] = "num0",
[Enum.KeyCode.Minus] = "-",
[Enum.KeyCode.Equals] = "=",
[Enum.KeyCode.Tilde] = "~",
[Enum.KeyCode.LeftBracket] = "[",
[Enum.KeyCode.RightBracket] = "]",
[Enum.KeyCode.RightParenthesis] = ")",
[Enum.KeyCode.LeftParenthesis] = "(",
[Enum.KeyCode.Semicolon] = ",",
[Enum.KeyCode.Quote] = "'",
[Enum.KeyCode.BackSlash] = "\\",
[Enum.KeyCode.Comma] = ",",
[Enum.KeyCode.Period] = ".",
[Enum.KeyCode.Slash] = "/",
[Enum.KeyCode.Asterisk] = "*",
[Enum.KeyCode.Plus] = "+",
[Enum.KeyCode.Period] = ".",
[Enum.KeyCode.Backquote] = "`",
[Enum.UserInputType.MouseButton1] = "mouse 1",
[Enum.UserInputType.MouseButton2] = "mouse 2",
[Enum.UserInputType.MouseButton3] = "mouse 3",
[Enum.KeyCode.Escape] = "escape",
[Enum.KeyCode.Space] = "space",
}

library.__index = library

for _, path in next, library.folders do
	local full_path = library.directory .. path
	pcall(function()
	if isfolder and not isfolder(full_path) then
		makefolder(full_path)
	elseif not isfolder then
		makefolder(full_path)
	end
end)
end

local flags = library.flags
local config_flags = library.config_flags
library.keybinds = {}

local fonts = {}; do
function Register_Font(Name, Weight, Style, Asset)
	if isfile(Asset.Id) then
		delfile(Asset.Id)
	end
	writefile(Asset.Id, Asset.Font)

	if isfile(Name .. ".font") then
		delfile(Name .. ".font")
	end

	local Data = {
	name = Name,
	faces = {
	{
	name = "Regular",
	weight = Weight,
	style = Style,
	assetId = getcustomasset(Asset.Id),
	},
	},
	}

	writefile(Name .. ".font", game:GetService("HttpService"):JSONEncode(Data))

	return getcustomasset(Name .. ".font");
end

local ProggyTiny = Register_Font("Tahoma", 200, "Normal", {
Id = "Tahoma.ttf",
Font = game:HttpGet("https://github.com/483923482035/library-code/raw/refs/heads/main/fonts/tahomabold.ttf"),
})

local Tahoma11Bold = Register_Font("Tahoma11PixelBold", 700, "Normal", {
Id = "Tahoma11PixelBold.ttf",
Font = game:HttpGet("https://github.com/483923482035/library-code/raw/refs/heads/main/fonts/Tahoma11PixelBold.ttf")
})

local Tahoma11 = Register_Font("Tahoma11Pixel", 400, "normal", {
Id = "Tahoma11Pixel.ttf",
Font = game:HttpGet("https://github.com/483923482035/library-code/raw/refs/heads/main/fonts/Tahoma11Pixel.ttf")
})

-- NOTE: Tahoma 12 Pixel is designed to use TextSize = 13
local Tahoma12 = Register_Font("Tahoma12Pixel", 400, "normal", {
Id = "Tahoma12Pixel.ttf",
Font = game:HttpGet("https://github.com/483923482035/library-code/raw/refs/heads/main/fonts/Tahoma12Pixel.ttf")
})

local Tahoma12Bold = Register_Font("Tahoma12PixelBold", 700, "Normal", {
Id = "Tahoma12PixelBold.ttf",
Font = game:HttpGet("https://github.com/483923482035/library-code/raw/refs/heads/main/fonts/Tahoma12PixelBold.ttf")
})

local SmallestPixel = Register_Font("SmallestPixel", 400, "Normal", {
Id = "SmallestPixel.ttf",
Font = game:HttpGet("https://github.com/483923482035/library-code/raw/refs/heads/main/fonts/smallest_pixel-7.ttf"),
})

fonts = {
["TahomaBold"] = Font.new(ProggyTiny, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
["Tahoma11Pixel"] = Font.new(Tahoma11, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
["Tahoma11PixelBold"] = Font.new(Tahoma11Bold, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
["Tahoma12Pixel"] = Font.new(Tahoma12, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
["Tahoma12PixelBold"] = Font.new(Tahoma12Bold, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
["ProggyClean"] = Font.new(Tahoma12, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
["SmallestPixel"] = Font.new(SmallestPixel, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
}
end

function library:tween(obj, properties)
	local tween = tween_service:Create(obj, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()

	return tween
end

function library:close_current_element(cfg)
	local path = library.current_element_open

	if path then
		if path.close then
			path.close()
		else
			path.set_visible(false)
			path.open = false
		end
	end

	library.current_element_open = nil
end

function library:resizify(frame)
	local Frame = Instance.new("TextButton")
	Frame.Position = dim2(1, -10, 1, -10)
	Frame.BorderColor3 = rgb(0, 0, 0)
	Frame.Size = dim2(0, 10, 0, 10)
	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = rgb(255, 255, 255)
	Frame.Parent = frame
	Frame.BackgroundTransparency = 1
	Frame.Text = ""

	local resizing = false
	local start_size
	local start
	local og_size = frame.Size

	Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = true
		start = input.Position
		start_size = frame.Size
	end
end)

Frame.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
	resizing = false
end
end)

library:connection(uis.InputChanged, function(input, game_event)
if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
	local viewport_x = camera.ViewportSize.X
	local viewport_y = camera.ViewportSize.Y

	local current_size = dim2(
	start_size.X.Scale,
	math.clamp(
	start_size.X.Offset + (input.Position.X - start.X),
	og_size.X.Offset,
	viewport_x
	),
	start_size.Y.Scale,
	math.clamp(
	start_size.Y.Offset + (input.Position.Y - start.Y),
	og_size.Y.Offset,
	viewport_y
	)
	)
	frame.Size = current_size
end
end)
end

function library:mouse_in_frame(uiobject)
	local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
	local x_cond = uiobject.AbsolutePosition.X <= mouse.X and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

	return (y_cond and x_cond)
end

library.lerp = function(start, finish, t)
t = t or 1 / 8

return start * (1 - t) + finish * t
end

function library:draggify(frame)
	local dragging = false
	local start_size = frame.Position
	local start

	frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		start = input.Position
		start_size = frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
	dragging = false
end
end)

library:connection(uis.InputChanged, function(input, game_event)
if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
	local viewport_x = camera.ViewportSize.X
	local viewport_y = camera.ViewportSize.Y

	local current_position = dim2(
	0,
	clamp(
	start_size.X.Offset + (input.Position.X - start.X),
	0,
	viewport_x - frame.Size.X.Offset
	),
	0,
	math.clamp(
	start_size.Y.Offset + (input.Position.Y - start.Y),
	0,
	viewport_y - frame.Size.Y.Offset
	)
	)

	frame.Position = current_position
end
end)
end

function library:convert(str)
	local values = {}

	for value in string.gmatch(str, "[^,]+") do
		insert(values, tonumber(value))
	end

	if #values == 4 then
		return unpack(values)
	else
		return
	end
end

function library:convert_enum(enum)
	local enum_parts = {}

	for part in string.gmatch(enum, "[%w_]+") do
		insert(enum_parts, part)
	end

	local enum_table = Enum
	for i = 2, #enum_parts do
		local enum_item = enum_table[enum_parts[i]]

		enum_table = enum_item
	end

	return enum_table
end

local config_holder;
function library:update_config_list()
	if not config_holder then
		return
	end

	local list = {}

	for idx, file in listfiles(library.directory .. "/configs") do
		local name = file:gsub(library.directory .. "/configs\\", ""):gsub(".cfg", ""):gsub(library.directory .. "\\configs\\", "")
		list[#list + 1] = name
	end

	config_holder.refresh_options(list)
end

function library:get_config()
	local Config = {}

	for _, v in flags do
		if type(v) == "table" and v.key then
			Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
		elseif type(v) == "table" and v["Transparency"] and v["Color"] then
			Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
		else
			Config[_] = v
		end
	end

	return http_service:JSONEncode(Config)
end

function library:load_config(config_json)
	local config = http_service:JSONDecode(config_json)

	for _, v in next, config do
		local function_set = library.config_flags[_]

		if _ == "config_name_list" then
			continue
		end

		if function_set then
			if type(v) == "table" and v["Transparency"] and v["Color"] then
				function_set(hex(v["Color"]), v["Transparency"])
			elseif type(v) == "table" and v["active"] then
				function_set(v)
			else
				function_set(v)
			end
		end
	end
end

function library:round(number, float)
	local multiplier = 1 / (float or 1)

	return floor(number * multiplier + 0.5) / multiplier
end

function library:apply_theme(instance, theme, property)
	insert(themes.utility[theme][property], instance)
end

function library:update_theme(theme, color)
	for propertyName, objects in next, themes.utility[theme] do
		for _, object in next, objects do
			if object:GetAttribute("PrivToggleState") == false and propertyName == "BackgroundColor3" then

				object[propertyName] = themes.preset.inline
			else
				object[propertyName] = color
			end
		end
	end

	themes.preset[theme] = color
end

function library:create_visuals_selection_box(selection_section)
	local selection_box = library:create("Frame", {
	Parent = selection_section.elements;
	BorderColor3 = themes.preset[tostring(selection_section.count)];
	BorderSizePixel = 1;
	BackgroundColor3 = rgb(35, 35, 35);
	Size = dim2(1, 0, 0, 0);
	AutomaticSize = Enum.AutomaticSize.Y;
	})
	library:apply_theme(selection_box, tostring(selection_section.count), "BorderColor3")

	library:create("UIPadding", {
	Parent = selection_box;
	PaddingTop = dim(0, 4);
	PaddingBottom = dim(0, 4);
	PaddingLeft = dim(0, 6);
	PaddingRight = dim(0, 6);
	})

	library:create("UIListLayout", {
	Parent = selection_box;
	Padding = dim(0, 2);
	SortOrder = Enum.SortOrder.LayoutOrder;
	})

	return selection_box
end

function library:create_visuals_page(visuals_center, visuals_right, page)
	for _, col in ipairs({visuals_center, visuals_right}) do
		if col and not col._visuals_autohide then
			col._visuals_autohide = true
			col.section = function(self, properties, ...)
			local result = library.section(self, properties, ...)
			if type(result) == "table" and result.frame then
				result.frame.Visible = false
			end
			return result
		end
	end
end

local center_name = page.center_label or page.label
local right_name = page.right_label or (page.label .. " options")

local auto_fill = page.auto_fill ~= false

local center_section = visuals_center:section({name = center_name, auto_fill = auto_fill, size = 1})
local right_section = visuals_right:section({name = right_name, auto_fill = auto_fill, size = 1})

return {
center = center_section,
right = right_section,
}
end

library.visuals_registry = library.visuals_registry or { pages = {}, selection_box = nil }

function library:create_visuals_selection(selection_section)
	local selection_inner = library:create_visuals_selection_box(selection_section)
	library.visuals_registry.selection_box = selection_inner
	return selection_inner
end

function library:create_visuals_placeholder(column, name)
	local placeholder = column:section({name = name or "placeholder", auto_fill = false, size = 1})
	placeholder.frame.Visible = false
	return placeholder
end

function library:register_visuals_page(id, label, center_section, right_section)
	library.visuals_registry.pages[id] = library.visuals_registry.pages[id] or {}
	local entry = library.visuals_registry.pages[id]
	entry.label = label
	entry.center = center_section
	entry.right = right_section

	local sel = library.visuals_registry.selection_box
	if sel and not entry.button then
		local btn = library:create("TextButton", {
		FontFace = fonts["Tahoma12Pixel"];
		TextColor3 = rgb(170, 170, 170);
		BorderColor3 = rgb(0, 0, 0);
		Text = label;
		Parent = sel;
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Size = dim2(1, 0, 0, 13);
		AutomaticSize = Enum.AutomaticSize.None;
		TextSize = 13;
		TextXAlignment = Enum.TextXAlignment.Left;
		TextYAlignment = Enum.TextYAlignment.Center;
		BackgroundColor3 = rgb(255, 255, 255)
		}); btn:SetAttribute("TextYOffset", -5)

		entry.button = btn

		btn.MouseButton1Click:Connect(function()
		library:set_visuals_page(id)
	end)
end

return entry
end

function library:get_visuals_page(id)
	library.visuals_registry = library.visuals_registry or { pages = {}, selection_box = nil }
	return library.visuals_registry.pages[id]
end

function library:set_visuals_page(id)
	library.visuals_registry = library.visuals_registry or { pages = {}, selection_box = nil }
	local function set_visible(obj, visible)
	if not obj then return end

	if type(obj) == "table" and obj.frame then
		obj.frame.Visible = visible
		return
	end

	if type(obj) == "table" then
		for _, v in next, obj do
			if v and v.frame then
				v.frame.Visible = visible
			end
		end
	end
end

for page_id, page_data in next, library.visuals_registry.pages do
	local selected = page_id == id

	set_visible(page_data.center, selected)
	set_visible(page_data.right, selected)

	if page_data.button then
		page_data.button.TextColor3 = selected and rgb(255, 255, 255) or rgb(170, 170, 170)
	end
end
end

function library:connection(signal, callback)
	local connection = signal:Connect(callback)

	insert(library.connections, connection)
	track(connection)

	return connection
end

local shadow_offsets = {
	Vector2.new(-1, 0),
	Vector2.new(1, 0),
	Vector2.new(0, -1),
	Vector2.new(0, 1),
}

local function normalize_richtext(str)
	if not str then return "" end
	return str:gsub("<font%s+color%s*=%s*['\"]?([^'\"%s>]+)['\"]?>", '<font color="%1">')
end

local function make_shadow_text(t, rich)
	if not t then return "" end
	if rich then
		return t:gsub("</?font[^>]*>", "")
	end
	return t
end

function library:apply_stroke(parent)
	if not parent then return end

	local parent_container = parent.Parent
	local is_in_list = parent:IsA("TextButton") or (parent_container and parent_container:FindFirstChildWhichIsA("UIListLayout") ~= nil)

	local shadows = {}

	if is_in_list then
		parent.TextTransparency = 1

		if parent.RichText then
			local norm = normalize_richtext(parent.Text)
			if norm ~= parent.Text then
				parent.Text = norm
			end
		end

		local auto_mode = parent.AutomaticSize
		if auto_mode ~= Enum.AutomaticSize.None then
			parent.AutomaticSize = Enum.AutomaticSize.None
		end

		local function update_parent_size()
			if auto_mode == Enum.AutomaticSize.None then return end
			local tw = parent.TextBounds.X
			local th = parent.TextBounds.Y
			if th <= 0 then
				th = parent.TextSize or 13
			end
			if tw <= 0 and parent.Text and parent.Text ~= "" then
				tw = math.ceil(#parent.Text * (parent.TextSize or 13) * 0.6)
			end

			local sx = parent.Size.X.Scale
			local ox = parent.Size.X.Offset
			local sy = parent.Size.Y.Scale
			local oy = parent.Size.Y.Offset

			if auto_mode == Enum.AutomaticSize.Y or auto_mode == Enum.AutomaticSize.XY then
				if sy == 0 then
					oy = th
				end
			end
			if auto_mode == Enum.AutomaticSize.X or auto_mode == Enum.AutomaticSize.XY then
				if sx == 0 then
					ox = tw
				end
			end

			parent.Size = UDim2.new(sx, ox, sy, oy)
		end

		update_parent_size()

		local shadow_t = make_shadow_text(parent.Text, parent.RichText)
		local y_off = parent:GetAttribute("TextYOffset") or 0

		for _, off in ipairs(shadow_offsets) do
			local shadow = Instance.new("TextLabel")
			shadow.Name = "Shadow"
			shadow.BackgroundTransparency = 1
			shadow.BorderSizePixel = 0
			shadow.Size = UDim2.new(1, 0, 1, 0)
			shadow.Position = UDim2.new(0, off.X, 0, off.Y + y_off)
			shadow.ZIndex = 1
			shadow.Active = false
			shadow.Selectable = false
			shadow.TextColor3 = themes.preset.text_outline
			shadow.FontFace = parent.FontFace
			shadow.TextSize = parent.TextSize
			shadow.RichText = parent.RichText
			shadow.Text = shadow_t
			shadow.TextXAlignment = parent.TextXAlignment
			shadow.TextYAlignment = parent.TextYAlignment
			shadow.AutomaticSize = Enum.AutomaticSize.None
			shadow.Visible = parent.Visible
			shadow.Parent = parent

			library:apply_theme(shadow, "text_outline", "TextColor3")
			insert(shadows, shadow)
		end

		local fg = Instance.new("TextLabel")
		fg.Name = "Text"
		fg.BackgroundTransparency = 1
		fg.BorderSizePixel = 0
		fg.Size = UDim2.new(1, 0, 1, 0)
		fg.Position = UDim2.new(0, 0, 0, y_off)
		fg.ZIndex = 2
		fg.Active = false
		fg.Selectable = false
		fg.TextColor3 = parent.TextColor3
		fg.FontFace = parent.FontFace
		fg.TextSize = parent.TextSize
		fg.RichText = parent.RichText
		fg.Text = parent.Text
		fg.TextXAlignment = parent.TextXAlignment
		fg.TextYAlignment = parent.TextYAlignment
		fg.AutomaticSize = Enum.AutomaticSize.None
		fg.Visible = parent.Visible
		fg.Parent = parent

		local function sync_text()
			local t = parent.Text
			if parent.RichText then
				local norm = normalize_richtext(t)
				if norm ~= t then
					parent.Text = norm
					return
				end
				t = norm
			end
			update_parent_size()
			fg.Text = t
			local st = make_shadow_text(t, parent.RichText)
			for _, s in ipairs(shadows) do s.Text = st end
		end
		local function sync_richtext()
			local rt = parent.RichText
			fg.RichText = rt
			local t = parent.Text
			if rt then
				local norm = normalize_richtext(t)
				if norm ~= t then
					parent.Text = norm
					return
				end
				t = norm
			end
			local st = make_shadow_text(t, rt)
			for _, s in ipairs(shadows) do
				s.RichText = rt
				s.Text = st
			end
		end
		local function sync_color()
			fg.TextColor3 = parent.TextColor3
		end
		local function sync_font()
			local f = parent.FontFace
			update_parent_size()
			fg.FontFace = f
			for _, s in ipairs(shadows) do s.FontFace = f end
		end
		local function sync_textsize()
			local ts = parent.TextSize
			update_parent_size()
			fg.TextSize = ts
			for _, s in ipairs(shadows) do s.TextSize = ts end
		end
		local function sync_visible()
			local v = parent.Visible
			fg.Visible = v
			for _, s in ipairs(shadows) do s.Visible = v end
		end
		local function sync_align()
			local xa, ya = parent.TextXAlignment, parent.TextYAlignment
			fg.TextXAlignment, fg.TextYAlignment = xa, ya
			for _, s in ipairs(shadows) do s.TextXAlignment, s.TextYAlignment = xa, ya end
		end
		local function sync_offset()
			local yo = parent:GetAttribute("TextYOffset") or 0
			fg.Position = UDim2.new(0, 0, 0, yo)
			for i, s in ipairs(shadows) do
				local off = shadow_offsets[i]
				s.Position = UDim2.new(0, off.X, 0, off.Y + yo)
			end
		end

		parent:GetPropertyChangedSignal("Text"):Connect(sync_text)
		parent:GetPropertyChangedSignal("RichText"):Connect(sync_richtext)
		parent:GetPropertyChangedSignal("TextColor3"):Connect(sync_color)
		parent:GetPropertyChangedSignal("FontFace"):Connect(sync_font)
		parent:GetPropertyChangedSignal("TextSize"):Connect(sync_textsize)
		parent:GetPropertyChangedSignal("Visible"):Connect(sync_visible)
		parent:GetPropertyChangedSignal("TextXAlignment"):Connect(sync_align)
		parent:GetPropertyChangedSignal("TextYAlignment"):Connect(sync_align)
		parent:GetAttributeChangedSignal("TextYOffset"):Connect(sync_offset)
	else
		local base_z = parent.ZIndex or 1
		parent.ZIndex = base_z + 1

		if parent.RichText then
			local norm = normalize_richtext(parent.Text)
			if norm ~= parent.Text then
				parent.Text = norm
			end
		end

		local function make_pos(off)
			local pos = parent.Position
			return UDim2.new(pos.X.Scale, pos.X.Offset + off.X, pos.Y.Scale, pos.Y.Offset + off.Y)
		end

		local shadow_t = make_shadow_text(parent.Text, parent.RichText)

		for _, off in ipairs(shadow_offsets) do
			local shadow = Instance.new("TextLabel")
			shadow.Name = "Shadow"
			shadow.BackgroundTransparency = 1
			shadow.BorderSizePixel = 0
			shadow.Size = parent.Size
			shadow.Position = make_pos(off)
			shadow.ZIndex = base_z
			shadow.Active = false
			shadow.Selectable = false
			shadow.TextColor3 = themes.preset.text_outline
			shadow.FontFace = parent.FontFace
			shadow.TextSize = parent.TextSize
			shadow.RichText = parent.RichText
			shadow.Text = shadow_t
			shadow.TextXAlignment = parent.TextXAlignment
			shadow.TextYAlignment = parent.TextYAlignment
			shadow.AutomaticSize = parent.AutomaticSize
			shadow.Visible = parent.Visible
			shadow.Parent = parent.Parent

			library:apply_theme(shadow, "text_outline", "TextColor3")
			insert(shadows, shadow)
		end

		local function sync_parent()
			local p = parent.Parent
			for _, s in ipairs(shadows) do s.Parent = p end
		end
		local function sync_pos()
			for i, s in ipairs(shadows) do
				s.Position = make_pos(shadow_offsets[i])
			end
		end
		local function sync_size()
			local sz = parent.Size
			for _, s in ipairs(shadows) do s.Size = sz end
		end
		local function sync_auto_size()
			local asz = parent.AutomaticSize
			for _, s in ipairs(shadows) do s.AutomaticSize = asz end
		end
		local function sync_text()
			local t = parent.Text
			if parent.RichText then
				local norm = normalize_richtext(t)
				if norm ~= t then
					parent.Text = norm
					return
				end
				t = norm
			end
			local st = make_shadow_text(t, parent.RichText)
			for _, s in ipairs(shadows) do s.Text = st end
		end
		local function sync_richtext()
			local rt = parent.RichText
			local t = parent.Text
			if rt then
				local norm = normalize_richtext(t)
				if norm ~= t then
					parent.Text = norm
					return
				end
				t = norm
			end
			local st = make_shadow_text(t, rt)
			for _, s in ipairs(shadows) do
				s.RichText = rt
				s.Text = st
			end
		end
		local function sync_font()
			local f = parent.FontFace
			for _, s in ipairs(shadows) do s.FontFace = f end
		end
		local function sync_textsize()
			local ts = parent.TextSize
			for _, s in ipairs(shadows) do s.TextSize = ts end
		end
		local function sync_visible()
			local v = parent.Visible
			for _, s in ipairs(shadows) do s.Visible = v end
		end
		local function sync_transparency()
			local tr = parent.TextTransparency
			for _, s in ipairs(shadows) do s.TextTransparency = tr end
		end
		local function sync_zindex()
			local z = parent.ZIndex
			for _, s in ipairs(shadows) do s.ZIndex = math.max(1, z - 1) end
		end
		local function sync_align()
			local xa, ya = parent.TextXAlignment, parent.TextYAlignment
			for _, s in ipairs(shadows) do s.TextXAlignment, s.TextYAlignment = xa, ya end
		end

		parent:GetPropertyChangedSignal("Parent"):Connect(sync_parent)
		parent:GetPropertyChangedSignal("Position"):Connect(sync_pos)
		parent:GetPropertyChangedSignal("Size"):Connect(sync_size)
		parent:GetPropertyChangedSignal("AutomaticSize"):Connect(sync_auto_size)
		parent:GetPropertyChangedSignal("Text"):Connect(sync_text)
		parent:GetPropertyChangedSignal("RichText"):Connect(sync_richtext)
		parent:GetPropertyChangedSignal("FontFace"):Connect(sync_font)
		parent:GetPropertyChangedSignal("TextSize"):Connect(sync_textsize)
		parent:GetPropertyChangedSignal("Visible"):Connect(sync_visible)
		parent:GetPropertyChangedSignal("TextTransparency"):Connect(sync_transparency)
		parent:GetPropertyChangedSignal("ZIndex"):Connect(sync_zindex)
		parent:GetPropertyChangedSignal("TextXAlignment"):Connect(sync_align)
		parent:GetPropertyChangedSignal("TextYAlignment"):Connect(sync_align)

		parent.Destroying:Connect(function()
			for _, s in ipairs(shadows) do s:Destroy() end
		end)
	end
end

function library:create(instance, options)
	local ins = Instance.new(instance)

	for prop, value in next, options do
		ins[prop] = value
	end

	if instance == "TextLabel" or instance == "TextButton" or instance == "TextBox" then
		library:apply_theme(ins, "text", "TextColor3")
		if instance == "TextLabel" or (options and options.Text and options.Text ~= "") then
			library:apply_stroke(ins)
		end
	end

	return ins
end

function library:update_keybind_visualizer()
	local container = self.active_keybind_container
	if not container then
		return
	end

	local actives = {}
	for _, cfg in ipairs(self.keybinds or {}) do
		if cfg.active and not cfg.ignore_key and cfg.flag ~= "menu_key" then
			insert(actives, cfg)
		end
	end

	for _, label in ipairs(self.active_keybind_labels or {}) do
		label:Destroy()
	end
	self.active_keybind_labels = {}

	local is_menu_open = (library.main_outline and library.main_outline.Visible) or (window and window.main_outline and window.main_outline.Visible)
	local show_preview = (#actives == 0) and (flags["keybind_draggable"] == true) and is_menu_open

	if #actives == 0 and not show_preview then
		container.Visible = false
		return
	end

	container.Visible = true

	if show_preview then
		local label = library:create("TextLabel", {
		Parent = container;
		Text = "keybinds [drag]";
		FontFace = fonts["Tahoma12Pixel"];
		TextColor3 = hex("#8AD4BF");
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		AutomaticSize = Enum.AutomaticSize.XY;
		TextSize = 13;
		TextXAlignment = Enum.TextXAlignment.Center;
		TextYAlignment = Enum.TextYAlignment.Center;
		})
		label.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if library.start_keybind_drag then
					library.start_keybind_drag(input)
				end
			end
		end)
		insert(self.active_keybind_labels, label)
		return
	end

	for _, cfg in ipairs(actives) do
		local label = library:create("TextLabel", {
		Parent = container;
		Text = "";
		FontFace = fonts["Tahoma12Pixel"];
		TextColor3 = (cfg.visualize_toggle and not flags[cfg.visualize_toggle]) and hex("#757e8a") or hex("#8AD4BF");
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		AutomaticSize = Enum.AutomaticSize.XY;
		TextSize = 13;
		TextXAlignment = Enum.TextXAlignment.Center;
		TextYAlignment = Enum.TextYAlignment.Center;
		})

		label.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if library.start_keybind_drag then
					library.start_keybind_drag(input)
				end
			end
		end)

		local name = string.lower(tostring(cfg.name or cfg.flag or "keybind"))
		local mode = string.upper(tostring(cfg.mode or ""))
		label.Text = string.format("%s [%s]", name, mode)
		insert(self.active_keybind_labels, label)
	end
end

function library:unload_menu()
	if library.gui then
		library.gui:Destroy()
	end

	for index, connection in next, library.connections do
		connection:Disconnect()
		connection = nil
	end

	if library.sgui then
		library.sgui:Destroy()
	end

	library = nil
end

function library:window(properties)
	local cfg = {
	name = properties.name or properties.Name or "priv9.net | roblox [internal]",
	size = properties.size or properties.Size or dim2(0, 465, 0, 350),
	selected_tab = nil,
	tabs = {}
	}

	library.gui = track_instance(library:create("ScreenGui", {
	Parent = coregui,
	Name = "\0",
	Enabled = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	IgnoreGuiInset = true,
	DisplayOrder = 2147483647,
	}))

	local window_outline = library:create("Frame", {
	Parent = library.gui;
	Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2);
	BorderColor3 = rgb(0, 0, 0);
	Size = cfg.size;
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	});
	window_outline.Position = dim2(0, window_outline.AbsolutePosition.Y, 0, window_outline.AbsolutePosition.Y)
	cfg.main_outline = window_outline
	library.main_outline = window_outline
	library.main_window = cfg

	library:resizify(window_outline)
	library:draggify(window_outline)

	local title_holder = library:create("Frame", {
	Parent = window_outline;
	BackgroundTransparency = 0.800000011920929;
	Position = dim2(0, 2, 0, 2);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -4, 0, 20);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(0, 0, 0)
	});

	local ui_title = library:create("TextLabel", {
	FontFace = fonts["Tahoma12PixelBold"];
	TextColor3 = rgb(255, 255, 255);
	BorderColor3 = rgb(0, 0, 0);
	Text = cfg.name;
	Parent = title_holder;
	BackgroundTransparency = 1;
	Size = dim2(1, 0, 1, 0);
	BorderSizePixel = 0;
	TextSize = 13;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	library.gradient = library:create("UIGradient", {
	Color = rgbseq{
	rgbkey(0, themes.preset["1"]),
	rgbkey(0.5, themes.preset["2"]),
	rgbkey(1, themes.preset["3"]),
	};
	Parent = window_outline
	});

	local tab_button_holder = library:create("Frame", {
	AnchorPoint = vec2(0, 1);
	Parent = window_outline;
	BackgroundTransparency = 0.800000011920929;
	Position = dim2(0, 2, 1, -2);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -4, 0, 20);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(0, 0, 0)
	}); cfg.tab_button_holder = tab_button_holder

	library:create("UIListLayout", {
	VerticalAlignment = Enum.VerticalAlignment.Center;
	FillDirection = Enum.FillDirection.Horizontal;
	HorizontalAlignment = Enum.HorizontalAlignment.Center;
	HorizontalFlex = Enum.UIFlexAlignment.Fill;
	Parent = tab_button_holder;
	SortOrder = Enum.SortOrder.LayoutOrder;
	VerticalFlex = Enum.UIFlexAlignment.Fill
	});

	function cfg.toggle_menu(bool)
		window_outline.Visible = bool
		if not bool then
			library:close_current_element()
		end
		if library.update_keybind_visualizer then
			library:update_keybind_visualizer()
		end
	end

	return setmetatable(cfg, library)
end

function library:tab(properties)
	local cfg = {
	name = properties.name or "visuals",
	count = 0,
	columns = {},
	dropdowns = {},
	}
	cfg.tab = cfg

	self.tabs = self.tabs or {}
	insert(self.tabs, cfg)

	local tab_button = library:create("TextButton", {
	FontFace = fonts["Tahoma12Pixel"];
	TextColor3 = rgb(170, 170, 170);
	BorderColor3 = rgb(0, 0, 0);
	Text = cfg.name;
	Parent = self.tab_button_holder;
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	AutomaticSize = Enum.AutomaticSize.XY;
	TextSize = 13;
	BackgroundColor3 = rgb(255, 255, 255)
	}); tab_button:SetAttribute("TextYOffset", -1)

	local Page = library:create("Frame", {
	Parent = self.main_outline;
	BackgroundTransparency = 0.6;
	Position = dim2(0, 2, 0, 24);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -4, 1, -48);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(0, 0, 0),
	Visible = false,
	}); cfg.page = Page

	library:create("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal;
	HorizontalFlex = Enum.UIFlexAlignment.Fill;
	Parent = Page;
	Padding = dim(0, 2);
	SortOrder = Enum.SortOrder.LayoutOrder;
	VerticalFlex = Enum.UIFlexAlignment.Fill
	});

	library:create("UIPadding", {
	PaddingTop = dim(0, 2);
	PaddingBottom = dim(0, 2);
	Parent = Page;
	PaddingRight = dim(0, 2);
	PaddingLeft = dim(0, 2)
	});

	function cfg.open_tab()
		local selected_tab = self.selected_tab

		if selected_tab then
			selected_tab[1].Visible = false
			selected_tab[2].TextColor3 = rgb(170, 170, 170)

			selected_tab = nil
		end

		Page.Visible = true
		tab_button.TextColor3 = rgb(255, 255, 255)

		self.selected_tab = {Page, tab_button}
	end

	tab_button.MouseButton1Down:Connect(function()
	cfg.open_tab()
end)

if not self.selected_tab then
	cfg.open_tab(true)
end

return setmetatable(cfg, library)
end

local notifications = {notifs = {}}

library.sgui = track_instance(library:create("ScreenGui", {
Name = "Hi",
Parent = gethui();
IgnoreGuiInset = false;
DisplayOrder = 2147483646;
}))

library.active_keybind_container = library:create("Frame", {
Parent = library.sgui;
AnchorPoint = vec2(0.5, 0);
Position = dim2(0.5, 0, 0.5, 30);
BackgroundTransparency = 1;
BorderSizePixel = 0;
AutomaticSize = Enum.AutomaticSize.XY;
Active = true;
Visible = false;
})
library.active_keybind_base_pos = dim2(0.5, 0, 0.5, 30)
library.active_keybind_labels = {}

library:create("UIListLayout", {
Parent = library.active_keybind_container;
Padding = dim(0, 4);
SortOrder = Enum.SortOrder.LayoutOrder;
HorizontalAlignment = Enum.HorizontalAlignment.Center;
})

local function is_priv9_menu_open()
	return (library.main_outline and library.main_outline.Visible) or (window and window.main_outline and window.main_outline.Visible)
end

local keybind_dragging = false
local drag_start_mouse = nil
local drag_start_pos = nil
local drag_start_abs = nil

function library.start_keybind_drag(input)
	if not (is_priv9_menu_open() and flags["keybind_draggable"]) then
		return
	end
	local container = library.active_keybind_container
	if not container then return end
	keybind_dragging = true
	drag_start_mouse = input.Position
	drag_start_pos = container.Position
	drag_start_abs = container.AbsolutePosition
end

library.active_keybind_container.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		library.start_keybind_drag(input)
	end
end)

library:connection(uis.InputChanged, function(input)
	if keybind_dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local container = library.active_keybind_container
		if not (container and is_priv9_menu_open() and flags["keybind_draggable"]) then
			keybind_dragging = false
			return
		end

		local delta_x = input.Position.X - drag_start_mouse.X
		local delta_y = input.Position.Y - drag_start_mouse.Y

		local cam = workspace.CurrentCamera
		local vp_x = (cam and cam.ViewportSize and cam.ViewportSize.X > 0) and cam.ViewportSize.X or 1920
		local vp_y = (cam and cam.ViewportSize and cam.ViewportSize.Y > 0) and cam.ViewportSize.Y or 1080

		local w = (container.AbsoluteSize and container.AbsoluteSize.X > 0) and container.AbsoluteSize.X or 50
		local h = (container.AbsoluteSize and container.AbsoluteSize.Y > 0) and container.AbsoluteSize.Y or 20

		local target_abs_x = clamp(drag_start_abs.X + delta_x, 0, math.max(0, vp_x - w))
		local target_abs_y = clamp(drag_start_abs.Y + delta_y, 0, math.max(0, vp_y - h))

		local actual_delta_x = target_abs_x - drag_start_abs.X
		local actual_delta_y = target_abs_y - drag_start_abs.Y

		container.Position = dim2(
			drag_start_pos.X.Scale,
			drag_start_pos.X.Offset + actual_delta_x,
			drag_start_pos.Y.Scale,
			drag_start_pos.Y.Offset + actual_delta_y
		)
	end
end)

library:connection(uis.InputEnded, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		keybind_dragging = false
	end
end)

function library:reset_keybind_position()
	local self_obj = (type(self) == "table" and self.active_keybind_container) and self or library
	local container = self_obj.active_keybind_container
	if not container then
		return
	end
	local base = self_obj.active_keybind_base_pos or dim2(0.5, 0, 0.5, 30)
	container.Position = base
end

function library:update_keybind_offset()
	local self_obj = (type(self) == "table" and self.active_keybind_container) and self or library
	local container = self_obj.active_keybind_container
	if not container then
		return
	end
	local base = self_obj.active_keybind_base_pos or dim2(0.5, 0, 0.5, 30)
	local ox = flags["keybind_offset_x"] or 0
	local oy = flags["keybind_offset_y"] or 0

	local cam = workspace.CurrentCamera
	if cam and cam.ViewportSize and cam.ViewportSize.X > 0 and cam.ViewportSize.Y > 0 then
		local vp = cam.ViewportSize
		local base_pixel_x = base.X.Scale * vp.X + base.X.Offset
		local base_pixel_y = base.Y.Scale * vp.Y + base.Y.Offset

		local half_w = (container.AbsoluteSize and container.AbsoluteSize.X > 0) and (container.AbsoluteSize.X / 2) or 50
		local h = (container.AbsoluteSize and container.AbsoluteSize.Y > 0) and container.AbsoluteSize.Y or 20

		local min_ox = 20 + half_w - base_pixel_x
		local max_ox = (vp.X - 20 - half_w) - base_pixel_x
		local min_oy = 20 - base_pixel_y
		local max_oy = (vp.Y - 20 - h) - base_pixel_y

		ox = clamp(ox, min_ox, max_ox)
		oy = clamp(oy, min_oy, max_oy)
	end

	container.Position = dim2(base.X.Scale, base.X.Offset + ox, base.Y.Scale, base.Y.Offset + oy)
end

function notifications:refresh_notifs()
	local wm = library.watermark_outline
	local baseX = (wm and wm.AbsolutePosition and wm.AbsolutePosition.X) and wm.AbsolutePosition.X or 18
	local baseY = (wm and wm.AbsolutePosition and wm.AbsolutePosition.Y) and wm.AbsolutePosition.Y or 0

	local idxs = {}
	for k in pairs(notifications.notifs) do
		if type(k) == "number" then
			insert(idxs, k)
		end
	end

	table.sort(idxs)

	local gap = 30
	local wmHeight = (wm and wm.AbsoluteSize and wm.AbsoluteSize.Y) and wm.AbsoluteSize.Y or 24
	for order, key in ipairs(idxs) do
		local v = notifications.notifs[key]
		if v then
			local targetY = baseY + wmHeight + (order * gap)
			tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = dim_offset(baseX, targetY)}):Play()
		end
	end
end

function notifications:fade(path, is_fading)
	local fading = is_fading and 1 or 0

	tween_service:Create(path, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = fading}):Play()

	for _, instance in path:GetDescendants() do
		if not instance:IsA("GuiObject") then
			if instance:IsA("UIStroke") then
				tween_service:Create(instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = fading}):Play()
			end

			continue
		end

		if instance:IsA("TextLabel") then
			tween_service:Create(instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = fading}):Play()
		elseif instance:IsA("Frame") then
			tween_service:Create(instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = instance.Transparency and 0.6 and is_fading and 1 or 0.6}):Play()
		end
	end
end

function notifications:create_notification(options)
	local cfg = {
	name = options.name or "Hit: retard (retard) in the Head for 100 Damage!",
	outline;
	}

	local wm = library.watermark_outline
	local baseX = (wm and wm.AbsolutePosition and wm.AbsolutePosition.X) and wm.AbsolutePosition.X or 18
	local baseY = (wm and wm.AbsolutePosition and wm.AbsolutePosition.Y) and wm.AbsolutePosition.Y or 0

	local gap = 8
	local wmHeight = (wm and wm.AbsoluteSize and wm.AbsoluteSize.Y) and wm.AbsoluteSize.Y or 24

	local outline = library:create("Frame", {
	Parent = library.sgui;
	Position = dim_offset(baseX, baseY + wmHeight + ((#notifications.notifs + 1) * gap));
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(0, 0, 0, 24);
	BorderSizePixel = 0;
	AutomaticSize = Enum.AutomaticSize.X;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	local dark = library:create("Frame", {
	Parent = outline;
	BackgroundTransparency = 1;
	Position = dim2(0, 2, 0, 2);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -4, 1, -4);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(0, 0, 0)
	});

	library:create("UIPadding", {
	PaddingTop = dim(0, 7);
	PaddingBottom = dim(0, 6);
	Parent = dark;
	PaddingRight = dim(0, 7);
	PaddingLeft = dim(0, 4)
	});

	library:create("TextLabel", {
	FontFace = fonts["Tahoma12Pixel"];
	TextColor3 = rgb(255, 255, 255);
	BorderColor3 = rgb(0, 0, 0);
	Text = cfg.name;
	Parent = dark;
	Size = dim2(0, 0, 1, 0);
	Position = dim2(0, 1, 0, -1);
	BackgroundTransparency = 1;
	TextXAlignment = Enum.TextXAlignment.Left;
	BorderSizePixel = 0;
	AutomaticSize = Enum.AutomaticSize.X;
	TextSize = 13;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	library:create("UIGradient", {
	Color = rgbseq{
	rgbkey(0, themes.preset["1"]),
	rgbkey(0.5, themes.preset["2"]),
	rgbkey(1, themes.preset["3"]),
	};
	Parent = outline
	});

	local index = #notifications.notifs + 1
	notifications.notifs[index] = outline

	notifications:refresh_notifs()
	tween_service:Create(outline, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {AnchorPoint = vec2(0, 0)}):Play()

	notifications:fade(outline, false)

	task.spawn(function()
	task.wait(3)

	notifications.notifs[index] = nil

	notifications:fade(outline, true)

	task.wait(3)

	outline:Destroy()
end)
end

function library:watermark(options)
	local cfg = {
	name = options.name or "nebulahax";
	}

	local outline = library:create("Frame", {
	Parent = library.sgui;
	Position = dim2(0, 18, 0, 0);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(0, 0, 0, 24);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	}); library.watermark_outline = outline; library:draggify(outline);

	local dark = library:create("Frame", {
	Parent = outline;
	BackgroundTransparency = 0.6;
	Position = dim2(0, 2, 0, 2);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -4, 1, -4);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(0, 0, 0)
	});

	local text_title = library:create("TextLabel", {
	FontFace = fonts["Tahoma12Pixel"];
	TextColor3 = rgb(255, 255, 255);
	BorderColor3 = rgb(0, 0, 0);
	Text = cfg.name;
	Parent = dark;
	Size = dim2(1, 0, 1, 0);
	Position = dim2(0, 0, 0, -2);
	BackgroundTransparency = 1;
	TextXAlignment = Enum.TextXAlignment.Center;
	TextYAlignment = Enum.TextYAlignment.Center;
	BorderSizePixel = 0;
	TextSize = 13;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	library.watermark_gradient = library:create("UIGradient", {
	Color = rgbseq{
	rgbkey(0, themes.preset["1"]),
	rgbkey(0.5, themes.preset["2"]),
	rgbkey(1, themes.preset["3"]),
	};
	Parent = outline
	});

	local char_w = 6.2

	local function apply_size(t)
		local len = #t
		outline.Size = dim2(0, math.ceil(len * char_w + 16), 0, 24)
	end

	text_title:GetPropertyChangedSignal("TextBounds"):Connect(function()
		local bounds_x = text_title.TextBounds.X
		local len = #text_title.Text
		if bounds_x and bounds_x > 0 and len > 0 then
			char_w = bounds_x / len
			outline.Size = dim2(0, math.ceil(bounds_x + 16), 0, 24)
		end
	end)

	function cfg.update_text(text)
		text_title.Text = text
		apply_size(text)
	end

	cfg.update_text(cfg.name)

	return setmetatable(cfg, library)
end

local watermark = library:watermark({name = "priv9.net alpha"})
local fps = 0
local watermark_delay = tick()

track(run.RenderStepped:Connect(function()
fps += 1

if tick() - watermark_delay > 1 then
	watermark_delay = tick()
	local ping = math.floor(stats.PerformanceStats.Ping:GetValue()) .. "ms"
	watermark.update_text(string.format("priv9.net alpha | fps: %s", fps, ping))
	fps = 0
end
end))

function library:column(properties)
	self.count += 1
	self.columns = self.columns or {}

	local target_tab = self.tab or self
	local cfg = {color = library.gradient.Color.Keypoints[self.count].Value, count = self.count, tab = target_tab}
	insert(self.columns, cfg)

	if target_tab and target_tab.dropdowns then
		local num_cols = target_tab.columns and #target_tab.columns or 0
		local target_w = (num_cols == 2) and 105 or 68
		for _, holder in ipairs(target_tab.dropdowns) do
			holder.Size = dim2(0, target_w, 0, 16)
		end
	end

	local scrolling_frame = library:create("ScrollingFrame", {
	ScrollBarImageColor3 = rgb(0, 0, 0);
	Active = true;
	AutomaticCanvasSize = Enum.AutomaticSize.Y;
	ScrollBarThickness = 0;
	Parent = self.page;
	LayoutOrder = -1;
	BackgroundTransparency = 1;
	ScrollBarImageTransparency = 1;
	BorderColor3 = rgb(0, 0, 0);
	BackgroundColor3 = rgb(0, 0, 0);
	BorderSizePixel = 0;
	CanvasSize = dim2(0, 0, 0, 0)
	}); cfg.column = scrolling_frame

	library:create("UIListLayout", {
	Parent = scrolling_frame;
	Padding = dim(0, 2);
	SortOrder = Enum.SortOrder.LayoutOrder
	});

	return setmetatable(cfg, library)
end

function library:section(properties)
	local cfg = {
	name = properties.name or properties.Name or "section",
	size = properties.size or 1,
	autofill = properties.auto_fill or false,
	count = self.count;
	color = self.color;
	tab = self.tab;
	}

	local accent = library:create("Frame", {
	Parent = self.column;
	ClipsDescendants = true;
	BorderColor3 = rgb(0, 0, 0);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	}); library:apply_theme(accent, tostring(self.count), "BackgroundColor3");

	local dark = library:create("Frame", {
	Parent = accent;
	BackgroundTransparency = 0.6;
	Position = dim2(0, 1, 0, 16);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -17);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(0, 0, 0)
	});

	local elements = library:create("Frame", {
	Parent = dark;
	Position = dim2(0, 4, 0, 5);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -8, 0, 0);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	}); cfg.elements = elements
	cfg.frame = accent

	if cfg.autofill == false then
		elements.AutomaticSize = Enum.AutomaticSize.Y;
		accent.AutomaticSize = Enum.AutomaticSize.Y;
		accent.Size = dim2(1, 0, 0, 0);

		local UIPadding = library:create("UIPadding", {
		Parent = elements,
		Name = "",
		PaddingBottom = dim(0, 7)
		})
	else

		local marker = Instance.new("BoolValue")
		marker.Name = "__autofill"
		marker.Value = true
		marker.Parent = accent

		accent.Size = dim2(1, 0, 0, 24)

		local function find_listlayout(col)
		for _, v in pairs(col:GetChildren()) do
			if v:IsA("UIListLayout") then
				return v
			end
		end
	end

	local function apply_autofill()
	local col = accent.Parent
	if not col then return end

	local layout = find_listlayout(col)
	if not layout then return end

	local contentY = layout.AbsoluteContentSize.Y
	local thisH = accent.AbsoluteSize.Y

	local lastAutofill
	local maxY = -math.huge
	for _, child in pairs(col:GetChildren()) do
		local m = child:FindFirstChild("__autofill")
		-- Only visible autofill sections count. Other pages' sections
		-- live in the same column but are hidden; an invisible one has
		-- a stale AbsolutePosition and would otherwise be picked as
		-- "last", leaving the visible section stuck at 24px.
		if m and m.Value and child.Visible then
			if child.AbsolutePosition.Y > maxY then
				maxY = child.AbsolutePosition.Y
				lastAutofill = child
			end
		end
	end

	if lastAutofill ~= accent then
		return
	end

	local remaining = col.AbsoluteSize.Y - (contentY - thisH)
	remaining = math.floor(remaining)
	if remaining < 24 then
		remaining = 24
	end

	if remaining and remaining > 0 then
		accent.Size = UDim2.new(1, 0, 0, remaining)
	end
end

local scheduled = false
local function schedule()
if scheduled then return end
scheduled = true
task.delay(0.04, function()
scheduled = false
pcall(apply_autofill)
end)
end

local col = accent.Parent
local layout = find_listlayout(col)
if layout then
	library:connection(layout:GetPropertyChangedSignal("AbsoluteContentSize"), schedule)
end
library:connection(col:GetPropertyChangedSignal("AbsoluteSize"), schedule)

library:connection(accent:GetPropertyChangedSignal("AbsoluteSize"), schedule)

schedule()
end

library:create("UIListLayout", {
Parent = elements;
Padding = dim(0, 6);
SortOrder = Enum.SortOrder.LayoutOrder
});

local title = library:create("TextLabel", {
FontFace = fonts["Tahoma11PixelBold"];
TextColor3 = rgb(255, 255, 255);
BorderColor3 = rgb(0, 0, 0);
Text = cfg.name;
Parent = accent;
Size = dim2(1, 0, 0, 0);
Position = dim2(0, 4, 0, 2);
BackgroundTransparency = 1;
TextXAlignment = Enum.TextXAlignment.Left;
BorderSizePixel = 0;
AutomaticSize = Enum.AutomaticSize.Y;
TextSize = 12;
BackgroundColor3 = rgb(255, 255, 255)
});

library:create("UIListLayout", {
Parent = ScrollingFrame;
Padding = dim(0, 5);
SortOrder = Enum.SortOrder.LayoutOrder
});

return setmetatable(cfg, library)
end

function library:toggle(options)
	local cfg = {
	name = options.name or "Toggle",
	flag = options.flag or options.name or "Flag",

	default = options.default or false,
	folding = options.folding or false,
	callback = options.callback or function() end,

	color = self.color;
	count = self.count;
	}

	if options.enabled ~= nil then
		cfg.enabled = options.enabled
	else
		cfg.enabled = cfg.default
	end

	local toggle = library:create("TextButton", {
	Parent = self.elements;
	BackgroundTransparency = 1;
	Text = "";
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, 0, 0, 12);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	library:create("TextLabel", {
	FontFace = fonts["Tahoma12Pixel"];
	TextColor3 = rgb(255, 255, 255);
	BorderColor3 = rgb(0, 0, 0);
	Text = cfg.name;
	Parent = toggle;
	Size = dim2(1, 0, 1, 0);
	Position = dim2(0, 1, 0, -1);
	BackgroundTransparency = 1;
	TextXAlignment = Enum.TextXAlignment.Left;
	BorderSizePixel = 0;
	AutomaticSize = Enum.AutomaticSize.X;
	TextSize = 13;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	local accent = library:create("Frame", {
	AnchorPoint = vec2(1, 0);
	Parent = toggle;
	Position = dim2(1, 0, 0, 0);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(0, 12, 0, 12);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	}); library:apply_theme(accent, tostring(self.count), "BackgroundColor3");

	local fill = library:create("Frame", {
	Parent = accent;
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -2);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	}); library:apply_theme(fill, tostring(self.count), "BackgroundColor3");

	library:create("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal;
	HorizontalAlignment = Enum.HorizontalAlignment.Right;
	Parent = right_components;
	Padding = dim(0, 4);
	SortOrder = Enum.SortOrder.LayoutOrder
	});

	local elements;

	if cfg.folding then
		elements = library:create("Frame", {
		Parent = self.elements;
		BackgroundTransparency = 1;
		Position = dim2(0, 4, 0, 21);
		Size = dim2(1, 0, 0, 0);
		BorderSizePixel = 0;
		Visible = false;
		AutomaticSize = Enum.AutomaticSize.Y;
		BackgroundColor3 = rgb(255, 255, 255)
		}); cfg.elements = elements

		library:create("UIListLayout", {
		Parent = elements;
		Padding = dim(0, 6);
		HorizontalAlignment = Enum.HorizontalAlignment.Right;
		SortOrder = Enum.SortOrder.LayoutOrder
		});
	end

	function cfg.set(bool)
		fill.BackgroundColor3 = bool and themes.preset[tostring(self.count)] or themes.preset.inline
		fill:SetAttribute("PrivToggleState", bool)

		flags[cfg.flag] = bool

		cfg.callback(bool)

		if cfg.folding then
			elements.Visible = bool
		end
	end

	cfg.set(cfg.enabled)

	config_flags[cfg.flag] = cfg.set

	toggle.MouseButton1Click:Connect(function()
	cfg.enabled = not cfg.enabled
	cfg.set(cfg.enabled)
end)

return setmetatable(cfg, library)
end

function library:list(options)
	local cfg = {
	callback = options and options.callback or function() end,
	name = options.name or nil,

	scale = options.size or 90,
	items = options.items or {"1", "2", "3"},

	visible = options.visible or true,

	option_instances = {},
	current_instance = nil,
	flag = options.flag or "flag",
	}

	local accent = library:create("Frame", {
	BorderColor3 = rgb(0, 0, 0);
	AnchorPoint = vec2(1, 0);
	Parent = self.elements;
	Position = dim2(1, 0, 0, 0);
	Size = dim2(1, 0, 0, cfg.scale);
	BorderSizePixel = 0;
	AutomaticSize = Enum.AutomaticSize.Y;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	}); library:apply_theme(accent, tostring(self.count), "BackgroundColor3")

	local inline = library:create("Frame", {
	Parent = accent;
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -2);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(35, 35, 35)
	}); library:apply_theme(inline, "inline", "BackgroundColor3")

	local scrollingframe = library:create("ScrollingFrame", {
	ScrollBarImageColor3 = rgb(0, 0, 0);
	Active = true;
	AutomaticCanvasSize = Enum.AutomaticSize.Y;
	ScrollBarThickness = 0;
	Parent = inline;
	Size = dim2(1, 0, 1, 0);
	LayoutOrder = -1;
	BackgroundTransparency = 1;
	ScrollBarImageTransparency = 1;
	BorderColor3 = rgb(0, 0, 0);
	BackgroundColor3 = rgb(0, 0, 0);
	BorderSizePixel = 0;
	CanvasSize = dim2(0, 0, 0, 0)
	});

	library:create("UIListLayout", {
	Parent = scrollingframe;
	Padding = dim(0, 6);
	SortOrder = Enum.SortOrder.LayoutOrder
	});

	library:create("UIPadding", {
	PaddingTop = dim(0, 2);
	PaddingBottom = dim(0, 4);
	Parent = scrollingframe;
	PaddingRight = dim(0, 5);
	PaddingLeft = dim(0, 5)
	});

	function cfg.render_option(text)
		local text = library:create("TextButton", {
		FontFace = fonts["Tahoma12Pixel"];
		TextColor3 = rgb(170, 170, 170);
		BorderColor3 = rgb(0, 0, 0);
		Text = text;
		AutoButtonColor = false;
		BackgroundTransparency = 1;
		Parent = scrollingframe;
		BorderSizePixel = 0;
		Size = dim2(1, 0, 0, 13);
		AutomaticSize = Enum.AutomaticSize.None;
		TextSize = 13;
		TextXAlignment = Enum.TextXAlignment.Center;
		TextYAlignment = Enum.TextYAlignment.Center;
		BackgroundColor3 = rgb(255, 255, 255)
		});

		return text
	end

	function cfg.refresh_options(options)
		for _, v in cfg.option_instances do
			v:Destroy()
		end

		for _, option in next, options do
			local button = cfg.render_option(option)

			insert(cfg.option_instances, button)

			button.MouseButton1Click:Connect(function()
			if cfg.current_instance and cfg.current_instance ~= button then
				cfg.current_instance.TextColor3 = rgb(170, 170, 170)
			end

			cfg.current_instance = button
			button.TextColor3 = rgb(255, 255, 255)

			flags[cfg.flag] = button.text

			cfg.callback(button.text)
		end)
	end
end

function cfg.filter_options(text)
	for _, v in next, cfg.option_instances do
		if string.find(v.Text, text) then
			v.Visible = true
		else
			v.Visible = false
		end
	end
end

local function update_label()
if cfg.open then

	local highlighted = nil
	for _, opt in next, cfg.option_instances do
		if opt.TextColor3 == rgb(255, 255, 255) then
			highlighted = opt.Text
			break
		end
	end

	if highlighted then
		text.Text = highlighted
	else
		local fallback = flags[cfg.flag] or (cfg.option_instances[1] and cfg.option_instances[1].Text) or "..."
		text.Text = fallback
	end

	return
end

local display = ""
if cfg.multi then
	display = concat(cfg.multi_items, ", ")
else
	display = flags[cfg.flag] or cfg.default or ""
end

text.Text = display
end

function cfg.set(value)
	for _, buttons in next, cfg.option_instances do
		if buttons.Text == value then
			buttons.TextColor3 = rgb(255, 255, 255)
		else
			buttons.TextColor3 = rgb(170, 170, 170)
		end
	end

	flags[cfg.flag] = value
	cfg.callback(value)
end

cfg.refresh_options(cfg.items)

return setmetatable(cfg, library)
end

function library:slider(options)
	local is_bipolar = (options.bipolar == true) or (options.min ~= nil and options.min < 0 and options.max ~= nil and options.max > 0)
	local default_val = options.default
	if default_val == nil then
		default_val = is_bipolar and 0 or 10
	end

	local cfg = {
	name = options.name or nil,
	suffix = options.suffix or "",
	flag = options.flag or options.name or "Flag",
	callback = options.callback or function() end,

	min = options.min or options.minimum or (is_bipolar and -100 or 0),
	max = options.max or options.maximum or 100,
	intervals = options.interval or options.decimal or 1,
	default = default_val,
	value = default_val,
	bipolar = is_bipolar,

	ignore = options.ignore or false,
	dragging = false,
	}

	local slider = library:create("Frame", {
	Parent = self.elements;
	BackgroundTransparency = 1;
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, 0, 0, 25);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	local eeeee = library:create("TextLabel", {
	FontFace = fonts["Tahoma12Pixel"];
	TextColor3 = rgb(255, 255, 255);
	RichText = true;
	BorderColor3 = rgb(0, 0, 0);
	Text = "max distance : 5000";
	Parent = slider;
	Size = dim2(1, 0, 0, 0);
	Position = dim2(0, 1, 0, -2);
	BackgroundTransparency = 1;
	TextXAlignment = Enum.TextXAlignment.Left;
	BorderSizePixel = 0;
	AutomaticSize = Enum.AutomaticSize.XY;
	TextSize = 13;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	local outline = library:create("TextButton", {
	Parent = slider;
	Text = "";
	AutoButtonColor = false;
	Position = dim2(0, 0, 0, 13);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, 0, 0, 12);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	}); library:apply_theme(outline, tostring(self.count), "BackgroundColor3")

	local inline = library:create("Frame", {
	Parent = outline;
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -2);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset.inline
	}); library:apply_theme(outline, "inline", "BackgroundColor3")

	local accent = library:create("Frame", {
	Parent = inline;
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(0.5, 0, 1, 0);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	}); library:apply_theme(accent, tostring(self.count), "BackgroundColor3")

	local highlight = library:create("Frame", {
	Parent = inline;
	ZIndex = 2;
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, 0, 1, 0);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)];
	BackgroundTransparency = 1;
	Active = false;
	}); library:apply_theme(highlight, tostring(self.count), "BackgroundColor3")

	local is_hovered = false
	local function update_hover(bool)
		if bool ~= nil then
			is_hovered = bool
		end
		if is_hovered or cfg.dragging then
			highlight.BackgroundTransparency = 0.90
		else
			highlight.BackgroundTransparency = 1
		end
	end

	outline.MouseEnter:Connect(function()
		update_hover(true)
	end)

	outline.MouseLeave:Connect(function()
		if not mouse_in_frame(outline) and not mouse_in_frame(slider) then
			update_hover(false)
		end
	end)

	slider.MouseEnter:Connect(function()
		update_hover(true)
	end)

	slider.MouseLeave:Connect(function()
		if not mouse_in_frame(outline) and not mouse_in_frame(slider) then
			update_hover(false)
		end
	end)

	function cfg.set(value)
		local valuee = tonumber(value)

		if valuee == nil then
			return
		end

		cfg.value = clamp(library:round(valuee, cfg.intervals), cfg.min, cfg.max)

		if cfg.bipolar then
			if cfg.value >= 0 then
				local w = cfg.max > 0 and ((cfg.value / cfg.max) * 0.5) or 0
				w = clamp(w, 0, 0.5)
				accent.Position = dim2(0.5, 0, 0, 0)
				accent.Size = dim2(w, 0, 1, 0)
			else
				local w = cfg.min < 0 and ((cfg.value / cfg.min) * 0.5) or 0
				w = clamp(w, 0, 0.5)
				accent.Position = dim2(0.5 - w, 0, 0, 0)
				accent.Size = dim2(w, 0, 1, 0)
			end
		else
			accent.Position = dim2(0, 0, 0, 0)
			accent.Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)
		end

		eeeee.Text = cfg.name .. '<font color="#AAAAAA"> - ' .. tostring(cfg.value) .. cfg.suffix .. '</font>'

		flags[cfg.flag] = cfg.value

		cfg.callback(flags[cfg.flag])
	end

	local function get_value_at_x(pixel_x)
		local w = inline.AbsoluteSize.X
		if w <= 0 then return cfg.value end
		local size_x = clamp((pixel_x - inline.AbsolutePosition.X) / w, 0, 1)
		if cfg.bipolar then
			if size_x >= 0.5 then
				return ((size_x - 0.5) / 0.5) * cfg.max
			else
				return ((0.5 - size_x) / 0.5) * cfg.min
			end
		else
			return ((cfg.max - cfg.min) * size_x) + cfg.min
		end
	end

	outline.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			cfg.dragging = true
			update_hover(true)
			cfg.set(get_value_at_x(input.Position.X))
		end
	end)

	outline.MouseButton1Down:Connect(function()
		cfg.dragging = true
		update_hover(true)
	end)

	library:connection(uis.InputChanged, function(input)
		if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			cfg.set(get_value_at_x(input.Position.X))
		end
	end)

	library:connection(uis.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			cfg.dragging = false
			if not mouse_in_frame(outline) and not mouse_in_frame(slider) then
				update_hover(false)
			end
		end
	end)

	cfg.set(cfg.default)

	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:bipolar_slider(options)
	options = options or {}
	options.bipolar = true
	return library.slider(self, options)
end

function library:dropdown(options)
	local cfg = {
	name = options.name or nil,
	flag = options.flag or options.name or "Flag",
	items = options.items or {""},
	callback = options.callback or function() end,
	multi = options.multi or false,
	scrolling = options.scrolling or false,

	open = false,
	option_instances = {},
	multi_items = {},
	ignore = options.ignore or false,
	}

	cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or "None"

	flags[cfg.flag] = {}

	local whitelist = {}
	for _, value in next, (options.whitelist or {}) do
		whitelist[value] = true
	end

	local dropdown = library:create("Frame", {
	Parent = self.elements;
	BackgroundTransparency = 1;
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, 0, 0, 16);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	}); cfg.frame = dropdown

	local target_tab = self.tab
	local initial_cols = 0
	if target_tab then
		if target_tab.columns and #target_tab.columns > 0 then
			initial_cols = #target_tab.columns
		elseif target_tab.page then
			for _, child in ipairs(target_tab.page:GetChildren()) do
				if child:IsA("ScrollingFrame") then
					initial_cols += 1
				end
			end
		end
	end
	local initial_w = (initial_cols == 2) and 105 or 68

	local dropdown_holder = library:create("TextButton", {
	AnchorPoint = vec2(1, 0);
	AutoButtonColor = false;
	Text = "";
	Parent = dropdown;
	Position = dim2(1, 0, 0, 0);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(0, initial_w, 0, 16);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	}); library:apply_theme(dropdown_holder, tostring(self.count), "BackgroundColor3")

	if target_tab then
		target_tab.dropdowns = target_tab.dropdowns or {}
		insert(target_tab.dropdowns, dropdown_holder)

		task.defer(function()
			local c_count = target_tab.columns and #target_tab.columns or 0
			if c_count == 0 and target_tab.page then
				for _, child in ipairs(target_tab.page:GetChildren()) do
					if child:IsA("ScrollingFrame") then
						c_count += 1
					end
				end
			end
			local tw = (c_count == 2) and 105 or 68
			dropdown_holder.Size = dim2(0, tw, 0, 16)
		end)
	end

	local inline = library:create("Frame", {
	Parent = dropdown_holder;
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -2);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(35, 35, 35)
	});

	local text = library:create("TextLabel", {
	FontFace = fonts["Tahoma12Pixel"];
	TextColor3 = rgb(255, 255, 255);
	BorderColor3 = rgb(0, 0, 0);
	Text = cfg.name;
	Parent = inline;
	Size = dim2(1, -4, 1, 0);
	BackgroundTransparency = 1;
	Position = dim2(0, 4, 0, -1);
	BorderSizePixel = 0;
	TextXAlignment = Enum.TextXAlignment.Left;
	TextYAlignment = Enum.TextYAlignment.Center;
	TextSize = 13;
	BackgroundColor3 = rgb(255, 255, 255);
	ZIndex = 3;
	});

	local highlight = library:create("Frame", {
	Parent = inline;
	ZIndex = 2;
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, 0, 1, 0);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)];
	BackgroundTransparency = 1;
	Active = false;
	}); library:apply_theme(highlight, tostring(self.count), "BackgroundColor3")

	local is_hovered = false
	local function update_hover(bool)
		if bool ~= nil then
			is_hovered = bool
		end
		if is_hovered or cfg.open then
			highlight.BackgroundTransparency = 0.75
		else
			highlight.BackgroundTransparency = 1
		end
	end

	dropdown_holder.MouseEnter:Connect(function()
		update_hover(true)
	end)

	dropdown_holder.MouseLeave:Connect(function()
		if not mouse_in_frame(dropdown) and not mouse_in_frame(dropdown_holder) then
			update_hover(false)
		end
	end)

	dropdown.MouseEnter:Connect(function()
		update_hover(true)
	end)

	dropdown.MouseLeave:Connect(function()
		if not mouse_in_frame(dropdown) and not mouse_in_frame(dropdown_holder) then
			update_hover(false)
		end
	end)

	local title = library:create("TextLabel", {
	FontFace = fonts["Tahoma12Pixel"];
	TextColor3 = rgb(255, 255, 255);
	BorderColor3 = rgb(0, 0, 0);
	Text = cfg.name;
	Parent = dropdown;
	Size = dim2(1, 0, 1, 0);
	Position = dim2(0, 1, 0, 0);
	BackgroundTransparency = 1;
	TextXAlignment = Enum.TextXAlignment.Left;
	BorderSizePixel = 0;
	AutomaticSize = Enum.AutomaticSize.X;
	TextSize = 13;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	local accent = library:create("Frame", {
	Parent = library.gui;
	Size = dim2(0.0907348021864891, 0, 0.006218905560672283, 20);
	Position = dim2(0, 500, 0, 100);
	BorderColor3 = rgb(0, 0, 0);
	BorderSizePixel = 0;
	Visible = false;
	AutomaticSize = Enum.AutomaticSize.Y;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	});	library:apply_theme(accent, tostring(self.count), "BackgroundColor3")

	local inline = library:create("Frame", {
	Parent = accent;
	Size = dim2(1, -2, 1, -2);
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	BorderSizePixel = 0;
	AutomaticSize = Enum.AutomaticSize.Y;
	BackgroundColor3 = themes.preset.inline
	});	library:apply_theme(inline, "inline", "BackgroundColor3")

	library:create("UIListLayout", {
	Parent = inline;
	Padding = dim(0, 6);
	SortOrder = Enum.SortOrder.LayoutOrder
	});

	library:create("UIPadding", {
	PaddingTop = dim(0, 5);
	PaddingBottom = dim(0, 2);
	Parent = inline;
	PaddingRight = dim(0, 1);
	PaddingLeft = dim(0, 1)
	});

	local padding = library:create("UIPadding", {
	PaddingBottom = dim(0, 2);
	Parent = accent
	});

	function cfg.render_option(text)
		local title = library:create("TextButton", {
		FontFace = fonts["Tahoma12Pixel"];
		AutoButtonColor = false;
		TextColor3 = rgb(170, 170, 170);
		BorderColor3 = rgb(0, 0, 0);
		Text = text;
		Parent = inline;
		Size = dim2(1, 0, 0, 13);
		Position = dim2(0, 0, 0, 0);
		BackgroundTransparency = 1;
		TextXAlignment = Enum.TextXAlignment.Left;
		TextYAlignment = Enum.TextYAlignment.Center;
		BorderSizePixel = 0;
		AutomaticSize = Enum.AutomaticSize.None;
		TextSize = 13;
		BackgroundColor3 = rgb(255, 255, 255)
		});

		return title
	end

	function cfg.set_visible(bool)
		accent.Visible = bool
	end

	local function fit_text(str)
	if whitelist[str] then
		return str
	end

	local max_x = text.AbsoluteSize.X - 4
	if max_x <= 0 then
		max_x = 62
	end

	text.Text = str
	if text.TextBounds.X <= max_x then
		return str
	end

	local ellipsis = "..."
	local result = ""
	for i = 1, #str do
		local candidate = result .. str:sub(i, i)
		text.Text = candidate .. ellipsis
		if text.TextBounds.X > max_x then
			break
		end
		result = candidate
	end

	result = result:gsub("%s+$", "")

	return result .. ellipsis
end

local function update_label()
if cfg.open then
	text.Text = "..."
	return
end

local display = ""
if cfg.multi then
	display = concat(cfg.multi_items, ", ")
	if display == "" then
		display = "none"
	end
else
	display = flags[cfg.flag] or cfg.default or ""
end

text.Text = fit_text(display)
end

function cfg.close()
	accent.Visible = false
	cfg.open = false
	update_label()
	if not mouse_in_frame(dropdown) and not mouse_in_frame(dropdown_holder) then
		update_hover(false)
	end
end

function cfg.set(value)
	local selected = {}
	local isTable = type(value) == "table"

	if value == nil then
		return
	end

	for _, option in next, cfg.option_instances do
		if option.Text == value or (isTable and find(value, option.Text)) then
			insert(selected, option.Text)
			cfg.multi_items = selected
			option.TextColor3 = rgb(255, 255, 255)
		else
			option.TextColor3 = rgb(170, 170, 170)
		end
	end

	flags[cfg.flag] = if isTable then selected else selected[1]
	cfg.callback(flags[cfg.flag])

	update_label()
end

function cfg.refresh_options(list)
	for _, option in next, cfg.option_instances do
		option:Destroy()
	end

	cfg.option_instances = {}

	for _, option in next, list do
		local button = cfg.render_option(option)

		insert(cfg.option_instances, button)

		button.MouseButton1Down:Connect(function()
		if cfg.multi then
			local selected_index = find(cfg.multi_items, button.Text)

			if selected_index then
				remove(cfg.multi_items, selected_index)
			else
				insert(cfg.multi_items, button.Text)
			end

			cfg.set(cfg.multi_items)
		else
			cfg.set_visible(false)
			cfg.open = false

			cfg.set(button.Text)
			if not mouse_in_frame(dropdown) and not mouse_in_frame(dropdown_holder) then
				update_hover(false)
			end
		end
	end)
end
end

cfg.refresh_options(cfg.items)

cfg.set(cfg.default)

config_flags[cfg.flag] = cfg.set

dropdown_holder.MouseButton1Click:Connect(function()
cfg.open = not cfg.open

local absX = math.round(dropdown_holder.AbsolutePosition.X)
local absY = dropdown_holder.AbsolutePosition.Y
local absH = dropdown_holder.AbsoluteSize.Y

local width = dropdown_holder.AbsoluteSize.X
for _, option in next, cfg.option_instances do
	width = math.max(width, math.max(option.TextBounds.X, #option.Text * 6.2) + 18)
end
accent.Size = UDim2.new(0, math.floor(width), accent.Size.Y.Scale, accent.Size.Y.Offset)
accent.Position = UDim2.new(0, absX, 0, absY + absH + 59)

cfg.set_visible(cfg.open)
update_label()

if cfg.open then
	if library.current_element_open and library.current_element_open ~= cfg then
		library:close_current_element()
	end
	library.current_element_open = cfg
else
	library.current_element_open = nil
end

update_hover(cfg.open or mouse_in_frame(dropdown) or mouse_in_frame(dropdown_holder))
end)

track(uis.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
	if not (mouse_in_frame(accent) or mouse_in_frame(dropdown)) then
		cfg.open = false
		cfg.set_visible(false)
		update_label()
		if not mouse_in_frame(dropdown) and not mouse_in_frame(dropdown_holder) then
			update_hover(false)
		end
	end
end
end))

return setmetatable(cfg, library)
end

function library:colorpicker(options)
	local cfg = {
	name = options.name or "Color",
	flag = options.flag or options.name or "Flag",

	color = options.color or color(1, 1, 1),
	alpha = options.alpha and 1 - options.alpha or 0,

	open = false,
	callback = options.callback or function() end,
	}

	local colorpicker_element = library:create("TextButton", {
	Parent = self.elements;
	BackgroundTransparency = 1;
	Text = "";
	AutoButtonColor = false;
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, 0, 0, 12);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	}); cfg.frame = colorpicker_element

	local accent = library:create("Frame", {
	AnchorPoint = vec2(1, 0);
	Parent = colorpicker_element;
	Position = dim2(1, 0, 0, 0);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(0, 30, 0, 12);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	}); library:apply_theme(accent, tostring(self.count), "BackgroundColor3")

	local colorpicker_element_color = library:create("Frame", {
	Parent = accent;
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -2);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	library:create("TextLabel", {
	FontFace = fonts["Tahoma12Pixel"];
	TextColor3 = rgb(255, 255, 255);
	BorderColor3 = rgb(0, 0, 0);
	Text = cfg.name;
	Parent = colorpicker_element;
	Size = dim2(1, 0, 1, 0);
	Position = dim2(0, 1, 0, 0);
	BackgroundTransparency = 1;
	TextXAlignment = Enum.TextXAlignment.Left;
	BorderSizePixel = 0;
	AutomaticSize = Enum.AutomaticSize.X;
	TextSize = 13;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	local colorpicker = library:create("Frame", {
	Parent = library.gui;
	Position = dim2(0.6888179183006287, 0, 0.24751244485378265, 0);
	BorderColor3 = rgb(0, 0, 0);
	Visible = false;
	Size = dim2(0, 150, 0, 150);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	});	library:apply_theme(colorpicker, tostring(self.count), "BackgroundColor3")

	local a = library:create("Frame", {
	Parent = colorpicker;
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, 0, 1, 0);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	}); library:apply_theme(a, tostring(self.count), "BackgroundColor3")

	local e = library:create("Frame", {
	Parent = a;
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -2);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(0, 0, 0);
	BackgroundTransparency = 0.6;
	ZIndex = -1
	});

	local _ = library:create("UIPadding", {
	PaddingTop = dim(0, 7);
	PaddingBottom = dim(0, -13);
	Parent = e;
	PaddingRight = dim(0, 6);
	PaddingLeft = dim(0, 7)
	});

	local textbox_holder = library:create("Frame", {
	Parent = e;
	Position = dim2(0, 0, 1, -36);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -1, 0, 16);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	}); library:apply_theme(textbox_holder, tostring(self.count), "BackgroundColor3")

	local textbox = library:create("TextBox", {
	FontFace = fonts["Tahoma12Pixel"];
	TextColor3 = rgb(255, 255, 255);
	BorderColor3 = rgb(0, 0, 0);
	Text = "";
	Parent = textbox_holder;
	BackgroundTransparency = 0;
	ClearTextOnFocus = false;
	PlaceholderColor3 = rgb(255, 255, 255);
	Size = dim2(1, -2, 1, -2);
	Position = dim2(0, 1, 0, 1);
	BorderSizePixel = 0;
	TextSize = 13;
	TextXAlignment = Enum.TextXAlignment.Center;
	BackgroundColor3 = themes.preset.inline
	}); library:apply_theme(textbox, "inline", "BackgroundColor3")

	local hue_button = library:create("TextButton", {
	AnchorPoint = vec2(1, 0);
	Text = "";
	AutoButtonColor = false;
	Parent = e;
	Position = dim2(1, -1, 0, 0);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(0, 14, 1, -60);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset.inline
	}); library:apply_theme(hue_button, "inline", "BackgroundColor3")

	local hue_drag = library:create("Frame", {
	Parent = hue_button;
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -2);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	library:create("UIGradient", {
	Rotation = 90;
	Parent = hue_drag;
	Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))}
	});

	local hue_picker = library:create("Frame", {
	Parent = hue_drag;
	BorderMode = Enum.BorderMode.Inset;
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, 2, 0, 3);
	Position = dim2(0, -1, 0, -1);
	BackgroundColor3 = rgb(255, 255, 255)
	});

	local alpha_button = library:create("TextButton", {
	AnchorPoint = vec2(0, 0.5);
	Text = "";
	AutoButtonColor = false;
	Parent = e;
	Position = dim2(0, 0, 1, -48);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -1, 0, 14);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset.inline
	}); library:apply_theme(alpha_button, "inline", "BackgroundColor3")

	local alpha_color = library:create("Frame", {
	Parent = alpha_button;
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -2);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(0, 221, 255)
	});

	local alphaind = library:create("ImageLabel", {
	ScaleType = Enum.ScaleType.Tile;
	BorderColor3 = rgb(0, 0, 0);
	Parent = alpha_color;
	Image = "rbxassetid://18274452449";
	BackgroundTransparency = 1;
	Size = dim2(1, 0, 1, 0);
	TileSize = dim2(0, 4, 0, 4);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	library:create("UIGradient", {
	Parent = alphaind;
	Rotation = 0;
	Transparency = numseq{numkey(0, 0), numkey(1, 1)}
	});

	local alpha_picker = library:create("Frame", {
	Parent = alpha_color;
	BorderMode = Enum.BorderMode.Inset;
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(0, 3, 1, 2);
	Position = dim2(0, -1, 0, -1);
	BackgroundColor3 = rgb(255, 255, 255)
	});

	local saturation_value_button = library:create("TextButton", {
	Parent = e;
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -20, 1, -60);
	Text = "";
	AutoButtonColor = false;
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset.inline
	}); library:apply_theme(saturation_value_button, "inline", "BackgroundColor3")

	local colorpicker_color = library:create("Frame", {
	Parent = saturation_value_button;
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -2);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(0, 221, 255)
	});

	local val = library:create("TextButton", {
	Parent = colorpicker_color;
	Text = "";
	AutoButtonColor = false;
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, 0, 1, 0);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	library:create("UIGradient", {
	Parent = val;
	Transparency = numseq{numkey(0, 0), numkey(1, 1)}
	});

	local saturation_value_picker = library:create("Frame", {
	Parent = colorpicker_color;
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(0, 3, 0, 3);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(0, 0, 0)
	});

	local inline = library:create("Frame", {
	Parent = saturation_value_picker;
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -2);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	local saturation_button = library:create("TextButton", {
	Parent = colorpicker_color;
	Text = "";
	AutoButtonColor = false;
	Size = dim2(1, 0, 1, 0);
	BorderColor3 = rgb(0, 0, 0);
	ZIndex = 2;
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	library:create("UIGradient", {
	Rotation = 270;
	Transparency = numseq{numkey(0, 0), numkey(1, 1)};
	Parent = saturation_button;
	Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
	});

	local dragging_sat = false
	local dragging_hue = false
	local dragging_alpha = false

	local h, s, v = cfg.color:ToHSV()
	local a = cfg.alpha

	flags[cfg.flag] = {}

	function cfg.set_visible(bool)
		colorpicker.Visible = bool

		colorpicker.Position = dim_offset(math.round(accent.AbsolutePosition.X), accent.AbsolutePosition.Y + accent.AbsoluteSize.Y + 59)
	end

	function cfg.set(color, alpha)
		if color then
			h, s, v = color:ToHSV()
		end

		if alpha then
			a = alpha
		end

		local Color = Color3.fromHSV(h, s, v)

		hue_picker.Position = dim2(0, -1, h, -1)
		alpha_picker.Position = dim2(1 - a, -1, 0, -1)
		saturation_value_picker.Position = dim2(s, -1, 1 - v, -1)

		alpha_color.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		colorpicker_element_color.BackgroundColor3 = Color
		colorpicker_color.BackgroundColor3 = Color3.fromHSV(h, 1, 1)

		flags[cfg.flag] = {
		Color = Color;
		Transparency = a
		}

		local color = colorpicker_element_color.BackgroundColor3
		textbox.Text = string.format("%s, %s, %s, ", library:round(color.R * 255), library:round(color.G * 255), library:round(color.B * 255))
		textbox.Text ..= library:round(1 - a, 0.01)

		cfg.callback(Color, a)
	end

	function cfg.update_color()
		local mouse = uis:GetMouseLocation()
		local offset = vec2(mouse.X, mouse.Y - gui_offset)

		if dragging_sat then
			s = math.clamp((offset - saturation_value_button.AbsolutePosition).X / saturation_value_button.AbsoluteSize.X, 0, 1)
			v = 1 - math.clamp((offset - saturation_value_button.AbsolutePosition).Y / saturation_value_button.AbsoluteSize.Y, 0, 1)
		elseif dragging_hue then
			h = math.clamp((offset - hue_button.AbsolutePosition).Y / hue_button.AbsoluteSize.Y, 0, 1)
		elseif dragging_alpha then
			a = 1 - math.clamp((offset - alpha_button.AbsolutePosition).X / alpha_button.AbsoluteSize.X, 0, 1)
		end

		cfg.set(nil, nil)
	end

	cfg.set(cfg.color, cfg.alpha)

	config_flags[cfg.flag] = cfg.set

	colorpicker_element.MouseButton1Click:Connect(function()
	cfg.open = not cfg.open

	cfg.set_visible(cfg.open)

	if cfg.open then
		if library.current_element_open and library.current_element_open ~= cfg then
			library:close_current_element()
		end
		library.current_element_open = cfg
	else
		library.current_element_open = nil
	end
end)

track(uis.InputChanged:Connect(function(input)
if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
	cfg.update_color()
end
end))

library:connection(uis.InputEnded, function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
	dragging_sat = false
	dragging_hue = false
	dragging_alpha = false
end
end)

track(uis.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
	if not (mouse_in_frame(colorpicker_element) or mouse_in_frame(colorpicker)) then
		cfg.open = false
		cfg.set_visible(false)
	end
end
end))

alpha_button.MouseButton1Down:Connect(function()
dragging_alpha = true
end)

hue_button.MouseButton1Down:Connect(function()
dragging_hue = true
end)

saturation_button.MouseButton1Down:Connect(function()
dragging_sat = true
end)

textbox.FocusLost:Connect(function()
local r, g, b, a = library:convert(textbox.Text)

if r and g and b and a then
	cfg.set(rgb(r, g, b), 1 - a)
end
end)

return setmetatable(cfg, library)
end

function library:textbox(options)
	local cfg = {
	name = options.name or "...",
	placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
	default = options.default,
	flag = options.flag or options.name or "Flag",
	callback = options.callback or function() end,
	visible = options.visible or true,
	}

	local frame = library:create("TextButton", {
	AnchorPoint = vec2(1, 0);
	Text = "";
	AutoButtonColor = false;
	Parent = self.elements;
	Position = dim2(1, 0, 0, 0);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, 0, 0, 16);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	}); library:apply_theme(frame, tostring(self.count), "BackgroundColor3")

	local frame_inline = library:create("Frame", {
	Parent = frame;
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -2);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset.inline
	}); library:apply_theme(frame_inline, "inline", "BackgroundColor3")

	local input = library:create("TextBox", {
	Parent = frame,
	Name = "",
	FontFace = fonts["Tahoma12Pixel"],
	TextTruncate = Enum.TextTruncate.AtEnd,
	TextSize = 13,
	Text = "",
	Size = dim2(1, -6, 1, 0),
	RichText = true,
	TextColor3 = rgb(255, 255, 255),
	BorderColor3 = rgb(0, 0, 0),
	CursorPosition = -1,
	BackgroundTransparency = 1,
	TextXAlignment = Enum.TextXAlignment.Left,
	Position = dim2(0, 6, 0, 0),
	BorderSizePixel = 0,
	PlaceholderColor3 = rgb(170, 170, 170),
	})

	function cfg.set(text)
		flags[cfg.flag] = text

		input.Text = text

		cfg.callback(text)
	end

	config_flags[cfg.flag] = cfg.set

	if cfg.default then
		cfg.set(cfg.default)
	end

	input:GetPropertyChangedSignal("Text"):Connect(function()
	cfg.set(input.Text)
end)

return setmetatable(cfg, library)
end

function library:keybind(options)
	local cfg = {
	flag = options.flag or options.name or "Flag",
	callback = options.callback or function() end,
	open = false,
	binding = nil,
	name = options.name or nil,
	ignore_key = options.ignore or false,

	key = options.key or nil,
	force_toggle = options.force_toggle or false,
	mode = options.force_toggle and "toggle" or (options.mode or "toggle"),
	active = options.default or false,

	hold_instances = {},
	visualize_toggle = options.visualize_toggle or nil,
	}

	flags[cfg.flag] = {}
	insert(library.keybinds, cfg)

	local keybind = library:create("Frame", {
	Parent = self.elements;
	BackgroundTransparency = 1;
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, 0, 0, 16);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	local keybind_holder = library:create("TextButton", {
	AnchorPoint = vec2(1, 0);
	AutoButtonColor = false;
	Text = "";
	Parent = keybind;
	Position = dim2(1, 0, 0, 0);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(0, 68, 0, 16);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	}); library:apply_theme(keybind_holder, tostring(self.count), "BackgroundColor3")

	local inline = library:create("Frame", {
	Parent = keybind_holder;
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -2);
	BorderSizePixel = 0;
	BackgroundColor3 = rgb(35, 35, 35)
	});

	local text = library:create("TextLabel", {
	FontFace = fonts["Tahoma12Pixel"];
	TextColor3 = rgb(255, 255, 255);
	BorderColor3 = rgb(0, 0, 0);
	Text = cfg.name;
	Parent = inline;
	Size = dim2(1, 0, 1, 0);
	BackgroundTransparency = 1;
	Position = dim2(0, 0, 0, -1);
	BorderSizePixel = 0;
	TextXAlignment = Enum.TextXAlignment.Center;
	TextYAlignment = Enum.TextYAlignment.Center;
	TextSize = 13;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	local title = library:create("TextLabel", {
	FontFace = fonts["Tahoma12Pixel"];
	TextColor3 = rgb(255, 255, 255);
	BorderColor3 = rgb(0, 0, 0);
	Text = cfg.name;
	Parent = keybind;
	Size = dim2(1, 0, 1, 0);
	Position = dim2(0, 1, 0, 0);
	BackgroundTransparency = 1;
	TextXAlignment = Enum.TextXAlignment.Left;
	BorderSizePixel = 0;
	AutomaticSize = Enum.AutomaticSize.X;
	TextSize = 13;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	local accent = library:create("Frame", {
	Parent = library.gui;
	Visible = false;
	Size = dim2(0.0907348021864891, 0, 0.006218905560672283, 20);
	Position = dim2(0, 500, 0, 100);
	BorderColor3 = rgb(0, 0, 0);
	BorderSizePixel = 0;
	AutomaticSize = Enum.AutomaticSize.Y;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	});	library:apply_theme(accent, tostring(self.count), "BackgroundColor3")

	local inline = library:create("Frame", {
	Parent = accent;
	Size = dim2(1, -2, 1, -2);
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	BorderSizePixel = 0;
	AutomaticSize = Enum.AutomaticSize.Y;
	BackgroundColor3 = themes.preset.inline
	});	library:apply_theme(inline, "inline", "BackgroundColor3")

	library:create("UIListLayout", {
	Parent = inline;
	Padding = dim(0, 6);
	SortOrder = Enum.SortOrder.LayoutOrder
	});

	library:create("UIPadding", {
	PaddingTop = dim(0, 5);
	PaddingBottom = dim(0, 2);
	Parent = inline;
	PaddingRight = dim(0, 1);
	PaddingLeft = dim(0, 1)
	});

	local padding = library:create("UIPadding", {
	PaddingBottom = dim(0, 2);
	Parent = accent
	});

	local options = cfg.force_toggle and {"toggle"} or {"hold", "toggle", "always"}

	for _, v in options do
		local option = library:create("TextButton", {
		FontFace = fonts["Tahoma12Pixel"];
		AutoButtonColor = false;
		TextColor3 = rgb(170, 170, 170);
		BorderColor3 = rgb(0, 0, 0);
		Text = v;
		Parent = inline;
		Size = dim2(1, 0, 0, 13);
		Position = dim2(0, 0, 0, 0);
		BackgroundTransparency = 1;
		TextXAlignment = Enum.TextXAlignment.Left;
		TextYAlignment = Enum.TextYAlignment.Center;
		BorderSizePixel = 0;
		AutomaticSize = Enum.AutomaticSize.None;
		TextSize = 13;
		BackgroundColor3 = rgb(255, 255, 255)
		}); cfg.hold_instances[v] = option

		option.MouseButton1Click:Connect(function()
		cfg.set(v)

		cfg.set_visible(false)

		cfg.open = false
	end)
end

function cfg.modify_mode_color(path)
	local target = path and string.lower(tostring(path))
	for k, v in cfg.hold_instances do
		if string.lower(tostring(k)) == target then
			v.TextColor3 = rgb(255, 255, 255)
		else
			v.TextColor3 = rgb(170, 170, 170)
		end
	end
end

function cfg.set_mode(mode)
	mode = mode and mode:gsub("^%l", string.upper) or mode
	cfg.mode = cfg.force_toggle and "Toggle" or mode

	if cfg.mode == "Always" then
		cfg.set(true)
	elseif cfg.mode == "Hold" then
		cfg.set(false)
	end

	flags[cfg.flag]["mode"] = cfg.mode
	cfg.modify_mode_color(cfg.mode)
end

function cfg.set(input)
	if type(input) == "boolean" then
		local __cached = input

		if cfg.mode == "Always" then
			__cached = true
		end

		cfg.active = __cached
		cfg.callback(__cached)
	elseif tostring(input):find("Enum") then
		input = input.Name == "Escape" and nil or input

		cfg.key = input

		cfg.callback(cfg.active or false)
	elseif find({"Toggle", "Hold", "Always", "toggle", "hold", "always"}, input) then
		cfg.set_mode(input)

		if cfg.mode == "Always" then
			cfg.active = true
		end

		cfg.callback(cfg.active or false)
	elseif type(input) == "table" then
		input.key = type(input.key) == "string" and input.key ~= "..." and library:convert_enum(input.key) or input.key

		input.key = input.key == Enum.KeyCode.Escape and nil or input.key
		cfg.key = input.key

		input.mode = cfg.force_toggle and "Toggle" or (input.mode or "Toggle")
		cfg.mode = input.mode
		cfg.set_mode(input.mode)

		if input.active then
			cfg.active = input.active
		end
	end

	flags[cfg.flag] = {
	name = cfg.name,
	mode = cfg.mode,
	key = cfg.key,
	active = cfg.active
	}

	library:update_keybind_visualizer()

	local _text = cfg.key and tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
	local __text = _text and (tostring(_text):gsub("KeyCode.", ""):gsub("UserInputType.", "")) or "none"

	text.Text = __text

end

function cfg.set_visible(bool)
	accent.Visible = bool

	accent.Size = dim2(0, keybind_holder.AbsoluteSize.X, 0, accent.Size.Y.Offset)
	accent.Position = dim2(0, math.round(keybind_holder.AbsolutePosition.X), 0, keybind_holder.AbsolutePosition.Y + keybind_holder.AbsoluteSize.Y + 59)
end

local function get_input_key(input)
if input.UserInputType == Enum.UserInputType.Keyboard then
	return input.KeyCode
end

return input.UserInputType
end

keybind_holder.MouseButton1Down:Connect(function()
task.wait()
text.Text = "..."

cfg.binding = library:connection(uis.InputBegan, function(input, game_event)
cfg.set(get_input_key(input))

cfg.binding:Disconnect()
cfg.binding = nil
end)
end)

keybind_holder.MouseButton2Down:Connect(function()
cfg.open = not cfg.open

cfg.set_visible(cfg.open)
end)

library:connection(uis.InputBegan, function(input)
local selected_key = get_input_key(input)
if selected_key == cfg.key then
	if cfg.mode == "Toggle" then
		cfg.active = not cfg.active
		cfg.set(cfg.active)
	elseif cfg.mode == "Hold" then
		cfg.set(true)
	end
end
end)

library:connection(uis.InputEnded, function(input)
local selected_key = get_input_key(input)
if selected_key == cfg.key then
	if cfg.mode == "Hold" then
		cfg.set(false)
	end
end

if input.UserInputType == Enum.UserInputType.MouseButton1 then
	if not (mouse_in_frame(keybind_holder) or mouse_in_frame(accent)) then
		cfg.open = false
		cfg.set_visible(false)
	end
end
end)

config_flags[cfg.flag] = cfg.set
cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})

return setmetatable(cfg, library)
end

function library:button(options)
	local cfg = {
	name = options.name or "button",
	callback = options.callback or function() end,
	}

	local frame = library:create("TextButton", {
	AnchorPoint = vec2(1, 0);
	Text = "";
	AutoButtonColor = false;
	Parent = self.elements;
	Position = dim2(1, 0, 0, 0);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, 0, 0, 16);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset[tostring(self.count)]
	}); library:apply_theme(frame, tostring(self.count), "BackgroundColor3")

	local frame_inline = library:create("Frame", {
	Parent = frame;
	Position = dim2(0, 1, 0, 1);
	BorderColor3 = rgb(0, 0, 0);
	Size = dim2(1, -2, 1, -2);
	BorderSizePixel = 0;
	BackgroundColor3 = themes.preset.inline
	}); library:apply_theme(frame_inline, "inline", "BackgroundColor3")

	local text = library:create("TextLabel", {
	FontFace = fonts["Tahoma12Pixel"];
	TextColor3 = rgb(255, 255, 255);
	BorderColor3 = rgb(0, 0, 0);
	Text = cfg.name;
	Parent = frame;
	Size = dim2(1, 0, 1, 0);
	BackgroundTransparency = 1;
	Position = dim2(0, 1, 0, -1);
	BorderSizePixel = 0;
	AutomaticSize = Enum.AutomaticSize.X;
	TextSize = 13;
	BackgroundColor3 = rgb(255, 255, 255)
	});

	frame.MouseButton1Click:Connect(function()
	cfg.callback()
end)

return setmetatable(cfg, library)
end


function library:init_config(window, target_column)
	local textbox;
	local config_column = target_column
	if not config_column then
		local config_tab = window:tab({name = "configs"})
		config_column = config_tab:column({})
	end

local section = config_column:section({name = "config", size = 1, default = true})
section:keybind({
name = "menu key",
flag = "menu_key",
key = Enum.KeyCode.Insert,
mode = "toggle",
force_toggle = true,
ignore = true,
callback = function(active)
window.toggle_menu(active)
end,
})
config_holder = section:dropdown({name = "config", options = {"Report", "This", "Error", "To", "Finobe"}, callback = function(option) if textbox then textbox.set(option) end end, flag = "config_name_list"}); library:update_config_list()
textbox = section:textbox({name = "Config name:", flag = "config_name_text"})
section:button({name = "Save", callback = function() writefile(library.directory .. "/configs/" .. flags["config_name_text"] .. ".cfg", library:get_config()) library:update_config_list() end})
section:button({name = "Load", callback = function() library:load_config(readfile(library.directory .. "/configs/" .. flags["config_name_text"] .. ".cfg"))  library:update_config_list() end})
section:button({name = "Delete", callback = function() delfile(library.directory .. "/configs/" .. flags["config_name_text"] .. ".cfg")  library:update_config_list() end})

local section = config_column:section({name = "theme", size = 1, default = true})

local refresh_theme_gradient = function()
library.gradient.Color = rgbseq{rgbkey(0, themes.preset["1"]), rgbkey(0.5, themes.preset["2"]), rgbkey(1, themes.preset["3"])}
library.watermark_gradient.Color = rgbseq{rgbkey(0, themes.preset["1"]), rgbkey(0.5, themes.preset["2"]), rgbkey(1, themes.preset["3"])}
end

local custom_picker_1, custom_picker_2, custom_picker_3

section:dropdown({
name = "theme",
flag = "theme",
items = {"morytania", "ancient", "new", "dark", "custom"},
whitelist = {"morytania", "ancient", "new", "dark", "custom"},
callback = function(value)
if custom_picker_1 then
	custom_picker_1.frame.Visible = value == "custom"
	custom_picker_2.frame.Visible = value == "custom"
	custom_picker_3.frame.Visible = value == "custom"

	if value == "custom" then
		custom_picker_1.set(themes.preset["1"])
		custom_picker_2.set(themes.preset["2"])
		custom_picker_3.set(themes.preset["3"])
	end
end

if value == "ancient" then
	local a1 = rgb(109, 78, 110)
	local a2 = rgb(54, 82, 114)
	local a3 = rgb(0, 88, 126)

	library:update_theme("1", a1)
	library:update_theme("2", a2)
	library:update_theme("3", a3)

	library.gradient.Color = rgbseq{
	rgbkey(0, a1),
	rgbkey(0.5, a2),
	rgbkey(1, a3),
	};

	library.watermark_gradient.Color = rgbseq{
	rgbkey(0, a1),
	rgbkey(0.5, a2),
	rgbkey(1, a3),
	};
elseif value == "new" then
	local n1 = hex("#360820")
	local n2 = hex("#360820")
	local n3 = hex("#360820")

	library:update_theme("1", n1)
	library:update_theme("2", n2)
	library:update_theme("3", n3)

	library.gradient.Color = rgbseq{
	rgbkey(0, n1),
	rgbkey(0.5, n2),
	rgbkey(1, n3),
	};

	library.watermark_gradient.Color = rgbseq{
	rgbkey(0, n1),
	rgbkey(0.5, n2),
	rgbkey(1, n3),
	};
elseif value == "dark" then
	local g = hex("#1D1D1D")

	library:update_theme("1", g)
	library:update_theme("2", g)
	library:update_theme("3", g)

	library.gradient.Color = rgbseq{
	rgbkey(0, g),
	rgbkey(0.5, g),
	rgbkey(1, g),
	};

	library.watermark_gradient.Color = rgbseq{
	rgbkey(0, g),
	rgbkey(0.5, g),
	rgbkey(1, g),
	};
else
	local m1 = hex("#245771")
	local m2 = hex("#215D63")
	local m3 = hex("#1E6453")

	library:update_theme("1", m1)
	library:update_theme("2", m2)
	library:update_theme("3", m3)

	library.gradient.Color = rgbseq{
	rgbkey(0, m1),
	rgbkey(0.5, m2),
	rgbkey(1, m3),
	};

	library.watermark_gradient.Color = rgbseq{
	rgbkey(0, m1),
	rgbkey(0.5, m2),
	rgbkey(1, m3),
	};
end
end,
default = "morytania"
})

custom_picker_1 = section:colorpicker({name = "1", flag = "custom_1", color = themes.preset["1"], callback = function(color)
library:update_theme("1", color)
refresh_theme_gradient()
end})
custom_picker_2 = section:colorpicker({name = "2", flag = "custom_2", color = themes.preset["2"], callback = function(color)
library:update_theme("2", color)
refresh_theme_gradient()
end})
custom_picker_3 = section:colorpicker({name = "3", flag = "custom_3", color = themes.preset["3"], callback = function(color)
library:update_theme("3", color)
refresh_theme_gradient()
end})

custom_picker_1.frame.Visible = false
custom_picker_2.frame.Visible = false
custom_picker_3.frame.Visible = false
end

end


return library
