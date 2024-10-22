return {
  { 'catppuccin/nvim', name = 'catpuccin', lazy = false },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    opts = {
      style = 'moon',
      styles = {
        comments = { italic = false },
      },
    },
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    opts = {
      overrides = function(colors)
        local theme = colors.theme
        return {
          Comment = { italic = false },

          -- Darker completion menu
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = 'none', bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },

          -- Remove underline for some cursor word
          LspReferenceWrite = { underline = false },

          -- Remove ugly Neogit diff colors
          NeogitDiffAdd = {},
          NeogitDiffDelete = {},
        }
      end,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = 'none',
            },
          },
        },
      },
    },
  },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    config = function()
      vim.g.gruvbox_material_disable_italic_comment = 1

      vim.g.gruvbox_material_background = 'medium'
      vim.g.gruvbox_material_foreground = 'material'

      -- Highlight and show colors for diagnostics
      vim.g.gruvbox_material_diagnostic_line_highlight = 1
      vim.g.gruvbox_material_diagnostic_virtual_text = 'highlighted'

      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          if vim.g.colors_name == 'gruvbox-material' then
            -- Override completion/floating windows colors
            vim.cmd.hi('Pmenu guifg=#ddc7a1 guibg=#32302f')
            vim.cmd.hi('PmenuSel guifg=none guibg=#45403d')
            vim.cmd.hi('NormalFloat guifg=#ddc7a1 guibg=#32302f')

            -- Update telescope selection colors
            vim.cmd.hi('TelescopeSelection guifg=none guibg=#45403d')
          end
        end,
      })
    end,
  },
}
