local cmds = require 'edit.cmds'
local util = require 'edit.util'

util.keys {
  [{ '', 'i' }] = {
    c_s = cmds.save,
    c_s_s = cmds.save_as,
    c_f = function() Snacks.picker.lines { pattern = util.sel() } end,
    c_s_f = function() Snacks.picker.grep { search = util.sel() } end,
    c_s_i = function() vim.lsp.buf.format() end,
    ['c_\\'] = function() Snacks.picker.buffers() end,
    ['c_s_\\'] = function() Snacks.picker.explorer() end,
    f1 = function() Snacks.picker.help { pattern = util.sel() } end,
    f2 = function() Snacks.picker.pickers() end,
    f11 = function() vim.lsp.buf.hover() end,
    f12 = function() Snacks.picker.lsp_definitions() end,
    m_g = function() Snacks.lazygit.open() end,
  },
  [{ '', '!', 't' }] = {
    c_q = cmds.quit,
  },
  [{ 'i', 'n' }] = {
    home = cmds.home,
  },
  [{ 'i' }] = {
    s_tab = function() MiniMove.move_line 'left' end,
  },
  [{ 'v' }] = {
    tab = function() MiniMove.move_line 'right' end,
    s_tab = function() MiniMove.move_line 'left' end,
  },
}

vim.keymap.set('i', '<Tab>', function()
  return vim.fn.pumvisible() == 1 and (
    vim.fn.complete_info { 'selected' }.selected == -1
    and '<C-N><C-Y>' or '<C-Y>'
  ) or '<Tab>'
end, { expr = true })
