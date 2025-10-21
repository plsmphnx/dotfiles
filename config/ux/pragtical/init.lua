local config  = require "core.config"
local plugins = config.plugins
local style   = require "core.style"

style.code_font = renderer.font.load(
    HOME .. "/.local/share/fonts/iosevka-clecompt/iosevka-clecompt-medium.ttf",
    15 * SCALE
)

config.indent_size = 4

plugins.drawwhitespace = {
    enabled = true,
    show_leading = false,
    show_middle = false
}

plugins.findfile = {
    show_recent = false
}

plugins.ipc = {
    single_instance = false
}

plugins.linewrapping = {
    mode = "word"
}

plugins.treeview = {
    show_hidden = true
}

if plugins.file.only then
    plugins.lineguide = {
        enabled = false
    }
else
    plugins.lineguide = {
        enabled = true,
        rulers = { 80, 120 },
        width = 1
    }
end
