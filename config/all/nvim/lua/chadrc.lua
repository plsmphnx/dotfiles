local stl = require 'nvchad.stl.utils'
local tree = require 'nvim-tree.view'
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
        if tree.is_visible() then return '' end
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
        },
        hl_add = {
            PmenuBorder = { fg = 'grey' },
            SnacksIndent = { fg = 'grey' },
            SnacksIndentScope = { fg = 'light_grey' },
        }
    },
    ui = {
        tabufline = { order = { 'treeOffset', 'buffers', 'tabs' } },
        statusline = { theme = 'vscode_colored', modules = modules },
    },
}
