for _, g in ipairs { 'g', 'opt' } do
    for k, v in pairs(require(g)) do vim[g][k] = v end
end

local editbuf = { [''] = true, prompt = true, terminal = true }
vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('InsertLock', { clear = true }),
    pattern = '*',
    callback = function() vim.schedule(function()
        vim.cmd(editbuf[vim.bo.buftype] and 'startinsert' or 'stopinsert')
    end) end
})

require('vim._core.ui2').enable()
require('plugins')

for k, v in pairs(require 'keymap') do
    vim.keymap.set({ 'i', 'n', 'v' }, k,
        type(v) == 'string' and '<Cmd>' .. v .. '<CR>' or v,
        { silent = true })
end

pcall(require, 'local')
