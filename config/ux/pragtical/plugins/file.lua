-- mod-version:3
local command  = require 'core.command'
local treeview = require 'plugins.treeview'

if #ARGS < 2 then
    command.perform "core:new-doc"
end

if #ARGS < 2 or system.get_file_info(ARGS[2]).type ~= "dir" then
    command.perform "core:toggle-tabs"
    command.perform "status-bar:toggle"
    command.perform "treeview:toggle"
end
