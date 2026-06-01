local function jump(spec)
  local current, workspaces = hl.get_active_monitor(), hl.get_workspaces()
  local last = #workspaces
  table.sort(workspaces, function(a, b) return a.id < b.id end)

  local monitor, active, count = {}, nil, 0
  for i, workspace in ipairs(workspaces) do
    if workspace.monitor == current then
      count = count + 1
      monitor[count] = i
      if workspace == current.active_workspace then active = count end
    end
  end

  local id
  if spec.prev then
    if active == 1 or spec.free then
      local i = monitor[1]
      id = workspaces[i].id
      if not spec.used and workspaces[i].windows > 0 then
        while i > 0 and workspaces[i].id == id do i, id = i - 1, id - 1 end
      end
    else id = workspaces[monitor[active - 1]].id end
  else
    if active == count or spec.free then
      local i = monitor[count]
      id = workspaces[i].id
      if not spec.used and workspaces[i].windows > 0 then
        while i <= last and workspaces[i].id == id do i, id = i + 1, id + 1 end
      end
    else id = workspaces[monitor[active + 1]].id end
  end
  local workspace = tostring(math.max(1, math.min(2147483647, id)))

  for _, cmd in ipairs(spec) do
    if type(cmd) == "function" then cmd = cmd { workspace = workspace } end
    if cmd then hl.dispatch(cmd) end
  end
end

return setmetatable({}, {
  __bor = function(a, b)
    for k, v in pairs(b) do if v == true then a[k] = true end end return a
  end,
  __call = function(self, ...)
    local spec = {...} | self
    return function() jump(spec) end
  end,
  __index = function(self, key)
    self[key] = setmetatable({ [key] = true } | self, getmetatable(self))
    return rawget(self, key)
  end,
})
