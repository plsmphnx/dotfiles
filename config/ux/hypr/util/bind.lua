local function dispatcher(v)
  if type(v) == "string" then return hl.dsp.exec_raw(v) else return v end
end

local function bind(k, v)
  if #v == 1 then hl.bind(k, dispatcher(v[1]), v) else
    for i, d in ipairs(v) do v[i] = dispatcher(d) end
    hl.bind(k, function() for _, d in ipairs(v) do hl.dispatch(d) end end, v)
  end
end

local function call(...)
  return setmetatable(table.pack(...), {
    __call = function(mods, binds)
      local i = #mods + 1
      for k, v in pairs(binds) do
        mods[i] = k
        bind(table.concat(mods, "+"), v)
      end
      mods[i] = nil
    end,
    __index = function(mods, key)
      return call(key:upper(), table.unpack(mods))
    end,
  })
end

return call()
