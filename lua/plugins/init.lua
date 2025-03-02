return {
  { -- Completion
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = 'v0.*',
    opts = {
      keymap = { preset = 'default' },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },

      signature = { enabled = true },
    },
    opts_extend = { 'sources.default' },
  },

  { -- File explorer
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    config = function(opts)
      require('oil').setup(opts)
      vim.api.nvim_create_autocmd('User', {
        pattern = 'OilActionsPost',
        callback = function(event)
          if event.data.actions.type == 'move' then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
          end
        end,
      })
    end,
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      columns = { 'icon' },
      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
          return name == '..' or name == '.git'
        end,
      },
    },
    keys = {
      {"-", '<cmd>Oil<cr>', { desc = "Open parent directory"}}
    },
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },

  {
    'folke/trouble.nvim',
    opts = { focus = true },
    cmd = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>cl', '<cmd>Trouble lsp toggle focus win.position=right<cr>', desc = 'LSP Definitions (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xf', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
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

  { -- Better html and xml tagging
    'windwp/nvim-ts-autotag',
    -- lazy=false,
    opts={},
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
      -- markdown preview
      { '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', desc = 'Markdown' },
    },
  },
}
