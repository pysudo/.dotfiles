-- Debug Adapter Protocol client implementation for Neovim and UI.
return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },

  config = function()
    local dap = require("dap")

    require("dap").adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        -- ≡ƒÆÇ Make sure to update this path to point to your installation
        args = { os.getenv('HOME') .. '/dev/microsoft/js-debug/src/dapDebugServer.js', "${port}" },
      }
    }


    for _, language in ipairs({ "typescript", "javascript" }) do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Current File (pwa-node)',
          cwd = "${workspaceFolder}", -- vim.fn.getcwd(),
          args = { '${file}' },
          sourceMaps = true,
          protocol = 'inspector',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Current File (Typescript)',
          cwd = "${workspaceFolder}",
          resolveSourceMapLocations = { "!**/node_modules/**" },
          runtimeArgs = { "-r", "ts-node/register" },
          program = function()
            local debug_current_file = vim.fn.input({
              prompt = "Wish to debug current file? Otherwise proceed debug main file from the project folder. (y/n): ",
              default = "y",
            })

            if debug_current_file == "y" then
              return "${file}"
            end


            local json = require('dkjson')
            local package_file = io.open(os.getenv("PWD") .. '/package.json', "r")

            if not package_file then
              print("\n")
              error(
                "File 'package.json' does not exists or verify your current working directory is your project root folder.")
            end
            local content = package_file:read "*a"
            package_file:close()
            local package_json = json.decode(content)

            if package_json["main"] == nil then
              print("\n")
              error("Property 'main' is not defined in the package.json file.")
            end

            local debug_file = os.getenv("PWD") .. "/" .. package_json["main"]
            if io.open(debug_file, "r") then
              return "${workspaceFolder}/" .. package_json["main"]
            end

            print("\n")
            error("The main file specified as a value for the 'main' property in package.json does not exist.")
          end,
          env = function()
            local node_env = vim.fn.input({
              prompt = "Enter the node environment you wish to debug in: ",
              default = "dev"
            })
            return { NODE_ENV = node_env }
          end
        },
      }
    end


    local dapui = require("dapui")
    require("dapui").setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end


    -- Remaps
    vim.keymap.set("n", "<leader>dd", "<cmd>lua require'dap'.continue()<CR>", { silent = true })
    vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.run_to_cursor()<CR>", { silent = true })
    vim.keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.terminate()<CR>", { silent = true })
    vim.keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { silent = true })
    vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { silent = true })
    vim.keymap.set("n", "<leader>dh", "<cmd>lua require'dap'.step_out()<CR>", { silent = true })
    vim.keymap.set("n", "<leader>b", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
    vim.keymap.set("n", "<leader>ba!", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
    vim.keymap.set("n", "<leader>B", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('breakpoint condition: '))<CR>",
      { silent = true })
    vim.keymap.set("n", "<leader>lp",
      "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('log point message: '))<CR>", { silent = true })
    vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", { silent = true })
  end
}
