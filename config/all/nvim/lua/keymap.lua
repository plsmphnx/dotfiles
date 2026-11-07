function cmd(cmd) return '<Cmd>' .. cmd .. '<CR>' end

return {
    inv = {
        ['<C-X>'] = cmd'normal! "+x',
        ['<C-C>'] = cmd'normal! "+y',
        ['<C-V>'] = cmd'normal! "+gP',
        ['<C-Z>'] = cmd'undo',
        ['<C-Y>'] = cmd'redo',
        ['<C-A>'] = cmd'normal! ggVG',
        ['<C-S>'] = cmd'update',
        ['<C-Q>'] = cmd'quitall!',
        ['<C-F>'] = function() Snacks.picker.lines() end,
        ['<C-S-F>'] = function() Snacks.picker.grep() end,
        ['<C-H>'] = function() Snacks.picker.help() end,
        ['<C-B>'] = function() Snacks.picker.explorer() end,
        ['<C-P>'] = function() Snacks.picker.pickers() end,
        ['<Home>'] = function()
            local col = vim.fn.col'.'
            vim.cmd'normal! ^'
            if col == vim.fn.col'.' then vim.cmd'normal! 0' end
        end,
    },
    v = {
        ['<Tab>'] = '>gv',
        ['<S-Tab>'] = '<gv',
    }
}
