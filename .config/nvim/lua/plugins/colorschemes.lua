return {
  { 'catppuccin/nvim', name = 'catpuccin', lazy = false },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    opts = {
      style = 'moon',
    },
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    opts = {
      overrides = function(colors)
        local theme = colors.theme
        return {
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
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_foreground = 'material'
      vim.g.gruvbox_material_visual = 'blue background'

      -- Highlight and show colors for diagnostics
      vim.g.gruvbox_material_diagnostic_line_highlight = 1
      vim.g.gruvbox_material_diagnostic_virtual_text = 'highlighted'

      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('custom_highlights_gruvboxmaterial', {}),
        pattern = 'gruvbox-material',
        callback = function()
          local config = vim.fn['gruvbox_material#get_configuration']()
          local palette = vim.fn['gruvbox_material#get_palette'](
            config.background,
            config.foreground,
            config.colors_override
          )
          local set_hl = vim.fn['gruvbox_material#highlight']

          -- Override completion/floating windows colors
          set_hl('Pmenu', palette.fg1, palette.bg1)
          set_hl('PmenuSel', palette.none, palette.bg3)
          set_hl('NormalFloat', palette.fg1, palette.bg1)
          set_hl('TelescopeSelection', palette.none, palette.bg3)

          set_hl('DiffviewDiffText', palette.none, palette.bg_diff_blue)
          set_hl('DiffviewDiffDelete', palette.grey0, palette.bg_diff_red)
        end,
      })
    end,
  },
  {
    'sainnhe/everforest',
    lazy = false,
    config = function()
      vim.g.everforest_background = 'hard'

      -- Highlight and show colors for diagnostics
      vim.g.everforest_diagnostic_line_highlight = 1
      vim.g.everforest_diagnostic_virtual_text = 'highlighted'

      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          if vim.g.colors_name == 'everforest' then
            local configuration = vim.fn['everforest#get_configuration']()
            local palette = vim.fn['everforest#get_palette'](
              configuration.background,
              configuration.colors_override
            )

            vim.api.nvim_set_hl(0, 'Visual', { fg = nil, bg = palette.bg_blue[1] })

            local select_hl = { fg = nil, bg = palette.bg3[1] }
            local window_hl = { fg = palette.fg[1], bg = palette.bg1[1] }

            vim.api.nvim_set_hl(0, 'Pmenu', window_hl)
            vim.api.nvim_set_hl(0, 'PmenuSel', select_hl)
            vim.api.nvim_set_hl(0, 'NormalFloat', window_hl)
            vim.api.nvim_set_hl(0, 'TelescopeSelection', select_hl)
          end
        end,
      })
    end,
  },
}
