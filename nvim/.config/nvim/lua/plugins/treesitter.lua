return {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		require("nvim-treesitter.configs").setup({
			highlight = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<cr>",
					scope_incremental = "<cr>",
					node_incremental = "<TAB>",
					node_decremental = "<S-TAB>",
				},
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			indent = {
				enable = true,
			},
			autotag = {
				enable = true,
			},
		})
	end,
}
