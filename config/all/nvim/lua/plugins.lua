for plug, opt in pairs {
    cmdline = {},
    icons = { default = { directory = { hl = 'MiniIconsGrey' } } },
    pairs = {},
    sessions = {
        directory = vim.fn.stdpath 'state' .. '/session/',
        file = '',
    },
} do require('mini.' .. plug).setup(opt) end

MiniIcons.mock_nvim_web_devicons()

local c = require('vscode.colors').get_colors()

for plugin, config in pairs {
    bufferline = {
        options = {
            separator_style = { '', '' },
            offsets = { { filetype = 'snacks_layout_box', separator = true } },
            hover = { enabled = true, delay = 200, reveal = { 'close' } },
        },
    },
    lualine = {
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
            lualine_x = { 'filetype' },
            lualine_y = {},
        },
    },
    snacks = {
        bigfile = { enabled = true },
        explorer = { enabled = true },
        indent = {
            enabled = true,
            animate = { enabled = false },
        },
        picker = {
            enabled = true,
            hidden = true,
            ignored = true,
            layout = { preset = 'ivy_split' },
            layouts = { ivy_split = { layout = { height = 0.25 } } },
            sources = { explorer = { layout = { auto_hide = { "input" } } } },
        },
        quickfile = { enabled = true },
        scroll = { enabled = true },
    },
    vscode = {
        transparent = true,
        group_overrides = {
            PmenuBorder = { fg = c.vscGray },

            MiniIconsAzure = { fg = c.vscAccentBlue },
            MiniIconsBlue = { fg = c.vscBlue },
            MiniIconsCyan = { fg = c.vscCyan },
            MiniIconsGreen = { fg = c.vscGreen },
            MiniIconsGrey = { fg = c.vscGrey },
            MiniIconsOrange = { fg = c.vscOrange },
            MiniIconsPurple = { fg = c.vscViolet },
            MiniIconsRed = { fg = c.vscRed },
            MiniIconsYellow = { fg = c.vscYellow },
        },
    },
    ['guess-indent'] = {},
} do require(plugin).setup(config) end

local menu = require('menu')
menu.filetype.snacks_picker_list = function(bufnr)
    return {
        { 'a', '\u{f0214} Create', 'a' },
        { 'a', '-1-', '<Nop>' },
        { 'a', '\u{f0455} Rename', 'r' },
        { 'a', '\u{f01b4} Delete', 'd' },
    }
end

vim.cmd.colorscheme 'vscode'
