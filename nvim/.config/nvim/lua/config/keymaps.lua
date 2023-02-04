-- keymaps

vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })

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

vim.keymap.set(
	"n",
	"<leader>.",
	"<cmd>:lua require('telescope.builtin').find_files({cwd = '~/dot', hidden = true})<cr>"
)
vim.keymap.set("n", "<leader>m", "<cmd>:lua require('telescope.builtin').find_files({cwd = '~/notes'})<cr>")
vim.keymap.set("n", "<leader>M", "<cmd>:e ~/notes/<cr>")
vim.keymap.set("n", "<leader>d", "<cmd>:DiffviewOpen<cr>")

vim.keymap.set("n", "<leader>ha", "<cmd>:lua require('harpoon.mark').add_file()<cr>")
vim.keymap.set("n", "<leader>hm", "<cmd>:lua require('harpoon.ui').toggle_quick_menu()<cr>")
vim.keymap.set("n", "<leader>ho", "<cmd>:lua require('harpoon.ui').nav_prev()<cr>")
vim.keymap.set("n", "<leader>hi", "<cmd>:lua require('harpoon.ui').nav_next()<cr>")

vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

vim.keymap.set("n", "<leader>b", "<cmd>:split | term<cr>")
vim.keymap.set("n", "<leader>v", "<cmd>:vsplit | term<cr>")
