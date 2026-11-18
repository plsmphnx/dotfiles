local icon = require 'icon'

local lualine_highlight = require 'lualine.highlight'
local function filetype_status()
  local ico, hl = MiniIcons.get('filetype', vim.bo.filetype)
  return '%#' .. hl .. '#' .. ico .. ' ' ..
      lualine_highlight.format_highlight('x', true) .. vim.bo.filetype
end

local theme = require 'lualine.themes.auto'
local color = require 'vscode.colors'.get_colors()
for _, colors in pairs(theme) do
  colors.x = colors.x or colors.c
  colors.c = { fg = color.vscSplitDark }
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
    lualine_b = {},
    lualine_c = {
      { 'diff',
        padding = { left = 1, right = 0 },
        on_click = function() MiniDiff.toggle_overlay() end,
      },
      { 'diagnostics',
        padding = { left = 1, right = 0 },
        symbols = {
          error = icon.diagnostics.error .. ' ',
          warn = icon.diagnostics.warn .. ' ',
          hint = icon.diagnostics.hint .. ' ',
          info = icon.diagnostics.info .. ' ',
        },
        update_in_insert = true,
        on_click = function()
          Snacks.picker.diagnostics_buffer { enter = false }
        end,
      },
      { 'filename', color = { fg = 'white' } } },
    lualine_x = {
      { 'lsp_status',
        padding = { left = 1, right = 0 },
      },
      { filetype_status,
        padding = { left = 1, right = 0 },
        on_click = function() Snacks.picker.filetype() end,
      },
      { 'vim.bo.expandtab and tostring(vim.bo.tabstop) or "\u{00bb}"',
        icon = { '\u{f0312}', color = { fg = 'gray' } },
        padding = 1,
        on_click = function()
          Snacks.input.input({
            prompt = 'Indentation',
            default = tostring(vim.bo.tabstop),
            win = { relative = 'win' },
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
  inactive_sections = { lualine_b = { 'mode' } },
}

vim.api.nvim_create_autocmd('BufWinEnter', {
  callback = vim.schedule_wrap(function(event)
    if vim.api.nvim_buf_is_valid(event.buf) then
      local win = vim.fn.bufwinid(event.buf)
      if vim.api.nvim_win_is_valid(win) then
        vim.wo[win].fillchars =
            vim.go.fillchars .. ',stl:\u{2500},stlnc:\u{2500}'
      end
    end
  end)
})
