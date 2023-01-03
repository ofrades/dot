vim.cmd([[
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
]])

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.cmd("autocmd BufWritePre *.lua lua vim.lsp.buf.format({ async = false })")
vim.cmd("autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll")

-- Map esc to exit inside lazygit
vim.api.nvim_exec(
  [[
  function LazyGitNativation()
    echom &filetype
    if &filetype ==# 'FTerm'
      tnoremap <Esc> q
      tnoremap <C-v><Esc> <Esc>
    endif
  endfunction
  ]],
  false
)
