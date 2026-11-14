local M = {}

local util = require 'util'

util.opts {
  selection = 'exclusive',
  selectmode = 'mouse,key',
  virtualedit = 'onemore',
  keymodel = 'startsel,stopsel',
  backspace = 'indent,eol,start',
  whichwrap = '<,>,[,]',
}

util.keys {
  i = {
    esc = '<C-O>',
    c_v = '<Cmd>normal! "+gP<CR>',
    c_z = '<Cmd>undo<CR>',
    c_y = '<Cmd>redo<CR>',
    ['2-LeftMouse'] = '<C-O>viw<C-G>',
  },
  v = {
    bs = '"_d',
    c_x = '"+x',
    c_c = '"+y',
    c_v = '"+P',
    c_z = '<Cmd>undo<CR>',
    c_y = '<Cmd>redo<CR>',
  },
  n = {
    esc = 'i',
    c_v = '"+gP',
    c_z = '<Cmd>undo<CR>',
    c_y = '<Cmd>redo<CR>',
  },
  s = {
    esc = '<C-O>',
  },
  x = {
    esc = '<C-G>',
  },
  c = {
    c_v = '<C-R>+',
  },
}

for mode, cmds in pairs {
  i = { '<Cmd>normal! @<CR>', '<C-\\><C-N>lv@<C-G>' },
  n = { '@', 'v@<C-G>' },
  v = { '<C-\\><C-N>@i', '@' },
} do
  for key, map in pairs { Down = { 'gj', '<C-N>' }, Up = { 'gk', '<C-P>' } } do
    for idx, mod in ipairs { '', 'S-' } do
      local expr, pum = cmds[idx]:gsub('@', map[1]), map[2]
      vim.keymap.set(mode, '<' .. mod .. key .. '>', function()
        return vim.fn.pumvisible() == 1 and pum or expr
      end, { silent = true, expr = true })
    end
  end
end

local group = vim.api.nvim_create_augroup('EditInsertLock', { clear = true })

M.insert = vim.schedule_wrap(function()
  vim.cmd(vim.bo.modifiable and 'startinsert' or 'stopinsert')
end)

vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = M.insert
})

vim.api.nvim_create_autocmd('ModeChanged', {
  group = group,
  pattern = '[vV\22sS\19]:n',
  callback = M.insert
})

return M
