-- The real VSCode Dark+ palette, installed but not activated -- tokyonight-night
-- is still the colourscheme set in init.lua.
--
--   :colorscheme vscode        try it for this session
--   :colorscheme tokyonight-night   go back
--
-- To make it permanent, change the `vim.cmd.colorscheme` call in init.lua.

return {
  'Mofiqul/vscode.nvim',
  lazy = false, -- must be on the runtimepath for :colorscheme to find it
  priority = 900,
  config = function()
    require('vscode').setup {
      style = 'dark',
      italic_comments = true,
      underline_links = true,
      terminal_colors = true,
    }
  end,
}
