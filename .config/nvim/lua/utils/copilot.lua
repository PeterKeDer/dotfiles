local M = {}

-- Try to accept a copilot suggestion. Return true if accepted, false otherwise
-- Supports both copilot.lua and copilot-lsp for NES (whichever is available)
M.copilot_try_accept = function()
  local nes_ok, nes = pcall(require, 'copilot-lsp.nes')
  local copilot_ok, copilot = pcall(require, 'copilot.suggestion')

  if nes_ok then
    -- The current behavior jumps and completes. If we want to jump and complete
    -- using separate tabs, check the return of walk_cursor_end_edit()
    nes.walk_cursor_start_edit()
    return (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
  elseif copilot_ok then
    return copilot.is_visible() and copilot.accept()
  end

  return false
end

return M
