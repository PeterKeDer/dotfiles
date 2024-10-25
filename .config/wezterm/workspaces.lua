local wezterm = require('wezterm') --[[@as Wezterm]]
local act = wezterm.action

local resurrect =
  wezterm.plugin.require('https://github.com/MLFlexer/resurrect.wezterm')

local config = wezterm.config_builder()

-- NOTE: default workspace will not get restored on launch
config.default_workspace = 'default'

local function save_workspace()
  resurrect.save_state(resurrect.workspace_state.get_workspace_state())
end

-- Periodically save workspace every 10 minutes
resurrect.periodic_save({
  save_workspaces = true,
  interval_seconds = 10 * 60,
})

local function get_workspace_elements()
  local choice_table = {}
  for _, workspace in ipairs(wezterm.mux.get_workspace_names()) do
    table.insert(choice_table, {
      id = workspace,
      label = wezterm.format({ { Text = '󱂬 : ' .. workspace } }),
    })
  end
  return choice_table
end

config.keys = {
  {
    key = 'q',
    mods = 'CMD',
    action = wezterm.action_callback(function(win, pane)
      -- Save workspace before quitting
      save_workspace()
      win:perform_action(act.QuitApplication, pane)
    end),
  },
  -- Switch to an active workspace - does not resurrect
  {
    key = 'r',
    mods = 'CMD',
    -- action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
    action = wezterm.action_callback(function(win, pane)
      win:perform_action(
        act.InputSelector({
          action = wezterm.action_callback(function(_, _, id)
            if id then
              save_workspace()
              wezterm.mux.set_active_workspace(id)
            end
          end),
          title = 'Choose Workspace',
          fuzzy_description = 'Workspace to switch: ',
          choices = get_workspace_elements(),
          fuzzy = true,
        }),
        pane
      )
    end),
  },
  -- Switch workspace relative
  {
    key = 'e',
    mods = 'CMD',
    -- TODO: make this smart with a stack? Toggle between frequent two tabs
    -- but if tapped frequently should cycle around
    action = wezterm.action_callback(function(win, pane)
      save_workspace()
      win:perform_action(act.SwitchWorkspaceRelative(1), pane)
    end),
  },
  -- Create a new workspace
  {
    key = 'n',
    mods = 'LEADER',
    action = act.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        -- Escape: line is nil
        -- Otherwise, line is a string (potentially empty), which will create a
        -- new workspace
        if line then
          window:perform_action(
            act.SwitchToWorkspace({
              name = line,
            }),
            pane
          )
        end
      end),
    }),
  },
  {
    key = 'd',
    mods = 'LEADER',
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_load(win, pane, function(id)
        resurrect.delete_state(id)
      end, {
        title = 'Delete State',
        fuzzy_description = 'Search State to Delete: ',
        is_fuzzy = true,
      })
    end),
  },
  -- Save current workspace
  {
    key = 's',
    mods = 'CMD',
    action = wezterm.action_callback(function(_, _)
      save_workspace()
    end),
  },
  -- Switch and restore workspace, only shows persisted workspaces
  {
    key = 'o',
    mods = 'CMD',
    action = wezterm.action_callback(function(win, pane)
      -- Only load workspaces
      local fuzzy_opts = {
        ignore_tabs = true,
        ignore_windows = true,
        fuzzy_description = 'Search Workspace to Load: ',
      }

      resurrect.fuzzy_load(win, pane, function(id, _)
        -- Before switching workspace, save current one
        save_workspace()

        id = string.match(id, '([^/]+)$') -- match after '/'
        id = string.match(id, '(.+)%..+$') -- remove file extention
        local workspace = id

        local workspace_exists = false
        for _, saved_workspace in pairs(wezterm.mux.get_workspace_names()) do
          if saved_workspace == workspace then
            workspace_exists = true
            break
          end
        end

        win:perform_action(act.SwitchToWorkspace({ name = workspace }), pane)

        -- Resurrect workspace if it did not exist
        if not workspace_exists then
          -- Find the window spawned in the newly created workspace
          local new_win = nil
          for _, mux_win in ipairs(wezterm.mux.all_windows()) do
            if mux_win:get_workspace() == workspace then
              new_win = mux_win
              break
            end
          end

          local opts = {
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          }

          local state = resurrect.load_state(workspace, 'workspace')
          resurrect.workspace_state.restore_workspace(state, opts)

          -- Hack to close the window obtained from spawning workspace
          if new_win then
            -- There should only be one tab, so close it
            new_win:gui_window():perform_action(
              act.CloseCurrentTab({ confirm = false }),
              new_win:active_pane()
            )
          end
        end
      end, fuzzy_opts)
    end),
  },
}

for _, keymap in ipairs(config.keys) do
  -- Also add ctrl shift keybind for windows
  if keymap.mods == 'CMD' then
    table.insert(config.keys, {
      key = keymap.key,
      mods = 'CTRL | SHIFT',
      action = keymap.action,
    })
  end
end

return config
