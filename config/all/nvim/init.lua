for _, g in ipairs { 'g', 'opt' } do
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
    { 'i', 'n', 'v' }, k,
    type(v) == 'string' and '<Cmd>' .. v .. '<CR>' or v,
    { silent = true }
) end

require('vim._core.ui2').enable()
require('nvchad')
require('snacks').setup {
    bigfile = { enabled = true },
    indent = {
        enabled = true,
        animate = { enabled = false },
        hl = 'IblChar',
        scope = { hl = 'IblScopeChar' },
    },
    picker = {
        enabled = true,
        layout = { preset = 'ivy' },
    },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    words = { enabled = true },
}

if vim.fn.isdirectory(vim.g.base46_cache) == 0 then
    require('base46').compile()
end
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
    dofile(vim.g.base46_cache .. v)
end

require('nvim-tree').setup {
    git = { ignore = false },
    hijack_cursor = true,
    update_focused_file = { enable = true },
}

vim.schedule(function()
    vim.api.nvim_create_augroup('ReloadNvChad', { clear = true })
end)

pcall(require, 'local')
