-- luacheck: ignore 113 -- ignores undefined vim var
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

      signature = { enabled = true }
    },
    opts_extend = { 'sources.default' },
  },
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

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      {
        '<leader>tn',
        function()
          Snacks.notifier:hide()
        end,
        desc = 'Dismiss All Notifications',
      },
      {
        '<leader>bd',
        function()
          Snacks.bufdelete()
        end,
        desc = 'Delete Buffer',
      },
      {
        '<leader>gg',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazygit',
      },
      -- { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      {
        '<leader>gB',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'Git Browse',
      },
      {
        '<leader>gf',
        function()
          Snacks.lazygit.log_file()
        end,
        desc = 'Lazygit Current File History',
      },
      {
        '<leader>gl',
        function()
          Snacks.lazygit.log()
        end,
        desc = 'Lazygit Log (cwd)',
      },
      {
        '<leader>rf',
        function()
          Snacks.rename()
        end,
        desc = 'Rename File',
      },
      -- { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
      -- { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
      {
        ']]',
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = 'Next Reference',
      },
      {
        '[[',
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = 'Prev Reference',
      },
      {
        '<leader>N',
        desc = 'Neovim News',
        function()
          Snacks.win {
            file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = 'yes',
              statuscolumn = ' ',
              conceallevel = 3,
            },
          }
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>ts'
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tw'
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>tL'
          Snacks.toggle.diagnostics():map '<leader>td'
          Snacks.toggle.line_number():map '<leader>tl'
          Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>tc'
          Snacks.toggle.treesitter():map '<leader>tT'
          Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>tb'
          -- Snacks.toggle.inlay_hints():map("<leader>th")
        end,
      })
    end,
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

  { -- Harpoon 2 (fast buffer switch)
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

      -- Sets up automatic add to list if list is short
      local harpoon_auto_add = vim.api.nvim_create_augroup('harpoon_auto_add', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        group = harpoon_auto_add,
        callback = function()
          -- Only run in buffers that you can modify
          if not vim.opt_local.modifiable:get() then
            return
          end
          -- avoid oil buffers
          if string.find(vim.api.nvim_buf_get_name(0), '^oil://') then
            return
          end
          -- avoid overflow
          if harpoon:list()._length > 4 then
            return
          end
          harpoon:list():add()
        end,
      })

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
