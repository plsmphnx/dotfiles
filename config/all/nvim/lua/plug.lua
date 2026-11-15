local c = require 'vscode.colors'.get_colors()

require 'vscode'.setup {
  transparent = true,
  color_overrides = { vscPopupBack = 'NONE' },
  group_overrides = {
    FloatBorder = { fg = c.vscSplitDark },
    PmenuBorder = { fg = c.vscSplitDark },
    StatusLine = { fg = c.vscSplitDark },
    StatusLineNC = { fg = c.vscSplitDark },

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

----

require 'mini.ai'.setup {}
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
  return vim.fn.pumvisible() == 1 and (
    vim.fn.complete_info { 'selected' }.selected == -1
    and '<C-N><C-Y>' or '<C-Y>'
  ) or '<Tab>'
end, { expr = true })

vim.api.nvim_create_autocmd('ModeChanged', {
  group = vim.api.nvim_create_augroup('SnippetSelection', { clear = true }),
  pattern = '*:[vV\22sS\19]',
  callback = function()
    vim.o.selection = vim.snippet and vim.snippet.active()
        and 'inclusive' or 'exclusive'
  end
})

vim.keymap.set('s', '/', '<Esc>/', { remap = true })

----

require 'guess-indent'.setup {}

----

local function single_click(opts)
  return vim.tbl_deep_extend('force', {
    win = {
      list = {
        keys = {
          ['<LeftRelease>'] = { 'confirm', mode = { 'i', 'n', 'v' } },
        }
      }
    }
  }, opts or {})
end

local function persist(opts)
  return vim.tbl_deep_extend('force', {
    layout = { preset = 'bottom', preview = false },
    auto_close = false,
    jump = { close = false },
  }, single_click(opts))
end

local explorer_menu = {}
for mode, prefix in pairs { [''] = '', i = '<Esc>' } do
  vim.list_extend(explorer_menu, {
    { mode, '\u{f0214} Create', prefix .. 'a',     true },
    { mode, '-1-',              '<Nop>' },
    { mode, '\u{eb57} HSplit',  prefix .. '<C-S>', true },
    { mode, '\u{eb56} VSplit',  prefix .. '<C-V>', true },
    { mode, '-2-',              '<Nop>' },
    { mode, '\u{f0455} Rename', prefix .. 'r',     true },
    { mode, '\u{f01b4} Delete', prefix .. 'd',     true },
  })
end

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
      actions = { quit = require 'cmds'.quit },
    },
  },
  picker = {
    enabled = true,
    hidden = true,
    ignored = true,
    layout = { preset = 'horizontal' },
    layouts = {
      bottom = { layout = { height = 0.25 } },
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
      buffers = persist {
        layout = { hidden = { 'input' } },
        win = { list = {
          keys = {
            ['<RightRelease>'] = { 'bufdelete', mode = { 'i', 'n', 'v' } },
          },
          on_buf = function(win) vim.b[win.buf].menu = function() end end
        } },
      },
      diagnostics_buffer = persist { layout = { hidden = { 'input' } } },
      explorer = single_click {
        layout = { hidden = { 'input' } },
        win = { list = {
          keys = { ['<Esc>'] = false },
          on_buf = function(win)
            vim.b[win.buf].menu = function() return explorer_menu end
          end
        } },
      },
      filetype = single_click {
        title = 'File Type',
        finder = function()
          return vim.tbl_map(function(ft)
            return { text = ft }
          end, vim.fn.getcompletion('', 'filetype'))
        end,
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
      },
      grep = persist {
        follow = true,
        matcher = { fuzzy = false },
        args = { '--sort=path' },
      },
      lines = persist {
        matcher = { fuzzy = false },
        sort = { fields = { 'idx' } },
      },
      pickers = single_click { layout = 'vscode' },
      select = single_click {},
    },
    win = {
      input = { keys = {
        ['<Esc>'] = { 'cancel', mode = { 'i', 'n', 'v' } },
        ['<C-Q>'] = { 'quit', mode = { 'i', 'n', 'v' } },
      } },
      list = { keys = {
        ['<Esc>'] = { 'cancel', mode = { 'i', 'n', 'v' } },
        ['<C-Q>'] = { 'quit', mode = { 'i', 'n', 'v' } },
      } },
      preview = { keys = {
        ['<Esc>'] = { 'cancel', mode = { 'i', 'n', 'v' } },
        ['<C-Q>'] = { 'quit', mode = { 'i', 'n', 'v' } },
      } },
    },
    actions = { quit = require 'cmds'.quit },
    on_close = require 'edit'.insert
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = {
    enabled = true,
    folds = { open = true, git_hl = true },
  },
  styles = {
    minimal = { wo = {
      fillchars = 'eob: ,lastline:\u{2026},stl:\u{2500},stlnc:\u{2500}',
    } },
    split = { wo = {
      statusline = '%@v:lua.snacks_picker_close@%= \u{f0156}  %T',
    } }
  },
  words = { enabled = true },
}

_G.snacks_picker_close = function()
  local winid = vim.fn.getmousepos().winid
  for _, picker in ipairs(Snacks.picker.get()) do
    if picker.layout.root.win == winid then picker:close() end
  end
end

vim.diagnostic.config { signs = { text = {
  [vim.diagnostic.severity.ERROR] = '\u{f015a}',
  [vim.diagnostic.severity.WARN]  = '\u{f002a}',
  [vim.diagnostic.severity.HINT]  = '\u{f0336}',
  [vim.diagnostic.severity.INFO]  = '\u{f02fd}',
} } }

vim.api.nvim_create_autocmd({
  'BufAdd',
  'BufDelete',
  'BufWipeout',
  'BufModifiedSet',
}, {
  group = vim.api.nvim_create_augroup('SnacksBuffersRefresh', { clear = true }),
  callback = function()
    for _, picker in ipairs(Snacks.picker.get { source = 'buffers' }) do
      vim.schedule(function()
        if not picker.closed then picker:find { refresh = true } end
      end)
    end
  end,
})

----

local lualine_highlight = require 'lualine.highlight'
local function filetype_status()
  local ico, hl = MiniIcons.get('filetype', vim.bo.filetype)
  return '%#' .. hl .. '#' .. ico .. ' ' ..
      lualine_highlight.format_highlight('x', true) .. vim.bo.filetype
end

local theme = require 'lualine.themes.vscode'
for _, colors in pairs(theme) do
  colors.x = colors.x or colors.c
  colors.c = { fg = c.vscSplitDark }
end


require 'lualine'.setup {
  options = {
    theme = theme,
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
        on_click = function() MiniDiff.toggle_overlay() end,
      },
      { 'diagnostics',
        padding = { left = 1, right = 0 },
        update_in_insert = true,
        on_click = function() Snacks.picker.diagnostics_buffer() end,
      },
    },
    lualine_c = { { 'filename', color = { fg = 'white' } } },
    lualine_x = {
      { 'lsp_status',
        padding = { left = 1, right = 0 },
      },
      { filetype_status,
        padding = { left = 1, right = 0 },
        on_click = function() Snacks.picker.filetype() end,
      },
      { 'vim.bo.expandtab and tostring(vim.bo.tabstop) or ""',
        icon = { '\u{f0312}', color = { fg = 'gray' } },
        padding = 1,
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

vim.opt.fillchars:append { stl = '\u{2500}', stlnc = '\u{2500}' }
