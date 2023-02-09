local builtin = require("telescope.builtin")
local themes = require("telescope.themes")


local function dropDownPicker(picker, opts)
  opts = opts or {}
  picker(themes.get_dropdown(opts))
end


vim.keymap.set("n", "<leader>pp", function() dropDownPicker(builtin.builtin) end)
vim.keymap.set("n", "<leader>pf", function() dropDownPicker(builtin.find_files) end)
vim.keymap.set("n", "<leader>pg", function() dropDownPicker(builtin.git_files) end)
vim.keymap.set("n", "<leader>pb", function() dropDownPicker(builtin.buffers) end)
vim.keymap.set("n", "<leader>p:", function() dropDownPicker(builtin.commands) end)
vim.keymap.set("n", "<leader>p::", function() dropDownPicker(builtin.command_history) end)
vim.keymap.set("n", "<leader>p/", function() dropDownPicker(builtin.search_history) end)
vim.keymap.set("n", "<leader>ps", function() dropDownPicker(builtin.grep_string, { search = vim.fn.input("Grep > ") }) end)
vim.keymap.set("n", "<leader>pss", function() dropDownPicker(builtin.live_grep) end)

