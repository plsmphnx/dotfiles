local config  = require "core.config"
local style   = require "core.style"

style.code_font = renderer.font.load(
    HOME .. "/.local/share/fonts/iosevka-clecompt/iosevka-clecompt-medium.ttf",
    15 * SCALE
)

config.indent_size = 4

config.plugins.drawwhitespace = {
    enabled = true,
    show_leading = false,
    show_middle = false
}

config.plugins.findfile = {
    show_recent = false
}

config.plugins.ipc = {
    single_instance = false
}

config.plugins.linewrapping = {
    mode = "word"
}

config.plugins.lsp = {
    symbolstree_visibility = "hide"
}

config.plugins.scratchpad = {
    arg_dir = system.getcwd()
};

config.plugins.treeview = {
    show_hidden = true
}

if config.plugins.scratchpad.file_only then
    config.plugins.lineguide = {
        enabled = false
    }
else
    config.plugins.lineguide = {
        enabled = true,
        rulers = { 80, 120 },
        width = 1
    }
end

local ok, lsp = pcall(require, "plugins.lsp.config")
if ok then
    local util = require "plugins.lsp.util"
    local function check(cmd)
        cmd = type(cmd) == "string" and { cmd } or cmd or {}
        for _, c in ipairs(cmd) do
            if util.command_exists(c) then
                return true
            end
        end
    end

    for _, lang in pairs(lsp) do
        local command = lang.get_options().command or {}
        if check(command[1]) then
            lang.setup()
        end
    end
end
