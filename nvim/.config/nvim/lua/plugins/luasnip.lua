return {
	"L3MON4D3/LuaSnip",
	module = "luasnip",
	config = function()
		require("luasnip").setup({})
	end,
	dependencies = {
		"rafamadriz/friendly-snippets",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}
