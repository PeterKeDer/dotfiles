local wezterm = require('wezterm') --[[@as Wezterm]]

local M = {}

M.is_darwin = wezterm.target_triple:find('darwin') ~= nil
M.is_windows = wezterm.target_triple:find('windows') ~= nil
M.is_linux = wezterm.target_triple:find('linux') ~= nil

function M.select_by_os(opts)
  if M.is_darwin and opts.darwin then
    return opts.darwin
  elseif M.is_windows and opts.windows then
    return opts.windows
  elseif M.is_linux and opts.linux then
    return opts.linux
  else
    return opts.default or opts[0]
  end
end

-- NOTE: this requires `IS_NVIM` to be set by the smart-splits.nvim plugin
function M.is_nvim(pane)
  return pane:get_user_vars().IS_NVIM == 'true'
end

function M.smart_merge(t1, t2)
  local result = {}
  for k, v in pairs(t1) do
    result[k] = v
  end
  for k, v in pairs(t2) do
    if type(k) == 'number' then
      -- If key is a number, insert into table as a new element
      table.insert(result, v)
    elseif type(v) == 'table' and type(result[k]) == 'table' then
      -- If both values are tables, try to merge them recursively
      result[k] = M.smart_merge(result[k], v)
    else
      -- Otherwise, insert by key and potentially overwrite
      result[k] = v
    end
  end
  return result
end

return M
