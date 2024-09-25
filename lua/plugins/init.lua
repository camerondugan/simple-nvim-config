-- luacheck: ignore 113 -- ignores undefined vim var
return {
  { -- File explorer
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      columns = { 'icon' },
      keymaps = {
        ['<C-h>'] = false,
        ['<M-h>'] = 'actions.select_split',
      },
      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
          return name == '..' or name == '.git'
        end,
      },
    },
    keys = {
      {
        '-',
        '<cmd>Oil<cr>',
        desc = 'Open parent dir',
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

  { -- Highlight colors from hex or other color codes
    'brenoprata10/nvim-highlight-colors',
    opts = {},
  },

  { -- Harpoon 2 (fast buffer change)
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    commit = 'e76cb03', -- for when harpoon doesn't account for cd
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      settings = {
        save_on_toggle = true,
        save_on_ui_close = true,
      },
    },
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
    opts = {
      org_agenda_files = '~/Notes/**',
      org_default_notes_file = '~/Notes/index.org',
    },
  },

  { -- Wraps based on file info
    'andrewferrier/wrapping.nvim',
    opts = {},
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
}
