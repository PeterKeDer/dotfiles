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

      vim.cmd('cnoreabbrev ng Neogit')

      vim.keymap.set('n', '<leader>gg', function()
        neogit.open({ kind = 'tab' })
      end, { desc = 'Neogit' })
      vim.keymap.set('n', '<leader>gc', function()
        neogit.open({ 'commit' })
      end, { desc = '[G]it [C]ommit' })
      vim.keymap.set('n', '<leader>gb', function()
        neogit.open({ 'branch' })
      end, { desc = '[G]it [B]ranch' })

      local a = require('plenary.async')

      local function run_neogit_action(action)
        return a.void(function()
          action({
            get_internal_arguments = function(_)
              return {}
            end,
            get_arguments = function(_)
              return {}
            end,
            state = { env = {} },
          })
        end)()
      end

      local function neogit_action(action)
        return function()
          run_neogit_action(action)
        end
      end

      vim.keymap.set('n', '<leader>G', function()
        require('snacks.picker').pick({
          title = 'Git',
          items = {
            {
              text = 'push',
              ft = 'text',
              action = neogit_action(require('neogit.popups.push.actions').to_pushremote),
            },
            {
              text = 'pull',
              ft = 'text',
              action = neogit_action(require('neogit.popups.pull.actions').from_pushremote),
            },
            {
              text = 'commit',
              ft = 'text',
              action = neogit_action(require('neogit.popups.commit.actions').commit),
            },
            {
              text = 'branch',
              ft = 'text',
              action = neogit_action(
                require('neogit.popups.branch.actions').checkout_branch_revision
              ),
            },
            {
              text = 'diff against base',
              ft = 'text',
              action = function()
                vim.cmd('DiffviewOpen origin/HEAD...HEAD --imply-local')
              end,
            },
            {
              text = 'diff commits against base',
              ft = 'text',
              action = function()
                vim.cmd('DiffviewFileHistory --range=origin/HEAD...HEAD --right-only --no-merges')
              end,
            },
            {
              text = 'stashes',
              ft = 'text',
              action = function()
                vim.cmd('DiffviewFileHistory -g --range=stash')
              end,
            },
          },
          format = 'text',
          preview = 'none',
          layout = {
            preset = 'vscode',
            layout = {
              width = 0.5,
            },
          },
          confirm = function(picker, item)
            item.action()
            picker:close()
          end,
        })
      end, { desc = 'Neogit' })

      vim.keymap.set('n', '<leader>gC', function()
        run_neogit_action(require('neogit.popups.commit.actions').commit)
      end, { desc = '[G]it [C]ommit' })

      vim.keymap.set('n', '<leader>gB', function()
        run_neogit_action(require('neogit.popups.branch.actions').checkout_branch_revision)
      end, { desc = '[G]it [B]ranch' })

      vim.keymap.set('n', '<leader>gp', function()
        run_neogit_action(require('neogit.popups.pull.actions').from_pushremote)
      end, { desc = '[G]it [P]ush' })

      vim.keymap.set('n', '<leader>gP', function()
        run_neogit_action(require('neogit.popups.push.actions').to_pushremote)
      end, { desc = '[G]it [P]ush' })
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
      { '<leader>gd', '<cmd>DiffviewOpen -uno<cr>', desc = '[G]it [D]iff' },
      { '<leader>gD', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff (with untracked files)' },
      {
        '<leader>gh',
        '<cmd>DiffviewFileHistory %<cr>',
        desc = '[G]it File [H]istory',
      },
      {
        '<leader>gl',
        '<cmd>DiffviewFileHistory<cr>',
        desc = '[G]it [L]og',
      },
    },
  },
  -- More detailed line blame
  {
    'FabijanZulj/blame.nvim',
    enabled = not vim.g.vscode,
    keys = {
      { '<leader>tb', '<cmd>BlameToggle<cr>', desc = 'Toggle Blame' },
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
        map('n', '<leader>hP', gitsigns.preview_hunk_inline, { desc = 'Git [P]review hunk inline' })
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
