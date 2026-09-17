-- The breadcrumb trail VSCode puts above the editor: path, then the enclosing
-- class/function chain from the language server.

return {
  'utilyre/barbecue.nvim',
  name = 'barbecue',
  version = '*',
  dependencies = { 'SmiteshP/nvim-navic', 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {
    attach_navic = true,
    create_autocmd = false, -- driven by the autocmd below instead
    show_modified = true,
    theme = 'auto',
    exclude_filetypes = { 'netrw', 'toggleterm', 'neo-tree', 'trouble', 'lazy', 'mason', 'gitcommit' },
  },
  config = function(_, opts)
    require('barbecue').setup(opts)

    vim.api.nvim_create_autocmd({ 'WinResized', 'BufWinEnter', 'CursorHold', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('barbecue-updater', { clear = true }),
      callback = function()
        require('barbecue.ui').update()
      end,
    })
  end,
}
