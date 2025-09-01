return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'comment',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'ruby',
        'terraform',
        'vim',
        'vimdoc',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      incremental_selection = {
        enable = true,
        -- Set manually below in init
        -- keymaps = {
        --   -- init_selection = '<cr>',
        --   node_incremental = 'v',
        --   -- scope_incremental = '<C-cr>',
        --   node_decremental = 'V',
        -- },
      },
      textobjects = {
        lsp_interlop = { enable = true },
        move = {
          enable = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
            [']a'] = '@parameter.inner',
            [']s'] = '@statement.outer',
            [']l'] = '@loop.outer',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']C'] = '@class.outer',
            [']A'] = '@parameter.inner',
            [']S'] = '@statement.outer',
            ['[l'] = '@loop.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
            ['[a'] = '@parameter.inner',
            ['[s'] = '@statement.outer',
            [']L'] = '@loop.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[C'] = '@class.outer',
            ['[A'] = '@parameter.inner',
            ['[S'] = '@statement.outer',
            ['[L'] = '@loop.outer',
          },
        },
        select = {
          enable = true,

          -- Automatically jump forward to textobj
          lookahead = false,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = {
              query = '@class.inner',
              desc = 'Select inner part of a class region',
            },
            ['as'] = '@statement.outer',
            ['al'] = '@loop.outer',
          },
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
        },
      },
    },
    init = function()
      -- There's a bug (?) where if you don't use init selection (i.e. only node_incremental)
      -- and if you decrement past the initial selection, you will go to the previous
      -- selection (if exists) since the buffer selection is not cleared.
      -- Work around this with a custom implementation and reset whenever we enter visual.
      vim.keymap.set({ 'x' }, 'v', function()
        require('utils.incremental-selection').node_incremental()
      end)

      vim.keymap.set({ 'x' }, 'V', function()
        require('utils.incremental-selection').node_decremental()
      end)

      local visual_event_group = vim.api.nvim_create_augroup('visual_event', { clear = true })

      vim.api.nvim_create_autocmd('ModeChanged', {
        group = visual_event_group,
        pattern = { '*:[vV\x16]*' },
        callback = function()
          -- Reset selection whenever we enter visual mode
          require('utils.incremental-selection').reset_selection()
        end,
      })
    end,
  },
  -- Show context on top of object/functions/class
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      -- Settings to match VSCode behavior
      max_lines = 2,
      -- Inner scope (e.g. loops, if-else) are discarded first
      trim_scope = 'inner',
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    config = function(_, opts)
      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require('nvim-treesitter.textobjects.move') ---@type table<string,fun(...)>
      local configs = require('nvim-treesitter.configs')
      for name, fn in pairs(move) do
        if name:find('goto') == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module('textobjects.move')[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find('[%]%[][cC]') then
                  vim.cmd('normal! ' .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
}
