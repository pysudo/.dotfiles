local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
end)

require("ibl").setup {
  whitespace = {
    remove_blankline_trail = false,
  },
  scope = {
    show_start = false,
    show_end = false,
    highlight = "RainbowViolet"
  },
}

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

