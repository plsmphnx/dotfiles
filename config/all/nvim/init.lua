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
require('menu')
require('plugins')

for mode, keys in pairs(require 'keymap') do
    local modes = {}
    for m in string.gmatch(mode, '.') do modes[#modes+1] = m end
    for key, cmd in pairs(keys) do
        vim.keymap.set(modes, key, cmd, { silent = true })
    end
end

pcall(require, 'local')
