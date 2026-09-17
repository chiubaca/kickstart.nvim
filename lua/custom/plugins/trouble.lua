-- VSCode's Problems panel and Outline view.
-- Ctrl+Shift+M and the <leader>x keys are in lua/custom/vscode.lua.

return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = {
    focus = true,
    win = { position = 'bottom', size = { height = 0.3 } },
    modes = {
      symbols = {
        win = { position = 'right', size = { width = 40 } },
      },
    },
  },
}
