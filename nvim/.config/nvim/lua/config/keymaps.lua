--Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move to window using the <ctrl> movement keys
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Out
vim.keymap.set("n", "<ESC><ESC>", ":q!<cr>")
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")
vim.keymap.set("", "<ESC>", ":noh<cr>")

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<Up>", ":resize +2<cr>")
vim.keymap.set("n", "<Down>", ":resize -2<cr>")
vim.keymap.set("n", "<Left>", ":vertical resize +2<cr>")
vim.keymap.set("n", "<Right>", ":vertical resize -2<cr>")

-- Move Lines up and down
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==")
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<cr>==gi")
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==")
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv")
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<cr>==gi")

-- Easy go to start and end of line
vim.keymap.set("n", "H", "^")
vim.keymap.set("o", "H", "^")
vim.keymap.set("x", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("o", "L", "$")
vim.keymap.set("x", "L", "$")

-- Nice defaults
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "D", "d$")
vim.keymap.set("n", "C", "c$")
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "<C-a>", "ggVG")

vim.keymap.set("n", "<C-t>", "<cmd>:term<cr>")

-- Copy file path
vim.keymap.set("n", "<leader>yp", ":let @+=expand('%:p')<cr>")

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Honky <C-i>
-- vim.keymap.set("n", "<Tab>", "%", { remap = true })
-- vim.keymap.set("x", "<Tab>", "%", { remap = true })
-- vim.keymap.set("o", "<Tab>", "%", { remap = true })
vim.keymap.set("n", "<C-t>", "<cmd>:tabnew<cr>")

-- remap fugitive inline diff to tab
vim.cmd("autocmd FileType fugitive nmap <buffer> <Tab> =")

vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions theme=ivy<cr>")
vim.keymap.set("n", "gh", vim.lsp.buf.hover)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help)
vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder)
vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder)
vim.keymap.set("n", "<space>wl", function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end)
-- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)
vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>")
vim.keymap.set("n", "gR", vim.lsp.buf.rename)
vim.keymap.set("n", "ga", vim.lsp.buf.code_action)
-- vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references theme=ivy<cr>")
vim.keymap.set("n", "gf", vim.lsp.buf.formatting)

vim.keymap.set("n", "X", "<cmd>lua vim.diagnostic.open_float(nil, { focus = false })<cr>")
vim.keymap.set("n", "gx", "<cmd>Trouble document_diagnostics<cr>")
