-- keymaps

-- Nice defaults
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "D", "d$")
vim.keymap.set("n", "C", "c$")
vim.keymap.set("n", ";", ":")

-- Easy go to start and end of line
vim.keymap.set("n", "H", "^")
vim.keymap.set("o", "H", "^")
vim.keymap.set("x", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("o", "L", "$")
vim.keymap.set("x", "L", "$")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set(
	"n",
	"<leader>.",
	"<cmd>:lua require('telescope.builtin').find_files({cwd = '~/dot', hidden = true})<cr>",
	{ desc = "Dot files" }
)

vim.keymap.set(
	"n",
	"<leader>n",
	"<cmd>:lua require('telescope.builtin').find_files({cwd = '~/notes'})<cr>",
	{ desc = "Find notes" }
)
vim.keymap.set("n", "<leader>M", "<cmd>:e ~/notes/<cr>", { desc = "Create note" })

vim.keymap.set("n", "<leader>ma", ":lua require('harpoon.mark').add_file()<cr>", { desc = "Mark file" })
vim.keymap.set("n", "<leader>mm", ":lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = "View project marks" })
vim.keymap.set("n", "<leader>mn", ":lua require('harpoon.ui').nav_next()<cr>", { desc = "Next mark" })
vim.keymap.set("n", "<leader>mp", ":lua require('harpoon.ui').nav_prev()<cr>", { desc = "Previous mark" })

-- harpoon tmux
vim.keymap.set(
	"n",
	"<leader>mt",
	":lua require('harpoon.tmux').gotoTerminal('{right}')<cr>",
	{ desc = "Go to terminal" }
)
