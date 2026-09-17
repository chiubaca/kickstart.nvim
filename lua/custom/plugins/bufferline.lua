-- VSCode's editor tabs across the top of the window.
-- Keymaps live in lua/custom/vscode.lua.

return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {
    options = {
      mode = 'buffers',
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(count, level)
        return (level:match 'error' and ' ' or ' ') .. count
      end,
      separator_style = 'thin',
      show_buffer_close_icons = true,
      show_close_icon = false,
      always_show_bufferline = true,
      hover = { enabled = true, delay = 120, reveal = { 'close' } },
      -- Keep the tab bar clear of the file tree, so it reads as a sidebar.
      offsets = {
        { filetype = 'neo-tree', text = 'EXPLORER', highlight = 'Directory', separator = true },
      },
    },
  },
}
