require 'vim._core.ui2'.enable { msg = { targets = 'msg' } }
require 'menu'
require 'plugins'
vim.cmd 'source $VIMRUNTIME/scripts/mswin.vim'

for k, v in pairs(require 'opt') do vim.opt[k] = v end

vim.g.clipboard = 'osc52'

vim.diagnostic.config { update_in_insert = true }

for mode, keys in pairs(require 'keymap') do
  for key, cmd in pairs(keys) do
    vim.keymap.set(mode, key, cmd, { silent = true })
  end
end

local editbuf = { [''] = true, prompt = true, terminal = true }
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('InsertLock', { clear = true }),
  pattern = '*',
  callback = function()
    vim.schedule(function()
      vim.cmd(editbuf[vim.bo.buftype] and 'startinsert' or 'stopinsert')
    end)
  end
})

pcall(require, 'local')

--[[
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('SessionActivate', { clear = true }),
  callback = function()
    local arg = vim.fn.argv(0)
    if vim.fn.isdirectory(arg) == 1 then
      local n = vim.fn.fnamemodify(arg, ':p'):sub(2, -2):gsub('/', '%%')
      if MiniSessions.detected[n] then
        MiniSessions.read(n)
      else
        MiniSessions.write(n)
      end
    end
  end
})
]]
