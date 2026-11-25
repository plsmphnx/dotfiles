local M = {}

M.default = function(event)
  local entries = {}

  if vim.lsp.get_clients { bufnr = event.buf }[1] then
    vim.list_extend(entries, {
      { 'a', 'Actions',     '<Cmd>lua vim.lsp.buf.code_action()<CR>' },
      { 'a', 'Diagnostics', '<Cmd>lua vim.diagnostic.open_float()<CR>' },
      { 'a', 'Definitions', '<C-\\><C-N><Cmd>lua Snacks.picker.lsp_definitions()<CR>' },
      { 'a', 'References',  '<C-\\><C-N><Cmd>lua Snacks.picker.lsp_references()<CR>' },
      { 'a', '-1-',         '<Nop>' },
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
      vim.cmd {
        cmd = e[1] .. (e[4] and '' or 'nore') .. 'menu',
        args = { 'PopUp.' .. e[2]:gsub(' ', [[\ ]]), e[3] },
      }
    end
  end
})

return M
