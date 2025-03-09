local M = {}

M.open_standalone_neogit = function()
  -- Disable auto restore to prevent conflicts
  vim.g.skip_persistence_auto_restore = true

  require('neogit').open({ kind = 'replace' })

  vim.keymap.set('n', 'q', function()
    vim.cmd('q')
  end, { buffer = true, desc = 'Close Neogit' })
end

return M
