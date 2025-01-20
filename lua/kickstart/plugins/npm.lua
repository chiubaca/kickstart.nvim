-- Add this inside your lazy.nvim setup table, along with your other plugins
return {
  'vuki656/package-info.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  opts = {
    icons = {
      enable = true, -- Enable icons
      style = {
        up_to_date = '| 📦', -- Icon for up to date dependencies
        outdated = '| 📦', -- Icon for outdated dependencies
      },
    },
    autostart = true, -- Automatically show package versions when opening package.json
    hide_up_to_date = false, -- Hide up to date dependencies
    hide_unstable_versions = false, -- Hide unstable versions from version list
  },
  event = 'BufRead package.json',
  keys = {
    {
      '<leader>ns',
      function()
        require('package-info').show()
      end,
      desc = 'Show package versions',
    },
    {
      '<leader>nc',
      function()
        require('package-info').hide()
      end,
      desc = 'Hide package versions',
    },
    {
      '<leader>nt',
      function()
        require('package-info').toggle()
      end,
      desc = 'Toggle package versions',
    },
    {
      '<leader>nu',
      function()
        require('package-info').update()
      end,
      desc = 'Update dependency on the line',
    },
    {
      '<leader>nd',
      function()
        require('package-info').delete()
      end,
      desc = 'Delete dependency on the line',
    },
    {
      '<leader>ni',
      function()
        require('package-info').install()
      end,
      desc = 'Install new dependency',
    },
  },
}
