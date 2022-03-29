local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({
	completion = {
		completeopt = "menuone,noinsert",
	},
	experimental = {
		native_menu = false,
		ghost_text = true,
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	preselect = cmp.PreselectMode.None,
	documentation = {
		border = "solid",
	},
	mapping = {
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip", priority = 999 },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "spell" },
		{ name = "nvim_lua" },
		{ name = "rg" },
		{ name = "cmp_git" },
		{ name = "tmux" },
		{ name = "signature_help" },
		{ name = "cmp_tabnine" },
	},
})

cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})
