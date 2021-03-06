-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- load keys externally
local keys = require("keys")

-- load rules externally
local rules = require("rules")

-- widgets
local wifi_widget = require("widgets.wifi")
-- local test = require("key_notifications.base")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%d.%m.%y  -  %H:%M")

local cal_shape = function(cr, width, height)
  --gears.shape.infobubble(cr, width, height, 12)
  gears.shape.partially_rounded_rect(
    cr,
    width,
    height,
    false,
    false,
    false,
    false,
    12)
end

local cal_item_shape = function(cr, width, height)
        gears.shape.circle(
                cr,
                width,
                height
                )
end


-- Calendar Widget
local month_calendar = awful.widget.calendar_popup.year({
    start_sunday = false,
-- 	spacing = 10,
    font = beautiful.font,
    long_weekdays = false,
    margin = 0, -- 10
    style_month = { border_width = 0, padding = 10, shape = cal_shape, padding = 20 },
    style_year = { border_width = 0, padding = 10, shape = cal_shape, padding = 20 },
    style_yearheader = { border_width = 0, padding = 10, shape = cal_shape, padding = 20 },
    style_header = { border_width = 0, bg_color = '#00000000' },
    style_weekday = { border_width = 0, bg_color = '#00000000' },
    style_normal = { border_width = 0, bg_color = '#00000000' },
    style_focus = { border_width = 0, bg_color = beautiful.green, shape = cal_item_shape, padding = 5, fg_color = beautiful.fg_normal },
    style_weeknumber = { border_width = 0, bg_color = '#00000000', fg_color = beautiful.yellow },
    week_numbers = true,

    })
    month_calendar:attach( mytextclock, "tc" , { on_pressed = true, on_hover = false })

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

screen.connect_signal("property::geometry", awesome.restart)

awful.screen.connect_for_each_screen(function(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[4])
    local function stylize_count(self, t, index, objects)
            local conversion_table = {" ", "", "", "", "", "", "" }
--            local conversion_table = {"0", "1", "2", "3", "4", "5", "6", "7", "8"}
            local clientcount = #t:clients()+1
            local text = ""
            if (clientcount > #conversion_table)
                then
                    text = "+"
                else
                    text = conversion_table[clientcount]
                end
            self:get_children_by_id('window_count')[1].markup = text
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        layout = {
                layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
        {
            {
                {
                        {
                            id     = 'window_count',
                            widget = wibox.widget.textbox,
                            font = "Overpass 20",
                        },
                        margins = 5,
                        widget  = wibox.container.margin,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            left  = -1,
            right = -1,
            widget = wibox.container.margin
        },
        id     = 'background_role',
        widget = wibox.container.background,
        create_callback = stylize_count,
        update_callback = stylize_count,
    },
    buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, width = s.geometry.width, height = 27 })

    -- systray
    s.systray = wibox.widget.systray()
    s.systray.visible = false

    -- Add widgets to the wibox
    s.mywibox:setup {
        expand = "none",
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        mytextclock,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wifi_widget,
            s.systray,
            s.mylayoutbox, -- der Layout-Indikator
        },
    }
end)
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Autostart
awful.spawn.with_shell("$HOME/Scripts/autorun.sh")
