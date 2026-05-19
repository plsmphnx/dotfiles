local specs = {}
local by_name = {}
local by_desc = {}
local base = 0
local size = 27

local function register(spec)
    specs[#specs + 1] = spec
    hl.monitor(spec)
    workspace_rule {
        workspace = "r[" .. (base + 1) .. "-" .. (base + (1 << size)) .. "]",
        monitor = spec.output,
    }
    workspace_rule {
        workspace = tostring(base + (1 << (size - 1))),
        monitor = spec.output,
        default = true,
    }
    base = base + (1 << size)
end

hl.on("monitor.added", function(monitor)
    for _, spec in ipairs(specs) do
        if spec.output:sub(1, 5) == "desc:" then
            if spec.output:sub(6, #spec.output) == monitor.description then
                by_name[monitor.name] = spec
                by_desc[monitor.description] = spec
            end
        elseif spec.output == monitor.name then
            by_name[monitor.name] = spec
            by_desc[monitor.description] = spec
        end
    end
end)

local function enable(output)
    if output:sub(1, 5) == "desc:" then
        local spec = by_desc[output:sub(6, #output)]
        if spec then
            hl.monitor(spec)
        else
            hl.monitor { output = output, disabled = false }
        end
    else
        local spec = by_name[output]
        if spec then
            hl.monitor(spec)
        else
            hl.monitor { output = output, disabled = false }
        end
    end
end

local function disable(output)
    hl.monitor { output = output, disabled = true }
end

local function toggle(output)
    if hl.get_monitor(output) then disable(output) else enable(output) end
end

return {
    register = register,
    enable = enable,
    disable = disable,
    toggle = toggle,
}
