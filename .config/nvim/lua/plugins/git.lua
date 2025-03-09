-- Plugins for managing Git

return {
  {
    'tpope/vim-fugitive',
  },
  -- Git client
  {
    'NeogitOrg/neogit',
    event = 'BufReadPre',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local neogit = require('neogit')
      neogit.setup({})

      vim.keymap.set('n', '<leader>gg', function()
        neogit.open({ kind = 'tab' })
      end, { desc = 'Neogit' })
      vim.keymap.set('n', '<leader>gl', function()
        neogit.open({ 'log' })
      end, { desc = '[G]it [L]og' })
      vim.keymap.set('n', '<leader>gc', function()
        neogit.open({ 'commit' })
      end, { desc = '[G]it [C]ommit' })
    end,
  },
  -- Show git diffs
  {
    'sindrets/diffview.nvim',
    config = function()
      local close_diffview = { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } }
      local close_window = { 'n', 'q', '<cmd>q<cr>', { desc = 'Close Window' } }

      require('diffview').setup({
        keymaps = {
          view = { close_diffview },
          file_panel = { close_diffview },
          file_history_panel = { close_diffview },
          option_panel = { close_window },
          help_panel = { close_window },
        },
      })
    end,
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff' },
      {
        '<leader>gh',
        '<cmd>DiffviewFileHistory %<cr>',
        desc = '[G]it File [H]istory',
      },
    },
  },
  -- More detailed line blame
  {
    'FabijanZulj/blame.nvim',
    keys = {
      { '<leader>gb', '<cmd>BlameToggle<cr>', desc = 'Toggle Blame' },
    },
    config = function()
      require('blame').setup({
        date_format = '%Y/%m/%d',
      })
    end,
  },
  -- Show and modify git hunks in editor
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      current_line_blame = true,
      attach_to_untracked = true,
      sign_priority = 100,
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('v', '<leader>hs', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'Git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis('@')
        end, { desc = 'Git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>td', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
        map(
          'n',
          '<leader>hh',
          gitsigns.toggle_linehl,
          { desc = 'Toggle show git [H]unks [H]ighlights' }
        )
        map('n', ']h', function()
          gitsigns.nav_hunk('next')
        end, { desc = 'Next Hunk' })

        map('n', '[h', function()
          gitsigns.nav_hunk('prev')
        end, { desc = 'Prev Hunk' })

        -- Hunk textobject
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
    },
  },
}
