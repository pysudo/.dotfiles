-- Config
local dap = require('dap')
dap.adapters.node = {
  type = 'executable',
  command = 'node',
  -- Install vscode-node-debug2 on the specified path.
  args = {os.getenv('HOME') .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
}
dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}

-- Remaps
vim.keymap.set("n", "<f5>", "<cmd>lua require'dap'.continue()<CR>",  { silent = true }) 
vim.keymap.set("n", "<f10>", "<cmd>lua require'dap'.step_over()<CR>",  { silent = true }) 
vim.keymap.set("n", "<f11>", "<cmd>lua require'dap'.step_into()<CR>",  { silent = true }) 
vim.keymap.set("n", "<f12>", "<cmd>lua require'dap'.step_out()<CR>",  { silent = true }) 
vim.keymap.set("n", "<leader>b", "<cmd>lua require'dap'.toggle_breakpoint()<CR>",  { silent = true }) 
vim.keymap.set("n", "<leader>B", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('breakpoint condition: '))<CR>",  { silent = true }) 
vim.keymap.set("n", "<leader>lp", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('log point message: '))<CR>",  { silent = true }) 
vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>",  { silent = true }) 
vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>",  { silent = true })
