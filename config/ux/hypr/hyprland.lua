for k, v in pairs(hl) do _G[k] = v end
for k, v in pairs(dsp) do _G[k] = v end

jump = require "util.jump"
monitor = require "util.monitor"

local ct = "rgba(00000000)"
local cs = "rgba(00000033)"
local ch = "rgba(ffffff66)"

local util = "~/.local/share/ux/bind"

for _, c in ipairs {
    "com.network.manager",
    "nm-connection-editor",
    "com.ezratweaver.AdwBluetooth",
    "com.saivert.pwvucontrol",
} do window_rule { match = { class = c }, float = true, pin = true } end

for _, c in ipairs {
    "steam_app_.*",
    "wlvncc",
} do window_rule { match = { class = c }, fullscreen = true } end

config {
    general = {
        gaps_in = -1,
        gaps_out = 0,
        border_size = 2,

        col = {
            active_border = { colors = { ch, ct, ct, ct, ct, ct, ct, ct, ch } },
            inactive_border = cs,
        },

        no_focus_fallback = true,
    },

    binds = {
        scroll_event_delay = 0,
        allow_pin_fullscreen = true,
    },

    input = {
        follow_mouse = 2,
        float_switch_override_focus = 0,

        touchpad = {
            natural_scroll = true,
        },
    },

    cursor = {
        no_warps = true,
        hide_on_key_press = true,
    },

    decoration = {
        rounding = 4,

        shadow = {
            range = 16,
            color = cs,
        },

        blur = {
            passes = 2,
            popups = true,
            special = true,
        },
    },

    xwayland = {
        force_zero_scaling = true,
    },

    misc = {
        background_color = "rgb(000000)",
        font_family = "Noto Sans Mono",

        focus_on_activate = true,
        allow_session_lock_restore = true,
        enable_anr_dialog = false,

        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,

        disable_autoreload = true,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        disable_watchdog_warning = true,
    },

    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
}

animation {
    leaf = "workspaces",
    enabled = false,
}
window_rule {
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding = 0,
}
window_rule {
    match = { float = false },
    no_shadow = true,
}
window_rule {
    match = { float = true },
    pin = true,
}

local function float_pin()
    dispatch(window.float())
    dispatch(window.pin())
end

local function exec_util(script) return exec_raw(util .. "/" .. script) end

bind("SUPER+mouse:272",  window.drag(), { mouse = true })
bind("SUPER+mouse:273",  window.resize(), { mouse = true })
bind("SUPER+mouse_down", jump.prev.used())
bind("SUPER+mouse_up",   jump.next.used())

bind("SUPER+SHIFT+mouse:272", window.drag(), { mouse = true })
bind("SUPER+SHIFT+mouse:272", float_pin, { release = true })
bind("SUPER+SHIFT+mouse:273", window.fullscreen(), { release = true })
bind("SUPER+mouse_down",      jump.prev(window.move))
bind("SUPER+mouse_up",        jump.next(window.move))

bind("SUPER+backslash", exec_util "term")
bind("SUPER+return",    exec_util "apps")
bind("SUPER+l",         exec_raw "loginctl lock-session")
bind("SUPER+r",         exec_raw "hyprctl reload")

bind("SUPER+s",         exec_util "edit")
bind("SUPER+c",         exec_util "calc")

bind("SUPER+escape", window.close())

bind("SUPER+left",  focus { direction = "l" }, { repeating = true })
bind("SUPER+right", focus { direction = "r" }, { repeating = true })
bind("SUPER+up",    focus { direction = "u" }, { repeating = true })
bind("SUPER+down",  focus { direction = "d" }, { repeating = true })

bind("SUPER+bracketleft",  jump.prev(), { repeating = true })
bind("SUPER+bracketright", jump.next(), { repeating = true })
bind("SUPER+tab",          jump.free())
bind("SUPER+equal",        window.fullscreen())
bind("SUPER+apostrophe",   window.float())
bind("SUPER+apostrophe",   window.pin())

bind("SUPER+SHIFT+backslash", jump.free(function(args) return exec_cmd(util .. "/term", args) end))
bind("SUPER+SHIFT+return",    jump.free(exec_util "apps"))

bind("SUPER+SHIFT+left",  window.move { direction = "l" }, { repeating = true })
bind("SUPER+SHIFT+right", window.move { direction = "r" }, { repeating = true })
bind("SUPER+SHIFT+up",    window.move { direction = "u" }, { repeating = true })
bind("SUPER+SHIFT+down",  window.move { direction = "d" }, { repeating = true })

bind("SUPER+SHIFT+bracketleft",  jump.prev(window.move), { repeating = true })
bind("SUPER+SHIFT+bracketright", jump.next(window.move), { repeating = true })
bind("SUPER+SHIFT+tab",          jump.free(window.move))

bind("SUPER+ALT+tab",       exec_raw "~/.local/share/ux/cycle-dpms", { locked = true })
bind("SUPER+ALT+backspace", function() monitor.toggle "eDP-1" end, { locked = true })
bind("SUPER+ALT+delete",    exit(), { locked = true })

bind("SUPER+ALT+left",  focus { monitor = "l" }, { repeating = true })
bind("SUPER+ALT+right", focus { monitor = "r" }, { repeating = true })
bind("SUPER+ALT+up",    focus { monitor = "u" }, { repeating = true })
bind("SUPER+ALT+down",  focus { monitor = "d" }, { repeating = true })

hl.monitor { output = "", mode = "preferred", position = "auto", scale = "auto" }

--on("config.reloaded", function ()
--    exec_cmd(
--        "hyprmods"
--        .. " SUPER=" .. utf8.char(0xf0142)
--        .. " SUPER+SHIFT=" .. utf8.char(0xf013e)
--        .. " SUPER+ALT=" .. utf8.char(0xf0379)
--    )
--end)

local handle = io.popen("ls " .. os.getenv("XDG_DATA_HOME") .. "/hypr/*.lua")
if handle then for file in handle:lines() do dofile(file) end handle:close() end

dofile "/usr/share/shell/hyprland.lua"
