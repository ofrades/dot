local nvim_lsp = require("lspconfig")

-- diagnostics
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = false,
	severity_sort = true,
	float = { border = "single", focusable = false, scope = "line" },
})
local M = {}
M.signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(M.signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local function on_attach(client)
	local opts = { noremap = true, silent = true }
	if client.resolved_capabilities.document_formatting then
		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	end
	if client.name == "jsonls" then
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
	end
	if client.name == "tsserver" then
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
	end

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
	vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
	vim.api.nvim_set_keymap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_set_keymap("n", "<space>lwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	vim.api.nvim_set_keymap("n", "<space>lwr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	vim.api.nvim_set_keymap(
		"n",
		"<space>lwl",
		"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
		opts
	)
	vim.api.nvim_set_keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
	vim.api.nvim_set_keymap("n", "ga", "<cmd>Telescope lsp_code_actions<CR>", opts)
	vim.api.nvim_set_keymap("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.api.nvim_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
	vim.api.nvim_set_keymap("n", "gx", "<cmd>Trouble document_diagnostics<CR>", opts)
	vim.api.nvim_set_keymap("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	vim.api.nvim_set_keymap("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	vim.api.nvim_set_keymap("n", "<space>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	vim.api.nvim_set_keymap("n", "<space>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local options = {
	on_attach = on_attach,
	capabilities = capabilities,
	flags = {
		debounce_text_changes = 150,
	},
}

local servers = {
	"tsserver",
	"cssls",
	"jsonls",
	"html",
	"pyright",
}
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup(options)
end

require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.prettier.with({
			filetypes = { "html", "json", "yaml", "markdown", "toml" },
		}),
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.eslint_d,
		require("null-ls").builtins.formatting.terraform_fmt,
		require("null-ls").builtins.formatting.black,
		require("null-ls").builtins.formatting.fixjson,

		require("null-ls").builtins.diagnostics.eslint_d,
		require("null-ls").builtins.diagnostics.flake8,
		require("null-ls").builtins.diagnostics.write_good,
		require("null-ls").builtins.diagnostics.markdownlint,
		require("null-ls").builtins.diagnostics.ansiblelint,
		require("null-ls").builtins.diagnostics.jsonlint,
		-- require("null-ls").builtins.diagnostics.cspell,

		require("null-ls").builtins.code_actions.gitsigns,
		require("null-ls").builtins.code_actions.eslint_d,
		require("null-ls").builtins.code_actions.refactoring,

		require("null-ls").builtins.hover.dictionary,
		require("null-ls").builtins.completion.spell,
	},
	on_attach = on_attach,
})

return M
