return {
  { --File Explorer
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      '3rd/image.nvim',
    },
    opts = {
      event_handlers = {
        {
          event = 'neo_tree_buffer_enter',
          handler = function(_)
            vim.opt.relativenumber = true
          end,
        },
      },
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
        '<cmd>ToggleTerm<CR><cmd>startinsert<CR><cmd>setlocal nospell<CR>',
        desc = 'ToggleTerm',
      },
      {
        '<leader>tl',
        '<cmd>ToggleTerm direction=vertical size=50<CR><cmd>startinsert<CR><cmd>setlocal nospell<CR>',
        desc = 'ToggleTerm right',
      },
      {
        '<leader>ts',
        '<cmd>ToggleTermSendVisualSelection<CR>',
        desc = 'ToggleTerm send selection',
      },
    },
  },

  { -- Auto-Save buffers
    'tmillr/sos.nvim',
    event = 'InsertEnter',
    opts = {
      enabled = true,
      timeout = 10000, --ms
      autowrite = true,
      save_on_cmd = false,
      save_on_bufleave = false,
      save_on_focuslost = false,
    },
    keys = {
      { '<leader>ta', '<cmd>SosToggle<CR>', desc = 'auto-save toggle' },
    },
  },

  -- Zoxide (fast directory change)
  { 'nanotee/zoxide.vim', lazy = false },

  { -- LuaLine (status line for nvim)
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  {
    'blumaa/ohne-accidents',
    config = function()
      require('ohne-accidents').setup { welcomeOnStartup = false }
      vim.api.nvim_set_keymap('n', '<leader>oh', ':OhneAccidents<CR>', { noremap = true, silent = true })
    end,
  },

  { -- Highlight colors
    'brenoprata10/nvim-highlight-colors',
    opts = {},
  },

  { -- Harpoon 2 (fast buffer change)
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup {}

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'Harpoon2 add' })
      vim.keymap.set('n', '<C-e>', function()
        local toggle_opts = {
          border = 'rounded',
          title_pos = 'center',
        }
        harpoon.ui:toggle_quick_menu(harpoon:list(), toggle_opts)
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

  { -- Show where you are in a top bar
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      enable = true,
      max_lines = 9,
      multiline_threshold = 1,
    },
  },

  { -- Refactoring (fast multi-lang Refactor command)
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function(opts)
      require('refactoring').setup(opts)
      vim.keymap.set('x', '<leader>re', '<cmd>Refactor extract<CR>')
      vim.keymap.set('x', '<leader>rf', '<cmd>Refactor extract_to_file<CR>')
      vim.keymap.set('x', '<leader>rv', '<cmd>Refactor extract_var<CR>')
      vim.keymap.set({ 'n', 'x' }, '<leader>ri', '<cmd>Refactor inline_var<CR>')
      vim.keymap.set('n', '<leader>rI', '<cmd>Refactor inline_func<CR>')
    end,
  },

  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    config = function()
      -- Setup orgmode
      require('orgmode').setup {
        org_agenda_files = '~/Notes/**/*',
        org_default_notes_file = '~/Notes/index.norg',
      }
    end,
  },

  { -- Markdown Preview
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    keys = {
      {
        '<leader>pm',
        '<cmd>MarkdownPreviewToggle<CR>',
        desc = 'Markdown',
      },
    },
  },

  { -- Git plugins
    'kdheepak/lazygit.nvim',
    cmd = { --which commands load lazygit plugin
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

  { -- Transparent-Nvim
    'xiyaowong/transparent.nvim',
    lazy = false,
  },
}
