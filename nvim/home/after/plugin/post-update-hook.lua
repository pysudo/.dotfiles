vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- kkoomen/vim-doge
    vim.cmd[[silent! call doge#install()]]
  end
})
