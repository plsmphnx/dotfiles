return {
    mouse = 'a',
    mousemoveevent = true,

    number = true,
    termguicolors = true,
    fillchars = { eob = ' ' },
    colorcolumn = '80,120',
    cmdheight = 0,
    title = true,
    shortmess = 'aoOWICF',

    pumborder = 'rounded',
    winborder = 'single',

    backup = false,
    writebackup = false,

    selection = 'exclusive',
    selectmode = 'mouse,key',
    keymodel = 'startsel,stopsel',
    virtualedit = 'onemore',
    whichwrap = '<,>,[,]',
    wrap = false,

    tabstop = 4,
    expandtab = true,
    shiftwidth = 0,
    softtabstop = -1,

    foldmethod = 'expr',
    foldexpr = 'v:lua.vim.treesitter.foldexpr()',
    foldtext = '',
    foldlevel = 99,
    foldlevelstart = 99,

    spell = true,
    spelllang = { 'en_us' },

    sessionoptions = 'options,skiprtp,tabpages,winsize',
}
