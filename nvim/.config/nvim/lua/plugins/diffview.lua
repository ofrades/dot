return {
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
}
