for plug, config in pairs {
  ai = {},
  basics = { mappings = { enable = false } },
  bufremove = {},
  cmdline = {},
  colors = {},
  comment = { mappings = { comment_visual = '/' } },
  completion = {},
  diff = { view = {
    style = 'sign',
    signs = { add = '\u{2590}', change = '\u{2590}', delete = '\u{2582}' },
  } },
  hipatterns = { highlighters = {
    trailspace = {  pattern = '%f[%s]%s*$',  group = 'MiniTrailspace' },
  } },
  icons = { default = { directory = { hl = 'MiniIconsGrey' } } },
  move = {},
  surround = {},
  trailspace = {},
} do require('mini.' .. plug).setup(config) end

MiniIcons.mock_nvim_web_devicons()

MiniColors.get_colorscheme():add_transparency {
  float = true,
  statuscolumn = true,
  statusline = true,
}:apply()

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'snacks_*',
  callback = function() vim.b.minicompletion_disable = true end
})

vim.api.nvim_create_autocmd('ModeChanged', {
  group = vim.api.nvim_create_augroup('SnippetSelection', { clear = true }),
  pattern = '*:[vV\22sS\19]',
  callback = function()
    vim.o.selection = vim.snippet and vim.snippet.active()
        and 'inclusive' or 'exclusive'
  end
})

vim.keymap.set('s', '/', '<Esc>/', { remap = true })
