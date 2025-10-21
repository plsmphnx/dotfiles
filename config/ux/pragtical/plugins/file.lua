-- mod-version:3
local command = require "core.command"
local config  = require "core.config"

if #ARGS < 2 then
    command.perform "core:new-doc"
end

config.plugins.file.only = true

for i = 2, #ARGS do
    if system.get_file_info(ARGS[i]).type == "dir" then
        config.plugins.file.only = false
        break
    end
end

if config.plugins.file.only then
    command.perform "core:toggle-tabs"
    command.perform "status-bar:toggle"
    command.perform "treeview:toggle"
end
