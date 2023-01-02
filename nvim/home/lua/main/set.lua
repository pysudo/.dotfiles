vim.opt.compatible = false

vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/.nvim/undodir"
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber   = true
vim.opt.wrap = false
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.wildmenu = true
-- vim.opt.wildmode=list:longest = true
vim.opt.scrolloff = 8

vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

vim.opt.expandtab = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2


-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
if (vim.fn.has("nvim-0.5.0") == 1 or vim.fn.has("patch-8.1.1564") == 1) then
  -- Recently vim can merge signcolumn and number column into one
  vim.opt.signcolumn = "number"
else
  vim.opt.signcolumn = "yes"
end

