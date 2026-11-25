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

local function list_focused(self)
  return not self.closed and self.list.win.win == vim.api.nvim_get_current_win()
end

local function persist(opts)
  return vim.tbl_deep_extend('force', {
    layout = { preset = 'bottom', preview = false },
    auto_close = false,
    jump = { close = false },
    on_show = function(self)
      self.list.win:on('WinEnter', function()
        if not self.closed then self._main:update() end
      end)
    end,
  }, opts or {})
end

local function autojump(opts)
  return vim.tbl_deep_extend('force', {
    on_change = function(self, item)
      if item and list_focused(self) then
        vim.schedule(function()
          if self:current() == item and list_focused(self) then
            self:action { 'jump', 'focus_list' }
          end
        end)
      end
    end,
    win = {
      list = {
        keys = {
          ['<LeftRelease>'] = {
            { 'jump', 'focus_list' },
            mode = { 'i', 'n', 'v' },
          }
        }
      }
    },
  }, persist(opts))
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
      actions = { quit = require 'edit.cmds'.quit },
    },
  },
  lazygit = {
    enabled = true,
    config = {
      gui = {
        fileTreeSortOrder = 'foldersFirst',
        showCommandLog = false,
        showBottomLine = false,
        showRandomTip = false,
      },
      disableStartupPopups = true,
    },
  },
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
      horizontal = {
        layout = {
          width = 7 / 8,
          height = 7 / 8,
          box = 'vertical',
          { win = 'preview', height = 1 / 2, border = true },
          {
            box = 'vertical',
            border = true,
            title = '{title} {live}',
            { win = 'input', height = 1, border = 'bottom' },
            { win = 'list' },
          },
        },
      },
      ivy = { layout = { height = 1 / 4 } },
      sidebar = { layout = { width = 1 / 5 } },
    },
    sources = {
      buffers = persist {
        layout = { hidden = { 'input' } },
        sort_lastused = false,
        matcher = { sort_empty = true },
        sort = { fields = { 'file:asc' } },
        win = { list = {
          keys = {
            ['<LeftRelease>'] = { 'confirm', mode = { 'i', 'n', 'v' } },
            ['<RightRelease>'] = { 'bufdelete', mode = { 'i', 'n', 'v' } },
          },
          on_buf = function(win) vim.b[win.buf].menu = function() end end
        } },
      },
      diagnostics_buffer = autojump { layout = { hidden = { 'input' } } },
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
      grep = autojump {
        follow = true,
        matcher = { fuzzy = false },
        args = { '--sort=path' },
      },
      lines = autojump {
        matcher = { fuzzy = false },
        sort = { fields = { 'idx' } },
      },
      lsp_definitions = autojump { layout = { hidden = { 'input' } } },
      lsp_references = autojump { layout = { hidden = { 'input' } } },
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
    actions = { quit = require 'edit.cmds'.quit },
    on_close = require 'edit.keys'.insert
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
  'BufEnter',
  'BufDelete',
  'BufWipeout',
  'BufModifiedSet',
}, {
  group = vim.api.nvim_create_augroup('SnacksBuffersRefresh', { clear = true }),
  callback = function(event)
    if vim.bo[event.buf].buflisted then
      for _, picker in ipairs(Snacks.picker.get { source = 'buffers' }) do
        vim.schedule(function()
          if not picker.closed then picker:find { refresh = true } end
        end)
      end
    end
  end,
})
