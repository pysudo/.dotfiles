vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", ":Ex<CR>") 

-- Move higlighted lines.
vim.keymap.set("v", "J", ":m'>+1<CR>gv=gv") 
vim.keymap.set("v", "K", ":m'<-2<CR>gv=gv") 

-- Cursor at the beginning when previous line is appended to the current line.
vim.keymap.set("n", "J", "mzJ`z") 

-- Keep the cursor in the middle when half scrolling or while searching.
vim.keymap.set("n", "<C-d>", "<C-d>zz") 
vim.keymap.set("n", "<C-u>", "<C-u>zz") 
vim.keymap.set("n", "n", "nzzzv") 
vim.keymap.set("n", "N", "Nzzzv") 

-- Copy text to system clipboard.
function isWSL()
  local output = vim.fn.systemlist "uname -r" 
  return not not string.find(output[1], "[Mm]icrosoft")
end

if (isWSL()) then
  -- Copy (write) highlighted text to .vimbuffer
  vim.keymap.set("v", "<leader>y", "y:new ~/.vimbuffer<CR>VGp:x<CR> | :!cat ~/.vimbuffer | clip.exe <CR><CR>") 
else
  vim.keymap.set({"n", "v"}, "<leader>y", [["+y]]) 
  vim.keymap.set("n", "<leader>Y", [["+Y]]) 
end

-- Don't retain deleted text in the numbered register.
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]]) 

-- When overwritting, presist the copied text and remove the overwritten text.
vim.keymap.set("x", "<leader>p", [["_dP]]) 

-- Search and replace the text under the cursor.
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) 

-- Make the current file an executable.
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Navigate through buffers.
vim.keymap.set("n", "H", ":bp<CR>")
vim.keymap.set("n", "L", ":bn<CR>")

-- Quick switch between buffer.
vim.keymap.set("n", "<leader><tab>", ":e #<CR>")

