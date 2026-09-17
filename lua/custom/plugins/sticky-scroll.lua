-- VSCode's sticky scroll: pins the enclosing function/block headers to the top
-- of the window as you scroll past them.

return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'VeryLazy',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    max_lines = 3,
    multiline_threshold = 1,
    mode = 'cursor',
    separator = nil,
  },
  keys = {
    {
      '<leader>ts',
      function()
        require('treesitter-context').toggle()
      end,
      desc = 'Toggle sticky scroll',
    },
  },
}
