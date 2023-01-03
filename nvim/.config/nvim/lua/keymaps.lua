--Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Out
vim.keymap.set("n", "<ESC><ESC>", ":q!<cr>")
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")
vim.keymap.set("", "<ESC>", ":noh<cr>")

vim.keymap.set({ "n", "x" }, "<leader>sr", function()
	require("ssr").open()
end)

-- Move to window using the <ctrl> movement keys
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w><C-h>")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w><C-j>")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w><C-k>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w><C-l>")

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", ":resize +2<cr>")
vim.keymap.set("n", "<C-Down>", ":resize -2<cr>")
vim.keymap.set("n", "<C-Left>", ":vertical resize +2<cr>")
vim.keymap.set("n", "<C-Right>", ":vertical resize -2<cr>")

-- Move Lines up and down
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==")
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<cr>==gi")
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==")
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv")
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<cr>==gi")

-- Easy go to start and end of line
vim.keymap.set("n", "H", "^")
vim.keymap.set("o", "H", "^")
vim.keymap.set("x", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("o", "L", "$")
vim.keymap.set("x", "L", "$")

-- Nice defaults
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "D", "d$")
vim.keymap.set("n", "C", "c$")
vim.keymap.set("n", ";", ":")

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- tree
vim.keymap.set("n", "<leader>e", "<cmd>:Neotree position=left focus toggle<cr>")

vim.keymap.set("n", "<leader>s", "<cmd>:lua require('spectre').open()<cr>")
vim.keymap.set("n", "<leader>o", "<cmd>:Telescope oldfiles hidden=true<cr>")
vim.keymap.set("n", "<leader>p", "<cmd>:Telescope find_files hidden=true<cr>")
vim.keymap.set("n", "<leader>f", "<cmd>:Telescope live_grep<cr>")
vim.keymap.set("n", "<leader><leader>", "<cmd>:Telescope file_browser hidden=true<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>:q<cr>") -- exit
vim.keymap.set("n", "<leader>w", "<cmd>:w<cr>") -- exit
vim.keymap.set("n", "<leader>x", "<cmd>:TroubleToggle<cr>") -- project diagnostics

vim.keymap.set("n", "<leader>d", "<cmd>:e ~/.config/nvim/init.lua<cr>")
vim.keymap.set(
	"n",
	"<leader>.",
	"<cmd>:lua require('telescope.builtin').find_files({cwd = '~/dot', hidden = true})<cr>"
)

vim.keymap.set("n", "<leader>m", "<cmd>:lua require('telescope.builtin').find_files({cwd = '~/notes'})<cr>")
vim.keymap.set("n", "<leader>M", "<cmd>:e ~/notes/<cr>")
vim.keymap.set("n", "<leader>/", "<cmd>:Telescope current_buffer_fuzzy_find<cr>")

vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>")
vim.keymap.set("n", "gb", "<cmd>:Gitsigns blame_line<cr>")
vim.keymap.set("n", "gp", "<cmd>:Gitsigns preview_hunk<cr>")
vim.keymap.set("n", "<leader>d", "<cmd>:DiffviewOpen<cr>")

vim.keymap.set("n", "<leader>ha", "<cmd>:lua require('harpoon.mark').add_file()<cr>")
vim.keymap.set("n", "<leader>hm", "<cmd>:lua require('harpoon.ui').toggle_quick_menu()<cr>")
vim.keymap.set("n", "<leader>ho", "<cmd>:lua require('harpoon.ui').nav_prev()<cr>")
vim.keymap.set("n", "<leader>hi", "<cmd>:lua require('harpoon.ui').nav_next()<cr>")
vim.keymap.set("n", "<leader>hh", "<cmd>:Telescope harpoon marks hidden=true<cr>")

vim.keymap.set("n", "<leader>t", "<cmd>:ToggleTerm direction=float<cr>")
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

vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

vim.keymap.set("n", "<leader>gg", function()
	require("lazy.util").open_cmd({ "lazygit" }, {
		terminal = true,
		close_on_exit = true,
		enter = true,
		float = {
			size = { width = 0.9, height = 0.9 },
			margin = { top = 0, right = 0, bottom = 0, left = 0 },
		},
	})
end, { desc = "Lazygit" })
