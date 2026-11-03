local stl = require 'nvchad.stl.utils'
local tree = require 'nvim-tree.view'
_G.stl = {
    diagnostics = function() Snacks.picker.diagnostics_buffer() end,
    git = function() Snacks.picker.git_diff { group = true } end
}

local modules = {}
for k in pairs(_G.stl) do
    modules[k] = function()
        local str = stl[k]()
        if str == '' then return '' end
        return '%@v:lua.stl.' .. k .. '@' .. str .. '%X'
    end
end

modules.lsp = function()
    return "%#St_Lsp#" .. stl.lsp():gsub('LSP ~ ', '')
end

modules.cwd = function()
    if tree.is_visible() then return '' end
    local name = vim.fn.fnamemodify(vim.uv.cwd(), ':~:t')
    return '%#St_cwd# \u{f0256} ' .. name .. ' '
end

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
        statusline = { theme = 'vscode_colored', modules = modules },
    },
}
