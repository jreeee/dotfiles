--[[

     Multicolor Awesome WM theme 2.0
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
theme.confdir                                   = os.getenv("HOME") .. "/.config/awesome/themes/multicolor"
theme.wallpaper 								= "/home/jre/git/dotfiles/misc/themes/wallpapers/wall1.png"

--[[ theme.menu_bg_normal                            = "#000000"
theme.menu_bg_focus                             = "#000000"
theme.bg_normal 								= "#0a0a0ab3" -- termite background when in rgba
theme.bg_focus 									= "#0a0a0ab3" -- color6 with transparency
theme.bg_urgent 								= "#B9372Bb3" -- color3 with transparency
theme.fg_normal 								= "#E3D198" -- color13
theme.taskbar_fg				= "#aaaaaa"
theme.fg_focus 									= "#C7953C" -- color6
theme.fg_urgent 								= "#B9372B" -- color3
theme.fg_minimize                               = "#ffffff"
theme.border_width                              = dpi(1)
theme.border_normal 							= "#455e7e" -- color10
theme.border_focus 								= "#E3D198" -- color14
theme.border_marked 							= "#74B8D3" -- color1
theme.menu_border_width                         = 0
theme.menu_width                                = dpi(130)
theme.menu_submenu_icon                         = theme.confdir .. "/icons/submenu.png"
theme.menu_fg_normal                            = "#aaaaaa"
theme.menu_fg_focus                             = "#ff8c00"
theme.menu_bg_normal                            = "#050505dd"
theme.menu_bg_focus                             = "#050505dd"
--]]

theme.font                                                                              = "FiraCode Nerd Font Mono 9"
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
theme.tasklist_bg_normal                                                = "#00000000"
theme.tasklist_bg_focus                         = "#00000000" --theme.bg_normal
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.taskbar_fg 								= "#B7BD99" -- color7
theme.taskbar_bg 								= "#36382E" -- color0
theme.bg_systray                                                                = theme.taskbar_fg --does not work with rgba so i improvised a bit

theme.widget_temp                               = theme.confdir .. "/icons/temp.png"
theme.widget_uptime                             = theme.confdir .. "/icons/ac.png"
theme.widget_cpu                                = theme.confdir .. "/icons/cpu.png"
theme.widget_weather                            = theme.confdir .. "/icons/dish.png"
theme.widget_fs                                 = theme.confdir .. "/icons/fs.png"
theme.widget_mem                                = theme.confdir .. "/icons/mem.png"
theme.widget_note                               = theme.confdir .. "/icons/note.png"
theme.widget_note_on                            = theme.confdir .. "/icons/note_on.png"
theme.widget_netdown                            = theme.confdir .. "/icons/net_down.png"
theme.widget_netup                              = theme.confdir .. "/icons/net_up.png"
theme.widget_mail                               = theme.confdir .. "/icons/mail.png"
theme.widget_batt                               = theme.confdir .. "/icons/bat.png"
theme.widget_clock                              = theme.confdir .. "/icons/clock.png"
--theme.widget_vol                                = theme.confdir .. "/icons/spkr.png"
theme.taglist_squares_sel                       = theme.confdir .. "/icons/square_a.png"
theme.taglist_squares_unsel                     = theme.confdir .. "/icons/square_b.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = 10
theme.layout_tile                               = theme.confdir .. "/icons/tile.png"
theme.layout_tilegaps                           = theme.confdir .. "/icons/tilegaps.png"
theme.layout_tileleft                           = theme.confdir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.confdir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.confdir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.confdir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.confdir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.confdir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.confdir .. "/icons/dwindle.png"
theme.layout_max                                = theme.confdir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.confdir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.confdir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.confdir .. "/icons/floating.png"
theme.titlebar_close_button_normal              = theme.confdir .. "/icons/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = theme.confdir .. "/icons/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal           = theme.confdir .. "/icons/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = theme.confdir .. "/icons/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive     = theme.confdir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme.confdir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme.confdir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = theme.confdir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive    = theme.confdir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme.confdir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme.confdir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = theme.confdir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive  = theme.confdir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme.confdir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme.confdir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = theme.confdir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "/icons/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.confdir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme.confdir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = theme.confdir .. "/icons/titlebar/maximized_focus_active.png"

local markup = lain.util.markup

local keyboardlayout = awful.widget.keyboardlayout:new()

local volume_widget = require("awesome-wm-widgets.volume-widget.volume")

local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")

local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")

local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")

local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")

local mpris_widget = require("awesome-wm-widgets.mpris-widget")

-- Textclock
--os.setlocale(os.getenv("LANG")) -- to localize the clock
--local clockicon = wibox.widget.imagebox(theme.widget_clock)
--local mytextclock = wibox.widget.textclock(markup("#7788af", "%A %d %B ") .. markup("#ab7367", ">") .. markup("#de5e1e", " %H:%M "))
--mytextclock.font = theme.font

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font = "xos4 Terminus 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

--[[ Weather
local weathericon = wibox.widget.imagebox(theme.widget_weather)
theme.weather = lain.widget.weather({
    city_id = 2643743, -- placeholder (London)
    notification_preset = { font = "xos4 Terminus 10", fg = theme.fg_normal },
    weather_na_markup = markup.fontfg(theme.font, "#eca4c4", "N/A "),
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fontfg(theme.font, "#eca4c4", descr .. " @ " .. units .. "°C "))
    end
})
--]]

-- / fs
--[[ commented because it needs Gio/Glib >= 2.54
local fsicon = wibox.widget.imagebox(theme.widget_fs)
theme.fs = lain.widget.fs({
    notification_preset = { font = "xos4 Terminus 10", fg = theme.fg_normal },
    settings  = function()
        widget:set_markup(markup.fontfg(theme.font, "#80d9d8", string.format("%.1f", fs_now["/"].used) .. "% "))
    end
})
--]]

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

-- Mail IMAP check
--[[ commented because it needs to be set before use
local mailicon = wibox.widget.imagebox()
theme.mail = lain.widget.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        if mailcount > 0 then
            mailicon:set_image(theme.widget_mail)
            widget:set_markup(markup.fontfg(theme.font, "#cccccc", mailcount .. " "))
        else
            widget:set_text("")
            --mailicon:set_image() -- not working in 4.0
            mailicon._private.image = nil
            mailicon:emit_signal("widget::redraw_needed")
            mailicon:emit_signal("widget::layout_changed")
        end
    end
})
--]]

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#e33a6e", cpu_now.usage .. "% "))
    end
})

-- Coretemp
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#f1af5f", coretemp_now .. "°C "))
    end
})

-- Textclock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
    "date +'%a %d %b %R'", 60,
    function(widget, stdout)
        widget:set_markup(markup.font(theme.font, stdout))
    end
)
clock:connect_signal("button::press", 
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
   	end)

-- Net
local netdownicon = wibox.widget.imagebox(theme.widget_netdown)
local netdowninfo = wibox.widget.textbox()
local netupicon = wibox.widget.imagebox(theme.widget_netup)
local netupinfo = lain.widget.net({
    settings = function()
--[[        if iface ~= "network off" and
           string.match(theme.weather.widget.text, "N/A")
        then
            theme.weather.update()
        end
--]]
        widget:set_markup(markup.fontfg(theme.font, "#e54c62", net_now.sent .. " "))
        netdowninfo:set_markup(markup.fontfg(theme.font, "#87af5f", net_now.received .. " "))
    end
})

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#e0da37", mem_now.used .. "M "))
    end
})

-- MPD
local mpdicon = wibox.widget.imagebox()
theme.mpd = lain.widget.mpd({
    settings = function()
        mpd_notification_preset = {
            text = string.format("%s [%s] - %s\n%s", mpd_now.artist,
                   mpd_now.album, mpd_now.date, mpd_now.title)
        }

        if mpd_now.state == "play" then
            artist = mpd_now.artist .. " > "
            title  = mpd_now.title .. " "
            mpdicon:set_image(theme.widget_note_on)
        elseif mpd_now.state == "pause" then
            artist = "mpd "
            title  = "paused "
        else
            artist = ""
            title  = ""
            --mpdicon:set_image() -- not working in 4.0
            mpdicon._private.image = nil
            mpdicon:emit_signal("widget::redraw_needed")
            mpdicon:emit_signal("widget::layout_changed")
        end
        widget:set_markup(markup.fontfg(theme.font, "#e54c62", artist) .. markup.fontfg(theme.font, "#b2b2b2", title))
    end
})

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
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    fairv = awful.layout.suit.fair
    centerw = lain.layout.centerwork
    -- tag layout assignment
    awful.tag(awful.util.tagnames, s, {fairv, fairv, fairv, fairv, fairv, fairv, fairv})

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
                           awful.button({}, 1, function () awful.layout.inc(-1) end),
                           awful.button({}, 2, function () awful.layout.inc(-1) end),
                           awful.button({}, 3, function () awful.layout.set(awful.layout.layouts[3]) end),
                           awful.button({}, 4, function () awful.layout.inc(-1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = dpi(20), bg = theme.bg_normal, fg = theme.fg_normal })

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
            volume_widget({
                                widget_type = 'arc',
                                with_icon = 'false',
                main_color = theme.taskbar_fg,
                bg_color = theme.taskbar_bg,
                mute_color = theme.border_marked
            }),
            mpris_widget(),
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
            {

                net_speed_widget(),
                                widget = wibox.container.background
                        },
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
