return {
  "jose-elias-alvarez/null-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.completion.spell,
        null_ls.builtins.diagnostics.actionlint,
        null_ls.builtins.diagnostics.write_good,
        null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.diagnostics.flake8,
        -- null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.fixjson,
        null_ls.builtins.formatting.yamlfmt,
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.code_actions.refactoring,
      },
    })
  end,
}
