-- commands
-- vim.cmd("autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll")
--

vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
