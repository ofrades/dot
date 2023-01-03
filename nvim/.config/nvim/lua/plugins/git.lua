return {

  -- diffview
  {
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup({
        keymaps = {
          file_panel = {
            ["q"] = "<Cmd>tabc<CR>",
          },
        },
      })
    end,
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      "petertriho/nvim-scrollbar",
    },
    config = function()
      require("gitsigns").setup()
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
}
