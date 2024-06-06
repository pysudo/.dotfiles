-- Full language server protocol.
return {
  "neovim/nvim-lspconfig",

  dependencies = {
    -- Package manager for LSP servers, DAP servers, linters, and formatters.
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Completion engine.
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",

    -- Extensible UI for Neovim notifications and LSP progress messages.
    "j-hui/fidget.nvim",

    -- Snippets.
    "L3MON4D3/LuaSnip",        -- Engine
    "saadparwaiz1/cmp_luasnip" -- Luasnip completion for nvim-cmp.
  },

  config = function()
    require("mason").setup()
    require("fidget").setup({})
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")

    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities())
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "bashls",
      },
      handlers = {
        -- Default failover.
        function(server_name)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities
          }
        end,

        -- For Specifics.
        -- Lua.
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "vim" },
                }
              }
            }
          }
        end,
      }
    })


    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    cmp.setup({
      -- General keybindings for the completion engine.
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),

      -- Completion configs for specified sources.
      sources = cmp.config.sources({
        -- Sources.
        { name = 'nvim_lsp' }, -- For LSP
        { name = 'luasnip' }   -- For snippets.
      })
    })

    -- `/` cmdline setup.
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'cmdline' }
      })
    })
  end
}
