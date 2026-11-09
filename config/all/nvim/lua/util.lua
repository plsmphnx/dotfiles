local M = {}

M.keys = function(map)
    for mode, keys in pairs(map) do
        for key, cmd in pairs(keys) do
            key = '<' .. key:gsub('_', '-') .. '>'
            vim.keymap.set(mode, key, cmd, { silent = true })
        end
    end
end

M.opts = function(map)
    for opt, val in pairs(map) do vim.opt[opt] = val end
end

return M
