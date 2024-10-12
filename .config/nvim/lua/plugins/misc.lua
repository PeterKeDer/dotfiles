-- Misc plugins

return {
  -- Determine tab width automatically
  { 'tpope/vim-sleuth' },
  -- Tools for rust
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        component_separators = '',
        section_separators = '',
      },
      sections = {
        lualine_a = {
          {
            'mode',
            color = { gui = 'bold' },
          },
        },
        lualine_b = { 'diff', 'diagnostics' },
        lualine_c = {
          {
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
      },
      inactive_sections = {
        lualine_c = {
          {
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
      },
    },
  },
  -- Navigate between Neovim and terminal splits
  {
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    config = function()
      vim.keymap.set('n', '<C-Left>', require('smart-splits').move_cursor_left)
      vim.keymap.set('n', '<C-Down>', require('smart-splits').move_cursor_down)
      vim.keymap.set('n', '<C-Up>', require('smart-splits').move_cursor_up)
      vim.keymap.set(
        'n',
        '<C-Right>',
        require('smart-splits').move_cursor_right
      )
      vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
      vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
      vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
      vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
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
        '<leader>xq',
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
  { 'HiPhish/rainbow-delimiters.nvim' },
  -- Improvements to search/command UI, shows LSP docs, notifications, etc.
  {
    'folke/noice.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
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
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
  },
  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  -- Add indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        -- A thinner indent line
        char = '▏',
      },
      scope = {
        enabled = false,
      },
    },
  },
  -- Auto pair brackets, quotes, etc.
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup({})
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
  -- Scrollbar to show diagnostics, git, and searches
  {
    'petertriho/nvim-scrollbar',
    opts = {
      handlers = {
        cursor = false,
        gitsigns = true,
        search = true,
      },
    },
  },
  {
    'kevinhwang91/nvim-hlslens',
    opts = {
      nearest_only = true,
    },
  },
}