local telescope = require('telescope.builtin');
return {
    ['<C-X>'] = 'normal! "+x',
    ['<C-C>'] = 'normal! "+y',
    ['<C-V>'] = 'normal! "+gP',
    ['<C-Z>'] = 'undo',
    ['<C-Y>'] = 'redo',
    ['<C-A>'] = 'normal! ggVG',
    ['<C-S>'] = 'update',
    ['<C-Q>'] = 'quitall',
    ['<RightMouse>'] = function()
        require('menu.utils').delete_old_menus()
        require('menu').open(vim.bo[
            vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
        ].ft == 'NvimTree' and 'nvimtree' or 'default', { mouse = true })
    end,
    ['<C-F>'] = telescope.current_buffer_fuzzy_find,
    ['<C-S-F>'] = telescope.live_grep,
}
