for _, g in ipairs {'g', 'opt'} do
    for k, v in pairs(require(g)) do vim[g][k] = v end
end

local custom = vim.api.nvim_create_augroup('CustomCommands', { clear = true })

local editbuf = { [''] = true, prompt = true, terminal = true }
vim.api.nvim_create_autocmd('BufEnter', {
    group = custom,
    pattern = '*',
    callback = function() vim.schedule(function()
        vim.cmd(editbuf[vim.bo.buftype] and 'startinsert' or 'stopinsert')
    end) end
})

for k, v in pairs(require 'keymap') do vim.keymap.set(
    {'i', 'n', 'v'}, k,
    type(v) == 'string' and '<Cmd>' .. v .. '<CR>' or v
) end

require('vim._core.ui2').enable()
require('nvim-tree').setup {
    git = { ignore = false },
    hijack_cursor = true,
    update_focused_file = { enable = true },
}
require('nvchad')
require('base46').load_all_highlights()

pcall(require, 'local')
