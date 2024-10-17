-- Plugins for managing Git

return {
  -- Git client
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local neogit = require('neogit')
      neogit.setup({})

      vim.keymap.set('n', '<leader>gg', neogit.open, { desc = 'Neogit' })
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
    opts = {},
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
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = true,
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
        map(
          'n',
          '<leader>hs',
          gitsigns.stage_hunk,
          { desc = 'Git [s]tage hunk' }
        )
        map(
          'n',
          '<leader>hr',
          gitsigns.reset_hunk,
          { desc = 'Git [r]eset hunk' }
        )
        map(
          'n',
          '<leader>hS',
          gitsigns.stage_buffer,
          { desc = 'Git [S]tage buffer' }
        )
        map(
          'n',
          '<leader>hu',
          gitsigns.undo_stage_hunk,
          { desc = 'Git [u]ndo stage hunk' }
        )
        map(
          'n',
          '<leader>hR',
          gitsigns.reset_buffer,
          { desc = 'Git [R]eset buffer' }
        )
        map(
          'n',
          '<leader>hp',
          gitsigns.preview_hunk,
          { desc = 'Git [p]review hunk' }
        )
        map(
          'n',
          '<leader>hb',
          gitsigns.blame_line,
          { desc = 'Git [b]lame line' }
        )
        map(
          'n',
          '<leader>hd',
          gitsigns.diffthis,
          { desc = 'Git [d]iff against index' }
        )
        map('n', '<leader>hD', function()
          gitsigns.diffthis('@')
        end, { desc = 'Git [D]iff against last commit' })
        -- Toggles
        -- map(
        --   'n',
        --   '<leader>tb',
        --   gitsigns.toggle_current_line_blame,
        --   { desc = '[T]oggle git show [b]lame line' }
        -- )
        -- map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
        map('n', ']h', function()
          gitsigns.nav_hunk('next')
        end, { desc = 'Next Hunk' })
        map('n', '[h', function()
          gitsigns.nav_hunk('prev')
        end, { desc = 'Prev Hunk' })
      end,
    },
  },
  -- Conflict markers like vscode
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    opts = {
      default_mappings = {
        -- Consistent mappings with diffview
        ours = '<leader>co',
        theirs = '<leader>ct',
        none = '<leader>cb',
        both = '<leader>ca',
      },
    },
  },
}
