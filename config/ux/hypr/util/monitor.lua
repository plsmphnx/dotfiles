local by_name = {}
local by_desc = {}

local base = 0
local SIZE = 27

local function parse(output)
  if output:sub(1, 5) == "desc:" then
    return output:sub(6, #output), by_desc
  end
  return output, by_name
end

local function add(spec)
  local out, tbl = parse(spec.output)
  tbl[out] = spec

  hl.monitor(spec)

  workspace_rule {
    workspace = "r[" .. (base + 1) .. "-" .. (base + (1 << SIZE)) .. "]",
    monitor = spec.output,
  }
  workspace_rule {
    workspace = tostring(base + (1 << SIZE - 1)),
    monitor = spec.output,
    default = true,
  }
  base = base + (1 << SIZE)
end

hl.on("monitor.added", function(monitor)
  if by_name[monitor.name] then
    by_desc[monitor.description] = by_name[monitor.name]
  else
    by_name[monitor.name] = by_desc[monitor.description]
  end
end)

local function enable(output)
  local out, tbl = parse(output)
  hl.monitor(tbl[out] or {
    output = output,
    mode = "preferred",
    position = "auto",
    scale = "auto",
    disabled = false,
  })
end

local function disable(output)
  hl.monitor { output = output, disabled = true }
end

local function toggle(output)
  if hl.get_monitor(output) then disable(output) else enable(output) end
end

return { add = add, enable = enable, disable = disable, toggle = toggle }
