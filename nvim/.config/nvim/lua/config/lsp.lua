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

local function on_attach(client, bufnr)
	local opts = { buffer = bufnr }
	if client.server_capabilities.documentFormattingProvider then
		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format{async = true}")
	end
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
	vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
	vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "X", "<cmd>lua vim.diagnostic.open_float(nil, { focus = false })<CR>", opts)

	vim.keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
	vim.keymap.set("n", "ga", "<cmd>Telescope lsp_code_actions<CR>", opts)
	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
	vim.keymap.set("n", "gx", "<cmd>Trouble document_diagnostics<CR>", opts)
	vim.keymap.set("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	vim.keymap.set("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	vim.keymap.set("n", "gq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
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
	"bashls",
	"eslint",
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

nvim_lsp.denols.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = nvim_lsp.util.root_pattern("deno.json"),
	init_options = {
		lint = true,
	},
})

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

require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.prettier.with({
			filetypes = { "html", "json", "yaml", "markdown", "toml" },
		}),
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.eslint_d,
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
		require("null-ls").builtins.completion.spell,
	},
	on_attach = on_attach,
})

return M
