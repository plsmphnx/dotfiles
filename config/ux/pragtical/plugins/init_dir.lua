-- mod-version:3
local core     = require "core"
local dirwatch = require "core.dirwatch"

local INIT_DIR = USERDIR .. PATHSEP .. "init"

if not system.get_file_info(INIT_DIR) then
    local ok, err = system.mkdir(INIT_DIR)
    if not ok then
        error("cannot create directory \"" .. INIT_DIR .. "\": " .. err)
    end
end

local function init()
    local paths = system.list_dir(INIT_DIR) or {}
    for _, path in ipairs(paths) do
        if path:sub(-4) == ".lua" then
            dofile(INIT_DIR .. PATHSEP .. path)
        end
    end
end

init()

local watch = dirwatch()
watch:watch(INIT_DIR)
core.add_thread(function()
    while true do
        watch:check(init)
        coroutine.yield(1)
    end
end)
