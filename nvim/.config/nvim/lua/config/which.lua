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
	c = { "<cmd>Telescope commands theme=ivy<cr>", "Commands" },
	d = { "<cmd>:T dev<CR>", "Dev" },
	m = { "<cmd>:T mux<CR>", "Mux" },
	f = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
	n = { "<cmd>:vsplit | enew<cr>", "New File" },
	o = { "<cmd>:Telescope oldfiles theme=ivy<cr>", "Recent Files" },
	p = { "<cmd>:Telescope find_files theme=ivy<cr>", "Find Files" },
	q = { "<cmd>:q<cr>", "Quit" },
	x = { "<cmd>:TroubleToggle<cr>", "Trouble" },
	w = { "<cmd>:w<cr>", "Save" },
	g = {
		name = "+git",
    a = { "<cmd>:Git commit -a --no-edit<cr>", "Amend" },
    b = { "<cmd>:GBrowse!<cr>", "Path to file" },
    b = { "<cmd>:Telescope git_branches<cr>", "Git branches" },
    c = { "<cmd>:tab Git commit -v<cr>", "Commit" },
    d = { "<cmd>:Gvdiffsplit<cr>", "Buffer diff split"},
    s = { "<cmd>:tab Git<cr>", "Git status" },
    l = { "<cmd>:LazyGit<cr>", "Lazygit" },
    p = { "<cmd>:Git pull<cr>", "Pull" },
    P = { "<cmd>:Git push<cr>", "Push" },
    m = {
      name = "+mob",
      s = { "<cmd>:T mob start<cr>", "Mob start"},
      n = { "<cmd>:T mob next<cr>", "Mob next"},
      t = { ":T mob timer ", "Mob timer..."},
      d = { "<cmd>:T mob done<cr>", "Mob done"},
      r = { "<cmd>:T mob reset<cr>", "Mob reset"},
      m = { "<cmd>:T mob moo<cr>", "Mob moo!"},
    },
  },
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
		f = { "<cmd>Telescope grep_string theme=ivy<cr>", "Find string under cursor" },
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

local leaderv = {
  g = {
    name = "+git",
    b = { "<cmd>:'<,'>GBrowse!<cr>", "Path to file" },
  },
}
wk.register(leaderv, { mode = "v", prefix = "<leader>" })
