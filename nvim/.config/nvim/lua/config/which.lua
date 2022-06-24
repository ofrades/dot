local map = require("which-key")
local presets = require("which-key.plugins.presets")

presets.objects["a("] = nil

map.setup({
	show_help = true,
	triggers = "auto",
	plugins = { spelling = true },
	key_labels = { ["<leader>"] = "SPC" },
})

map.register({
	b = { "<cmd>:botright Ttoggle<cr>", "Terminal bottom" },
	v = { "<cmd>:vertical Ttoggle<cr>", "Terminal side" },
	e = { "<cmd>:Neotree toggle reveal<CR>", "Tree sidebar" },
	t = { "<cmd>:Ranger<CR>", "Ranger" },
	n = { "<cmd>:vsplit | enew<cr>", "New File" },
	q = { "<cmd>:q<cr>", "Quit" },
	u = { "<cmd>:MundoToggle<cr>", "Undo tree" },
	x = { "<cmd>:TroubleToggle<cr>", "Trouble" },
	w = { "<cmd>:w<cr>", "Save" },
	f = { "<cmd>:lua require('spectre').open()<CR>", "Search" },
	F = { "<cmd>:lua require('spectre').open_visual({select_word=true})<CR>", "Search selected" },
	g = {
		name = "+git",
		a = { "<cmd>:Git commit -a --no-edit<cr>", "Amend" },
		b = { "<cmd>:GBrowse<cr>", "Open repo in browser" },
		B = { "<cmd>:GBrowse!<cr>", "Path to file" },
		c = { "<cmd>:tab Git commit -v<cr>", "Commit" },
		d = { "<cmd>:Gvdiffsplit<cr>", "Buffer diff split" },
		s = { "<cmd>:tab Git<cr>", "Git status" },
		g = { "<cmd>:Lazygit<cr>", "Lazygit" },
		p = { "<cmd>:Git pull<cr>", "Pull" },
		P = { "<cmd>:Git push<cr>", "Push" },
		m = {
			name = "+mob",
			s = { "<cmd>:T mob start<cr>", "Mob start" },
			n = { "<cmd>:T mob next<cr>", "Mob next" },
			t = { ":T mob timer ", "Mob timer..." },
			d = { "<cmd>:T mob done<cr>", "Mob done" },
			r = { "<cmd>:T mob reset<cr>", "Mob reset" },
			m = { "<cmd>:T mob moo<cr>", "Mob moo!" },
		},
	},
	h = {
		name = "+harpoon",
		a = { "<cmd>:lua require('harpoon.mark').add_file()<cr>", "Add" },
		m = { "<cmd>:lua require('harpoon.ui').toggle_quick_menu()<cr>", "Menu" },
		p = { "<cmd>:lua require('harpoon.ui').nav_prev()<cr>", "Prev" },
		n = { "<cmd>:lua require('harpoon.ui').nav_next()<cr>", "Next" },
	},
}, { prefix = "<leader>" })

map.register({
	a = { "<cmd>:A<cr>", "Toggle test/source file" },
	f = { "<cmd>:TestFile<cr>", "Test File" },
	l = { "<cmd>:TestLast<cr>", "Test Last" },
	c = { "<cmd>:TestNearest<cr>", "Test Nearest" },
	s = { "<cmd>:TestSuite<cr>", "Test Suite" },
	t = { "<cmd>:tab term<cr>", "Terminal" },
	j = {
		name = "+jester",
		r = { "<cmd>:lua require'jester'.run()<cr>", "Run" },
		f = { "<cmd>:lua require'jester'.run_file()<CR>", "Run test file" },
		l = { "<cmd>:lua require'jester'.run_last()<CR>", "Run last test" },
		d = { "<cmd>:lua require'jester'.debug()<CR>", "Debug" },
		F = { "<cmd>:lua require'jester'.debug_file()<CR>", "Debug file" },
		L = { "<cmd>:lua require'jester'.debug_last()<CR>", "Debug last" },
	},
	n = {
		name = "+neotest",
		c = { "<cmd>:lua require'neotest'.run.run()<cr>", "Run nearest test" },
		f = { "<cmd>:lua require'neotest'.run.run(vim.fn.expand('%'))<CR>", "Run test file" },
		d = { "<cmd>:lua require'neotest'.run.run({strategy = 'dap'})<CR>", "Debug nearest test" },
		s = { "<cmd>:lua require'neotest'.run.run(vim.fn.getcwd())<CR>", "Run test suite" },
		S = { "<cmd>:lua require'neotest'.run.stop()<CR>", "Stop nearest test" },
		a = { "<cmd>:lua require'neotest'.run.attach()<CR>", "Attach nearest test" },
		o = { "<cmd>:lua require'neotest'.output.open()<CR>", "Open output" },
		t = { "<cmd>:lua require'neotest'.summary.toggle()<CR>", "Toggle summary" },
	},
	d = {
		name = "+dap",
		b = { "<cmd>:lua require'dap'.toggle_breakpoint()<cr>", "Toggle breakpoint" },
		c = { "<cmd>:lua require'dap'.continue()<CR>", "Continue" },
		o = { "<cmd>:lua require'dap'.step_over()<CR>", "Step over" },
		i = { "<cmd>:lua require'dap'.step_into()<CR>", "Step into" },
		t = { "<cmd>:lua require'dapui'.toggle()<CR>", "Toggle ui" },
	},
}, { prefix = "t" })

map.register({
	b = { "<cmd>:Telescope git_branches theme=ivy<cr>", "Git branches" },
	c = { "<cmd>:Telescope commands theme=ivy<cr>", "Commands" },
	d = { "<cmd>:lua require('telescope.builtin').find_files({cwd = '~/dot', hidden = true})<cr>", "Dot" },
	f = { "<cmd>Telescope live_grep theme=ivy hidden=true<cr>", "Find Text" },
	o = { "<cmd>:Telescope oldfiles theme=ivy hidden=true theme=ivy<cr>", "Recent Files" },
	h = { "<cmd>:Telescope help_tags theme=ivy<cr>", "Help" },
	k = { "<cmd>:Telescope keymaps theme=ivy<cr>", "Keymaps" },
	m = { "<cmd>:Telescope man_pages theme=ivy<cr>", "Man pages" },
	p = { "<cmd>:Telescope find_files theme=ivy hidden=true<cr>", "Find Files" },
	P = { "<cmd>:Telescope frecency hidden=true theme=ivy<cr>", "Find Files frecency" },
	r = { "<cmd>:Telescope project theme=ivy<cr>", "Projectile" },
}, { prefix = "<leader><leader>" })

map.register({
	b = { "<cmd>:'<,'>GBrowse!<cr>", "Path to file" },
}, { mode = "v", prefix = "<leader>" })
