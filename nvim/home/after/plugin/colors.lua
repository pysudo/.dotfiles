vim.cmd([[colorscheme gruvbox]])


function SootheMySights()
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

  vim.cmd([[highlight CursorColumn cterm=NONE ctermbg=239]])
  vim.cmd([[highlight CursorLine cterm=NONE ctermbg=235]])
  vim.cmd([[highlight ColorColumn ctermbg=lightgrey guibg=lightgrey]])
  vim.cmd([[highlight Conceal ctermbg=DarkBlue]])

  vim.cmd([[highlight Pmenu ctermfg=Black ctermbg=238]])
  vim.cmd([[highlight PmenuSel ctermfg=Grey ctermbg=Black]])
  vim.cmd([[highlight PmenuSbar ctermbg=Black]])
  vim.cmd([[highlight PmenuThumb ctermbg=DarkGrey]])
end


SootheMySights()

