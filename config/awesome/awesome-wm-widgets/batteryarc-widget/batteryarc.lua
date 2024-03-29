-------------------------------------------------
-- Battery Arc Widget for Awesome Window Manager
-- Shows the battery level of the laptop
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/batteryarc-widget

-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local HOME = os.getenv("HOME")
local WIDGET_DIR = HOME .. '/.config/awesome/awesome-wm-widgets/batteryarc-widget'
local BATTERY_CMD = [[bash -c "acpi"]]

local VIDEO_SCRIPT = HOME .. '/dotfiles/scripts/an-bg.sh'
local playing = false

local batteryarc_widget = {}

local function worker(user_args)

    local args = user_args or {}

    local font = args.font or 'Play 6'
    local arc_thickness = args.arc_thickness or 2
    local show_current_level = args.show_current_level or false
    local size = args.size or 18
    local timeout = args.timeout or 20
    local show_notification_mode = args.show_notification_mode or 'on_hover' -- on_hover / on_click

    local main_color = args.main_color or beautiful.fg_color
    local bg_color = args.bg_color or '#ffffff11'
    local low_level_color = args.low_level_color or '#e53935'
    local charging_color = args.charging_color or '#43a047'

    local warning_msg_title = args.warning_msg_title or 'Careful - Low Energy'
    local warning_msg_position = args.warning_msg_position or 'bottom_right'
    local warning_msg_icon = args.warning_msg_icon or WIDGET_DIR .. '/ganyu.png'
    local enable_battery_warning = args.enable_battery_warning
    if enable_battery_warning == nil then
        enable_battery_warning = true
    end

    local stop_video_after = args.stop_video_after or 95

    local text = wibox.widget {
        font = font,
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }

    local text_with_background = wibox.container.background(text)

    batteryarc_widget = wibox.widget {
        text_with_background,
        max_value = 100,
        rounded_edge = true,
        thickness = arc_thickness,
        start_angle = 4.71238898, -- 2pi*3/4
        forced_height = size,
        forced_width = size,
        bg = bg_color,
        paddings = 2,
        widget = wibox.container.arcchart
    }

    local last_battery_check = os.time()

    --[[ Show warning notification ]]
    local function show_battery_warning(charge)
        naughty.notify {
            icon = warning_msg_icon,
            icon_size = 100,
            text = 'Only ' .. charge .. '% left',
            title = warning_msg_title,
            timeout = 25, -- show the warning for a longer time
            hover_timeout = 0.5,
            position = warning_msg_position,
            bg = low_level_color,
            fg = bg_color,
            width = 300,
        }
    end

    local function update_widget(widget, stdout)
        local charge = 0
        local status
        for s in stdout:gmatch("[^\r\n]+") do
            local cur_status, charge_str, _ = string.match(s, '.+: (%a+), (%d?%d?%d)%%,?(.*)')
            if cur_status ~= nil and charge_str ~= nil then
                local cur_charge = tonumber(charge_str)
                if cur_charge > charge then
                    status = cur_status
                    charge = cur_charge
                end
            end
        end

        widget.value = charge

        if status == 'Charging' then
            text_with_background.bg = charging_color
            text_with_background.fg = '#000000'
			if not playing then
				awful.spawn.easy_async("bash " .. VIDEO_SCRIPT .. " c", function() end)
				playing = true
			end
        else
            text_with_background.bg = '#00000000'
            text_with_background.fg = main_color
			if playing and charge < stop_video_after then
                awful.spawn.easy_async("bash " .. VIDEO_SCRIPT .. " s", function() end)
				playing = false
			end
        end

        if show_current_level == true then
            --- if battery is fully charged (100) there is not enough place for three digits, so we don't show any text
            text.text = charge == 100
                    and ''
                    or string.format('%d', charge)
        else
            text.text = ''
        end

        if charge < 20 then
            widget.colors = { low_level_color }
            if enable_battery_warning and status ~= 'Charging' and os.difftime(os.time(), last_battery_check) > 300 then
                -- if 5 minutes have elapsed since the last warning - 300
                last_battery_check = os.time()

                show_battery_warning(charge)
            end
        else
            widget.colors = { main_color }
        end
    end

    watch("acpi", timeout, update_widget, batteryarc_widget)

    -- actual Popup with battery info

	local popup = awful.popup {
		ontop = true,
		visible = false,
		fg = bg_color,
		bg = main_color,
		opacity = 0.8,
		widget = {},
		offset = { z = 20 },
		hide_on_right_click = true
	}

	local update_widget = function(stdout, _, _, _)
		popup:setup {
			{
				markup = "<b>Battery status</b>\n" .. stdout,
				align = 'center',
				forced_width = 170,
				widget = wibox.widget.textbox
			},
			margins = 10,
			widget  = wibox.container.margin
		}
	end

	batteryarc_widget:buttons(
		awful.util.table.join(
			awful.button({}, 1, function()
				if popup.visible then
					popup.visible = not popup.visible
				else
					awful.spawn.easy_async(BATTERY_CMD, 
						function(stdout)
							update_widget(stdout)
							popup:move_next_to(mouse.current_widget_geometry)
					end)
				end
            end)
        )
    )

    return batteryarc_widget

end

return setmetatable(batteryarc_widget, { __call = function(_, ...)
    return worker(...)
end })
