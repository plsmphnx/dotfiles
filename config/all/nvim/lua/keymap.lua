--local hover_timer = nil
--local debounce_ms = 1000

return {
    ['<C-X>'] = 'normal! "+x',
    ['<C-C>'] = 'normal! "+y',
    ['<C-V>'] = 'normal! "+gP',
    ['<C-Z>'] = 'undo',
    ['<C-Y>'] = 'redo',
    ['<C-A>'] = 'normal! ggVG',
    ['<C-S>'] = 'update',
    ['<C-Q>'] = 'quitall',
    --[[
    ['<MouseMove>'] = function()
        if hover_timer then
            hover_timer:stop()
            hover_timer:close()
            hover_timer = nil
        end
        hover_timer = vim.loop.new_timer()
        hover_timer:start(debounce_ms, 0, vim.schedule_wrap(function()
            if not vim.tbl_isempty(vim.lsp.get_clients {
                bufnr = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
            }) then vim.lsp.buf.hover {
                border = 'single',
                relative = 'mouse',
            } end
        end))
    end,
    ]]
    ['<C-F>'] = function() Snacks.picker.lines() end,
    ['<C-S-F>'] = function() Snacks.picker.grep() end,
    ['<C-H>'] = function() Snacks.picker.help() end,
    ['<Home>'] = function()
        local col = vim.fn.col '.'
        vim.cmd 'normal! ^'
        if col == vim.fn.col '.' then vim.cmd 'normal! 0' end
    end,
}
