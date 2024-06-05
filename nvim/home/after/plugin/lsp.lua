local autocmd = vim.api.nvim_create_autocmd

autocmd('LspAttach', {
  callback = function(e)
    local opts = { buffer = e.buf, remap = false }

    -- GoTo code navigation.
    vim.keymap.set('n', "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', "gy", function() vim.lsp.buf.type_definition() end, opts)
    vim.keymap.set('n', "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set('n', "gr", function() vim.lsp.buf.references() end, opts)

    -- Use K to show documentation in preview window.
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)

    -- Formatting selected code.
    vim.keymap.set({ 'n', 'v' }, "<leader>f", function() vim.lsp.buf.format() end, opts)

    -- Symbol renaming.
    vim.keymap.set('n', "<leader>rn", function() vim.lsp.buf.rename() end, opts)

    vim.keymap.set('n', "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set('n', "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('i', "<C-h>", function() vim.lsp.buf.signature_help() end, opts)


    -- Code Actions
    -- Display pending actions list in the current line.
    vim.keymap.set('n', "ca", function() vim.lsp.buf.code_action() end, opts)

    -- Apply AutoFix to problem on the current line.
    vim.keymap.set('n', "qf", function()
      vim.lsp.buf.code_action({
        filter = function(a) return a.isPreferred end,
        apply = true
      })
    end, opts)
  end
})

vim.api.nvim_create_augroup("SymbolHighlightOnHover", {});
autocmd({ "CursorHold", "CursorHoldI" }, {
  group = "SymbolHighlightOnHover",
  command = "lua vim.lsp.buf.document_highlight()",
  desc = "Highlight symbol under cursor"
})

autocmd({ "CursorMoved", "CursorMovedI" }, {
  group = "SymbolHighlightOnHover",
  command = "lua vim.lsp.buf.clear_references()",
  desc = "Remove highlights for all symbol after the cursor moves."
})
