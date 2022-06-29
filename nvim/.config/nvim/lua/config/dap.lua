require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")

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
		type = "node2",
		request = "launch",
		name = "Launch Program (Node2 with ts-node)",
		cwd = vim.fn.getcwd(),
		runtimeArgs = { "-r", "ts-node/register" },
		runtimeExecutable = "node",
		args = { "--inspect", "${file}" },
		sourceMaps = true,
		skipFiles = { "<node_internals>/**", "node_modules/**" },
	},
	{
		type = "node2",
		request = "launch",
		name = "Launch Test Program (Node2 with jest)",
		cwd = vim.fn.getcwd(),
		runtimeArgs = { "--inspect-brk", "${workspaceFolder}/node_modules/.bin/jest" },
		runtimeExecutable = "node",
		args = { "${file}", "--runInBand", "--coverage", "false" },
		sourceMaps = true,
		port = 9229,
		skipFiles = { "<node_internals>/**", "node_modules/**" },
	},
	{
		type = "node2",
		request = "attach",
		name = "Attach Program (Node2 with ts-node)",
		cwd = vim.fn.getcwd(),
		runtimeExecutable = "node",
		args = { "--inspect", "${file}" },
		sourceMaps = true,
		skipFiles = { "<node_internals>/**" },
		port = 9229,
	},
}
