local MODS = {
  SHIFT   = { "shift_l", "shift_r" },
  CAPS    = { "caps_lock" },
  CTRL    = { "control_l", "control_r" },
  CONTROL = { "control_l", "control_r" },
  ALT     = { "alt_l", "alt_r" },
  MOD2    = {},
  MOD3    = {},
  SUPER   = { "super_l", "super_r" },
  WIN     = { "super_l", "super_r" },
  LOGO    = { "super_l", "super_r" },
  MOD4    = { "super_l", "super_r" },
  MOD5    = {},
}

local function bind(k, v)
  if #v == 1 then hl.bind(k, v[1], v) else
    hl.bind(k, function() for _, d in ipairs(v) do hl.dispatch(d) end end, v)
  end
end

local function bind_exit(k, v)
  local d = { table.unpack(v) }
  d[#d + 1] = hl.dsp.submap "reset"
  bind(k, d)
end

local function keys(mods, key)
  if mods and mods ~= "" then return mods .. "+" .. key else return key end
end

return setmetatable({ _ = {} }, {
  __call = function(self, binds)
    for _, v in pairs(binds) do
      for i, d in ipairs(v) do
        if type(d) == "string" then v[i] = hl.dsp.exec_raw(d) end
      end
    end

    local mods = {}
    local target = self
    while target do
      local m = keys(table.concat(mods, "+"), "")
      local build = function(binder)
        for k, v in pairs(binds) do binder(m .. k, v) end

        for _, mod in ipairs(mods) do
          for _, key in ipairs(MODS[mod]) do
            hl.bind(m .. key, hl.dsp.submap(self._.sub), { release = true })
          end
        end
      end

      if target._.sub then hl.define_submap(target._.sub, function()
        build(bind_exit)
      end) else build(bind) end

      table.insert(mods, 1, target._.mod)
      target = target._.prev
    end
  end,

  __index = function(self, key)
    local mod = key:upper()
    local sub = keys(self._.sub, mod)
    hl.define_submap(sub, function()
      hl.bind("catchall", hl.dsp.submap "reset", { release = true })
    end)
    local val = setmetatable({
      _ = { mod = mod, sub = sub, prev = self },
    }, getmetatable(self))
    self[key] = val
    return val
  end,
})
