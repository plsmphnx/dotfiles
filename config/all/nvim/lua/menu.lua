local function default(bufnr)
  local entries = {}

  if vim.lsp.get_clients { bufnr = bufnr }[1] then
    entries[#entries + 1] = {
      'anore', 'Go to definition', '<Cmd>lua vim.lsp.buf.definition()<CR>'
    }
    entries[#entries + 1] = { 'anore', '-1-', '<Nop>' }
  end

  for _, e in ipairs {
    { 'vnore', 'Cut',        '"+x' },
    { 'vnore', 'Copy',       '"+y' },
    { 'anore', 'Paste',      '"+gP' },
    { 'vnore', 'Paste',      '"+P' },
    { 'vnore', 'Delete',     '"_x' },
    { 'nnore', 'Select All', 'ggVG' },
    { 'vnore', 'Select All', 'gg0oG$' },
    { 'inore', 'Select All', '<C-Home><C-O>VG' },
  } do entries[#entries + 1] = e end

  return entries
end

local filetype = {}

vim.api.nvim_del_augroup_by_name 'nvim.popupmenu'

vim.api.nvim_create_autocmd('MenuPopup', {
  group = vim.api.nvim_create_augroup('MenuPopup', { clear = true }),
  callback = function(event)
    local menu = filetype[vim.bo[event.buf].filetype] or default
    vim.cmd.aunmenu 'PopUp'
    for _, e in ipairs(menu(event.buf)) do
      local label = e[2]:gsub(' ', [[\ ]])
      vim.cmd(e[1] .. 'menu PopUp.' .. label .. ' ' .. e[3])
    end
  end
})

return { filetype = filetype, default = default }
