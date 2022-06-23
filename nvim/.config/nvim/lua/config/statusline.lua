-- one statusline to rule them all
-- vim.opt.laststatus = 3

-- vim.opt.statusline = '%#Pmenu#    %m %r %w %= %< %{FugitiveHead()} |  Ln %l, Col %c  %{&fileencoding?&fileencoding:&encoding}  '
--
-- %<                                             trim from here
-- %{fugitive#head()}                             name of the current branch (needs fugitive.vim)
-- %f                                             path+filename
-- %m                                             check modifi{ed,able}
-- %r                                             check readonly
-- %w                                             check preview window
-- %=                                             left/right separator
-- %l/%L,%c                                       rownumber/total,colnumber
-- %{&fileencoding?&fileencoding:&encoding}       file encoding

local function getfilename()
	if vim.api.nvim_win_get_width(0) < 100 then
		return " %<%t "
	end
	return " %<%f "
end

local function getBranch()
	if vim.api.nvim_win_get_width(0) < 160 then
		return ""
	end
	return " %{FugitiveHead()} "
end

Statusline = {}

Statusline.active = function()
	return table.concat({
		"%#PmenuSel# ",
		" ",
		getfilename(),
		"%m",
		"%#Normal#",
		"%=",
		getBranch(),
	})
end

function Statusline.inactive()
	return table.concat({
		"%#Normal# ",
		" ",
		getfilename(),
	})
end

vim.api.nvim_exec(
	[[
	augroup Statusline
	au!
	au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
	au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
	augroup END
]],
	false
)
