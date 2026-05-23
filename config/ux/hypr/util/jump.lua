local function jump(self)
  local active_monitor = hl.get_active_monitor()
  local workspaces = hl.get_workspaces()
  table.sort(workspaces, function(a, b) return a.id < b.id end)

  local active
  local monitor = {}
  for i, workspace in ipairs(workspaces) do
    if workspace.monitor == active_monitor then
      monitor[#monitor + 1] = i
      if workspace == active_monitor.active_workspace then
        active = #monitor
      end
    end
  end

  local id
  if self.prev then
    if active == 1 or self.free then
      local i = monitor[1]
      id = workspaces[i].id
      if not self.used and workspaces[i].windows ~= 0 then
        while i > 0 and workspaces[i].id == id do
          i = i - 1
          id = id - 1
        end
      end
    else id = workspaces[monitor[active - 1]].id end
  else
    if active == #monitor or self.free then
      local i = monitor[#monitor]
      id = workspaces[i].id
      if not self.used and workspaces[i].windows ~= 0 then
        while i <= #workspaces and workspaces[i].id == id do
          i = i + 1
          id = id + 1
        end
      end
    else id = workspaces[monitor[active + 1]].id end
  end
  local workspace = tostring(math.max(1, math.min(2147483647, id)))

  for _, cmd in ipairs(self) do
    if type(cmd) == "function" then
      local dispatcher = cmd { workspace = workspace }
      if dispatcher then hl.dispatch(dispatcher) end
    else hl.dispatch(cmd) end
  end
end

return setmetatable({}, {
  __call = function(self, ...)
    local cmds = {...}
    local focus = true
    for _, cmd in ipairs(cmds) do
      if type(cmd) == "function" then focus = false end
    end
    if focus then table.insert(cmds, 1, hl.dsp.focus) end
    for k, v in pairs(self) do cmds[k] = v end
    return function() jump(cmds) end
  end,
  __index = function(self, key)
    local next = setmetatable({ [key] = true }, getmetatable(self))
    for k, v in pairs(self) do next[k] = v end
    return next
  end,
})
