return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {},
  keys = {
    {
      '<leader>ps',
      function()
        require('persistence').load()
      end,
      desc = 'Restore Session',
    },
    {
      '<leader>pS',
      function()
        require('persistence').select()
      end,
      desc = 'Select Session',
    },
    {
      '<leader>pl',
      function()
        require('persistence').load({ last = true })
      end,
      desc = 'Restore Last Session',
    },
    {
      '<leader>pd',
      function()
        require('persistence').stop()
      end,
      desc = "Don't Save Current Session",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('persistence', { clear = true }),
      callback = function()
        -- Do not load if lazy is installing plugins
        if require('lazy.view').visible() then
          return
        end

        -- Before loading, heck no argument is passed, and not piped with stdin
        if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
          require('persistence').load()
        end
      end,
      -- Nested allows filetypes to be set when loading
      nested = true,
    })
  end,
}
