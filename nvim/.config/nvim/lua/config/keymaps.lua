vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "D", "d$")
vim.keymap.set("n", "C", "c$")
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "H", "^")
vim.keymap.set("o", "H", "^")
vim.keymap.set("x", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("o", "L", "$")
vim.keymap.set("x", "L", "$")

vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")

vim.keymap.set(
	"n",
	"<leader>.",
	"<cmd>:lua require('telescope.builtin').find_files({cwd = '~/dot', hidden = true})<cr>",
	{ desc = "Dot files" }
)

vim.keymap.set("n", "<leader>tx", "<cmd>:vsplit | term yarn test %<cr>", { desc = "Run test in split" })
vim.keymap.set("n", "<leader>tX", "<cmd>:vsplit | term yarn test:watch %<cr>", { desc = "Run test watch in split" })

vim.keymap.set("n", "qq", "<cmd>:q!<cr>", { desc = "Close" })
vim.keymap.set("n", "<leader>w", "<cmd>:w<cr>", { desc = "Save" })

vim.keymap.set("n", "tt", "<cmd>:vsplit | term<cr>", { desc = "Terminal" })
vim.keymap.set("n", "tb", "<cmd>:split | term<cr>", { desc = "Terminal bottom" })

vim.keymap.set("n", "<M-t>", ':exec &bg=="light" ? "set bg=dark" : "set bg=light"<CR>', { desc = "Toggle bg" })
