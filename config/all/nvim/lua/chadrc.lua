return {
    base46 = {
        theme = 'vscode_dark',
        integrations = { 'gitsigns' },
        hl_override = {
            Pmenu = { bg = 'black' },
        },
        hl_add = {
            PmenuBorder = { fg = 'grey' },
            SnacksIndent = { fg = 'grey' },
            SnacksIndentScope = { fg = 'light_grey' },
        }
    },
    ui = {
        tabufline = { order = { 'treeOffset', 'buffers', 'tabs' } },
        statusline = { theme = 'vscode_colored' },
    },
}
