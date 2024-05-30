return {
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",

    dependencies = { "rafamadriz/friendly-snippets", "honza/vim-snippets" },

    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load()

      local ls = require("luasnip")
      vim.keymap.set({ "i" }, "<C-y>", function() ls.expand() end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-n>", function() ls.jump(1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-p>", function() ls.jump(-1) end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })
    end
  }
}
