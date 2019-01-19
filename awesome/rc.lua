--     __    ____        ___    __    __    ____  ____  ____/ ___
--    /__\  (  _ \ ___  / __)  /__\  (  )  (  _ \( ___)(  _ \/ __)
--   /(__)\  )   /(___)( (__  /(__)\  )(__  )(_) ))__)  )   /\__ \
--  (__)(__)(_)\_)      \___)(__)(__)(____)(____/(____)(_)\_)(___/
--   ____   ___    __    __  __    __
--  (  _ \ / __)  (  )  (  )(  )  /__\
--   )   /( (__    )(__  )(__)(  /(__)\
--  (_)\_) \___)()(____)(______)(__)(__)


-- ---------------------
-- Standard Requirements
-- ---------------------
-- Standard awesome library
local gears     = require("gears")
local awful     = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox     = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty   = require("naughty")
-- Awesome Main Menu
local menubar   = require("menubar")
-- Enable hotkeys help widget
local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")

-- -----------
-- My Includes
-- -----------
-- Utils - My helper file equivalent
local Utils = require("Utils")
-- Utilities specifically related to colours e.g. gradients
local ColourUtils = require("ColourUtils")
-- Key and mouse bindings
local Bindings = require("Bindings")
-- `sharedtags` - allowing tags to be shared across screens
local sharedtags = require("lib/sharedtags")

-- ==============
-- Error Handling
-- ==============
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


-- =======================
-- Application Preferences
-- =======================
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- Basic Applications
terminal          = "xfce4-terminal"
gui_editor        = "atom"
gui_editor_cmd    = terminal .. " -e " .. gui_editor
editor            = "nano"

-- Music Applications
spotify           = "spotify"

-- File System
file_search       = "catfish"
file_browser      = terminal .. " -e ranger"
gui_file_browser  = "thunar"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.max
}

-- =============
-- Notifications
-- =============

-- Icon size
naughty.config.defaults['icon_size'] = beautiful.notification_icon_size

-- Timeouts
naughty.config.defaults.timeout         = 5
naughty.config.presets.low.timeout      = 2
naughty.config.presets.critical.timeout = 10

-- Apply theme variables
naughty.config.padding               = beautiful.notification_padding
naughty.config.spacing               = beautiful.notification_spacing
naughty.config.defaults.margin       = beautiful.notification_margin
naughty.config.defaults.border_width = beautiful.notification_border_width


naughty.config.presets.ok   = naughty.config.presets.low
naughty.config.presets.info = naughty.config.presets.low
naughty.config.presets.warn = naughty.config.presets.normal

naughty.config.presets.low = {
    font         = beautiful.notification_font,
    fg           = beautiful.notification_fg,
    bg           = beautiful.notification_bg,
    border_width = beautiful.notification_border_width,
    margin       = beautiful.notification_margin,
    position     = beautiful.notification_position
}

naughty.config.presets.normal = {
    font         = beautiful.notification_font,
    fg           = beautiful.notification_fg,
    bg           = beautiful.notification_bg,
    border_width = beautiful.notification_border_width,
    margin       = beautiful.notification_margin,
    position     = beautiful.notification_position
}

naughty.config.presets.critical = {
    font         = beautiful.notification_font,
    fg           = beautiful.notification_crit_fg,
    bg           = beautiful.notification_crit_bg,
    border_width = beautiful.notification_border_width,
    margin       = beautiful.notification_margin,
    position     = beautiful.notification_position
}


-- =========
-- Main Menu
-- =========
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", gui_editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

-- add myawesomemenu to the main menu
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })
-- define launcher for `on connect_for_each_screen`
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ super }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ super }, 3, function(t)
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
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end


-- ------------
-- Screen Setup
-- ------------

tags = sharedtags({
    { name = "home", screen = 1, layout = awful.layout.layouts[1] },
    { name = "dev", screen = 1, layout = awful.layout.layouts[2] },
    { name = "www", screen = 2, layout = awful.layout.layouts[2] },
    { name = "music", screen = 2, layout = awful.layout.layouts[2] },
    { name = "games", screen = 2, layout = awful.layout.layouts[3] },
    { name = "misc", screen = 2, layout = awful.layout.layouts[2] }
})

tag_count = Utils.tableLen(tags)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Screen Initialization function
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- use same config for all tags
    --awful.tag(tag_names, s, layouts)

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
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- ============
-- Client Rules
-- ============
awful.rules.rules = {

    -- -----------
    -- All clients
    -- -----------
    {   rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },
    -- Add titlebars to normal clients and dialogs
    {   rule_any = {
            type = {
                "normal",
                "dialog"
            }
        },
        properties = {
            titlebars_enabled = true
        }
    },

    -- ----------------
    -- Floating clients.
    -- ----------------
    {   rule_any = {
            class = {
              "Galculator",
              "NetworkManager",
              "Xfce4-settings"
             },

             name = {
                 "Event Tester",  -- xev.
             },
             role = {
                 "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
             }
        },
        properties = {
            floating = true
        }
    },

    -- ------------------
    -- Fullscreen clients
    -- ------------------
    {   rule_any = {
            class = {
                "vlc",
            },
        },
        properties = {
            fullscreen = true
        }
    },

    -- ----------------
    -- Centered clients
    -- ----------------
    -- TODO
    -- {   rule_any = {
    --         type = {
    --
    --         },
    --         class = {
    --
    --         },
    --         name = {
    --
    --         },
    --         role = {
    --
    --         }
    --     },
    --     properties = {},
    --     callback = function (c)
    --         awful.placement.centered(c,{honor_workarea=true})
    --     end
    -- },

    -- -------------
    -- Titlebars OFF
    -- -------------
    {   rule_any = {
            class = {
                "qutebrowser",
                "Atom"
            },
        },
        properties = {},
        callback = function (c)
            if not beautiful.titlebars_imitate_borders then
                awful.titlebar.hide(c, beautiful.titlebar_position)
            end
        end
    },

    -- ------------
    -- Titlebars ON
    -- ------------
    {   rule_any = {
            class = {
                -- TODO
            },
            name = {
                -- TODO
            },
        },
        properties = {},
        callback = function (c)
            awful.titlebar.show(c, beautiful.titlebar_position)
        end
    },

    -- ----------------
    -- Tag App Defaults
    -- ----------------
    -- Tag 1 - `Home`
    {   rule = {
            class = {
                "Slack",
                "TaskManager"
            }
        },
        properties = {
            --screen = 1,
            tag = tags[1]
        }
    },
    -- Tag 2 - `web`
    {   rule = {
            class = {
                "Firefox",
                "Chromium-browser",
                "qutebrowser"
            }
        },
        properties = {
            --screen = 1,
            tag = tags[2]
        }
    },
    -- Tag 3 - `dev`
    {   rule = {
            class = {
                "Atom"
            }
        },
        properties = {
            --screen = 1,
            tag = tags[3]
        }
    },
    -- Tag 4 - `music`
    {   rule = {
            class = {
                "Spotify"
            }
        },
        properties = {
            --screen = 1,
            tag = tags[4]
        }
    },
    -- Tag 5 - `games`
    {   rule = {
            class = {
                "Steam"
            }
        },
        properties = {
            --screen = 1,
            tag = tags[5]
        }
    }
    -- Tag 6- `misc`
    {   rule = {
            class = {
                "shutter"
            }
        },
        properties = {
            --screen = 1,
            tag = tags[6]
        }
    }
}
-- }}}

-- -------------
-- On New client
-- -------------
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    -- Hide titlebars if required by the theme
    if not beautiful.titlebars_enabled then
        awful.titlebar.hide(c, beautiful.titlebar_position)
    end

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.minimizebutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--         and awful.client.focus.filter(c) then
--         client.focus = c
--     end
-- end)

-- Here and below - borrowed from elenapan/dotfiles

-- Rounded corners
if beautiful.border_radius ~= 0 then
    client.connect_signal("manage", function (c, startup)
        if not c.fullscreen then
            c.shape = helpers.rrect(beautiful.border_radius)
        end
    end)

    -- Fullscreen clients should not have rounded corners
    client.connect_signal("property::fullscreen", function (c)
        if c.fullscreen then
            c.shape = helpers.rect()
        else
            c.shape = helpers.rrect(beautiful.border_radius)
        end
    end)
end

client.connect_signal("manage", function(c)
  if c.fullscreen then
    gears.timer.delayed_call(function()
      if c.valid then
        c:geometry(c.screen.geometry)
      end
    end)
  end
end)

-- Apply shapes
beautiful.notification_shape = helpers.rrect(beautiful.notification_border_radius)
beautiful.snap_shape = helpers.rrect(beautiful.border_radius * 2)
beautiful.taglist_shape = helpers.rrect(beautiful.taglist_item_roundness)


client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Floating: restore geometry
tag.connect_signal('property::layout',
    function(t)
        for k, c in ipairs(t:clients()) do
            if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
                -- Geometry x = 0 and y = 0 most probably means that the
                -- clients have been spawned in a non floating layout, and thus
                -- they don't have their floating_geometry set properly.
                -- If that is the case, don't change their geometry
                local cgeo = awful.client.property.get(c, 'floating_geometry')
                if cgeo ~= nil then
                    if not (cgeo.x == 0 and cgeo.y == 0) then
                        c:geometry(awful.client.property.get(c, 'floating_geometry'))
                    end
                end
                --c:geometry(awful.client.property.get(c, 'floating_geometry'))
            end
        end
    end
)

client.connect_signal('manage',
    function(c)
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            awful.client.property.set(c, 'floating_geometry', c:geometry())
        end
    end
)

client.connect_signal('property::geometry',
    function(c)
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            awful.client.property.set(c, 'floating_geometry', c:geometry())
        end
    end
)

-- Make rofi able to unminimize minimized clients
-- Note: causes clients to unminimize after restarting awesome
client.connect_signal("request::activate",
    function(c, context, hints)
        if c.minimized then
            c.minimized = false
        end
        awful.ewmh.activate(c, context, hints)
    end
)

-- ===
-- END
-- ===
