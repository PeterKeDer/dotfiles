local wezterm = require('wezterm') --[[@as Wezterm]]
local config = wezterm.config_builder()

-- Override default color schemes
local scheme_overrides = {
  ['Gruvbox Material (Gogh)'] = function(scheme)
    -- Brighter gray for auto-complete (set to the same color as neovim comments)
    scheme.brights[1] = '#928374'
    -- Darker background to match Gruvbox material 'hard' background
    scheme.background = '#1d2021'
    return scheme
  end,
}

local color_schemes = {}
for scheme_name, override in pairs(scheme_overrides) do
  local default_scheme = wezterm.color.get_builtin_schemes()[scheme_name]
  color_schemes[scheme_name] = override(default_scheme)
end
config.color_schemes = color_schemes

return config
