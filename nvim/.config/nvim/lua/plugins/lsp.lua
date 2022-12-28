return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"mrshmllow/document-color.nvim",
	},
	config = function()
		vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			underline = true,
			update_in_insert = false,
			virtual_text = { spacing = 4, prefix = "●" },
			severity_sort = true,
		})

		local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		require("document-color").setup({
			mode = "background", -- "background" | "foreground" | "single"
		})

		local opts = { noremap = true, silent = true }

		vim.keymap.set("n", "gq", vim.diagnostic.setloclist, opts)
		vim.keymap.set("n", "gx", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
		vim.keymap.set(
			"n",
			"[e",
			"<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>",
			opts
		)
		vim.keymap.set(
			"n",
			"]e",
			"<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>",
			opts
		)

		local function on_attach(client, bufnr)
			if vim.fn.exists(":Telescope") then
				vim.keymap.set("n", "gr", "<cmd>:Telescope lsp_references<CR>", buf_opts)
				vim.keymap.set("n", "gd", "<cmd>:Telescope lsp_definitions<CR>", buf_opts)
				vim.keymap.set("n", "gD", "<cmd>:Telescope lsp_declarations<CR>", buf_opts)
				vim.keymap.set("n", "gi", "<cmd>:Telescope lsp_implementations<CR>", buf_opts)
				vim.keymap.set("n", "gt", "<cmd>:Telescope lsp_type_definitions<CR>", buf_opts)
			else
				vim.keymap.set("n", "gr", vim.lsp.buf.references, buf_opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, buf_opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, buf_opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buf_opts)
				vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, buf_opts)
			end

			vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, buf_opts)
			vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, buf_opts)
			vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, buf_opts)
			vim.keymap.set("n", "ga", vim.lsp.buf.code_action, buf_opts)
			vim.keymap.set("n", "gF", vim.lsp.buf.format, buf_opts)
			vim.keymap.set("n", "gh", vim.lsp.buf.hover, buf_opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)

			if client.server_capabilities.documentFormatting then
				vim.keymap.set("n", "gF", vim.lsp.buf.format, buf_opts)
			elseif client.server_capabilities.documentRangeFormatting then
				vim.keymap.set("n", "gF", vim.lsp.buf.range_formatting, buf_opts)
			elseif client.server_capabilities.colorProvider then
				require("document-color").buf_attach(bufnr)
			end
		end

		require("mason").setup()
		local mason_lspconfig = require("mason-lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		local servers = {
			tsserver = {},
			eslint = {},
			jsonls = {},
			pyright = {},
			rust_analyzer = {},
			marksman = {},
			sumneko_lua = {},
		}

		mason_lspconfig.setup({
			ensure_installed = servers,
			automatic_installation = true,
		})

		local lspconfig = require("lspconfig") -- LSP config
		capabilities.textDocument.colorProvider = {
			dynamicRegistration = true,
		}
		local options = {
			on_attach = on_attach,
			capabilities = capabilities,
			flags = {
				debounce_text_changes = 150,
			},
		}
		mason_lspconfig.setup_handlers({
			function(servers)
				require("lspconfig")[servers].setup(options)
			end,
		})

		lspconfig["denols"].setup({
			autostart = false,
			root_dir = lspconfig.util.root_pattern("deno.json"),
			init_options = { lint = true },
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["tsserver"].setup({
			root_dir = lspconfig.util.root_pattern("package.json"),
			init_options = { lint = true },
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end,
}
