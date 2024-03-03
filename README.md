# My Incredibly Simple Neovim Config

## Goals:
1. Editing without being slowed down
1. Small size for simplicity in configuration
1. Easily adaptable by others

## Setup:

This will move your current config to ~/.config/nvim.bak and will then install this config in its place

```bash
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/camerondugan/simple-nvim-config.git ~/.config/nvim
```

Warning: Do not press these keybindings all at once, press in order (not necessary to release before next key)

## Programming Workflow:

* Find Directory (auto opens file search): space sd (launches telescope zoxide list, then file picker)
* Find File (current directory): space sf (launches telescope for files)
* Copy/Paste/Delete/Rename many files: space f (launches floating neotree)

## Note-taking Workflow: (Neorg)

(https://github.com/nvim-neorg/neorg)[https://github.com/nvim-neorg/neorg]

* Show Neorg index: space n enter (runs :Neorg command then selects index)

## Buffer Switching:

* Telescope buffers: space space

### Harpoon:

* Edit Harpoon List: control e
* Add current file to list: space a

* Jump to first file: control h
* Jump to second file: control j
* Jump to third file: control k
* Jump to fourth file: control l
