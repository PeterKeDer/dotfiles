return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      indent = {
        enabled = true,
        indent = {
          char = '▏',
        },
        scope = {
          char = '▏',
        },
        animate = { enabled = false },
      },
      quickfile = { enabled = true },
      terminal = { enabled = true },
      words = { enabled = true },
      picker = {
        enabled = true,
        formatters = {
          file = {
            filename_first = true,
            truncate = 80,
          },
        },
        layout = {
          preset = 'vertical',
          layout = {
            width = 0.8,
            min_width = 80,
            height = 0.9,
          },
        },
        filter = {
          cwd = true,
        },
        win = {
          input = {
            keys = {
              ['<a-c>'] = {
                'toggle_cwd',
                mode = { 'n', 'i' },
              },
            },
          },
        },
        actions = {
          toggle_cwd = function(p)
            local buffer = p.input.filter.current_buf
            local buf_path = vim.api.nvim_buf_get_name(buffer)
            local buf_dir = vim.fs.dirname(buf_path)
            local cwd = vim.fs.normalize(buf_dir)

            local root = vim.fs.normalize((vim.uv or vim.loop).cwd() or '.')
            local current = p:cwd()
            p:set_cwd(current == root and cwd or root)
            p:find()
          end,
        },
        config = function()
          vim.api.nvim_create_user_command('Pick', function(opts)
            local picker = opts['args']
            if picker ~= '' then
              Snacks.picker.pick(picker)
            else
              Snacks.picker.pick()
            end
          end, { nargs = '?' })

          vim.api.nvim_set_hl(0, 'SnacksPickerListCursorLine', { link = 'PmenuSel' })
        end,
      },
    },
    keys = {
      {
        '<leader><leader>',
        function()
          Snacks.picker.smart({
            multi = { 'files' },
            hidden = true,
          })
        end,
        desc = 'Smart Find Files',
      },
      {
        '<leader>ff',
        function()
          Snacks.picker.files({ hidden = true })
        end,
        desc = '[F]ind [F]iles',
      },
      {
        '<leader>faf',
        function()
          Snacks.picker.files({ hidden = true, ignored = true })
        end,
        desc = '[F]ind [A]ll [F]iles',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.grep({ hidden = true })
        end,
        desc = '[F]ind by [G]rep',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.grep_word({ hidden = true })
        end,
        desc = '[F]ind by [G]rep',
        mode = { 'x' },
      },
      {
        '<leader>fag',
        function()
          Snacks.picker.grep({ hidden = true, ignored = true })
        end,
        desc = '[F]ind [A]ll by [G]rep',
      },
      {
        '<leader>fc',
        function()
          -- TODO: investigate replacing neogit workflow with just pickers
          Snacks.picker.git_log()
        end,
        desc = '[F]ind Git [C]ommits',
      },
      {
        '<leader>ft',
        function()
          Snacks.picker.todo_comments()
        end,
        desc = '[F]ind [T]ODOs',
      },
      {
        '<leader>fw',
        function()
          Snacks.picker.grep_word({ hidden = true })
        end,
        desc = '[F]ind Current [W]ord',
        mode = { 'n', 'x' },
      },
      {
        '<leader>fs',
        function()
          Snacks.picker.lsp_symbols({
            filter = {
              default = true,
            },
          })
        end,
        desc = '[F]ind [S]ymbols',
      },
      {
        '<leader>fS',
        function()
          Snacks.picker.lsp_workspace_symbols({
            filter = {
              default = true,
            },
          })
        end,
        desc = '[F]ind Workspace [S]ymbols',
      },
      {
        '<leader>fd',
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = '[F]ind Buffer [D]iagnostics',
      },
      {
        '<leader>fD',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = '[F]ind Workspace [D]iagnostics',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.resume()
        end,
        desc = '[F]ind [R]esume',
      },
      {
        '<leader>fk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = '[F]ind [K]eymaps',
      },
      {
        '<leader>fh',
        function()
          Snacks.picker.highlights()
        end,
        desc = '[F]ind [H]ighlights',
      },
      {
        '<leader>fu',
        function()
          Snacks.picker.undo()
        end,
        desc = '[F]ind [U]ndo',
      },
      {
        '<leader>fq',
        function()
          Snacks.picker.qflist()
        end,
        desc = '[F]ind [Q]uickfix',
      },
      {
        '<leader>fp',
        function()
          Snacks.picker.pick()
        end,
        desc = '[F]ind [P]icker',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.lines({
            layout = {
              preset = 'default',
            },
          })
        end,
        desc = '[F]ind in Buffer',
      },
      {
        '<C-`>',
        function()
          Snacks.terminal()
        end,
        desc = 'Toggle terminal',
        mode = { 'n', 't' },
      },
      {
        ']w',
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = 'Next Reference',
        mode = { 'n', 't' },
      },
      {
        '[w',
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = 'Prev Reference',
        mode = { 'n', 't' },
      },
    },
  },
}
