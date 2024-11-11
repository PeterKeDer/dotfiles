return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = {
        'bash',
        'c',
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
        keymaps = {
          init_selection = '<cr>',
          node_incremental = '<cr>',
          scope_incremental = '<C-cr>',
          node_decremental = '<S-cr>',
        },
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
      -- Set keymap in normal/visual mode for shift enter for incremental selection
      vim.keymap.set(
        { 'n', 'x' },
        '<S-CR>',
        require('nvim-treesitter.incremental_selection').init_selection
      )
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
