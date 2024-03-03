-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { --File Explorer
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      '3rd/image.nvim',
    },
    keys = {
      {
        '<leader>f',
        '<cmd>Neotree toggle float<CR>',
        desc = 'File Explorer',
      },
    },
  },
  { --Toggle Terminal
    'akinsho/toggleterm.nvim',
    opts = {},
    keys = {
      {
        '<leader>tt',
        '<cmd>ToggleTerm<CR>',
      },
    },
  },

  { -- Auto-Save buffers
    'Pocco81/auto-save.nvim',
    opts = {
      trigger_events = { 'InsertLeave', 'TextChanged' },
      condition = function(buf)
        local fn = vim.fn
        local utils = require 'auto-save.utils.data'
        if
          fn.getbufvar(buf, '&modifiable') == 1
          and utils.not_in(fn.getbufvar(buf, '&filetype'), {})
          and string.find(fn.getbufvar(buf, '&name'), '__harpoon__')
        then
          return true
        end
        return false
      end,
    },
    keys = {
      { '<leader>ta', '<cmd>ASToggle<CR>', desc = 'auto-save toggle' },
    },
  },

  -- Zoxide (fast directory change)
  { 'nanotee/zoxide.vim', lazy = false },

  { -- LuaLine (status line for nvim)
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  { -- Harpoon2 (fast buffer change)
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
      -- Harpoon with telescope
      local harpoon = require 'harpoon'
      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():append()
      end, { desc = 'Harpoon2 add' })
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
      vim.keymap.set('n', '<C-h>', function()
        harpoon:list():select(1)
      end)
      vim.keymap.set('n', '<C-j>', function()
        harpoon:list():select(2)
      end)
      vim.keymap.set('n', '<C-k>', function()
        harpoon:list():select(3)
      end)
      vim.keymap.set('n', '<C-l>', function()
        harpoon:list():select(4)
      end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-S-p>', function()
        harpoon:list():prev()
      end)
      vim.keymap.set('n', '<C-S-n>', function()
        harpoon:list():next()
      end)
    end,
  },

  -- Refactoring (fast multi-lang Refactor command)
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('refactoring').setup()
    end,
  },

  -- Neorg config (note taking setup)
  {
    'nvim-neorg/neorg',
    build = ':Neorg sync-parsers',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neorg/neorg-telescope',
    },
    event = 'VeryLazy',
    opts = {
      load = {
        ['core.defaults'] = {}, -- Loads default behaviour
        ['core.concealer'] = {}, -- Adds pretty icons to your documents
        ['core.keybinds'] = {}, -- Adds default keybindings
        ['core.summary'] = {}, -- Adds generate-workspace-summary
        -- ['core.ui.calendar'] = {}, -- Available in nvim 0.10.0+
        ['core.completion'] = {
          config = {
            engine = 'nvim-cmp',
          },
        }, -- Enables support for completion plugins
        ['core.journal'] = {}, -- Enables support for the journal module
        ['core.dirman'] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = '~/Notes',
            },
            default_workspace = 'notes',
          },
        },
      },
    },
    keys = {
      {
        '<leader>n',
        '<cmd>Neorg<CR>',
        { desc = 'Neorg commands' },
      },
      {
        '<leader>sN',
        '<cmd>Telescope neorg find_linkable<CR>',
        { desc = 'Neorg' },
      },
    },
  },

  -- Git plugins
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
}