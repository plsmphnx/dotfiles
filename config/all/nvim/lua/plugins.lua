require'mini.basics'.setup { mappings = { enable = false } }
require'mini.bufremove'.setup {}
require'mini.cmdline'.setup {}
require'mini.icons'.setup {
    default = { directory = { hl = 'MiniIconsGrey' } },
}
require'mini.pairs'.setup {}
require'mini.sessions'.setup {
    directory = vim.fn.stdpath 'state' .. '/session/',
    file = '',
}

MiniIcons.mock_nvim_web_devicons()

require'bufferline'.setup {
    options = {
        indicator = { style = 'none' },
        separator_style = { '', '' },
        offsets = { {
            filetype = 'snacks_layout_box',
            separator = true,
            highlight = 'TabLineFill',
        } },
        hover = { enabled = true, delay = 200, reveal = { 'close' } },
        always_show_bufferline = false,
        close_command = MiniBufremove.delete,
        right_mouse_command = MiniBufremove.delete,
    },
}

require'guess-indent'.setup {}

require'lualine'.setup {
    options = {
        disabled_filetypes = { statusline = { 'snacks_layout_box' } },
        ignore_focus = { 'snacks_picker_list', 'snacks_picker_input' },
        section_separators = '',
        component_separators = '',
    },
    sections = {
        lualine_b = {
            { 'diff', on_click = function()
                Snacks.picker.git_diff { group = true }
            end },
            { 'diagnostics', update_in_insert = true, on_click = function()
                 Snacks.picker.diagnostics_buffer()
            end },
        },
        lualine_x = {
            'lsp_status',
            { 'filetype', fmt = function(ft)
                return ft == '' and ' ' or ft
            end, on_click = function()
                vim.ui.select(vim.fn.getcompletion('', 'filetype'), {
                    prompt = 'File Type',
                    format_item = function(ft)
                        return MiniIcons.get('filetype', ft) .. ' ' .. ft
                    end
                }, function(choice)
                    if choice then vim.bo.filetype = choice end
                end)
            end },
        },
        lualine_y = {},
    },
}

require'snacks'.setup {
    bigfile = { enabled = true },
    explorer = { enabled = true },
    indent = {
        enabled = true,
        animate = { enabled = false },
        scope = { enabled = true },
    },
    picker = {
        enabled = true,
        hidden = true,
        ignored = true,
        layout = { preset = 'ivy_split' },
        layouts = { ivy_split = { layout = { height = 0.25 } } },
        sources = { explorer = { layout = { auto_hide = { 'input' } } } },
        win = { input = { keys = {
            ['<Esc>'] = { 'close', mode = { 'i', 'n', 'v' } },
        } } },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = {
        enabled = true,
        folds = { open = true, git_hl = true },
    },
}

local menu = require'menu'
menu.filetype.snacks_picker_list = function(bufnr)
    return {
        { 'a', '\u{f0214} Create', 'a' },
        { 'a', '-1-', '<Nop>' },
        { 'a', '\u{f0455} Rename', 'r' },
        { 'a', '\u{f01b4} Delete', 'd' },
    }
end

local c = require'vscode.colors'.get_colors()
require'vscode'.setup {
    transparent = true,
    group_overrides = {
        PmenuBorder = { fg = c.vscSplitDark },

        TabLine = { bg = 'NONE' },
        TabLineSel = { bg = 'NONE' },
        TabLineFill = { bg = 'NONE' },

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
vim.cmd.colorscheme'vscode'
