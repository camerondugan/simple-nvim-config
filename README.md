# My Simple Neovim Config

This config is a fork of nvim/kickstart. If you are brand new and want to learn,
go there. If you don't wish to learn, read this README, follow the setup steps,
and install specific language support with :Mason.

## Goals

1. Fast editing, easy shortcuts for important commands used often.
1. Small size for simplicity in configuration
1. Easily adaptable for other people

## Setup

This will move your current config to ~/.config/nvim.bak and will then install
this config in its place

```bash
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/camerondugan/simple-nvim-config.git ~/.config/nvim
```

## Programming Workflow

Warning: Do not press these keybindings all at once, press in order

\<leader\> = space bar

- Manage Files (Oil.nvim): -
- Find File (current directory and not in .gitignore): \<leader\> s f
- Find In File (requires ripgrep to be installed): \<leader\> s g
- Debugging (Trouble.nvim): \<leader\> x x

## Buffer Switching

### Harpoon2

My config adds buffers you visit to the harpoon list when it isn't full

- Edit Harpoon List: control e
- Add current file to list: \<leader\> a
- Jump to first file: control h
- Jump to second file: control j
- Jump to third file: control k
- Jump to fourth file: control l

### Telescope

- Search for another open buffer: \<leader\> \<leader\>
- See configured telescope shortcuts: \<leader\> s
- Search all telescope shortcuts: \<leader\> s t
