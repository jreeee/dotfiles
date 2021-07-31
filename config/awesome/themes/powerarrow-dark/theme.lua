
--[[

     Powerarrow Dark Awesome WM theme
     github.com/lcpz

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/powerarrow-dark"
theme.wallpaper 								= "/home/jre/dotfiles/config/themes/wallpapers/wall1.png"
theme.font                                      = "Terminus 9"
theme.fg_normal 								= "#E3D198" -- color13
theme.fg_focus 									= "#C7953C" -- color6
theme.fg_urgent 								= "#B9372B" -- color3
theme.bg_normal 								= "#0a0a0ab3" -- termite background when in rgba
theme.bg_focus 									= "#0a0a0ab3" -- color6 with transparency
theme.bg_urgent 								= "#B9372Bb3" -- color3 with transparency
theme.border_width                              = dpi(1)
theme.border_normal 							= "#455e7e" -- color10
theme.border_focus 								= "#E3D198" -- color14
theme.border_marked 							= "#74B8D3" -- color1
theme.tasklist_bg_normal						= "#00000000"
theme.tasklist_bg_focus                         = "#00000000" --theme.bg_normal
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = dpi(0)
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

local markup = lain.util.markup
local separators = lain.util.separators

local keyboardlayout = awful.widget.keyboardlayout:new()

local volume_widget = require("awesome-wm-widgets.volume-widget.volume")

local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")

local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness") --TODO

local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")

local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")

local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")

local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")

-- Textclock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
    "date +'%a %d %b %R'", 60,
    function(widget, stdout)
        widget:set_markup(markup.font(theme.font, stdout))
    end
)

-- Calendar
local cw = calendar_widget({
	t_bg = theme.bg_normal,
	t_fg = theme.fg_normal,
	t_br = theme.border_normal,
	t_dt = theme.fg_focus,
    theme = 'custom',
    placement = 'bottom_right',
    radius = 8,
})

clock:connect_signal("button::press", 
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
   	end)

-- Separators
local spr     = wibox.widget.textbox(' ')
local spr2 = wibox.widget.textbox(markup.font("Fira Code Nerd Font 12", " "))
local spr1 = wibox.widget.textbox(markup.font("Fira Code Nerd Font 12", " "))

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, false)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = dpi(18), bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
			spr2,
			spr,
            s.mytaglist,
			spr1,
			wibox.container.background(spr, theme.fg_normal),
			spr2,
			spr,
			s.mypromptbox,
        },
	        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
			spr1,
			{  -- this is ugly and i don' like it but it does the job
				keyboardlayout,
				bg = theme.fg_normal,
				fg = theme.bg_normal,
				widget = wibox.container.background
			},
			spr2,
			spr,
            volume_widget({
				widget_type = 'arc',
				with_icon = 'false'
            }),
            brightness_widget({
                type = 'arc',
                program = 'xbacklight',
                step = '1',
				path_to_icon = ''
            }),
            ram_widget(),
            cpu_widget(),
			spr,
            batteryarc_widget({
				charging_color = theme.fg_normal
			}),
			spr,
			spr1,
			{
            	net_speed_widget(),
				bg = theme.fg_normal,
				fg = theme.bg_normal,
				widget = wibox.container.background
			},
			spr2,
			spr,
            clock,
            spr1,
			{
				s.mylayoutbox,
				bg = theme.fg_normal,
				fg = theme.fg_urgent,
				widget = wibox.container.background
			},
        },
    }
end

return theme
