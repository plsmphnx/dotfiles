for plug, opt in pairs {
    cmdline = {},
    icons = { default = { directory = { hl = 'MiniIconsGrey' } } },
    map = {
        window = {
            width = 1,
            winblend = 100,
            show_integration_count = false,
        },
    },
    pairs = {},
    sessions = {
        directory = vim.fn.stdpath 'state' .. '/session/',
        file = '',
    },
} do require('mini.' .. plug).setup(opt) end

MiniIcons.mock_nvim_web_devicons()

require('snacks').setup {
    bigfile = { enabled = true },
    explorer = { enabled = true },
    indent = {
        enabled = true,
        animate = { enabled = false },
    },
    picker = {
        enabled = true,
        hidden = true,
        ignored = true,
        layout = { preset = 'ivy' },
        sources = {
            explorer = { layout = { auto_hide = { "input" } } },
        },
    },
    quickfile = { enabled = true },
    scroll = { enabled = true },
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'snacks_picker_list',
    callback = function(args) vim.bo[args.buf].buflisted = false end,
})

local menu = require('menu')
menu.filetype.snacks_picker_list = function(bufnr)
    return {
        { 'a', '\u{f0214} Create', 'a' },
        { 'a', '-1-', '<Nop>' },
        { 'a', '\u{f0455} Rename', 'r' },
        { 'a', '\u{f01b4} Delete', 'd' },
    }
end

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
