local use_nes = false

return {
  {
    -- This is cool but kinda slow
    'copilotlsp-nvim/copilot-lsp',
    enabled = not vim.g.vscode and use_nes,
    init = function()
      vim.g.copilot_nes_debounce = 100
      vim.lsp.enable('copilot_ls')
    end,
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    -- Disabled for copilot lsp
    enabled = not vim.g.vscode and not use_nes,
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          -- Will be accepted via nvim-cmp
          accept = false,
          accept_word = '<M-w>',
          accept_line = '<M-l>',
        },
      },
      panel = {
        -- enabled = false,
        auto_refresh = true,
      },
      filetypes = {
        yaml = true,
        markdown = true,
      },
    },
    config = function(_, opts)
      require('copilot').setup(opts)

      vim.keymap.set(
        { 'n', 'i' },
        '<M-j>',
        '<cmd>lua require("copilot.suggestion").next()<cr>',
        { noremap = true }
      )
      vim.keymap.set(
        { 'n', 'i' },
        '<M-k>',
        '<cmd>lua require("copilot.suggestion").prev()<cr>',
        { noremap = true }
      )
      vim.keymap.set(
        { 'n', 'i' },
        '<M-Down>',
        '<cmd>lua require("copilot.suggestion").next()<cr>',
        { noremap = true }
      )
      vim.keymap.set(
        { 'n', 'i' },
        '<M-Up>',
        '<cmd>lua require("copilot.suggestion").prev()<cr>',
        { noremap = true }
      )
    end,
  },
}
