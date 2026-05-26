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

return setmetatable({ _ = {} }, {
  __call = function(self, binds)
    for _, v in pairs(binds) do
      for i, d in ipairs(v) do
        if type(d) == "string" then v[i] = hl.dsp.exec_raw(d) end
      end
    end

    local mods, list, target = "", {}, self
    while target do
      local build = function(binder)
        for k, v in pairs(binds) do binder(mods .. k, v) end

        for _, mod in ipairs(list) do
          for _, key in ipairs(MODS[mod]) do
            hl.bind(mods .. key, hl.dsp.submap(self._.sub), { release = true })
          end
        end
      end

      if target._.sub then hl.define_submap(target._.sub, function()
        build(bind_exit)
      end) else build(bind) end

      if target._.mod then
        mods = mods .. target._.mod .. "+"
        list[#list + 1] = target._.mod
      end
      target = target._.prev
    end
  end,

  __index = function(self, key)
    local mod = key:upper()
    local sub = self._.sub and self._.sub .. "+" .. mod or mod
    hl.define_submap(sub, function()
      hl.bind("catchall", hl.dsp.submap "reset", { release = true })
    end)
    self[key] = setmetatable({
      _ = { mod = mod, sub = sub, prev = self },
    }, getmetatable(self))
    return rawget(self, key)
  end,
})
