-- VSCode's multi-cursor: Ctrl+D to add the next occurrence, Ctrl+Shift+L for
-- all of them. Once cursors exist, type as normal; <Esc> collapses back to one.

return {
  'mg979/vim-visual-multi',
  branch = 'master',
  event = 'VeryLazy',
  init = function()
    -- Neo-tree owns `\`, so move vim-visual-multi's own prefix off it.
    vim.g.VM_leader = ','
    vim.g.VM_default_mappings = 0
    vim.g.VM_mouse_mappings = 1
    vim.g.VM_silent_exit = 1
    vim.g.VM_show_warnings = 0

    vim.g.VM_maps = {
      ['Find Under'] = '<C-d>',
      ['Find Subword Under'] = '<C-d>',
      ['Select All'] = '<C-S-l>',
      ['Skip Region'] = '<C-x>',
      ['Add Cursor Down'] = '<C-A-Down>',
      ['Add Cursor Up'] = '<C-A-Up>',
      -- VSCode adds a cursor with Alt+click; Ctrl+click is go-to-definition.
      ['Mouse Cursor'] = '<A-LeftMouse>',
      ['Mouse Word'] = '<A-RightMouse>',
      ['Undo'] = 'u',
      ['Redo'] = '<C-r>',
    }
  end,
}
