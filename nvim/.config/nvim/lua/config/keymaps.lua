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
vim.keymap.set("n", "<leader>tx", "<cmd>:vsplit | term npm run test %<cr>", { desc = "Run test in split" })
vim.keymap.set("n", "<leader>tX", "<cmd>:vsplit | term npm run test:watch %<cr>", { desc = "Run test watch in split" })
vim.keymap.set("n", "qq", "<cmd>:q!<cr>", { desc = "Close" })
vim.keymap.set("n", "tt", "<cmd>:vsplit | term<cr>", { desc = "Terminal" })
vim.keymap.set("n", "tb", "<cmd>:split | term<cr>", { desc = "Terminal bottom" })
vim.keymap.set("n", "<M-t>", ':exec &bg=="light" ? "set bg=dark" : "set bg=light"<CR>', { desc = "Toggle bg" })

vim.keymap.set(
	{ "n", "x" },
	"<leader>k",
	"<cmd>:lua require('telescope.builtin').grep_string()<CR>",
	{ desc = "Search under cursor" }
)
vim.keymap.set(
	"v",
	"<leader>k",
	"y<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.getreg('\"') })<CR>",
	{ desc = "Search selection" }
)

vim.keymap.set(
	"n",
	"<leader>gf",
	"<cmd>:lua require('telescope.builtin').git_bcommits()<CR>",
	{ desc = "File commits" }
)

-- Function to encode URL
local function url_encode(str)
	return str:gsub("\n", " "):gsub("([^%w ])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
end

-- Function to perform the search
local function perform_search(search_term)
	search_term = url_encode(search_term)
	local url = "https://www.google.com/search?q=" .. search_term
	os.execute('open "' .. url .. '"')
end

-- Function for visual mode search
function _G.search_visual_selection()
	vim.cmd("normal! gvy")
	local search_term = vim.fn.getreg('"')
	perform_search(search_term)
end

-- Function for normal mode search (word under cursor)
function _G.search_word_under_cursor()
	local search_term = vim.fn.expand("<cword>")
	perform_search(search_term)
end

-- Set up keybindings
vim.keymap.set("v", "<leader>sg", ":<C-U>lua search_visual_selection()<CR>", { desc = "Search Google (visual)" })
vim.keymap.set("n", "<leader>sg", ":lua search_word_under_cursor()<CR>", { desc = "Search Google (normal)" })
