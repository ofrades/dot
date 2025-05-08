vim.o.updatetime = 250

-- reload when files change outside buffer
vim.o.autoread = true
vim.o.shell = "nush"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.opt.grepprg = "rg --vimgrep"

vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 5 -- Lines of context
vim.opt.swapfile = false
vim.g.show_inlay_hints = false

vim.opt.backup = true
vim.opt.cmdheight = 0
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldcolumn = "0"

vim.g.netrw_banner = 0
vim.g.netrw_keepdir = 0
vim.g.netrw_liststyle = 1
vim.o.spelllang = "en,pt,la"
vim.o.spell = true

-- macros
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa:', " .. esc .. "pa);" .. esc .. "s") -- with sav
