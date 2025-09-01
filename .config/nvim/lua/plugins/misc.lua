-- Misc plugins

return {
  -- Determine tab width automatically
  { 'tpope/vim-sleuth' },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        component_separators = '',
        section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'diff', 'diagnostics' },
        lualine_c = {
          {
            'filename',
            symbols = { modified = '●' },
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
        lualine_x = { { 'copilot', show_colors = true }, 'filetype' },
      },
      inactive_sections = {
        lualine_c = {
          {
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            symbols = { modified = '●' },
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
      },
      tabline = {
        lualine_a = {
          {
            'tabs',
            mode = 2, -- tab number and file name
            path = 0, -- only show filename
            show_modified_status = false,
          },
        },
        lualine_x = { 'datetime' },
        lualine_y = { 'branch' },
      },
    },
  },
  -- Copilot status for lualine
  { 'AndreM222/copilot-lualine' },
  -- Navigate between Neovim and terminal splits
  {
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    enabled = not vim.g.vscode,
    config = function()
      vim.keymap.set({ 'n', 't' }, '<C-Left>', require('smart-splits').move_cursor_left)
      vim.keymap.set({ 'n', 't' }, '<C-Down>', require('smart-splits').move_cursor_down)
      vim.keymap.set({ 'n', 't' }, '<C-Up>', require('smart-splits').move_cursor_up)
      vim.keymap.set({ 'n', 't' }, '<C-Right>', require('smart-splits').move_cursor_right)
      vim.keymap.set({ 'n', 't' }, '<C-h>', require('smart-splits').move_cursor_left)
      vim.keymap.set({ 'n', 't' }, '<C-j>', require('smart-splits').move_cursor_down)
      vim.keymap.set({ 'n', 't' }, '<C-k>', require('smart-splits').move_cursor_up)
      vim.keymap.set({ 'n', 't' }, '<C-l>', require('smart-splits').move_cursor_right)
    end,
  },
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble' },
    opts = {
      modes = {
        lsp = {
          win = { position = 'right' },
        },
      },
    },
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cS',
        '<cmd>Trouble lsp toggle<cr>',
        desc = 'LSP references/definitions/... (Trouble)',
      },
      {
        '<leader>xl',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>q',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
      {
        '<leader>?',
        '<cmd>lua vim.diagnostic.open_float()<cr>',
        desc = 'Diagnostics Window',
      },
    },
  },
  -- Prevent d/c/x from copying to clipboard, and add a new cut action (m)
  { 'gbprod/cutlass.nvim', opts = { cut_key = 'm', override_del = true } },
  {
    'HiPhish/rainbow-delimiters.nvim',
    -- seemed to have cause random brackets to show up?
    enabled = not vim.g.vscode,
    init = function()
      vim.g.rainbow_delimiters = {
        highlight = {
          -- Removed red because it looks bad
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
  },
  -- Improvements to search/command UI, shows LSP docs, notifications, etc.
  {
    'folke/noice.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    enabled = not vim.g.vscode,
    opts = {
      lsp = {
        progress = {
          -- Disable because this spams while typing...
          -- Also fidget.nvim handles it better
          enabled = false,
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      messages = {
        -- Disable search counter, of which hlslens does a better job
        view_search = false,
      },
    },
  },
  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      highlight = {
        pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
      },
      search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
    },
  },
  -- Auto pair brackets, quotes, etc.
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { 'TelescopePrompt', 'snacks_picker_input' },
      })
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
      { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_by_name = {
            '.git',
            '.DS_Store',
            '__pycache__',
          },
        },
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
    },
  },
  {
    'kevinhwang91/nvim-hlslens',
    opts = {
      nearest_only = true,
    },
  },
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
