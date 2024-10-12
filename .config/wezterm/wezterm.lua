require('helpers')

local wezterm = require('wezterm')
local mux = wezterm.mux

local config = wezterm.config_builder()

config.leader = { key = 'a', mods = 'CTRL' }

config.initial_rows = 40
config.initial_cols = 150

config.color_scheme = 'tokyonight'
config.font = wezterm.font('JetBrains Mono')
config.font_size = 15

-- Potential options for better looking font
-- config.front_end = 'OpenGL'
config.freetype_load_target = 'Light'
config.freetype_render_target = 'HorizontalLcd'
config.cell_width = 0.9
config.freetype_load_flags = 'NO_HINTING'

config.max_fps = 120
config.enable_scroll_bar = true
config.scrollback_lines = 10000

-- Maximize window on startup
wezterm.on('gui-startup', function()
  local _, _, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

-- Utility function to map keys only in Neovim
local function map_vim(key, vim_key)
  return {
    key = key.key,
    mods = key.mods,
    action = wezterm.action_callback(function(win, pane)
      local key_to_send = IsNvim(pane) and vim_key or key
      win:perform_action({ SendKey = key_to_send }, pane)
    end),
  }
end

config.keys = {
  -- Split/close panes
  {
    key = 'v',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
  },
  {
    key = 's',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }),
  },
  {
    key = 'c',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },
  {
    key = '!',
    mods = 'LEADER | SHIFT',
    action = wezterm.action_callback(function(win, pane)
      pane:move_to_new_window()
    end),
  },
  -- Arrow navigations
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = wezterm.action.SendKey({ key = 'b', mods = 'OPT' }),
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = wezterm.action.SendKey({ key = 'f', mods = 'OPT' }),
  },
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = wezterm.action.SendKey({ key = 'a', mods = 'CTRL' }),
  },
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = wezterm.action.SendKey({ key = 'e', mods = 'CTRL' }),
  },
  -- Delete word/line
  {
    key = 'Backspace',
    mods = 'CMD',
    action = wezterm.action.SendKey({ key = 'u', mods = 'CTRL' }),
  },
  {
    key = 'Backspace',
    mods = 'OPT',
    -- Sends \x1b (escape) + \x08 (backspace) to delete one word
    -- NOTE: this seems to work better than CTRL-w in certain contexts
    -- e.g. ipython
    action = wezterm.action({ SendString = '\x1b\x08' }),
  },
  -- Map navigating forward/backward in vim
  map_vim({ key = '[', mods = 'CMD' }, { key = 'o', mods = 'CTRL' }),
  map_vim({ key = ']', mods = 'CMD' }, { key = 'i', mods = 'CTRL' }),
}

local function merge_config(new)
  for k, v in pairs(new) do
    if not config[k] or type(v) ~= 'table' or type(config[k]) ~= 'table' then
      config[k] = v
    else
      for _, v2 in pairs(v) do
        table.insert(config[k], v2)
      end
    end
  end
end

local smart_splits = require('smart-splits')
merge_config(smart_splits)

return config