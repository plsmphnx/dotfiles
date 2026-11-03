require('snacks').setup {
    bigfile = { enabled = true },
    indent = {
        enabled = true,
        animate = { enabled = false },
    },
    picker = {
        enabled = true,
        layout = { preset = 'ivy' },
    },
    quickfile = { enabled = true },
    scroll = { enabled = true },
}

local function tree_cmd(cmd)
    return '<Cmd>lua require("nvim-tree.api").' .. cmd .. '()<CR>'
end
require('menu').filetype['NvimTree'] = function() return {
    { 'a', '\u{f0214} Create', tree_cmd 'fs.create' },
    { 'a', '-1-', '<Nop>' },
    { 'a', '\u{f01d8} Copy Path', tree_cmd 'fs.copy.absolute_path' },
    { 'a', '-2-', '<Nop>' },
    { 'a', '\u{f0455} Rename', tree_cmd 'fs.rename' },
    { 'a', '\u{f01b4} Delete', tree_cmd 'fs.remove' },
} end

require('nvim-tree').setup {
    git = { ignore = false },
    hijack_cursor = true,
    update_focused_file = { enable = true },
    actions = { open_file = { resize_window = false } },
    on_attach = function(buffer)
        local api = require('nvim-tree.api')
        api.map.on_attach.default(buffer)
        vim.keymap.set({ 'i', 'n', 'v' }, '<LeftRelease>', function()
            if vim.fn.getmousepos().winid == vim.fn.bufwinid(buffer) then
                api.node.open.edit()
            end
        end, { buffer = buffer, silent = true })
    end
}

require('guess-indent').setup {}

require('nvchad')

vim.schedule(function()
    vim.api.nvim_del_augroup_by_name 'ReloadNvChad'
end)

if vim.fn.isdirectory(vim.g.base46_cache) == 0 then
    require('base46').compile()
end
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
    dofile(vim.g.base46_cache .. v)
end
