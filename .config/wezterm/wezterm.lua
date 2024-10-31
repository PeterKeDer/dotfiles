local h = require('helpers')
local wezterm = require('wezterm') --[[@as Wezterm]]
local mux = wezterm.mux

local config = wezterm.config_builder()

config.leader = { key = 'a', mods = 'CTRL' }

config.initial_rows = 40
config.initial_cols = 150

config.color_scheme = 'Everforest Dark Hard (Gogh)'

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

wezterm.on('format-window-title', function(tab, pane, tabs)
  local index = ''
  if #tabs > 1 then
    index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
  end

  -- Show tab # and workspace name in title
  return index .. wezterm.mux.get_active_workspace()
end)

-- Utility function to map keys only in Neovim
local function map_vim(key, vim_key)
  return {
    key = key.key,
    mods = key.mods,
    action = wezterm.action_callback(function(win, pane)
      local key_to_send = h.is_nvim(pane) and vim_key or key
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
    key = 'd',
    mods = 'LEADER',
    action = wezterm.action.DetachDomain('CurrentPaneDomain'),
  },
  {
    key = 'h',
    mods = 'CTRL | SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'LeftArrow',
    mods = 'CTRL | SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'l',
    mods = 'CTRL | SHIFT',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'RightArrow',
    mods = 'CTRL | SHIFT',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'n',
    mods = 'LEADER',
    action = wezterm.action_callback(function(_, pane)
      pane:move_to_new_window()
    end),
  },
  {
    key = 't',
    mods = 'LEADER',
    action = wezterm.action_callback(function(_, pane)
      pane:move_to_new_tab()
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
    mods = h.select_by_os({ darwin = 'OPT', default = 'CTRL' }),
    -- Sends \x1b (escape) + \x08 (backspace) to delete one word
    -- NOTE: this seems to work better than CTRL-w in certain contexts
    -- e.g. ipython
    action = wezterm.action({ SendString = '\x1b\x08' }),
  },
  -- Map navigating forward/backward in vim
  map_vim({ key = '[', mods = 'CMD' }, { key = 'o', mods = 'CTRL' }),
  map_vim({ key = ']', mods = 'CMD' }, { key = 'i', mods = 'CTRL' }),
  -- Allow shift/ctrl enter in vim
  -- Source: https://stackoverflow.com/questions/16359878/how-to-map-shift-enter
  {
    key = 'Enter',
    mods = 'SHIFT',
    action = wezterm.action({ SendString = '\x1b[13;2u' }),
  },
  {
    key = 'Enter',
    mods = 'CTRL',
    action = wezterm.action({ SendString = '\x1b[13;5u' }),
  },
  {
    key = '/',
    mods = 'CTRL',
    action = wezterm.action.SendKey({ key = '/', mods = 'CTRL' }),
  },
  -- Debug overlay
  {
    key = '/',
    mods = 'LEADER',
    action = wezterm.action.ShowDebugOverlay,
  },
}

local modules = {
  'smart-splits',
  'colors',
  'workspaces',
  'custom',
}

for _, name in ipairs(modules) do
  local has_mod, mod = pcall(require, name)
  if has_mod then
    config = h.smart_merge(config, mod)
  end
end

return config
