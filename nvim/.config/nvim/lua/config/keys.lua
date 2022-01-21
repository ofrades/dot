local wk = require("which-key")
local presets = require("which-key.plugins.presets")

local map = function(mode, key, cmd, opts, defaults)
	opts = vim.tbl_deep_extend("force", { silent = true }, defaults or {}, opts or {})

	if type(cmd) == "function" then
		table.insert(M.functions, cmd)
		if opts.expr then
			cmd = ([[luaeval('require("util").execute(%d)')]]):format(#M.functions)
		else
			cmd = ("<cmd>lua require('util').execute(%d)<cr>"):format(#M.functions)
		end
	end
	if opts.buffer ~= nil then
		local buffer = opts.buffer
		opts.buffer = nil
		return vim.api.nvim_buf_set_keymap(buffer, mode, key, cmd, opts)
	else
		return vim.api.nvim_set_keymap(mode, key, cmd, opts)
	end
end

presets.objects["a("] = nil
wk.setup({
	show_help = false,
	triggers = "auto",
	plugins = { spelling = true },
	key_labels = { ["<leader>"] = "SPC" },
})

-- util.nnoremap("zz", ":Z ")
-- Move to window using the <ctrl> movement keys
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("n", "<ESC><ESC>", ":q!<cr>")

map("i", "jj", "<ESC>", { noremap = true })
map("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
map("t", "<jj>", "<C-\\><C-n>", { noremap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<Up>", ":resize +2<CR>", { noremap = true })
map("n", "<Down>", ":resize -2<CR>", { noremap = true })
map("n", "<Left>", ":vertical resize +2<CR>", { noremap = true })
map("n", "<Right>", ":vertical resize -2<CR>", { noremap = true })

-- terminal
map("n", "<C-\\>", ":ToggleTerm<CR>", { noremap = true })

-- Move Lines
map("n", "<A-j>", ":m .+1<CR>==", { noremap = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true })
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { noremap = true })
map("n", "<A-k>", ":m .-2<CR>==", { noremap = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { noremap = true })

-- Easier pasting
map("n", "[p", ":pu!<cr>")
map("n", "]p", ":pu<cr>")

-- Clear search with <esc>
map("", "<esc>", ":noh<cr>")
map("n", "gw", "*N")
map("x", "gw", "*N")

-- Easy start and end of line
map("n", "H", "^", { noremap = true })
map("o", "H", "^", { noremap = true })
map("x", "H", "^", { noremap = true })
map("n", "L", "$", { noremap = true })
map("o", "L", "$", { noremap = true })
map("x", "L", "$", { noremap = true })

map("n", "<leader>-", ":set background=light<cr>", { noremap = true })
map("n", "<leader>=", ":set background=dark<cr>", { noremap = true })

map("n", "f", ":HopWord<cr>", { noremap = true })
map("n", ";", ":", { noremap = true })

-- Nice defaults
map("n", "Y", "y$", { noremap = true })
map("n", "D", "d$", { noremap = true })
map("n", "C", "c$", { noremap = true })
map("n", "<C-a>", "ggVG", { noremap = true })

-- file tree
map("n", "<space><space>", "<cmd>:NvimTreeToggle<cr>", { noremap = true })

-- jest nearest
map("n", "<C-t>", "<cmd>:lua require'config.jest'.run()<cr>", { noremap = true })

-- better indenting
map("v", "<", "<gv", { noremap = true })
map("v", ">", ">gv", { noremap = true })

local leader = {
	b = { "<cmd>:Telescope buffers<cr>", "Buffers" },
	c = { "<cmd>Telescope commands<cr>", "Commands" },
	d = { "<cmd>lua require 'telescope'.extensions.file_browser.file_browser({ path = '~/dev/' })<CR>", "Dev" },
	e = { "<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>", "File Browser" },
	f = { "<cmd>Telescope live_grep<cr>", "Find Text" },
	g = { "<cmd>:LazyGit<cr>", "Lazygit" },
	n = { "<cmd>enew<cr>", "New File" },
	o = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
	p = { "<cmd>Telescope find_files<cr>", "Find Files" },
	q = { "<cmd>:q<cr>", "Quit" },
	r = { "<cmd>Telescope repo list<cr>", "Repos" },
	s = {
		name = "+search",
		c = { "<cmd>viw:lua require('spectre').open_file_search()<CR>", "Search selected" },
		f = { "<cmd>Telescope grep_string<cr>", "Find string under cursor" },
		s = { "<cmd>:lua require('spectre').open()<CR>", "Search" },
		v = { "<cmd>:lua require('spectre').open_visual()<CR>", "Search selected" },
		w = { "<cmd>:lua require('spectre').open_visual({select_word=true})<CR>", "Search word under cursor" },
	},
	S = { "<cmd>:PackerSync<cr>", "Packer Sync" },
	t = {
		name = "+term/test",
		b = { "<cmd>:split | term<cr>", "Bottom terminal" },
		c = { ":vsplit | term code . %<CR>:q<CR>:echo '-> VSCODE'<CR>", "Open in vscode" },
		f = { "<cmd>:TestFile<cr>", "Test File" },
		n = { "<cmd>:TestNearest<cr>", "Test Nearest" },
		t = { "<cmd>:term<cr>", "Terminal" },
		v = { "<cmd>:vsplit | term<cr>", "Side terminal" },
	},
	x = { "<cmd>TroubleToggle<cr>", "Trouble" },
	w = { "<cmd>:w<cr>", "Save" },
	z = { "<cmd>lua require 'telescope'.extensions.file_browser.file_browser({ path = '~/notes' })<CR>", "Notes" },
}

for i = 0, 10 do
	leader[tostring(i)] = "which_key_ignore"
end

wk.register(leader, { prefix = "<leader>" })
