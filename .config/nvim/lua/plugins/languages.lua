-- Language specific plugins

return {
  -- Tools for rust
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
  },
  -- Typescript and TSX
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    enabled = not vim.g.vscode,
    opts = {},
  },
  { 'windwp/nvim-ts-autotag', opts = {} },
  -- Python notebooks
  {
    -- For displaying images
    'willothy/wezterm.nvim',
    opts = true,
  },
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    dependencies = { 'willothy/wezterm.nvim' },
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_image_provider = 'wezterm'
      -- Not supported by wezterm provider
      vim.g.molten_auto_open_output = false

      vim.g.molten_virt_text_output = true
      vim.g.molten_wrap_output = true

      vim.keymap.set(
        'n',
        '<localleader>pi',
        ':MoltenInit<CR>',
        { silent = true, desc = 'Initialize the plugin' }
      )
      vim.keymap.set(
        'n',
        '<localleader>pr',
        ':MoltenEvaluateOperator<CR>',
        { silent = true, desc = 'run operator selection' }
      )
      vim.keymap.set(
        'n',
        '<localleader>pl',
        ':MoltenEvaluateLine<CR>',
        { silent = true, desc = 'evaluate line' }
      )
      vim.keymap.set(
        'n',
        '<localleader>pc',
        ':MoltenReevaluateCell<CR>',
        { silent = true, desc = 're-evaluate cell' }
      )
      vim.keymap.set(
        'v',
        '<localleader>pr',
        ':<C-u>MoltenEvaluateVisual<CR>gv',
        { silent = true, desc = 'evaluate visual selection' }
      )
      vim.keymap.set(
        'n',
        '<localleader>pd',
        ':MoltenDelete<CR>',
        { silent = true, desc = 'molten delete cell' }
      )
      vim.keymap.set(
        'n',
        '<localleader>ph',
        ':MoltenHideOutput<CR>',
        { silent = true, desc = 'hide output' }
      )
      vim.keymap.set(
        'n',
        '<localleader>po',
        ':noautocmd MoltenEnterOutput<CR>',
        { silent = true, desc = 'show/enter output' }
      )
    end,
  },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      -- Do not show by default, use preview split command to show
      initial_state = false,
    },
    config = function(_, opts)
      require('markview').setup(opts)

      vim.keymap.set(
        'n',
        '<leader>mp',
        '<cmd>Markview splitToggle<cr>',
        { desc = 'Markdown Preview' }
      )
    end,
  },
}
