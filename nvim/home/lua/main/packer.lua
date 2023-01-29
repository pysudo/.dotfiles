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

  -- Repository containing snippets files for various programming languages.
  use "honza/vim-snippets"

  -- Browse undo history and switch between different undo branches.
  use "mbbill/undotree"

  -- Vim plugin for Git.
  use "tpope/vim-fugitive"

  -- (Do)cumentation (Ge)nerator which will generate a proper documentation.
  use 'kkoomen/vim-doge'

  -- Debug Adapter Protocol client implementation for Neovim.
  use "mfussenegger/nvim-dap"

  use {
    -- Highly extendable fuzzy finder over lists.
    "nvim-telescope/telescope.nvim", tag = "0.1.0",
    -- or                            , branch = "0.1.x",
    requires = { {"nvim-lua/plenary.nvim"} }
  }

  -- Quick switch to differnt files.
  use("theprimeagen/harpoon")

  -- Parser tool for efficient syntax tree for neovim.
  use("nvim-treesitter/nvim-treesitter", {run = ":TSUpdate"})

  -- Enhances netrw.
  use("tpope/vim-vinegar")
end)
