vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    callback = function()
        vim.cmd(vim.bo.buftype == '' and 'startinsert' or 'stopinsert')
    end,
})

for k, v in pairs {
    mouse = 'a',
    number = true,
    termguicolors = true,
    fillchars = { eob = ' ' },
    cmdheight = 0,

    backup = false,
    writebackup = false,

    selection = 'exclusive',
    selectmode = 'mouse,key',
    keymodel = 'startsel,stopsel',
    virtualedit = 'onemore',
    whichwrap = '<,>,[,]',

    expandtab = true,
    shiftwidth = 4,
    tabstop = 4,
    softtabstop = 4,
} do vim.opt[k] = v end

for k, v in pairs {
    ['<C-X>'] = 'normal! "+x',
    ['<C-C>'] = 'normal! "+y',
    ['<C-V>'] = 'normal! "+gP',
    ['<C-Z>'] = 'undo',
    ['<C-Y>'] = 'redo',
    ['<C-A>'] = 'normal! ggVG',
    ['<C-S>'] = 'update',
    ['<C-Q>'] = 'quitall',
} do vim.keymap.set({'i', 'n', 'v'}, k, "<Cmd>" .. v .. "<CR>") end

local vline = '\226\148\130'

for k, v in pairs {
    bufferline = {
        options = {
            offsets = { { filetype = 'NvimTree', separator = true } },
        },
    },
    lualine = {
        extensions = { 'nvim-tree' },
        options = {
            section_separators = { left = '', right = '' },
            component_separators = { left = vline, right = vline },
        },
    },
    hover = {},
    ['nvim-tree'] = {
        update_focused_file = { enable = true },
        renderer = { root_folder_label = false },
    },
} do require(k).setup(v) end

vim.g.clipboard = 'osc52'
vim.o.mousemoveevent = true
vim.cmd.colorscheme 'vscode'
