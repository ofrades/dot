local wk = require("which-key")
local presets = require("which-key.plugins.presets")

presets.objects["a("] = nil

wk.setup({
	show_help = false,
	triggers = "auto",
	plugins = { spelling = true },
	key_labels = { ["<leader>"] = "SPC" },
})

local leader = {
	v = { "<cmd>:vertical Ttoggle<cr>", "Terminal side" },
	b = { "<cmd>:botright Ttoggle<cr>", "Terminal bottom" },
	c = { "<cmd>Telescope commands<cr>", "Commands" },
	d = { "<cmd>lua require 'telescope'.extensions.file_browser.file_browser({ path = '~/dev/' })<CR>", "Dev" },
	N = {
		"<cmd>lua require 'telescope'.extensions.file_browser.file_browser({ path = '~/Dropbox/notes/' })<CR>",
		"Notes",
	},
	f = { "<cmd>Telescope live_grep<cr>", "Find Text" },
	g = { "<cmd>:LazyGit<cr>", "Lazygit" },
	n = { "<cmd>:vsplit | enew<cr>", "New File" },
	o = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
	p = { "<cmd>Telescope find_files<cr>", "Find Files" },
	q = { "<cmd>:q<cr>", "Quit" },
	x = { "<cmd>TroubleToggle<cr>", "Trouble" },
	w = { "<cmd>:w<cr>", "Save" },
	t = {
		name = "+test",
		a = { "<cmd>:A<cr>", "Toggle test/source file" },
		v = { "<cmd>:AV<cr>", "Open test/source file in vsplit" },
		f = { "<cmd>:TestFile<cr>", "Test File" },
		l = { "<cmd>:TestLast<cr>", "Test Last" },
		n = { "<cmd>:TestNearest<cr>", "Test Nearest" },
		s = { "<cmd>:TestSuite<cr>", "Test Suite" },
	},
	s = {
		name = "+search",
		f = { "<cmd>Telescope grep_string<cr>", "Find string under cursor" },
		s = { "<cmd>:lua require('spectre').open()<CR>", "Search" },
		v = { "<cmd>:lua require('spectre').open_visual()<CR>", "Search selected" },
		w = { "<cmd>:lua require('spectre').open_visual({select_word=true})<CR>", "Search word under cursor" },
	},
	h = {
		name = "+harpoon",
		a = { "<cmd>:lua require('harpoon.mark').add_file()<cr>", "Add" },
		m = { "<cmd>:lua require('harpoon.ui').toggle_quick_menu()<cr>", "Menu" },
		p = { "<cmd>:lua require('harpoon.ui').nav_prev()<cr>", "Prev" },
		n = { "<cmd>:lua require('harpoon.ui').nav_next()<cr>", "Next" },
	},
}

for i = 0, 10 do
	leader[tostring(i)] = "which_key_ignore"
end

wk.register(leader, { prefix = "<leader>" })
