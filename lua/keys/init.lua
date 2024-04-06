-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous Diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next Diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Error messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Quickfix list' })

-- Terminal Better Exit
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n><cmd>ToggleTerm<CR>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- TIP: Disable insert-mode CTRL+w to not get stuck closing browser tabs later
vim.keymap.set('i', '<C-w>', function()
  vim.notify('Use ctrl-backspace a.k.a. <C-BS>', vim.log.levels.INFO, nil)
end, { desc = 'No More Closing Browser Tabs by accident' })
vim.keymap.set('i', '<C-BS>', '<C-w>', { desc = 'No More Closing Browser Tabs by accident' })
vim.keymap.set('i', '<C-h>', '<C-w>', { desc = 'No More Closing Browser Tabs by accident' })
vim.keymap.set('i', '<M-BS>', '<C-w>', { desc = 'No More Closing Browser Tabs by accident' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<M-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<M-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<M-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<M-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Keybindings for plugins
vim.keymap.set('n', '<leader>gg', '<cmd>LazyGitCurrentFile<CR>', { desc = 'LazyGitCurrentFile' })
