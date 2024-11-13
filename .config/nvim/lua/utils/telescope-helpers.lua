local M = {}

local lspkind = require('lspkind')

local entry_display = require('telescope.pickers.entry_display')
local make_entry = require('telescope.make_entry')

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

  local components = {
    { icon, highlight },
    entry.symbol_name,
  }
  local items = { { width = 2 }, opts.symbol_width or {} }
  return components, items
end

local function file_section(entry, opts)
  opts = opts or {}

  local path, file = get_path_and_file(entry.filename)
  if path then
    -- TODO: consider line:col numbers. This requires changing everything to entry_maker
    -- perhaps as a separate section, so can use for document symbols?
    return { file .. ' ', { path, 'Comment' } }, { opts.file_width or {}, opts.path_width or {} }
  else
    return { file }, { opts.file_width or {} }
  end
end

local function display_sections(entry, sections, opts)
  opts = opts or {}
  local section_items = {}
  local section_components = {}

  for _, section in ipairs(sections) do
    local section_func, section_opts

    if type(section) == 'table' then
      section_func = section[1]
      section_opts = section.opts or section[2] or {}
    else
      section_func = section
      section_opts = {}
    end

    local components, items = section_func(entry, section_opts)
    table.insert(section_components, components)
    table.insert(section_items, items)
  end

  local displayer = entry_display.create({
    separator = opts.separator or ' ',
    items = concat_lists(section_items),
  })
  return displayer(concat_lists(section_components))
end

local function make_sections_display(sections, opts)
  return function(entry)
    return display_sections(entry, sections, opts)
  end
end

function M.lsp_symbol_entry_maker(opts)
  opts = opts or {}

  --- if show file, width is 0.3, else 0.5
  local symbol_width = opts.show_file and { width = 0.3 } or { remaining = true }
  local sections = {
    {
      lsp_symbol_section,
      opts = { symbol_width = symbol_width },
    },
  }
  if opts.show_file then
    table.insert(sections, file_section)
  end

  local entry_maker = make_entry.gen_from_lsp_symbols({})
  return function(line)
    local originalEntryTable = entry_maker(line)
    originalEntryTable.display = make_sections_display(sections)
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
