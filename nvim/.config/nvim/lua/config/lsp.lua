local nvim_lsp = require("lspconfig")

vim.diagnostic.config({
	underline = true,
	update_in_insert = true,
	signs = true,
	virtual_text = true,
	severity_sort = true,
	float = { focusable = false, border = "rounded", style = "minimal" },
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local function on_attach(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
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

-- vim.cmd([[autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll]])

-- nvim_lsp.eslint.setup({
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- 	root_dir = nvim_lsp.util.root_pattern("package.json"),
-- })
