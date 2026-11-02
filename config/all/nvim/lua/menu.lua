local function default(bufnr)
    local entries = {}

    if vim.lsp.get_clients { bufnr = bufnr } [1] then
        entries[#entries + 1] = {
            'a', 'Go to definition', '<Cmd>lua vim.lsp.buf.definition()<CR>'
        }
        entries[#entries + 1] = { 'a', '-1-', '<Nop>' }
    end

    for _, e in ipairs {
        { 'v', 'Cut',        '"+x'             },
        { 'v', 'Copy',       '"+y'             },
        { 'a', 'Paste',      '"+gP'            },
        { 'v', 'Paste',      '"+P'             },
        { 'v', 'Delete',     '"_x'             },
        { 'n', 'Select All', 'ggVG'            },
        { 'v', 'Select All', 'gg0oG$'          },
        { 'i', 'Select All', '<C-Home><C-O>VG' },
    } do entries[#entries + 1] = e end

    return entries
end

local filetype = {}

local function popup(entries)
    entries = entries or default
    vim.cmd.aunmenu 'PopUp'
    for _, e in ipairs(entries) do
        local label = e[2]:gsub(' ', [[\ ]])
        vim.cmd(e[1] .. 'noremenu PopUp.' .. label .. ' ' .. e[3])
    end
end

vim.api.nvim_del_augroup_by_name 'nvim.popupmenu'

vim.api.nvim_create_autocmd('MenuPopup', {
    group = vim.api.nvim_create_augroup('MenuPopup', { clear = true }),
    pattern = '*',
    callback = function(args)
        local menu = filetype[vim.bo[args.buf].filetype] or default
        vim.cmd.aunmenu 'PopUp'
        for _, e in ipairs(menu(args.buf)) do
            local label = e[2]:gsub(' ', [[\ ]])
            vim.cmd(e[1] .. 'noremenu PopUp.' .. label .. ' ' .. e[3])
        end
    end
})

return { filetype = filetype }
