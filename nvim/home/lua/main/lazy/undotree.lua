-- Browse undo history and switch between different undo branches.
return {
  "mbbill/undotree",

  config = function()
    vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")
  end
}
