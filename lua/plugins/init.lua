-- luacheck: ignore 113 -- ignores undefined vim var
return {
  { -- File explorer
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        columns = { 'icon' },
        keymaps = {
          ['<C-h}'] = false,
          ['<M-h>'] = 'actions.select_split',
        },
        view_options = {
          show_hidden = true,
        },
      }

      -- Open parent folder in cur window
      vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent dir' })
    end,
  },

  { --Toggle Terminal
    'akinsho/toggleterm.nvim',
    opts = {},
    keys = {
      {
        '=',
        '<cmd>ToggleTerm<cr><cmd>startinsert<cr><cmd>setlocal nospell<cr>',
        desc = 'ToggleTerm',
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
      { '<leader>ta', '<cmd>SosToggle<cr>', desc = 'auto-save toggle' },
    },
  },

  -- Zoxide (fast directory change)
  { 'nanotee/zoxide.vim', lazy = false },

  { -- LuaLine (status line for Neovim)
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  { -- Show how long it's been since you tweaked your config
    'blumaa/ohne-accidents',
    config = function()
      require('ohne-accidents').setup { welcomeOnStartup = false }
      vim.api.nvim_set_keymap('n', '<leader>oh', ':OhneAccidents<cr>', { noremap = true, silent = true })
    end,
  },

  { -- Highlight colors from hex or other color codes
    'brenoprata10/nvim-highlight-colors',
    opts = {},
  },

  { -- Harpoon 2 (fast buffer change)
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    commit = 'e76cb03', -- for when harpoon breaks
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { settings = {
      save_on_toggle = true,
      save_on_ui_close = true,
    } },
    config = function(opts)
      local harpoon = require 'harpoon'
      harpoon:setup { opts }

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

  { -- Shows what you are editing in the top bar if off screen
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
      vim.keymap.set('x', '<leader>re', '<cmd>Refactor extract<cr>')
      vim.keymap.set('x', '<leader>rf', '<cmd>Refactor extract_to_file<cr>')
      vim.keymap.set('x', '<leader>rv', '<cmd>Refactor extract_var<cr>')
      vim.keymap.set({ 'n', 'x' }, '<leader>ri', '<cmd>Refactor inline_var<cr>')
      vim.keymap.set('n', '<leader>rI', '<cmd>Refactor inline_func<cr>')
    end,
  },

  { -- Notes and organization
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    config = function()
      -- Setup orgmode
      require('orgmode').setup {
        org_agenda_files = '~/Notes/**',
        org_default_notes_file = '~/Notes/index.org',
      }
    end,
  },

  { -- Auto Session
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        log_level = 'error',
        auto_session_suppress_dirs = { '~/', '~/Downloads', '/' },
      }
    end,
  },

  { -- Markdown Preview
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' }, -- only loads in markdown files
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    keys = { -- only load if these key binds are pressed
      { -- preview markdown
        '<leader>pm',
        '<cmd>MarkdownPreviewToggle<cr>',
        desc = 'Markdown',
      },
      { -- markdown preview
        '<leader>mp',
        '<cmd>MarkdownPreviewToggle<cr>',
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

  -- Framework Specific Plugins
  { -- Flutter
    'mskelton/flutter.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = true,
  },

  -- LLM Tinkering
  {
    'nomnivore/ollama.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    cmd = { 'Ollama', 'OllamaModel', 'OllamaServe', 'OllamaServeStop' },
    opts = { -- a custom ollama model found here: https://github.com/camerondugan/pair-programmer
      model = 'pair-programmer', -- it avoids brain rot from code gen for the most part.
    },
    keys = {
      -- {
      --   '<leader>ll',
      --   ":<c-u>lua require('ollama').prompt()<cr>",
      --   desc = 'Ollama Prompt',
      --   mode = { 'n', 'v' },
      -- },
      {
        '<leader>le',
        ":<c-u>lua require('ollama').prompt('Explain_Code')<cr>",
        desc = 'Ollama Explain Code',
        mode = { 'n', 'v' },
      },
      {
        '<leader>lE',
        "<esc>ggVG:<c-u>lua require('ollama').prompt('Explain_Code')<cr>",
        desc = 'Ollama Explain File',
        mode = { 'n', 'v' },
      },
      {
        '<leader>lq',
        ":<c-u>lua require('ollama').prompt('Ask_About_Code')<cr>",
        desc = 'Ollama Ask About Code',
        mode = { 'n', 'v' },
      },
      {
        '<leader>lQ',
        "<esc>ggVG:<c-u>lua require('ollama').prompt('Ask_About_Code')<cr>",
        desc = 'Ollama Ask About Code whole file',
        mode = { 'n', 'v' },
      },
      {
        '<leader>lq',
        ":<c-u>lua require('ollama').prompt('Ask_About_Code')<cr>",
        desc = 'Ollama Ask About Code',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ll',
        ":<c-u>lua require('ollama').prompt('Raw')<cr>",
        desc = 'Ollama Chat',
        mode = { 'n', 'v' },
      },
    },
  },
}
