local M = {}

M.save = function()
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
end

M.quit = function() vim.cmd 'conf qa' end

return M
