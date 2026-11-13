for plug, conf in pairs {
  basics = { mappings = { enable = false } },
  bufremove = {},
  cmdline = {},
  comment = { mappings = { comment_visual = '/' } },
  completion = {},
  diff = { view = {
    style = 'sign',
    signs = { add = '\u{2590}', change = '\u{2590}', delete = '\u{2582}' },
  } },
  extra = {},
  icons = { default = { directory = { hl = 'MiniIconsGrey' } } },
  indentscope = {
    draw = { animation = require('mini.indentscope').gen_animation.none() },
    symbol = '\u{2502}',
  },
  input = {},
  move = {},
  pick = {
    window = {
      config = function()
        local height = math.floor(0.9 * vim.o.lines)
        local width = math.floor(0.9 * vim.o.columns)
        return {
          anchor = 'NW',
          height = height,
          width = width,
          row = math.floor(0.5 * (vim.o.lines - height - 2)),
          col = math.floor(0.5 * (vim.o.columns - width - 2)),
        }
      end,
    },
  },
  surround = {},
} do require('mini.' .. plug).setup(conf) end

MiniIcons.mock_nvim_web_devicons()

vim.keymap.set('i', '<Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-N>' or '<Tab>'
end, { expr = true })

vim.api.nvim_create_autocmd('ModeChanged', {
  group = vim.api.nvim_create_augroup('SnippetSelection', { clear = true }),
  pattern = '*:[vV\22sS\19]',
  callback = function()
    vim.o.selection = vim.snippet and vim.snippet.active()
        and 'inclusive' or 'exclusive'
  end
})

vim.keymap.set('s', '/', '<C-O>/', { remap = true })

----

require 'guess-indent'.setup {}

----

require 'lualine'.setup {
  options = {
    disabled_filetypes = { statusline = { 'neo-tree' } },
    ignore_focus = { 'help', 'minipick', 'neo-tree' },
    section_separators = '',
    component_separators = '',
  },
  sections = {
    lualine_b = {
      { 'diff',
        padding = { left = 1, right = 0 },
        on_click = vim.schedule_wrap(function()
          MiniExtra.pickers.git_hunks()
        end),
      },
      { 'diagnostics',
        padding = { left = 1, right = 0 },
        update_in_insert = true,
        on_click = vim.schedule_wrap(function()
          MiniExtra.pickers.diagnostic { scope = 'current' }
        end),
      },
    },
    lualine_x = {
      { 'lsp_status',
        padding = { left = 0, right = 1 },
      },
      { function()
        local ico, hl = MiniIcons.get('filetype', vim.bo.filetype)
        return '%#' .. hl .. '#' .. ico .. ' %*' .. vim.bo.filetype
      end,
        padding = { left = 0, right = 1 },
        on_click = vim.schedule_wrap(function()
          MiniPick.start { source = {
            items = vim.fn.getcompletion('', 'filetype'),
            name = 'File Type',
            show = function(buf_id, items, query)
              MiniPick.default_show(buf_id, vim.tbl_map(function(item)
                return MiniIcons.get('filetype', item) .. ' ' .. item
              end, items), query)
            end,
            choose = function(item) vim.bo.filetype = item end,
          } }
        end),
      },
      { function()
        local indent = vim.bo.expandtab and vim.bo.tabstop or ''
        return '%#MiniIconsGrey#\u{f0312} %*' .. indent
      end,
        padding = { left = 0, right = 1 },
        on_click = function()
          vim.ui.input({
            prompt = 'Indentation',
            default = tostring(vim.bo.tabstop),
          }, function(input)
            if input then
              if input == '' then
                vim.bo.expandtab = false
              else
                vim.bo.expandtab = true
                vim.bo.tabstop = tonumber(input)
                vim.bo.shiftwidth = tonumber(input)
                vim.bo.softtabstop = tonumber(input)
              end
            end
          end)
        end,
      },
    },
    lualine_y = {},
  },
}

vim.diagnostic.config { signs = { text = {
  [vim.diagnostic.severity.ERROR] = '\u{f015a}',
  [vim.diagnostic.severity.WARN]  = '\u{f002a}',
  [vim.diagnostic.severity.HINT]  = '\u{f0336}',
  [vim.diagnostic.severity.INFO]  = '\u{f02fd}',
} } }

----

require 'neo-tree'.setup {
  window = { mappings = { ['<LeftRelease>'] = 'open' } },
  default_component_configs = {
    indent = { with_expanders = true, with_markers = false },
  },
  source_selector = { statusline = true },
  filesystem = { filtered_items = { visible = true } },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'neo-tree',
  callback = function() vim.b.miniindentscope_disable = true end,
})

require 'menu'.filetype['neo-tree'] = function()
  return {
    { 'a', '\u{f0214} Create', 'a' },
    { 'a', '-1-',              '<Nop>' },
    { 'a', '\u{f0455} Rename', 'r' },
    { 'a', '\u{f01b4} Delete', 'd' },
  }
end

----

local c = require 'vscode.colors'.get_colors()

require 'vscode'.setup {
  transparent = true,
  color_overrides = { vscPopupBack = 'NONE' },
  group_overrides = {
    FloatBorder = { fg = c.vscSplitDark },
    PmenuBorder = { fg = c.vscSplitDark },

    TabLine = { bg = 'NONE' },
    TabLineSel = { bg = 'NONE' },
    TabLineFill = { bg = 'NONE' },

    Added = { fg = c.vscGreen },
    Removed = { fg = c.vscRed },
    Changed = { fg = c.vscBlue },

    MiniIconsAzure = { fg = c.vscAccentBlue },
    MiniIconsBlue = { fg = c.vscBlue },
    MiniIconsCyan = { fg = c.vscBlueGreen },
    MiniIconsGreen = { fg = c.vscGreen },
    MiniIconsGrey = { fg = c.vscGray },
    MiniIconsOrange = { fg = c.vscOrange },
    MiniIconsPurple = { fg = c.vscViolet },
    MiniIconsRed = { fg = c.vscRed },
    MiniIconsYellow = { fg = c.vscYellow },

    MiniIndentscopeSymbol = { fg = c.vscSplitDark },

    NeoTreeExpander = { fg = c.vscSplitDark },
  },
}

vim.cmd.colorscheme 'vscode'
