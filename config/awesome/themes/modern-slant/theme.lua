
--[[
     
     modern slant - by github.com/jreeee - based off of 
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
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/modern-slant"
theme.wallpaper 								= "/home/jre/the-folder/misc/steampunk.jpg"
theme.font										= "FiraCode Nerd Font 9"
theme.fg_normal 								= "#a1a161" -- color13
theme.fg_focus 									= "#ecbbb4" -- color6
theme.fg_urgent 								= "#dcdca4" -- color3
theme.bg_normal 								= "#19191980" -- termite background when in rgba
theme.bg_focus 									= "#19191980" -- color6 with transparency
theme.bg_urgent 								= "#dcdca480" -- color3 with transparency
theme.border_width                              = dpi(1)
theme.border_normal 							= "#498a86" -- color10
theme.border_focus 								= "#a1a161" -- color14
theme.border_marked 							= "#c96154" -- color1
theme.tasklist_bg_normal						= "#00000000"
theme.tasklist_bg_focus                         = "#00000000" --theme.bg_normal
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.taskbar_fg 								= "#e5dfdf" -- color7
theme.taskbar_bg 								= "#3e4035" -- color0
theme.bg_systray								= theme.taskbar_fg --does not work with rgba so i improvised a bit
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(130)
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
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = dpi(0)

local markup = lain.util.markup

local keyboardlayout = awful.widget.keyboardlayout:new()

--local volume_widget = require("awesome-wm-widgets.volume-widget.volume")

--local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")

--local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness") --TODO

--local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")

--local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")

--local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")

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
	t_bg = theme.taskbar_fg,
	t_fg = theme.taskbar_bg,
	t_br = theme.fg_focus,
	t_dt = theme.border_normal,
    theme = 'custom',
    placement = 'bottom_right',
    radius = 8,
})

clock:connect_signal("button::press", 
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
   	end)

-- Separators
local spr = wibox.widget.textbox(' ')
local spr2 = wibox.widget.textbox(markup.font("Fira Code Nerd Font 12", ""))
local spr1 = wibox.widget.textbox(markup.font("Fira Code Nerd Font 12", ""))

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
    s.mypromptbox = awful.widget.prompt({
		bg = theme.taskbar_fg,
		fg = theme.taskbar_bg,
		prompt = 'ᐅ ', 
		bg_cursor = theme.fg_urgent
		})
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
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = dpi(18), bg = theme.bg_normal, fg = theme.taskbar_fg })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
			spr2,
			spr,
            s.mytaglist,
			spr1,
			wibox.container.background(spr, theme.taskbar_fg),
			s.mypromptbox,
			spr2
        },
	        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
			spr1,
			wibox.container.background(wibox.widget.systray(), theme.taskbar_fg),
			spr2,
			spr,
 --[[           volume_widget({
				widget_type = 'arc',
				with_icon = 'false',
                main_color = theme.taskbar_fg,
                bg_color = theme.taskbar_bg,
                mute_color = theme.border_marked
            }),
			spr,
  --brightness_widget({
    --            type = 'arc',
      --          program = 'xbacklight',
        --        step = '1',
		--		path_to_icon = '',
          --      bg_color = theme.taskbar_bg
            --}),
            ram_widget({
                color_used = theme.taskbar_bg,
                color_free = theme.taskbar_fg,
                color_buf = theme.border_normal
            }),
            cpu_widget({
				color = theme.taskbar_bg,
                foreground_color = theme.taskbar_fg,
				background_color = theme.bg_normal
            }),
			spr,
--            batteryarc_widget({
  --             main_color = theme.taskbar_fg,
    --            bg_color = theme.taskbar_bg,
	--			charging_color = theme.border_focus,
      --          low_level_color = theme.border_marked,
		--		show_notification_mode = 'on_click',
		--		stop_video_after = 95
		--	}),
		--	spr,
			spr1,
			{
            	net_speed_widget(),
				bg = theme.taskbar_fg,
				fg = theme.taskbar_bg,
				widget = wibox.container.background
			}, --]]
			spr2,
			spr,
            clock,
            spr1,
			{
				keyboardlayout,
				bg = theme.taskbar_fg,
				fg = theme.taskbar_bg,
				widget = wibox.container.background
			},
			{
				s.mylayoutbox,
				bg = theme.taskbar_fg,
				fg = theme.fg_urgent,
				widget = wibox.container.background
			},
        },
    }
end

return theme
