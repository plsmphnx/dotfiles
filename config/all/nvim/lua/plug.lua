require 'mini.basics'.setup { mappings = { enable = false } }
require 'mini.bufremove'.setup {}
require 'mini.cmdline'.setup {}
require 'mini.comment'.setup { mappings = { comment_visual = '/' } }
require 'mini.completion'.setup {}
require 'mini.diff'.setup { view = {
  style = 'sign',
  signs = { add = '\u{2590}', change = '\u{2590}', delete = '\u{2582}' },
} }
require 'mini.icons'.setup {
  default = { directory = { hl = 'MiniIconsGrey' } },
}
require 'mini.move'.setup {}
require 'mini.surround'.setup {}

MiniIcons.mock_nvim_web_devicons()

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'snacks_*',
  callback = function() vim.b.minicompletion_disable = true end
})

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

require 'bufferline'.setup {
  options = {
    indicator = { style = 'none' },
    separator_style = { '', '' },
    offsets = { {
      filetype = 'snacks_layout_box',
      separator = true,
      highlight = 'TabLineFill',
    } },
    always_show_bufferline = false,
    close_command = MiniBufremove.delete,
    right_mouse_command = MiniBufremove.delete,
  },
}

----

require 'guess-indent'.setup {}

----

require 'snacks'.setup {
  bigfile = { enabled = true },
  explorer = { enabled = true },
  indent = {
    enabled = true,
    animate = { enabled = false },
    scope = { enabled = true },
  },
  input = {
    enabled = true,
    win = {
      keys = {
        i_esc = { '<Esc>', 'cancel', mode = { 'i', 'v' } },
        a_c_q = { '<C-Q>', 'quit', mode = { 'i', 'n', 'v' } },
      },
      actions = { quit = function() vim.cmd 'qa' end },
    },
  },
  picker = {
    enabled = true,
    hidden = true,
    ignored = true,
    layout = { preset = 'horizontal' },
    layouts = {
      ivy_split = { layout = { height = 0.25 } },
      horizontal = {
        layout = {
          width = 0.9,
          height = 0.9,
          box = 'vertical',
          { win = 'preview', height = 0.5, border = true },
          {
            box = 'vertical',
            border = true,
            title = '{title} {live}',
            { win = 'input', height = 1, border = 'bottom' },
            { win = 'list' },
          },
        },
      }
    },
    sources = {
      diagnostics_buffer = { layout = 'ivy_split' },
      explorer = { layout = { auto_hide = { 'input' } } },
      grep = { layout = 'ivy_split', matcher = { fuzzy = false } },
      lines = { layout = 'ivy_split', matcher = { fuzzy = false } },
      pickers = { layout = 'vscode' },
    },
    win = {
      input = { keys = {
        ['<Esc>'] = { 'cancel', mode = { 'i', 'n', 'v' } },
        ['<C-Q>'] = { 'quit', mode = { 'i', 'n', 'v' } },
      } },
      list = { keys = {
        ['<Esc>'] = { 'cancel', mode = { 'i', 'n', 'v' } },
        ['<C-Q>'] = { 'quit', mode = { 'i', 'n', 'v' } },
        ['<LeftRelease>'] = { 'confirm', mode = { 'i', 'n', 'v' } },
      } },
      preview = { keys = {
        ['<Esc>'] = { 'cancel', mode = { 'i', 'n', 'v' } },
        ['<C-Q>'] = { 'quit', mode = { 'i', 'n', 'v' } },
      } },
    },
    actions = { quit = function() vim.cmd 'qa' end },
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = {
    enabled = true,
    folds = { open = true, git_hl = true },
  },
  words = { enabled = true },
}

local menu = require 'menu'
menu.filetype.snacks_picker_list = function(bufnr)
  return {
    { 'a', '\u{f0214} Create', 'a' },
    { 'a', '-1-',              '<Nop>' },
    { 'a', '\u{f0455} Rename', 'r' },
    { 'a', '\u{f01b4} Delete', 'd' },
  }
end

vim.diagnostic.config { signs = { text = {
  [vim.diagnostic.severity.ERROR] = '\u{f015a}',
  [vim.diagnostic.severity.WARN]  = '\u{f002a}',
  [vim.diagnostic.severity.HINT]  = '\u{f0336}',
  [vim.diagnostic.severity.INFO]  = '\u{f02fd}',
} } }

----

require 'lualine'.setup {
  options = {
    disabled_filetypes = { statusline = { 'snacks_layout_box' } },
    ignore_focus = function(win)
      local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
      return ft:find('snacks_', 1, true) == 1 or ft == 'help'
    end,
    section_separators = '',
    component_separators = '',
  },
  sections = {
    lualine_b = {
      { 'diff',
        padding = { left = 1, right = 0 },
        on_click = function() Snacks.picker.git_diff { group = true } end,
      },
      { 'diagnostics',
        padding = { left = 1, right = 0 },
        update_in_insert = true,
        on_click = function() Snacks.picker.diagnostics_buffer() end,
      },
    },
    lualine_x = {
      { 'lsp_status',
        padding = { left = 0, right = 1 },
      },
      { function()
        local ico, hl = MiniIcons.get('filetype', vim.bo.filetype)
        return '%#' .. hl .. '#' .. ico .. ' %#Normal#' .. vim.bo.filetype
      end,
        padding = { left = 0, right = 1 },
        on_click = function()
          local items = {}
          for _, ft in ipairs(vim.fn.getcompletion('', 'filetype')) do
            items[#items + 1] = { text = ft }
          end
          Snacks.picker {
            title = 'File Type',
            items = items,
            layout = 'vscode',
            format = function(item)
              return {
                { MiniIcons.get('filetype', item.text) },
                { ' ',                                 virtual = true },
                { item.text,                           'Normal' },
              }
            end,
            confirm = function(picker, item)
              picker:close()
              if item then vim.bo.filetype = item.text end
            end,
          }
        end,
      },
      { function()
        local indent = vim.bo.expandtab and vim.bo.tabstop or ''
        return '%#MiniIconsGrey#\u{f0312} %#Normal#' .. indent
      end,
        padding = { left = 0, right = 1 },
        on_click = function()
          Snacks.input.input({
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
  },
}

vim.cmd.colorscheme 'vscode'
