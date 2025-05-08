return {
    {
      "nvim-lspconfig",
      opts = {
        inlay_hints = { enabled = false },
      },
    },
    {
      "NvChad/nvim-colorizer.lua",
      opts = {
        user_default_options = {
          mode = "background",
          names = false,
        },
      },
    },
   { "mason-org/mason.nvim", version = "^1.0.0" },
   { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
    { "echasnovski/mini.pairs", enabled = false },
    { "akinsho/bufferline.nvim", enabled = false },
    { "mg979/vim-visual-multi" },
    {
      "stevearc/oil.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        default_file_explorer = true,
        columns = {
          "icon",
          "size",
        },
      },
      keys = {
        { "-", "<cmd>Oil<cr>", desc = "Open parent directory with Oil" },
      },
    },
    {
      "nvim-neotest/neotest",
      dependencies = {
        "marilari88/neotest-vitest",
      },
      opts = {
        adapters = {
          ["neotest-vitest"] = {},
        },
        output = {
          enabled = false,
        },
        quickfix = {
          enabled = false,
        },
      },
    },
  }
