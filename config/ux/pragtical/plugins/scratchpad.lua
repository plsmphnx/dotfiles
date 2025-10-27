-- mod-version:3
local command = require "core.command"
local config  = require "core.config"

if config.plugins.scratchpad then
    local arg_dir = config.plugins.scratchpad.arg_dir or system.getcwd()

    if #ARGS < 2 then
        command.perform "core:new-doc"
    end

    config.plugins.scratchpad.file_only = true
    for i = 2, #ARGS do
        local path = ARGS[i]
        if path ~= system.absolute_path(path) then
            path = arg_dir .. PATHSEP .. ARGS[i]
        end
        local info = system.get_file_info(path) or {}
        if info.type == "dir" then
            config.plugins.scratchpad.file_only = false
            break
        end
    end

    if config.plugins.scratchpad.file_only then
        command.perform "core:toggle-tabs"
        command.perform "status-bar:toggle"
        command.perform "treeview:toggle"
    end
end
