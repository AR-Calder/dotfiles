-- Awesome Libs
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

-- My Includes
local helpers = require("helpers")

-- Start of keybind.lua
local keybindings = {}

-- Modifier Keys
super = "Mod4"
alt = "Mod1"
ctrl = "Control"
shift = "Shift"

-- Mouse 'Buttons'
left_mouse = 1
middle_mouse = 2
right_mouse = 3
scroll_down = 4
scroll_up = 5

-- ==============
-- MOUSE BINDINGS
-- ==============

keybindings.mousebindings = gears.table.join(

    -- Left mouse click
    --awful.button({ }, left_mouse, function() naughty.destroy_all_notifications() end),

    -- Middle mouse click
    awful.button({ }, middle_mouse, function() naughty.destroy_all_notifications() end),
    -- Right mouse click
    --awful.button({ }, right_mouse, function () mymainmenu:toggle() end),

    -- Scroll Wheel - Switch tags
    awful.button({ }, scroll_down, function () awful.tag.viewnext() end),
    awful.button({ }, scroll_up, function () awful.tag.viewprev() end)
)


-- ============
-- KEY BINDINGS
-- ============

keybindings.globalkeys = gears.table.join(
    -- awful.key({ super  }, "`",  hotkeys_popup.show_help,
    --        {description="show help", group="awesome"}),

    -- -----------
    -- EXPERIMENTS
    -- -----------
    -- awful.key({ super }, "0",
    --     function()
    --         local exp_color = ColourUtils.update(exper, perc)
    --
    --         naughty.notify({ preset = naughty.config.presets.info,
    --                          bg = exp_color,
    --                          title = "Colour Experiments",
    --                          text = "colour=" .. exp_color .. ", perc=" .. perc })
    --         perc = perc - 1
    --     end,
    --     {description = "color testing", group = "experiments"}
    -- ),

    ----------------
    -- FOCUS CLIENTS
    ----------------

    -- Focus leftwards client
    awful.key({ super }, "h",
        function ()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "focus-client"}
    ),
    -- Focus rightwards client
    awful.key({ super }, "l",
        function ()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "focus-client"}
    ),
    -- Focus upwards client
    awful.key({ super }, "k",
        function ()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "focus-client"}
    ),
    -- Focus downwards client
    awful.key({ super }, "j",
        function ()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "focus-client"}
    ),

    -- get urgent client
    awful.key({ super }, "u",
        awful.client.urgent.jumpto(),
        {description = "jump to urgent client", group = "focus-client"}
    ),

    -- get previous client
    awful.key({ super }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "focus-client"}
    ),

    ---------------
    -- SWAP CLIENTS
    ---------------

    -- Swap with leftwards client
    awful.key({ super, shift }, "h",
        function ()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local client_focus = client.focus
            if nil ~= client_focus and (current_layout == "floating" or client_focus.floating) then
                helpers.move_to_edge(client_focus, "left")
            else
                awful.client.swap.bydirection("left", client_focus, nil)
            end
        end,
        {description = "swap with left client", group = "swap-client"}),
  -- Swap with rightwards client
    awful.key({ super, shift }, "l",
        function ()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local client_focus = client.focus
            if nil ~= client_focus and (current_layout == "floating" or client_focus.floating) then
                helpers.move_to_edge(client_focus, "right")
            else
                awful.client.swap.bydirection("right", client_focus, nil)
            end
        end,
        {description = "swap with right client", group = "swap-client"}),
    -- Swap with upper client
    awful.key({ super, shift }, "k",
        function ()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local client_focus = client.focus
            if nil ~= client_focus and (current_layout == "floating" or client_focus.floating) then
                helpers.move_to_edge(client_focus, "up")
            else
                awful.client.swap.bydirection("up", client_focus, nil)
            end
        end,
        {description = "swap with upper client", group = "swap-client"}),
    -- Swap with lower client
    awful.key({ super, shift }, "j",
        function ()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local client_focus = client.focus
            if nil ~= client_focus and (current_layout == "floating" or client_focus.floating) then
                helpers.move_to_edge(client_focus, "down")
            else
                awful.client.swap.bydirection("down", client_focus, nil)
            end
        end,
        {description = "swap with lower client", group = "swap-client"}),

    -------------
    -- SET LAYOUT
    -------------

    -- Set max layout
    awful.key({ super }, "m",
        function()
            awful.layout.set(awful.layout.suit.max)
        end,
        {description = "set max layout", group = "layout"}),
    -- Set tiled layout
    awful.key({ super }, "t",
        function()
            awful.layout.set(awful.layout.suit.tile)
        end,
        {description = "set tiled layout", group = "layout"}),
    -- Set floating layout
    awful.key({ super }, "f",
        function()
            awful.layout.set(awful.layout.suit.floating)
        end,
        {description = "set floating layout", group = "layout"}),

    -- Next Layout
    awful.key({ super }, "space", function () awful.layout.inc( 1) end,
              {description = "next layout", group = "layout"}),
    -- Previous Layout
    awful.key({ super, ctrl }, "space", function () awful.layout.inc(-1) end,
              {description = "previous layout", group = "layout"}),

    ---------------
    -- MULTI-SCREEN
    ---------------

    -- Focus next screen
    awful.key({ super, ctrl }, "l",
        function ()
            awful.screen.focus_relative( 1)
        end,
        {description = "focus the next screen", group = "multi-screen"}),

    -- Focus previous screen
    awful.key({ super, ctrl }, "h",
      function ()
          awful.screen.focus_relative(-1)
      end,
      {description = "focus the previous screen", group = "multi-screen"}),

    -- -------
    -- AWESOME
    -- -------

    -- Restart Awesome
    awful.key({ ctrl, alt }, "r", awesome.restart,
        {description = "reload awesome", group = "awesome"}),
    -- Quit Awesome
    awful.key({ ctrl, alt }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    -- MAIN MENU
    -- awful.key({ super }, "w",
    --     function ()
    --         local temp = 1
    --       --TODO mymainmenu:show()
    --     end,
    --     {description = "show main menu", group = "awesome"}),
    -- Lua prompt
    awful.key({ ctrl, alt }, "x",
        function ()
            awful.prompt.run {
              prompt       = "Run Lua code: ",
              textbox      = awful.screen.focused().mypromptbox.widget,
              exe_callback = awful.util.eval,
              history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {description = "lua execute prompt", group = "awesome"}),

    -- Menubar
    awful.key({ ctrl, alt }, "p",
        function()
            menubar.show()
        end,
        {description = "show the menubar", group = "awesome"}),

    -- Lock screen
    awful.key({ ctrl, alt }, "l",
        function()
            awful.spawn.with_shell("i3lock")
        end,
        {description = "lock screen", group = "power"}),


    -----------
    -- LAUNCHER
    -----------

    -- Show rofi run prompt
    awful.key({ super }, "r",
        function ()
            --awful.screen.focused().mypromptbox:run()
            awful.spawn.with_shell("rofi -show run")
        end,
        {description = "rofi launcher run", group = "launcher"}),

    -- Show rofi window prompt
    awful.key({ super }, "d",
        function ()
              awful.spawn.with_shell("rofi -show window")
        end,
        {description = "rofi launcher windows", group = "launcher"}),
    -- Spawn terminal
    awful.key({ ctrl, alt }, "t",
        function ()
            awful.spawn(terminal)
        end,
      {description = "open a terminal", group = "launcher"}),
    -- Spawn ranger in a terminal
    awful.key({ }, "XF86Search",
        function()
            awful.spawn(terminal .. " -e ranger")
        end,
        {description = "ranger", group = "launcher"}),

    -- Spawn catfish (search)
    awful.key({super}, "XF86Search",
        function()
            awful.spawn.with_shell("catfish")
        end,
        {description = "catfish search", group = "launcher"}),



    -----------------
    -- MEDIA CONTROLS
    -----------------
    --TODO rebind

    -- Play/pause
    awful.key( { }, "XF86AudioPlay",
        function()
            awful.spawn.with_shell("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
        end,
        {description = "pause/resume playback", group = "media"}),

    -- Previous media
    awful.key( { }, "XF86AudioPrev",
        function()
            awful.spawn.with_shell("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
        end,
        {description = "resume playback", group = "media"}),

    -- Next media
    awful.key( { }, "XF86AudioNext",
        function()
            awful.spawn.with_shell("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
        end,
        {description = "resume playback", group = "media"}),

    -- Mute/unmute
    awful.key( { }, "XF86AudioMute",
        function()
            awful.spawn.with_shell("amixer -q -D pulse sset Master toggle")
        end,
        {description = "(un)mute volume", group = "volume"}),

    -- Lower volume
    awful.key( { }, "XF86AudioLowerVolume",
        function()
            awful.spawn.with_shell("amixer -D pulse sset Master 5%-")
        end,
        {description = "lower volume", group = "volume"}),

    -- Raise Volume
    awful.key( { }, "XF86AudioRaiseVolume",
        function()
            awful.spawn.with_shell("amixer -D pulse sset Master 5%+")
        end,
        {description = "raise volume", group = "volume"}),

    --------------
    -- SCREENSHOTS TODO
    --------------

    -- Full screenshot
    awful.key( { }, "Print",
        function()
            awful.spawn.with_shell("xfce4-screenshooter --fullscreen")
        end,
        {description = "take full screenshot", group = "screenshot"}),

    -- Screen clipping to file
    awful.key( { super }, "Print",
        function()
            awful.spawn.with_shell("xfce4-screenshooter --region")
        end,
        {description = "select area to capture", group = "screenshot"}),

    -- Screen clipping to clipboard
    awful.key( { super, ctrl }, "Print",
        function()
            awful.spawn.with_shell("xfce4-screenshooter --region --clipboard")
        end,
        {description = "select area to copy to clipboard", group = "screenshot"}),

    -- Screen clipping to gimp
    awful.key( { super, shift }, "Print",
        function()
            awful.spawn.with_shell("xfce4-screenshooter --region --open gimp")
        end,
        {description = "select area to edit with gimp", group = "screenshot"})

)
-- ===============
-- Client Bindings
-- ===============
clientkeys = gears.table.join(
    -- Fullscreen
    awful.key({ super,           }, "Up",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    -- Minimize
    awful.key({ super,           }, "Down",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    -- Kill Client
    -- I consider it a logical increment of ctrl w = close tab
    awful.key({ ctrl, shift   }, "w",
        function (c)
            c:kill()
        end,
        {description = "kill", group = "client"}),
    -- Toggle Client Floating
    awful.key({ super, shift }, "f",
        awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}),
)


-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ super }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = tags[i]
                        if tag then
                           sharedtags.viewonly(tag, screen)
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Move client to tag.
        awful.key({ super, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ super, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

keybindings.clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ super }, 1, awful.mouse.client.move),
    awful.button({ super }, 3, awful.mouse.client.resize)
)


-- Set keys
root.keys(keybindings.globalkeys)
root.buttons(keybindings.mousebindings)


return keybindings
