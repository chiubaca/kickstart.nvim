-- Routes vim.ui.input and vim.ui.select through floating windows, so Rename
-- (F2), Go to line (Ctrl+G) and code-action menus look like VSCode's dialogs
-- instead of a prompt on the last line.

return {
  'stevearc/dressing.nvim',
  event = 'VeryLazy',
  opts = {
    input = {
      border = 'rounded',
      relative = 'cursor',
      prefer_width = 40,
    },
    select = {
      backend = { 'telescope', 'builtin' },
    },
  },
}
