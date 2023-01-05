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

vim.keymap.set("n", "<leader>b", "<cmd>:ToggleTerm direction=horizontal<cr>")
vim.keymap.set("n", "<leader>v", "<cmd>:ToggleTerm direction=vertical<cr>")

vim.keymap.set("n", "tf", "<cmd>:TestFile<cr>")
vim.keymap.set("n", "tl", "<cmd>:TestLast<cr>")
vim.keymap.set("n", "tn", "<cmd>:TestNearest<cr>")
vim.keymap.set("n", "tw", "<cmd>:TestNearest --watch<cr>")
vim.keymap.set("n", "ts", "<cmd>:TestSuite<cr>")

vim.keymap.set("n", "<leader>nn", "<cmd>:lua require('neotest').run.run()<cr>")
vim.keymap.set("n", "<leader>nf", "<cmd>:lua require('neotest').run.run(vim.fn.expand('%'))<cr>")
vim.keymap.set("n", "<leader>nd", "<cmd>:lua require('neotest').run.run({strategy = 'dap'})<cr>")
vim.keymap.set("n", "<leader>nx", "<cmd>:lua require('neotest').run.stop()<cr>")
vim.keymap.set("n", "<leader>na", "<cmd>:lua require('neotest').run.attach()<cr>")
vim.keymap.set("n", "<leader>no", "<cmd>:lua require('neotest').output.open({enter = true})<cr>")
vim.keymap.set("n", "<leader>ns", "<cmd>:lua require('neotest').summary.toggle()<cr>")

vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
