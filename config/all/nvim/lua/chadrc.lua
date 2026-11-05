local stl = require 'nvchad.stl.utils'
_G.stl = {
    diagnostics = function() Snacks.picker.diagnostics_buffer() end,
    git = function() Snacks.picker.git_diff { group = true } end
}

local modules = {
    diagnostics = function()
        local str = stl.diagnostics()
        if str == '' then return '' end
        return '%@v:lua.stl.diagnostics@' .. str .. '%X'
    end,
    git = function()
        local str = stl.git()
        if str == '' then return '' end
        return '%@v:lua.stl.git@' .. str .. '%X'
    end,
    lsp = function()
        return "%#St_Lsp#" .. stl.lsp():gsub(' LSP ~ ', '')
    end,
    cwd = function()
        local explorer = Snacks.picker.get({ source = "explorer" })
        if explorer and #explorer > 0 then return '' end
        local name = vim.fn.fnamemodify(vim.uv.cwd(), ':~:t')
        return '%#St_cwd# \u{f0256} ' .. name .. ' '
    end
}

return {
    base46 = {
        theme = 'vscode_dark',
        integrations = { 'gitsigns' },
        hl_override = {
            Normal = { bg = 'NONE' },
            NormalFloat = { bg = 'NONE' },
            Pmenu = { bg = 'NONE' },
            NvimTreeNormal = { bg = 'NONE' },
            NvimTreeWinSeparator = { bg = 'NONE' },

            Directory = { fg = 'white' },
        },
        hl_add = {
            PmenuBorder = { fg = 'grey' },

            SnacksIndent = { fg = 'grey' },
            SnacksIndentScope = { fg = 'light_grey' },

            MiniIconsAzure = { fg = 'nord_blue' },
            MiniIconsBlue = { fg = 'blue' },
            MiniIconsCyan = { fg = 'cyan' },
            MiniIconsGreen = { fg = 'green' },
            MiniIconsGrey = { fg = { 'grey', 'white', 50 } },
            MiniIconsOrange = { fg = 'orange' },
            MiniIconsPurple = { fg = 'purple' },
            MiniIconsRed = { fg = 'red' },
            MiniIconsYellow = { fg = 'yellow' },
        }
    },
    ui = {
        tabufline = {
            order = { 'treeOffset', 'buffers', 'tabs' },
            treeOffsetFt = 'snacks_picker_list',
        },
        statusline = {
            theme = 'vscode_colored',
            modules = modules,
        },
    },
}
