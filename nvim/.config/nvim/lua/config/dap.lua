vim.fn.sign_define("DapBreakpoint", { text = "→", texthl = "Error", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "Success", linehl = "", numhl = "" })

vim.keymap.set("n", "<F4>", [[:lua require('dap').toggle_breakpoint()<cr>]])
vim.keymap.set("n", "<F5>", [[:lua require('dap').continue()<cr>]])
vim.keymap.set("n", "<F6>", [[:lua require('dap').step_over()<cr>]])
vim.keymap.set("n", "<F7>", [[:lua require('dap').step_into()<cr>]])
vim.keymap.set("n", "<F8>", [[:lua require('dap').step_out()<cr>]])

vim.keymap.set("n", "<F1>", [[:lua require('dapui').toggle()<cr>]])
vim.keymap.set("n", "<F2>", [[:lua require('jester').debug()<cr>]])

local dap = require("dap")

dap.set_log_level("TRACE")

dap.adapters.node2 = {
	type = "executable",
	command = "node",
	args = { os.getenv("HOME") .. "/vscode-node-debug2/out/src/nodeDebug.js" },
}
dap.configurations.typescript = {
	{
		name = "Launch",
		type = "node2",
		request = "launch",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
		skipFiles = { "<node_internals>/**/*.js" },
	},
	{
		-- For this to work you need to make sure the node process is started with the `--inspect` flag.
		name = "Attach to process",
		type = "node2",
		request = "attach",
		processId = require("dap.utils").pick_process,
	},
}
