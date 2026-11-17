local icon = require 'icon'

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
  lazygit = { enabled = true },
  picker = {
    enabled = true,
    hidden = true,
    ignored = true,
    icons = { diagnostics = {
      Error = icon.diagnostics.error .. ' ',
      Warn = icon.diagnostics.warn .. ' ',
      Hint = icon.diagnostics.hint .. ' ',
      Info = icon.diagnostics.info .. ' ',
    } },
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
  [vim.diagnostic.severity.ERROR] = icon.diagnostics.error,
  [vim.diagnostic.severity.WARN]  = icon.diagnostics.warn,
  [vim.diagnostic.severity.HINT]  = icon.diagnostics.hint,
  [vim.diagnostic.severity.INFO]  = icon.diagnostics.info,
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
