-- VSCode's integrated terminal panel, on Ctrl+` (see lua/custom/vscode.lua).

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = { 'ToggleTerm', 'TermExec' },
  opts = {
    direction = 'horizontal',
    size = function(term)
      if term.direction == 'horizontal' then
        return math.floor(vim.o.lines * 0.3)
      end
      return math.floor(vim.o.columns * 0.4)
    end,
    start_in_insert = true,
    persist_size = true,
    persist_mode = false,
    shade_terminals = false,
  },
}
