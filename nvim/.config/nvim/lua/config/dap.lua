vim.fn.sign_define("DapBreakpoint", { text = "→", texthl = "Error", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "Success", linehl = "", numhl = "" })

vim.keymap.set("n", "<F1>", [[:lua require('dap').toggle_breakpoint()<cr>]])
vim.keymap.set("n", "<F5>", [[:lua require('dap').continue()<cr>]])
vim.keymap.set("n", "<F6>", [[:lua require('dap').step_over()<cr>]])
vim.keymap.set("n", "<F7>", [[:lua require('dap').step_into()<cr>]])
vim.keymap.set("n", "<F8>", [[:lua require('dap').step_out()<cr>]])

local dap = require("dap")

local dap_python = require("dap-python")

dap_python.setup("~/virtualenvs/debugpy/bin/python", { include_configs = false })
dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
		justMyCode = false,
		program = "${file}",
		console = "integratedTerminal",
	},
	{
		type = "python",
		request = "attach",
		name = "Attach remote",
		justMyCode = false,
		host = function()
			local value = vim.fn.input("Host [127.0.0.1]: ")
			if value ~= "" then
				return value
			end
			return "127.0.0.1"
		end,
		port = function()
			return tonumber(vim.fn.input("Port [5678]: ")) or 5678
		end,
	},
}

dap_python.test_runner = "pytest"

dap.configurations.lua = {
	{
		type = "nlua",
		request = "attach",
		name = "Attach to running Neovim instance",
		host = function()
			local value = vim.fn.input("Host [127.0.0.1]: ")
			if value ~= "" then
				return value
			end
			return "127.0.0.1"
		end,
		port = function()
			local val = tonumber(vim.fn.input("Port: "))
			assert(val, "Please provide a port number")
			return val
		end,
	},
}

dap.adapters.nlua = function(callback, config)
	callback({ type = "server", host = config.host, port = config.port })
end

dap.adapters.go = {
	type = "executable",
	command = "node",
	args = { os.getenv("HOME") .. "/Dev/repos/vscode-go/dist/debugAdapter.js" },
}
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
	{
		type = "go",
		name = "Debug",
		request = "launch",
		program = "${file}",
		dlvToolPath = vim.fn.exepath("dlv"),
	},
}

dap.adapters.node2 = {
	type = "executable",
	command = "node",
	args = {
		"/var/home/ofrades/vscode-node-debug2/out/src/nodeDebug.js",
	},
}
dap.configurations.javascript = {
	{
		type = "node2",
		request = "launch",
		program = "${workspaceFolder}/${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
	},
}
dap.configurations.typescript = dap.configurations.javascript

dap.adapters.lldb = {
	type = "executable",
	attach = { pidProperty = "pid", pidSelect = "ask" },
	command = "lldb-vscode",
	env = { LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES" },
}

dap.configurations.rust = {
	{
		type = "rust",
		request = "launch",
		name = "lldb",
		program = function()
			local metadata_json = vim.fn.system("cargo metadata --format-version 1 --no-deps")
			local metadata = vim.fn.json_decode(metadata_json)
			local target_name = metadata.packages[1].targets[1].name
			local target_dir = metadata.target_directory
			return target_dir .. "/debug/" .. target_name
		end,
	},
}

dap.configurations.c = {
	{
		-- If you get an "Operation not permitted" error using this, try disabling YAMA:
		--  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		name = "Attach to process",
		type = "lldb", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
		request = "attach",
		pid = require("dap.utils").pick_process,
		args = {},
	},
}