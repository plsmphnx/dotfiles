local SIZE, base, by_name, by_desc = 27, 0, {}, {}

local function parse(id)
  if id:sub(1, 5) == "desc:" then return id:sub(6), by_desc end
  return id, by_name
end

local function default(id)
  return { output = id, mode = "preferred", position = "auto", scale = "auto" }
end

local function add(spec)
  if type(spec) == "string" then spec = default(spec) end
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

local function enable(id)
  local out, tbl = parse(id)
  hl.monitor(tbl[out] or default(id))
end

local function disable(id)
  hl.monitor { output = id, disabled = true }
end

local function toggle(id)
  if hl.get_monitor(id) then disable(id) else enable(id) end
end

return { add = add, enable = enable, disable = disable, toggle = toggle }
