# My Simple Neovim Config

## Goals

1. Editing without being slowed down
1. Small size for simplicity in configuration
1. Easily adaptable by others

## Setup

This will move your current config to ~/.config/nvim.bak and will then install
this config in its place

```bash
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/camerondugan/simple-nvim-config.git ~/.config/nvim
```

## Programming Workflow

Warning: Do not press these keybindings all at once, press in order

- Find Directory: space z (launches telescope Zoxide list)
- Find File (current directory and not in .gitignore): space sf
- Copy/Paste/Delete/Rename many files: space f (launches floating Neotree)

## Buffer Switching

- Switch to another open buffer: space space

### Harpoon

- Edit Harpoon List: control e
- Add current file to list: space a
- Jump to first file: control h
- Jump to second file: control j
- Jump to third file: control k
- Jump to fourth file: control l

## Note-taking Workflow: (Neorg)

<https://github.com/nvim-neorg/neorg>

- Show Neorg index: , n i (runs :Neorg index)
