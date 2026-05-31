for k, v in pairs(hl) do _G[k] = v end
for k, v in pairs(dsp) do _G[k] = v end

bind = require "util.bind"
jump = require "util.jump"
view = require "util.view"

local ct, cs, ch = "rgba(00000000)", "rgba(00000033)", "rgba(ffffff66)"

local data = os.getenv "XDG_DATA_HOME"
local util = data .. "/ux/bind/"

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
      inactive_border = ct,
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
    touchpad = { natural_scroll = true },
  },

  cursor = {
    no_warps = true,
    hide_on_key_press = true,
  },

  decoration = {
    rounding = 4,
    shadow = { range = 16, color = cs },
    blur = { passes = 2, popups = true, special = true },
  },

  xwayland = { force_zero_scaling = true },

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

  ecosystem = { no_update_news = true, no_donation_nag = true },
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

function expand()
  local current = get_active_window()
  if current then
    if current.floating then
      dispatch(window.float { action = "unset" })
    elseif current.fullscreen == 0 then
      dispatch(window.fullscreen { action = "set" })
    end
  end
end

function contract()
  local current = get_active_window()
  if current then
    if current.fullscreen > 0 then
      dispatch(window.fullscreen { action = "unset" })
    elseif not current.floating then
      dispatch(window.float { action = "set" })
      dispatch(window.pin())
    end
  end
end

bind.super {
  left  = { focus { direction = "l" }, repeating = true },
  right = { focus { direction = "r" }, repeating = true },
  up    = { focus { direction = "u" }, repeating = true },
  down  = { focus { direction = "d" }, repeating = true },

  bracketleft  = { jump.prev(focus), repeating = true },
  bracketright = { jump.next(focus), repeating = true },
  tab          = { jump.free(focus) },
  equal        = { expand },
  apostrophe   = { contract },

  escape    = { window.close() },
  pause     = { submap "keylock" },
  backspace = { window.move { workspace = "special:background", follow = false } },

  ["mouse:272"] = { window.drag(),   mouse = true },
  ["mouse:273"] = { window.resize(), mouse = true },
  mouse_down    = { jump.prev.used(focus) },
  mouse_up      = { jump.next.used(focus) },

  backslash  = { util .. "term" },
  ["return"] = { util .. "apps" },
  l          = { "loginctl lock-session" },
  r          = { "hyprctl reload" },
  s          = { util .. "edit" },
  c          = { util .. "calc" },

  print = { "grimblast copy area" },
}

bind.super.shift {
  left  = { window.move { direction = "l" }, repeating = true },
  right = { window.move { direction = "r" }, repeating = true },
  up    = { window.move { direction = "u" }, repeating = true },
  down  = { window.move { direction = "d" }, repeating = true },

  bracketleft  = { jump.prev(window.move), repeating = true },
  bracketright = { jump.next(window.move), repeating = true },
  tab          = { jump.free(window.move) },

  backspace = { workspace.toggle_special "background", submap "background" },

  mouse_down = { jump.prev(window.move) },
  mouse_up   = { jump.next(window.move) },

  backslash  = { jump.free(function(args) return exec_cmd(util .. "term", args) end) },
  ["return"] = { jump.free(focus, exec_raw(util .. "apps")) },

  print = { "grimblast save" },
}

bind.super.alt {
  left  = { focus { monitor = "l" }, repeating = true },
  right = { focus { monitor = "r" }, repeating = true },
  up    = { focus { monitor = "u" }, repeating = true },
  down  = { focus { monitor = "d" }, repeating = true },

  tab       = { data .. "/ux/cycle-dpms",           locked = true },
  backspace = { function() view.toggle "eDP-1" end, locked = true },
  delete    = { exit(),                             locked = true },

  print = { "grimblast copy output" },
}

bind {
  XF86MonBrightnessDown = { "brightnessctl set 5%-",                locked = true, repeating = true },
  XF86MonBrightnessUp   = { "brightnessctl set +5%",                locked = true, repeating = true },
  XF86AudioLowerVolume  = { "wpctl set-volume @DEFAULT_SINK@ 5%-",  locked = true, repeating = true },
  XF86AudioRaiseVolume  = { "wpctl set-volume @DEFAULT_SINK@ 5%+",  locked = true, repeating = true },
  XF86AudioMute         = { "wpctl set-mute @DEFAULT_SINK@ toggle", locked = true },
  XF86AudioPlay         = { "playerctl play-pause",                 locked = true },
  XF86AudioPrev         = { "playerctl previous",                   locked = true },
  XF86AudioNext         = { "playerctl next",                       locked = true },
  XF86AudioStop         = { "playerctl stop",                       locked = true },

  print = { "grimblast copy active" },
}

workspace_rule { workspace = "special:background", gaps_in = 32, gaps_out = 32 }
local bg_exit = { function()
  local current = get_active_special_workspace()
  if current and current.name == "special:background" then
    dispatch(workspace.toggle_special "background")
  end
end, submap "reset" }
local bg_free = { window.move { workspace = "e+0" }, table.unpack(bg_exit) }

bind "keylock" { pause = { submap "reset" } }
bind "background" {
  escape        = bg_exit,
  backspace     = bg_exit,
  ["mouse:273"] = bg_exit,

  ["return"]    = bg_free,
  ["mouse:272"] = { non_consuming = true, release = true, table.unpack(bg_free) },

  left  = { window.move { direction = "l" }, repeating = true },
  right = { window.move { direction = "r" }, repeating = true },
  up    = { window.move { direction = "u" }, repeating = true },
  down  = { window.move { direction = "d" }, repeating = true },
}

view.add ""

local handle = io.popen("ls " .. data .. "/hypr/*.lua")
if handle then for file in handle:lines() do dofile(file) end handle:close() end

dofile "/usr/share/hypr/shell.lua"
