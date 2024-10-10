local function get_selected_text()
  -- NOTE: this only returns one selected line
  local lines = nil
  local _, srow, scol = unpack(vim.fn.getpos('v'))
  local _, erow, ecol = unpack(vim.fn.getpos('.'))
  if vim.fn.mode() == 'v' and srow == erow then
    if scol <= ecol then
      lines =
        vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
    else
      lines =
        vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
    end
  end

  if not lines then
    return nil
  end

  local text, _ = lines[1]:gsub('([%(%)%[%]%{%}%.])', '\\%1')
  return text
end

return {
  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Enables icons with nerd font
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },

      -- Enables picker for recent files
      { 'smartpde/telescope-recent-files', config = {} },
    },
    config = function()
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { 'node_modules' },
          -- path_display = { 'smart' },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'recent_files')

      local builtin = require('telescope.builtin')

      vim.keymap.set(
        'n',
        '<leader>fh',
        builtin.help_tags,
        { desc = '[F]ind [H]elp' }
      )
      vim.keymap.set(
        'n',
        '<leader>fk',
        builtin.keymaps,
        { desc = '[F]ind [K]eymaps' }
      )
      vim.keymap.set(
        'n',
        '<leader>ff',
        builtin.find_files,
        { desc = '[F]ind [F]iles' }
      )
      vim.keymap.set('n', '<leader>faf', function()
        builtin.find_files({ hidden = true, no_ignore = true })
      end, { desc = '[F]ind [A]ll [F]iles' })
      vim.keymap.set('n', '<leader>fag', function()
        builtin.live_grep({
          default_text = get_selected_text(),
          additional_args = function(_)
            -- Show hidden files in live grep
            return { '--hidden' }
          end,
        })
      end, { desc = '[F]ind [A]ll by [G]rep' })
      vim.keymap.set(
        'n',
        '<leader>fs',
        builtin.lsp_workspace_symbols,
        { desc = '[F]ind Workspace [S]ymbols' }
      )
      vim.keymap.set(
        'n',
        '<leader>fw',
        builtin.grep_string,
        { desc = '[F]ind current [W]ord' }
      )
      vim.keymap.set({ 'n', 'v' }, '<leader>fg', function()
        -- TODO: wait that option was set up top
        builtin.live_grep({
          default_text = get_selected_text(),
        })
      end, { desc = '[F]ind by [G]rep' })
      vim.keymap.set(
        'n',
        '<leader>fd',
        builtin.diagnostics,
        { desc = '[F]ind [D]iagnostics' }
      )
      vim.keymap.set(
        'n',
        '<leader>fr',
        builtin.resume,
        { desc = '[F]ind [R]esume' }
      )
      vim.keymap.set('n', '<leader><leader>', function()
        require('telescope').extensions.recent_files.pick({
          only_cwd = true,
        })
      end, { desc = '[ ] Find recent files' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(
          require('telescope.themes').get_dropdown({
            winblend = 10,
            previewer = false,
          })
        )
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>f/', function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end, { desc = '[F]ind [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end, { desc = '[F]ind [N]eovim files' })
    end,
  }, -- Search and replace
  {
    'MagicDuck/grug-far.nvim',
    opts = {},
    keys = {
      {
        '<leader>far',
        function()
          require('grug-far').open()
        end,
        mode = { 'n', 'v' },
        desc = '[F]ind [A]nd [R]eplace',
      },
    },
  },
}
