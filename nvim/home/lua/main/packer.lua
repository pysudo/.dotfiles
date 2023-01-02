-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim"

  -- Full language server protocol. (Also works for vim).
  use {
    "neoclide/coc.nvim",
    branch = "release"
  }

  -- Mappings to easily delete, change and add \"surroundings\-- in pairs.
  use "tpope/vim-surround"

  -- A multi language graphical debugger for Vim.
  use "puremourning/vimspector"

  -- A dark Vim/Neovim color scheme.
  use "morhetz/gruvbox"
  vim.g.gruvbox_contrast_dark = "hard"

  -- Status/tabline for vim/nvim.
  use "vim-airline/vim-airline"

  -- A file system explorer.
  use "scrooloose/nerdtree"

  -- Enables NERDTree to open, delete, move, or copy multiple files at once.
  use "PhilRunninger/nerdtree-visual-selection"

  -- A plugin of NERDTree showing git status flags.
  use "Xuyuanp/nerdtree-git-plugin"
  vim.g.NERDTreeGitStatusShowClean = 1

  -- A snippets manager for vim.
  use "SirVer/ultisnips"
  -- If you want :UltiSnipsEdit to split your window.
  vim.g.UltiSnipsEditSplit = "vertical"

  -- Repository containing snippets files for various programming languages.
  use "honza/vim-snippets"

  -- Browse undo history and switch between different undo branches.
  use "mbbill/undotree"

  -- Vim plugin for Git.
  use "tpope/vim-fugitive"

  -- (Do)cumentation (Ge)nerator which will generate a proper documentation.
  use 'kkoomen/vim-doge'

  -- Debug Adapter Protocol client implementation for Neovim
  use "mfussenegger/nvim-dap"
end)
