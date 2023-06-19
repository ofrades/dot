-- options
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 5 -- Lines of context
vim.opt.shell = "fish"
vim.opt.swapfile = false

vim.opt.backup = true
vim.opt.cmdheight = 0
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldcolumn = "0"
