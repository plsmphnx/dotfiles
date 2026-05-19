local function jump(next, free, cmds)
    local active_monitor = hl.get_active_monitor()
    local workspaces = hl.get_workspaces()
    table.sort(workspaces, function(a, b) return a.id < b.id end)

    local active
    local monitor = {}
    for i, this in ipairs(workspaces) do
        if this.monitor.id == active_monitor.id then
            monitor[#monitor + 1] = i
            if this.id == active_monitor.active_workspace.id then
                active = #monitor
            end
        end
    end

    local workspace
    if next then
        if active == #monitor or free == 1 then
            local i = monitor[#monitor]
            local id = workspaces[i].id
            if free ~= -1 and workspaces[i].windows ~= 0 then
                while i <= #workspaces and workspaces[i].id == id do
                    i = i + 1
                    id = id + 1
                end
            end
            workspace = id
        else
            workspace = workspaces[monitor[active + 1]].id
        end
    else
        if active == 1 or free == 1 then
            local i = monitor[1]
            local id = workspaces[i].id
            if free ~= -1 and workspaces[i].windows ~= 0 then
                while i > 0 and workspaces[i].id == id do
                    i = i - 1
                    id = id - 1
                end
            end
            workspace = id
        else
            workspace = workspaces[monitor[active - 1]].id
        end
    end
    workspace = tostring(math.max(1, math.min(2147483647, workspace)))

    for _, cmd in ipairs(cmds) do
        if type(cmd) == "function" then
            local dispatcher = cmd { workspace = workspace }
            if dispatcher then
                hl.dispatch(dispatcher)
            end
        else
            hl.dispatch(cmd)
        end
    end
end

local function call(next, free, obj)
    return setmetatable(obj or {}, {
        __call = function(_, ...)
            local cmds = {...}
            local add_focus = true
            for _, cmd in ipairs(cmds) do
                if type(cmd) == "function" then
                    add_focus = false
                    break
                end
            end
            if add_focus then
                table.insert(cmds, 1, hl.dsp.focus)
            end
            return function() jump(next, free, cmds) end
        end
    })
end

return call(true, 0, {
    next = call(true,  0, { free = call(true,  1), used = call(true,  -1) }),
    prev = call(false, 0, { free = call(false, 1), used = call(false, -1) }),
    free = call(true,  1, { next = call(true,  1), prev = call(false,  1) }),
    used = call(true, -1, { next = call(true, -1), prev = call(false, -1) }),
})
