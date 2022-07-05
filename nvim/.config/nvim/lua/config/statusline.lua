local function getfilename()
  if vim.api.nvim_win_get_width(0) < 100 then
    return " %<%t "
  end
  return " %<%f "
end

local function getBranch()
  local signs = vim.b.gitsigns_status_dict or { head = "", added = 0, changed = 0, removed = 0 }

  if vim.api.nvim_win_get_width(0) < 160 then
    return ""
  end
  return string.format(" +%s ~%s -%s |  %s ", signs.added, signs.changed, signs.removed, signs.head)
end

Statusline = {}

Statusline.active = function()
  return table.concat({
    "%#Pmenu# ",
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
]] ,
  false
)
