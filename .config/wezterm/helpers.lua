-- NOTE: this requires `IS_NVIM` to be set by the smart-splits.nvim plugin
function IsNvim(pane)
  return pane:get_user_vars().IS_NVIM == 'true'
end

function MergeTables(tables)
  local result = {}
  for _, tbl in ipairs(tables) do
    for k, v in pairs(tbl) do
      if not result[k] or type(v) ~= 'table' or type(result[k]) ~= 'table' then
        result[k] = v
      else
        for _, v2 in pairs(tbl) do
          table.insert(result[k], v2)
        end
      end
    end
  end
  return result
end
