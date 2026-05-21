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

local function call(mods)
  return setmetatable({}, {
    __call = function(_, binds)
      for _, v in pairs(binds) do for i, d in ipairs(v) do
        if type(d) == "string" then v[i] = hl.dsp.exec_raw(d) end
      end end

      local sub = table.concat(mods, "+")

      for i = 0, #mods do
        local group = { table.unpack(mods, 1, i) }
        local active = { table.unpack(mods, i + 1) }

        local build = function(binder)
          local i = #active + 1

          for _, mod in ipairs(active) do
            for _, key in ipairs(MODS[mod]) do
              hl.bind(
                table.concat(active, "+") .. "+" .. key,
                hl.dsp.submap(sub),
                { release = true }
              )
            end
          end

          for k, v in pairs(binds) do
            active[i] = k
            binder(table.concat(active, "+"), v)
          end
        end

        if #group == 0 then build(bind) else
          hl.define_submap(table.concat(group, "+"), function()
            build(bind_exit)
          end)
        end
      end

      if sub ~= "" then
        hl.define_submap(sub, function()
          hl.bind("catchall", hl.dsp.submap("reset"))
        end)
      end
    end,

    __index = function(self, key)
      local child = rawget(self, key)
      if not child then
        local next = { table.unpack(mods) }
        next[#mods + 1] = key:upper()
        child = call(next)
        rawset(self, key, child)
      end
      return child
    end,
  })
end

return call {}
