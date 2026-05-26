local SPEC = { next = 0, prev = 1, free = 2, used = 4 }

local function jump(spec, cmds)
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
  if spec & SPEC.prev > 0 then
    if active == 1 or spec & SPEC.free > 0 then
      local i = monitor[1]
      id = workspaces[i].id
      if spec & SPEC.used == 0 and workspaces[i].windows ~= 0 then
        while i > 0 and workspaces[i].id == id do i, id = i - 1, id - 1 end
      end
    else id = workspaces[monitor[active - 1]].id end
  else
    if active == count or spec & SPEC.free > 0 then
      local i = monitor[count]
      id = workspaces[i].id
      if spec & SPEC.used == 0 and workspaces[i].windows ~= 0 then
        while i <= last and workspaces[i].id == id do i, id = i + 1, id + 1 end
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

return setmetatable({ _ = 0 }, {
  __call = function(self, ...)
    local spec, cmds = self._, default {...}
    return function() jump(spec, cmds) end
  end,
  __index = function(self, key)
    self[key] = SPEC[key] and setmetatable({
      _ = self._ | SPEC[key],
    }, getmetatable(self))
    return rawget(self, key)
  end,
})
