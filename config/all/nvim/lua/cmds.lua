local M = {}

local function save(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  vim.cmd('noautocmd ' .. buf .. 'bufdo update')
end

M.save = function(buf, next, ...)
  if vim.api.nvim_buf_get_name(buf or 0) == '' then
    M.save_as(buf, next, ...)
  else
    save(buf)
    if next then next(...) end
  end
end

M.save_as = function(buf, next, ...)
  local args = { ... }
  local default = vim.api.nvim_buf_get_name(buf or 0)
  if default == '' then default = vim.fn.getcwd() .. '/' end
  vim.ui.input({ prompt = 'Save As', default = default }, function(input)
    if input then
      vim.api.nvim_buf_set_name(buf or 0, input)
      save(buf)
      if next then next(unpack(args)) end
    end
  end)
end

M.confirm = function(buf, next, ...)
  local args = { ... }
  local name = vim.api.nvim_buf_get_name(buf or 0)
  if name == '' then name = '[No Name]' end
  vim.ui.select({ 'Yes', 'No' }, {
    prompt = 'Save ' .. name .. '?',
  }, function(item)
    if item == 'Yes' then
      M.save(buf, next, unpack(args))
    elseif item == 'No' and next then
      next(unpack(args))
    end
  end)
end

M.quit = function()
  local unsaved = vim.tbl_filter(function(buf)
    return vim.bo[buf].buflisted and vim.bo[buf].modified
  end, vim.api.nvim_list_bufs())
  if #unsaved == 0 then
    vim.cmd 'qa!'
    return
  end
  local first = table.remove(unsaved, 1)
  local function next(tail, ...)
    if not tail then vim.cmd 'qa!' else M.confirm(tail, next, ...) end
  end
  M.confirm(first, next, unpack(unsaved))
end

M.home = function()
  local col = vim.fn.col '.'
  vim.cmd.normal { '^', bang = true }
  if col == vim.fn.col '.' then vim.cmd.normal { '0', bang = true } end
end

return M
