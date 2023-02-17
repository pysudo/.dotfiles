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
local function isWSL()
  local output = vim.fn.systemlist "uname -r"
  return not not string.find(output[1], "[Mm]icrosoft")
end

if (isWSL()) then
  vim.keymap.set("v", "<leader>y", "y:new ~/.vimbuffer<CR>VGp:x<CR> | :!cat ~/.vimbuffer | clip.exe <CR><CR>")
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("r", ""))', ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("r", ""))',
    },
    cache_enabled = 0,
  }
end

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]])


-- Don't retain deleted text in the numbered register.
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- When overwritting, presist the copied text and remove the overwritten text.
vim.keymap.set("x", "<leader>P", [["_dP]])

-- Search and replace the text under the cursor.
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])


-- Search and replace the yanked text from the selected range.
-- -- TODO: Escape slashes because they are interpreted as part of the search-replace command.  --
vim.keymap.set("v", "<leader>s", [[:exe "'<,'>s/" . @0 . "/" . input("Enter replacement string: ") . "/g"<Home><Del><Del><Del><Del><Del><CR>]])

-- Make the current file an executable.
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Create buffer.
vim.keymap.set("n", "<leader>bb", ":enew<CR>")
vim.keymap.set("n", "<leader>bv", ":vnew<CR>") -- Vertical
vim.keymap.set("n", "<leader>bh", ":new<CR>") -- Horizontal
-- Write buffer to current directory.
vim.keymap.set("n", "<leader>bw", function ()
  local filename = vim.fn.input("Enter filename: ")
  vim.cmd(":write " .. filename)
end)

-- Delist buffer.
vim.keymap.set("n", "<leader>bd", function ()
  vim.cmd[[
    if &modified
      let errorMessage = "Buffer has been modified. "
      let errorMessage = errorMessage . "Use '<leader>bd!' to quit wihout saving"

      echohl ErrorMsg
      echomsg errorMessage
      echohl None
    else
      :bdelete!
    endif
  ]]
end)

vim.keymap.set("n", "<leader>bd!", ":bdelete!<CR>") -- Force without saving.

-- Delete buffer's file location.
local function deleteBuffer()
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)

  if not file then
    vim.cmd[[
      let errorMessage =  "File does not exist. "
      let errorMessage = errorMessage . "Use '<leader>bd' or '<leader>bd!'"
      let errorMessage = errorMessage . " to close current buffer."

      echohl ErrorMsg
      echomsg errorMessage
      echohl None
    ]]

    return
  end

  os.remove(file)
end

vim.keymap.set("n", "<leader>bDD", function ()
  deleteBuffer()
  print("File has been successfully deleted.")
end) -- Keep buffer.

vim.keymap.set("n", "<leader>bDD!", function ()
  deleteBuffer()
  vim.api.nvim_command("bdelete!")
end) -- Delist buffer.

-- Navigate through buffers.
vim.keymap.set("n", "H", ":bp<CR>")
vim.keymap.set("n", "L", ":bn<CR>")

-- Quick switch between buffer.
vim.keymap.set("n", "<leader><tab>", ":e #<CR>")

-- Remove the highlighting of the last searched pattern.
vim.keymap.set("n", "<leader>nh", ":noh<CR>")

-- Remove trailing and leading whitespaces.
function TrimTrails()
  vim.cmd[[:%s/\s\+$//g]]
end
function TrimLeads()
  vim.cmd[[:%s/^ *//g]]
end

