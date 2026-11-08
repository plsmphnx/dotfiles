return {
  title = true,
  cmdheight = 0,
  colorcolumn = '80,120',
  shortmess = vim.opt.shortmess + 'I',

  pumborder = 'rounded',
  winborder = 'rounded',

  mousemodel = 'popup_setpos',
  virtualedit = 'onemore',

  expandtab = true,
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 4,

  foldmethod = 'expr',
  foldexpr = 'v:lua.vim.treesitter.foldexpr()',
  foldtext = '',
  foldlevel = 99,
  foldlevelstart = 99,

  spell = true,
  spelllang = { 'en_us' },

  sessionoptions = 'tabpages,winsize',
}
