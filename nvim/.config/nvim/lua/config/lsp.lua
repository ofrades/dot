local nvim_lsp = require("lspconfig")

-- diagnostics
vim.diagnostic.config({
	underline = true,
	update_in_insert = true,
	signs = true,
	virtual_text = true,
	severity_sort = true,
	float = { focusable = false, border = "rounded", style = "minimal" },
})
local M = {}
M.signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(M.signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local function on_attach(client, bufnr)
	local opts = { buffer = bufnr }
	if client.name == "jsonls" then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end
	if client.name == "eslint" then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end
	if client.name == "denols" then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end
	if client.name == "rust_analyzer" then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, opts)

	vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "g]", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "gq", vim.diagnostic.setloclist, opts)
	vim.keymap.set("n", "gf", vim.lsp.buf.formatting, opts)
	vim.keymap.set("n", "X", "<cmd>lua vim.diagnostic.open_float(nil, { focus = false })<CR>", opts)
	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
	vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
	vim.keymap.set("n", "gx", "<cmd>Trouble document_diagnostics<CR>", opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

vim.cmd([[autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll]])

local options = {
	on_attach = on_attach,
	capabilities = capabilities,
	flags = {
		debounce_text_changes = 150,
	},
}

local servers = {
	"bashls",
	"cssls",
	"jsonls",
	"html",
	"pyright",
	"gopls",
	"rust_analyzer",
}

for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup(options)
end

-- nvim_lsp.denols.setup({
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- 	root_dir = nvim_lsp.util.root_pattern("deno.json"),
-- 	init_options = {
-- 		lint = true,
-- 	},
-- })

nvim_lsp.emmet_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "css", "typescriptreact", "javascriptreact" },
})

nvim_lsp.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = nvim_lsp.util.root_pattern("package.json"),
})

nvim_lsp.eslint.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = nvim_lsp.util.root_pattern("package.json"),
})

require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.prettier.with({
			filetypes = { "html", "json", "yaml", "markdown", "toml" },
		}),
		require("null-ls").builtins.formatting.stylua,
		-- require("null-ls").builtins.formatting.eslint_d,
		require("null-ls").builtins.formatting.terraform_fmt,
		require("null-ls").builtins.formatting.black.with({ filetypes = { "python", "jq" } }),
		require("null-ls").builtins.formatting.fixjson,
		require("null-ls").builtins.formatting.rustfmt,
		-- require("null-ls").builtins.formatting.deno_fmt,

		-- require("null-ls").builtins.diagnostics.eslint_d,
		require("null-ls").builtins.diagnostics.flake8,
		require("null-ls").builtins.diagnostics.write_good,
		require("null-ls").builtins.diagnostics.markdownlint,
		require("null-ls").builtins.diagnostics.ansiblelint,
		require("null-ls").builtins.diagnostics.jsonlint,
		require("null-ls").builtins.diagnostics.golangci_lint,
		-- require("null-ls").builtins.diagnostics.cspell,

		require("null-ls").builtins.code_actions.gitsigns,
		-- require("null-ls").builtins.code_actions.eslint_d,
		require("null-ls").builtins.code_actions.refactoring,

		require("null-ls").builtins.hover.dictionary,
	},
	on_attach = on_attach,
})

return M
