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

local function dispatcher(v)
  if type(v) == "string" then return hl.dsp.exec_raw(v) else return v end
end

local function bind(k, v)
  if type(v) ~= "table" then hl.bind(k, dispatcher(v)) else
    if #v == 1 then hl.bind(k, dispatcher(v[1]), v) else
      for i, d in ipairs(v) do v[i] = dispatcher(d) end
      hl.bind(k, function() for _, d in ipairs(v) do hl.dispatch(d) end end, v)
    end
  end
end

local function is_sub(v) return type(v) == "table" and #v == 0 end

local function apply(binds, ...)
  for k, v in pairs(binds) do
    local keys = table.pack(...)
    keys[#keys + 1] = k
    if is_sub(v) then
      apply(v, table.unpack(keys))
    else
      bind(table.concat(keys, "+"), v)
    end
  end

  local prefix = table.pack(...)
  if #prefix ~= 0 then
    local sub = table.concat(prefix, "+")
    for _, mod in ipairs(prefix) do
      for _, key in ipairs(MODS[mod]) do
        hl.bind(sub .. "+" .. key, function()
          hl.notification.create { text = sub, duration = 5000 }
          hl.dispatch(hl.dsp.submap(sub))
        end, { release = true })
      end
    end
    hl.define_submap(sub, function()
      for _, mod in ipairs(prefix) do
        for _, key in ipairs(MODS[mod]) do
          hl.bind(mod .. "+" .. key, function()
            hl.notification.create { text = "reset", duration = 5000 }
            hl.dispatch(hl.dsp.submap("reset"))
          end, { release = true })
        end
      end
    end)
  end
end

return function(binds) apply(binds) end
