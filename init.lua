-- luacheck: ignore 113 -- ignores undefined vim var
require 'options'
require 'keys'
require 'autocommands'

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup {
        -- ...
      }

      vim.cmd 'colorscheme github_dark_default'
    end,
  },

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Useful plugin to show you pending keybinds.
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
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
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
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'saghen/blink.cmp',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          -- map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')

          -- Find references for the word under your cursor.
          -- map('gr', require('telescope.builtin').lsp_references, 'Goto References')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          -- map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type Definition')

          -- Fuzzy find all the symbols in your current workspace
          --  Similar to document symbols, except searches over your whole project.
          -- vim.keymap.set(
          --   'n',
          --   '<leader>ss',
          --   require('telescope.builtin').lsp_dynamic_workspace_symbols,
          --   { buffer = event.buf, desc = 'Search Symbols in Workspace' }
          -- )

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')

          -- Restart your LSP, useful when suggestions stop working.
          -- Hopefully you will rarely use this one.
          map('<leader>cr', '<cmd>LspRestart<cr><cmd>LspStart<cr>', 'Restart Lsp')

          -- Fuzzy find all the symbols in your current buffer.
          --  Symbols are things like variables, functions, types, etc.
          -- map('<leader>cs', require('telescope.builtin').lsp_document_symbols, 'Code Symbols')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          -- map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          -- map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
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

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        bashls = {},
        clangd = {
          capabilities = {
            signatureHelpProvider = false,
            offsetEncoding = 'utf-16',
          },
        },
        codespell = {},
        docker_compose_language_service = {},
        gopls = {},
        gradle_ls = {},
        jdtls = {}, -- java LSP
        jsonls = {},
        lemminx = {}, -- XML
        luacheck = {},
        pyright = {},
        taplo = {},
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
      }

      -- Anything not from mason / cannot run without dynamic linking
      require('lspconfig').gdscript.setup {}
      require('lspconfig').rust_analyzer.setup {}
      require('lspconfig').gleam.setup {}
      require('lspconfig').nixd.setup {
        cmd = { 'nixd' },
        settings = {
          nixd = {
            nixpkgs = {
              expr = 'import <nixpkgs> { }',
            },
          },
        },
      }
      require('lspconfig').nil_ls.setup {}
      require('lspconfig').typos_lsp.setup {}
      require('lspconfig').yamlls.setup {}
      require('lspconfig').lua_ls.setup {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
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
        'markdownlint', -- markdown
        'quick-lint-js', -- javascript
        'yamllint', -- yaml
        'jsonlint', -- json
        'hadolint', -- docker file
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
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Auto format
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        go = { 'goimports', 'golines', 'gofmt' }, -- a then b then c
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

  -- -- Show function signature while typing
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    opts = {
      floating_window = false,
      hint_prefix = '',
    },
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },
  -- Or with configuration
  -- Highlight todo, notes, etc in comments
  {
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

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      -- Examples:
      --  - va)  - Visually select Around )
      --  - yinq - Yank Inside Next '
      --  - ci'  - Change Inside '
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- - saiw) - Surround Add Inner Word )
      -- - sd'   - Surround Delete '
      -- - sr)'  - Surround Replace ) '
      require('mini.surround').setup()
      -- require('mini.pairs').setup() -- Auto add ([{' pairs
      -- ... And there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
      require('mini.sessions').setup { autoread = true }
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      -- ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.gitsigns',
  require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',

  { import = 'plugins' },
}
