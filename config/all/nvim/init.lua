local arg = vim.fn.argv(0)
if vim.fn.isdirectory(arg) == 1 then
  vim.g.project = arg
  vim.api.nvim_set_current_dir(arg)
end

vim.g.clipboard = 'osc52'

require 'vim._core.ui2'.enable { msg = { targets = 'msg' } }

require 'plug.misc'
require 'plug.mini'
require 'plug.pick'
require 'plug.line'

require 'edit.keys'
require 'opts'
require 'keys'
require 'menu'

vim.diagnostic.config { update_in_insert = true }
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('StartTreesitter', { clear = true }),
  callback = function(event) pcall(vim.treesitter.start, event.buf) end
})

pcall(require, 'local')
