return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
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
