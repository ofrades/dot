return {

  -- telescope
  {
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
  },

  -- spectre
  {
    "windwp/nvim-spectre",
    config = function()
      require("spectre").setup()
    end,
  },

  -- ssr
  {
    "cshuaimin/ssr.nvim",
    config = function()
      require("ssr").setup({
        min_width = 50,
        min_height = 5,
        max_width = 120,
        max_height = 25,
        keymaps = {
          close = "q",
          next_match = "n",
          prev_match = "N",
          replace_confirm = "<cr>",
          replace_all = "<leader><cr>",
        },
      })
    end,
  },
}
