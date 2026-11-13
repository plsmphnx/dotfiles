local visual = { v = true, V = true, ['\22'] = true }
local function sel()
  local mode = vim.fn.mode()
  if not visual[mode] then return end
  return table.concat(vim.fn.getregion(
    vim.fn.getpos 'v',
    vim.fn.getpos '.',
    { type = mode }
  ), '\n')
end

require 'util'.keys {
  [{ 'i', 'n', 'v' }] = {
    c_s = require 'cmds'.save,
    c_q = require 'cmds'.quit,
    c_f = function() Snacks.picker.lines { pattern = sel() } end,
    c_s_f = function() Snacks.picker.grep { search = sel() } end,
    c_s_i = function() vim.lsp.buf.format() end,
    c_b = function() Snacks.picker.explorer() end,
    f1 = function() Snacks.picker.help { pattern = sel() } end,
    f2 = function() Snacks.picker.pickers() end,
    f12 = '<C-O><C-]>',
  },
  [{ 'i', 'n' }] = {
    home = function()
      local col = vim.fn.col '.'
      vim.cmd 'normal! ^'
      if col == vim.fn.col '.' then vim.cmd 'normal! 0' end
    end,
  },
  [{ 'i' }] = {
    s_tab = function() MiniMove.move_line 'left' end,
  },
  [{ 'v' }] = {
    tab = function() MiniMove.move_line 'right' end,
    s_tab = function() MiniMove.move_line 'left' end,
  },
}
