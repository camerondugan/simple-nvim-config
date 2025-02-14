-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>')

-- Save file faster
vim.keymap.set({'n','i'}, '<C-s>', '<cmd>w<cr>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous Diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next Diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Error messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Quickfix list' })

vim.keymap.set('i', '<C-BS>', '<C-w>', { desc = 'No More Closing Browser Tabs by accident' })
vim.keymap.set('i', '<C-h>', '<C-w>',  { desc = 'No More Closing Browser Tabs by accident' })
vim.keymap.set('i', '<M-BS>', '<C-w>', { desc = 'No More Closing Browser Tabs by accident' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Keybindings for plugins
vim.keymap.set('n', '<leader>gg', '<cmd>LazyGitCurrentFile<cr>', { desc = 'LazyGitCurrentFile' })
