-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim
--
-- Set up to stand in for VSCode's Explorer: left-hand side, tracks the file you
-- are editing, single Enter to open. Ctrl+B toggles it, Ctrl+Shift+E focuses it
-- (see lua/custom/vscode.lua). `\` still works too.

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
      indent = {
        with_markers = true,
        with_expanders = true,
      },
    },
    window = {
      position = 'left',
      width = 32,
      mappings = {
        ['\\'] = 'close_window',
      },
    },
    filesystem = {
      -- Reveal the current file in the tree as you move between buffers.
      follow_current_file = { enabled = true, leave_dirs_open = true },
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = 'open_default',
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = { '.DS_Store', 'node_modules' },
      },
    },
  },
}
