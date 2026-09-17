-- Small things VSCode does out of the box.

return {
  -- Closes and renames JSX/HTML tag pairs as you type.
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'xml', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte', 'vue', 'astro', 'markdown' },
    opts = {},
  },

  -- A colour swatch next to every hex value, rgb() and Tailwind class.
  {
    'brenoprata10/nvim-highlight-colors',
    event = 'VeryLazy',
    opts = {
      render = 'virtual',
      virtual_symbol = '■',
      virtual_symbol_position = 'inline',
      virtual_symbol_suffix = ' ',
      enable_named_colors = true,
      enable_tailwind = true,
    },
  },
}
