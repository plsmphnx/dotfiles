return function(args)
    if #args == 0 then
        args[1] = hl.dsp.focus
    end
    return function()
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
        if args.prev then
            if active == 1 or args.free then
                local i = monitor[1]
                local id = workspaces[i].id
                if not args.used and workspaces[i].windows ~= 0 then
                    while i > 0 and workspaces[i].id == id do
                        i = i - 1
                        id = id - 1
                    end
                end
                workspace = id
            else
                workspace = workspaces[monitor[active - 1]].id
            end
        else
            if active == #monitor or args.free then
                local i = monitor[#monitor]
                local id = workspaces[i].id
                if not args.used and workspaces[i].windows ~= 0 then
                    while i <= #workspaces and workspaces[i].id == id do
                        i = i + 1
                        id = id + 1
                    end
                end
                workspace = id
            else
                workspace = workspaces[monitor[active + 1]].id
            end
        end
        workspace = tostring(math.max(1, math.min(2147483647, workspace)))

        for _, arg in ipairs(args) do
            if type(arg) == "function" then
                local dispatcher = arg { workspace = workspace }
                if dispatcher then
                    hl.dispatch(dispatcher)
                end
            else
                hl.dispatch(arg)
            end
        end
    end
end
