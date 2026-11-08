local function cmd(impl) return '<Cmd>' .. impl .. '<CR>' end

local visual = { v = true, V = true, ['\22'] = true }
local function sel()
  local mode = vim.fn.mode()
  if not visual[mode] then return end
  return table.concat(vim.fn.getregion(
    vim.fn.getpos 'v',
    vim.fn.getpos '.',
    { type = mode }
  ), '\n')
end

return {
  [{ 'v', 'n', '!' }] = {
    ['<C-S>'] = function()
      if vim.api.nvim_buf_get_name(0) == '' then
        Snacks.input.input({
          prompt = 'Save As',
          default = vim.fn.getcwd() .. '/',
        }, function(input)
          if input then
            vim.api.nvim_buf_set_name(0, input)
            vim.cmd 'update'
          end
        end)
      else
        vim.cmd 'update'
      end
    end,
    ['<C-Q>'] = cmd 'quitall!',
    ['<C-S-I>'] = function() vim.lsp.buf.format() end,
    ['<C-F>'] = function() Snacks.picker.lines { pattern = sel() } end,
    ['<C-S-F>'] = function() Snacks.picker.grep { search = sel() } end,
    ['<C-B>'] = function() Snacks.picker.explorer() end,
    ['<F1>'] = function() Snacks.picker.help() end,
    ['<F2>'] = function() Snacks.picker.pickers() end,
  },
  [{ 'v' }] = {
    ['<Tab>'] = '>gv',
    ['<S-Tab>'] = '<gv',
  },
  [{ 'n', '!' }] = {
    ['<S-Tab>'] = cmd 'normal! V<g',
    ['<Home>'] = function()
      local col = vim.fn.col '.'
      vim.cmd 'normal! ^'
      if col == vim.fn.col '.' then vim.cmd 'normal! 0' end
    end,
  },
  [{ '!' }] = {
    ['<2-LeftMouse>'] = '<C-O>viw<C-G>',
  }
}
