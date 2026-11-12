require 'util'.opts {
  title = not vim.g.present,
  laststatus = vim.g.present and 0 or 2,

  cmdheight = 0,
  cursorline = vim.g.project ~= nil,
  colorcolumn = vim.g.project and '80,120' or '',
  shortmess = vim.opt.shortmess + 'I',
  swapfile = false,

  background = 'dark',
  pumborder = 'rounded',
  winborder = 'rounded',

  expandtab = true,
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 4,

  foldmethod = 'expr',
  foldexpr = 'v:lua.vim.treesitter.foldexpr()',
  foldtext = '',
  foldlevel = 99,
  foldlevelstart = 99,

  spell = not vim.g.present,
  spelllang = { 'en_us' },

  completeopt = 'fuzzy,menuone,noselect,nosort',
}
