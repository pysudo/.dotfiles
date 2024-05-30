-- Status/tabline for vim/nvim.
return {
  "vim-airline/vim-airline",

  config = function()
    vim.g["airline#extensions#tabline#enabled"] = 1
    vim.g["airline#extensions#tabline#left_alt_sep"] = "▶"
    vim.g["airline#extensions#tabline#formatter"] = "unique_tail"
  end

}
