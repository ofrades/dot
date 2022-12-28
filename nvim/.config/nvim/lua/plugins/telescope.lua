return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ThePrimeagen/harpoon",
  },
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<ESC>"] = actions.close,
          },
        },
      },
      extensions = {
        project = {
          base_dirs = {
            { "~/dev", max_depth = 4 },
          },
          hidden_files = true,
        },
      },
    })
    require("telescope").load_extension("harpoon")
  end,
}
