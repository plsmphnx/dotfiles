return {
  title = true,
  cmdheight = 0,
  colorcolumn = '80,120',
  shortmess = vim.opt.shortmess + 'I',
  confirm = true,

  pumborder = 'rounded',
  winborder = 'rounded',

  clipboard = 'unnamedplus',
  selection = 'exclusive',
  selectmode = 'mouse,key',
  virtualedit = 'onemore',
  keymodel = 'startsel,stopsel',
  backspace = 'indent,eol,start',
  whichwrap = '<,>,[,]',

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
