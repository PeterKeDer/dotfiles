local h = require('helpers')
local wezterm = require('wezterm') --[[@as Wezterm]]

-- Use CTRL + hjkl or arrow keys to move around
local direction_keys = {
  ['LeftArrow'] = 'Left',
  ['RightArrow'] = 'Right',
  ['UpArrow'] = 'Up',
  ['DownArrow'] = 'Down',
  ['h'] = 'Left',
  ['j'] = 'Down',
  ['k'] = 'Up',
  ['l'] = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if h.is_nvim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = {
            key = key,
            mods = resize_or_move == 'resize' and 'META' or 'CTRL',
          },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action(
            { AdjustPaneSize = { direction_keys[key], 3 } },
            pane
          )
        else
          win:perform_action(
            { ActivatePaneDirection = direction_keys[key] },
            pane
          )
        end
      end
    end),
  }
end

return {
  keys = {
    -- move between split panes
    split_nav('move', 'LeftArrow'),
    split_nav('move', 'DownArrow'),
    split_nav('move', 'UpArrow'),
    split_nav('move', 'RightArrow'),
    split_nav('move', 'h'),
    split_nav('move', 'j'),
    split_nav('move', 'k'),
    split_nav('move', 'l'),
  },
}
