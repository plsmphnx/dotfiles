local util = require 'util'

util.opts {
  selection = 'exclusive',
  selectmode = 'mouse,key',
  virtualedit = 'onemore',
  keymodel = 'startsel,stopsel',
  backspace = 'indent,eol,start',
  whichwrap = '<,>,[,]',
  clipboard = 'unnamedplus',
}

util.keys {
  i = {
    esc = '<C-O>',
    c_v = '<C-O>"+gP',
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

local group = vim.api.nvim_create_augroup('EditInsertLock', { clear = true })

vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = vim.schedule_wrap(function()
    vim.cmd(vim.bo.modifiable and 'startinsert' or 'stopinsert')
  end)
})

vim.api.nvim_create_autocmd('ModeChanged', {
  group = group,
  pattern = '[vV\22sS\19]:n',
  callback = vim.schedule_wrap(function()
    if vim.bo.modifiable then vim.cmd 'startinsert' end
  end)
})
