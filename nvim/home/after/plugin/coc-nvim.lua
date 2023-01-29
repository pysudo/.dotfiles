-- Automaticaly install basic LSPs.
vim.g.coc_global_extensions = {"coc-sh", "coc-lua", "coc-snippets"}

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
vim.keymap.set("i", "<C-space>", "coc#refresh()", { silent = true, expr = true })

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


-- Snippets
-- Trigger snippet expand.
vim.keymap.set("i", "<C-l>", "<Plug>(coc-snippets-expand)")

-- Select text for visual placeholder of snippet.
vim.keymap.set("v", "<C-j>", "<Plug>(coc-snippets-select)")

-- Jump to next placeholder.
vim.g.coc_snippet_next = "<C-j>"

-- Jump to previous placeholder.
vim.g.coc_snippet_prev = "<C-k>"

-- Use <C-j> for both expand and jump (make expand higher priority.)
vim.keymap.set("i", "<C-j>", "<Plug>(coc-snippets-expand-jump)")
