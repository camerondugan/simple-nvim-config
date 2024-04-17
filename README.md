# My Simple Neovim Config

## Goals

1. Fast editing, easy shortcuts for important commands used often.
1. Small size for simplicity in configuration
1. Adaptable by others

## Setup

This will move your current config to ~/.config/nvim.bak and will then install
this config in its place

```bash
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/camerondugan/simple-nvim-config.git ~/.config/nvim
```

## Programming Workflow

Warning: Do not press these keybindings all at once, press in order

- Find Directory: space z (launches telescope Zoxide)
- ^^Alternate^^: *Ctrl* z (also launches telescope Zoxide)
- Find File (current directory and not in .gitignore): space sf
- Copy/Paste/Delete/Rename files: space f (launches floating Neotree)

## Buffer Switching

### Harpoon

- Edit Harpoon List: control e
- Add current file to list: space a
- Jump to first file: control h
- Jump to second file: control j
- Jump to third file: control k
- Jump to fourth file: control l

### Telescope

- Switch to another open buffer: space space
