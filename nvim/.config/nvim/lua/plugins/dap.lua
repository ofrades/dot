return {
  enabled = false,
  "mfussenegger/nvim-dap",
  dependencies = {
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/nvim-dap-ui",
    "mxsdev/nvim-dap-vscode-js",
  },
  config = function()
    require("dapui").setup({})
    vim.fn.sign_define("DapBreakpoint", { text = "→", texthl = "Error", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "Success", linehl = "", numhl = "" })

    vim.keymap.set("n", "<F1>", [[:lua require('dapui').toggle()<cr>]])
    vim.keymap.set("n", "<F2>", [[:lua require('dap').terminate()<cr>]])

    vim.keymap.set("n", "<F4>", [[:lua require('dap').toggle_breakpoint()<cr>]])
    vim.keymap.set("n", "<F5>", [[:lua require('dap').continue()<cr>]])
    vim.keymap.set("n", "<F6>", [[:lua require('dap').step_over()<cr>]])
    vim.keymap.set("n", "<F7>", [[:lua require('dap').step_into()<cr>]])
    vim.keymap.set("n", "<F9>", [[:lua require('dap').step_out()<cr>]])

    local dap = require("dap")

    dap.set_log_level("TRACE")

    require("nvim-dap-virtual-text").setup()
    vim.g.dap_virtual_text = true

    require("dap-vscode-js").setup({
      debugger_cmd = { "js-debug-adapter" },
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
    })
    for _, language in ipairs({ "typescript", "javascript" }) do
      require("dap").configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "[pwa-node] Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "[pwa-node] Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Jest Tests ts-node",
          -- trace = true, -- include debugger info
          runtimeExecutable = "node",
          runtimeArgs = {
            "node_modules/.bin/jest",
            "--runInBand",
          },
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          skipFiles = { "<node_internals>/**" },
          protocol = "inspector",
        },
      }
    end
  end,
}
