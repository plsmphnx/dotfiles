return {
    mousemoveevent = true,

    title = true,
    cmdheight = 0,
    colorcolumn = '80,120',

    pumborder = 'rounded',
    winborder = 'single',

    selection = 'exclusive',
    selectmode = 'mouse,key',
    keymodel = 'startsel,stopsel',
    whichwrap = '<,>,[,]',

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

    sessionoptions = 'tabpages,winsize',
}
