local M = {}

local lspkind = require('lspkind')

local entry_display = require('telescope.pickers.entry_display')
local make_entry = require('telescope.make_entry')
local utils = require('telescope.utils')

local function concat_lists(lists)
  local result = {}
  for _, lst in ipairs(lists) do
    for _, e in ipairs(lst) do
      table.insert(result, e)
    end
  end
  return result
end

local function get_path_and_file(path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  local cwd = vim.fn.getcwd()

  if parent == '.' then
    -- Do not display current working dir
    parent = nil
  elseif string.starts(parent, cwd) then
    -- Remove cwd in path if exists
    -- e.g. if cwd = /user/project and parent = /user/project/file
    -- format parent = file
    parent = string.sub(parent, string.len(cwd) + 2, string.len(parent))
  end

  return parent, tail
end

local function lsp_symbol_section(entry, opts)
  opts = opts or {}

  -- Use symbol provided by lspkind, similar to cmp
  local kind = entry.symbol_type
  local icon = lspkind.symbolic(kind, { mode = 'symbol' })
  local highlight = 'CmpItemKind' .. kind
  if icon == '' then
    -- Use default icon and highlighting
    icon = ' '
    highlight = 'CmpItemKind'
  end

  return {
    { { icon, highlight }, { width = 2 } },
    { entry.symbol_name, opts.symbol_width or {} },
  }
end

local function line_col_component(entry)
  local line_nr = entry.lnum .. ':' .. entry.col
  return { { line_nr, 'TelescopeResultsLineNr' }, { width = #line_nr } }
end

local function icon_component(entry)
  local icon_display, icon_hl = utils.transform_devicons(entry.filename)
  return { { icon_display, icon_hl }, { width = 2 } }
end

local function file_section(entry, opts)
  opts = opts or {}

  local path, file = get_path_and_file(entry.filename)

  local components = {
    icon_component(entry),
    { file, opts.file_width or {} },
    line_col_component(entry),
  }

  if path then
    table.insert(components, { { path, 'Comment' }, opts.path_width or {} })
  end

  return components
end

local function display_components(components, opts)
  opts = opts or {}
  local items = {}
  local contents = {}

  for _, component in ipairs(components) do
    table.insert(contents, component[1])
    table.insert(items, component[2] or {})
  end

  local displayer = entry_display.create({
    separator = opts.separator or ' ',
    items = items,
  })
  return displayer(contents)
end

function M.lsp_symbol_workspace_entry_maker()
  local entry_maker = make_entry.gen_from_lsp_symbols({})
  return function(line)
    local originalEntryTable = entry_maker(line)
    originalEntryTable.display = function(entry)
      local components = concat_lists({
        lsp_symbol_section(entry, { symbol_width = { width = 0.3 } }),
        file_section(entry),
      })
      return display_components(components)
    end
    return originalEntryTable
  end
end

function M.lsp_symbol_entry_maker()
  local entry_maker = make_entry.gen_from_lsp_symbols({})
  return function(line)
    local originalEntryTable = entry_maker(line)
    originalEntryTable.display = function(entry)
      local components = concat_lists({
        lsp_symbol_section(entry),
        { line_col_component(entry) },
      })
      return display_components(components)
    end
    return originalEntryTable
  end
end

function M.grep_entry_maker()
  local entry_maker = make_entry.gen_from_vimgrep({})
  return function(line)
    local originalEntryTable = entry_maker(line)
    originalEntryTable.display = function(entry)
      local components = concat_lists({
        file_section(entry),
        { { entry.text } },
      })
      return display_components(components)
    end
    return originalEntryTable
  end
end

function string.starts(String, Start)
  return string.sub(String, 1, string.len(Start)) == Start
end

function M.file_name_first_path_display(_, path)
  local parent, tail = get_path_and_file(path)

  if not parent then
    return tail
  else
    -- Use two tabs to delimit filename and path
    -- This works from a highlight group created in telescope.lua
    return string.format('%s\t\t%s\t\t', tail, parent)
  end
end

return M
