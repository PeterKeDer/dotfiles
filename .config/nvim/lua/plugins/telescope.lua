local function get_selected_text()
  -- NOTE: this only returns one selected line
  local lines = nil
  local _, srow, scol = unpack(vim.fn.getpos('v'))
  local _, erow, ecol = unpack(vim.fn.getpos('.'))
  if vim.fn.mode() == 'v' and srow == erow then
    if scol <= ecol then
      lines = vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
    else
      lines = vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
    end
  end

  if not lines then
    return nil
  end

  local text, _ = lines[1]:gsub('([%(%)%[%]%{%}%.])', '\\%1')
  return text
end

function string.starts(String, Start)
  return string.sub(String, 1, string.len(Start)) == Start
end

local function file_name_first(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  local cwd = vim.fn.getcwd()

  if parent == '.' then
    return tail
  elseif string.starts(parent, cwd) then
    -- Remove cwd in path if exists
    -- e.g. if cwd = /user/project and parent = /user/project/file
    -- format parent = file
    parent = string.sub(parent, string.len(cwd) + 2, string.len(parent))
  end

  -- Use two tabs to delimit filename and path
  return string.format('%s\t\t%s\t\t', tail, parent)
end

-- Colors everything after two tabs like comments
-- Works in conjunction with function above to color the paths
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'TelescopeResults',
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd('TelescopeParent', '\t\t.*\t\t')
      -- Match truncated paths
      vim.fn.matchadd('TelescopeParent', '\t\t.*…')
      vim.api.nvim_set_hl(0, 'TelescopeParent', { link = 'Comment' })
    end)
  end,
})

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
          file_ignore_patterns = { 'node_modules/', '.git/' },
          -- TODO: use this option after merged to stable (0.1.x)
          -- https://github.com/nvim-telescope/telescope.nvim/pull/3010
          -- It currently still has problems with highlighting lsp symbols
          path_display = file_name_first,
          -- More horizontal space for long file paths
          layout_strategy = 'vertical',
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
      local actions_state = require('telescope.actions.state')
      local actions = require('telescope.actions')

      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })

      vim.keymap.set('n', '<leader>ff', function()
        builtin.find_files({ hidden = true })
      end, { desc = '[F]ind [F]iles' })

      vim.keymap.set('n', '<leader>faf', function()
        builtin.find_files({ hidden = true, no_ignore = true })
      end, { desc = '[F]ind [A]ll [F]iles' })

      vim.keymap.set('n', '<leader>fag', function()
        builtin.live_grep({
          default_text = get_selected_text(),
          additional_args = function(_)
            -- Show hidden and ignored files in live grep
            return { '--hidden', '--no-ignore' }
          end,
        })
      end, { desc = '[F]ind [A]ll by [G]rep' })

      vim.keymap.set('n', '<leader>fs', function()
        builtin.lsp_dynamic_workspace_symbols({ fname_width = 0.4, symbol_width = 0.4 })
      end, { desc = '[F]ind Workspace [S]ymbols' })
      vim.keymap.set('n', '<leader>fd', function()
        builtin.lsp_document_symbols({ symbol_width = 0.5 })
      end, { desc = '[F]ind [D]ocument Symbols' })

      vim.keymap.set('n', '<leader>fx', builtin.diagnostics, { desc = '[F]ind Diagnostics' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
      vim.keymap.set({ 'n', 'v' }, '<leader>fg', function()
        builtin.live_grep({
          default_text = get_selected_text(),
          additional_args = function(_)
            -- Show hidden files in live grep
            return { '--hidden' }
          end,
        })
      end, { desc = '[F]ind by [G]rep' })

      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
      vim.keymap.set('n', '<leader><leader>', function()
        require('telescope').extensions.recent_files.pick({
          only_cwd = true,
        })
      end, { desc = '[ ] Find recent files' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10,
          previewer = false,
        }))
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

      local open_commit = function(prompt_buffer)
        local selected = actions_state.get_selected_entry()
        actions.close(prompt_buffer)

        if selected.value then
          -- Open commit using diffview
          vim.cmd(':DiffviewOpen ' .. selected.value .. '~1..' .. selected.value)
        end
      end

      vim.keymap.set('n', '<leader>fc', function()
        builtin.git_commits({
          attach_mappings = function(_, map)
            map({ 'n', 'i' }, '<cr>', open_commit)
            return true
          end,
        })
      end, { desc = '[F]ind Git [C]ommits' })

      vim.keymap.set('n', '<leader>fbc', function()
        builtin.git_bcommits({
          attach_mappings = function(_, map)
            map({ 'n', 'i' }, '<cr>', open_commit)
            return true
          end,
        })
      end, { desc = '[F]ind Git [B]uffer [C]ommits' })
    end,
  },
  -- Search and replace
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
