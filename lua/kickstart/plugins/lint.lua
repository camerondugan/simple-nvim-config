-- luacheck: ignore 113 -- ignores undefined vim var
return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Specify linters_by_ft
      lint.linters_by_ft = lint.linters_by_ft or {}
      lint.linters_by_ft['html'] = { 'htmlhint' }
      lint.linters_by_ft['markdown'] = { 'markdownlint', 'write_good', 'proselint' }
      lint.linters_by_ft['text'] = { 'write_good', 'proselint' }
      lint.linters_by_ft['org'] = { 'write_good', 'proselint' }
      lint.linters_by_ft['python'] = { 'pylint' }
      lint.linters_by_ft['go'] = { 'golangcilint' }
      lint.linters_by_ft['javascript'] = { 'quick-lint-js' }
      lint.linters_by_ft['yaml'] = { 'yamllint' }
      lint.linters_by_ft['json'] = { 'jsonlint' }
      lint.linters_by_ft['sh'] = { 'shellcheck' }
      lint.linters_by_ft['nix'] = { 'nix' }
      lint.linters_by_ft['dockerfile'] = { 'hadolint' }
      lint.linters_by_ft['lua'] = { 'luacheck' }

      -- Create auto command which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
