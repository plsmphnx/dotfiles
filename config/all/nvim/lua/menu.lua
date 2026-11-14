local M = {}

M.default = function(event)
  local entries = {}

  if vim.lsp.get_clients { bufnr = event.buf }[1] then
    vim.list_extend(entries, {
      { 'a', 'Info',       '<Cmd>lua vim.lsp.buf.hover()<CR>' },
      { 'a', 'Action',     '<Cmd>lua vim.lsp.buf.code_action()<CR>' },
      { 'a', 'Diagnostic', '<Cmd>lua vim.diagnostic.open_float()<CR>' },
      { 'a', 'Definition', '<Cmd>lua vim.lsp.buf.definition()<CR>' },
      { 'a', '-1-',        '<Nop>' },
    })
  end

  vim.list_extend(entries, {
    { 'v', 'Cut',        '"+x' },
    { 'v', 'Copy',       '"+y' },
    { 'a', 'Paste',      '"+gP' },
    { 'v', 'Paste',      '"+P' },
    { 'v', 'Delete',     '"_x' },
    { 'n', 'Select All', 'ggVG' },
    { 'v', 'Select All', 'gg0oG$' },
    { 'i', 'Select All', '<C-Home><C-O>VG' },
  })

  return entries
end

vim.api.nvim_del_augroup_by_name 'nvim.popupmenu'

vim.api.nvim_create_autocmd('MenuPopup', {
  group = vim.api.nvim_create_augroup('MenuPopup', { clear = true }),
  callback = function(event)
    vim.cmd.aunmenu 'PopUp'
    for _, e in ipairs((vim.b[event.buf].menu or M.default)(event) or {}) do
      local label = e[2]:gsub(' ', [[\ ]])
      local re = e[4] and '' or 'nore'
      vim.cmd(e[1] .. re .. 'menu PopUp.' .. label .. ' ' .. e[3])
    end
  end
})

return M
