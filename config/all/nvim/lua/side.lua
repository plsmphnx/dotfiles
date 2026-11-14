local M = {}

M.pick = function(source, opts)
  for _, pick in ipairs(Snacks.picker.get()) do
    if pick.resolved_layout and pick.resolved_layout.preset == 'sidebar' then
      M.width = pick.layout.root:size().width
      pick:close()
    end
  end

  Snacks.picker.pick(source, vim.tbl_deep_extend('force', {
    layout = { preset = 'sidebar', preview = false, width = M.width },
    auto_close = false,
    jump = { close = false },
  }, opts or {}))
end

return M
