local function jump(spec, cmds)
  local active_monitor = hl.get_active_monitor()
  local workspaces = hl.get_workspaces()
  table.sort(workspaces, function(a, b) return a.id < b.id end)

  local monitor, active = {}
  for i, workspace in ipairs(workspaces) do
    if workspace.monitor == active_monitor then
      monitor[#monitor + 1] = i
      if workspace == active_monitor.active_workspace then
        active = #monitor
      end
    end
  end

  local id
  if spec.prev then
    if active == 1 or spec.free then
      local i = monitor[1]
      id = workspaces[i].id
      if not spec.used and workspaces[i].windows ~= 0 then
        while i > 0 and workspaces[i].id == id do
          i, id = i - 1, id - 1
        end
      end
    else id = workspaces[monitor[active - 1]].id end
  else
    if active == #monitor or spec.free then
      local i = monitor[#monitor]
      id = workspaces[i].id
      if not spec.used and workspaces[i].windows ~= 0 then
        while i <= #workspaces and workspaces[i].id == id do
          i, id = i + 1, id + 1
        end
      end
    else id = workspaces[monitor[active + 1]].id end
  end
  local workspace = tostring(math.max(1, math.min(2147483647, id)))

  for _, cmd in ipairs(cmds) do
    if type(cmd) == "function" then cmd = cmd { workspace = workspace } end
    if cmd then hl.dispatch(cmd) end
  end
end

function default(cmds)
  for _, cmd in ipairs(cmds) do
    if type(cmd) == "function" then return cmds end
  end
  return table.insert(cmds, 1, hl.dsp.focus) or cmds
end

return setmetatable({ _ = {} }, {
  __call = function(self, ...)
    local spec, cmds = self._, default {...}
    return function() jump(spec, cmds) end
  end,
  __index = function(self, key)
    local val = setmetatable({ _ = { [key] = true } }, getmetatable(self))
    for k in pairs(self._) do val._[k] = true end
    self[key] = val
    return val
  end,
})
