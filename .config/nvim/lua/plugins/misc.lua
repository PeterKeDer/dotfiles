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
      },
      sections = {
        lualine_a = {
          { 'mode' },
        },
        lualine_b = { 'diff', 'diagnostics' },
        lualine_c = {
          {
            'filename',
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
      tabline = {
        lualine_a = {
          {
            'tabs',
            mode = 2, -- tab number and file name
            path = 0, -- only show filename
            symbols = { modified = ' ●' },
          },
        },
        lualine_x = { 'datetime' },
        lualine_y = { 'branch' },
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
      excluded_buftypes = {
        'terminal',
        'nofile',
      },
    },
  },
  {
    'kevinhwang91/nvim-hlslens',
    opts = {
      nearest_only = true,
    },
  },
  -- Breadcrumbs at the top of window
  {
    'Bekaboo/dropbar.nvim',
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      local api = require('dropbar.api')
      local utils = require('dropbar.utils')

      local function select_prev()
        local menu = utils.menu.get_current()
        if not menu then
          return
        end
        if menu.prev_menu then
          -- There is a previous dropdown, just close current one
          menu:close()
        else
          -- If this menu if the first, then prev_win is the window on
          -- which the dropbar is attached
          local bar = utils.bar.get({ win = menu.prev_win })
          if not bar then
            return
          end

          -- Dropbar very unfortunately does not provide us with menu index
          for _, component in ipairs(bar.components) do
            -- Find the first opened menu (i.e. current menu), close it,
            -- and open the previous one
            if component.menu then
              component.menu:close()
              if component.bar_idx > 1 then
                bar:pick(component.bar_idx - 1)
              end
              break
            end
          end
        end
      end

      local function select_next()
        -- Try to expand next menu if possible, otherwise enter
        local menu = utils.menu.get_current()
        if not menu then
          return
        end
        local cursor = vim.api.nvim_win_get_cursor(menu.win)
        local component = menu.entries[cursor[1]]:first_clickable()
        if component then
          menu:click_on(component, nil, 1, 'l')
        end
      end

      require('dropbar').setup({
        menu = {
          quick_navigation = false,
          keymaps = {
            ['<Esc>'] = function()
              -- Close all previously opened menus
              local menu = utils.menu.get_current()
              while menu do
                menu:close()
                menu = menu.prev_menu
              end
            end,
            ['h'] = select_prev,
            ['<Left>'] = select_prev,
            ['l'] = select_next,
            ['<Right>'] = select_next,
            ['<S-CR>'] = function()
              -- This just selects the item, without expanding
              local menu = utils.menu.get_current()
              if not menu then
                return
              end
              local cursor = vim.api.nvim_win_get_cursor(menu.win)

              -- If there are two clickables, the first one will expand
              local first_component, pos =
                menu.entries[cursor[1]]:first_clickable()
              local next_component =
                menu.entries[cursor[1]]:next_clickable(pos['end'])
              local component = next_component or first_component

              if component then
                menu:click_on(component, nil, 1, 'l')
              end
            end,
            ['/'] = function()
              local menu = utils.menu.get_current()
              if not menu then
                return
              end
              menu:fuzzy_find_open()
            end,
          },
        },
      })

      -- Override ugly highlights
      vim.api.nvim_set_hl(0, 'DropBarMenuHoverEntry', { link = 'CursorLine' })
      vim.api.nvim_set_hl(0, 'DropBarMenuHoverIcon', { link = 'CursorLine' })
      vim.api.nvim_set_hl(0, 'DropBarCurrentContext', {})
      vim.api.nvim_set_hl(0, 'DropBarPreview', { link = 'CursorLine' })

      vim.keymap.set('n', '<leader>b', function()
        api.pick()
      end, { desc = '[B]readcrumbs' })
    end,
  },
}
