vim.cmd('startinsert')

for k, v in pairs {
    mouse = 'a',
    number = true,
    termguicolors = true,
    fillchars = { eob = ' ' },

    backup = false,
    writebackup = false,

    selection = 'exclusive',
    selectmode = 'mouse,key',
    keymodel = 'startsel,stopsel',
    virtualedit = 'onemore',

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

vim.g.clipboard = 'osc52'

require('nvim-tree').setup {}
require('vscode').setup { transparent = true }

vim.cmd.colorscheme 'vscode'
