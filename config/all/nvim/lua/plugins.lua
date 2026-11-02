require('nvchad')

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

if vim.fn.isdirectory(vim.g.base46_cache) == 0 then
    require('base46').compile()
end
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
    dofile(vim.g.base46_cache .. v)
end

local function menu(opts)
    local options = {}
    for _, o in ipairs(opts) do options[#options + 1] = o[1] end
    vim.ui.select(options, {}, function(choice)
        for _, o in ipairs(opts) do if choice == o[1] then o[2]() end end
    end)
end

require('nvim-tree').setup {
    git = { ignore = false },
    hijack_cursor = true,
    update_focused_file = { enable = true },
    on_attach = function(bufnr)
        local api = require('nvim-tree.api')
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set({ 'i', 'n', 'v' }, '<RightMouse>', function() menu {
            { 'Create', api.fs.create },
            { 'Delete', api.fs.remove },
            { 'Rename', api.fs.rename },
            { 'Copy Path', api.fs.copy.absolute_path },
        } end, { buffer = bufnr, silent = true })
        vim.keymap.set({ 'i', 'n', 'v' }, '<LeftRelease>',
            api.node.open.edit,
            { buffer = bufnr, silent = true })
    end
}

vim.schedule(function()
    vim.api.nvim_create_augroup('ReloadNvChad', { clear = true })
end)
