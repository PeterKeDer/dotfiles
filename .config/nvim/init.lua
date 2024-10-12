-- Neovim configuration, based off kickstart.nvim

-- Set leader key, must happen before plugins are loaded
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Better looking fill char for diffview
vim.opt.fillchars:append({ diff = '╱' })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set(
  'n',
  '<leader>q',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic [Q]uickfix list' }
)

-- Escape terminal instead of the default <C-\><C-Esc>
-- NOTE: This won't work in all terminal emulators/tmux/etc
vim.keymap.set(
  't',
  '<Esc><Esc>',
  '<C-\\><C-n>',
  { desc = 'Exit terminal mode' }
)

-- Navigating between tabs (buffers)
vim.keymap.set('n', '[t', '<cmd>tabp<cr>', { desc = 'Previous Tab' })
vim.keymap.set('n', ']t', '<cmd>tabn<cr>', { desc = 'Next Tab' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabc<cr>', { desc = 'Close Tab' })

-- Navigating between quickfix list items
vim.keymap.set('n', '[q', '<cmd>cp<cr>', { desc = 'Previous Quicklist Item' })
vim.keymap.set('n', ']q', '<cmd>cn<cr>', { desc = 'Next Quicklist Item' })

-- Navigate to start/end of line because I don't like $/^
vim.keymap.set({ 'n', 'v' }, 'g<Left>', '^', { desc = 'Go to start of line' })
vim.keymap.set({ 'n', 'v' }, 'gh', '^', { desc = 'Go to start of line' })
vim.keymap.set({ 'n', 'v' }, 'g<Right>', '$', { desc = 'Go to end of line' })
vim.keymap.set({ 'n', 'v' }, 'gl', '$', { desc = 'Go to end of line' })

-- Copy current file path to clipboard
vim.keymap.set('n', '<leader>cp', function()
  vim.fn.setreg('*', vim.fn.expand('%'))
end, { desc = 'Copy Path' })

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Install lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'folke/tokyonight.nvim',
    -- Load this before other plugins
    priority = 1000,
    init = function()
      vim.cmd.colorscheme('tokyonight-night')

      -- Remove highlight for comments (no bold/italic)
      vim.cmd.hi('Comment gui=none')
    end,
  },
  { import = 'plugins' },
}, {
  ui = {
    -- Fallback if nerd font is not available
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Disable modelines
vim.opt.modelines = 0
