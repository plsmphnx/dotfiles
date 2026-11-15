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
    s_esc = '<Esc>',
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
    s_esc = '<C-G>',
  },
  x = {
    esc = '<C-G>',
  },
  c = {
    c_v = '<C-R>+',
  },
}

for mode, cmds in pairs {
  i = {
    function(k) return '<Cmd>normal! ' .. k .. '<CR>' end,
    function(k)
      local move = vim.fn.col '.' == 1 and '' or 'l'
      return '<Esc>' .. move .. 'v<Cmd>silent! normal! ' .. k .. '<CR><C-G>'
    end,
  },
  n = {
    function(k) return k end,
    function(k) return 'v' .. k end,
  },
  x = {
    function(k) return '<Esc>' .. k end,
    function(k) return k end,
  },
  s = {
    function(k) return '<Esc>' .. k .. 'i' end,
    function(k) return '<C-G><Cmd>silent! normal! ' .. k .. '<CR><C-G>' end,
  },
} do
  for key, map in pairs {
    Down = { 'gj', '<C-N>', '$l', function() return vim.fn.line '$' end },
    Up = { 'gk', '<C-P>', '0', function() return 1 end },
  } do
    for idx, mod in ipairs { '', 'S-' } do
      vim.keymap.set(mode, '<' .. mod .. key .. '>', function()
        if vim.fn.pumvisible() == 1 then return map[2] end
        if vim.fn.line '.' == map[4]() then return cmds[idx](map[3]) end
        return cmds[idx](map[1])
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
