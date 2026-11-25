local M = {}

M.keys = function(map)
  for mode, keys in pairs(map) do
    for key, cmd in pairs(keys) do
      key = '<' .. key:gsub('_', '-') .. '>'
      vim.keymap.set(mode, key, cmd, { silent = true })
    end
  end
end

M.opts = function(map)
  for opt, val in pairs(map) do vim.opt[opt] = val end
end

M.eol = { unix = '\n', dos = '\r\n', mac = '\r' }
M.visual = { v = true, V = true, ['\22'] = true }

M.sel = function()
  local mode = vim.fn.mode()
  return M.visual[mode] and table.concat(vim.fn.getregion(
    vim.fn.getpos 'v',
    vim.fn.getpos '.',
    { type = mode }
  ), M.eol[vim.bo.fileformat])
end

return M
