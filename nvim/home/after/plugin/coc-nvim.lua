-- Automaticaly install basic LSPs.
vim.g.coc_global_extensions = {"coc-sh", "coc-lua"}

-- GoTo code navigation.
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true }) 
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true }) 
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true }) 
vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true }) 

-- Use K to show documentation in preview window.
function ShowDocumentation()
  if vim.fn.CocAction('hasProvider', 'hover') then
    vim.fn.CocActionAsync('doHover')
  else
    vim.fn.feedkeys('K', 'in')
  end
end
vim.keymap.set("n", "K", "<cmd>lua ShowDocumentation()<CR>", { silent = true }) 

-- Use <c-space> to trigger completion.
vim.keymap.set("i", "<expr><C-space>", "coc#refresh()", { silent = true }) 

-- Symbol renaming.
vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)") 

-- Formatting selected code.
vim.keymap.set({"x", "n"}, "<leader>f", "<Plug>(coc-format-selected)") 

-- Applying codeAction to the selected region.
-- Example: `<leader>aap` for current paragraph
vim.keymap.set({"x", "n"}, "<leader>a", "<Plug>(coc-codeaction-selected)") 

-- Rvim.keymap.set("e", "keys for applying codeAction to the current", "buffer.") 
vim.keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction)") 
-- Apply AutoFix to problem on the current line.
vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)") 

-- Run the Code Lens action on the current line.
vim.keymap.set("n", "<leader>cl", "<Plug>(coc-codelens-action)")
