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
    opts = {},
  },
  { 'windwp/nvim-ts-autotag', opts = {} },
}
