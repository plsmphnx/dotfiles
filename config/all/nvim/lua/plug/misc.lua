local c = require 'vscode.colors'.get_colors()

require 'vscode'.setup {
  transparent = true,
  group_overrides = {
    FloatBorder = { link = 'WinSeparator' },
    PmenuBorder = { link = 'FloatBorder' },
    StatusLine = { link = 'WinSeparator' },
    StatusLineNC = { link = 'StatusLine' },

    SnacksPickerBorder = { fg = c.vscSplitLight },

    SnacksInputBorder = { link = 'SnacksPickerBorder' },
    SnacksInputTitle = { link = 'SnacksPickerTitle' },
    SnacksInputIcon = { link = 'SnacksPickerIcon' },

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

require 'guess-indent'.setup {}
