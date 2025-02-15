-- luacheck: ignore 113 -- ignores undefined vim var
-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>gs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>gr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        -- map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'git stage hunk' })
        -- map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'git reset hunk' })
        -- map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'git Stage buffer' })
        -- map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'git undo stage hunk' })
        -- map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'git Reset buffer' })
        -- map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'git preview hunk' })
        -- map('n', '<leader>gb', gitsigns.blame_line, { desc = 'git blame line' })
        -- map('n', '<leader>gd', gitsigns.diffthis, { desc = 'git diff against index' })
        map('n', '<leader>gh', gitsigns.preview_hunk_inline, { desc = 'Git show Deleted' })
        map('n', '<leader>gD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git Diff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle git show blame line' })
      end,
    },
  },
}
