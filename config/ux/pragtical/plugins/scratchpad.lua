-- mod-version:3
local core    = require "core"
local command = require "core.command"
local config  = require "core.config"

if #ARGS < 2 then
    core.add_thread(function()
        command.perform "core:new-doc"
    end)
end

config.plugins.scratchpad = true
for i = 2, #ARGS do
    local path = ARGS[i]
    if path ~= system.absolute_path(path) then
        path = core.init_working_dir .. PATHSEP .. ARGS[i]
    end
    local info = system.get_file_info(path) or {}
    if info.type == "dir" then
        config.plugins.scratchpad = false
        break
    end
end

if config.plugins.scratchpad then
    command.perform "core:toggle-tabs"
    command.perform "status-bar:toggle"
    command.perform "treeview:toggle"
end
