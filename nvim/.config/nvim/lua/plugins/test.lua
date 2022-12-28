return {
  "vim-test/vim-test",
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "haydenmeade/neotest-jest",
    "nvim-neotest/neotest-vim-test",
    "akinsho/toggleterm.nvim",
  },
  config = function()
    local tt = require("toggleterm")
    local ttt = require("toggleterm.terminal")

    vim.g["test#custom_strategies"] = {
      tterm = function(cmd)
        tt.exec(cmd)
      end,

      tterm_close = function(cmd)
        local term_id = 0
        tt.exec(cmd, term_id)
        ttt.get_or_create_term(term_id):close()
      end,
    }

    vim.g["test#strategy"] = {
      nearest = "tterm",
      file = "tterm",
      suite = "tterm",
    }
    require("neotest").setup({
      icons = {
        passed = "",
        failed = "",
        skipped = "ﭡ",
        unknown = "",
        running = "",
        running_animated = { "", "", "", "", "", "", "", "", "" },
      },
      output = {
        enabled = true,
        open_on_run = true,
      },
      run = {
        enabled = true,
      },
      status = {
        enabled = true,
        virtual_text = true,
      },
      strategies = {
        integrated = {
          height = 40,
          width = 120,
        },
      },
      summary = {
        enabled = true,
        expand_errors = true,
        follow = true,
        mappings = {
          attach = "a",
          expand = { "<CR>", "<2-LeftMouse>" },
          expand_all = "e",
          jumpto = "i",
          output = "o",
          run = "r",
          short = "O",
          stop = "x",
        },
      },
      adapters = {
        require("neotest-jest")({
          jestCommand = "npm test --",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),
      },
    })
  end,
}
