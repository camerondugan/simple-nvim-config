return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      input = { enabled = true },
      indent = { enabled = true, animate = { enabled = false } },
      notifier = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      image = { enabled = true },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 15, total = 200 },
        },
        animate_repeat = {
          delay = 300,
        },
      },
      terminal = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      { '<leader>tn', function() Snacks.notifier:hide() end, desc = 'Dismiss All Notifications', },
      { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer', },
      { '<leader>rf', function() Snacks.rename() end, desc = 'Rename File', },
      -- Terminal
      { '<c-/>', function() Snacks.terminal.toggle() end, desc = 'Toggle Terminal', },
      { '<c-/>', function() Snacks.terminal.toggle() end, mode = 't', desc = 'Toggle Terminal', },
      -- Words
      { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', }, 
      { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', },
      -- Windows
      {
        '<leader>N',
        desc = 'Neovim News',
        function()
          Snacks.win {
            file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
            width = 0.6,
            height = 0.9,
            wo = {
              spell = false,
              wrap = true,
              signcolumn = 'yes',
              statuscolumn = '  ',
              conceallevel = 3,
            },
          }
        end,
      },
      -- Top Pickers & Explorer
      { '<leader><space>', function() Snacks.picker.buffers() end, desc = 'Search Buffers', },
      { '<leader>,', function() Snacks.picker.smart() end, desc = 'Smart Find Files', },
      { '<leader>/', function() Snacks.picker.lines() end, desc = 'Search Lines', },
      { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History', },
      { '<leader>n', function() Snacks.picker.notifications() end, desc = 'Notification History', },
      { '<leader>z', function() Snacks.picker.zoxide() end, desc = 'Search Zoxide', },
      -- find
      { '<leader>sb', function() Snacks.picker.buffers() end, desc = 'Buffers', },
      { '<leader>sc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File', },
      { '<leader>sf', function() Snacks.picker.files() end, desc = 'Find Files', },
      { '<leader>sg', function() Snacks.picker.git_files() end, desc = 'Find Git Files', },
      { '<leader>sp', function() Snacks.picker.projects() end, desc = 'Projects', },
      { '<leader>sr', function() Snacks.picker.recent() end, desc = 'Recent', },
      -- git
      { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit', },
      { '<leader>gb', function() Snacks.git.blame_line() end, desc = 'Git Blame Line', },
      { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse', },
      { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'Lazygit Current File History', },
      { '<leader>gl', function() Snacks.lazygit.log() end, desc = 'Lazygit Log (cwd)', },
      { '<leader>gr', function() Snacks.picker.git_branches() end, desc = 'Git Branches', },
      { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log', },
      { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line', },
      { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status', },
      { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash', },
      { '<leader>gD', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)', },
      { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File', },
      -- Grep
      { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines', },
      { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers', },
      { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep', },
      { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' },
      },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers', },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History', },
      { '<leader>sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds', },
      { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines', },
      { '<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands', },
      { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics', },
      { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics', },
      { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Pages', },
      { '<leader>sH', function() Snacks.picker.highlights() end, desc = 'Highlights', },
      { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons', },
      { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps', },
      { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps', },
      { '<leader>sl', function() Snacks.picker.loclist() end, desc = 'Location List', },
      { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks', },
      { '<leader>sM', function() Snacks.picker.man() end, desc = 'Man Pages', },
      { '<leader>sp', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec', },
      { '<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List', },
      { '<leader>sR', function() Snacks.picker.resume() end, desc = 'Resume', },
      { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo History', },
      { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes', },
      -- LSP
      { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition', },
      { 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Goto Declaration', },
      { 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References', },
      { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation', },
      { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition', },
      { '<leader>ss', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols', },
      { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols', },
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
          Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
          Snacks.toggle.diagnostics():map '<leader>ud'
          Snacks.toggle.line_number():map '<leader>ul'
          Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
          Snacks.toggle.treesitter():map '<leader>uT'
          Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
          Snacks.toggle.inlay_hints():map '<leader>uh'
          Snacks.toggle.indent():map '<leader>ug'
          Snacks.toggle.dim():map '<leader>td'
        end,
      })
    end,
  },
}
