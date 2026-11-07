for k, v in pairs(require'opt') do vim.opt[k] = v end

require'vim._core.ui2'.enable()
require'menu'
require'plugins'

vim.opt.shortmess:append'I'
vim.opt.virtualedit = 'onemore'
vim.g.clipboard = 'osc52'

local editbuf = { [''] = true, prompt = true, terminal = true }
vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('InsertLock', { clear = true }),
    pattern = '*',
    callback = function() vim.schedule(function()
        vim.cmd(editbuf[vim.bo.buftype] and 'startinsert' or 'stopinsert')
    end) end
})

for mode, keys in pairs(require'keymap') do
    local modes = {}
    for m in string.gmatch(mode, '.') do modes[#modes+1] = m end
    for key, cmd in pairs(keys) do
        vim.keymap.set(modes, key, cmd, { silent = true })
    end
end

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
