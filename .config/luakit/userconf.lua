local settings = require "settings"
local modes = require "modes"

settings.application.prefer_dark_mode = true

settings.webview.enable_developer_extras = true
settings.webview.enable_java = false
settings.webview.enable_smooth_scrolling = true
settings.webview.hardware_acceleration_policy = "always"
settings.webview.javascript_can_access_clipboard = true

settings.window.close_with_last_tab = true
settings.window.home_page = "google.com"
settings.window.search_engines.nixpkgs = "https://search.nixos.org/packages?channel=unstable&query=%s"
settings.window.search_engines.nixopts = "https://search.nixos.org/options?channel=unstable&query=%s"

modes.remap_binds("normal", {
    {"<Shift-Left>", "<Shift-h>", true},
    {"<Shift-Right>", "<Shift-l>", true},
})
