return {

  -- scrollbar
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end,
  },

  -- harpoon
  {
    "ThePrimeagen/harpoon",
  },

  -- tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false,
          },
          follow_current_file = true,
        },
        window = {
          position = "current",
        },
      })
    end,
  },

  -- yanky
  {
    "gbprod/yanky.nvim",
    config = function()
      require("yanky").setup({
        ring = {
          history_length = 100,
          storage = "shada",
          sync_with_numbered_registers = true,
          cancel_event = "update",
        },
        highlight = {
          timer = 100,
        },
        system_clipboard = {
          sync_with_ring = true,
        },
      })
    end,
  },

  -- trouble
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({})
    end,
  },

  -- mundo
  { "simnalamburt/vim-mundo" },
}
