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

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "g]", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "gq", vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
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
	--
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions theme=ivy<cr>", bufopts)
	vim.keymap.set("n", "gh", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	-- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", bufopts)
	vim.keymap.set("n", "gR", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "ga", vim.lsp.buf.code_action, bufopts)
	-- vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references theme=ivy<cr>", bufopts)
	vim.keymap.set("n", "gf", vim.lsp.buf.formatting, bufopts)

	vim.keymap.set("n", "X", "<cmd>lua vim.diagnostic.open_float(nil, { focus = false })<cr>", bufopts)
	vim.keymap.set("n", "gx", "<cmd>Trouble document_diagnostics<cr>", bufopts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local options = {
	on_attach = on_attach,
	capabilities = capabilities,
}

local servers = {
	"bashls",
	"cssls",
	"jsonls",
	"html",
	"pyright",
	"gopls",
	"rust_analyzer",
	"tsserver",
}

-- nvim_lsp.tsserver.setup({
-- 	options,
-- 	root_dir = nvim_lsp.util.root_pattern("package.json"),
-- })

nvim_lsp.emmet_ls.setup({
	options,
	filetypes = { "html", "css", "typescriptreact", "javascriptreact" },
})

for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup(options)
end

-- nvim_lsp.denols.setup({
-- 	options,
-- 	root_dir = nvim_lsp.util.root_pattern("deno.json"),
-- 	init_options = {
-- 		lint = true,
-- 	},
-- })

-- vim.cmd([[autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll]])

-- nvim_lsp.eslint.setup({
--  options,
-- 	root_dir = nvim_lsp.util.root_pattern("package.json"),
-- })
