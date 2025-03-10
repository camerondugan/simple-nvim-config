-- luacheck: ignore 113 -- ignores undefined vim var
-- make vim load lua modules faster
vim.loader.enable()
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Set to false if you don't have
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Syntax
vim.opt.syntax = 'on'

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Confirm on :q and :e instead of not allowing
vim.opt.confirm = true

-- Enable break indent
vim.opt.breakindent = true

-- Enable Spell Check
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

-- Enable wrap by word
vim.opt.linebreak = true

-- Disable wrap by default
vim.opt.wrap = false

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how Neovim will display certain white-space in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '| ', trail = '·', nbsp = '␣' }

-- Tab size options
vim.opt.tabstop = 4 -- max tab size
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- Set <C-d> and <C-u> jump distance to half screen again
vim.opt.scroll = 0

-- Plugin Options
vim.opt.termguicolors = true

-- Sets text width
vim.opt.textwidth = 80

-- Conceal some text (mainly for orgmode)
vim.opt.conceallevel = 2

-- GUI font
vim.opt.guifont = 'JetBrainsMono\\ Nerd\\ Font:h11'

-- Show source of diagnostics
vim.diagnostic.config {
  virtual_text = {
    format = function(diagnostic)
      local first_line = diagnostic.message:gmatch("[^\n]*")()
      local first_sentence = string.match(first_line, "(.-%.)") or first_line
      local first_lhs = string.match(first_sentence, "(.-): ")
      -- first_sentence = string.sub(first_sentence, 1, 45).."..."
      return first_lhs or first_sentence
    end
  },
  update_in_insert = false,
  float = {
    border = 'rounded',
    source = true,
  },
}

vim.cmd.colorscheme "habamax"
