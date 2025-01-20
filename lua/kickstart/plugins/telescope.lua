return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    print 'telescope activate'

    require('telescope').setup {
      pickers = {
        find_files = {
          -- theme = 'ivy',
        },
      },
      defaults = {
        file_ignore_patterns = { 'dist', 'node_modules', '.git/' },
      },
    }

    -- open telescope
    vim.keymap.set('n', '<space>f', require('telescope.builtin').find_files)

    -- global fuzzy find
    vim.keymap.set('n', '<space>fg', require('telescope.builtin').live_grep)

    vim.keymap.set('n', '<space>/', function()
      require('telescope.builtin').current_buffer_fuzzy_find {
        sorting_strategy = 'ascending', -- Optional: display matches from top to bottom
        previewer = false, -- Optional: disable preview for faster navigation
      }
    end, { noremap = true, silent = true })
  end,
}
