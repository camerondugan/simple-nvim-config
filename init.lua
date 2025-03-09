-- luacheck: ignore 113 -- ignores undefined vim var
require 'options'
require 'keys'
require 'autocommands'

-- Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  'tpope/vim-sleuth',   -- Detect expandtab and shiftwidth automatically

  {                     -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      local wk = require 'which-key'
      wk.setup()

      -- Document existing key chains
      -- Normal Mode
      wk.add {
        { '<leader>b', group = 'Buffer' },
        { '<leader>c', group = 'Code' },
        { '<leader>d', group = 'Debug' },
        { '<leader>g', group = 'Git' },
        { '<leader>m', group = 'Markdown' },
        { '<leader>o', group = 'OrgMode' },
        { '<leader>p', group = 'Preview' },
        { '<leader>r', group = 'Refactor' },
        { '<leader>s', group = 'Search' },
        { '<leader>t', group = 'Toggle' },
        { '<leader>u', group = 'Toggle' },
        { '<leader>x', group = 'Trouble' },
      }
    end,
  },

  -- LSP Plugins
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependents
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      'j-hui/fidget.nvim',

      -- Allows extra capabilities provided by nvim-cmp
      'saghen/blink.cmp',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('<leader>rn', vim.lsp.buf.rename, 'Rename')

          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')

          map('<leader>cr', '<cmd>LspRestart<cr><cmd>LspStart<cr>', 'Restart Lsp')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle Inlay Hints')
          end
        end,
      })

      -- Change diagnostic symbols in the sign column (gutter)
      if vim.g.have_nerd_font then
        local signs = { Error = '', Warn = '', Hint = '', Info = '' }
        for type, icon in pairs(signs) do
          local hl = 'DiagnosticSign' .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
      end

      local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
      local default = { capabilities = capabilities }

      local servers = {
        bashls = default,
        clangd = {
          capabilities = {
            signatureHelpProvider = false,
            offsetEncoding = 'utf-16',
          },
        },
        codespell = default,
        docker_compose_language_service = default,
        gopls = default,
        gradle_ls = default,
        jdtls = default,   -- java LSP
        jsonls = default,
        lemminx = default, -- XML
        luacheck = default,
        pyright = default,
        taplo = default,
      }

      -- Anything not from mason / cannot run without dynamic linking
      local lsp = require 'lspconfig'
      lsp.gdscript.setup(default)
      lsp.rust_analyzer.setup(default)
      lsp.gleam.setup(default)
      lsp.nixd.setup {
        cmd = { 'nixd' },
        settings = {
          nixd = {
            nixpkgs = {
              expr = 'import <nixpkgs> { }',
            },
          },
        },
      }
      lsp.nil_ls.setup(default)
      lsp.typos_lsp.setup(default)
      lsp.yamlls.setup(default)
      lsp.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      }

      -- Gives :Mason command
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- formatters
        'asmfmt',
        'autopep8',
        'black', -- python
        'clang-format',
        'gdtoolkit',
        -- 'gofumpt',
        'goimports',
        'golines',
        'google-java-format',
        'gomodifytags',
        'isort',
        'prettier',
        'prettierd',
        'shfmt',
        'java-test',
        -- linters
        'htmlhint',
        'golangci-lint', -- golang
        'markdownlint',  -- markdown
        'quick-lint-js', -- javascript
        'yamllint',      -- yaml
        'jsonlint',      -- json
        'hadolint',      -- docker file
        'proselint',
        'shellcheck',
        'shellharden',
        'nixpkgs-fmt',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            lsp[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Better format
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'prefer' }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        go = { 'goimports', 'golines', 'gofmt' },                          -- a then b then c
        java = { 'google-java-format' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true }, -- a or b
        json = { 'prettierd', 'prettier', stop_after_first = true },
        lua = { 'stylua' },
        protobuf = { 'clang-format' },
        python = { 'isort', 'black' },
        rust = { 'rustfmt' },
        dart = { 'dart_format' },
        sh = { 'shellharden', 'shfmt' },
        nix = { 'alejandra' },
        gdscript = { 'gdformat' },
        text = {},
        ['*'] = { 'trim_whitespace', 'codespell' },
      },
    },
  },

  { -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VimEnter',
    opts = { signs = false },
    keys = {
      {
        '<leader>st',
        function()
          Snacks.picker.todo_comments()
        end,
        desc = 'Todo',
      },
      {
        '<leader>sT',
        function()
          Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
        end,
        desc = 'Todo/Fix/Fixme',
      },
      {
        '<leader>xi',
        '<cmd>Trouble todo filter = {tag = {NOTE,WARNING,HACK,PERF}}<cr>',
        mode = 'n',
        desc = 'Todos',
      },
      {
        '<leader>xt',
        '<cmd>Trouble todo filter = {tag = {TODO,FIX,FIXME}}<cr>',
        mode = 'n',
        desc = 'Todos',
      },
      {
        '<leader>xT',
        '<cmd>Trouble todo = {tag = {TODO,FIX,FIXME}}<cr>',
        mode = 'n',
        desc = 'Todos All',
      },
    },
  },
  -- Collection of various small independent plugins/modules
  {
    'echasnovski/mini.nvim',
    dependencies = { 'hrsh7th/nvim-cmp' }, --pairs
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.pairs').setup() -- Auto add ([{' pairs
      require('mini.map').setup()   -- Auto add ([{' pairs
      require('mini.diff').setup {
        -- view = { style = 'sign', signs = {
        --   add = '+',
        --   change = '~',
        --   delete = '_',
        -- } },
        mappings = {
          apply = 'gh',     -- apply git hunk (stage)
          reset = 'gr',     -- reset git hunk
          goto_prev = '[c', -- navigate hunks
          goto_next = ']c',
          goto_first = '[C',
          goto_last = ']C',
        },
      }

      vim.keymap.set('n', '<leader>gd', MiniDiff.toggle_overlay, {})
      vim.keymap.set('n', '<Leader>um', MiniMap.toggle)

      --  Check out: https://github.com/echasnovski/mini.nvim
      require('mini.sessions').setup()
      require('mini.statusline').setup()
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'filNaj/tree-setter' },
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- See `:help nvim-treesitter`
    opts = {
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      tree_setter = { enable = true },
    },
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
  { -- smarter text objects
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            include_surrounding_whitespace = true,
            keymaps = {
              ['af'] = '@function.outer',  -- methods
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',     -- classes
              ['ic'] = '@class.inner',
              ['i/'] = '@comment.inner',   -- comments
              ['a/'] = '@comment.outer',
              ['ia'] = '@parameter.inner', -- args
              ['aa'] = '@parameter.outer',
              ['ir'] = '@return.inner',    -- returns
              ['ar'] = '@return.outer',
            },
          },
        },
      }
    end,
  },

  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.lint',

  { import = 'plugins' },
}
